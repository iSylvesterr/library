-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Library.Client.GuardTutorialPresentationComponent);
local StepUtils = require(script.Parent.Parent.StepUtils);
require(script.Parent.Types.Interface);
local u1 = Color3.fromRGB(255, 255, 255);
local u3 = {
    StepId = "PlaceEgg",

    IsSatisfied = function(p2) -- Line: 24, Name: IsSatisfied
        return p2:HasPlacedEgg();
    end
};

function u3.Bind(p4, p5) -- Line: 28
    -- upvalues: StepUtils (copy), u3 (copy)
    return StepUtils.BindOnAdapterChanged(p4, u3.IsSatisfied, p5);
end;

function u3.Present(u6, u7) -- Line: 32
    -- upvalues: u3 (copy), u1 (copy)
    local u9 = u7.Changed:Connect(function() -- Line: 36, Name: refreshPresentation
        -- upvalues: u3 (ref), u7 (copy), u6 (copy), u1 (ref)
        if u3.IsSatisfied(u7) then
            u6:ClearAll();

            return;
        end;

        u6:ShowAnimatedMessage("Place your Egg!", u1);
        local v8 = u7:GetEggPlacementBillboardCFrame();

        if v8 ~= nil then
            u6:ShowBillboardClick(v8);
        end;
    end);

    if u3.IsSatisfied(u7) then
        u6:ClearAll();
    else
        u6:ShowAnimatedMessage("Place your Egg!", u1);
        local v10 = u7:GetEggPlacementBillboardCFrame();

        if v10 ~= nil then
            u6:ShowBillboardClick(v10);
        end;
    end;

    return function() -- Line: 52
        -- upvalues: u9 (copy), u6 (copy)
        u9:Disconnect();
        u6:ClearAll();
    end;
end;

return u3;