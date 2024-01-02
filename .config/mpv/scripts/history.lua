local mp = require 'mp'
local log = require 'mp.msg'
local utils = require 'mp.utils'

local HISTFILE = os.getenv('XDG_CACHE_HOME') .. '/mpv/history.log';

RUN_QUOTE = 1

local function exec(args)
    log.debug('Running: ' .. table.concat(args, ' '))

    return mp.command_native({
        name = 'subprocess',
        args = args,
        capture_stdout = true,
        capture_stderr = true,
    })
end

local add_to_history = function(path)
    local title = mp.get_property('media-title');
    log.info(('add_to_history: %s %s'):format(utils.to_string(title), path))

    local stat = utils.file_info(path)

    if stat and (stat.is_dir or stat.is_file) then
        if RUN_QUOTE < 1 then return end
        RUN_QUOTE = RUN_QUOTE - 1

        local cwd = mp.get_property_native('working-directory')
        path = utils.join_path(cwd, path)

        if title == nil or title == '' then
            local _, basename = utils.split_path(path)
            title = basename
        end

        -- title = (title == mp.get_property('filename') and '' or (' (%s)'):format(title));
        -- log.info(('title: "%s"'):format(title))

        if stat.is_dir then
            title = 'directory: ' .. title
        else
            title = 'file: ' .. title
        end
    else
        -- title = title:match('^%s*(.-)%s*$')
        -- title = title:match('^%(*(.-)%)*$')

        local command = {'yt-dlp', '--print=%(.{title,uploader})#j', '--', path}
        local result = exec(command)
        if not result.killed_by_us then
            local json = result.stdout
            local parse_err = nil
            if result.status ~= 0 or json == '' then
                json = nil
            elseif json then
                json, parse_err = utils.parse_json(json)
            end

            if json ~= nil and not parse_err then
                log.info(('fetch data: %s'):format(utils.to_string(json)))
                if json.title then title = json.title end
                if json.uploader then title = ('{=%s} %s'):format(json.uploader, title) end
            end
        end

        if title == nil or title == '' then title = path end

        title = 'youtube: ' .. title
    end

    log.info(('add_to_history: "%s" %s'):format(title, path))

    local opt = {'--quiet'}
    if mp.get_property_native('osc') == false then table.insert(opt, '--no-osc') end
    if mp.get_property_native('term-osd') == 'force' then table.insert(opt, '--term-osd=force') end
    if mp.get_property_native('audio-display') == false then table.insert(opt, '--no-audio-display') end

    local fp = io.open(HISTFILE, 'a+');
    if fp then
        fp:write(('[%s]\t%s\tmpv %s --\t"%s"\n'):format(os.date('%Y-%m-%dT%X'), title, table.concat(opt, ' '), path));
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

    add_to_history(path)
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

    add_to_history(path)
end)
