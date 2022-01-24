local Signal = Jello.NewService("Signal")
local SignalListener = Jello.GetService("SignalListener")
Signal.__index = Signal

function Signal.new()
    -- Create a new signal.
    local signal = setmetatable({
        _listeners = {},
    }, Signal)
    setmetatable(signal._listeners, {
        __mode = "v";
    })

    -- Return the signal.
    return signal
end

function Signal:Connect(func)
    -- Create a new signal listener.
    local newSignalListener = SignalListener.new(self, func)
    self.listeners[newSignalListener] = true

    -- Return the signal listener.
    return newSignalListener
end

function Signal:Fire(...)
    -- Fire all listeners.
    for signalListener, _ in pairs(self.listeners) do
        signalListener:Fire(...)
    end
end

function Signal:_Disconnect(signalListener)
    -- Disconnect the signal listener.
    self.listeners[signalListener] = nil
end
