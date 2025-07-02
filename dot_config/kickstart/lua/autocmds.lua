-- Disable auto comments on new line
vim.cmd 'autocmd BufNewFile,BufRead,BufEnter,FileType * set formatoptions-=cro'
vim.cmd 'autocmd BufNewFile,BufRead,BufEnter,FileType * setlocal formatoptions-=cro'

-- Line numbers
vim.cmd 'autocmd InsertEnter * set nu nornu'
vim.cmd 'autocmd InsertLeave * set nu rnu'

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_user_command('SearchInBrowser', function(args)
  local config = {
    default_engine = 'google',
    query_map = {
      google = 'https://www.google.com/search?q=%s',
    },
  }

  local function looks_like_url(input)
    local pat = '[%w%.%-_]+%.[%w%.%-_/]+'
    return input:match(pat) ~= nil
  end

  local function extract_prefix(input)
    local pat = '@(%w+)'
    local prefix = input:match(pat)
    if not prefix or not config.query_map[prefix] then
      return vim.trim(input), config.default_engine
    end
    local query = input:gsub('@' .. prefix, '')
    return vim.trim(query), prefix
  end

  local function query_browser(input)
    local q, prefix = extract_prefix(input)
    if not looks_like_url(input) then
      local format = config.query_map[prefix]
      q = format:format(vim.uri_encode(q))
    end
    vim.ui.open(q)
  end

  vim.ui.input({ prompt = 'Search: ' }, function(input)
    if input then
      query_browser(input)
    end
  end)
end, {
  desc = 'Search in browser',
})

-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_buf_call(args.buf, function()
        vim.cmd 'normal! g`"zz'
      end)
    end
  end,
})
