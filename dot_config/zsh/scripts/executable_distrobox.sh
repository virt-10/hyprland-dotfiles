#!/usr/bin/env bash


# Get pretty name from podman
# Check if container is a distrobox
get_containers (){
	PODMAN_CONTAINERS=$(podman ps -a --format "{{.Names}}")

	for DISTROBOX_CONTAINERS in ${PODMAN_CONTAINERS}; do
		if distrobox-list | grep -q "${DISTROBOX_CONTAINERS}"; then
			echo "${DISTROBOX_CONTAINERS}"
		fi
	done
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
