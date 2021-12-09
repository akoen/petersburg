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

table = mat2latex([1:length(winnings) winnings])


# %%
writedlm("world.csv", winnings)
write(ARGS[1], table)
# %%
