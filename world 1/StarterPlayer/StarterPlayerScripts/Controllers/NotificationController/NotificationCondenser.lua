-- Decompiled with Potassium's decompiler.

require(game.ReplicatedStorage.ClientModules.Chalk);
local v1 = {
    Rules = {
        YourShopRestock = {
            Key = "YourShopRestock",
            Pattern = "^Your ([%w ]+ Shop) stock has restocked!$",
            Suffix = "stock has restocked!",
            PluralSuffix = "stocks have restocked!"
        }
    }
};

local function StripRich(p2) -- Line: 36
    return p2:gsub("<.->", "");
end;

local function ExtractFullFontColor(p3) -- Line: 40
    return p3:match("^%s*<font[^>]-color=\"([^\"]+)\"[^>]*>.*</font>%s*$") or p3:match("^%s*<font[^>]-color=([^%s>]+)[^>]*>.*</font>%s*$");
end;

local function CaptureColoredVariantBeforeSuffix(p4, p5) -- Line: 48
    return p4:match("^.*(<font.-</font>)%s+.*$");
end;

function v1.GetCondenseKey(p6, p7) -- Line: 52
    local v8 = p7:gsub("<.->", "");

    for _, v in pairs(p6.Rules) do
        local v9 = v8:match(v.Pattern);

        if v9 then
            local _ = v.Suffix;
            local v10 = p7:match("^.*(<font.-</font>)%s+.*$");
            local v11 = v10 or p7;
            local v12 = v11:match("^%s*<font[^>]-color=\"([^\"]+)\"[^>]*>.*</font>%s*$") or v11:match("^%s*<font[^>]-color=([^%s>]+)[^>]*>.*</font>%s*$");

            if not v10 then
                local v13 = p7:match("^%s*<font[^>]-color=\"([^\"]+)\"[^>]*>.*</font>%s*$") or p7:match("^%s*<font[^>]-color=([^%s>]+)[^>]*>.*</font>%s*$");

                if v13 then
                    v10 = `<font color="{v13}">{v9}</font>`;
                else
                    v10 = v9;
                end;
            end;

            return {
                Rule = v,
                Variant = {
                    Plain = v9,
                    Rich = v10,
                    Color = v12
                }
            };
        end;
    end;

    return nil;
end;

function v1.BuildCondensedText(p14, p15, p16, p17) -- Line: 86
    table.sort(p15, function(p18, p19) -- Line: 87
        return p18.Plain < p19.Plain;
    end);
    local v20 = true;
    local v21;

    if #p15 > 0 then
        v21 = p15[1].Color;

        for i = 2, #p15 do
            if p15[i].Color ~= v21 then
                v20 = false;
                break;
            end;
        end;
    else
        v20 = false;
        v21 = nil;
    end;

    local v22;

    if #p15 == 1 then
        v22 = p15[1].Rich .. " " .. p16;
    elseif #p15 == 2 then
        v22 = p15[1].Rich .. " and " .. p15[2].Rich .. " " .. p17;
    else
        local v23 = {};

        for i = 1, #p15 - 1 do
            table.insert(v23, p15[i].Rich);
        end;

        v22 = table.concat(v23, ", ") .. " and " .. p15[#p15].Rich .. " " .. p17;
    end;

    if v20 and v21 then
        v22 = `<font color="{v21}">{v22}</font>`;
    end;

    return v22;
end;

return v1;