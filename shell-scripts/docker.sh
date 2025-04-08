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