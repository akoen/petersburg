# %%
# using CairoMakie
using Distributions
using Gadfly
import Cairo, Fontconfig
# %%
function symlog(x,n=-3)
    return sign(x)*(log10(1+abs(x))/10.0^n)
end

function altlog(x)
    return sign(x)*log10(abs(x)+1)
end

# %%

g = Geometric(0.5)
toss() = rand(g)+1

function calcWinnings(N::Int,P::Int, F::Float64=log2(N)+2)
    winnings = zeros(Float64, N, P)
    for p in 1:P
        for i in 2:N
            winnings[i,p] = winnings[i-1,p] + 2^toss() - F
        end
    end
    return winnings
end

# %%
winnings = calcWinnings(Int(1e4), Int(1e3), 100.0)
# winnings[winnings .> 2e4] .= 3e4
# winnings[winnings .< -2e4] .= -3e4

# p = plot(winnings, x=Row.index, y=Col.value, Geom.line, style(line_width=0.1mm, default_color = RGBA(.1,.1,.9,0.2)))
# display(p)


# p = plot(symlog.(winnings), x=Row.index, y=Col.value, Geom.hexbin)
nbins = 100
p = plot(
    # winnings,
    winnings .|> altlog,
    # (winnings.+1) .|> log10,
    x=Row.index,
    y=Col.value,
    Geom.hexbin(xbincount=nbins, ybincount=nbins),
    Theme(background_color="white"),
    Coord.cartesian(xmin=0, xmax=1e4)
    # Coord.cartesian(xmin=0, xmax=1e4, ymin=-2e4, ymax=2e4)
)

draw(PNG("/tmp/fig.png", 6inch, 3inch, dpi=300),p)
# %%

# %%
# f = Figure()
# Axis(f[1, 1], yscale=Makie.pseudolog10)

# @time series!(winnings, linewidth=0.05, solid_color=:black)

# # lines!.(1:N, winnings, color = (:red, 0.04))
# save("/tmp/fig.png", f.scene)
# %%
# Plots.PyPlotBackend()
# @time p = Plots.plot(winnings, yscale=:log, color=:black, alpha=0.025)
# @time save("/tmp/fig2.png", p)
