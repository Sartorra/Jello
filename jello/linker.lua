local LoadedServices = {}
local Basepath = "jello/services/"

local Linker = {}

function Linker:NewService(serviceName)
    -- Check if the service is already loaded.
    assert(not LoadedServices[serviceName], "Service already loaded: " .. serviceName)

    -- Create a new service table.
    local serviceTable = {}
    LoadedServices[serviceName] = serviceTable

    -- Return the service table.
    return serviceTable
end

function Linker:GetService(serviceName)
    -- Check if service is loaded.
    if LoadedServices[serviceName] then
        return LoadedServices[serviceName]
    end

    -- The service is not loaded.
    local serviceFile = Basepath .. serviceName .. ".lua"
    Bootloader.runFileInEnviroment(serviceFile, Bootloader.getNewEnviroment())

    -- Return the service.
    return LoadedServices[serviceName]
end

function Linker:SetBasePath(path)
    -- Set the base path.
    Basepath = path
end

LoadedServices["Linker"] = Linker
LoadedServices["FileSystem"] = FileSystem

return Linker