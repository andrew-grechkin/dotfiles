# vim: filetype=zsh foldmethod=marker

# => exports ----------------------------------------------------------------------------------------------------- {{{1

# export        PERLTIDY="$XDG_CONFIG_HOME/perltidyrc"
export      PERLCRITIC="$XDG_CONFIG_HOME/perlcriticrc"
export PERL_CPANM_HOME="$XDG_CACHE_HOME/cpanm"
export   PERLBREW_HOME="$XDG_DATA_HOME/perlbrew"
export   PERLBREW_ROOT="$XDG_DATA_HOME/perlbrew"

# => aliases ----------------------------------------------------------------------------------------------------- {{{1

alias perldebug='PERLDB_OPTS="RemotePort=localhost:9000" perl -I${PERL_LOCAL_LIB_ROOT}/lib/perl5/x86_64-linux-thread-multi/dbgp-helper -d '
alias perlverbose='export PERL5OPT="-MCarp=verbose"'

# => functions --------------------------------------------------------------------------------------------------- {{{1

function enable-perlbrew() {
	[[ -d "$PERLBREW_ROOT" ]] || {
		NEED_PERLBREW_INIT=1
		mkdir -p "$PERLBREW_ROOT"
		perlbrew init
		perlbrew install-cpanm
	}

	# make system perl available for perlbrew
	[[ -d "$PERLBREW_ROOT/perls/system/bin"      ]] || mkdir -p            "$PERLBREW_ROOT/perls/system/bin"
	[[ -h "$PERLBREW_ROOT/perls/system/bin/perl" ]] || ln -s $(command -v perl) "$PERLBREW_ROOT/perls/system/bin/perl"

	# enable perlbrew environment
	source-file "$PERLBREW_ROOT/etc/bashrc"
	source-file "$PERLBREW_ROOT/etc/perlbrew-completion.bash"

	if (( $NEED_PERLBREW_INIT )); then
		perlbrew lib create system@default
		perlbrew switch system@default
	fi
}

function activate-local-perl() {
	local PERL_LOCAL=${1:-$HOME/.local/usr}
	if [[ ":$PERL5LIB:" != *":$PERL_LOCAL/lib/perl5:"* ]]; then
		# install local::lib if necessary
		[[ -e "$PERL_LOCAL/lib/perl5/local/lib.pm" ]] || {
			echo "Preparing Perl local environment in: $PERL_LOCAL"
			cpanm -nqf --local-lib="$PERL_LOCAL" local::lib
		}

		# enable local::lib environment
		eval "$(perl -I "$PERL_LOCAL/lib/perl5/" -Mlocal::lib="$PERL_LOCAL")"
	fi
}

function export-perl5lib() {
	typeset -gUT PERL5LIB perl5lib
	perl5lib=("$HOME/git/booking/pakket/lib" ${perl5lib[@]})
	perl5lib=("$HOME/.local/lib/perl5"       ${perl5lib[@]})
	perl5lib=("./lib"                        ${perl5lib[@]})
}

# => main -------------------------------------------------------------------------------------------------------- {{{1

if (( $+commands[perlbrew] )); then                                            # perlbrew is the preferred way of managing perl and libraries
	enable-perlbrew
else                                                                           # fallback onto local::lib if perlbrew is not available but cpanm is
	(( $+commands[cpanm] )) && activate-local-perl
fi

export-perl5lib
