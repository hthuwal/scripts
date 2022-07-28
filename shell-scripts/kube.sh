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
        namespace=$1
        pod=$2
        source=$3
        target=$4
        if [[ ! -d $target ]]; then
                echo "$target is not a valid directory."
                return 1
        fi
        size=$(kubectl exec -n $namespace $pod -- du -k -d 0 "$source" | awk -F" " '{print $1}')

        if [[ -z ${size+x} ]] || [[ $size == "" ]]; then
                echo "Error while estimating size of the source to be copied."
        else
                echo "Copying $size KB of data from $source"
                kubectl exec -n $namespace $pod -- tar cf - "$source" | pv -s "$size"k | tar xf - -C "$target"
        fi
}
