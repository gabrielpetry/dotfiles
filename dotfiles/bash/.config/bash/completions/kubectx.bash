_kubectx_comp() {
	local cur contexts opts
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	
	if contexts=$(kubectl config get-contexts -o name 2>/dev/null | rev | cut -d/ -f1 | rev | sort); then
		opts="$contexts"
	else
		opts=""
	fi
	
	mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
	
	return 0
}

complete -F _kubectx_comp kubectx
complete -F _kubectx_comp kubectx-env