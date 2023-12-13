local mp = require 'mp'
local log = require 'mp.msg'
local utils = require 'mp.utils'

local HISTFILE = os.getenv('XDG_CACHE_HOME') .. '/mpv/history.log';

local add_to_history = function(title, path)
    local opt = {}
    if mp.get_property_native('osc') == false then table.insert(opt, '--no-osc') end
    if mp.get_property_native('term-osd') == 'force' then table.insert(opt, '--term-osd=force') end
    if mp.get_property_native('audio-display') == false then table.insert(opt, '--no-audio-display') end

    local fp = io.open(HISTFILE, 'a+');
    if fp then
        fp:write(('[%s]\t%s\tmpv %s "%s"\n'):format(os.date('%Y-%m-%dT%X'), title, table.concat(opt, ' '), path));
        fp:close();
    end
end

mp.add_hook('on_load', 50, function(hook)
    local path = mp.get_property_native('path')
    log.info(('on_load: "%s" %s'):format(path, utils.to_string(hook)))
    if not path then return end

    local cwd = mp.get_property_native('working-directory')
    path = utils.join_path(cwd, path)

    local stat = utils.file_info(path)
    if not stat then return end

    log.info(('path: %s, stat: %s'):format(path, utils.to_string(stat)))

    if not stat.is_dir then return end

    local _, basename = utils.split_path(path)
    add_to_history(basename, path)
end)

local ignore = {gif = 1, png = 1, mjpg = 1, mjpeg = 1, jpeg = 1, jpg = 1}

mp.register_event('file-loaded', function(event)
    local path = mp.get_property('path')
    local video_format = mp.get_property('video-format')
    log.info(('%s: "%s" %s'):format(utils.to_string(event), path, video_format))

    if not video_format or ignore[video_format] ~= nil then return end

    local title = mp.get_property('media-title');
    title = (title == mp.get_property('filename') and '' or (' (%s)'):format(title));
    if title == '' then title = path end

    add_to_history(title, path)
end)
