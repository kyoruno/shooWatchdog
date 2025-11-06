Config = {}

function Config.fileExists(path)
	local f = io.open(path, "r")
	return f ~= nil and io.close(f)
end

function Config.createConfig(path, data)
	if Config.fileExists(path) then
		return
	end

	local file = io.open(path, "w")
	if file == nil then
		return
	end

    local jconfig = json.encode(data)
	file:write(jconfig)
	file:close()
end

function Config.loadFile(path)
	local file = io.open(path, "r")
    if file == nil then
        return
    end

	local settings = json.decode(file:read("*a"))
	file:close()
	return settings
end

function Config.saveFile(path, data)
	local file = io.open(path, "w")
    if file == nil then
        return
    end

	local jconfig = json.encode(data)
	file:write(jconfig)
	file:close()
end

return Config
