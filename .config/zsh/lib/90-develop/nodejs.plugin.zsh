# vim: filetype=sh foldmethod=marker

# => aliases ------------------------------------------------------------------------------------------------------ {{{1

alias npr='npm run'

# => functions ---------------------------------------------------------------------------------------------------- {{{1

function npm-typescript-global-setup () {
	npm install -g ts-node typescript @types/node
}

function npm-typescript-setup () {
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

function npm-package-setup () {
	npm init --init-author-name "Andrew Grechkin" --init-license "GPLv3" --init-module index.js --yes

	npm install --save-dev eslint eslint-plugin-prettier eslint-config-prettier
	npm install --save-dev --save-exact prettier

	npm init @eslint/config@latest

	# npx eslint --init

	cat > ./.editorconfig << END_EDITORCONFIG
root = true

[*]
charset = utf-8
end_of_line = lf
indent_size = 4
indent_style = space
insert_final_newline = true
max_line_length = 120
tab_width = 4
trim_trailing_whitespace = true

[Makefile]
indent_style = tab

[*.json,*.yaml]
indent_size = 2
END_EDITORCONFIG

	cat > ./eslint.config.mjs << END_ESLINT_CONFIG
import globals from 'globals';
import pluginJs from '@eslint/js';

import eslintConfigPrettier from 'eslint-config-prettier';
import eslintPluginPrettier from 'eslint-plugin-prettier/recommended';

export default [
    {files: ['**/*.js'], languageOptions: {sourceType: 'module'}},
    {languageOptions: {globals: globals.node}},
    pluginJs.configs.recommended,
    eslintConfigPrettier,
    eslintPluginPrettier,
];
END_ESLINT_CONFIG

	cat > ./.prettierrc.yaml << END_PRETTIER_CONFIG
---
# https://prettier.io/docs/en/options
# https://json.schemastore.org/prettierrc
arrowParens: avoid
bracketSameLine: false
bracketSpacing: false
htmlWhitespaceSensitivity: ignore
jsxSingleQuote: true

overrides:
  - files: ['*.html', '*.html.ep']
    options:
      parser: html

proseWrap: preserve
quoteProps: consistent
semi: true
singleAttributePerLine: true
singleQuote: true
trailingComma: all
vueIndentScriptAndStyle: true
END_PRETTIER_CONFIG
}

# => exports ------------------------------------------------------------------------------------------------------ {{{1

# export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"

# => main --------------------------------------------------------------------------------------------------------- {{{1

if [[ -x $(command -v fnm) ]]; then
	eval "$(fnm env --use-on-cd --shell zsh)"
elif [[ -d "$XDG_CONFIG_HOME/nvm" ]]; then
	export NVM_DIR="$XDG_CONFIG_HOME/nvm"

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
fi
