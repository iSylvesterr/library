-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService;
local u1 = {};

local function parseRichText(p2) -- Line: 6
    local v3 = 1;
    local v4 = {};

    while v3 <= #p2 do
        local v5 = { string.find(p2, "<font", v3, true) };

        if v5 == nil then
            local v6 = {
                text = string.sub(p2, v3),
                openTag = "",
                closeTag = ""
            };
            table.insert(v4, v6);

            return v4;
        end;

        local v7 = v5[1];

        if v3 < v7 then
            local v8 = {
                text = string.sub(p2, v3, v7 - 1),
                openTag = "",
                closeTag = ""
            };
            table.insert(v4, v8);
        end;

        local v9 = { string.find(p2, ">", v7, true) };

        if v9 == nil then
            local v10 = {
                openTag = "",
                closeTag = "",
                text = string.sub(p2, v7)
            };
            table.insert(v4, v10);

            return v4;
        end;

        local v11 = v9[2];
        local v12 = { string.find(p2, "</font>", v11 + 1, true) };

        if v12 == nil then
            local v13 = {
                openTag = "",
                closeTag = "",
                text = string.sub(p2, v7)
            };
            table.insert(v4, v13);

            return v4;
        end;

        local v14 = {
            text = string.sub(p2, v11 + 1, v12[1] - 1),
            openTag = string.sub(p2, v7, v11),
            closeTag = "</font>"
        };
        table.insert(v4, v14);
        v3 = v12[2] + 1;
    end;

    return v4;
end;

return {
    TypeWriterEffect = RuntimeLib.async(function(p15, p16, p17) -- Line: 72
        -- upvalues: HttpService (copy), u1 (copy), parseRichText (copy), RuntimeLib (copy)
        local v18 = HttpService:GenerateGUID(false);
        u1[p15] = v18;
        local v19 = { string.find(p16, "<font", 1, true) } == nil and {
            {
                openTag = "",
                closeTag = "",
                text = p16
            }
        } or parseRichText(p16);
        local v20 = 0;

        for _, v in v19 do
            v20 = v20 + #v.text;
        end;

        local v21 = v20 <= 0 and 0 or math.min(p17 / v20, 0.05);
        local v22 = table.create(#v19);

        local function _() -- Line: 88
            return 0;
        end;

        for i, _ in v19 do
            local _ = i - 1;
            v22[i] = 0;
        end;

        for i = 0, #v19 - 1 do
            for i2 = 1, #v19[i + 1].text do
                if u1[p15] ~= v18 then
                    return nil;
                end;

                v22[i + 1] = i2;
                local v23 = "";

                for i3 = 0, #v19 - 1 do
                    local v24 = v19[i3 + 1];
                    local v25 = string.sub(v24.text, 1, v22[i3 + 1]);

                    if v24.openTag ~= "" then
                        v25 = `{v24.openTag}{v25}{v24.closeTag}`;
                    end;

                    v23 = v23 .. v25;
                end;

                p15.Text = v23;
                RuntimeLib.await(RuntimeLib.Promise.delay(v21));
            end;
        end;

        if u1[p15] == v18 then
            u1[p15] = nil;
        end;
    end)
};