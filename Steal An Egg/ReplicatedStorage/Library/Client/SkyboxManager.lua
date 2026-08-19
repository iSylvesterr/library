-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = require(game:GetService("ReplicatedStorage").Library.Modules.WeightedTable).new();

function v1.AddSkybox(p3, p4) -- Line: 4
    -- upvalues: u2 (copy)
    u2:Add(p3, p4 or 0);
end;

function v1.UpdateSkybox(p5, p6) -- Line: 8
    -- upvalues: u2 (copy)
    u2:SetWeight(p5, p6);
end;

local u7 = nil;

local function checkSkyboxes() -- Line: 14
    -- upvalues: u2 (copy), u7 (ref)
    local v8, _ = u2:GetHighestObject();

    if u7 then
        u7.Parent = script;
    end;

    u7 = v8;
    u7.Parent = game:GetService("Lighting");
end;

v1.AddSkybox(game:GetService("Lighting").Cartoon, 1);
u2.OnUpdate:Connect(checkSkyboxes);
local v9, _ = u2:GetHighestObject();

if u7 then
    u7.Parent = script;
end;

u7 = v9;
u7.Parent = game:GetService("Lighting");

return v1;