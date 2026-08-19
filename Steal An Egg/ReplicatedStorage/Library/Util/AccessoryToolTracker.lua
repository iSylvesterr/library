-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local v1 = {};

local function getToolHumanoid(p2) -- Line: 22
    local Parent = p2.Parent;

    if Parent and Parent:IsA("Model") then
        return Parent:FindFirstChildOfClass("Humanoid") or nil;
    end;

    return nil;
end;

function v1.Bind(u3, u4) -- Line: 37
    -- upvalues: Asserts (copy), Trove (copy), HttpService (copy)
    Asserts.Tool(u3);
    Asserts.Instance(u4);
    local v5 = u4:IsA("Accessory");
    assert(v5, "AccessoryToolTracker.Bind expects an Accessory");
    local u6 = Trove.new();
    local Parent = u4.Parent;
    local u7 = HttpService:GenerateGUID(false);
    local u8 = nil;
    local u9 = nil;
    u4:SetAttribute("MurderMysteryToolAccessory", true);
    u4:SetAttribute("AccessoryToolTrackerId", u7);

    local function getRestoreParent() -- Line: 51
        -- upvalues: Parent (copy), u3 (copy)
        if Parent and Parent.Parent then
            return Parent;
        end;

        if u3.Parent then
            return u3;
        end;

        return nil;
    end;

    local function unequipAccessory() -- Line: 63
        -- upvalues: u8 (ref), u9 (ref), u7 (copy), Parent (copy), u3 (copy), u4 (copy)
        local v10 = u8 and u8.Parent;

        if u9 then
            u9:Destroy();
            u9 = nil;
        end;

        if v10 and v10:IsA("Model") then
            for _, child in v10:GetChildren() do
                if child:IsA("Accessory") and child:GetAttribute("AccessoryToolTrackerId") == u7 then
                    child:Destroy();
                end;
            end;
        end;

        u8 = nil;
        local v11;

        if Parent and Parent.Parent then
            v11 = Parent;
        elseif u3.Parent then
            v11 = u3;
        else
            v11 = nil;
        end;

        if u4.Parent ~= v11 then
            u4.Parent = v11;
        end;
    end;

    local function equipAccessory() -- Line: 87
        -- upvalues: u3 (copy), unequipAccessory (copy), u8 (ref), u9 (ref), u4 (copy), u7 (copy)
        local Parent2 = u3.Parent;
        local v12;

        if Parent2 and Parent2:IsA("Model") then
            v12 = Parent2:FindFirstChildOfClass("Humanoid") or nil;
        else
            v12 = nil;
        end;

        if not v12 then
            unequipAccessory();

            return;
        end;

        if u8 == v12 and (u9 and u9.Parent == v12.Parent) then
            return;
        end;

        unequipAccessory();
        u8 = v12;
        local v13 = u4:Clone();
        v13:SetAttribute("AccessoryToolTrackerId", u7);
        u9 = v13;
        v12:AddAccessory(v13);
    end;

    u6:Connect(u3.Equipped, function() -- Line: 106
        -- upvalues: equipAccessory (copy)
        equipAccessory();
    end);
    u6:Connect(u3.Unequipped, function() -- Line: 110
        -- upvalues: unequipAccessory (copy)
        unequipAccessory();
    end);
    u6:Connect(u3.Destroying, function() -- Line: 114
        -- upvalues: unequipAccessory (copy)
        unequipAccessory();
    end);
    u6:Connect(u3:GetPropertyChangedSignal("Parent"), function() -- Line: 118
        -- upvalues: u3 (copy), equipAccessory (copy), unequipAccessory (copy)
        local Parent2 = u3.Parent;
        local v14;

        if Parent2 and Parent2:IsA("Model") then
            v14 = Parent2:FindFirstChildOfClass("Humanoid") or nil;
        else
            v14 = nil;
        end;

        if v14 then
            equipAccessory();

            return;
        end;

        unequipAccessory();
    end);
    u6:Add(function() -- Line: 127
        -- upvalues: unequipAccessory (copy)
        unequipAccessory();
    end);
    u6:AttachToInstance(u3);
    equipAccessory();

    return {
        Destroy = function(p15) -- Line: 136, Name: Destroy
            -- upvalues: u6 (copy)
            u6:Destroy();
        end,

        Sync = function(p16) -- Line: 139, Name: Sync
            -- upvalues: u3 (copy), equipAccessory (copy), unequipAccessory (copy)
            local Parent2 = u3.Parent;
            local v17;

            if Parent2 and Parent2:IsA("Model") then
                v17 = Parent2:FindFirstChildOfClass("Humanoid") or nil;
            else
                v17 = nil;
            end;

            if v17 then
                equipAccessory();

                return;
            end;

            unequipAccessory();
        end
    };
end;

return v1;