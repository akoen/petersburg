import numpy as np

def setup():
    plt.rc('font',**{'family':'serif','serif':['PragmataPro Mono']})
    np.random.seed(0)

def toss(n, N):
    """Simulate a St. Petersburg game starting at turn n and ending after turn N."""
    if np.random.rand() > 1/2:
        return 2**n
    elif n > N:
        return 0
    else:
        return toss(n+1,N)
