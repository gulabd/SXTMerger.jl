using FITSIO, FITSIO.Libcfitsio

function sxt_correct_level1lbt(lbtfile::String)
    f=fits_open_file(lbtfile,1)
    fits_movabs_hdu(f,2)
    colnum_ccdtemp1 = fits_get_colnum(f,"CCD_Temp_1")
    colnum_ccdtemp2 = fits_get_colnum(f,"CCD_Temp_2")
    nrows = fits_get_num_rows(f)
    ccdtemp1 = Array{Float32}(undef,nrows)
    ccdtemp2 = Array{Float32}(undef,nrows)
    fits_read_col(f,colnum_ccdtemp1,1,1,ccdtemp1)
    fits_read_col(f,colnum_ccdtemp2,1,1,ccdtemp2)
    if (maximum(ccdtemp1) - minimum(ccdtemp1) > maximum(ccdtemp2) - minimum(ccdtemp2))
        cp(lbtfile, lbtfile * ".orig"; force=true)
        fits_update_key(f,"TTYPE24","CCD_Temp_2")
        fits_update_key(f,"TTYPE25","CCD_Temp_1")
        print("CCD_Temp_1 range  greater than CCD_Temp_2 range. CCD_Temp_1 updated.\n")
    else
        print("CCD_Temp_1 range  less or equal to CCD_Temp_2 range. CCD_Temp_1 not changed.\n")
    end
    fits_close_file(f)
    return
end
