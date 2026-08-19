-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = {};
local Client = ReplicatedStorage.Library.Client;
local Packages = ReplicatedStorage.Library.Modules.Packages;
local WeatherEffectController = require(Client.WeatherEffectController);
local WeatherSoundsController = require(Client.WeatherSoundsController);
local CycleController = require(Client.CycleController);
local u2 = require(Packages.Trove).new();

function v1.OnStart(p3) -- Line: 15
    -- upvalues: ReplicatedStorage (copy), u2 (copy), WeatherSoundsController (copy), CycleController (copy), WeatherEffectController (copy)
    ReplicatedStorage:SetAttribute("Effect_Space", true);
    u2:Add(function() -- Line: 17
        -- upvalues: ReplicatedStorage (ref)
        ReplicatedStorage:SetAttribute("Effect_Space", nil);
    end);
    WeatherSoundsController:UpdateOST();
    CycleController:Update();
    local u4 = u2:Extend();
    local u5 = true;
    u2:Add(function() -- Line: 24
        -- upvalues: u5 (ref)
        u5 = false;
    end);
    local u6 = nil;

    local function runUpdate() -- Line: 28
        -- upvalues: ReplicatedStorage (ref), u5 (ref), u6 (ref), WeatherEffectController (ref), WeatherSoundsController (ref), CycleController (ref), u4 (copy)
        local v7 = ReplicatedStorage:GetAttribute("NyanCatsEvent");
        local v8;

        if u5 then
            if v7 then
                v8 = script.Nyan;
            else
                v8 = script.Space;
            end;
        else
            v8 = nil;
        end;

        if v8 == u6 then
            return;
        end;

        u6 = v8;
        WeatherEffectController:Activate("Blink");
        WeatherSoundsController:UpdateOST();
        CycleController:Update();
        u4:Destroy();

        if v8 then
            local v9 = u4:Clone(v8);
            v9.Parent = workspace;
            v9.spacemeshbg.Transparency = 0;

            for _, descendant in v9:GetDescendants() do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
                    descendant.Enabled = true;
                end;
            end;
        end;
    end;

    ReplicatedStorage:GetAttributeChangedSignal("NyanCatsEvent"):Connect(runUpdate);
    u2:Add(task.spawn(runUpdate));
    u2:Add(runUpdate);
end;

function v1.OnStop(p10) -- Line: 55
    -- upvalues: u2 (copy)
    u2:Destroy();
end;

function v1.OnLoad(p11) -- Line: 59
end;

return v1;