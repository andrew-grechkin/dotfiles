# vim: filetype=zsh foldmethod=marker

# => aliases ------------------------------------------------------------------------------------------------------ {{{1

alias npr='npm run'

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

function npm-global-common () {
	npm install -g @commitlint/config-conventional @commitlint/cli
	npm install -g neovim
}

function nvm-lazy-load() {
	unset -f node npm nvm

	source-file "$NVM_DIR/nvm.sh"
	source-file "$NVM_DIR/bash_completion"
}

node() {
	nvm-lazy-load
	node "$@"
}

npm() {
	nvm-lazy-load
	npm "$@"
}

nvm() {
	nvm-lazy-load
	nvm "$@"
}

# => exports ------------------------------------------------------------------------------------------------------ {{{1

if [[ -d "$XDG_CONFIG_HOME/nvm" ]]; then
	export NVM_DIR="$XDG_CONFIG_HOME/nvm"
fi

# => main --------------------------------------------------------------------------------------------------------- {{{1

# export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
