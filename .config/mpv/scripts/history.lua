local mp = require 'mp'

local HISTFILE = os.getenv('XDG_CACHE_HOME') .. '/mpv/history.log';

mp.register_event('file-loaded', function()
    local title, fp;

    local video_format = mp.get_property('video-format')
    if video_format and video_format ~= 'mjpeg' then
        print(video_format)
    else
        return
    end

    title = mp.get_property('media-title');
    title = (title == mp.get_property('filename') and '' or (' (%s)'):format(title));
    if title == '' then title = mp.get_property('path') end

    fp = io.open(HISTFILE, 'a+');
    if fp then
        fp:write(('[%s]%s\tmpv "%s"\n'):format(os.date('%Y-%m-%dT%X'), title, mp.get_property('path')));
        fp:close();
    end
end)
