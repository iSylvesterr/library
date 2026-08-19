-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local WaitFor = require(ReplicatedStorage.Library.Modules.Packages.WaitFor);
local GuardWakeLookAt = require(script.Parent.GuardWakeLookAt);
local u1 = Log.new();
local u2 = {};
u2.__index = u2;
u2.__class = "GuardComponent";
local u3 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true);

function u2.new(p4) -- Line: 49
    -- upvalues: Asserts (copy), u2 (copy), WaitFor (copy), Trove (copy), GuardWakeLookAt (copy)
    Asserts.Model(p4);
    local u5 = setmetatable({}, u2);
    local Guard = p4:WaitForChild("Guard");
    local v6 = Guard:IsA("Model");
    local v7 = `{p4:GetFullName()}.Guard must be a Model`;
    assert(v6, v7);
    local v8, v9 = WaitFor.Descendant(Guard, "Head"):await();

    if v8 then
        v8 = v9 ~= nil;
    end;

    local v10 = `{Guard:GetFullName()} requires a Head descendant for alert GUI`;
    assert(v8, v10);
    local v11 = v9:IsA("BasePart");
    local v12 = `{v9:GetFullName()} must be a BasePart`;
    assert(v11, v12);
    local v13;

    if p4.Name == "Forest" then
        v13 = Guard:WaitForChild("HumanoidRootPart");
        local v14 = `{Guard:GetFullName()} requires a HumanoidRootPart descendant for Forest shake effects`;
        assert(v13, v14);
        local v15 = v13:IsA("BasePart");
        local v16 = `{v13:GetFullName()} must be a BasePart`;
        assert(v15, v16);
    else
        v13 = nil;
    end;

    local v17, v18 = WaitFor.Descendant(v9, "AlertGui"):await();

    if v17 then
        if v18 then
            v17 = v18:IsA("BillboardGui");
        else
            v17 = v18;
        end;
    end;

    local v19 = `{v9:GetFullName()} requires an AlertGui descendant`;
    assert(v17, v19);
    u5._alertGuiTemplate = v18;
    u5._alertGui = nil;
    u5._guardModel = Guard;
    u5._head = v9;
    u5._lastAlertAt = (-1 / 0);
    u5._root = v13;
    u5._sleepColorTrove = Trove.new();
    u5._trove = Trove.new();

    if not Guard:GetAttribute("HeadLookAtDisabled") then
        u5._wakeLookAt = GuardWakeLookAt.new(Guard);
    end;

    u5._trove:Add(u5._sleepColorTrove);
    u5._trove:Add(Guard:GetAttributeChangedSignal("TargetPlayer"):Connect(function() -- Line: 87
        -- upvalues: u5 (copy)
        u5:_updateTargetAlert();
    end));
    u5._trove:Add(Guard:GetAttributeChangedSignal("Sleeping"):Connect(function() -- Line: 90
        -- upvalues: u5 (copy), Guard (copy)
        u5:_applySleepVfx();

        if Guard:GetAttribute("Sleeping") == true then
            u5:_clearAlert();
        end;
    end));
    u5._trove:Add(Guard:GetAttributeChangedSignal("GuardState"):Connect(function() -- Line: 96
        -- upvalues: u5 (copy)
        u5:_applySleepVfx();
        u5:_applyGuardStatePresentation();
    end));
    u5._trove:Add(Guard:GetAttributeChangedSignal("WakeTargetPlayer"):Connect(function() -- Line: 100
        -- upvalues: u5 (copy)
        u5:_applyGuardStatePresentation();
    end));
    u5:_applySleepVfx();
    u5:_applyGuardStatePresentation();
    u5:_updateTargetAlert();
    local u20 = false;
    u5._trove:Add(Guard.DescendantAdded:Connect(function(p21) -- Line: 108
        -- upvalues: u20 (ref), u5 (copy)
        if not p21:IsA("BasePart") then
            return;
        end;

        task.delay(1, function() -- Line: 112
            -- upvalues: u20 (ref), u5 (ref)
            if not u20 then
                u20 = true;
                u5:_applyGuardStatePresentation();
                task.wait(1);
                u20 = false;
            end;
        end);
    end));

    return u5;
end;

function u2._updateTargetAlert(p22) -- Line: 129
    local v23 = p22._guardModel:GetAttribute("TargetPlayer");

    if typeof(v23) ~= "string" or v23 == "" then
        return;
    end;

    local v24 = os.clock();

    if v24 - p22._lastAlertAt < 3 then
        return;
    end;

    p22._lastAlertAt = v24;
    p22:_showAlert();
end;

function u2._applySleepVfx(p25) -- Line: 144
    -- upvalues: u1 (copy)
    local v26 = p25._guardModel:GetAttribute("GuardState") == "Sleeping";
    local SleepVFXAttachment = p25._guardModel:FindFirstChild("SleepVFXAttachment", true);

    if SleepVFXAttachment then
        for _, descendant in ipairs(SleepVFXAttachment:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = v26;

                if not v26 then
                    descendant:Clear();
                end;
            end;
        end;

        return;
    end;

    u1:AtWarning():Log((`Guard model {p25._guardModel:GetFullName()} is missing SleepVFXAttachment`));
end;

function u2._applyGuardStatePresentation(p27) -- Line: 162
    -- upvalues: Asserts (copy)
    local v28 = p27._guardModel:GetAttribute("GuardState");
    local v29 = p27._guardModel:GetAttribute("WakeTargetPlayer");
    Asserts.optional.string(v29);

    if p27._wakeLookAt then
        if v29 == "" then
            v29 = nil;
        end;

        p27._wakeLookAt:SetWaking(v28 == "Waking", v29);
    end;

    if v28 == "Sleeping" then
        p27:_applySleepDetailColors();

        return;
    end;

    if v28 ~= "Waking" then
        return;
    end;

    p27:_animateSleepDetailColorsToOriginal();
end;

function u2._applySleepDetailColors(p30) -- Line: 185
    p30._sleepColorTrove:Clean();

    for _, descendant in ipairs(p30._guardModel:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local v31 = descendant:GetAttribute("SleepColor");

            if v31 then
                if descendant:GetAttribute("OriginalColor") == nil then
                    descendant:SetAttribute("OriginalColor", descendant.Color);
                end;

                descendant.Color = v31;
            end;
        end;
    end;
end;

function u2._animateSleepDetailColorsToOriginal(p32) -- Line: 205
    p32._sleepColorTrove:Clean();

    for _, descendant in ipairs(p32._guardModel:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant:GetAttribute("SleepColor") then
            local v33 = descendant:GetAttribute("OriginalColor");

            if v33 == nil then
                v33 = descendant.Color;
                descendant:SetAttribute("OriginalColor", v33);
            end;

            assert(v33, "luau");
            descendant.Color = v33;
        end;
    end;
end;

function u2._clearAlert(p34) -- Line: 223
    local _alertGui = p34._alertGui;

    if _alertGui == nil then
        return;
    end;

    p34._alertGui = nil;
    _alertGui:Destroy();
end;

function u2._showAlert(u35) -- Line: 233
    -- upvalues: Tween (copy), u1 (copy)
    if u35._alertGui ~= nil then
        return;
    end;

    local u36 = u35._alertGuiTemplate:Clone();
    local u37 = assert(u36:FindFirstChildWhichIsA("ImageLabel"));
    u37.Transparency = 1;
    u36.AlwaysOnTop = true;
    u36.Enabled = true;
    u36.Parent = u35._head;
    u35._alertGui = u36;
    u35._trove:Add(u36);
    Tween(u37, {
        ImageTransparency = 0
    }, { 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });
    Tween(u36, {
        StudsOffset = u36.StudsOffset + Vector3.new(0, 1, 0) * math.max(u36.StudsOffset.Y * 0.6, 1)
    }, { 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out }).Completed:Once(function() -- Line: 254
        -- upvalues: Tween (ref), u37 (copy)
        task.wait(1);
        Tween(u37, {
            ImageTransparency = 1
        }, { 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });
    end);
    task.delay(3, function() -- Line: 259
        -- upvalues: u36 (copy), u35 (copy)
        if u36.Parent == nil then
            return;
        end;

        if u35._alertGui == u36 then
            u35._alertGui = nil;
        end;

        u36:Destroy();
    end);
    u1:AtTrace():Log((`Guard alert shown for {u35._guardModel:GetFullName()}`));
end;

function u2.Destroy(p38) -- Line: 277
    if p38._wakeLookAt then
        p38._wakeLookAt:Destroy();
    end;

    p38._trove:Destroy();
end;

function u2.GetGuardModel(p39) -- Line: 284
    return p39._guardModel;
end;

function u2.PlayWakeUp(p40) -- Line: 288
    -- upvalues: TweenService (copy), u3 (copy), Debris (copy)
    local Highlight = Instance.new("Highlight");
    Highlight.Name = "GuardWakeHighlight";
    Highlight.FillColor = Color3.fromRGB(255, 0, 0);
    Highlight.OutlineColor = Color3.fromRGB(132, 0, 0);
    Highlight.FillTransparency = 1;
    Highlight.OutlineTransparency = 1;
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    Highlight.Parent = p40._guardModel;
    TweenService:Create(Highlight, u3, {
        FillTransparency = 0.35,
        OutlineTransparency = 0
    }):Play();
    Debris:AddItem(Highlight, u3.Time * 2 + 0.05);
end;

return u2;