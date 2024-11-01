#!/usr/bin/env bash


# Get distrobox containers
get_containers (){
    podman ps -a --filter label=manager=distrobox --format "{{.Names}}"
}

# Blublu
blublu_containers (){
    echo "Select Container to install"
    SELECT_CONTAINER=$(gum choose "blublu-arch" "blublu-resolve" "blublu-gaming")
    echo "Enter container name"
    CONTAINER_NAME=$(gum input --placeholder "tmp")

    podman pull ghcr.io/virt-10/"${SELECT_CONTAINER}":latest

    if [[ "${SELECT_CONTAINER}" == "blublu-resolve" ]]; then
        distrobox create -n "${CONTAINER_NAME}" \
            -H ~/Documents/Distrobox/"${CONTAINER_NAME}" \
            -i ghcr.io/virt-10/"${SELECT_CONTAINER}":latest \
            --nvidia \
            --volume /usr/share/vulkan/icd.d/nvidia_icd.x86_64.json:/usr/share/vulkan/icd.d/nvidia_icd.json:ro
    else
        distrobox create -n "${CONTAINER_NAME}" \
            -H ~/Documents/Distrobox/"${CONTAINER_NAME}" \
            -i ghcr.io/virt-10/"${SELECT_CONTAINER}":latest \
            --additional-flags "--device nvidia.com/gpu=all --security-opt=label=disable" \
            --volume /usr/share/vulkan/icd.d/nvidia_icd.x86_64.json:/usr/share/vulkan/icd.d/nvidia_icd.json:ro
    fi
}

# Distrobox remove
remove_container (){
	echo "This will stop and remove the selected container."
	SELECT_CONTAINER=$(get_containers | gum choose)
	echo "${SELECT_CONTAINER} is being removed."
	distrobox-stop "${SELECT_CONTAINER}"
	distrobox-rm "${SELECT_CONTAINER}"
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
        h) echo "h rm c";;
        rm) remove_container;;
        c) blublu_containers;;
        *) echo "Unknown parameter: $1";;
    esac
    shift
done
