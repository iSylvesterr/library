-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = {};
u1.__index = u1;
u1.__class = "GuiTransitionGroup";

function u1.new(p2, p3, p4) -- Line: 43
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.Instance(p2);
    Asserts.Instance(p3);
    Asserts.number(p4);
    local v5 = setmetatable({}, u1);
    v5._activeTweens = {};
    v5._positionRecords = {};
    v5._transparencyRecords = {};

    for _, descendant in ipairs(p2:GetDescendants()) do
        local v6 = {
            BackgroundTransparency = nil,
            GroupTransparency = nil,
            ImageTransparency = nil,
            TextStrokeTransparency = nil,
            TextTransparency = nil,
            Transparency = nil,
            Instance = descendant
        };
        local v7;

        if descendant:IsA("GuiObject") then
            v6.BackgroundTransparency = descendant.BackgroundTransparency;
            v7 = true;
        else
            v7 = false;
        end;

        if descendant:IsA("CanvasGroup") then
            v6.GroupTransparency = descendant.GroupTransparency;
            v7 = true;
        end;

        if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            v6.ImageTransparency = descendant.ImageTransparency;
            v7 = true;
        end;

        if descendant:IsA("TextLabel") or (descendant:IsA("TextButton") or descendant:IsA("TextBox")) then
            v6.TextTransparency = descendant.TextTransparency;
            v6.TextStrokeTransparency = descendant.TextStrokeTransparency;
            v7 = true;
        end;

        if descendant:IsA("UIStroke") then
            v6.Transparency = descendant.Transparency;
            v7 = true;
        end;

        if v7 then
            v5._transparencyRecords[#v5._transparencyRecords + 1] = v6;
        end;
    end;

    for _, child in ipairs(p3:GetChildren()) do
        if child:IsA("GuiObject") then
            local Position = child.Position;
            v5._positionRecords[#v5._positionRecords + 1] = {
                GuiObject = child,
                OriginalPosition = Position,
                OffsetPosition = UDim2.new(Position.X.Scale, Position.X.Offset, Position.Y.Scale - p4, Position.Y.Offset)
            };
        end;
    end;

    return v5;
end;

function u1._playTween(p8, p9, p10, p11) -- Line: 115
    -- upvalues: TweenService (copy)
    local v12 = TweenService:Create(p9, p10, p11);
    p8._activeTweens[#p8._activeTweens + 1] = v12;
    v12:Play();
end;

function u1.Cancel(p13) -- Line: 130
    for _, v in ipairs(p13._activeTweens) do
        v:Cancel();
    end;

    table.clear(p13._activeTweens);
end;

function u1.PrepareHidden(p14) -- Line: 137
    for _, v in ipairs(p14._transparencyRecords) do
        local Instance = v.Instance;

        if v.BackgroundTransparency ~= nil then
            Instance.BackgroundTransparency = 1;
        end;

        if v.GroupTransparency ~= nil then
            Instance.GroupTransparency = 1;
        end;

        if v.ImageTransparency ~= nil then
            local v15 = Instance:IsA("ImageLabel") or Instance:IsA("ImageButton");
            local v16 = `{Instance:GetFullName()} must render images`;
            assert(v15, v16);
            Instance.ImageTransparency = 1;
        end;

        if v.TextTransparency ~= nil then
            local v17 = Instance:IsA("TextLabel") or (Instance:IsA("TextButton") or Instance:IsA("TextBox"));
            local v18 = `{Instance:GetFullName()} must render text`;
            assert(v17, v18);
            Instance.TextTransparency = 1;
        end;

        if v.TextStrokeTransparency ~= nil then
            local v19 = Instance:IsA("TextLabel") or (Instance:IsA("TextButton") or Instance:IsA("TextBox"));
            local v20 = `{Instance:GetFullName()} must render text strokes`;
            assert(v19, v20);
            Instance.TextStrokeTransparency = 1;
        end;

        if v.Transparency ~= nil then
            Instance.Transparency = 1;
        end;
    end;

    for _, v in ipairs(p14._positionRecords) do
        v.GuiObject.Position = v.OffsetPosition;
    end;
end;

function u1.TweenVisible(p21, p22) -- Line: 180
    for _, v in ipairs(p21._transparencyRecords) do
        local v23 = {};

        if v.BackgroundTransparency ~= nil then
            v23.BackgroundTransparency = v.BackgroundTransparency;
        end;

        if v.GroupTransparency ~= nil then
            v23.GroupTransparency = v.GroupTransparency;
        end;

        if v.ImageTransparency ~= nil then
            v23.ImageTransparency = v.ImageTransparency;
        end;

        if v.TextTransparency ~= nil then
            v23.TextTransparency = v.TextTransparency;
        end;

        if v.TextStrokeTransparency ~= nil then
            v23.TextStrokeTransparency = v.TextStrokeTransparency;
        end;

        if v.Transparency ~= nil then
            v23.Transparency = v.Transparency;
        end;

        p21:_playTween(v.Instance, p22, v23);
    end;

    for _, v in ipairs(p21._positionRecords) do
        p21:_playTween(v.GuiObject, p22, {
            Position = v.OriginalPosition
        });
    end;
end;

function u1.TweenHidden(p24, p25) -- Line: 211
    for _, v in ipairs(p24._transparencyRecords) do
        local v26 = {};

        if v.BackgroundTransparency ~= nil then
            v26.BackgroundTransparency = 1;
        end;

        if v.GroupTransparency ~= nil then
            v26.GroupTransparency = 1;
        end;

        if v.ImageTransparency ~= nil then
            v26.ImageTransparency = 1;
        end;

        if v.TextTransparency ~= nil then
            v26.TextTransparency = 1;
        end;

        if v.TextStrokeTransparency ~= nil then
            v26.TextStrokeTransparency = 1;
        end;

        if v.Transparency ~= nil then
            v26.Transparency = 1;
        end;

        p24:_playTween(v.Instance, p25, v26);
    end;

    for _, v in ipairs(p24._positionRecords) do
        p24:_playTween(v.GuiObject, p25, {
            Position = v.OffsetPosition
        });
    end;
end;

function u1.RestorePositions(p27) -- Line: 242
    for _, v in ipairs(p27._positionRecords) do
        v.GuiObject.Position = v.OriginalPosition;
    end;
end;

return u1;