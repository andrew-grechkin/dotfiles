local mp = require 'mp'
local log = require 'mp.msg'
local utils = require 'mp.utils'

RUN_QUOTE = 1

local MPV_HIST_DIR = os.getenv('XDG_STATE_HOME') .. '/mpv';
local MPV_HIST_FILE = MPV_HIST_DIR .. '/play.history.tsv';
os.execute('mkdir -p ' .. MPV_HIST_DIR)

local add_to_history = function(path)
    if RUN_QUOTE < 1 then return end
    RUN_QUOTE = RUN_QUOTE - 1

    local title = mp.get_property('media-title');
    log.debug(('add_to_history: %s %s'):format(utils.to_string(title), path))

    local stat = utils.file_info(path)
    local type = 'undef'

    if stat and (stat.is_dir or stat.is_file) then

        local cwd = mp.get_property_native('working-directory')
        path = utils.join_path(cwd, path)

        if title == nil or title == '' then
            local _, basename = utils.split_path(path)
            title = basename
        end

        -- title = (title == mp.get_property('filename') and '' or (' (%s)'):format(title));
        -- log.debug(('title: "%s"'):format(title))

        if stat.is_dir then
            type = 'directory'
        else
            type = 'file'
        end

    else
        -- title = title:match('^%s*(.-)%s*$')
        -- title = title:match('^%(*(.-)%)*$')

        local metadata = mp.get_property_native('metadata');
        if metadata then
            if metadata.uploader then
                log.debug(('uploader: %s'):format(utils.to_string(metadata.uploader)))
                title = ('{=%s} %s'):format(metadata.uploader, title)
            else
                log.debug(('metadata: %s'):format(utils.to_string(metadata)))
            end
        end

        if title == nil or title == '' then title = path end

        type = 'youtube'
    end

    local opt = {'--quiet'}
    if mp.get_property_native('osc') == false then table.insert(opt, '--no-osc') end
    if mp.get_property_native('term-osd') == 'force' then table.insert(opt, '--term-osd=force') end
    if mp.get_property_native('audio-display') == false then table.insert(opt, '--no-audio-display') end
    if mp.get_property_native('vid') == false then table.insert(opt, '--vid=no') end

    local ytdl = mp.get_property_native('ytdl-raw-options')
    if ytdl then
        local params = {}
        for k, v in pairs(ytdl) do
            if type == 'youtube' and k == 'format' and v == 'ba/b' then type = 'youtube-music' end
            table.insert(params, ([[%s="%s"]]):format(k, v))
        end
        if #params > 0 then table.insert(opt, ([[--ytdl-raw-options='%s']]):format(table.concat(params, ','))) end
    end

    log.info(('%s: %s -> %s'):format(type, title, path))

    local hist_stat = utils.file_info(MPV_HIST_FILE)
    if not hist_stat then
        local fp = io.open(MPV_HIST_FILE, 'a+')
        if fp then
            fp:write('localtime\ttype\ttitle\tcommand\tpath\n')
            fp:close();
        end
    end

    local fp = io.open(MPV_HIST_FILE, 'a+');
    if fp then
        fp:write(('%s\t%s\t%s\tmpv %s --\t\'%s\'\n'):format(os.date('%Y-%m-%dT%X'), type, title, table.concat(opt, ' '),
            path));
        fp:close();
    end
end

mp.add_hook('on_load', 50, function(hook)
    local path = mp.get_property_native('path')
    log.debug(('on_load: "%s" %s'):format(path, utils.to_string(hook)))
    if not path then return end

    local stat = utils.file_info(path)
    if not stat then return end

    log.debug(('path: %s, stat: %s'):format(path, utils.to_string(stat)))

    if not stat.is_dir then return end

    add_to_history(path)
end)

mp.register_event('file-loaded', function(event)
    local path = mp.get_property('path')
    local file_format = mp.get_property('file-format')
    log.debug(('%s: "%s" %s'):format(utils.to_string(event), path, file_format))
    local audio_codec = mp.get_property('audio-codec-name')
    log.debug(('%s: "%s" %s'):format(utils.to_string(event), path, audio_codec))
    -- local video_format = mp.get_property('video-format')
    -- log.debug(('%s: "%s" %s'):format(utils.to_string(event), path, video_format))

    -- if not video_format or ignore[video_format] ~= nil then return end
    if not audio_codec then return end
    if string.find(path, '/fuse/') then return end

    add_to_history(path)
end)
