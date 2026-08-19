-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Audio = require(Library.Audio);
local Asserts = require(ReplicatedStorage.Library.Asserts);

function CreateInteractSound(p1, p2, u3, p4, u5)
    -- upvalues: Asserts (copy), Audio (copy)
    Asserts.GuiButton(p1);
    Asserts.string(p2);
    Asserts.string(u3);
    Asserts.optional.number(p4);
    Asserts.optional.boolean(u5);
    local v6 = string.lower(p2);
    local u7 = false;
    local u8 = {};
    local u9 = p4 or 0.15;

    if u5 == nil or not u5 then
        u5 = false;
    end;

    local function playSound() -- Line: 29
        -- upvalues: u5 (copy), Audio (ref), u3 (copy), u9 (copy)
        local v10 = u5 and math.random(95, 105) / 100 or 1;
        Audio.Play(u3, script, v10, u9);
    end;

    local function playLoudSound() -- Line: 34
        -- upvalues: u5 (copy), Audio (ref), u3 (copy), u9 (copy)
        local v11 = u5 and math.random(95, 105) / 100 or 1;
        Audio.Play(u3, script, v11, u9 * 2);
    end;

    if v6 == "mousedown" then
        u8[#u8 + 1] = p1.InputBegan:Connect(function(p12) -- Line: 40
            -- upvalues: u5 (copy), Audio (ref), u3 (copy), u9 (copy)
            if p12.UserInputType == Enum.UserInputType.MouseButton1 or p12.UserInputType == Enum.UserInputType.Touch and p12.UserInputState == Enum.UserInputState.Begin or p12.KeyCode == Enum.KeyCode.ButtonA then
                local v13 = u5 and math.random(95, 105) / 100 or 1;
                Audio.Play(u3, script, v13, u9 * 2);
            end;
        end);
    elseif v6 == "mouseup" then
        u8[#u8 + 1] = p1.InputEnded:Connect(function(p14) -- Line: 50
            -- upvalues: u5 (copy), Audio (ref), u3 (copy), u9 (copy)
            if p14.UserInputType == Enum.UserInputType.MouseButton1 or p14.UserInputType == Enum.UserInputType.Touch and p14.UserInputState == Enum.UserInputState.End or p14.KeyCode == Enum.KeyCode.ButtonA then
                local v15 = u5 and math.random(95, 105) / 100 or 1;
                Audio.Play(u3, script, v15, u9 * 2);
            end;
        end);
    elseif v6 == "mouseenter" then
        u8[#u8 + 1] = p1.MouseEnter:Connect(playSound);
    elseif v6 == "mouseleave" then
        u8[#u8 + 1] = p1.MouseLeave:Connect(playSound);
    elseif v6 == "mouseclick" then
        u8[#u8 + 1] = p1.Activated:Connect(playSound);
    end;

    return function() -- Line: 67
        -- upvalues: u7 (ref), u8 (copy)
        if u7 then
            return;
        end;

        u7 = false;

        for _, v in ipairs(u8) do
            v:Disconnect();
        end;
    end;
end;

return CreateInteractSound;