The default extension for lua-annotations-python; it is a Roblox game framework built around annotations.  

### Game framework
- Services (`@service`) define individual game logic
- Controllers (`@controller`) define per-instance behavior and are automatically mapped to instances containing CollectionService tags
- Dependency injection for services and controllers with automatic load ordering
- Seamless networking bridge; simply import "remote services" (wrappers of RemoteEvents/Functions)