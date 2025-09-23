local mp = require 'mp'
local log = require 'mp.msg'
local utils = require 'mp.utils'

mp.register_event('file-loaded', function(event)
    log.info(('file-loaded: %s'):format(utils.to_string(event)))
    mp.observe_property('chapter', 'number', function(k, v)
        log.info(('changed: %s'):format(utils.to_string(k)))
        log.info(('chapter: %s'):format(utils.to_string(v)))
    end)
end)

local function reset_position_on_eof(event)
    if event.reason == 'eof' then
        -- This ensures that if file position was saved before it's forgotten on the reaching end
        mp.command('delete-watch-later-config')
    end
end

mp.register_event('end-file', reset_position_on_eof)
