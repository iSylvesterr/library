-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {};
local u3 = nil;

local function getGuildCrateData() -- Line: 8
    -- upvalues: u3 (ref)
    if u3 == nil then
        local Parent = script.Parent;

        if Parent then
            Parent = Parent:FindFirstChild("GuildCrateData");
        end;

        if Parent and Parent:IsA("ModuleScript") then
            local success, result = pcall(require, Parent);

            if success then
                u3 = result;
            else
                warn((`[CrateData] GuildCrateData require failed; guild crate lookups disabled: {result}`));
                u3 = false;
            end;
        else
            u3 = false;
        end;
    end;

    if u3 == false then
        return nil;
    end;

    return u3;
end;

local function getCrateImageOverride(p4) -- Line: 30
    local Parent = script.Parent;

    if not Parent then
        return nil;
    end;

    local CrateImages = Parent:FindFirstChild("CrateImages");

    if not CrateImages then
        return nil;
    end;

    local v5 = CrateImages:FindFirstChild(p4);

    if v5 and (v5:IsA("StringValue") and v5.Value ~= "") then
        return v5.Value;
    end;

    return nil;
end;

function u1.GetData(p6) -- Line: 42
    -- upvalues: u2 (copy), getGuildCrateData (copy)
    if u2[p6] then
        return u2[p6];
    end;

    local u7 = script:FindFirstChild(p6);

    if not u7 then
        local v8 = getGuildCrateData();

        return v8 and v8.GetData(p6) or nil;
    end;

    local success, result = pcall(function() -- Line: 63
        -- upvalues: u7 (copy)
        return require(u7);
    end);

    if not success then
        warn((`[CrateData] Crate module require failed ({p6}): {result}`));

        return nil;
    end;

    local Parent = script.Parent;
    local v9;

    if Parent then
        local CrateImages = Parent:FindFirstChild("CrateImages");

        if CrateImages then
            local v10 = CrateImages:FindFirstChild(p6);

            if v10 and (v10:IsA("StringValue") and v10.Value ~= "") then
                v9 = v10.Value;
            else
                v9 = nil;
            end;
        else
            v9 = nil;
        end;
    else
        v9 = nil;
    end;

    if v9 then
        result.IMG = v9;
    end;

    u2[p6] = result;

    return result;
end;

function u1.IsGuildCrate(p11) -- Line: 83
    -- upvalues: getGuildCrateData (copy)
    local v12 = getGuildCrateData();

    if v12 then
        return v12.GetData(p11) ~= nil;
    end;

    return false;
end;

function u1.GetRandomItem(p13) -- Line: 89
    -- upvalues: u1 (copy)
    local v14 = u1.GetData(p13);

    if not v14 or (not v14.Items or #v14.Items == 0) then
        return nil;
    end;

    local v15 = 0;

    for _, v in v14.Items do
        v15 = v15 + v.Chance;
    end;

    local v16 = math.random() * v15;
    local v17 = 0;

    for _, v in v14.Items do
        v17 = v17 + v.Chance;

        if v16 <= v17 then
            return v;
        end;
    end;

    return v14.Items[#v14.Items];
end;

function u1.GetAllCrates() -- Line: 113
    -- upvalues: u1 (copy), getGuildCrateData (copy)
    local v18 = {};

    for _, child in script:GetChildren() do
        if child:IsA("ModuleScript") then
            local v19 = u1.GetData(child.Name);

            if v19 then
                table.insert(v18, v19);
            end;
        end;
    end;

    local v20 = getGuildCrateData();

    if v20 then
        for _, v in v20.GetAllCrates() do
            table.insert(v18, v);
        end;
    end;

    return v18;
end;

return u1;