function pmath --description "use first line of input as variable P in fish math, awesome in pipes"
    read pipe
    math $argv[1..-2] (string replace --all "P" "$pipe" "$argv[-1]")
end
