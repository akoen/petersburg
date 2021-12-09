import sys
import matplotlib.pyplot as plt
from matplotlib.collections import LineCollection
import numpy as np

import util

def plot(figpath):

    num_players = int(100)
    num_turns = int(1e2)
    t = range(num_turns)
    m = []
    for i in range(num_players):
        won = [0]
        for j in range(1,num_turns):
            won.append(won[j-1]+util.toss(1,np.infty)-100)
            m.append(won)

    N = 100

    lines = LineCollection([np.column_stack([t,p]) for p in m], color='#333333', alpha=0.5)

    fig,ax = plt.subplots()
    # fig.set_size_inches(120,60)
    ax.grid(False)
    ax.set_xlim(0,num_turns)
    ax.set_yscale("log")
    ax.set_ylim(1e-1,1e6)
    ax.add_collection(lines)

    ax.set_xlabel("Games played")
    ax.set_ylabel("Total winnings")

if __name__ == "__main__":
    _, figpath = sys.argv
    plot(figpath)
