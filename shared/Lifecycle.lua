--@module
local module = {}

--@onPostInit
function module.postInit(manifest)
    for _, data in pairs(manifest.services) do
        local service = require(data.module)

        if service._init then
            --build deps list
            if #data.depends > 0 then
                local inject_deps = {}
                for i, dep in ipairs(data.depends) do
                    if dep.
                    inject_deps[i] = manifest.services[dep]
                end
                service.init(inject_deps)
            else
                service._init()
            end
        end
    end
end

return module