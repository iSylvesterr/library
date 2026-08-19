-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Effects = script.Effects;
local Libraries = script.Libraries;
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
require(script.Types);
local u1 = {};
local v21 = {
    Init = function(u2, p3) -- Line: 15, Name: Init
        -- upvalues: Effects (copy), Libraries (copy)
        u2.Components = {};
        u2.Libraries = {};

        for _, descendant in pairs(Effects:GetDescendants()) do
            if descendant.ClassName == "ModuleScript" then
                task.spawn(function() -- Line: 20
                    -- upvalues: descendant (copy), u2 (copy)
                    local success, result = pcall(require, descendant);

                    if success then
                        u2.Components[descendant.Name] = result;
                    end;
                end);
            end;
        end;

        for _, child in pairs(Libraries:GetChildren()) do
            if child.ClassName == "ModuleScript" then
                task.spawn(function() -- Line: 30
                    -- upvalues: child (copy), u2 (copy)
                    local success, result = pcall(require, child);

                    if success then
                        u2.Libraries[child.Name] = result;
                    end;
                end);
            end;
        end;
    end,

    SplitName = function(p4, p5) -- Line: 40, Name: SplitName
        local v6 = p5:split("/");

        if v6 then
            return v6[1], v6[2];
        end;
    end,

    FetchComponent = function(p7, p8) -- Line: 48, Name: FetchComponent
        if p7.Components[p8] then
            return p7.Components[p8];
        end;

        warn(("Invalid Effect Name: %s, Component not Found."):format(p8));

        return nil;
    end,

    FetchCache = function(p9, p10, p11) -- Line: 57, Name: FetchCache
        -- upvalues: u1 (copy), Trove (copy)
        if not u1[p10] then
            u1[p10] = {};
        end;

        if not u1[p10][p11] then
            u1[p10][p11] = {
                Cache = {},
                Container = Trove.new()
            };
        end;

        return u1[p10][p11];
    end,

    Play = function(p12, p13) -- Line: 70, Name: Play
        if not p13.caster then
            warn(("No caster found in data table %s."):format((tostring(p13))));

            return false;
        end;

        local v14, v15 = p12:SplitName(p13.name_State);
        local v16 = p12:FetchComponent(v14);
        local v17;

        if v16 then
            v17 = v16[v15];
        else
            v17 = v16;
        end;

        local v18;

        if v16 then
            v18 = p12:FetchCache(p13.caster, v16);
        else
            v18 = v16;
        end;

        if v16 and (v17 and v18) then
            task.spawn(v17, {
                Caster = p13.caster,
                Parameters = p13.parameters,
                Libraries = p12.Libraries,
                Default = p12.Libraries.Default,
                Cache = v18.Cache,
                Container = v18.Container
            });

            return true;
        end;

        warn(("Component Found: %s, Callback Found: %s, Cache Found: %s."):format(tostring(v16), tostring(v17), (tostring(v18))));

        return false;
    end,

    Request = function(p19, p20) -- Line: 103, Name: Request
        error("unimplemented");
    end
};
task.spawn(v21.Init, v21, Players.LocalPlayer);

return v21;