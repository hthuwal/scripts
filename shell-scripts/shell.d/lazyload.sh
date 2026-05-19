function nvm() {
	unfunction nvm
	export NVM_DIR="$HOME/.nvm"
	[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
	[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
	nvm "$@"
}

function fzf() {
	unfunction fzf
	[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
	fzf "$@"
}