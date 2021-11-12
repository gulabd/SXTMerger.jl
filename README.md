# SXTMerger.jl
A tool to merge orbit-wise [AstroSat/SXT](https://www.tifr.res.in/~astrosat_sxt/index.html) event files in FITS format.

AstroSat data are downloaded every orbit. The individual datasets may containing overlapping event lists which need to be idenified, rejected and merged. The SXTMerger tool reads the level2 event lists, bad pixel lists and the Good Time Intervals (GTIs)  from the event files from different orbits, it then checks for overlapping event data, and retains only unique events and merges the event lists. It also generated a merged GTI by merging the individual GTIs after accounting for the overlapping event data. The tools writes a merged event file with appropriate extensions, fully compatible with [Xselect package](https://heasarc.gsfc.nasa.gov/docs/software/lheasoft/ftools/xselect/index.html).

## Installation

```julia
julia> using Pkg

julia> Pkg.add("SXTMerger")
```
or
```julia
julia>]

(@v1.6) pkg> add SXTMerger
```



## Usage
- First generate a file listing the level2 cleaned event files from different orbits using a SHELL command as follows.  This assumes that the data dir *level2/sxt/ is the current directory.

```shell
ls -d -1 $PWD/*/*/*cl.evt > evtfilelist
```
- Merge the event files using the command below. Ensure that the current working directory is the directory contating the "evtfilelist" file created above. One can use linux commands on julia prompt by first typing ; followed by any linux command.

```julia

julia> using SXTMerger

julia> sxt_l2evtlist_merge("evtfilelist","sxt_merged_cl.evt")
```

The merged eventlist can be used to extract images, lightcurves and spectra using [HEASOFT tool xselect](https://heasarc.gsfc.nasa.gov/docs/software/lheasoft/ftools/xselect/index.html).
