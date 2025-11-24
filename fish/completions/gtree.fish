complete -c gtree -s L -l level -d "Max depth to display" -x
complete -c gtree -s d -l dirs -d "Show directories only"
complete -c gtree -s a -l all -d "Show all files (including ignored)"
complete -c gtree -s h -l help -d "Show help"
complete -c gtree -f -a "(__fish_complete_directories)"
