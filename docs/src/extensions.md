# [`ExtendableFEMBase`](https://github.com/chmerdon/ExtendableFEMBase.jl/) Extension

The extension for [`ExtendableFEMBase`](https://github.com/chmerdon/ExtendableFEMBase.jl/) extends the functions below for solution types of [`ExtendableFEM`](https://github.com/chmerdon/ExtendableFEM.jl/).
The name of the extension originates from the solution type `FEVectorBlock` that is defined in `ExtendableFEMBase`.

```@docs
edgevelocities(grid::ExtendableGrid, vel::FEVectorBlock; kwargs...)
bfacevelocities(grid::ExtendableGrid, vel::FEVectorBlock; kwargs...)
```
