-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MutationConfig = require(ReplicatedStorage.Shared.Info.MutationConfig);
local u1 = {};
local u2 = Color3.fromRGB(255, 255, 255);

local function colorTag(p3, p4) -- Line: 21
    return string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(p4.R * 255), math.round(p4.G * 255), math.round(p4.B * 255), p3);
end;

function u1.build(p5) -- Line: 32
    -- upvalues: MutationConfig (copy), colorTag (copy), u2 (copy)
    local v6 = MutationConfig.OrderKeys(p5);

    if #v6 == 0 then
        return "";
    end;

    local v7 = {};

    for _, v in v6 do
        local v8 = MutationConfig.Mutations[v];
        table.insert(v7, colorTag(v8.displayName, v8.textColor));
    end;

    return table.concat(v7, colorTag(" + ", u2));
end;

function u1.coloredName(p9) -- Line: 45
    -- upvalues: MutationConfig (copy)
    local v10 = MutationConfig.Mutations[p9];
    local v11;

    if v10 then
        local displayName = v10.displayName;
        local textColor = v10.textColor;
        v11 = string.format("<font color=\"rgb(%d,%d,%d)\">%s</font>", math.round(textColor.R * 255), math.round(textColor.G * 255), math.round(textColor.B * 255), displayName) or "";
    else
        v11 = "";
    end;

    return v11;
end;

function u1.apply(p12, p13) -- Line: 53
    -- upvalues: MutationConfig (copy), CollectionService (copy), u1 (copy)
    if not p12 then
        return;
    end;

    local v14 = MutationConfig.OrderKeys(p13);

    if p12:GetAttribute("rarity") == "CHARGED" then
        CollectionService:RemoveTag(p12, "ShinyTextLabel");
        local v15 = p12:FindFirstChildWhichIsA("UIGradient");

        if v15 then
            v15:Destroy();
        end;

        p12:SetAttribute("rarity", nil);
    end;

    p12.RichText = true;

    if #v14 == 1 and v14[1] == "Charged" then
        p12.Text = "Charged";
        p12:SetAttribute("rarity", "CHARGED");
        CollectionService:AddTag(p12, "ShinyTextLabel");
    else
        p12.Text = u1.build(v14);
    end;

    p12.Visible = #v14 > 0;
end;

return u1;