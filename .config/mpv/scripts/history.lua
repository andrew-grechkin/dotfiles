local mp = require 'mp'
local msg = require 'mp.msg'
local utils = require 'mp.utils'

local HISTFILE = os.getenv('XDG_CACHE_HOME') .. '/mpv/history.log';

mp.add_hook('on_load', 50, function()
    local path = mp.get_property_native('path')
    if not path then return end

    if string.sub(path, 1, 1) ~= '/' then
        local cwd = mp.get_property_native('working-directory')
        path = utils.join_path(cwd, path)
    end

    local stat = utils.file_info(path)
    if not stat then return end

    msg.debug(('path: %s, stat: %s'):format(path, utils.format_json(stat)))

    if stat.is_dir then
        local _, basename = utils.split_path(path)
        local opt = {}
        if mp.get_property_native('osc') == false then table.insert(opt, '--no-osc') end
        if mp.get_property_native('term-osd') == 'force' then table.insert(opt, '--term-osd=force') end
        if mp.get_property_native('audio-display') == false then table.insert(opt, '--no-audio-display') end

        local fp = io.open(HISTFILE, 'a+');
        if fp then
            fp:write(('[%s]\t%s\tmpv %s "%s"\n'):format(os.date('%Y-%m-%dT%X'), basename, table.concat(opt, ' '), path));
            fp:close();
        end
    end
end)

mp.register_event('file-loaded', function()
    local video_format = mp.get_property('video-format')
    if video_format and video_format ~= 'mjpeg' then
        print(video_format)
    else
        return
    end

    local title = mp.get_property('media-title');
    title = (title == mp.get_property('filename') and '' or (' (%s)'):format(title));
    if title == '' then title = mp.get_property('path') end

    local fp = io.open(HISTFILE, 'a+');
    if fp then
        fp:write(('[%s]\t%s\tmpv "%s"\n'):format(os.date('%Y-%m-%dT%X'), title, mp.get_property('path')));
        fp:close();
    end
end)
