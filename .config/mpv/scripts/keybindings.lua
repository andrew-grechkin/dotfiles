-- https://mpv.io/manual/master/#lua-scripting
-- https://github.com/mpv-player/mpv/blob/master/DOCS/man/input.rst
local function do_nothing() end

local function disable_quit()
    mp.add_forced_key_binding('q', 'disable_q_key_bindings', do_nothing)
    mp.add_forced_key_binding('esc', 'disable_esc_key_bindings', do_nothing)
end

mp.add_forced_key_binding('ctrl+q', 'disable_quit_key_bindings', disable_quit)
