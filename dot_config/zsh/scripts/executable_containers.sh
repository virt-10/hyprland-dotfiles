#!/usr/bin/env sh


# image downloader
gallery-dl () {
    podman run \
    --interactive \
    --rm \
    --tty \
    --volume ~/Documents/Containers/Gallery-dl:/etc/gallery-dl:z \
    --volume ~/Documents/Containers/Gallery-dl/gallery-dl.conf:/etc/gallery-dl.conf:z \
    ghcr.io/mikf/gallery-dl:latest \
    "$@"
}
