local TableUtils = require(script.Parent.Utils.TableUtils)

--@module
local module = {}


--@onPostInit
function module.postInit(manifest)
    for _, data in pairs(manifest.services) do
        local service = require(data.module)
        if data.exports then
            service = TableUtils.walkTable(service, data.exports)
        end

        if service._init then
            --build deps list
            if #data.depends.services > 0 or #data.depends.remotes > 0 then
                local inject_deps = {}

                --service deps
                for _, dep in ipairs(data.depends.services) do
                    inject_deps[dep] = manifest.services[dep]
                end

                --remote deps
                for _, dep in ipairs(data.depends.remotes) do
                    --TODO 
                    --inject_deps[dep] = 
                end

                service.init(inject_deps)
            else
                service._init()
            end
        end
    end
end

return module