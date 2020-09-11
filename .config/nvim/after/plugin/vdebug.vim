if plugin#is_loaded('vdebug')
	if !exists('g:vdebug_options')
		let g:vdebug_options = {}
	endif

	let g:vdebug_options.server              = 'localhost'
	let g:vdebug_options.debug_window_level  = 0
	"let g:vdebug_options["socket_type"]      = 'unix'
	"let g:vdebug_options["unix_path"]        = '/run/user/1027/dbgp.sock'
	"let g:vdebug_options["unix_permissions"] = 0777
	let g:vdebug_options.break_on_open       = 0
	let g:vdebug_options.watch_window_style  = 'compact'                           " This can be 'compact' or 'expanded'.

	let g:vdebug_keymap = {
	\	'run' :               '<F5>',
	\	'run_to_cursor' :     '<F9>',
	\	'step_over' :         '<F2>',
	\	'step_into' :         '<F3>',
	\	'step_out' :          '<F4>',
	\	'close' :             '<F6>',
	\	'detach' :            '<F7>',
	\	'set_breakpoint' :    '<F10>',
	\	'get_context' :       '<F11>',
	\	'eval_under_cursor' : '<F12>',
	\	'eval_visual' :       '<leader>e',
	\}

	"let g:vdebug_features = {}
	" This determines the maximum number of hash or array values available to you in the watch window. Hopefully this is enough?
	"let g:vdebug_features['max_children']    = 512
	" This determines the maximum number of bytes that will be sent to the debugger
	" While ~1MB of data really shouldn't cause any problem in this day and age, YMMV?
	"let g:vdebug_features['max_data']        = 1000000
endif
