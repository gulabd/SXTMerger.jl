
using DataFrames, FITSIO, FITSIO.Libcfitsio

"""
    sxt_l2evtlist_merge(l2evtfilelist, merged_evtfile)

Merge the level2 orbit-wise event files in FITS format from the AstroSat/SXT instrument.

...
# Arguments
- `l2evtfilelist::String`: An ascii file listing the level2 event files for different orbits of a given SXT observation.
- `merged_evtfile::String`: Name of the merged event file to be created.
...
"""
function sxt_l2evtlist_merge(l2evtfilelist::String, merged_evtfile::String)
   evtfiles = readlines(l2evtfilelist)
   # Read fits event files
   f=Array{FITS}(undef, length(evtfiles))
   for i=1:length(evtfiles)
     f[i]=FITS(evtfiles[i], "r+")
     write_key(f[i][2],"TFORM10","1I")
     write_key(f[i][4],"TFORM5","1I")
     close(f[i])
   end
   f=FITS.(evtfiles, "r+")
   evtlist=Array{TableHDU}(undef, length(evtfiles))
   badpixlist=Array{TableHDU}(undef,length(evtfiles))
   gtilist=Array{TableHDU}(undef,length(evtfiles))
   evt_df=Array{DataFrame}(undef, length(evtfiles))
   badpix_df=Array{DataFrame}(undef, length(evtfiles))
   gti_df=Array{DataFrame}(undef, length(evtfiles))
   for i=1:length(f)
     evtlist[i]=f[i][2]
     gtilist[i]=f[i][3]
     badpixlist[i]=f[i][4]
     evt_df[i]=sxtevtlist2df(evtlist[i])
     badpix_df[i]=sxtbadpixlist2df(badpixlist[i])
     gti_df[i]=gti2df(gtilist[i])
     write_key(f[i][2],"TFORM10","16X")
     write_key(f[i][4],"TFORM5","16X")
    # close(f)
   end
   close.(f)
   # Merge event lists and badpixel lists
   evtlist_merged=vcat(evt_df...)
   gtilist_merged = vcat(gti_df...)
   gtilist_unique = gti_unique_or(gtilist_merged)
   badpixlist_merged=vcat(badpix_df...)
   # Retain only unique events or badpixels
   # sort!(evtlist_merged, [:TIME, :RAWX, :RAWY])
   sort!(evtlist_merged, :TIME)
   # unique!(evtlist_merged, [:CCDFrame,:RAWX, :RAWY])
   unique!(evtlist_merged, [:CCDFrame,:RAWX, :RAWY, :PHAS1, :PHAS2, :PHAS3, :PHAS4,:PHAS5, :PHAS6, :PHAS7, :PHAS8,:PHAS9])
   sort!(badpixlist_merged, [:RAWX, :RAWY])
   unique!(badpixlist_merged)

   # Convert dataframes to vectors to be able to write to fits files
   (evtlist_col_names, evtlist_col_vals) = sxtevt_df2vec(evtlist_merged)
   (badpix_col_names,badpix_col_vals) = sxtbadpix_df2vec(badpixlist_merged)
   (gti_start, gti_stop) = (gtilist_unique[:,:START], gtilist_unique[:,:STOP])
   exposure_sec = sum(gti_stop .- gti_start)

   # Create GTIs
   # evttimes = evtlist_merged[:TIME]
   # (gti_start,gti_stop) = buildgti(evttimes)
   # exptime_sec=sum(gti_stop .- gti_start)



   gti_col_names=["START","STOP"]
   gti_col_vals=[gti_start,gti_stop]

   # Read headers from the first evtfile
   # ff=FITS(evtfiles[1])
   # primary_hdr=read_header(ff[1])
   # evt_hdr=read_header(ff[2])
   # gti_hdr=read_header(ff[3])
   # badpix_header=read_header(ff[4])
   # close(ff)
   #
   # # Update header keywords for merged eventfile
   # evt_hdr["EXPOSURE"]=exptime_sec
   # evt_hdr["ONTIME"]=exptime_sec
   # evt_hdr["LIVETIME"]=exptime_sec


   # Write the merged event file



  ff=fits_create_file(merged_evtfile)
  evtlist_coldef=[("TIME", "1D", "seconds"),("CCDFrame", "1J", " "),("X", "1I", "pixel"),("Y", "1I", "pixel"),("RAWX", "1I", "pixel"),("RAWY", "1I", "pixel"),("DETX", "1I", "pixel"),("DETY", "1I", "pixel"),("PHAS", "9I", "channel"),("STATUS", "16X", " "), ("PHA", "1J", " "), ("GRADE", "1I", " "),  ("PixsAbove", "1I", " "), ("PI", "1J", "channel"), ("RA", "D", " "),("Dec", "D", " "), ("PHASO", "9I", " ")]
  fits_create_binary_tbl(ff,0,evtlist_coldef,"EVENTS")
  for i=1:length(evtlist_col_names)
    fits_write_col(ff,i,1,1,evtlist_col_vals[i])
  end

  gti_coldef=[("START", "1D", "s"),("STOP", "1D", "s")]
  fits_create_binary_tbl(ff,0,gti_coldef,"STDGTI")
  for i=1:length(gti_col_names)
    fits_write_col(ff,i,1,1,gti_col_vals[i])
  end

  badpix_coldef=[("RAWX", "1I", " "),("RAWY", "1I"," "),("TYPE", "1I", " "),("YEXTENT", "1I"," "), ("BADFLAG", "16I", " ")]
  fits_create_binary_tbl(ff,0,badpix_coldef,"BADPIX ")
  for i=1:length(badpix_col_names)
    fits_write_col(ff,i,1,1,badpix_col_vals[i])
  end
fits_close_file(ff)

# Determine start-stop keywords from the list of event files
  ef = Array{FITS}(undef, length(evtfiles))
  ef_evtheader = Array{FITSHeader}(undef, length(evtfiles))
  ef = FITS.(evtfiles, "r")
  for n=1:length(ef)
     ef_evtheader[n] = read_header(ef[n][2])
     close(ef[n])
   end

   # Determine keyword values
   tstart = Array{Float64}(undef,length(evtfiles))
   tstop = Array{Float64}(undef,length(evtfiles))
   date_obs = Array{String}(undef,length(evtfiles))
   date_end = Array{String}(undef,length(evtfiles))
   time_obs = Array{String}(undef,length(evtfiles))
   time_end = Array{String}(undef,length(evtfiles))
   mjd_obs = Array{Float64}(undef,length(evtfiles))
  for i=1:length(evtfiles)
    tstart[i] = ef_evtheader[i]["TSTART"]
    tstop[i] = ef_evtheader[i]["TSTOP"]
    date_obs[i] = ef_evtheader[i]["DATE-OBS"]
    date_end[i] = ef_evtheader[i]["DATE-END"]
    time_obs[i] = ef_evtheader[i]["TIME-OBS"]
    time_end[i] = ef_evtheader[i]["TIME-END"]
    mjd_obs[i] = ef_evtheader[i]["MJD-OBS"]
  end
  tstart_merged = minimum(tstart)
  tstop_merged = maximum(tstop)
  mjd_obs_merged = minimum(mjd_obs)
  telapse_merged = tstop_merged - tstart_merged
  date_obs_merged = date_obs[findall(x ->x==tstart_merged, tstart)][1]
  date_end_merged = date_end[findall(x ->x==tstop_merged, tstop)][1]
  time_obs_merged = time_obs[findall(x ->x==tstart_merged, tstart)][1]
  time_end_merged = time_end[findall(x ->x==tstop_merged, tstop)][1]



  # Write header keywords from the first eventfile
  ef1=FITS(readlines(l2evtfilelist)[1])
  mef=FITS(merged_evtfile,"r+")
  # ef1h1=read_header(ef1[1])
  # ef1h2=read_header(ef1[2])
  # ef1h3=read_header(ef1[3])
  # ef1h4=read_header(ef1[4])
  ef1_header=[read_header(ef1[i]) for i=1:4]
  for i=1:4
    for j=1:length(ef1_header[i].keys)
      if ef1_header[i].keys[j] in ["SIMPLE", "BITPIX", "NAXIS", "EXTEND", "NAXIS1", "NAXIS2", "PCOUNT", "GCOUNT", "TFIELDS", "XTENSION", "BITPIX", "TFORM1", "TFORM2", "TFORM3", "TFORM4", "TFORM5", "TFORM6", "TFORM7", "TFORM8",  "TFORM9", "TFORM10", "TFORM11", "TFORM12", "TFORM13", "TFORM14","TFORM15", "TFORM16", "TFORM17", "TOTAL2K", "ERROR2K", "FILIN001", "EXPOSURE"]
#        println(ef1_header[i].keys[j] * "Not updated")
      else
        write_key(mef[i],ef1_header[i].keys[j],ef1_header[i].values[j],ef1_header[i].comments[j])
#        println(ef1_header[i].keys[j] * " updated.")
      end
      write_key(mef[i],"EXPOSURE",exposure_sec,"Exposure time")
      write_key(mef[i],"LIVETIME",exposure_sec,"On source time")
      write_key(mef[i],"ONTIME",exposure_sec,"On source time")
      write_key(mef[i], "TSTART",tstart_merged,"time start")
      write_key(mef[i], "TSTOP",tstop_merged ,"time stop")
      write_key(mef[i], "DATE-OBS",date_obs_merged,"start date of observation")
      write_key(mef[i], "DATE-END",date_end_merged,"end date of observation")
      write_key(mef[i], "TIME-OBS",time_obs_merged,"start time of observation")
      write_key(mef[i], "TIME-END",time_end_merged,"end time of observation")
      write_key(mef[i], "TELAPSE", telapse_merged, "Total elapsed time")
      write_key(mef[i], "MJD-OBS", mjd_obs_merged, "MJD of observation start")
  end
end
close(ef1)
close(mef)
println("Merged event file: "  * merged_evtfile * " successfully written!")
return 1
end
