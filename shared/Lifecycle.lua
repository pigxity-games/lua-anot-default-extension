local class = require(script.Parent.Utils.class)
local InstanceUtils = require(script.Parent.Utils.InstanceUtils)


--@module
local module = {}


function initService(data, service, ...)
    if data.kind == "service" then
        service:_init(...)
    else
        class(service)
        for _, tag in ipairs(data.tags) do
            InstanceUtils.useCollectionTag(tag, function(inst)
                service.new(inst)
            end)
        end
    end
end


--@onInit
function module.initServices(manifest)
    for _, serviceName in ipairs(manifest.load_order) do
        local data = manifest.services[serviceName]
        local service = data.getAdornee()

        if service._init then
            --build deps list
            if #data.depends.services > 0 or #data.depends.remotes > 0 then
                local injectDeps = {}

                --service deps
                for _, dep in ipairs(data.depends.services) do
                    injectDeps[dep] = manifest.services[dep].getAdornee()
                end

                --remote deps
                for _, dep in ipairs(data.depends.remotes) do
                    --TODO 
                    --injectDeps[dep] = {wrap remote events into a table that is similar to a service}
                end

                initService(data, service, injectDeps)
            else
                initService(data, service)
            end
        end
    end
end

return module