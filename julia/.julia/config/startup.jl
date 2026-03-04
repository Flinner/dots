using Pkg
if isfile("Project.toml") && isfile("Manifest.toml")
    Pkg.activate(".")
end


try
    using Revise
catch e
    @warn "Error initializing Revise" exception=(e, catch_backtrace())
end

try
    using BenchmarkTools
catch e
    @warn "Error initializing Revise" exception=(e, catch_backtrace())
end


try
     @eval using OhMyREPL
catch e
     @warn "error while importing OhMyREPL" e
end
