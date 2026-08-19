-- Decompiled with Potassium's decompiler.

local ContentProvider = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ContentProvider;

return {
    NpcPreload = {
        preload = function(p1) -- Line: 7, Name: preload
            -- upvalues: ContentProvider (copy)
            local function v3(p2) -- Line: 10
                return p2:IsA("MeshPart") or p2:IsA("SpecialMesh") or (p2:IsA("Decal") or p2:IsA("Shirt") or (p2:IsA("Pants") or p2:IsA("Animation")));
            end;

            local v4 = 0;
            local u5 = {};

            for i, v in p1 do
                if v3(v, i - 1, p1) == true then
                    v4 = v4 + 1;
                    u5[v4] = v;
                end;
            end;

            if #u5 == 0 then
                return nil;
            end;

            pcall(function() -- Line: 25
                -- upvalues: ContentProvider (ref), u5 (copy)
                return ContentProvider:PreloadAsync(u5);
            end);
        end
    }
};