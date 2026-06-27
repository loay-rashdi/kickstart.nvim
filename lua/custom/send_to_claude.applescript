on run argv
  set theText to item 1 of argv
  set myID to item 2 of argv
  tell application "iTerm2"
    repeat with w in windows
      repeat with t in tabs of w
        set sess to sessions of t
        set hasMe to false
        repeat with s in sess
          if (unique id of s) is myID then set hasMe to true
        end repeat
        if hasMe then
          repeat with s in sess
            if (unique id of s) is not myID then
              tell s to write text theText newline no
              select s
              return "ok"
            end if
          end repeat
        end if
      end repeat
    end repeat
  end tell
  return "no-target"
end run
