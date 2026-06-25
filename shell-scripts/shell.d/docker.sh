function dkexec() {
    containers=$(docker ps -f status=running --format "{{.Names}}")
    target=$(echo $containers | gum filter --placeholder="Select container")
    if [[ -z $target ]]; then
        echo "No container selected"
        return
    fi

    if [[ -n $target ]]; then
        docker exec -it "$target" /bin/ash
    fi
}

function dkrmi() {
    local selected
    selected=$(docker image ls --format json | jq -r '"\(.Repository):\(.Tag)"' | gum choose --no-limit --header "Select images to remove")

    if [[ -z "$selected" ]]; then
        echo "No images selected."
        return
    fi

    echo "$selected"
    gum confirm "Remove these images?" || return

    echo "$selected" | xargs docker image rm
}