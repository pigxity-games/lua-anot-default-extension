--@module
local module = {}

--@onPostInit
function module.postInit(manifest)
    for deps, serviceAnot in pairs(manifest.services) do
        local service = serviceAnot.adornee

        if service._init then
            --build deps list
            local inject_deps = {}
            if deps then
                for i, dep in ipairs(deps) do
                    inject_deps[i] = manifest.services[dep]
                end
            end

            service._init(deps)
        end
    end
end

return module