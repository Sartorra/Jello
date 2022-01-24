-- This is the first file loaded.
local FileSystem = {}

-- Import base libraries.
FileSystem.List = fs.list
FileSystem.Exists = fs.exists
FileSystem.IsDir = fs.isDir
FileSystem.IsReadOnly = fs.isReadOnly
FileSystem.GetName = fs.getName
FileSystem.GetDrive = fs.getDrive
FileSystem.GetSize = fs.getSize
FileSystem.GetFreeSpace = fs.getFreeSpace
FileSystem.MakeDirectory = fs.makeDir
FileSystem.Move = fs.move
FileSystem.Copy = fs.copy
FileSystem.Delete = fs.delete
FileSystem.Open = fs.open
FileSystem.Find = fs.find
FileSystem.GetDirectory = fs.getDir


function FileSystem.Require(file)
    -- Check if file exists.
    if not FileSystem.Exists(file) then
        error("File not found: " .. file)
    end

    -- Get  file handle.
    local fileHandle = FileSystem.Open(file, "r");

    -- Load file contents.
    local fileContents = fileHandle.readAll();

    -- Close file handle.
    fileHandle.close();

    -- Return file contents as a function.
    return loadstring(fileContents);
end

return FileSystem