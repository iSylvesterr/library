-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Parent = script.Parent;
local u1 = true;
local Network = require(ReplicatedStorage.Library.Client.Network);
local GetMouseToWorld = require(ReplicatedStorage.Library.Functions.GetMouseToWorld);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
Parent.Activated:Connect(function() -- Line: 9
    -- upvalues: u1 (ref), Parent (copy), GetMouseToWorld (copy), Message (copy), Network (copy)
    if u1 then
        u1 = false;
        task.delay(0.4, function() -- Line: 12
            -- upvalues: u1 (ref)
            u1 = true;
        end);
        local v2 = Parent:GetAttribute("Uses") or 1;
        local v3 = Parent:GetAttribute("LocalUses") or 1;

        if math.min(v2, v3) <= 0 then
            return;
        end;

        local v4 = RaycastParams.new();
        v4.FilterDescendantsInstances = { workspace.Map.CanPlace };
        v4.FilterType = Enum.RaycastFilterType.Include;
        local v5 = GetMouseToWorld(v4, 1000);

        if not v5 then
            Message.Bottom({
                Message = "You cannot place your egg here!",
                Time = 0.5
            });

            return;
        end;

        Network.Fire(Network.NET_MAP.Pets.PET_EGG_SERVICE, "CreateEgg", v5.Position);
    end;
end);
Parent:GetAttributeChangedSignal("Uses"):Connect(function() -- Line: 33
    -- upvalues: Parent (copy)
    local v6 = Parent:GetAttribute("Uses") or 1;
    Parent:SetAttribute("LocalUses", v6);
    Parent.Name = (Parent:GetAttribute("EggName") or "Common") .. " x" .. v6;
end);
local v7 = Parent:GetAttribute("Uses") or 1;
Parent:SetAttribute("LocalUses", v7);
Parent.Name = (Parent:GetAttribute("EggName") or "Common") .. " x" .. v7;