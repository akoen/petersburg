using Gadfly
using Compose
using Distributions
import Cairo, Fontconfig
using DataFrames

# %%
g = Geometric(1/2)

# %%
x_min = [0 1/2 3/4 7/8 15/16]
x_max = [1/2 3/4 7/8 15/16 31/32]
y = [2 4 8 16 32]

label = ["H" "TH" "TTH" "..."]
text_x = [1/4 5/8 13/16 29/32]

tick_labels=Dict(zip(x_min, ["0" "1/2" "1/4" "1/8" "1/16"]))

theme = Theme(major_label_font="PragmataPro Mono",
              minor_label_font="PragmataPro Mono",
              key_title_font="PragmataPro Mono Bold",
              highlight_width=0.005w,
              bar_highlight=color("black"))
Gadfly.push_theme(theme)

p = plot(
    x_min=x_min,
    x_max=x_max,
    y=y,
    Geom.bar,
    Coord.cartesian(ymax=20),
    Guide.xticks(ticks=x_min),
    Guide.yticks(ticks=y),
    Scale.x_continuous(labels = x -> tick_labels[x]),
    Guide.xlabel("PROBABILITY"),
    Guide.ylabel("PAYOUT"),
    Guide.title("<b>Distribution of Payouts</b>"),
    Guide.annotation(compose(
        context(),
        text(text_x, ones(5), label, repeat([hcenter], 4), repeat([vcenter], 4)),
        # font("PragmataPro Mono"),
        fontsize(8pt),
        stroke("black"))))
# %%
draw(PDF("../../figures/distribution.pdf"), p)
