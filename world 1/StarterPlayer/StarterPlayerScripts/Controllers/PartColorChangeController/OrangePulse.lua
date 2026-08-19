-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local Name = script.Name;
local u2 = {};
local u3 = {};
local u4 = 200;
local u5 = 0.016666666666666666;
local u6 = 1;

local function UnregisterPart(p7) -- Line: 38
    -- upvalues: u3 (copy), u2 (copy), u6 (ref)
    local v8 = u3[p7];

    if not v8 then
        return;
    end;

    local v9 = #u2;
    local v10 = u2[v9];
    u2[v8] = v10;
    u3[v10] = v8;
    u2[v9] = nil;
    u3[p7] = nil;

    if u6 > #u2 then
        u6 = 1;
    end;
end;

local function RegisterPart(p11) -- Line: 31
    -- upvalues: u3 (copy), u2 (copy)
    if not p11:IsA("BasePart") then
        return;
    end;

    if u3[p11] then
        return;
    end;

    table.insert(u2, p11);
    u3[p11] = #u2;
end;

for _, v in CollectionService:GetTagged(Name) do
    if v:IsA("BasePart") then
        if not u3[v] then
            table.insert(u2, v);
            u3[v] = #u2;
        end;
    end;
end;

CollectionService:GetInstanceAddedSignal(Name):Connect(RegisterPart);
CollectionService:GetInstanceRemovedSignal(Name):Connect(UnregisterPart);

function v1.Start(p12) -- Line: 60
    -- upvalues: RunService (copy), u2 (copy), u5 (ref), u4 (ref), u6 (ref)
    RunService.Heartbeat:Connect(function(p13) -- Line: 61
        -- upvalues: u2 (ref), u5 (ref), u4 (ref), u6 (ref)
        local v14 = #u2;

        if v14 == 0 then
            return;
        end;

        u5 = u5 + (p13 - u5) * 0.1;

        if u5 > 0.019166666666666665 then
            local v15 = math.floor(u4 * 0.85);
            u4 = math.max(20, v15);
        else
            u4 = math.min(200, u4 + 2);
        end;

        local v16 = math.min(v14, u4);
        local v17 = tick();

        for _ = 1, v16 do
            local v18 = u2[u6];

            if v18 and v18.Parent then
                local v19 = (math.sin((v18.Position.Y - v17 * 0.5) / 1 * 3.141592653589793 * 2) + 1) / 2 * 0.55 + 0.35;
                v18.Color = Color3.fromHSV(0.0965556, 1, v19);
            end;

            u6 = u6 + 1;

            if v14 < u6 then
                u6 = 1;
            end;
        end;
    end);
end;

return v1;