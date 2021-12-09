# %%
using Plots
using DelimitedFiles
include("../util.jl")
# %%

d = readdlm("data/lotto.csv", ',', Float64)
plot(d, xscale=:log10)
xlabel!("Winnings")
