using DataFrames

function df2dic(df::DataFrame)
  ncolumn = ncol(df)
  colnames = names(df)
  key = Vector{String}(undef, 0)
  val = Vector(undef, 0)
  for i=1:ncolumn
  push!(key, string(names(evtdf)[i]))
  push!(val,evtdf[i])
  end
  dic=Dict(zip(key,val))
  return dic
  end
  



