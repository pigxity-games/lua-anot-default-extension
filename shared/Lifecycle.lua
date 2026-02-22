local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local class = require(script.Parent.Utils.class)
local InstanceUtils = require(script.Parent.Utils.InstanceUtils)

local isServer = RunService:IsServer()
local oppositeEnvName = isServer and "client" or "server" 


local function initService(data, service, ...)
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

local function getRemoteMethod(remote: RemoteFunction | RemoteEvent)
    if remote:IsA("RemoteEvent") then
        if isServer then
            return remote.FireClient
        else
            return remote.FireServer
        end
    else
        if isServer then
            return remote.InvokeClient
        else
            return remote.InvokeServer
        end
    end
end


--@module
local module = {}


--@annotationInit
function module.bindTag(anot, manifest)
    local adornee = anot.getAdornee()
    for _, tag in ipairs(anot.args[1]) do
        InstanceUtils.useCollectionTag(tag, adornee)
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
                injectDeps[oppositeEnvName] = {}

                --service deps
                for _, dep in ipairs(data.depends.services) do
                    injectDeps[dep] = manifest.services[dep].getAdornee()
                end

                --remote deps
                for _, dep in ipairs(data.depends.remotes) do
                    --wrap remote events into a table that is similar to a service
                    local remotesTable = {}
                    local remotes = ReplicatedStorage.Generated.Remotes:WaitForChild(dep)

                    for i, remote in ipairs(remotes:GetChildren()) do
                        local remoteMethod = getRemoteMethod(remote)
                        
                        remotesTable[remote.Name] = function(...)
                            return remoteMethod(remote, ...)
                        end
                    end

                    injectDeps[oppositeEnvName][dep] = remotesTable
                end

                initService(data, service, injectDeps)
            else
                initService(data, service)
            end
        end
    end
end


return module