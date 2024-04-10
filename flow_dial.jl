using DelimitedFiles
function run_flow_analysis(logfile,outfile)
    try
        run(`python flow_analysis_cli.py $logfile $outfile`)
    catch
        run(`python3 flow_analysis_cli.py $logfile $outfile`)
    end
end
function plaquettes_log(file)
    plaquettes = Float64[]
    for line in eachline(file)
        if occursin("Plaquette",line)
            line = replace(line,"="=>" ")
            line = replace(line,":"=>" ")
            p = parse(Float64,split(line)[end])
            append!(plaquettes,p)
        end
    end
    return plaquettes
end

outputDIR = "outputDiaL"
ensembles = [
    "Lt48Ls20beta6.5mf0.71mas1.01FUN",
    "Lt64Ls20beta6.5mf0.71mas1.01FUN",
    "Lt64Ls20beta6.5mf0.70mas1.01FUN",
    "Lt64Ls32beta6.5mf0.72mas1.01FUN",
    "Lt80Ls20beta6.5mf0.71mas1.01FUN",
    "Lt96Ls20beta6.5mf0.71mas1.01FUN",
    "Lt48Ls24beta6.45mf0.7mas1.04FUN",
    "Lt48Ls28beta6.45mf0.7mas1.045FUN",
    "Lt56Ls32beta6.45mf0.7mas1.05FUN",
    "Lt56Ls32beta6.45mf0.71mas1.04FUN",
    "Lt56Ls36beta6.45mf0.718mas1.04FUN",
    "Lt56Ls36beta6.45mf0.7mas1.055FUN",
]

path = "/home/fabian/Documents/Lattice/HiRepDIaL/measurements/"
path = "/media/fabian/HDD#3/DiaLrsync/measurements"
path = "/home/fabian/Documents/DataDiaL/measurements"

ispath(outputDIR) || mkpath(outputDIR)
for ensemble in ensembles
    @show ensemble
 
    hirep_file = joinpath(path,"$ensemble/out/out_flow")
    output_file = joinpath(outputDIR,ensemble*"_flow")
    run_flow_analysis(hirep_file,output_file)

    # now get the plaquette
    plaq = plaquettes_log(hirep_file)
    data = readdlm(output_file,',',skipstart=1)
    head = readline(output_file)

    io = open(output_file,"w")
    write(io,head*"\n")
    writedlm(io,hcat(data,plaq),',')
    close(io)
end