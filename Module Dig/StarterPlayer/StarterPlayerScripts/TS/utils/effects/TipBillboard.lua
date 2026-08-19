-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local ReplicatedStorage = v1.ReplicatedStorage;
local TweenService = v1.TweenService;
local Workspace = v1.Workspace;
local applyGoldGradient = RuntimeLib.import(script, script.Parent.Parent, "ui", "gradient", "GoldGradient").applyGoldGradient;
local formatAbbrevMoney = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatAbbrevMoney").formatAbbrevMoney;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local playWorldSound = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "sound", "SoundUtil").playWorldSound;

return {
    showTipBillboard = function(p2, p3) -- Line: 16, Name: showTipBillboard
        -- upvalues: WFChain (copy), ReplicatedStorage (copy), Workspace (copy), applyGoldGradient (copy), formatAbbrevMoney (copy), playWorldSound (copy), TweenService (copy)
        local v4 = WFChain(ReplicatedStorage, "Assets", "WorldUI", "VisitorMoney");
        local Part = Instance.new("Part");
        Part.Size = Vector3.new(0.2, 0.2, 0.2);
        Part.Transparency = 1;
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Position = p2;
        Part.Parent = Workspace;
        local v5 = v4:Clone();
        local u6 = WFChain(v5, "Money");
        local u7 = u6:FindFirstChildOfClass("UIStroke");
        applyGoldGradient(u6);
        u6.Text = `+{formatAbbrevMoney(p3)}`;
        v5.Adornee = Part;
        v5.Parent = Part;
        playWorldSound("Money Collect", {
            volume = 0.7,
            parent = Part
        });
        TweenService:Create(v5, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            StudsOffset = v5.StudsOffset + Vector3.new(0, 5, 0)
        }):Play();
        task.delay(0.9, function() -- Line: 45
            -- upvalues: TweenService (ref), u6 (copy), u7 (copy)
            local v8 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            TweenService:Create(u6, v8, {
                TextTransparency = 1
            }):Play();

            if u7 then
                TweenService:Create(u7, v8, {
                    Transparency = 1
                }):Play();
            end;
        end);
        task.delay(1.6, function() -- Line: 56
            -- upvalues: Part (copy)
            return Part:Destroy();
        end);
    end
};