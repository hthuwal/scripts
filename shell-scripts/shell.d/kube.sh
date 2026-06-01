# --------------------------------- CONTEXTS --------------------------------- #

alias kcuc='kubectl config use-context'
alias kccc='kubectl config current-context'
alias kcgc='kubectl config get-contexts'

# ----------------------------------- PODS ----------------------------------- #

alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgpw='kgp --watch'
alias kgpwide='kgp -o wide'
alias kep='kubectl edit pods'
alias kdp='kubectl describe pods'

# -------------------------------- NAMESPACES -------------------------------- #

alias kgns='kubectl get namespaces'
alias kdns='kubectl describe namespace'

# ----------------------------------- NODES ---------------------------------- #

alias kgno='kubectl get nodes'
alias keno='kubectl edit node'
alias kdno='kubectl describe node'
alias kdelno='kubectl delete node'

# ----------------------------------- LOGS ----------------------------------- #

alias kl='kubectl logs'
alias klf='kubectl logs -f'

# ----------------------------------- SCP ------------------------------------ #
function kcp() {
    local namespace=$1
    local pod=$2
    local source=$3
    local target=$4
    if [[ ! -d $target ]]; then
            echo "$target is not a valid directory."
            return 1
    fi
    local size=$(kubectl exec -n $namespace $pod -- du -k -d 0 "$source" | awk -F" " '{print $1}')

    if [[ -z ${size+x} ]] || [[ $size == "" ]]; then
            echo "Error while estimating size of the source to be copied."
    else
            echo "Copying $size KB of data from $source"
            kubectl exec -n $namespace $pod -- tar cf - "$source" | pv -s "$size"k | tar xf - -C "$target"
    fi
}

function klogs() {
    local input=$1
    if [[ -z "$input" ]]; then
        echo "Usage: klogs <pod-name|service-name>"
        return 1
    fi

    local pattern container

    # Detect if input is a full pod name (e.g. ms-appointments-7c9bdfd5b-hpua0)
    # by matching the trailing ReplicaSet hash (9-10 chars) and pod hash (5 chars).
    # If so, strip the two hashes to derive the container name (e.g. ms-appointments).
    # Otherwise treat the input as a service/deployment name used directly.
    if [[ "$input" =~ ^.+-[a-z0-9]{9,10}-[a-z0-9]{5}$ ]]; then
        pattern="^${input}"
        container=$(echo "$input" | rev | cut -d'-' -f3- | rev)
    else
        pattern="^${input}"
        container="${input}"
    fi

    echo stern -n microservices --since 1s "${pattern}" -c "${container}"
    stern -n microservices --since 1s "${pattern}" -c "${container}"
}