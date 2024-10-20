# This is a code for 8.08 - 8.S421 recitation.
# You will simulate polymer in equlibrium fluid

# for installing required packages
# using Pkg
# Pkg.add("Plots")
# Pkg.add("Random")

# for plotting
using Plots
using Random

cd(@__DIR__)
include("Rec8_module.jl")

#random number generator
rng = MersenneTwister(1234)

# parameters
dt = 1e-2   # time step
N = 300     # number of monomers
k = 1       # nearest neighbor interaction strength
mu = 1      # mobility
kT = 1      # thermal energy

#set parameters
param = Rec.setParam(dt, N, k, mu, kT)

#set state
state = Rec.setState(param)

for n in 1:param.N  # initial configuration exteded along the x-axis.
    state.y[n] = 0
    state.x[n] = n-param.N/2
end

# for generating animation of your simulation
get_movie!(state, param, rng, 100, 200, 20)


# for measuring energy of your polymer
average_energy = 0
num_records = 100
delta_t = 30

for i in 1:num_records  
    # get average energy by measuring energy with the time interval of delta_t
    run_simulation!(state, param, delta_t, rng)
    average_energy += getEnergy(state, param)
end
average_energy /= num_records

println("my energy is about "*string(round(average_energy; digits=2))*" kT")

# Task - Make sure your polymer is well-behaving and check whether your energy is NkT or not.

# If you are done early - Check the end-to-end distance distribution and compare it with your expectation
distance_x = state.x[param.N] - state.x[1]
distance_y = state.y[param.N] - state.y[1]

# If you still have time - Check N dependence of the end-to-end distance.



