using FITSIO, CFITSIO, DataFrames

function fits_binary_table2df(fitsfile::String, extnumber::Int64)

# Get the number of colums, names and type of columns
    ff = FITS(fitsfile)
    colname = FITSIO.columns_names_tforms(ff[2])[1]
    coltype = FITSIO.columns_names_tforms(ff[2])[2]
    close(ff)

    f=CFITSIO.fits_open_file(fitsfile,0)
    CFITSIO.fits_movabs_hdu(f,extnumber)
    ncols = CFITSIO.fits_get_num_cols(f)
    nrows = CFITSIO.fits_get_num_rows(f)

    # Read colums
    # Define column data variables

    for i in 1:ncols
        if coltype[i] == "D"
           @eval $(Symbol("col$i")) = Array{Float64}(undef, nrows)
        elseif coltype[i] == "1D"
           @eval $(Symbol("col$i"))  = Array{Float64}(undef, nrows)
        elseif coltype[i] == "1J"
            @eval $(Symbol("col$i"))  = Array{Int64}(undef, nrows)
        elseif coltype[i] == "1I"
            @eval $(Symbol("col$i"))  = Array{Int16}(undef, nrows)

        elseif coltype[i] == "9I"
            @eval $(Symbol("col$i")) =  Array{NTuple{9, Int16}}(undef, nrows)

        elseif coltype[i] == "16X"
            @eval $(Symbol("col$i")) = Array{UInt16}(undef, nrows)
        
        elseif coltype[i] == "1K"
            @eval $(Symbol("col$i")) = Array{Int64}(undef, nrows)
        else coltype[i] == "1B"
            @eval $(Symbol("col$i")) = Array{UInt8}(undef, nrows)
        end
    end

    for i=1:ncols
        CFITSIO.fits_read_col(f,i, 1, 1, @eval $(Symbol("col$i")))
        return @eval $(Symbol("col$i"))
    end
CFITSIO.fits_close_file(f)
end

