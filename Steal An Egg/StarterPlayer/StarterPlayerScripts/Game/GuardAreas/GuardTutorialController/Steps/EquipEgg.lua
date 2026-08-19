-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Library.Client.GuardTutorialPresentationComponent);
local StepUtils = require(script.Parent.Parent.StepUtils);
require(script.Parent.Types.Interface);
local u2 = {
    StepId = "EquipEgg",

    IsSatisfied = function(p1) -- Line: 21, Name: IsSatisfied
        return p1:HasEquippedEgg();
    end
};

function u2.Bind(p3, p4) -- Line: 25
    -- upvalues: StepUtils (copy), u2 (copy)
    return StepUtils.BindOnAdapterChanged(p3, u2.IsSatisfied, p4);
end;

function u2.Present(u5, u6) -- Line: 29
    -- upvalues: u2 (copy)
    local function refreshPresentation() -- Line: 33
        -- upvalues: u2 (ref), u6 (copy), u5 (copy)
        if u2.IsSatisfied(u6) then
            u5:ClearAll();

            return;
        end;

        local v7 = u6:ForceBestEggIntoHotbar() or u6:GetEggHotbarTarget();

        if v7 == nil then
            u5:ClearHighlight();

            return;
        end;

        u5:ShowHighlight(v7);
    end;

    local u8 = u6.Changed:Connect(refreshPresentation);
    refreshPresentation();

    return function() -- Line: 50
        -- upvalues: u8 (copy), u5 (copy)
        u8:Disconnect();
        u5:ClearAll();
    end;
end;

return u2;