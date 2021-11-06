
function gti2df(hdu::TableHDU)
    gti_start=read(hdu,"START")
    gti_stop = read(hdu,"STOP")
    gti=DataFrame(START=gti_start,STOP=gti_stop)
    return gti
end

function gti_unique_or(gti_list::DataFrame)
# join all GTIs
    merged_gti=vcat(gti_list)
    sort!(merged_gti,[:START,:STOP])
    gti_start = merged_gti[!,:START]
    gti_stop = merged_gti[!,:STOP]
# Determine unique GTIs
    unique_gti_start=Float64[]
    unique_gti_stop=Float64[]
    push!(unique_gti_start,gti_start[1])
    for i=1:length(gti_start)-1
        if (gti_stop[i] <= gti_start[i+1])
            push!(unique_gti_stop, gti_stop[i])
            push!(unique_gti_start, gti_start[i+1])
        end
    end
    push!(unique_gti_stop, gti_stop[end])
    unique_gti_df=DataFrame(START=unique_gti_start,STOP=unique_gti_stop)
    return unique_gti_df
end
