-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Maid = require(ReplicatedStorage.Packages.Maid);
local u1 = UDim2.new(0.269, 0, 0.436, 0);
local u2 = UDim2.new(0.388, 0, 0.407, 0);
local u3 = UDim2.new(0.12, 0, 0, 0);
local u4 = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local v5 = Knit.CreateController({
    Name = "SellStandController"
});

function v5.KnitStart(p6) -- Line: 27
    -- upvalues: Maid (copy), Knit (copy), Players (copy), UserInputService (copy), u2 (copy), u1 (copy), u3 (copy), TweenService (copy), u4 (copy), RunService (copy)
    local v7 = Maid.new();
    local u8 = Knit.GetService("SellStandService");
    local UI_Manager = p6.UI_Manager;
    local SoundController = p6.SoundController;
    local LocalPlayer = Players.LocalPlayer;
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local SellStand = workspace:WaitForChild("BigField"):WaitForChild("SellStand");
    SellStand:WaitForChild("PromptHolder"):WaitForChild("ProximityPrompt").Enabled = false;
    local u9, v10 = SellStand:GetBoundingBox();
    local u11 = v10.X / 2;
    local u12 = v10.Z / 2;

    local function inZone(p13, p14) -- Line: 50
        -- upvalues: u9 (copy), u11 (copy), u12 (copy)
        local v15 = u9:PointToObjectSpace(p13);
        local v16;

        if math.abs(v15.X) <= u11 + 2 + p14 and v15.Z <= u12 + p14 then
            v16 = v15.Z >= -u12 - 6 - p14;
        else
            v16 = false;
        end;

        return v16;
    end;

    local SellStuff = PlayerGui:WaitForChild("HUD"):WaitForChild("Center"):WaitForChild("SellStuff");
    SellStuff.Size = UserInputService.TouchEnabled and not UserInputService.MouseEnabled and u2 or u1;
    local Button = SellStuff:WaitForChild("SellAll"):WaitForChild("Button");
    local Button2 = SellStuff:WaitForChild("SellThis"):WaitForChild("Button");
    local Button3 = SellStuff:WaitForChild("Nevermind"):WaitForChild("Button");
    UI_Manager:AddBounceButton(Button, 1.08, false);
    UI_Manager:AddBounceButton(Button2, 1.08, false);
    UI_Manager:AddBounceButton(Button3, 1.08, true);
    local u17 = { Button, Button2, Button3 };
    local u18 = {};

    for i, v in u17 do
        u18[i] = v.Position;
    end;

    local u19 = 0;
    local u20 = {};

    local function cancelReveal() -- Line: 78
        -- upvalues: u19 (ref), u20 (copy)
        u19 = u19 + 1;

        for _, v in u20 do
            v:Cancel();
        end;

        table.clear(u20);
    end;

    SellStuff.Visible = false;
    local u21 = false;
    local u22 = false;

    local function openUI() -- Line: 102
        -- upvalues: u21 (ref), SellStuff (copy), u19 (ref), u20 (copy), u17 (copy), u18 (copy), u3 (ref), TweenService (ref), u4 (ref)
        if u21 then
            return;
        end;

        u21 = true;
        SellStuff.Visible = true;
        u19 = u19 + 1;

        for _, v in u20 do
            v:Cancel();
        end;

        table.clear(u20);
        local u23 = u19;

        for i, v in u17 do
            v.Visible = false;
            v.Position = u18[i] + u3;
        end;

        task.spawn(function() -- Line: 115
            -- upvalues: u17 (ref), u23 (copy), u19 (ref), TweenService (ref), u4 (ref), u18 (ref), u20 (ref)
            for i, v in u17 do
                if u23 ~= u19 then
                    return;
                end;

                v.Visible = true;
                local v24 = TweenService:Create(v, u4, {
                    Position = u18[i]
                });
                u20[i] = v24;
                v24:Play();
                task.wait(0.07);
            end;
        end);
    end;

    local function dismiss() -- Line: 128
        -- upvalues: u22 (ref), u21 (ref), u19 (ref), u20 (copy), SellStuff (copy), u17 (copy), u18 (copy)
        u22 = true;

        if not u21 then
            return;
        end;

        u21 = false;
        u19 = u19 + 1;

        for _, v in u20 do
            v:Cancel();
        end;

        table.clear(u20);
        SellStuff.Visible = false;

        for i, v in u17 do
            v.Position = u18[i];
            v.Visible = true;
        end;
    end;

    v7:GiveTask(function() -- Line: 91, Name: closeUI
        -- upvalues: u21 (ref), u19 (ref), u20 (copy), SellStuff (copy), u17 (copy), u18 (copy)
        if not u21 then
            return;
        end;

        u21 = false;
        u19 = u19 + 1;

        for _, v in u20 do
            v:Cancel();
        end;

        table.clear(u20);
        SellStuff.Visible = false;

        for i, v in u17 do
            v.Position = u18[i];
            v.Visible = true;
        end;
    end);
    v7:GiveTask(RunService.Heartbeat:Connect(function() -- Line: 136
        -- upvalues: LocalPlayer (copy), u21 (ref), u19 (ref), u20 (copy), SellStuff (copy), u17 (copy), u18 (copy), u9 (copy), u11 (copy), u12 (copy), u22 (ref), openUI (copy)
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if not Character then
            if not u21 then
                return;
            end;

            u21 = false;
            u19 = u19 + 1;

            for _, v in u20 do
                v:Cancel();
            end;

            table.clear(u20);
            SellStuff.Visible = false;

            for i, v in u17 do
                v.Position = u18[i];
                v.Visible = true;
            end;

            return;
        end;

        local v25 = u9:PointToObjectSpace(Character.Position);
        local v26;

        if math.abs(v25.X) <= u11 + 2 + 2 and v25.Z <= u12 + 2 then
            v26 = v25.Z >= -u12 - 6 - 2;
        else
            v26 = false;
        end;

        if v26 then
            local v27 = u9:PointToObjectSpace(Character.Position);
            local v28;

            if math.abs(v27.X) <= u11 + 2 + 0 and v27.Z <= u12 + 0 then
                v28 = v27.Z >= -u12 - 6 - 0;
            else
                v28 = false;
            end;

            if v28 and not u22 then
                openUI();
            end;

            return;
        end;

        u22 = false;

        if not u21 then
            return;
        end;

        u21 = false;
        u19 = u19 + 1;

        for _, v in u20 do
            v:Cancel();
        end;

        table.clear(u20);
        SellStuff.Visible = false;

        for i, v in u17 do
            v.Position = u18[i];
            v.Visible = true;
        end;
    end));

    local function onSold(p29) -- Line: 151
        -- upvalues: SoundController (copy), LocalPlayer (copy)
        if p29 == true then
            SoundController:PlaySound("ShopBuy", LocalPlayer);
        end;
    end;

    v7:GiveTask(Button.Activated:Connect(function() -- Line: 157
        -- upvalues: u8 (copy), onSold (copy), u22 (ref), u21 (ref), u19 (ref), u20 (copy), SellStuff (copy), u17 (copy), u18 (copy)
        u8:SellAll():andThen(onSold);
        u22 = true;

        if not u21 then
            return;
        end;

        u21 = false;
        u19 = u19 + 1;

        for _, v in u20 do
            v:Cancel();
        end;

        table.clear(u20);
        SellStuff.Visible = false;

        for i, v in u17 do
            v.Position = u18[i];
            v.Visible = true;
        end;
    end));
    v7:GiveTask(Button2.Activated:Connect(function() -- Line: 162
        -- upvalues: u8 (copy), SoundController (copy), LocalPlayer (copy), u22 (ref), u21 (ref), u19 (ref), u20 (copy), SellStuff (copy), u17 (copy), u18 (copy)
        u8:SellTree():andThen(function(p30, p31, p32) -- Line: 163
            -- upvalues: SoundController (ref), LocalPlayer (ref), u22 (ref), u21 (ref), u19 (ref), u20 (ref), SellStuff (ref), u17 (ref), u18 (ref)
            if p30 == true then
                SoundController:PlaySound("ShopBuy", LocalPlayer);
            end;

            if p30 and not p32 then
                u22 = true;

                if not u21 then
                    return;
                end;

                u21 = false;
                u19 = u19 + 1;

                for _, v in u20 do
                    v:Cancel();
                end;

                table.clear(u20);
                SellStuff.Visible = false;

                for i, v in u17 do
                    v.Position = u18[i];
                    v.Visible = true;
                end;
            end;
        end);
    end));
    v7:GiveTask(Button3.Activated:Connect(dismiss));
    p6._maid = v7;
end;

function v5.KnitInit(p33) -- Line: 176
    -- upvalues: Knit (copy)
    p33.UI_Manager = Knit.GetController("UI_Manager");
    p33.SoundController = Knit.GetController("SoundController");
end;

return v5;