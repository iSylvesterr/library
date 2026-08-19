-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
require(script:WaitForChild("Types"));
local Observers = require(ReplicatedStorage.Packages.Observers);
local Sound = require(ReplicatedStorage.Classes.Sound);

local function OpenGarage(p1, p2) -- Line: 20
    -- upvalues: Sound (copy), TweenService (copy)
    Sound.new("Miscellaneous"):playOneTime({
        Name = "Open Garage",
        Parent = p1.Handle
    });

    return TweenService:Create(p1.Handle, TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = p2 + Vector3.new(0, 10, 0)
    });
end;

local function CloseGarage(p3, p4) -- Line: 31
    -- upvalues: Sound (copy), TweenService (copy)
    Sound.new("Miscellaneous"):playOneTime({
        Name = "Close Garage",
        Parent = p3.Handle
    });

    return TweenService:Create(p3.Handle, TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = p4
    });
end;

return Observers.observeTag("Garage", function(u5) -- Line: 43
    -- upvalues: Observers (copy), OpenGarage (copy), CloseGarage (copy)
    u5:WaitForChild("Handle");

    if u5:IsDescendantOf(workspace) then
        local Position = u5.Handle.Position;
        local u6 = nil;

        return Observers.observeAttribute(u5, "CurrentState", function(p7) -- Line: 54
            -- upvalues: u6 (ref), OpenGarage (ref), u5 (copy), Position (copy), CloseGarage (ref)
            if u6 then
                u6:Cancel();
                u6 = nil;
            end;

            if not p7 then
                local v8 = CloseGarage(u5, Position);
                u6 = v8;
                v8:Play();

                return function() -- Line: 72
                    -- upvalues: u5 (ref), CloseGarage (ref), Position (ref)
                    if u5:IsDescendantOf(workspace) then
                        CloseGarage(u5, Position);
                    end;
                end;
            end;

            local v9 = OpenGarage(u5, Position);
            u6 = v9;
            v9:Play();
        end);
    end;
end);