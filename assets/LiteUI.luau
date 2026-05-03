local LiteUI = {}

local Element = {}
Element.__index = Element

local function isInstance(val)
    return typeof(val) == "Instance"
end

function LiteUI.new(className, props) -- create a root
    return Element.new(className, props, nil)
end

function LiteUI.Element(className, props, parent) -- create element setting parent manually
    return Element.new(className, props, parent)
end

function Element.new(className, props, parent)
    local self = setmetatable({}, Element)
    self.Instance = typeof(className) == "Instance" and className or Instance.new(className)
    self.Events = {}
    
    self._registered_events = {}
    
    if props then self:Change(props) end
    if parent then self:Parent(parent) end
    
    return self
end

function Element:Element(className, props)
    return Element.new(className, props, self)
end

function Element:Parent(parent)
    if isInstance(parent) then
        self.Instance.Parent = parent
    else
        self.Instance.Parent = parent.Instance
    end
    return self
end

function Element:Event(name, fn)
    table.insert(self.Events, {name, fn})
    
    local found = false
    for _, con in ipairs(self._registered_events) do
        if con[1] == name then
            found = true
            break
        end
    end
    
    if not found then
        local con
        con = self.Instance[name]:Connect(function(...)
            for _, con in ipairs(self.Events) do
                if con[1] == name then
                    con[2](self, ...)
                end
            end
        end)
        table.insert(self._registered_events, {name, con})
    end
    return self
end

function Element:DisconnectEvents(eventName)
    if not eventName then
        self.Events = {}
        for _, con in ipairs(self._registered_events) do
            con[2]:Disconnect()
        end
        self._registered_events = {}
    else
        for i, ev in ipairs(self.Events) do
            if ev[1] == eventName then
                table.remove(self.Events, i)
            end
        end
        for i, con in ipairs(self._registered_events) do
            if con[1] == eventName then
                con[2]:Disconnect()
                table.remove(self._registered_events, i)
            end
        end
    end
end

function Element:Change(props)
    for k, v in pairs(props) do
        if k == "Events" then
            for eve, nt in pairs(v) do
                self:Event(eve, nt)
            end
        elseif k == "Children" then
            for name, child in pairs(v) do
                if isInstance(child) then
                    child.Name = name
                    child.Parent = self.Instance
                else
                    child.Instance.Name = name
                    child:Parent(self)
                end
            end
        else
            self.Instance[k] = v
        end
    end
    return self
end

function Element:Tween(goal, info, fn)
    local tw = game:GetService("TweenService"):Create(self.Instance, info, goal)
    if tw and fn then
        tw.Completed:Once(function(...)
            fn(self, ...)
        end)
    end
    tw:Play()
    return goal, tw
end

function Element:Destroy()
    self:DisconnectEvents()
    self.Instance:Destroy()
    
    self.Instance = nil
    self.Events = nil
    self._registered_events = nil
    setmetatable(self, nil)
end

return LiteUI
