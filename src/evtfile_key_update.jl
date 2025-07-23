function evtfile_status_tform_16x_1i(evtfile::String)
    f=fits_open_file(evtfile,1)
    fits_movabs_hdu(f,2)
   # nrows = fits_get_num_cols(f)
   # status = Array{UInt16}(undef, nrows)
   # fits_read_col(f,10,1,1,status)
   # status_new = convert.(Int16, status)
    fits_update_key(f, "TFORM10", "1I")
    fits_movabs_hdu(f,4)
    fits_update_key(f, "TFORM5", "1I")
 #   fits_write_col(f,10,1,1,status_new)
    fits_close_file(f)
end


function evtfile_status_tform_1i_16x(evtfile::String)
    f=fits_open_file(evtfile,1)
    fits_movabs_hdu(f,2)
  #  nrows = fits_get_num_cols(f)
   # status = Array{Int16}(undef, nrows)
 #   fits_read_col(f,10,1,1,status)
  #  status_new = convert.(UInt16, status)
    fits_update_key(f, "TFORM10", "16X")
    fits_movabs_hdu(f,4)
    fits_update_key(f, "TFORM5", "16X")

  #   fits_write_col(f,10,1,1,status_new)
    fits_close_file(f)
end