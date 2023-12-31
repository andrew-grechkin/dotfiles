local mp = require 'mp'
local log = require 'mp.msg'
local utils = require 'mp.utils'

local HISTFILE = os.getenv('XDG_CACHE_HOME') .. '/mpv/history.log';

local add_to_history = function(title, path)
    log.info(('add_to_history: "%s" %s'):format(title, path))

    local cwd = mp.get_property_native('working-directory')
    path = utils.join_path(cwd, path)

    if not title then
        title = mp.get_property('media-title');
        log.info(('title: "%s"'):format(title))
        -- title = (title == mp.get_property('filename') and '' or (' (%s)'):format(title));
        -- log.info(('title: "%s"'):format(title))
        if title == '' then title = path end
        log.info(('title: "%s"'):format(title))
    end

    log.info(('add_to_history: "%s" %s'):format(title, path))

    if (path:match('youtube')) then
        -- title = title:match('^%s*(.-)%s*$')
        -- title = title:match('^%(*(.-)%)*$')
        title = 'youtube: ' .. title
    elseif (path:match('^/')) then
        local stat = utils.file_info(path)
        if stat.is_dir then
            title = 'directory: ' .. title
        else
            title = 'file: ' .. title
        end
    end

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

    local stat = utils.file_info(path)
    if not stat then return end

    log.info(('path: %s, stat: %s'):format(path, utils.to_string(stat)))

    if not stat.is_dir then return end

    local _, basename = utils.split_path(path)
    add_to_history(basename, path)
end)

mp.register_event('file-loaded', function(event)
    local path = mp.get_property('path')
    local file_format = mp.get_property('file-format')
    log.info(('%s: "%s" %s'):format(utils.to_string(event), path, file_format))
    local audio_codec = mp.get_property('audio-codec-name')
    log.info(('%s: "%s" %s'):format(utils.to_string(event), path, audio_codec))
    -- local video_format = mp.get_property('video-format')
    -- log.info(('%s: "%s" %s'):format(utils.to_string(event), path, video_format))

    -- if not video_format or ignore[video_format] ~= nil then return end
    if not audio_codec then return end

    add_to_history(nil, path)
end)
