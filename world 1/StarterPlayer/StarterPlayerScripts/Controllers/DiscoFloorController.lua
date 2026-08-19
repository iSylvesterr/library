-- Decompiled with Potassium's decompiler.

local v1 = {};
local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local u2 = {};
local u3 = 0;

local function Track(p4) -- Line: 57
    -- upvalues: u2 (copy)
    if u2[p4] or not (p4:IsA("Model") and p4:IsDescendantOf(workspace)) then
        return;
    end;

    local Position = p4:GetPivot().Position;
    local v5 = {};
    local v6 = {};

    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("BasePart") and string.sub(descendant.Name, 1, 4) == "Top_" then
            local v7 = descendant.Position - Position;
            local v8 = math.round((v7.X - v7.Z) / 120 * 1000);
            local v9 = v5[v8];

            if not v9 then
                v9 = {
                    Offset = v8 / 1000,
                    Parts = {}
                };
                v5[v8] = v9;
                table.insert(v6, v9);
            end;

            table.insert(v9.Parts, descendant);
        end;
    end;

    if #v6 == 0 then
        warn((`[DiscoFloorController] {p4:GetFullName()} has no Top_* tiles to light`));

        return;
    end;

    u2[p4] = v6;
end;

local function Untrack(p10) -- Line: 92
    -- upvalues: u2 (copy)
    u2[p10] = nil;
end;

local function Step(p11) -- Line: 96
    -- upvalues: u3 (ref), u2 (copy)
    u3 = u3 + p11;

    if u3 < 0.03333333333333333 then
        return;
    end;

    u3 = 0;
    local v12 = workspace:GetServerTimeNow() / 2.5;

    for i, v in u2 do
        if i.Parent then
            for _, v2 in v do
                local v13 = Color3.fromHSV((v2.Offset - v12) % 1, 1, 0.8470588235294118);

                for _, v3 in v2.Parts do
                    v3.Color = v13;
                end;
            end;
        else
            u2[i] = nil;
        end;
    end;
end;

function v1.Init(p14) -- Line: 121
end;

function v1.Start(p15) -- Line: 123
    -- upvalues: CollectionService (copy), Track (copy), Untrack (copy), RunService (copy), Step (copy)
    for _, v in CollectionService:GetTagged("DiscoFloor") do
        Track(v);
    end;

    CollectionService:GetInstanceAddedSignal("DiscoFloor"):Connect(Track);
    CollectionService:GetInstanceRemovedSignal("DiscoFloor"):Connect(Untrack);
    RunService.RenderStepped:Connect(Step);
end;

return v1;