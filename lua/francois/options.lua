local opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs and indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/vim/undodir"
opt.undofile = true

-- cursor line
opt.cursorline = false

--apearance
opt.termguicolors = true
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

-- add - as a word element
opt.iskeyword:append("-")

opt.scrolloff = 8

opt.updatetime = 50
