# %% Simulate progression of wealth over many rounds with different fees
# using CairoMakie
using Distributions
using DataFrames
using Gadfly
import Cairo, Fontconfig
using Printf

# %% Functions
g = Geometric(0.5)
toss() = rand(g)+1

function symlog(x)
    return sign(x)*log10(abs(x)+1)
end

function calcWinnings(N::Int,P::Int, F::Float64=log2(N)+2)
    winnings = zeros(Float64, N, P)
    for p in 1:P
        for i in 2:N
            winnings[i,p] = winnings[i-1,p] + 2^toss() - F
        end
    end
    return winnings
end

# %% Figure setup
theme = Theme(major_label_font="PragmataPro Mono",
              minor_label_font="PragmataPro Mono",
              key_title_font="PragmataPro Mono Bold",
              key_position=:none)
Gadfly.push_theme(theme)

nbins = 1000

function plotWinnings(winnings, fee)
    fig = plot(
        winnings,
        x=Row.index,
        y=Col.value,
        Geom.hexbin(xbincount=nbins, ybincount=nbins),
        Guide.xlabel("ROUNDS"),
        Guide.ylabel("CUMULATIVE PAYOUT (SYMLOG)"),
        Guide.xticks(ticks=[0 2500 5000 7500 10000]),
        Guide.yticks(label=false),
        Guide.title(@sprintf("<b>Fee Per Round = %s</b>", fee)),
        Coord.cartesian(xmin=0, xmax=1e4, ymin=-8, ymax=8))
    return fig
end

# %% Plot figures
wN = calcWinnings(Int(1e4), Int(1e3)) .|> symlog
draw(PDF("../../figures/winnings-N.pdf"), plotWinnings(wN, "log2(10000)+2"))

# %%
df2_wide = DataFrame(w2, :auto)
cols = names(df2_wide)
df2_wide.x = 1:(size(df2_wide)[1])
df2_wide.f .= "P=\$2"
df2 = stack(df2_wide, cols)


df100_wide = DataFrame(w100, :auto)
cols = names(df100_wide)
df100_wide.x = 1:(size(df100_wide)[1])
df100_wide.f .= "P=\$100"
df100 = stack(df100_wide, cols)

df = vcat(df2, df100)

# %%
p = plot(df,
         x=:x,
         y=:value,
         ygroup=:f,
         Geom.subplot_grid(Geom.hexbin(xbincount=nbins, ybincount=nbins),
                           Coord.cartesian(xmin=0, xmax=1e4, ymin=-8, ymax=8),
                           # Guide.yticks(ticks=nothing), Does not work :(
                           Guide.xticks(ticks=[0 2500 5000 7500 10000]),
                           ),
         Guide.xlabel("ROUNDS"),
         Guide.ylabel("CUMULATIVE PAYOUT (SYMLOG)"),
         Guide.title("<b>Distribution of Payouts over Time</b>"))


draw(PDF("../../figures/winnings-2-100.pdf"), p)
# %%

Guide.yticks
