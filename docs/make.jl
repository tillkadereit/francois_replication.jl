push!(LOAD_PATH,"../src/")
using Documenter, francois_replication

makedocs(modules = [francois_replication], sitename = "francois_replication.jl")

deploydocs(repo = "github.com/tillkadereit/francois_replication.jl.git", devbranch = "main")
