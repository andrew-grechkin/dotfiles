# vim: filetype=zsh foldmethod=marker

# => aliases ------------------------------------------------------------------------------------------------------ {{{1

# => functions ---------------------------------------------------------------------------------------------------- {{{1

function typescript-global-setup () {
	npm install -g ts-node typescript @types/node
}

function typescript-setup () {
	npm install --save-dev nodemon ts-node typescript @types/node
}

function npm-global-install () {
	jq -r '.devDependencies | to_entries | map([.key, .value] | join("@")) | .[] | @sh' package.json \
		| xargs -t npm -g install
}

# => exports ------------------------------------------------------------------------------------------------------ {{{1

if [[ -d "$XDG_CONFIG_HOME/nvm" ]]; then
	export NVM_DIR="$XDG_CONFIG_HOME/nvm"
fi

# => main --------------------------------------------------------------------------------------------------------- {{{1

if [[ -x "$NVM_DIR/nvm.sh" ]]; then
	source "$NVM_DIR/nvm.sh"
fi
