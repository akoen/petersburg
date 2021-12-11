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
        winnings .|> symlog,
        x=Row.index,
        y=Col.value,
        Geom.hexbin(xbincount=nbins, ybincount=nbins),
        Guide.xlabel("ROUNDS"),
        Guide.ylabel("CUMULATIVE GAIN/LOSS (SYMLOG)"),
        Guide.xticks(ticks=[0 2500 5000 7500 10000]),
        Guide.yticks(label=false),
        Guide.title(@sprintf("<b>Fee Per Round = %s</b>", fee)),
        Coord.cartesian(xmin=0, xmax=1e4, ymin=-8, ymax=8))
    return fig
end

# %% Plot figures
w2 = calcWinnings(Int(1e4), Int(1e3), 2.0)
w100 = calcWinnings(Int(1e4), Int(1e3), 100.0)
wN = calcWinnings(Int(1e4), Int(1e3))
# draw(PNG("winnings-100.png", 12inch, 8inch, dpi=300), plotWinnings(w100, "100"))
# draw(PNG("winnings-2.png", 12inch, 8inch, dpi=300), plotWinnings(w2, "2"))
# draw(PNG("winnings-N.png", 12inch, 8inch, dpi=300), plotWinnings(wN, ""))
draw(PDF("../../figures/winnings-100.pdf"), plotWinnings(w100, "\$100"))
draw(PDF("../../figures/winnings-2.pdf"), plotWinnings(w2, "\$2"))
draw(PDF("../../figures/winnings-N.pdf"), plotWinnings(wN, "log2(10000)+2"))

# %%
w2 = calcWinnings(Int(1e2), Int(1e1), 2.0)
df2 = stack(DataFrame(w2, :auto))
df2[:, :fee] .= 2
w100 = calcWinnings(Int(1e2), Int(1e1), 100.0)
df100 = stack(DataFrame(w100, :auto))
df100[:, :fee] .= 100
df = vcat(df2,df100)
fig = plot(
    df,
    x=Row.index,
    y=Col.value,
    Geom.subplot_grid(Geom.hexbin)
    ygroup=:fee,
)
draw(PDF("tmp.pdf"), fig)
# %%
N=50000
df1 = DataFrame(
  x1 = rand(Normal(1,3), N),
  x2 = [sample(["High", "Medium", "Low"],
              pweights([0.25,0.45,0.30])) for i=1:N],
    x3 = rand(Normal(2, 6), N
              )
 )

p2 = plot(df1,
    ygroup =:x2,  x=:x1,  y=:x3,
    Scale.color_continuous(colormap=Scale.lab_gradient("blue", "white", "orange")),
    Geom.subplot_grid(Geom.hexbin)
)
display(p2)
# %%
