local SignalListener = Jello.NewService("SignalListener")
SignalListener.__index = SignalListener

function SignalListener.new(signal, connectedFunction)
    -- Create a new signal listener.
    local signalListener = setmetatable({
        _signal = signal;
        _connectedFunction = connectedFunction;
    }, SignalListener)


    -- Return the signal listener.
    return signalListener
end

function SignalListener:Disconnect()
    -- Disconnect the signal listener.
    self._signal:_Disconnect(self)
end

function SignalListener:Fire(...)
    -- Fire the signal listener.
    local success, error = pcall(self._connectedFunction, ...)

    -- Check if it failed.
    if success then return end

    -- Print the error.
    error(error)
end