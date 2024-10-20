# This is a module for 8.08 - 8.S421 numerics recitation.

module Rec
    #parameters of the model
    mutable struct Param
        dt::Float64             # time step
        
        N::Int64                # number of monomers
        k::Float64              # nearest neighbor interaction strength
        mu::Float64             # mobility
        kT::Float64             # thermal energy
    end

    #constructor
    function setParam(dt, N, k, mu, kt)

        param = Param(dt, N, k, mu, kt)
        return param
    end

    #state variables of the model
    mutable struct State
        t::Float64                  # current time
        x::Array{Float64, 1}        # x-coordinates
        y::Array{Float64, 1}        # y-coordinates

        x_next::Array{Float64, 1}   # next x-coordinates
        y_next::Array{Float64, 1}   # next y-coordinates

        fx::Array{Float64, 1}       # force along x-direction
        fy::Array{Float64, 1}       # force along y-direction
    end

    #constructor
    function setState(param)
        x = zeros(Float64, param.N)
        y = zeros(Float64, param.N)

        x_next = zeros(Float64, param.N)
        y_next = zeros(Float64, param.N)

        fx = zeros(Float64, param.N)
        fy = zeros(Float64, param.N)

        state = State(0, x, y, x_next, y_next, fx, fy)
        return state
    end
end

function get_force!(param, state)
    fill!(state.fx, 0)
    fill!(state.fy, 0)

    #### 1) the part you should write

    # for the first monomer
    i = 1
    state.fx[i] = param.k*(state.x[i+1] - state.x[i])
    state.fy[i] = param.k*(state.y[i+1] - state.y[i])
    
    # for the second to N-1 th monomer
    for i in 2:param.N-1
        state.fx[i] = -param.k*(state.x[i] - state.x[i-1]) + param.k*(state.x[i+1] - state.x[i])
        state.fy[i] = -param.k*(state.y[i] - state.y[i-1]) + param.k*(state.y[i+1] - state.y[i])
    end

    # for the last monomer
    i = param.N
    state.fx[i] = -param.k*(state.x[i] - state.x[i-1])
    state.fy[i] = -param.k*(state.y[i] - state.y[i-1])
    
    #### 1) end
end 

function run_simulation!(state, param, t_run, rng)

    t_now = state.t     # time at the beginning of your simulation
    dt = param.dt       # time step

    while state.t < t_now + t_run
        get_force!(param, state)

        noise = sqrt(2*param.mu*param.kT * dt)

        #### 2) the part you should write
        for n in 1:param.N
            state.x_next[n] = state.x[n] + param.mu * state.fx[n] * dt + noise * randn(rng)
            state.y_next[n] = state.y[n] + param.mu * state.fy[n] * dt + noise * randn(rng)
        end
        #### 2) end

        state.x = copy(state.x_next)
        state.y = copy(state.y_next)

        state.t += dt
    end
end

function get_movie!(state, param, rng, t_gap, n_frame, in_fps)

    anim = @animate for frame in 1:n_frame
        run_simulation!(state, param, t_gap, rng)

        x_center = sum(state.x)/length(state.x)
        y_center = sum(state.y)/length(state.y)

        x_min = findmin(state.x)[1]
        x_max = findmax(state.x)[1]

        y_min = findmin(state.y)[1]
        y_max = findmax(state.y)[1]

        x_left = x_max-x_min+10 > 3*sqrt(param.N) ? x_min-5 : x_center - 1.5*sqrt(param.N)
        x_right = x_max-x_min+10 > 3*sqrt(param.N) ? x_max+5 : x_center + 1.5*sqrt(param.N)

        y_left = y_max-y_min+10 > 3*sqrt(param.N) ? y_min-5 : y_center - 1.5*sqrt(param.N)
        y_right = y_max-y_min+10 > 3*sqrt(param.N) ? y_max+5 : y_center + 1.5*sqrt(param.N)


        plot(state.x, state.y, xlims=(x_left, x_right), ylims=(y_left, y_right), aspectratio=1, m=(2), legend=false )
    end

    name = "Rec8_movie.gif"
    gif(anim, name, fps=in_fps)
end


function getEnergy(state, param)
    energy = 0

    for i in 1:N-1
        energy += (param.k/2)*((state.x[i] - state.x[i+1])^2 + (state.y[i] - state.y[i+1])^2)
    end

    return energy
end


function measure!(ind, state, param)
    state.times[ind] += state.t
    state.records[ind,1] += state.x
    state.records[ind,2] += state.x^2 + state.y^2
end