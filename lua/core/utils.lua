local utils = {}
local home = os.getenv('HOME')

function utils.get_config_path()
    return home .. '/.config/nvim'
end

return utils