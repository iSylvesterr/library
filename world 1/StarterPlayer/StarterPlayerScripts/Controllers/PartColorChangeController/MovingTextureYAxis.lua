-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local Name = script.Name;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = 200;
local u6 = 0.016666666666666666;
local u7 = 1;

local function UnregisterTexture(p8) -- Line: 43
    -- upvalues: u3 (copy), u2 (copy), u4 (copy), u7 (ref)
    local v9 = u3[p8];

    if not v9 then
        return;
    end;

    local v10 = #u2;
    local v11 = u2[v10];
    u2[v9] = v11;
    u3[v11] = v9;
    u2[v10] = nil;
    u3[p8] = nil;
    u4[p8] = nil;

    if u7 > #u2 then
        u7 = 1;
    end;
end;

local function RegisterTexture(p12) -- Line: 31
    -- upvalues: u3 (copy), u2 (copy), u4 (copy)
    if not p12:IsA("Texture") then
        return;
    end;

    if u3[p12] then
        return;
    end;

    p12.OffsetStudsV = math.random(1, 20);
    p12.OffsetStudsU = math.random(1, 20);
    table.insert(u2, p12);
    u3[p12] = #u2;
    u4[p12] = os.clock();
end;

for _, v in CollectionService:GetTagged(Name) do
    RegisterTexture(v);
end;

CollectionService:GetInstanceAddedSignal(Name):Connect(RegisterTexture);
CollectionService:GetInstanceRemovedSignal(Name):Connect(UnregisterTexture);

function v1.Start(p13) -- Line: 69
    -- upvalues: RunService (copy), u2 (copy), u6 (ref), u5 (ref), u7 (ref), u4 (copy)
    RunService.Heartbeat:Connect(function(p14) -- Line: 70
        -- upvalues: u2 (ref), u6 (ref), u5 (ref), u7 (ref), u4 (ref)
        local v15 = #u2;

        if v15 == 0 then
            return;
        end;

        u6 = u6 + (p14 - u6) * 0.1;

        if u6 > 0.019166666666666665 then
            local v16 = math.floor(u5 * 0.85);
            u5 = math.max(20, v16);
        else
            u5 = math.min(200, u5 + 2);
        end;

        local v17 = math.min(v15, u5);
        local v18 = os.clock();

        for _ = 1, v17 do
            local v19 = u2[u7];

            if v19 and v19.Parent then
                local v20 = v18 - (u4[v19] or v18);
                u4[v19] = v18;
                local v21 = v19.OffsetStudsV + 2 * v20;
                local StudsPerTileV = v19.StudsPerTileV;

                if StudsPerTileV > 0 then
                    v21 = v21 % StudsPerTileV;
                end;

                v19.OffsetStudsV = v21;
            end;

            u7 = u7 + 1;

            if v15 < u7 then
                u7 = 1;
            end;
        end;
    end);
end;

return v1;