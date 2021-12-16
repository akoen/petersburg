# %% Plot average winnings over time
# using Distributions
# using DataFrames
using Gadfly
using Colors
import Cairo, Fontconfig
using Printf
# %%

# Returns the value of the steinhaus sequence at position n (1-indexed).
function steinhaus(n)
    d = 1
    while (n % 2 == 0)
        d += 1
        n /= 2
    end
    return 2^d
end

# %%
theme = Theme(major_label_font="PragmataPro Mono",
              minor_label_font="PragmataPro Mono",
              key_title_font="PragmataPro Mono Bold")
Gadfly.push_theme(theme)

x = 1:150

m = layer(x=x,
          y=cumsum(steinhaus.(x)) ./ (1:length(x)),
          Geom.step,
          Theme(default_color=RGBA(0,0,0,0.8)))

f = layer(x=x,
          y=log2.(x).+2,
          Geom.line)

p = plot(f,m,
         Guide.manual_color_key("", ["Cumulative mean", "log<sub>2</sub>n+2"], [RGBA(0,0,0,0.8), "deepskyblue"]),
         Guide.xlabel("n"),
         Guide.ylabel(nothing),
         Guide.xticks(ticks=0:16:length(x)),
         Guide.yticks(ticks=2:9),
         Coord.cartesian(ymin=2,ymax=9.2),
         Guide.title("<b>Expected Value of Steinhaus Sequence Over <i>n</i> Rounds</b>"))


push!(p,l)

draw(PDF("../../figures/steinhaus.pdf"), p)
# %%
