# Delete all local branches which are no longer present in remote
function delete_gone_branches() {
    if [[ "$#" -ne 1 ]]; then
        echo "Needs exactly one argument: path to the directory."
        return 1
    fi
    dir=${1}

    make_heading ${dir}
    if [[ ! -d ${dir} ]]; then
        echo "${dir} is not a valid path."
        return 1
    fi

    pushd ${dir}
    if [[ -d .git ]]; then
        git fetch -p
        git branch -v | grep gone | awk -F' ' '{print $1}' | xargs -I{} -P 4 -- git branch -D {}
    else
        echo "Not a git repository."
    fi
    popd
}

# --------------------- List all branches older than date -------------------- #

function list_old_branches() {
    padding="                                      "
    for branch in $(git branch -r | grep -v HEAD | grep -v develop | grep -v master | grep -v main | grep -v "release*" | sed /\*/d); do
        if [[ -z "$(git log -1 --since=\"${1}\" -s ${branch})" ]]; then
            last_updated=$(git show --format="%ci %cr %an" ${branch} | head -n 1)
            printf "%s%s %s\n" "${branch}" "${padding:${#branch}}" "${last_updated}"
        fi
    done
}
