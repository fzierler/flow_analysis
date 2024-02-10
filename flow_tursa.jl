using DelimitedFiles
function run_flow_analysis(logfile,outfile)
    try
        run(`python flow_analysis_cli.py $logfile $outfile`)
    catch
        run(`python3 flow_analysis_cli.py $logfile $outfile`)
    end
end

path = "../../Lattice/FlowTursa/WilsonFlow/"
dirs = filter(!contains("bin"),readdir(path,join=true))
for ensemble in dirs
    logfiles = filter(contains("Wilson_flow"),readdir(ensemble,join=true))
    name = splitpath(ensemble)[end]
    tmp = "tmpfile_$name"
    io = open(tmp,"a")  
    @show name
    for logfile in logfiles
        write(io,read(logfile))
    end
    close(io)
    outfile = "outputTursa/$name"
    run_flow_analysis(tmp,outfile)
    rm(tmp)
end

files = readdir("outputTursa/",join=true)
for file in files

    #read header and data
    head = readline(file)
    data = readdlm(file,',',skipstart=1)

    # sort and remove duplicates
    data = sortslices(data,dims=1)
    data = unique(data,dims=1)

    # write to file
    io = open(file,"w")
    write(io,head*"\n")
    writedlm(io,data,',')
    close(io)
end