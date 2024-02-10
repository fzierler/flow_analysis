using DelimitedFiles
function run_flow_analysis(logfile,outfile)
    try
        run(`python flow_analysis_cli.py $logfile $outfile`)
    catch
        run(`python3 flow_analysis_cli.py $logfile $outfile`)
    end
end


outputDIR = "outputDiaL"
ensembles = [
    "Lt48Ls20beta6.5mf0.71mas1.01FUN",
    "Lt64Ls20beta6.5mf0.71mas1.01FUN",
    "Lt64Ls20beta6.5mf0.70mas1.01FUN",
    "Lt64Ls32beta6.5mf0.72mas1.01FUN",
    "Lt80Ls20beta6.5mf0.71mas1.01FUN",
    "Lt96Ls20beta6.5mf0.71mas1.01FUN",
]
ensembles = [
    "Lt48Ls24beta6.45mf0.7mas1.04FUN",
    "Lt48Ls28beta6.45mf0.7mas1.045FUN",
    "Lt56Ls32beta6.45mf0.7mas1.05FUN",
    "Lt56Ls32beta6.45mf0.71mas1.04FUN",
    "Lt56Ls36beta6.45mf0.718mas1.04FUN",
    "Lt56Ls36beta6.45mf0.7mas1.055FUN",
]


ispath(outputDIR) || mkpath(outputDIR)
for ensemble in ensembles
    hirep_file = "/home/fabian/Documents/Lattice/HiRepDIaL/measurements/$ensemble/out/out_flow"
    @show hirep_file
    output_file = joinpath(outputDIR,ensemble*"_flow")
    run_flow_analysis(hirep_file,output_file)
end