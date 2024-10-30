#!/usr/bin/env bash


# Get distrobox containers
get_containers (){
    podman ps -a --filter label=manager=distrobox --format "{{.Names}}"
}

# Distrobox remove
remove_container (){
	echo "This will stop and remove the selected container."
	SELECT_CONTAINER=$(get_containers | gum choose)
	echo "Are you sure you want to remove ${SELECT_CONTAINER}"
	if [[ $(gum choose "yes" "no") = "yes" ]]
	then
        distrobox-stop "${SELECT_CONTAINER}"
        distrobox-rm "${SELECT_CONTAINER}"
    else
        echo "distrobox-rm cancelled"
        exit 0
    fi
}

# List and enter selected container
enter_container (){
    SELECT_CONTAINER=$(get_containers | gum choose)
    distrobox-enter "${SELECT_CONTAINER}"
}

# Check if no arguments were passed
if [[ $# -eq 0 ]]; then
    enter_container
    exit 0
fi

# Arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --help) echo "--help --remove";;
        --remove) remove_container;;
        *) echo "Unknown parameter: $1";;
    esac
    shift
done
