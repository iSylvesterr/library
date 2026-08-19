-- Decompiled with Potassium's decompiler.

local v1 = {};
local SfxController = require(script.Parent.SfxController);
local CollectionService = game:GetService("CollectionService");
local u2 = {};

local function hook(p3) -- Line: 9
    -- upvalues: u2 (copy), SfxController (copy)
    if u2[p3] then
        return;
    end;

    if not p3:IsA("GuiButton") then
        return;
    end;

    u2[p3] = true;
    p3.Activated:Connect(function() -- Line: 19
        -- upvalues: SfxController (ref)
        SfxController:PlaySFX("Click");
    end);
end;

function v1.Init(p4) -- Line: 24
end;

function v1.Start(p5) -- Line: 27
    -- upvalues: CollectionService (copy), u2 (copy), SfxController (copy), hook (copy)
    for _, v in CollectionService:GetTagged("ClickSFX") do
        if not u2[v] then
            if v:IsA("GuiButton") then
                u2[v] = true;
                v.Activated:Connect(function() -- Line: 19
                    -- upvalues: SfxController (ref)
                    SfxController:PlaySFX("Click");
                end);
            end;
        end;
    end;

    CollectionService:GetInstanceAddedSignal("ClickSFX"):Connect(hook);
end;

return v1;