-- https://mpv.io/manual/master/#lua-scripting
-- https://github.com/mpv-player/mpv/blob/master/DOCS/man/input.rst
local mp = require 'mp'
local utils = require 'mp.utils'

local function do_nothing() end

local function disable_quit()
    mp.add_forced_key_binding('q', 'disable_q_key_bindings', do_nothing)
    mp.add_forced_key_binding('esc', 'disable_esc_key_bindings', do_nothing)
end

local function set_clipboard(text)
    utils.subprocess({
        args = {
            'bash',
            '-c',
            string.format([[
                echo -n '%s' | ~/.local/script/clipcopy
            ]], text),
        },
        playback_only = false,
    })
end

local function copy_url_to_clipboard()
    local text = mp.get_property_native('path', '')
    if (text:find('http://') == 1) or (text:find('https://') == 1) or (text:find('ytdl://') == 1) then
        set_clipboard(text)
    end
end

mp.add_forced_key_binding('ctrl+q', 'disable_quit_key_bindings', disable_quit)
mp.add_forced_key_binding('ctrl+y', 'copy-url-to-clipboard', copy_url_to_clipboard)
