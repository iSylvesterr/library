-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local NpcUIs = ReplicatedStorage.Assets.NpcUIs;
local Talk_UI = NpcUIs.Talk_UI;
local Response_UI = NpcUIs.Response_UI;
local Option_UI = NpcUIs.Option_UI;
local responseText = SoundService.SFX.responseText;
local u2 = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
local u3 = nil;
local u4 = nil;

local function stripRichTextTags(p5) -- Line: 34
    return p5:gsub("<.->", "");
end;

local function playTypewriterEffect(p6, p7, p8) -- Line: 42
    -- upvalues: SoundService (copy), responseText (copy)
    local v9 = p6.Text:gsub("<.->", "");
    local v10 = utf8.len(v9) or 0;
    p6.MaxVisibleGraphemes = 0;
    local v11;

    if p7 then
        v11 = p8 and SoundService.NPC_SFX:FindFirstChild(p8) or SoundService.NPC_SFX.NPC_Text;
    else
        v11 = nil;
    end;

    if p7 and v11 then
        while v10 >= 1 do
            task.wait();

            if v11.TimePosition > 0.07 or not v11.Playing then
                v11.TimePosition = 0;
                v11.Playing = true;
                v11.PlaybackSpeed = 1 + math.random(-5, 5) / 100;
            end;

            v10 = v10 - 1;
            p6.MaxVisibleGraphemes = p6.MaxVisibleGraphemes + 1;
        end;
    else
        local v12 = v10;

        while v10 >= 1 do
            task.wait();

            if math.floor(v10 / 3) * 3 == v10 or v10 == v12 then
                responseText.TimePosition = 0;
                responseText.Playing = true;
                responseText.PlaybackSpeed = 1 + math.random(-5, 5) / 100;
            end;

            v10 = v10 - 1;
            p6.MaxVisibleGraphemes = p6.MaxVisibleGraphemes + 1;
        end;
    end;
end;

local function setupDisappearScripts(p13, p14, p15) -- Line: 79
    if not p15 then
        return;
    end;

    for _, descendant in p13:GetDescendants() do
        if descendant:IsA("LocalScript") or descendant:IsA("Script") then
            descendant:Destroy();
        end;
    end;

    for _, descendant in p14:GetDescendants() do
        if descendant:IsA("LocalScript") or descendant:IsA("Script") then
            for _, descendant2 in p13:GetDescendants() do
                if descendant2.Name == descendant.Parent.Name then
                    local v16 = descendant:Clone();
                    v16.Parent = descendant2;
                    v16.Enabled = true;
                end;
            end;
        end;
    end;
end;

local function buildRainbowText(p17, p18) -- Line: 103
    local v19 = utf8.len(p17) or 1;
    local v20 = 0;
    local v21 = {};

    for _, v in utf8.codes(p17) do
        v20 = v20 + 1;
        local v22 = utf8.char(v);
        local v23 = Color3.fromHSV((p18 * 1.2 + (v20 - 1) / v19 * 0.6) % 1, 1, 1);
        local v24 = string.format("#%02X%02X%02X", math.floor(v23.R * 255), math.floor(v23.G * 255), (math.floor(v23.B * 255)));
        table.insert(v21, string.format("<font color=\"%s\">%s</font>", v24, v22));
    end;

    return table.concat(v21);
end;

function v1.NpcText(p25, p26, p27) -- Line: 122
    -- upvalues: u3 (ref), Talk_UI (copy), playTypewriterEffect (copy), setupDisappearScripts (copy)
    if u3 then
        u3();
        u3 = nil;
    end;

    local v28 = p25.Head:FindFirstChild(Talk_UI.Name);

    if v28 then
        setupDisappearScripts(v28, Talk_UI, p27);
        v28.TextLabel.Text = p26;
        playTypewriterEffect(v28.TextLabel, true, p25.Name);

        return v28;
    end;

    local v29 = Talk_UI:Clone();
    v29.Parent = p25.Head;
    v29.TextLabel.Text = p26;
    playTypewriterEffect(v29.TextLabel, true, p25.Name);

    if p27 then
        for _, descendant in v29:GetDescendants() do
            if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                descendant.Enabled = true;
            end;
        end;
    end;

    return v29;
end;

function v1.RainbowNpcText(p30, u31, u32, u33, p34) -- Line: 157
    -- upvalues: u3 (ref), Talk_UI (copy), playTypewriterEffect (copy), setupDisappearScripts (copy), buildRainbowText (copy)
    if u3 then
        u3();
        u3 = nil;
    end;

    local v35 = p30.Head:FindFirstChild(Talk_UI.Name);
    local v36 = u31 .. "<font color=\"#FFFFFF\">" .. u32 .. "</font>" .. u33;
    local u37;

    if v35 then
        setupDisappearScripts(v35, Talk_UI, p34);
        u37 = v35;
        u37.TextLabel.Text = v36;
        playTypewriterEffect(u37.TextLabel, true, p30.Name);
    else
        u37 = Talk_UI:Clone();
        u37.Parent = p30.Head;
        u37.TextLabel.Text = v36;
        playTypewriterEffect(u37.TextLabel, true, p30.Name);

        if p34 then
            for _, descendant in u37:GetDescendants() do
                if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                    descendant.Enabled = true;
                end;
            end;
        end;
    end;

    local u38 = true;

    local function stop() -- Line: 190
        -- upvalues: u38 (ref)
        u38 = false;
    end;

    u3 = stop;
    task.spawn(function() -- Line: 195
        -- upvalues: u38 (ref), u37 (ref), u31 (copy), buildRainbowText (ref), u32 (copy), u33 (copy), u3 (ref), stop (copy)
        local v39 = 0;

        while u38 do
            v39 = v39 + task.wait(0.04);

            if not u38 then
                break;
            end;

            if not (u37 and u37.Parent) then
                u38 = false;
                break;
            end;

            u37.TextLabel.Text = u31 .. buildRainbowText(u32, v39) .. u33;
        end;

        if u3 == stop then
            u3 = nil;
        end;
    end);

    return stop;
end;

local function wrapColor(p40, p41) -- Line: 220
    if p41 then
        return string.format("<font color=\"%s\">%s</font>", p41, p40);
    end;

    return p40;
end;

local function spawnTypewriterEffect(u42, p43) -- Line: 232
    -- upvalues: SoundService (copy)
    u42.MaxVisibleGraphemes = 0;
    local u44 = p43 and SoundService.NPC_SFX:FindFirstChild(p43) or SoundService.NPC_SFX.NPC_Text;
    task.spawn(function() -- Line: 235
        -- upvalues: u42 (copy), u44 (copy)
        local v45 = 0;

        while u42 and u42.Parent do
            if (utf8.len((u42.Text:gsub("<.->", ""))) or 0) <= v45 then
                u42.MaxVisibleGraphemes = -1;

                return;
            end;

            v45 = v45 + 1;
            u42.MaxVisibleGraphemes = v45;

            if u44 and (u44.TimePosition > 0.07 or not u44.Playing) then
                u44.TimePosition = 0;
                u44.Playing = true;
                u44.PlaybackSpeed = 1 + math.random(-5, 5) / 100;
            end;

            task.wait();
        end;
    end);
end;

function v1.NpcCountUp(p46, p47) -- Line: 271
    -- upvalues: u3 (ref), Talk_UI (copy), setupDisappearScripts (copy), SoundService (copy), buildRainbowText (copy)
    if u3 then
        u3();
        u3 = nil;
    end;

    local TextBefore = p47.TextBefore;
    local TextAfter = p47.TextAfter;
    local FinalAmount = p47.FinalAmount;
    local Format = p47.Format;
    local Color = p47.Color;
    local v48 = p47.Rainbow == true;
    local v49 = p47.Duration or 0.7;
    local v50 = p47.ShouldDisappear or false;
    local u51 = Format(0);
    local v52;

    if v48 then
        v52 = TextBefore .. "<font color=\"#FFFFFF\">" .. u51 .. "</font>" .. TextAfter;
    else
        local v53;

        if Color then
            v53 = string.format("<font color=\"%s\">%s</font>", Color, u51);
        else
            v53 = u51;
        end;

        v52 = TextBefore .. v53 .. TextAfter;
    end;

    local v54 = p46.Head:FindFirstChild(Talk_UI.Name);
    local u55;

    if v54 then
        setupDisappearScripts(v54, Talk_UI, v50);
        u55 = v54;
        u55.TextLabel.Text = v52;
    else
        u55 = Talk_UI:Clone();
        u55.Parent = p46.Head;
        u55.TextLabel.Text = v52;

        if v50 then
            for _, descendant in u55:GetDescendants() do
                if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                    descendant.Enabled = true;
                end;
            end;
        end;
    end;

    local TextLabel = u55.TextLabel;
    local Name = p46.Name;
    TextLabel.MaxVisibleGraphemes = 0;
    local u56 = Name and SoundService.NPC_SFX:FindFirstChild(Name) or SoundService.NPC_SFX.NPC_Text;
    task.spawn(function() -- Line: 235
        -- upvalues: TextLabel (copy), u56 (copy)
        local v57 = 0;

        while TextLabel and TextLabel.Parent do
            if (utf8.len((TextLabel.Text:gsub("<.->", ""))) or 0) <= v57 then
                TextLabel.MaxVisibleGraphemes = -1;

                return;
            end;

            v57 = v57 + 1;
            TextLabel.MaxVisibleGraphemes = v57;

            if u56 and (u56.TimePosition > 0.07 or not u56.Playing) then
                u56.TimePosition = 0;
                u56.Playing = true;
                u56.PlaybackSpeed = 1 + math.random(-5, 5) / 100;
            end;

            task.wait();
        end;
    end);

    if not v48 then
        local v58 = 0;

        while v58 < v49 do
            if not (u55 and u55.Parent) then
                return;
            end;

            local v59 = math.clamp(v58 / v49, 0, 1);
            local v60 = math.lerp(0, FinalAmount, v59);
            local v61 = math.round(v60);
            local TextLabel2 = u55.TextLabel;
            local v62 = Format(v61);

            if Color then
                v62 = string.format("<font color=\"%s\">%s</font>", Color, v62);
            end;

            TextLabel2.Text = TextBefore .. v62 .. TextAfter;
            v58 = v58 + task.wait();
        end;

        if u55 and u55.Parent then
            local TextLabel2 = u55.TextLabel;
            local v63 = Format(FinalAmount);

            if Color then
                v63 = string.format("<font color=\"%s\">%s</font>", Color, v63);
            end;

            TextLabel2.Text = TextBefore .. v63 .. TextAfter;
        end;

        return;
    end;

    local u64 = true;

    local function u65() -- Line: 338
        -- upvalues: u64 (ref)
        u64 = false;
    end;

    u3 = u65;
    local v66 = 0;
    local u67 = 0;

    while v66 < v49 do
        if not (u64 and (u55 and u55.Parent)) then
            u64 = false;
            break;
        end;

        local v68 = math.clamp(v66 / v49, 0, 1);
        local v69 = math.lerp(0, FinalAmount, v68);
        u51 = Format((math.round(v69)));
        u55.TextLabel.Text = TextBefore .. buildRainbowText(u51, u67) .. TextAfter;
        local v70 = task.wait();
        v66 = v66 + v70;
        u67 = u67 + v70;
    end;

    if u64 then
        u51 = Format(FinalAmount);
    end;

    task.spawn(function() -- Line: 363
        -- upvalues: u64 (ref), u67 (ref), u55 (ref), TextBefore (copy), buildRainbowText (ref), u51 (ref), TextAfter (copy), u3 (ref), u65 (copy)
        while u64 do
            u67 = u67 + task.wait(0.04);

            if not u64 then
                break;
            end;

            if not (u55 and u55.Parent) then
                u64 = false;
                break;
            end;

            u55.TextLabel.Text = TextBefore .. buildRainbowText(u51, u67) .. TextAfter;
        end;

        if u3 == u65 then
            u3 = nil;
        end;
    end);
end;

v1.BuildRainbowText = buildRainbowText;

function v1.RainbowPlayerResponse(p71, u72, u73, u74, p75) -- Line: 384
    -- upvalues: u4 (ref), Talk_UI (copy), Response_UI (copy), playTypewriterEffect (copy), setupDisappearScripts (copy), buildRainbowText (copy)
    if u4 then
        u4();
        u4 = nil;
    end;

    local Head = p71:FindFirstChild("Head");

    if not Head then
        return nil;
    end;

    local v76 = Head:FindFirstChild(Talk_UI.Name);
    local v77 = u72 .. "<font color=\"#FFFFFF\">" .. u73 .. "</font>" .. u74;
    local u78;

    if v76 then
        setupDisappearScripts(v76, Response_UI, p75);
        u78 = v76;
        u78.TextLabel.Text = v77;
        playTypewriterEffect(u78.TextLabel, false);
    else
        u78 = Response_UI:Clone();
        u78.Parent = Head;
        u78.TextLabel.Text = v77;
        playTypewriterEffect(u78.TextLabel, false);

        if p75 then
            for _, descendant in u78:GetDescendants() do
                if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                    descendant.Enabled = true;
                end;
            end;
        end;
    end;

    local u79 = true;

    local function u80() -- Line: 419
        -- upvalues: u79 (ref)
        u79 = false;
    end;

    u4 = u80;
    task.spawn(function() -- Line: 424
        -- upvalues: u79 (ref), u78 (ref), u72 (copy), buildRainbowText (ref), u73 (copy), u74 (copy), u4 (ref), u80 (copy)
        local v81 = 0;

        while u79 do
            v81 = v81 + task.wait(0.04);

            if not u79 then
                break;
            end;

            if not (u78 and u78.Parent) then
                u79 = false;
                break;
            end;

            u78.TextLabel.Text = u72 .. buildRainbowText(u73, v81) .. u74;
        end;

        if u4 == u80 then
            u4 = nil;
        end;
    end);

    return u80;
end;

function v1.ShowChoices(p82, p83) -- Line: 443
    -- upvalues: Option_UI (copy), TweenService (copy), Debris (copy)
    local v84 = {};
    local Billboard_UI = p82.PlayerGui:FindFirstChild("Billboard_UI");

    if not Billboard_UI then
        return v84;
    end;

    for i, v in ipairs(p83) do
        local v85 = Option_UI:Clone();
        v85.Parent = Billboard_UI.Objects;
        v85.Frame.Frame.Text_Element.Text = "[\"" .. v .. "\"]";
        v85.Frame.Frame.TextLabel.Text = "#" .. tostring(i);
        local UIPadding = v85.Frame.Frame.Text_Element.UIPadding;
        local v86 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
        UIPadding.PaddingLeft = UDim.new(string.len(v) * 0.001 + 0.04, 0);
        local v87 = TweenService:Create(UIPadding, v86, {
            PaddingLeft = UDim.new(0, 0)
        });
        v87:Play();
        Debris:AddItem(v87, v86.Time);
        table.insert(v84, v85);
        v85.Frame.Frame.Text_Element:SetAttribute("Text", v);
        task.wait(0.075);
    end;

    return v84;
end;

function v1.TakeAwayResponses(p88, p89) -- Line: 474
    -- upvalues: TweenService (copy), u2 (copy), Debris (copy)
    for _, child in p88.Head:GetChildren() do
        if child:IsA("BillboardGui") and (child.Name == "Response_UI" or child.Name == "Talk_UI") then
            for _, child2 in child:GetChildren() do
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

function v1.ConnectChoiceKeyboard(p90, p91) -- Line: 497
    return function() -- Line: 501
    end;
end;

function v1.RemovePlayerSideFrame(p92) -- Line: 504
    local Billboard_UI = p92.PlayerGui:FindFirstChild("Billboard_UI");

    if Billboard_UI then
        for _, child in Billboard_UI.Objects:GetChildren() do
            if child.Name ~= "UIListLayout" then
                child:Destroy();
            end;
        end;
    end;
end;

function v1.ShowResponse(p93, p94, p95) -- Line: 516
    -- upvalues: Talk_UI (copy), playTypewriterEffect (copy), setupDisappearScripts (copy)
    local v96 = p93.Head:FindFirstChild(Talk_UI.Name);

    if v96 then
        setupDisappearScripts(v96, Talk_UI, p95);
        v96.TextLabel.Text = p94;
        playTypewriterEffect(v96.TextLabel, true);

        return v96;
    end;

    local v97 = Talk_UI:Clone();
    v97.Parent = p93.Head;
    v97.TextLabel.Text = p94;
    playTypewriterEffect(v97.TextLabel, true);

    if p95 then
        for _, descendant in v97:GetDescendants() do
            if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                descendant.Enabled = true;
            end;
        end;
    end;

    return v97;
end;

function v1.PlayerResponse(p98, p99, p100) -- Line: 542
    -- upvalues: u4 (ref), Talk_UI (copy), Response_UI (copy), playTypewriterEffect (copy), setupDisappearScripts (copy)
    if not p99 then
        return nil;
    end;

    if u4 then
        u4();
        u4 = nil;
    end;

    local v101 = p98.Head:FindFirstChild(Talk_UI.Name);

    if v101 then
        setupDisappearScripts(v101, Response_UI, p100);
        v101.TextLabel.Text = p99;
        playTypewriterEffect(v101.TextLabel, false);

        return v101;
    end;

    local v102 = Response_UI:Clone();
    v102.Parent = p98.Head;
    v102.TextLabel.Text = p99;
    playTypewriterEffect(v102.TextLabel, false);

    if p100 then
        for _, descendant in v102:GetDescendants() do
            if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                descendant.Enabled = true;
            end;
        end;
    end;

    return v102;
end;

return v1;