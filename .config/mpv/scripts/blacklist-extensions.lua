local mp = require 'mp'
local options = require 'mp.options'
local log = require 'mp.msg'
local utils = require 'mp.utils'

OPTS = {
    blacklist_str = 'gif,jpg,png,log,cue,txt',
    whitelist_str = '',
    remove_files_without_extension = true,
    oneshot = true,
}

options.read_options(OPTS)

local split = function(input)
    local ret = {}
    for str in string.gmatch(input, '([^,]+)') do ret[#ret + 1] = str end
    return ret
end

OPTS.blacklist = split(OPTS.blacklist_str)
OPTS.whitelist = split(OPTS.whitelist_str)

local exclude
if #OPTS.whitelist > 0 then
    exclude = function(extension)
        for _, ext in pairs(OPTS.whitelist) do if extension == ext then return false end end
        return true
    end
elseif #OPTS.blacklist > 0 then
    exclude = function(extension)
        for _, ext in pairs(OPTS.blacklist) do if extension == ext then return true end end
        return false
    end
else
    return
end

local should_remove = function(filename)
    -- log.info(('got: %s'):format(filename))
    if string.find(filename, '://') then return false end

    local stat = utils.file_info(filename)
    if stat and stat.is_file then
        local extension = string.match(filename, '%.([^./]+)$')
        if not extension and OPTS.remove_files_without_extension then return true end
        if extension and exclude(string.lower(extension)) then return true end
    else
        if stat and stat.is_dir then
            local _, basename = utils.split_path(filename)
            if basename == '@eaDir' then return true end
        end
    end

    return false
end

-- local process = function(playlist_count)
--     log.info(('playlist size: %s'):format(playlist_count))
--     if playlist_count < 2 then return end
--     if OPTS.oneshot then mp.unobserve_property(OBSERVE) end
--     local playlist = mp.get_property_native('playlist')
--     local removed = 0
--     for i = #playlist, 1, -1 do
--         if should_remove(playlist[i].filename) then
--             log.info(('removed file: %s'):format(playlist[i].filename))
--             mp.commandv('playlist-remove', i - 1)
--             removed = removed + 1
--         end
--     end
--     if removed == #playlist then log.warn('removed eveything from the playlist') end
-- end

-- OBSERVE = function(_, v) process(v) end

local observe_playlist = function(playlist)
    -- log.info(('playlist: %s'):format(utils.to_string(playlist)))
    if #playlist == 1 then return end
    local removed = 0
    for i = #playlist, 1, -1 do
        if should_remove(playlist[i].filename) then
            log.info(('removed file: %s'):format(playlist[i].filename))
            mp.commandv('playlist-remove', i - 1)
            removed = removed + 1
        end
    end
    if removed == #playlist then log.warn('removed eveything from the playlist') end
end

-- mp.observe_property('playlist-count', 'number', OBSERVE)
mp.observe_property('playlist', 'native', function(_, v) observe_playlist(v) end)
