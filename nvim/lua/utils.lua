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

-- Create an autogroup
function utils.create_augroup(name, autocmds)
    cmd("augroup " .. name)
    cmd("autocmd!")
    for _, autocmd in ipairs(autocmds) do
        cmd("autocmd " .. table.concat(autocmd, " "))
    end
    cmd("augroup END")
end

return utils
