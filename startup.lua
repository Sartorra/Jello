-- Jello bootloader

-- enviroment table.
local env = getfenv()
env.Jello = {}
env.fs = nil

setmetatable(env, {
    __mode = "k";
})

-- Helper functions
local function loadFile(file)
    -- Get  file handle.
    local fileHandle = fs.open(file, "r");

    -- Load file contents.
    local fileContents = fileHandle.readAll();

    -- Close file handle.
    fileHandle.close();

    -- Return file contents as a function.
    return loadstring(fileContents, file);
end

local function copyTable(t)
    -- Create a new table.
    local newTable = {}

    -- Copy all values from the table.
    for key, value in pairs(t) do
        if type(value) == "table" then
            newTable[key] = copyTable(value)
        else
            newTable[key] = value
        end
    end

    -- Return the new table.
    return newTable
end

local function runFileInEnviroment(file, env)
    -- Create a new enviroment.
    local newEnv = copyTable(env)

    -- Load the file.
    local fileContents = loadFile(file)

    -- Set the enviroment.
    setfenv(fileContents, newEnv)

    -- Run the file.
    return fileContents()
end

local function getNewEnviroment(override)
    -- Create a new enviroment.
    local newEnv = copyTable(env)

    -- Override the enviroment.
    if override then
        for key, value in pairs(override) do
            newEnv[key] = value
        end
    end

    -- Return the new enviroment.
    return newEnv
end

-- Fetch the file system table.
local fileSystem = loadFile("jello/filesystem.lua")()

-- Create a custom environment for the linker.
local linkerEnviroment = getNewEnviroment(
    {
        FileSystem = fileSystem;
        Bootloader = getfenv();
    }
)


-- Load the linker.
local linker = runFileInEnviroment("jello/linker.lua", linkerEnviroment)

-- Load the services.
local fileList = fileSystem.List("jello/services/")

for _, file in ipairs(fileList) do
    -- Get the service.
    local service = linker:GetService(file)
end

-- Set base path.
linker:SetBasePath("services/")

-- Add linker to jello enviroment.
env.Jello.GetService = linker.GetService
env.Jello.NewService = linker.NewService

print("Jello loaded.\n Loading bootup file...")

-- Load bootup.
local bootup = runFileInEnviroment("bootup.lua", getNewEnviroment())