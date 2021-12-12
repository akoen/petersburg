# %% Plot distribution of payouts when the global population plays a round of
# the game
using DelimitedFiles
using Gadfly
import Cairo, Fontconfig
using DataFrames
using Printf
using Compose
# %%
data = vec(readdlm("../../data/world.csv"))
# %%
df_wide = DataFrame(x=1:length(data), d=data, l=log2.(data))
df = stack(df_wide, [:d, :l])

# %%
theme = Theme(major_label_font="PragmataPro Mono",
              minor_label_font="PragmataPro Mono",
              key_title_font="PragmataPro Mono Bold",
              highlight_width=0.0025w,
              bar_highlight=color("black"))
Gadfly.push_theme(theme)

ylabs = Dict("d"=>"Linear", "l"=>"log₂")
p = plot(df,
         x=:x,
         y=:value,
         ygroup=:variable,
         Geom.subplot_grid(Geom.bar,
                           free_y_axis=true),
         Guide.xlabel("PAYOUT"),
         Guide.ylabel("NUMBER OF PEOPLE"),
         Guide.title("<b>World Population Simulation Payouts</b>"),
         Scale.ygroup(labels=i->ylabs[i]),
         Scale.x_continuous(labels = x -> @sprintf("2<sup>%d</sup>",x)),
         )
draw(PDF("../../figures/world.pdf"), p)
# %%
