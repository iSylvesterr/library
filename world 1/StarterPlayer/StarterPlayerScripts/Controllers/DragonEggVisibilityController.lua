-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local LocalPlayer = Players.LocalPlayer;
local v1 = {};

local function evaluate(u2) -- Line: 23
    -- upvalues: evaluate (copy), LocalPlayer (copy)
    if not u2:IsA("Model") then
        return;
    end;

    local v3 = u2:GetAttribute("DragonEggOwner");

    if v3 ~= nil then
        if v3 ~= LocalPlayer.UserId then
            u2:Destroy();
        end;

        return;
    end;

    local u4 = nil;
    u4 = u2.AttributeChanged:Connect(function(p5) -- Line: 29
        -- upvalues: u4 (ref), evaluate (ref), u2 (copy)
        if p5 == "DragonEggOwner" then
            if u4 then
                u4:Disconnect();
            end;

            evaluate(u2);
        end;
    end);
end;

function v1.Init(p6) -- Line: 43
    -- upvalues: CollectionService (copy), evaluate (copy)
    for _, v in CollectionService:GetTagged("DragonEggInstance") do
        task.spawn(evaluate, v);
    end;

    CollectionService:GetInstanceAddedSignal("DragonEggInstance"):Connect(function(p7) -- Line: 47
        -- upvalues: evaluate (ref)
        task.spawn(evaluate, p7);
    end);
end;

return v1;