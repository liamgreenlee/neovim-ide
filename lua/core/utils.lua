local utils = {}
local home = os.getenv('HOME')

function utils.get_config_path()
    return vim.fn.stdpath('config') .. '/.config/nvim'
end

return utils