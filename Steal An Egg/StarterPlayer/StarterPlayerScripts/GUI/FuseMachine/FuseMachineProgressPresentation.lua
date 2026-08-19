-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Library.Types.FuseMachine);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = Log.new();
local u2 = {};
u2.__index = u2;
u2.__class = "FuseMachineProgressPresentation";
local u3 = Vector2.new(0, -0.5);
local u4 = Vector2.new(0, 0.5);
local u5 = Color3.new(1, 1, 1);
local u6 = Color3.new(0, 0, 0);
local u7 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u8 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u9 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 1, true);
local u10 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u11 = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out);

function u2.new(p12, p13) -- Line: 73
    -- upvalues: Asserts (copy), u2 (copy), Trove (copy)
    Asserts.Folder(p12);
    Asserts.Frame(p13);
    local v14 = setmetatable({}, u2);
    v14._connectorStates = {};
    v14._connectorTroves = {};
    v14._icon = p13.Icon;
    Asserts.ImageLabel(v14._icon);
    v14._iconOriginalBackgroundColor = v14._icon.BackgroundColor3;
    v14._iconOriginalColor = v14._icon.ImageColor3;
    v14._iconOriginalImage = v14._icon.Image;
    v14._iconOriginalTransparency = v14._icon.ImageTransparency;
    v14._iconScale = Instance.new("UIScale");
    v14._iconScale.Name = "FuseProgressScale";
    v14._iconScale.Parent = v14._icon;
    v14._iconOriginalScale = v14._iconScale.Scale;
    v14._iconTrove = Trove.new();
    v14._outputFill = p13.FillContainer.Frame;
    Asserts.Frame(v14._outputFill);
    v14._outputOriginalSize = v14._outputFill.Size;
    v14._outputTrove = Trove.new();
    v14._selectedCount = nil;
    v14._trove = Trove.new();
    v14._trove:Add(v14._iconScale);
    v14._trove:Add(v14._iconTrove);
    v14._trove:Add(v14._outputTrove);

    for _, v in ipairs({ p12["1"], p12["2"], p12["3"] }) do
        Asserts.ImageLabel(v);
        local Fill = v.Fill;
        Asserts.ImageLabel(Fill);
        local UIGradient = Fill.UIGradient;
        Asserts.UIGradient(UIGradient);
        table.insert(v14._connectorStates, {
            Fill = Fill,
            Gradient = UIGradient,
            OriginalColor = Fill.ImageColor3,
            OriginalOffset = UIGradient.Offset
        });
        local v15 = Trove.new();
        table.insert(v14._connectorTroves, v15);
        v14._trove:Add(v15);
    end;

    return v14;
end;

function u2._setConnectorState(p16, p17, p18) -- Line: 129
    -- upvalues: u4 (copy), u3 (copy)
    local v19 = p16._connectorStates[p17];
    local v20 = `Missing FuseMachine connector state {p17}`;
    assert(v19 ~= nil, v20);
    local v21 = p16._connectorTroves[p17];
    local v22 = `Missing FuseMachine connector trove {p17}`;
    assert(v21 ~= nil, v22);
    v21:Clean();
    local v23;

    if p18 then
        v23 = u4;
    else
        v23 = u3;
    end;

    v19.Gradient.Offset = v23;
    v19.Fill.ImageColor3 = v19.OriginalColor;
end;

function u2._animateConnector(p24, p25) -- Line: 143
    -- upvalues: TweenService (copy), u7 (copy), u4 (copy), u9 (copy), u5 (copy)
    p24:_setConnectorState(p25, false);
    local u26 = p24._connectorStates[p25];
    local v27 = `Missing FuseMachine connector state {p25}`;
    assert(u26 ~= nil, v27);
    local v28 = p24._connectorTroves[p25];
    local v29 = `Missing FuseMachine connector trove {p25}`;
    assert(v28 ~= nil, v29);
    local u30 = TweenService:Create(u26.Gradient, u7, {
        Offset = u4
    });
    local u31 = TweenService:Create(u26.Fill, u9, {
        ImageColor3 = u5
    });
    v28:Add(function() -- Line: 152
        -- upvalues: u30 (copy)
        u30:Cancel();
        u30:Destroy();
    end);
    v28:Add(function() -- Line: 156
        -- upvalues: u31 (copy)
        u31:Cancel();
        u31:Destroy();
    end);
    v28:Add(u31.Completed:Connect(function(p32) -- Line: 160
        -- upvalues: u26 (copy)
        if p32 == Enum.PlaybackState.Completed then
            u26.Fill.ImageColor3 = u26.OriginalColor;
        end;
    end));
    v28:Add(u30.Completed:Connect(function(p33) -- Line: 165
        -- upvalues: u31 (copy), u26 (copy)
        if p33 == Enum.PlaybackState.Completed then
            u31:Cancel();
            u26.Fill.ImageColor3 = u26.OriginalColor;
        end;
    end));
    u30:Play();
    u31:Play();
end;

function u2._setOutputProgress(p34, p35, p36) -- Line: 175
    -- upvalues: TweenService (copy), u8 (copy)
    p34._outputTrove:Clean();
    local v37 = UDim2.new(p34._outputOriginalSize.X.Scale, p34._outputOriginalSize.X.Offset, p35 / 3, 0);

    if not p36 then
        p34._outputFill.Size = v37;

        return;
    end;

    local u38 = TweenService:Create(p34._outputFill, u8, {
        Size = v37
    });
    p34._outputTrove:Add(function() -- Line: 193
        -- upvalues: u38 (copy)
        u38:Cancel();
        u38:Destroy();
    end);
    u38:Play();
end;

function u2._setIncompleteIcon(p39) -- Line: 200
    -- upvalues: u6 (copy)
    p39._iconTrove:Clean();
    p39._icon.ImageTransparency = 0.1;
    p39._icon.ImageColor3 = u6;
    p39._icon.BackgroundColor3 = u6;
    p39._iconScale.Scale = p39._iconOriginalScale;
end;

function u2._setReadyIcon(u40, p41) -- Line: 208
    -- upvalues: u5 (copy), TweenService (copy), u10 (copy), u11 (copy)
    u40._iconTrove:Clean();
    u40._icon.ImageTransparency = 0;
    u40._icon.ImageColor3 = u5;
    u40._icon.BackgroundColor3 = u5;
    u40._iconScale.Scale = u40._iconOriginalScale;

    if not p41 then
        return;
    end;

    u40._iconScale.Scale = 0.8;
    local u42 = TweenService:Create(u40._iconScale, u10, {
        Scale = u40._iconOriginalScale * 1.2
    });
    u40._iconTrove:Add(function() -- Line: 222
        -- upvalues: u42 (copy)
        u42:Cancel();
        u42:Destroy();
    end);
    u40._iconTrove:Add(u42.Completed:Connect(function(p43) -- Line: 226
        -- upvalues: u40 (copy), TweenService (ref), u11 (ref)
        if p43 ~= Enum.PlaybackState.Completed or u40._selectedCount ~= 3 then
            return;
        end;

        local u44 = TweenService:Create(u40._iconScale, u11, {
            Scale = u40._iconOriginalScale
        });
        u40._iconTrove:Add(function() -- Line: 233
            -- upvalues: u44 (copy)
            u44:Cancel();
            u44:Destroy();
        end);
        u44:Play();
    end));
    u42:Play();
end;

function u2.Update(p45, p46, p47) -- Line: 246
    -- upvalues: Asserts (copy)
    Asserts.integerNonNegative(p46);
    Asserts.cond(p46 <= 3);
    Asserts.optional.string(p47);

    if p46 == 0 then
        p45._icon.Image = p45._iconOriginalImage;
    else
        local v48;

        if p47 == nil then
            v48 = false;
        else
            v48 = p47 ~= "";
        end;

        assert(v48, "Selected FuseMachine category requires an egg icon");
        p45._icon.Image = p47;
    end;

    local _selectedCount = p45._selectedCount;

    if _selectedCount == p46 then
        return;
    end;

    p45._selectedCount = p46;

    if _selectedCount ~= nil then
        if _selectedCount < p46 then
            for i = _selectedCount + 1, p46 do
                p45:_animateConnector(i);
            end;
        else
            for i = p46 + 1, _selectedCount do
                p45:_setConnectorState(i, false);
            end;
        end;

        p45:_setOutputProgress(p46, true);

        if p46 == 3 then
            p45:_setReadyIcon(true);

            return;
        end;

        p45:_setIncompleteIcon();

        return;
    end;

    p45:_setConnectorState(1, p46 >= 1);
    p45:_setConnectorState(2, p46 >= 2);
    p45:_setConnectorState(3, p46 >= 3);
    p45:_setOutputProgress(p46, false);

    if p46 == 3 then
        p45:_setReadyIcon(false);

        return;
    end;

    p45:_setIncompleteIcon();
end;

function u2.Destroy(p49) -- Line: 297
    -- upvalues: u1 (copy)
    p49._trove:Destroy();

    for _, v in ipairs(p49._connectorStates) do
        v.Fill.ImageColor3 = v.OriginalColor;
        v.Gradient.Offset = v.OriginalOffset;
    end;

    p49._outputFill.Size = p49._outputOriginalSize;
    p49._icon.Image = p49._iconOriginalImage;
    p49._icon.ImageTransparency = p49._iconOriginalTransparency;
    p49._icon.ImageColor3 = p49._iconOriginalColor;
    p49._icon.BackgroundColor3 = p49._iconOriginalBackgroundColor;
    u1:AtTrace():Log("Destroyed FuseMachine progress presentation");
end;

return u2;