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
