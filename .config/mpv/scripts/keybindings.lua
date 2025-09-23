-- https://mpv.io/manual/master/#lua-scripting
-- https://github.com/mpv-player/mpv/blob/master/DOCS/man/input.rst
local mp = require 'mp'
local log = require 'mp.msg'
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

local function save_position() mp.command('write-watch-later-config') end

mp.register_script_message('save-position-next', function()
    save_position()
    mp.command('playlist-next')
end)

mp.register_script_message('save-position-prev', function()
    save_position()
    mp.command('playlist-prev')
end)

local function next_chapter_or_item(direction)
    local chapters = mp.get_property_number('chapters') or 0
    log.info(('chapters: "%s"'):format(utils.to_string(chapters)))
    local chapter = mp.get_property_number('chapter') or 0
    log.info(('chapter: "%s"'):format(chapter + 1))
    if chapter + direction < 0 then
        log.info('prev item')
        save_position()
        mp.command('playlist-prev')
        mp.commandv('script-message', 'osc-playlist')
    elseif chapter + direction >= chapters then
        log.info('next item')
        save_position()
        mp.command('playlist-next')
        mp.commandv('script-message', 'osc-playlist')
    else
        log.info(('set chapter: %s'):format(chapter + direction + 1))
        save_position()
        mp.commandv('add', 'chapter', direction)
        mp.commandv('script-message', 'show-text ${chapter-list}')
    end
end

mp.add_forced_key_binding('ctrl+q', 'disable_quit_key_bindings', disable_quit)
mp.add_forced_key_binding('ctrl+y', 'copy-url-to-clipboard', copy_url_to_clipboard)

mp.observe_property('pause', 'bool', function(_, _) save_position() end)

mp.register_event('playback-restart', save_position)
mp.register_event('start-file', save_position)

mp.add_forced_key_binding('n', 'chapterplaylist-next', function() next_chapter_or_item(1) end)
mp.add_forced_key_binding('p', 'chapterplaylist-prev', function() next_chapter_or_item(-1) end)
