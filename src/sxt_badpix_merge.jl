function sxt_badpix_merge(l2evtfilelist::String)
   evtfiles = readlines(l2evtfilelist)
   # Read fits event files
   f=Array{FITS}(length(evtfiles))
   for i=1:length(evtfiles)
     f[i]=FITS(evtfiles[i], "r+")
     write_key(f[i][2],"TFORM10","1I")
     write_key(f[i][4],"TFORM5","1I")
     close(f[i])
   end
   f=FITS.(evtfiles, "r+")
   badpixlist=Array{TableHDU}(length(evtfiles))
   sxt_badpix_mergedf=Array{DataFrame}(length(evtfiles))
   for i=1:length(f)
     badpixlist[i]=f[i][4]
     badpix_df[i]=sxtbadpixlist2df(badpixlist[i])
     write_key(f[i][2],"TFORM10","16X")
     write_key(f[i][4],"TFORM5","16X")
     close(f[i])
   end
   badpixlist_merged=vcat(df)
   unique!(badpixlist_merged)
   return badpixlist_merged
 end
