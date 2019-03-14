-- default keybinding s
-- add the following to your input.conf to change the default keybinding:
-- keyname script_binding auto_load_subs
-- requires subliminal -> sudo pip install subliminal

local utils = require 'mp.utils'

function display_error(msg)
  mp.msg.warn("Subtitle download failed: " .. msg)
  mp.osd_message("Subtitle download failed " .. msg)
end

function load_sub_fn()
  path = mp.get_property("path")
  srt_path = string.gsub(path, "%.%w+$", ".srt")
  t = { args = { "subliminal", "download", "-s", "-f", "-l", "en", path } }

  mp.osd_message("Searching subtitle")
  res = utils.subprocess(t)
  if res.error == nil then
    if mp.commandv("sub_add", srt_path) then
      mp.msg.warn("Subtitle download succeeded")
      mp.osd_message("Subtitle '" .. srt_path .. "' download succeeded")
    else
      display_error("Failed to add subtitle to the video")
    end
  else
    display_error("subliminal subprocess failed")
  end
end

mp.add_key_binding("s", "auto_load_subs", load_sub_fn)
