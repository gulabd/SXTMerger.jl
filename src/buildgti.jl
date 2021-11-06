function buildgti(t)
    n=length(t)
    tstart =Float64[]
    tstop = Float64[]
    push!(tstart,t[1] - 1.1886703073978424)
    for i=1:n-1
        if (t[i+1] - t[i]) > 2.4
            push!(tstop,t[i] + 1.1886703073978424)
            println(t[i+1] - t[i])
            push!(tstart,t[i+1] - 1.1886703073978424)
        end
    end
    return tstart[1:end-1],  tstop
end
