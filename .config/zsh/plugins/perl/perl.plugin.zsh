# vim: syntax=zsh foldmethod=marker

# => exports ----------------------------------------------------------------------------------------------------- {{{1

export PERLBREW_HOME="$HOME/.local/usr/perlbrew"
export PERLBREW_ROOT="$HOME/.local/share/perlbrew"

# => aliases ----------------------------------------------------------------------------------------------------- {{{1

alias perldebug='PERLDB_OPTS="RemotePort=localhost:9000" perl -I${PERL_LOCAL_LIB_ROOT}/lib/perl5/x86_64-linux-thread-multi/dbgp-helper -d '
alias perlverbose='export PERL5OPT="-MCarp=verbose"'

# => functions --------------------------------------------------------------------------------------------------- {{{1

function export-perl5lib() {
	_appendvar_head PERL5LIB "$HOME/git/booking/pakket/lib"
	_appendvar_head PERL5LIB "./lib"
	export PERL5LIB
}

function activate-local-perl() {
	local PERL_LOCAL=${1:-${HOME}/.local/usr}
	if [[ ":$PERL5LIB:" != *":$PERL_LOCAL/lib/perl5:"* ]] ;then
		[[ -e "$PERL_LOCAL/lib/perl5/local/lib.pm" ]] || echo "Preparing Perl local environment in: $PERL_LOCAL"
		[[ -e "$PERL_LOCAL/lib/perl5/local/lib.pm" ]] || cpanm -nqf --local-lib="$PERL_LOCAL" local::lib
		eval "$(perl -I "$PERL_LOCAL/lib/perl5/" -Mlocal::lib="$PERL_LOCAL")"
	fi
}

function enable-perlbrew() {
	PERLBREW_ROOT=${PERLBREW_ROOT:-${XDG_CACHE_HOME}/perlbrew}

	if [[ ! -d "$PERLBREW_ROOT" ]]; then
		NEED_PERLBREW_INIT=1
		perlbrew init
		perlbrew install-cpanm
	fi

	[[ -d "$PERLBREW_ROOT/perls/system/bin"      ]] || mkdir -p "$PERLBREW_ROOT/perls/system/bin"
	[[ -h "$PERLBREW_ROOT/perls/system/bin/perl" ]] || ln -s /usr/bin/perl "$PERLBREW_ROOT/perls/system/bin/perl"

	source-file "$PERLBREW_ROOT/etc/bashrc"
	source-file "$PERLBREW_ROOT/etc/perlbrew-completion.bash"

	if [[ "$NEED_PERLBREW_INIT" == 1 ]]; then
		perlbrew lib create system@default
		perlbrew switch system@default
	fi
}

# => main -------------------------------------------------------------------------------------------------------- {{{1

if [[ -n "$(command -v perlbrew)" ]]; then
	enable-perlbrew
else
	#perlbrew list 2>/dev/null | grep '\* system' &>/dev/null && activate-local-perl "$PERLBREW_ROOT/perls/system"
	[[ -n "$(command -v cpanm)" ]] && activate-local-perl
fi

export-perl5lib
