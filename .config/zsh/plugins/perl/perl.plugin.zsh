# vim: syntax=zsh foldmethod=marker

function update-perl-inc() {
	_appendvar_head PERL5LIB "$HOME/git/booking/pakket/lib"
	_appendvar_head PERL5LIB "./lib"
	export PERL5LIB
}

function activate-local-perl() {
	local PERL_LOCAL=${1:-${HOME}/.local/usr}
	if [[ ":$PERL5LIB:" != *":$PERL_LOCAL/lib/perl5:"* ]] ;then
		[[ -e "$PERL_LOCAL/lib/perl5/local/lib.pm" ]] || cpanm -nf --local-lib="$PERL_LOCAL" local::lib
		eval "$(perl -I "$PERL_LOCAL/lib/perl5/" -Mlocal::lib="$PERL_LOCAL")"
	fi

#	PATH="$PERL_LOCAL/bin${PATH:+:${PATH}}"
#	PERL5LIB="$PERL_LOCAL/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
#	PERL_LOCAL_LIB_ROOT="${PERL_LOCAL}${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
#	PERL_MB_OPT="--install_base \"$PERL_LOCAL\""
#	PERL_MM_OPT="INSTALL_BASE=$PERL_LOCAL"
}

function enable-perlbrew() {
	local PERLBREW_ROOT=${PERLBREW_ROOT:-${XDG_CACHE_HOME}/perlbrew}
	[[ -d "${PERLBREW_ROOT}/perls/system/bin"             ]] || mkdir -p "${PERLBREW_ROOT}/perls/system/bin"
	[[ -h "${PERLBREW_ROOT}/perls/system/bin/perl"        ]] || ln -s /usr/bin/perl "${PERLBREW_ROOT}/perls/system/bin/perl"
	source-file "${PERLBREW_ROOT}/etc/bashrc"
	source-file "${PERLBREW_ROOT}/etc/perlbrew-completion.bash"
	perlbrew list 2>/dev/null | grep '\* system' &>/dev/null && activate-local-perl "${PERLBREW_ROOT}/perls/system"
}

enable-perlbrew
update-perl-inc

# => aliases ----------------------------------------------------------------------------------------------------- {{{1

alias perldebug='PERLDB_OPTS="RemotePort=localhost:9000" perl -I${PERL_LOCAL_LIB_ROOT}/lib/perl5/x86_64-linux-thread-multi/dbgp-helper -d '
