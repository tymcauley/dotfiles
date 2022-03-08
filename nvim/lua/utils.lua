local utils = {}

local cmd = vim.cmd

-- Define highlight settings
function utils.hi(group, opts)
    local c = "highlight " .. group
    for k, v in pairs(opts) do
        c = c .. " " .. k .. "=" .. v
    end
    cmd(c)
end

return utils
