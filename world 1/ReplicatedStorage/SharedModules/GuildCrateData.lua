-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {};

local function getCrateImageOverride(p3) -- Line: 35
    local GuildCrateImages = script:FindFirstChild("GuildCrateImages");

    if not GuildCrateImages then
        return nil;
    end;

    local v4 = GuildCrateImages:FindFirstChild(p3);

    if v4 and (v4:IsA("StringValue") and v4.Value ~= "") then
        return v4.Value;
    end;

    return nil;
end;

function u1.GetData(p5) -- Line: 45
    -- upvalues: u2 (copy)
    if u2[p5] then
        return u2[p5];
    end;

    local u6 = script:FindFirstChild(p5);

    if not (u6 and u6:IsA("ModuleScript")) then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 55
        -- upvalues: u6 (copy)
        return require(u6);
    end);

    if not success or type(result) ~= "table" then
        warn((`[GuildCrateData] Crate module require failed ({p5}): {success and "not a table" or result}`));

        return nil;
    end;

    local GuildCrateImages = script:FindFirstChild("GuildCrateImages");
    local v7;

    if GuildCrateImages then
        local v8 = GuildCrateImages:FindFirstChild(p5);

        if v8 and (v8:IsA("StringValue") and v8.Value ~= "") then
            v7 = v8.Value;
        else
            v7 = nil;
        end;
    else
        v7 = nil;
    end;

    if v7 then
        result.IMG = v7;
    elseif not result.IMG or result.IMG == "" then
        result.IMG = "rbxassetid://102182642774885";
    end;

    u2[p5] = result;

    return result;
end;

function u1.GetRandomItem(p9) -- Line: 77
    -- upvalues: u1 (copy)
    local v10 = u1.GetData(p9);

    if not v10 or (not v10.Items or #v10.Items == 0) then
        return nil;
    end;

    local v11 = 0;

    for _, v in v10.Items do
        v11 = v11 + v.Chance;
    end;

    local v12 = math.random() * v11;
    local v13 = 0;

    for _, v in v10.Items do
        v13 = v13 + v.Chance;

        if v12 <= v13 then
            return v;
        end;
    end;

    return v10.Items[#v10.Items];
end;

function u1.GetAllCrates() -- Line: 101
    -- upvalues: u1 (copy)
    local v14 = {};

    for _, child in script:GetChildren() do
        if child:IsA("ModuleScript") then
            local v15 = u1.GetData(child.Name);

            if v15 then
                table.insert(v14, v15);
            end;
        end;
    end;

    return v14;
end;

function u1.IsGuildCrate(p16) -- Line: 114
    -- upvalues: u1 (copy)
    return u1.GetData(p16) ~= nil;
end;

return u1;