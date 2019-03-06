print_error(){
	local R="\033[0;31m"    # red
	local ZZ="\033[0m"      # Reset
    printf "${R}${@}${ZZ}\n"
}

print_success(){
	local G="\033[0;32m"    # green
	local ZZ="\033[0m"      # Reset
    printf "${G}${@}${ZZ}\n"
}
