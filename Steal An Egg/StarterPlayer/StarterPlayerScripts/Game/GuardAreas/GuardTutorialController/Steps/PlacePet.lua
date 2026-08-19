-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Library.Client.GuardTutorialPresentationComponent);
local StepUtils = require(script.Parent.Parent.StepUtils);
require(script.Parent.Types.Interface);
local u1 = Color3.fromRGB(255, 255, 255);
local u3 = {
    StepId = "PlacePet",

    IsSatisfied = function(p2) -- Line: 24, Name: IsSatisfied
        return p2:HasPlacedPet();
    end
};

function u3.Bind(p4, p5) -- Line: 28
    -- upvalues: StepUtils (copy), u3 (copy)
    return StepUtils.BindOnAdapterChanged(p4, u3.IsSatisfied, p5);
end;

function u3.Present(u6, u7) -- Line: 32
    -- upvalues: u3 (copy), u1 (copy)
    local function refreshPresentation() -- Line: 36
        -- upvalues: u3 (ref), u7 (copy), u6 (copy), u1 (ref)
        if u3.IsSatisfied(u7) or not u7:HasPetInInventory() then
            u6:ClearAll();

            return;
        end;

        u6:ShowAnimatedMessage("Place your Pet!", u1);
        u6:SetScreenClickVisible(u7:HasPetToolEquipped());
    end;

    local u8 = u7.Changed:Connect(refreshPresentation);
    refreshPresentation();

    return function() -- Line: 49
        -- upvalues: u8 (copy), u6 (copy)
        u8:Disconnect();
        u6:ClearAll();
    end;
end;

return u3;