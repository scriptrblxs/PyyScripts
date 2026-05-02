local LiteUI = {}

local Element = {}
Element.__index = Element

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
    if typeof(parent) == "Instance" then
        self.Instance.Parent = parent
    else
        self.Instance.Parent = parent.Instance
    end
    return self
end

function Element:Event(name, fn)
    table.insert(self.Events, {name, fn})
    if not table.find(self._registered_events, name) then
        table.insert(self._registered_events, name)
        self.Instance[name]:Connect(function(...)
            for _, con in ipairs(self.Events) do
                if con[1] == name then
                    con[2](self, ...)
                end
            end
        end)
    end
    return self
end

function Element:Change(props)
    for k, v in pairs(props) do
        if k == "Events" then
            for eve, nt in pairs(v) do
                self:Event(eve, nt)
            end
        else
            self.Instance[k] = v
        end
    end
    return self
end

function Element:Tween(goal, info, fn)
    local tw = game:GetService("TweenService"):Create(self.Instance, info, goal)
    if tw then
        tw.Completed:Once(function(...)
            fn(self, ...)
        end)
    end
    tw:Play()
    return goal
end

return LiteUI