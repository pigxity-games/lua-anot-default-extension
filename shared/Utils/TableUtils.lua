--@indexed, Utils
local module = {}

--similar to java's stream.map function; K and V is the original table's keys, and R is the new table's value type.
function module.map<K, V, R>(t: { [K]: V }, callback: (K, V) -> R): { [K]: R }
	local returned: { [K]: R } = {}
	for key, value in pairs(t) do
		returned[key] = callback(key, value)
	end
	return returned
end

return module
