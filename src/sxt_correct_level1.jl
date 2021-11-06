function sxt_correct_level1(level1dir::String)

  cd(level1dir * "/sxt")
  l1orbitdatadir = readdir("./")
  print(l1orbitdatadir)
  print("\n\n")
  for i=1:length(l1orbitdatadir)
    cd(l1orbitdatadir[i] * "/aux/aux2")
      lbtfiles = filter(x -> endswith(x,".lbt"), readdir("./"))
      for j=1:length(lbtfiles)
        print("Orbit ")
        print(l1orbitdatadir[i])
        print(": ")
        sxt_correct_level1lbt(lbtfiles[j])
      end
      cd("../../..")
    end
    cd("../..")
    return
  end
