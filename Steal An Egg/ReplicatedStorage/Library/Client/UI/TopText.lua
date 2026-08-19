-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local GamepadService = game:GetService("GamepadService");
local Talk_UI = ReplicatedStorage.Assets.UI.Npcs.Talk_UI;
local Response_UI = ReplicatedStorage.Assets.UI.Npcs.Response_UI;
local Option_UI = ReplicatedStorage.Assets.UI.Npcs.Option_UI;
local u2 = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0);
local Response_Text = SoundService.Response_Text;
task.wait(1);

local function typeEffect(p3, p4, p5) -- Line: 18
    -- upvalues: SoundService (copy), Response_Text (copy), Debris (copy)
    local v6 = p3.Text:gsub("<.->", "");
    local v7 = string.len(v6);
    local v8 = string.len(v6);
    p3.MaxVisibleGraphemes = 0;
    local v9 = p5 and SoundService.NPC_SFX:FindFirstChild(p5) or SoundService.NPC_Text;

    if p4 == true then
        while v7 >= 1 do
            task.wait();

            if v9.TimePosition > 0.07 or v9.Playing == false then
                v9.TimePosition = 0;
                v9.Playing = true;
                v9.PlaybackSpeed = 1 + math.random(-5, 5) / 100;
            end;

            v7 = v7 - 1;
            p3.MaxVisibleGraphemes = p3.MaxVisibleGraphemes + 1;
        end;
    else
        while v7 >= 1 do
            task.wait();

            if math.floor(v7 / 3) * 3 == v7 or v7 == v8 then
                local v10 = Response_Text:Clone();
                v10.Parent = SoundService;
                v10.Name = "SFX";
                v10.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                v10.Playing = true;
                Debris:AddItem(v10, v10.TimeLength * v10.PlaybackSpeed);
            end;

            v7 = v7 - 1;
            p3.MaxVisibleGraphemes = p3.MaxVisibleGraphemes + 1;
        end;
    end;
end;

function v1.NpcText(p11, p12, p13) -- Line: 55
    -- upvalues: Talk_UI (copy), typeEffect (copy)
    local v14 = p11.Head:FindFirstChild(Talk_UI.Name);

    if v14 ~= nil then
        if p13 == true then
            for _, descendant in pairs(v14:GetDescendants()) do
                if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                    descendant:Destroy();
                end;
            end;
        end;

        v14.TextLabel.Text = p12;
        typeEffect(v14.TextLabel, true, p11.Name);

        if p13 == true then
            for _, descendant in pairs(Talk_UI:GetDescendants()) do
                if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                    for _, descendant2 in pairs(v14:GetDescendants()) do
                        if descendant2.Name == descendant.Parent.Name then
                            local v15 = descendant:Clone();
                            v15.Parent = descendant2;
                            v15.Enabled = true;
                        end;
                    end;
                end;
            end;
        end;

        return v14;
    end;

    local v16 = Talk_UI:Clone();
    v16.Parent = p11.Head;
    v16.TextLabel.Text = p12;
    typeEffect(v16.TextLabel, true, p11.Name);

    if p13 == true then
        for _, descendant in pairs(v16:GetDescendants()) do
            if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                descendant.Enabled = true;
            end;
        end;
    end;

    return v16;
end;

function v1.ShowChoices(p17, p18) -- Line: 97
    -- upvalues: Option_UI (copy), TweenService (copy), Debris (copy), GamepadService (copy)
    local v19 = 0;
    local v20 = {};

    for _, v in pairs(p18) do
        v19 = v19 + 1;
        local v21 = Option_UI:Clone();
        v21.Parent = p17.PlayerGui.Billboard_UI;
        v21.Frame.Frame.Text_Element.Text = v;
        v21.Frame.Frame.TextLabel.Text = tostring(v19) .. ".";
        local UIPadding = v21.Frame.Frame.Text_Element.UIPadding;
        local v22 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0);
        UIPadding.PaddingLeft = UDim.new(string.len(v) * 0.001 + 0.04, 0);
        local v23 = TweenService:Create(UIPadding, v22, {
            PaddingLeft = UDim.new(0, 0)
        });
        v23:Play();
        Debris:AddItem(v23, v22.Time);
        table.insert(v20, v21);
        v21.Frame.Frame.Text_Element:SetAttribute("Text", v);
        task.wait(0.075);
    end;

    if v20[1] then
        GamepadService:EnableGamepadCursor(v20[1]);
    end;

    return v20;
end;

function v1.TakeAwayResponses(p24, p25) -- Line: 124
    -- upvalues: TweenService (copy), u2 (copy), Debris (copy)
    for _, child in pairs(p25.PlayerGui.Billboard_UI:GetChildren()) do
        if child.Name ~= "UIListLayout" then
            child:Destroy();
        end;
    end;

    for _, child in pairs(p24.Head:GetChildren()) do
        if child:IsA("BillboardGui") and (child.Name == "Response_UI" or child.Name == "Talk_UI") then
            for _, child2 in pairs(child:GetChildren()) do
                if child2:IsA("TextLabel") then
                    TweenService:Create(child2, u2, {
                        TextTransparency = 1
                    }):Play();
                elseif child2:IsA("ImageLabel") then
                    TweenService:Create(child2, u2, {
                        ImageTransparency = 1
                    }):Play();
                end;
            end;

            Debris:AddItem(child, u2.Time);
        end;
    end;
end;

function v1.RemovePlayerSideFrame(p26) -- Line: 148
    -- upvalues: GamepadService (copy)
    for _, child in pairs(p26.PlayerGui.Billboard_UI:GetChildren()) do
        if child.Name ~= "UIListLayout" then
            child:Destroy();
        end;
    end;

    GamepadService:DisableGamepadCursor();
end;

function v1.ShowResponse(p27, p28, p29) -- Line: 157
    -- upvalues: Talk_UI (copy), typeEffect (copy)
    local v30 = p27.Head:FindFirstChild(Talk_UI.Name);

    if v30 ~= nil then
        if p29 == true then
            for _, descendant in pairs(v30:GetDescendants()) do
                if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                    descendant:Destroy();
                end;
            end;
        end;

        v30.TextLabel.Text = p28;
        typeEffect(v30.TextLabel, true);

        if p29 == true then
            for _, descendant in pairs(Talk_UI:GetDescendants()) do
                if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                    for _, descendant2 in pairs(v30:GetDescendants()) do
                        if descendant2.Name == descendant.Parent.Name then
                            descendant.Enabled = false;
                            local v31 = descendant:Clone();
                            v31.Parent = descendant2;
                            v31.Enabled = true;
                        end;
                    end;
                end;
            end;
        end;

        return v30;
    end;

    local v32 = Talk_UI:Clone();
    v32.Parent = p27.Head;
    v32.TextLabel.Text = p28;
    typeEffect(v32.TextLabel, true);

    if p29 == true then
        for _, descendant in pairs(v32:GetDescendants()) do
            if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                descendant.Enabled = true;
            end;
        end;
    end;

    return v32;
end;

function v1.PlayerResponse(p33, p34, p35) -- Line: 200
    -- upvalues: Talk_UI (copy), Response_UI (copy), typeEffect (copy)
    if p34 ~= nil then
        local v36 = p33.Head:FindFirstChild(Talk_UI.Name);

        if v36 ~= nil then
            if p35 == true then
                for _, descendant in pairs(v36:GetDescendants()) do
                    if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                        descendant:Destroy();
                    end;
                end;
            end;

            v36.TextLabel.Text = p34;
            typeEffect(v36.TextLabel, false);

            if p35 == true then
                for _, descendant in pairs(Response_UI:GetDescendants()) do
                    if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                        for _, descendant2 in pairs(v36:GetDescendants()) do
                            if descendant2.Name == descendant.Parent.Name then
                                descendant.Enabled = false;
                                local v37 = descendant:Clone();
                                v37.Parent = descendant2;
                                v37.Enabled = true;
                            end;
                        end;
                    end;
                end;
            end;

            return v36;
        end;

        local v38 = Response_UI:Clone();
        v38.Parent = p33.Head;
        v38.TextLabel.Text = p34;
        typeEffect(v38.TextLabel, false);

        if p35 == true then
            for _, descendant in pairs(v38:GetDescendants()) do
                if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                    descendant.Enabled = true;
                end;
            end;
        end;

        return v38;
    end;
end;

return v1;