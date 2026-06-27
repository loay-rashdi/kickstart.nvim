local M = {}

-- Types the ref into the tmux pane nvc tagged with @claude (falls back to the
-- last-active pane). No Enter, matching the iTerm path, so you can add context.
local function send_via_tmux(ref)
  local target = '{last}'
  for _, line in ipairs(vim.fn.systemlist({ 'tmux', 'list-panes', '-F', '#{pane_id} #{@claude}' })) do
    local id, tag = line:match('^(%S+)%s+(%S*)')
    if tag == '1' then
      target = id
      break
    end
  end

  vim.fn.system({ 'tmux', 'send-keys', '-t', target, '-l', ref })
  if vim.v.shell_error ~= 0 then
    vim.notify('claude_ref: tmux send-keys failed', vim.log.levels.ERROR)
    return false
  end
  vim.fn.system({ 'tmux', 'select-pane', '-t', target })
  return true
end

local function send_via_iterm(ref)
  local session = vim.env.ITERM_SESSION_ID
  if not session then
    vim.notify('claude_ref: not in tmux or iTerm2 — no Claude pane to target', vim.log.levels.WARN)
    return false
  end
  local guid = session:match(':(.+)$') or session

  local script = vim.fn.stdpath('config') .. '/lua/custom/send_to_claude.applescript'
  local out = vim.fn.system({ 'osascript', script, ref, guid })

  if vim.v.shell_error ~= 0 then
    vim.notify('claude_ref: osascript failed: ' .. out, vim.log.levels.ERROR)
    return false
  elseif vim.trim(out) == 'no-target' then
    vim.notify('claude_ref: no sibling pane found in this tab', vim.log.levels.WARN)
    return false
  end
  return true
end

function M.send()
  local path = vim.fn.expand('%:p')
  if path == '' then
    vim.notify('claude_ref: no file in this buffer', vim.log.levels.WARN)
    return
  end

  local ref = '@' .. path .. ':' .. vim.fn.line('.')
  vim.fn.setreg('+', ref)

  local ok
  if vim.env.TMUX then
    ok = send_via_tmux(ref)
  else
    ok = send_via_iterm(ref)
  end

  if ok then
    vim.notify('Sent ' .. ref .. ' to Claude', vim.log.levels.INFO)
  end
end

return M
