-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
game:GetService("TweenService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Maid = require(ReplicatedStorage.Packages.Maid);
local Constants = require(ReplicatedStorage.Shared.Info.Constants);
require(ReplicatedStorage.Shared.Info.CustomEnum);
local LocalPlayer = Players.LocalPlayer;
local HoverCursorUI = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Overlay"):WaitForChild("ItemDescriptions"):WaitForChild("HoverCursorUI");
local Info = HoverCursorUI:WaitForChild("HoverInfo"):WaitForChild("Content"):WaitForChild("Info");
local UI = game.SoundService:WaitForChild("SoundEffects"):WaitForChild("UI");
UI:WaitForChild("Off");
UI:WaitForChild("On");
local Hover = UI:WaitForChild("Hover");
local v1 = Knit.CreateController({
    Name = "HoverDescriptions"
});
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = {};

local function checkWithinBounds(p7, p8) -- Line: 48
    -- upvalues: u6 (copy)
    if p8.Visible ~= true then
        return false;
    end;

    local v9 = u6[p8];

    if not v9 then
        warn("?!");
    end;

    if v9 and (v9.uiOpenFunction and v9.uiOpenFunction() ~= true) then
        return false;
    end;

    local v10;

    if p7.X >= p8.AbsolutePosition.X and (p7.X <= p8.AbsolutePosition.X + p8.AbsoluteSize.X and p7.Y >= p8.AbsolutePosition.Y) then
        v10 = p7.Y <= p8.AbsolutePosition.Y + p8.AbsoluteSize.Y;
    else
        v10 = false;
    end;

    return v10;
end;

function v1.UpdateUI(p11) -- Line: 63
    if p11.DataClient.currentData then
    end;
end;

function v1.ShowItemDesc(u12, p13, p14) -- Line: 74
    -- upvalues: u6 (copy), u3 (ref), u2 (ref), Maid (copy), Hover (copy), LocalPlayer (copy), Info (copy), HoverCursorUI (copy)
    local v15 = u6[p13];

    if not v15 then
        return;
    end;

    if u3 == p13 then
        return;
    end;

    u3 = p13;

    if u2 then
        u2:Destroy();
    end;

    u2 = Maid.new();

    if v15.doesHoverSfx then
        u12.SoundController:PlaySound(Hover, LocalPlayer, {
            PlaybackSpeed = NumberRange.new(0.8, 1.2)
        });
        u2:GiveTask(function() -- Line: 88
            -- upvalues: u12 (copy), Hover (ref), LocalPlayer (ref)
            u12.SoundController:PlaySound(Hover, LocalPlayer, {
                PlaybackSpeed = NumberRange.new(0.8, 1.2)
            });
        end);
    end;

    Info.Text = v15.descText;
    HoverCursorUI.Position = p14;
    HoverCursorUI.Visible = true;
    u2:GiveTask(function() -- Line: 100
        -- upvalues: HoverCursorUI (ref)
        HoverCursorUI.Visible = false;
    end);
end;

function v1.MoveItemDesc(p16, p17) -- Line: 105
    -- upvalues: HoverCursorUI (copy)
    HoverCursorUI.Position = p17;
end;

function v1.HideItemDesc(p18) -- Line: 109
    -- upvalues: u2 (ref), u3 (ref)
    if u2 then
        u2:Destroy();
    end;

    u2 = nil;
    u3 = nil;
end;

function v1.SetupHoverCell(p19, p20, p21, p22, p23, p24) -- Line: 119
    -- upvalues: u6 (copy)
    if u6[p20] then
        return;
    end;

    u6[p20] = {};
    u6[p20].descText = p21;
    u6[p20].clickFunction = p23;
    u6[p20].uiOpenFunction = p22;
    u6[p20].doesHoverSfx = p24;
end;

function v1.RemoveHoverCell(p25, p26) -- Line: 128
    -- upvalues: u3 (ref), u6 (copy)
    if u3 == p26 then
        u3 = nil;
        p25:HideItemDesc();
    end;

    if not u6[p26] then
        return;
    end;

    u6[p26] = nil;
end;

function v1.KnitStart(u27) -- Line: 142
    -- upvalues: UserInputService (copy), u3 (ref), checkWithinBounds (copy), u6 (copy), u4 (ref), u5 (ref), Constants (copy)
    UserInputService.InputChanged:Connect(function(p28, p29) -- Line: 143
        -- upvalues: u3 (ref), checkWithinBounds (ref), u27 (copy), u6 (ref)
        if p28.UserInputType == Enum.UserInputType.MouseMovement then
            if u3 then
                if checkWithinBounds(Vector2.new(p28.Position.X, p28.Position.Y), u3) then
                    u27:MoveItemDesc(UDim2.fromOffset(p28.Position.X, p28.Position.Y));

                    return;
                end;

                u27:HideItemDesc();

                return;
            end;

            for i, _ in u6 do
                if checkWithinBounds(Vector2.new(p28.Position.X, p28.Position.Y), i) then
                    u27:ShowItemDesc(i, UDim2.fromOffset(p28.Position.X, p28.Position.Y));

                    return;
                end;
            end;
        end;
    end);
    UserInputService.InputBegan:Connect(function(p30, p31) -- Line: 166
        -- upvalues: u3 (ref), checkWithinBounds (ref), u27 (copy), u6 (ref), u4 (ref), u5 (ref)
        if p30.UserInputType ~= Enum.UserInputType.Touch then
            if p30.UserInputType == Enum.UserInputType.MouseButton1 then
                local v32 = nil;

                for i, _ in u6 do
                    if checkWithinBounds(Vector2.new(p30.Position.X, p30.Position.Y), i) then
                        v32 = i;
                        break;
                    end;
                end;

                if v32 then
                    u4 = v32;

                    return;
                end;

                u4 = nil;
            end;

            return;
        end;

        if u3 and checkWithinBounds(Vector2.new(p30.Position.X, p30.Position.Y), u3) == false then
            u27:HideItemDesc();
        end;

        local v33 = nil;

        for i, _ in u6 do
            if checkWithinBounds(Vector2.new(p30.Position.X, p30.Position.Y), i) then
                v33 = i;
                break;
            end;
        end;

        if not v33 then
            u4 = nil;

            return;
        end;

        u4 = v33;
        u5 = os.clock();
    end);
    UserInputService.InputEnded:Connect(function(p34, p35) -- Line: 211
        -- upvalues: u3 (ref), u6 (ref), checkWithinBounds (ref), u4 (ref), u5 (ref), Constants (ref), u27 (copy)
        if p34.UserInputType == Enum.UserInputType.Touch then
            if not u3 then
                local v36 = nil;

                for i, _ in u6 do
                    if checkWithinBounds(Vector2.new(p34.Position.X, p34.Position.Y), i) then
                        v36 = i;
                        break;
                    end;
                end;

                if v36 and v36 == u4 then
                    u4 = nil;

                    if os.clock() - u5 >= Constants.LONG_PRESS_TIME then
                        local AbsolutePosition = v36.AbsolutePosition;
                        u27:ShowItemDesc(v36, UDim2.fromOffset(AbsolutePosition.X + v36.AbsoluteSize.X, AbsolutePosition.Y));
                        u4 = nil;

                        return;
                    end;

                    if u6[v36].clickFunction then
                        u6[v36].clickFunction();
                        u4 = nil;
                    end;
                end;
            end;
        elseif p34.UserInputType == Enum.UserInputType.MouseButton1 then
            local v37 = nil;

            for i, _ in u6 do
                if checkWithinBounds(Vector2.new(p34.Position.X, p34.Position.Y), i) then
                    v37 = i;
                    break;
                end;
            end;

            if v37 and (v37 == u4 and u6[v37].clickFunction) then
                u6[v37].clickFunction();
                u4 = nil;
            end;
        end;
    end);
end;

function v1.KnitInit(p38) -- Line: 263
    -- upvalues: Knit (copy)
    p38.DataClient = Knit.GetController("DataClient");
    p38.UI_Manager = Knit.GetController("UI_Manager");
    p38.UserInputParser = Knit.GetController("UserInputParser");
    p38.NotificationController = Knit.GetController("NotificationController");
    p38.SoundController = Knit.GetController("SoundController");
end;

return v1;