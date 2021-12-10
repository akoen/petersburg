# %% Plot average winnings over time
using Distributions
using DataFrames
using Gadfly
using Colors
import Cairo, Fontconfig
using Printf
# %%
g = Geometric(0.5)

toss() = rand(g)+1

n_games = 20

n_players = 5
winnings = zeros(n_games,n_players)
for p in 1:n_players
    for n in 1:n_games
        payout = 0
        for i in 1:2^n
            payout += 2^toss()
        end
        winnings[n,p] = payout/(2^n)
    end
end

# %%

theme = Theme(major_label_font="PragmataPro Mono",
              minor_label_font="PragmataPro Mono",
              key_title_font="PragmataPro Mono Bold")
Gadfly.push_theme(theme)

x = 1:n_games
p = plot(x=x,
         Coord.cartesian(ymax=40),
         color=[RGBA(0,0,0,0.2)],
         Scale.x_continuous(labels = x -> @sprintf("2<sup>%d</sup>",x)),
         Guide.xlabel("ROUNDS PLAYED"),
         Guide.ylabel("MEAN PAYOUT"),
         Guide.title("<b>Average Payout Per Round vs. Total Rounds Played</b>"),
         )


for n in 1:n_players
    l = layer(y=winnings[:,n],
              Geom.line)
    push!(p,l)
end

draw(PDF("../../figures/average-over-time.pdf"), p)

legend = Guide.manual_color_key("", ["log<sub>2</sub>n+2"], ["deepskyblue"])
push!(p,legend)

l = layer(y=(1:n_games).+2,
          Geom.line,
          color=[theme.default_color],
          # color=["sine"],
          style(line_width=0.5mm),
          )

push!(p,l)
draw(PDF("../../figures/average-over-time-fit.pdf"), p)
# %%
