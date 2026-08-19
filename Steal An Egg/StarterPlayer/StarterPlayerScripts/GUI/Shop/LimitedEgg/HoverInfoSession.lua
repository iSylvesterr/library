-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Assets = require(ReplicatedStorage.Directory.Assets);
local InfoOverlay = require(ReplicatedStorage.Library.Client.InfoOverlay);
require(ReplicatedStorage.Directory.LimitedEgg.Types.Interface);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
require(ReplicatedStorage.Library.Modules.Packages.Trove);
require(script.Parent.Types.Interface);
local Directory = Assets.Directory;
local u1 = Log.new();
local v2 = {};

local function bindInfoFade(p3, p4, u5) -- Line: 31
    -- upvalues: Tween (copy)
    local u6 = nil;
    local u7 = false;
    local u8 = 0;

    local function clearTween() -- Line: 36
        -- upvalues: u6 (ref)
        local v9 = u6;
        u6 = nil;

        if v9 ~= nil then
            v9:Cancel();
            v9:Destroy();
        end;
    end;

    local function fadeTo(p10) -- Line: 45
        -- upvalues: u6 (ref), Tween (ref), u5 (copy)
        local v11 = u6;
        u6 = nil;

        if v11 ~= nil then
            v11:Cancel();
            v11:Destroy();
        end;

        local u12 = Tween(u5, {
            GroupTransparency = p10
        }, { 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });
        u6 = u12;
        u12.Completed:Once(function() -- Line: 53
            -- upvalues: u6 (ref), u12 (copy)
            if u6 ~= u12 then
                return;
            end;

            u6 = nil;
            u12:Destroy();
        end);
    end;

    u5.GroupTransparency = 1;
    p3:Add(p4.Activated:Connect(function() -- Line: 64
        -- upvalues: u8 (ref), u7 (ref), fadeTo (copy)
        u8 = u8 + 1;
        local u13 = u8;

        if u7 then
            u7 = false;
            fadeTo(1);

            return;
        end;

        u7 = true;
        fadeTo(0);
        task.delay(8, function() -- Line: 74
            -- upvalues: u13 (copy), u8 (ref), u7 (ref), fadeTo (ref)
            if u13 == u8 then
                u7 = false;
                fadeTo(1);
            end;
        end);
    end));
    p3:Add(function() -- Line: 82
        -- upvalues: u6 (ref), u5 (copy)
        local v14 = u6;
        u6 = nil;

        if v14 ~= nil then
            v14:Cancel();
            v14:Destroy();
        end;

        u5.GroupTransparency = 1;
    end);
end;

function v2.Start(p15, p16, p17, p18, p19) -- Line: 92
    -- upvalues: Asserts (copy), Directory (copy), InfoOverlay (copy), bindInfoFade (copy), u1 (copy)
    Asserts.table(p15);
    Asserts.GuiObject(p16);
    Asserts.GuiObject(p17);
    assert(#p18 == #p19, "Limited egg hover session requires one authored slot per entry");

    for i, v in ipairs(p19) do
        local v20 = Directory[v.AssetId];
        p15:Add(InfoOverlay.Hook(p18[i].Frame, {
            { "Title", v20.DisplayName },
            { "Rarity", v20.Rarity._id }
        }));
    end;

    bindInfoFade(p15, p16, p17);
    u1:AtTrace():Log("Limited egg hover info session opened");
end;

return v2;