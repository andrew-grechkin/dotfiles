local mp = require 'mp'
local log = require 'mp.msg'
local utils = require 'mp.utils'

local function Set(t)
    local set = {}
    for _, v in pairs(t) do set[v] = true end
    return set
end

EXTENSIONS = Set {'m4b'}

local function get_extension(path)
    local match = string.match(path, '%.([^%.]+)$')
    if match == nil then
        return 'nomatch'
    else
        return match
    end
end

mp.add_hook('on_load_fail', 50, function(hook)
    local path = mp.get_property_native('path')
    log.debug(('on_load_fail: "%s" %s'):format(path, utils.to_string(hook)))
    if not path then return end

    local stat = utils.file_info(path)
    if not stat then return end

    log.debug(('path: %s, stat: %s'):format(path, utils.to_string(stat)))

    if not stat.is_dir then return end

    local files = utils.readdir(path, 'files')
    if not files then return end
    for _, name in pairs(files) do
        if (EXTENSIONS[string.lower(get_extension(name))]) then
            log.info(('explicitly: %s'):format(utils.to_string(name)))
            mp.commandv('loadfile', utils.join_path(path, name), 'append')
        end
    end
end)
