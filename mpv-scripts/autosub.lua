-- default keybinding s
-- add the following to your input.conf to change the default keybinding:
-- keyname script_binding auto_load_subs
-- requires subliminal -> sudo pip install subliminal

local utils = require 'mp.utils'

function log(msg)
  mp.msg.warn(msg)
  mp.osd_message(msg)
end

function log_error(msg)
  log("Subtitle download FAILED : " .. msg)
end

function load_sub_fn()
  path = mp.get_property("path")
  srt_path = string.gsub(path, "%.%w+$", ".srt")
  t = { args = { "subliminal", "download", "-s", "-f", "-l", "en", path } }

  mp.osd_message("Searching subtitle")
  res = utils.subprocess(t)

  if res.error ~= nil then
    log_error("subliminal subprocess failed")
    do return end
  end

  if not string.find(res.stdout, 'Downloaded 1 subtitle') then
    log_error("Failed to find subtitle for " .. path)
    do return end
  end

  if mp.commandv("sub_add", srt_path) then
    log("Subtitle download succeeded. Adding " .. srt_path .. " to the video.")
  else
    log_error("Failed to add " .. srt_path .. " to the video")
  end  
end

mp.add_key_binding("s", "auto_load_subs", load_sub_fn)
