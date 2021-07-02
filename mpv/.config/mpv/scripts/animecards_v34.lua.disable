------------- Instructions -------------
-- -- Video Demonstration: https://www.youtube.com/watch?v=M4t7HYS73ZQ
--
-- -- Open clipboard inserter
-- -- Wait for unknown word and add it to anki through yomichan
-- -- Select all the subtitle lines to add to the card.
-- -- Ctrl + c
-- -- Tab back to MPV and Ctrl + v
-- -- Done. The lines, their respective Audio and the current paused image
-- -- will be added to the back of the card.
-- -- Ctrl + t will toggle clipboard inserter on and off.
-- -- Be sure to configure the user config below.
---------------------------------------

------------- Credits -------------
-- This script was made by users of 4chan's Daily Japanese Thread (DJT) on /jp/
-- More information can be found here http://animecards.site/
-- Message @Anacreon with bug reports and feature requests on Discord (https://discord.gg/5K5jQjG) or 4chan (https://boards.4channel.org/jp/#s=djt)
--
-- If you like this work please consider subscribing on Patreon!
-- https://www.patreon.com/Quizmaster
------------------------------------

local utils = require 'mp.utils'
local msg = require 'mp.msg'

------------- User Config -------------
-- Set these to match your field names in Anki
local FRONT_FIELD = "front"
local SENTENCE_AUDIO_FIELD = "SentenceAudio"
local SENTENCE_FIELD = "Sentence"
local IMAGE_FIELD = "Picture"
-- Anki collection media path. Ensure Anki username is correct.
-- Linux users will want to set this to something like:
-- utils.join_path(os.getenv('HOME'), [[.local/share/Anki2/User 1/collection.media]])
-- and MacOS will need something like:
-- utils.join_path(os.getenv('HOME'), [[Library/Application Support/Anki2/User 1/collection.media]])
local prefix = utils.join_path(os.getenv('XDG_DATA_HOME'), [[Anki2/User 1/collection.media]])
-- Optional padding and fade settings in seconds.
-- Padding grabs extra audio around your selected subs.
-- Fade does a volume fade effect at the beginning and end of the resulting audio.
local AUDIO_CLIP_FADE = 0.2
local AUDIO_CLIP_PADDING = 0.75
-- Optional fetch Forvo word audio if word audio field is empty in Anki.
local WORD_AUDIO_FIELD = ""
-- Optional play sentence and forvo audio automatically after card update
local AUTOPLAY_AUDIO = true
-- Optional screenshot image format.
-- Change to "jpeg" if you plan to view cards on iOS or Mac.
local IMAGE_FORMAT = "jpg"
-- Optional set to true if you want your volume in mpv to affect Anki card volume.
local USE_MPV_VOLUME = false
---------------------------------------

local subs = {}
local enable_subs_to_clip = true
local debug_mode = false
local use_powershell_clipboard = nil

if unpack ~= nil then table.unpack = unpack end

local o = {}
local platform
if mp.get_property_native('options/vo-mmcss-profile', o) ~= o then
  platform = 'windows'
elseif mp.get_property('options/cocoa-force-dedicated-gpu', o) ~= o then
  platform = 'macos'
else
  platform = 'linux'
end

local function dlog(...)
  if debug_mode then
    print(...)
  end
end

local function clean(s)
  for _, ws in ipairs({'%s', ' ', '᠎', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '​', ' ', ' ', '　', '﻿'}) do
    s = s:gsub(ws..'+', "")
  end
  return s
end

local function get_name(s, e)
  return mp.get_property("filename"):gsub('%W','').. tostring(s) .. tostring(e)
end

local function get_clipboard()
  local res
  if platform == 'windows' then
    res = utils.subprocess({ args = {
      'powershell', '-NoProfile', '-Command', [[& {
        Trap {
          Write-Error -ErrorRecord $_
          Exit 1
        }
        $clip = ""
        if (Get-Command "Get-Clipboard" -errorAction SilentlyContinue) {
          $clip = Get-Clipboard -Raw -Format Text -TextFormatType UnicodeText
        } else {
          Add-Type -AssemblyName PresentationCore
          $clip = [Windows.Clipboard]::GetText()
        }
        $clip = $clip -Replace "`r",""
        $u8clip = [System.Text.Encoding]::UTF8.GetBytes($clip)
        [Console]::OpenStandardOutput().Write($u8clip, 0, $u8clip.Length)
      }]]
    } })
  elseif platform == 'macos' then
    return io.popen('LANG=en_US.UTF-8 pbpaste'):read("*a")
  else
    res = utils.subprocess({ args = {
      'xclip', '-selection', 'clipboard', '-out'
    } })
  end
  if not res.error then
    return res.stdout
  end
end

local function powershell_set_clipboard(text)
  utils.subprocess({ args = {
    'powershell', '-NoProfile', '-Command', [[Set-Clipboard -Value @"]] .. "\n" .. text .. "\n" .. [["@]]
  }})
end

local function cmd_set_clipboard(text)
  local cmd = 'echo ' .. text .. ' | clip';
  mp.command("run cmd /D /C " .. cmd);
end

local function determine_clip_type()
  powershell_set_clipboard([[Anacreon様]])
  use_powershell_clipboard = get_clipboard() == [[Anacreon様]]
end

local function linux_set_clipboard(text)
  os.execute('xclip -selection clipboard <<EOF\n' .. text .. '\nEOF\n')
end

local function macos_set_clipboard(text)
  os.execute('export LANG=en_US.UTF-8; cat <<EOF | pbcopy\n' .. text .. '\nEOF\n')
end

local function record_sub(_, text)
  if text and mp.get_property_number('sub-start') and mp.get_property_number('sub-end') then
    local sub_delay = mp.get_property_native("sub-delay")
    local audio_delay = mp.get_property_native("audio-delay")
    local newtext = clean(text)
    if newtext == '' then
      return
    end

    subs[newtext] = { mp.get_property_number('sub-start') + sub_delay - audio_delay, mp.get_property_number('sub-end') + sub_delay - audio_delay }
    dlog(string.format("%s -> %s : %s", subs[newtext][1], subs[newtext][2], newtext))
    if enable_subs_to_clip then
      -- Remove newlines from text before sending it to clipboard.
      -- This way pressing control+v without copying from texthooker page
      -- will always give last line.
      text = string.gsub(text, "[\n\r]+", " ")
      if platform == 'windows' then
        if use_powershell_clipboard == nil then
          determine_clip_type()
        end
        if use_powershell_clipboard then
          powershell_set_clipboard(text)
        else
          cmd_set_clipboard(text)
        end
      elseif platform == 'macos' then
        macos_set_clipboard(text)
      else
        linux_set_clipboard(text)
      end
    end
  end
end

local function clean_audio(filename)
  local destination = utils.join_path(prefix, 'normalize_tmp.mp3')
  mp.commandv(
    'run',
    'mpv',
    filename,
    '--af-append=lowpass=1000',
    '--af-append=highpass=200',
    '--af-append=areverse',
    '--af-append=silenceremove=1:0:-35dB',
    '--af-append=areverse',
    string.format('-o=%s', destination)
  )
  local args
  if platform == 'windows' then
    args = {'powershell', '-NoProfile', '-Command', [[& {
      while (!(Test-Path "]] .. destination .. [[")) { Start-Sleep -Milliseconds 100 }
      }]]
    }
    utils.subprocess({ args = args, capture_stderr = true })
    args = {'powershell', '-NoProfile', '-Command', [[& {
      mv -Force "]] .. destination .. [[" "]] .. filename .. [["
      }]]
    }
    utils.subprocess({ args = args, capture_stderr = true })
  else
    args = {'/bin/sh', '-c', [[
until [ -f "]] .. destination .. [[" ] ; do sleep 1; done ]]}
    utils.subprocess({ args = args, capture_stderr = true })
    args = {'mv', destination, filename}
    utils.subprocess({ args = args, capture_stderr = true })
  end
end

local function create_audio(s, e)

  if s == nil or e == nil then
    return
  end

  local name = get_name(s, e)
  local destination = utils.join_path(prefix, name .. '.mp3')
  s = s - AUDIO_CLIP_PADDING
  local t = e - s + AUDIO_CLIP_PADDING
  local source = mp.get_property("path")
  local aid = mp.get_property("aid")

  local tracks_count = mp.get_property_number("track-list/count")
  for i = 1, tracks_count do
    local track_type = mp.get_property(string.format("track-list/%d/type", i))
    local track_selected = mp.get_property(string.format("track-list/%d/selected", i))
    if track_type == "audio" and track_selected == "yes" then
      if mp.get_property(string.format("track-list/%d/external-filename", i), o) ~= o then
        source = mp.get_property(string.format("track-list/%d/external-filename", i))
        aid = 'auto'
      end
      break
    end
  end


  local cmd = {
    'run',
    'mpv',
    source,
    '--loop-file=no',
    '--video=no',
    '--no-ocopy-metadata',
    '--no-sub',
    '--audio-channels=1',
    string.format('--start=%.3f', s),
    string.format('--length=%.3f', t),
    string.format('--aid=%s', aid),
    string.format('--volume=%s', USE_MPV_VOLUME and mp.get_property('volume') or '100'),
    string.format("--af-append=afade=t=in:curve=ipar:st=%.3f:d=%.3f", s, AUDIO_CLIP_FADE),
    string.format("--af-append=afade=t=out:curve=ipar:st=%.3f:d=%.3f", s + t - AUDIO_CLIP_FADE, AUDIO_CLIP_FADE),
    string.format('-o=%s', destination)
  }
  mp.commandv(table.unpack(cmd))
  dlog(utils.to_string(cmd))
end

local function create_screenshot(s, e)
  local source = mp.get_property("path")
  local img = utils.join_path(prefix, get_name(s,e) .. '.' .. IMAGE_FORMAT)

  local cmd = {
    'run',
    'mpv',
    source,
    '--loop-file=no',
    '--audio=no',
    '--no-ocopy-metadata',
    '--no-sub',
    '--frames=1',
  }
  if IMAGE_FORMAT == 'webp' then
    table.insert(cmd, '--ovc=libwebp')
    table.insert(cmd, '--ovcopts-add=lossless=0')
    table.insert(cmd, '--ovcopts-add=compression_level=6')
    table.insert(cmd, '--ovcopts-add=preset=drawing')
  elseif IMAGE_FORMAT == 'png' then
    table.insert(cmd, '--vf-add=format=rgb24')
  end
  table.insert(cmd, '--vf-add=scale=480*iw*sar/ih:480')
  table.insert(cmd, string.format('--start=%.3f', mp.get_property_number("time-pos")))
  table.insert(cmd, string.format('-o=%s', img))
  mp.commandv(table.unpack(cmd))
  dlog(utils.to_string(cmd))
end

local function anki_connect(action, params)
  local request = utils.format_json({action=action, params=params, version=6})
  local args
  if platform == 'windows' then
    args = {
      'powershell', '-NoProfile', '-Command', [[& {
      $data = Invoke-RestMethod -Uri http://127.0.0.1:8765 -Method Post -ContentType 'application/json; charset=UTF-8' -Body @"]] .. "\n" .. request .. "\n" .. [["@ | ConvertTo-Json -Depth 10
      $u8data = [System.Text.Encoding]::UTF8.GetBytes($data)
      [Console]::OpenStandardOutput().Write($u8data, 0, $u8data.Length)
      }]]
    }
  else
    args = {'curl', '-s', 'localhost:8765', '-X', 'POST', '-d', request}
  end

  local result = utils.subprocess({ args = args, cancellable = true, capture_stderr = true })
  dlog(result.stdout)
  dlog(result.stderr)
  return utils.parse_json(result.stdout)
end

local function url_enc(url)
  local char_to_hex = function(c)
    return string.format("%%%02X", string.byte(c))
  end
  if url == nil then
    return
  end
  url = url:gsub("\n", "\r\n")
  url = url:gsub("([^%w _%%%-%.~])", char_to_hex)
  url = url:gsub(" ", "+")
  return url
end

local function get_forvo_audio(word)
  local function b64dec(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
      if (x == '=') then return '' end
      local r,f='',(b:find(x)-1)
      for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
      return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
      if (#x ~= 8) then return '' end
      local c=0
      for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
      return string.char(c)
    end))
  end

  local args
  if platform == 'windows' then
    args = {
      'powershell', '-NoProfile', '-Command', [[& {
      [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
      $data = Invoke-WebRequest -Uri "https://forvo.com/search/]] .. url_enc(word) .. [[/ja/" -Headers @{
      "method"="GET"
      "authority"="forvo.com"
      "scheme"="https"
      "cache-control"="max-age=0"
      "upgrade-insecure-requests"="1"
      "user-agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36 Edg/86.0.622.58"
      "accept"="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
      "sec-fetch-site"="same-origin"
      "sec-fetch-mode"="navigate"
      "sec-fetch-user"="?1"
      "sec-fetch-dest"="document"
      "referer"="https://forvo.com/"
      "accept-encoding"="gzip, deflate, br"
      "accept-language"="en-US,en;q=0.9"
    }
      $u8data = [System.Text.Encoding]::UTF8.GetBytes($data)
      [Console]::OpenStandardOutput().Write($u8data, 0, $u8data.Length)
      }]]
    }
  else
    args = {
      'curl', 'https://forvo.com/search/' .. word .. '/ja/',
      '-H', 'authority: forvo.com',
      '-H', 'pragma: no-cache',
      '-H', 'cache-control: no-cache',
      '-H', 'dnt: 1',
      '-H', 'upgrade-insecure-requests: 1',
      '-H', 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36',
      '-H', 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      '-H', 'sec-fetch-site: same-origin',
      '-H', 'sec-fetch-mode: navigate',
      '-H', 'sec-fetch-user: ?1',
      '-H', 'sec-fetch-dest: document',
      '-H', 'referer: https://forvo.com',
      '-H', 'accept-language: en-US,en;q=0.9,ny;q=0.8,ja;q=0.7,es;q=0.6'
    }
  end

  local result = utils.subprocess({ args = args, cancellable = true, capture_stderr = true })
  dlog(result.stdout)
  dlog(result.stderr)

  local audio_url
  for thing in string.match(result.stdout, "Play(.-)span"):gmatch("[^']+") do
    local url_part = b64dec(thing)
    if string.match(url_part, 'mp3$') then
      audio_url = 'https://audio00.forvo.com/mp3/' .. url_part
      break
    end
  end

  if platform == 'windows' then
    args = {
      'powershell', '-NoProfile', '-Command', [[& {
      [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
      Invoke-WebRequest -Uri "]] .. audio_url .. [[" -OutFile "]] .. utils.join_path(prefix, "forvo_" .. word .. '.mp3') .. [["
    }]]
    }
  else
    args = {'curl', audio_url, '-o',  utils.join_path(prefix, "forvo_" .. word .. '.mp3')}
  end

  utils.subprocess({ args = args, cancellable = true, capture_stderr = true })
  dlog(result.stdout)
  dlog(result.stderr)

  clean_audio(utils.join_path(prefix, "forvo_" .. word .. '.mp3'))
  return utils.join_path(prefix, "forvo_" .. word .. '.mp3')
end

local function add_to_last_added(ifield, afield, tfield)
  local forvo_path = nil
  local added_notes = anki_connect('findNotes', {query='added:1'})["result"]
  table.sort(added_notes)
  local noteid = added_notes[#added_notes]
  local note = anki_connect('notesInfo', {notes={noteid}})

  if note ~= nil then
    local word = note["result"][1]["fields"][FRONT_FIELD]["value"]
    local new_fields = {
      [SENTENCE_AUDIO_FIELD]=afield,
      [SENTENCE_FIELD]=tfield,
      [IMAGE_FIELD]=ifield
    }

    if WORD_AUDIO_FIELD ~= "" then
      local wafield = note["result"][1]["fields"][WORD_AUDIO_FIELD]["value"]
      if wafield == "" then
        local success, res = pcall(get_forvo_audio, word)
        if success then
          forvo_path = res
          new_fields[WORD_AUDIO_FIELD] = "[sound:forvo_" .. word .. ".mp3]"
        end
      end
    end

    anki_connect('updateNoteFields', {
      note={
        id=noteid,
        fields=new_fields
      }
    })

    mp.osd_message("Updated note: " .. word, 3)
    msg.info("Updated note: " .. word)
  end

  return forvo_path
end

local function get_extract()
  local lines = get_clipboard()
  local e = 0
  local s = 0
  for line in lines:gmatch("[^\r\n]+") do
    line = clean(line)
    dlog(line)
    if subs[line]~= nil then
      if subs[line][1] ~= nil and subs[line][2] ~= nil then
        if s == 0 then
          s = subs[line][1]
        else
          s = math.min(s, subs[line][1])
        end
        e = math.max(e, subs[line][2])
      end
    else
      mp.osd_message("ERR! Line not found: " .. line, 3)
      return
    end
  end
  dlog(string.format('s=%d, e=%d', s, e))
  if e ~= 0 then
    create_screenshot(s, e)
    create_audio(s, e)
    local ifield = '<img src='.. get_name(s,e) ..'.' .. IMAGE_FORMAT .. '>'
    local afield = "[sound:".. get_name(s,e) .. ".mp3]"
    local tfield = string.gsub(string.gsub(lines,"\n+", "<br />"), "\r", "")
    local forvo_path = add_to_last_added(ifield, afield, tfield)
    if AUTOPLAY_AUDIO then
      local name = get_name(s, e)
      local audio = utils.join_path(prefix, name .. '.mp3')
      local cmd = {'run', 'mpv'}
      if forvo_path ~= nil then
        table.insert(cmd, forvo_path)
      end
      table.insert(cmd, audio)
      table.insert(cmd, '--loop-file=no')
      table.insert(cmd, '--load-scripts=no')
      mp.commandv(table.unpack(cmd))
    end
  end
end

local function ex()
  if debug_mode then
    get_extract()
  else
    pcall(get_extract)
  end
end

local function rec(...)
  if debug_mode then
    record_sub(...)
  else
    pcall(record_sub, ...)
  end
end

local function toggle_sub_to_clipboard()
  enable_subs_to_clip = not enable_subs_to_clip
  mp.osd_message("Clipboard inserter " .. (enable_subs_to_clip and "activated" or "deactived"), 3)
end

local function toggle_debug_mode()
  debug_mode = not debug_mode
  mp.osd_message("Debug mode " .. (debug_mode and "activated" or "deactived"), 3)
end

local function clear_subs(_)
  subs = {}
end

mp.observe_property("sub-text", 'string', rec)
mp.observe_property("filename", "string", clear_subs)

mp.add_key_binding("ctrl+v", "update-anki-card", ex)
mp.add_key_binding("ctrl+t", "toggle-clipboard-insertion", toggle_sub_to_clipboard)
mp.add_key_binding("ctrl+d", "toggle-debug-mode", toggle_debug_mode)
mp.add_key_binding("ctrl+V", ex)
mp.add_key_binding("ctrl+T", toggle_sub_to_clipboard)
mp.add_key_binding("ctrl+D", toggle_debug_mode)
