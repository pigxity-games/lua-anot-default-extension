local CollectionService = game:GetService("CollectionService")

--@indexed, Utils
local module = {}

--calls consumer for each current and future instance that has tag
function module.useCollectionTag(tag: string, consumer: (Instance) -> ())
	--current instances
	for _, inst in ipairs(CollectionService:GetTagged(tag)) do
		consumer(inst)
	end

	--future instances
	CollectionService:GetInstanceAddedSignal(tag):Connect(consumer)
end

--sets the properties of a instance based on values of its attributes
function module.processAttributes(instance: Instance, attributes: { string })
	for _, attrName in ipairs(attributes) do
		local instAttr = instance:GetAttribute(attrName)

		if instAttr ~= nil then
			instance[attrName] = instAttr
		end
	end
end

--creates a temporary, invisible part at a location
--this is required as a variable itself cannot be tweened; a part is required as sort of a "container".
function module.createTempPart(location: CFrame)
	local tempPart = Instance.new("Part")

	tempPart.Parent = workspace
	tempPart.CFrame = location
	tempPart.Anchored = true
	tempPart.Transparency = 1

	return tempPart
end

--calls consumer for each descendant of instance, including the instance itself.
function module.itAndDescendants(inst: Instance, consumer: (Instance) -> ())
	consumer(inst)

	for _, child in ipairs(inst:GetDescendants()) do
		consumer(child)
	end
end

--
function module.getOrCreateInstance(parent: Instance, childName: string, className: string): Instance
	local child = parent:FindFirstChild(childName)

	if child then
		return child
	else
		return Instance.new(className)
	end
end

return module
