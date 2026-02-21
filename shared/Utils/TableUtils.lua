--NOTE: add more table utility functions here in the future.

--@indexed
local module = {}

function module.walkTable(table: {}, keys: {string})
    local cur = table
    for _, exp in ipairs(keys) do
        cur = cur[exp]
    end
    return cur
end

return module