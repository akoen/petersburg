# %% Let everyone in the world play the St. Petersburg game
using Distributions
using DelimitedFiles
include("../util.jl")
# %%
# TODO Cache

g = Geometric(0.5)

population = Int(7.9e9)

function computeWinnings(N)
    winnings = zeros(Int, round(Int, log2(N)+5))
    for _ in 1:N
        w = rand(g)+1
        winnings[w] += 1
    end
    return winnings
end

@time winnings = computeWinnings(population)



# %%
writedlm("../../data/world.csv", winnings)
write(ARGS[1], table)

# %% Write to table
function commas(num::Integer)
    str = string(num)
    return replace(str, r"(?<=[0-9])(?=(?:[0-9]{3})+(?![0-9]))" => ",")
end

data = readdlm("../../data/world.csv") |> vec .|> x -> round(x, sigdigits=3) .|> Int64 .|> commas
payout = 1:length(data) .|> x -> 2^x .|> x -> round(x, sigdigits=3) .|> Int64 .|> commas
# %%
table = mat2latex([payout[1:34] data[1:34]])
write("../../tex/world.tex", table)
# %%
