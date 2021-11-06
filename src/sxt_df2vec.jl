using DataFrames

function sxtevt_df2vec(df::DataFrame)
    ti=df[:,:TIME]
    ccdframe = df[!,:CCDFrame]
    x= df[:,:X]
    y=df[:,:Y]
    rawx= df[:,:RAWX]
    rawy= df[:,:RAWY]
    detx= df[:,:DETX]
    dety= df[:,:DETY]
    phas= [df[:,:PHAS1] df[:,:PHAS2] df[:,:PHAS3] df[:,:PHAS4] df[:,:PHAS5] df[:,:PHAS6] df[:,:PHAS7] df[:,:PHAS8] df[:,:PHAS9]]
    stts= df[:,:STATUS]
    pha= df[:,:PHA]
    grade= df[:,:GRADE]
    pixsabove= df[:,:PixsAbove]
    pi_channel= df[:,:PI]
    ra= df[:,:RA]
    decl= df[:,:Dec]
    phaso= [df[:,:PHASO1] df[:,:PHASO2] df[:,:PHASO3] df[:,:PHASO4] df[:,:PHASO5] df[:,:PHASO6] df[:,:PHASO7] df[:,:PHASO8] df[:,:PHASO9]]
    evt_col_names=["TIME", "CCDFrame", "X", "Y", "RAWX", "RAWY", "DETX", "DETY", "PHAS", "STATUS","PHA", "GRADE","PixsAbove", "PI", "RA","Dec", "PHASO"]
    evt_col_vals=[ti,ccdframe, x,y,rawx,rawy,detx,dety,phas,stts,pha,grade,pixsabove, pi_channel,ra,decl,phaso]
    return evt_col_names, evt_col_vals
    end


    function sxtbadpix_df2vec(df::DataFrame)
        rawx= df[:,:RAWX]
        rawy= df[:,:RAWY]
        typ= df[:,:TYPE]
        yextnt= df[:,:YEXTENT]
        badflag= df[:,:BADFLAG]
        badpix_col_names=["RAWX","RAWY","TYPE","YEXTENT","BADFLAG"]
        badpix_col_vals=[rawx,rawy,typ,yextnt,badflag]
        return badpix_col_names, badpix_col_vals
    end

    function gti_df2vec(df::DataFrame)
        gti_start=df[:,:START]
        gti_stop=df[:,:STOP]
        return gti_start, gti_stop
    end
