using FITSIO, DataFrames, FITSIO

function sxtevtlist2df(hdu::TableHDU)
#    f=FITS(evtfile)
    ti=read(hdu,"TIME")
    ccdframe = read(hdu, "CCDFrame")
        x= read(hdu, "X")
        y= read(hdu, "Y")
        rawx= read(hdu, "RAWX")
        rawy= read(hdu, "RAWY")
        detx= read(hdu, "DETX")
        dety= read(hdu, "DETY")
        phas= read(hdu, "PHAS")
        stts= read(hdu, "STATUS")
        pha= read(hdu, "PHA")
        grade= read(hdu, "GRADE")
        pixsabove= read(hdu, "PixsAbove")
        pi_channel= read(hdu, "PI")
        ra= read(hdu, "RA")
        decl= read(hdu, "Dec")
        phaso= read(hdu, "PHASO")
        evtdf=DataFrame(TIME=ti,CCDFrame=ccdframe, X=x,Y=y,RAWX=rawx,RAWY=rawy,DETX=detx,DETY=dety,PHAS1=phas[1,:],PHAS2=phas[2,:],PHAS3=phas[3,:],PHAS4=phas[4,:],PHAS5=phas[5,:],PHAS6=phas[6,:],PHAS7=phas[7,:],PHAS8=phas[8,:],PHAS9=phas[9,:],STATUS=stts,PHA=pha,GRADE=grade,PixsAbove=pixsabove,PI=pi_channel,RA=ra,Dec=decl,PHASO1=phaso[1,:],PHASO2=phaso[2,:],PHASO3=phaso[3,:],PHASO4=phaso[4,:],PHASO5=phaso[5,:],PHASO6=phaso[6,:],PHASO7=phaso[7,:],PHASO8=phaso[8,:],PHASO9=phaso[9,:])
    return evtdf
end

function sxtbadpixlist2df(hdu::TableHDU)
#    f=FITS(evtfile)
        rawx= read(hdu, "RAWX")
        rawy= read(hdu, "RAWY")
        typ= read(hdu, "TYPE")
        yextnt= read(hdu, "YEXTENT")
        badflag= read(hdu, "BADFLAG")
        badpixdf=DataFrame(RAWX=rawx,RAWY=rawy,TYPE=typ,YEXTENT=yextnt,BADFLAG=badflag)
    return badpixdf
end
