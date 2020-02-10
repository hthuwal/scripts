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