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

outputDIR = "outputVSC4"
path = "/home/fabian/Documents/DataVSC/measurements/runsSp4"

ispath(outputDIR) || mkpath(outputDIR)
for ensemble in readdir(path;join=true)
    file = joinpath(ensemble,"out","out_flow")
    name = basename(ensemble)
    
    isfile(file) || continue

    hirep_file  = file
    output_file = joinpath(outputDIR,"$(name)_flow")
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
