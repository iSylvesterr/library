-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v1.CollectionService;
local GamepadService = v1.GamepadService;
local GuiService = v1.GuiService;
local ProximityPromptService = v1.ProximityPromptService;
local ReplicatedStorage = v1.ReplicatedStorage;
local TweenService = v1.TweenService;
local UserInputService = v1.UserInputService;
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants");
local Player = v2.Player;
local PlayerGui = v2.PlayerGui;
local NpcPreload = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "npc", "NpcPreload").NpcPreload;
local v3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "gradient", "GoldGradient");
local GOLD_GRADIENT_COLOR = v3.GOLD_GRADIENT_COLOR;
local GOLD_GRADIENT_ROTATION = v3.GOLD_GRADIENT_ROTATION;
local TransparentDescendents = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "tween", "TransparentDescendants").TransparentDescendents;
local R6_IDLE_ANIM_ID = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "npc", "NPCConstants").R6_IDLE_ANIM_ID;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local playSound = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "sound", "SoundUtil").playSound;
local RichTextUtil = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "ui", "RichTextUtil").RichTextUtil;
local u4 = Color3.fromRGB(255, 200, 40);
local u5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u6 = UDim2.fromScale(-0.4, 0);
local u7 = UDim2.fromScale(0, 0);
local u8 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u9 = {
    hidden = {
        outline = 1
    },
    range = {
        outline = 0.5
    },
    talking = {
        outline = 0
    }
};
local u10 = setmetatable({}, {
    __tostring = function() -- Line: 65, Name: __tostring
        return "DialogueController";
    end
});
u10.__index = u10;

function u10.new(...) -- Line: 70
    -- upvalues: u10 (ref)
    local v11 = setmetatable({}, u10);

    return v11:constructor(...) or v11;
end;

function u10.constructor(p12, p13, p14) -- Line: 74
    p12.tutorial = p13;
    p12.islands = p14;
    p12.byPrompt = {};
    p12.registrations = {};
    p12.idleSyncTimer = 0;
end;

function u10.onStart(u15) -- Line: 81
    -- upvalues: ProximityPromptService (copy), UserInputService (copy)
    ProximityPromptService.PromptShown:Connect(function(p16) -- Line: 82
        -- upvalues: u15 (copy)
        local v17 = u15.byPrompt[p16];

        if not v17 then
            return nil;
        end;

        v17.promptVisible = true;
        local active = u15.active;

        if active ~= nil then
            active = active.registration;
        end;

        if active ~= v17 then
            u15:setHighlightState(v17, "range");
        end;
    end);
    ProximityPromptService.PromptHidden:Connect(function(p18) -- Line: 98
        -- upvalues: u15 (copy)
        local v19 = u15.byPrompt[p18];

        if not v19 then
            return nil;
        end;

        v19.promptVisible = false;
        local active = u15.active;

        if active ~= nil then
            active = active.registration;
        end;

        if active ~= v19 then
            u15:setHighlightState(v19, "hidden");
        end;
    end);
    UserInputService.InputBegan:Connect(function(p20) -- Line: 114
        -- upvalues: u15 (copy)
        return u15:tryVirtualCursorSelect(p20);
    end);
end;

function u10.tryVirtualCursorSelect(p21, p22) -- Line: 118
    -- upvalues: GamepadService (copy)
    if p22.KeyCode ~= Enum.KeyCode.ButtonA then
        return nil;
    end;

    local active = p21.active;

    if not active or (active.closed or not active.optionsVisible) then
        return nil;
    end;

    local v23;

    if GamepadService.GamepadCursorEnabled then
        v23 = p21:optionAtCursor(active);
    else
        v23 = nil;
    end;

    local v24 = active.hoveredOption or v23;

    if v24 then
        p21:selectOption(active, v24);
    end;
end;

function u10.optionAtCursor(p25, p26) -- Line: 132
    -- upvalues: GuiService (copy), UserInputService (copy), PlayerGui (copy)
    local v27 = GuiService:GetGuiInset();
    local v28 = UserInputService:GetMouseLocation();

    for _, v in PlayerGui:GetGuiObjectsAtPosition(v28.X - v27.X, v28.Y - v27.Y) do
        local v29 = p26.optionByButton[v];

        if v29 then
            return v29;
        end;
    end;

    return nil;
end;

function u10.onTick(p30, p31) -- Line: 143
    -- upvalues: Player (copy)
    p30:syncIdleAnimations(p31);
    local active = p30.active;

    if not active or active.closed then
        return nil;
    end;

    local Character = Player.Character;

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not (Character and Character:IsA("BasePart")) then
        p30:close(active);

        return nil;
    end;

    if (Character.Position - active.registration.root.Position).Magnitude > 20 then
        p30:close(active);
    end;
end;

function u10.registerNpc(u32, u33) -- Line: 165
    -- upvalues: NpcPreload (copy)
    local HumanoidRootPart = u33.model:WaitForChild("HumanoidRootPart");
    task.spawn(function() -- Line: 167
        -- upvalues: NpcPreload (ref), u33 (copy)
        return NpcPreload.preload(u33.model:GetDescendants());
    end);
    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.ActionText = u33.actionText;
    ProximityPrompt.ObjectText = u33.name;
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt.MaxActivationDistance = 10;
    ProximityPrompt.Parent = HumanoidRootPart;
    local Highlight = Instance.new("Highlight");
    Highlight.FillColor = Color3.new(1, 1, 1);
    Highlight.OutlineColor = Color3.new(1, 1, 1);
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    Highlight.FillTransparency = 1;
    Highlight.OutlineTransparency = 1;
    Highlight.Adornee = u33.model;
    Highlight.Parent = u33.model;
    local u34 = {
        promptVisible = false,
        npc = u33,
        root = HumanoidRootPart,
        prompt = ProximityPrompt,
        highlight = Highlight
    };
    u32.byPrompt[ProximityPrompt] = u34;
    table.insert(u32.registrations, u34);
    u32:loadIdle(u34);
    ProximityPrompt.Triggered:Connect(function() -- Line: 196
        -- upvalues: u32 (copy), u34 (copy)
        return u32:openDialogue(u34);
    end);
end;

function u10.loadIdle(u35, u36) -- Line: 200
    -- upvalues: R6_IDLE_ANIM_ID (copy)
    task.spawn(function() -- Line: 201
        -- upvalues: u36 (copy), R6_IDLE_ANIM_ID (ref), u35 (copy)
        local Animator = u36.npc.model:WaitForChild("Humanoid"):WaitForChild("Animator");
        local Animation = Instance.new("Animation");
        Animation.AnimationId = `rbxassetid://{R6_IDLE_ANIM_ID}`;
        Animation.Parent = Animator;
        local v37 = Animator:LoadAnimation(Animation);
        v37.Looped = true;
        u36.idleTrack = v37;
        u35:setIdlePlaying(u36, u36.npc.islandId == u35.idleIsland);
    end);
end;

function u10.syncIdleAnimations(p38, p39) -- Line: 213
    p38.idleSyncTimer = p38.idleSyncTimer + p39;

    if p38.idleSyncTimer < 0.5 then
        return nil;
    end;

    p38.idleSyncTimer = 0;
    local v40 = p38.islands:getCurrentIslandId();

    if v40 == nil or v40 == p38.idleIsland then
        return nil;
    end;

    p38.idleIsland = v40;

    for _, v in p38.registrations do
        p38:setIdlePlaying(v, v.npc.islandId == v40);
    end;
end;

function u10.setIdlePlaying(p41, p42, p43) -- Line: 228
    local idleTrack = p42.idleTrack;

    if not idleTrack or idleTrack.IsPlaying == p43 then
        return nil;
    end;

    if p43 then
        idleTrack:Play();

        return;
    end;

    idleTrack:Stop();
end;

function u10.openDialogue(u44, p45) -- Line: 239
    -- upvalues: Player (copy), Janitor (copy), WFChain (copy), ReplicatedStorage (copy), u6 (copy), PlayerGui (copy)
    if u44.active then
        return nil;
    end;

    if not u44.tutorial:canOpenDialogue() then
        u44.tutorial:notifyFollowTutorial();

        return nil;
    end;

    local Character = Player.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 5);

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil;
    end;

    p45.prompt.Enabled = false;
    u44:setHighlightState(p45, "talking");
    local v46 = Janitor.new();
    local v47 = WFChain(ReplicatedStorage, "Assets", "WorldUI");
    local u48 = WFChain(v47, "DialogueText"):Clone();
    local Frame = u48:FindFirstChild("Frame");
    local v49 = Frame:FindFirstChildOfClass("TextLabel");
    v49.TextScaled = true;
    v49.TextWrapped = true;
    v49.RichText = true;
    v49.AutomaticSize = Enum.AutomaticSize.None;
    v49.Size = UDim2.fromScale(1, 0.12);
    v49.Text = "";
    Frame.ClipsDescendants = false;
    u48.ClipsDescendants = false;
    u48.StudsOffset = u48.StudsOffset + Vector3.new(0, 4, 0);
    u48.Adornee = p45.root;
    u48.Parent = p45.root;
    v46:Add(function() -- Line: 275
        -- upvalues: u48 (copy)
        return u48:Destroy();
    end);
    local u50 = WFChain(v47, "DialogueOptions"):Clone();
    local Frame2 = u50:FindFirstChild("Frame");
    local v51 = Frame2:FindFirstChildOfClass("TextButton");
    v51.Visible = false;
    Frame2.Position = u6;
    u50.ClipsDescendants = false;
    u50.Adornee = HumanoidRootPart;
    u50.Parent = PlayerGui;
    v46:Add(function() -- Line: 286
        -- upvalues: u50 (copy)
        return u50:Destroy();
    end);
    local u52 = {
        typeToken = 0,
        optionsVisible = false,
        selecting = false,
        closed = false,
        registration = p45,
        janitor = v46,
        textLabel = v49,
        optionsFrame = Frame2,
        optionsTemplate = v51,
        optionByButton = {}
    };
    local v56 = {
        say = function(p53, p54) -- Line: 302, Name: say
            -- upvalues: u44 (copy), u52 (copy)
            return u44:say(u52, p53, p54);
        end,

        showOptions = function(p55) -- Line: 305, Name: showOptions
            -- upvalues: u44 (copy), u52 (copy)
            return u44:showOptions(u52, p55);
        end,

        close = function() -- Line: 308, Name: close
            -- upvalues: u44 (copy), u52 (copy)
            return u44:close(u52);
        end
    };
    u52.session = v56;
    u44.active = u52;
    u44:showOptions(u52, p45.npc.buildRootOptions(v56));
end;

function u10.showOptions(u57, u58, p59) -- Line: 316
    -- upvalues: RichTextUtil (copy), u4 (copy), CollectionService (copy), u6 (copy), TweenService (copy), u5 (copy), u7 (copy), TransparentDescendents (copy)
    if u58.closed then
        return nil;
    end;

    for _, child in u58.optionsFrame:GetChildren() do
        if child:IsA("TextButton") and child ~= u58.optionsTemplate then
            child:Destroy();
        end;
    end;

    table.clear(u58.optionByButton);
    u58.hoveredOption = nil;

    local function v69(u60, p61) -- Line: 328
        -- upvalues: u58 (copy), RichTextUtil (ref), u4 (ref), u57 (copy), CollectionService (ref)
        local v62 = u58.optionsTemplate:Clone();
        v62.Name = `Option{p61 + 1}`;
        v62.LayoutOrder = p61;
        v62.TextScaled = true;
        v62.Size = UDim2.fromScale(3, 0.084);
        local v63 = `{RichTextUtil.color(`[#{p61 + 1}]`, u4)} - `;
        local v64 = u57:optionSegments(u60.label);
        local v65 = 0;

        for _, v in v64 do
            v65 = v65 + #v.text;
        end;

        v62.Text = v63 .. u57:renderLine(v64, v65, false);
        v62.TextTransparency = 1;
        local v66 = v62:FindFirstChildOfClass("UIStroke");

        if v66 then
            v66.Transparency = 1;
        end;

        local function _(p67) -- Line: 348
            return p67.gold == true;
        end;

        local v68 = false;

        for i, v in v64 do
            local _ = i - 1;

            if v.gold == true then
                v68 = true;
                break;
            end;
        end;

        if v68 then
            u57:createGoldOverlay(v62).Text = `<font transparency="1">{v63}</font>{u57:renderLine(v64, v65, true)}`;
        end;

        v62.Active = true;
        v62.Visible = true;
        v62.Activated:Connect(function() -- Line: 364
            -- upvalues: u57 (ref), u58 (ref), u60 (copy)
            return u57:selectOption(u58, u60);
        end);
        v62.MouseEnter:Connect(function() -- Line: 367
            -- upvalues: u58 (ref), u60 (copy)
            u58.hoveredOption = u60;

            return u58.hoveredOption;
        end);
        v62.MouseLeave:Connect(function() -- Line: 371
            -- upvalues: u58 (ref), u60 (copy)
            if u58.hoveredOption == u60 then
                u58.hoveredOption = nil;
            end;
        end);
        v62.Parent = u58.optionsFrame;
        u58.optionByButton[v62] = u60;
        CollectionService:AddTag(v62, "Button");
    end;

    for i, v in p59 do
        v69(v, i - 1, p59);
    end;

    u58.optionsFrame.Position = u6;
    u58.optionsFrame.Interactable = true;
    u58.optionsVisible = true;
    u58.selecting = false;
    TweenService:Create(u58.optionsFrame, u5, {
        Position = u7
    }):Play();
    TransparentDescendents(u58.optionsFrame, true, u5);
end;

function u10.hideOptions(p70, p71) -- Line: 395
    -- upvalues: RuntimeLib (copy), TweenService (copy), u5 (copy), u6 (copy), TransparentDescendents (copy)
    if not p71.optionsVisible then
        return RuntimeLib.Promise.resolve();
    end;

    p71.optionsVisible = false;
    p71.optionsFrame.Interactable = false;
    TweenService:Create(p71.optionsFrame, u5, {
        Position = u6
    }):Play();
    TransparentDescendents(p71.optionsFrame, false, u5);

    return RuntimeLib.Promise.delay(0.25):andThen(function() -- Line: 405
        return nil;
    end);
end;

function u10.selectOption(p72, u73, u74) -- Line: 409
    if u73.closed or (u73.selecting or not u73.optionsVisible) then
        return nil;
    end;

    u73.selecting = true;
    p72:hideOptions(u73):andThen(function() -- Line: 414
        -- upvalues: u73 (copy), u74 (copy)
        if u73.closed then
            return nil;
        end;

        u73.selecting = false;
        task.spawn(function() -- Line: 419
            -- upvalues: u74 (ref)
            return u74.select();
        end);
    end);
end;

u10.say = RuntimeLib.async(function(p75, p76, p77, p78) -- Line: 424
    -- upvalues: RuntimeLib (copy), playSound (copy)
    local v79 = p78 == nil and 2 or p78;

    if p76.closed then
        return nil;
    end;

    RuntimeLib.await(p75:hideOptions(p76));

    if p76.closed then
        return nil;
    end;

    local v80 = p75:splitGoldWords(p75:toSegments(p77));

    local function _(p81) -- Line: 438
        return p81.gold == true;
    end;

    local v82 = false;

    for i, v in v80 do
        local _ = i - 1;

        if v.gold == true then
            v82 = true;
        end;
    end;

    local overlay = p76.overlay;

    if overlay ~= nil then
        overlay:Destroy();
    end;

    local v83;

    if v82 then
        v83 = p75:createGoldOverlay(p76.textLabel);
    else
        v83 = nil;
    end;

    p76.overlay = v83;
    p76.typeToken = p76.typeToken + 1;
    local typeToken = p76.typeToken;
    local v84 = "";

    for _, v in v80 do
        v84 = v84 .. v.text;
    end;

    local v85 = #v84;
    local v86 = false;
    local v87 = 1;

    while true do
        if v86 then
            v87 = v87 + 1;
        else
            v86 = true;
        end;

        if v87 > v85 then
            RuntimeLib.await(RuntimeLib.Promise.delay(v79));

            return;
        end;

        if p75.active ~= p76 or (p76.closed or p76.typeToken ~= typeToken) then
            return nil;
        end;

        p76.textLabel.Text = p75:renderLine(v80, v87, false);

        if p76.overlay then
            p76.overlay.Text = p75:renderLine(v80, v87, true);
        end;

        if string.sub(v84, v87, v87) ~= " " and v87 % 2 == 1 then
            playSound("Pop", {
                volume = 0.15,
                playbackSpeed = 0.85 + math.random() * 0.4
            });
        end;

        RuntimeLib.await(RuntimeLib.Promise.delay(0.03));
    end;
end);

function u10.toSegments(p88, p89) -- Line: 495
    return type(p89) == "string" and {
        {
            text = p89
        }
    } or p89;
end;

function u10.optionSegments(p90, p91) -- Line: 501
    local v92 = p90:toSegments(p91);
    local v93 = table.create(#v92);

    local function _(p94) -- Line: 506
        return p94.gold ~= true and {
            text = string.lower(p94.text)
        } or p94;
    end;

    for i, v in v92 do
        local _ = i - 1;
        v93[i] = v.gold ~= true and {
            text = string.lower(v.text)
        } or v;
    end;

    return p90:splitGoldWords(v93);
end;

function u10.splitGoldWords(p95, p96) -- Line: 517
    local v97 = {};

    for _, v in p96 do
        if v.gold == true then
            table.insert(v97, v);
        else
            local text = v.text;
            local v98 = string.lower(text);
            local v99 = #text;
            local v100 = 1;

            while v100 <= v99 do
                local v101, v102 = string.find(v98, "%f[%a]gold%f[%A]", v100);

                if v101 == nil or v102 == nil then
                    break;
                end;

                if v100 < v101 then
                    local v103 = {
                        text = string.sub(text, v100, v101 - 1)
                    };
                    table.insert(v97, v103);
                end;

                local v104 = {
                    gold = true,
                    text = string.sub(text, v101, v102)
                };
                table.insert(v97, v104);
                v100 = v102 + 1;
            end;

            if v100 <= v99 then
                local v105 = {
                    text = string.sub(text, v100)
                };
                table.insert(v97, v105);
            end;
        end;
    end;

    return v97;
end;

function u10.renderLine(p106, p107, p108, p109) -- Line: 559
    local v110 = "";

    for _, v in p107 do
        if p108 <= 0 then
            break;
        end;

        local v111 = math.min(p108, #v.text);
        p108 = p108 - v111;
        local v112 = string.sub(v.text, 1, v111);

        if v.gold == true ~= p109 then
            v112 = `<font transparency="1">{v112}</font>`;
        end;

        v110 = v110 .. v112;
    end;

    return v110;
end;

function u10.createGoldOverlay(p113, p114) -- Line: 574
    -- upvalues: GOLD_GRADIENT_COLOR (copy), GOLD_GRADIENT_ROTATION (copy)
    local v115 = p114:Clone();
    v115.Name = "GoldOverlay";

    for _, child in v115:GetChildren() do
        child:Destroy();
    end;

    v115.AutomaticSize = Enum.AutomaticSize.None;
    v115.AnchorPoint = Vector2.new(0.5, 0.5);
    v115.Position = UDim2.fromScale(0.5, 0.5);
    v115.Size = UDim2.fromScale(1, 1);
    v115.BackgroundTransparency = 1;
    v115.TextColor3 = Color3.new(1, 1, 1);
    v115.ZIndex = p114.ZIndex + 1;
    v115.Visible = true;
    v115.Text = "";

    if v115:IsA("TextButton") then
        v115.Active = false;
        v115.Interactable = false;
        v115.AutoButtonColor = false;
    end;

    local UIGradient = Instance.new("UIGradient");
    UIGradient.Color = GOLD_GRADIENT_COLOR;
    UIGradient.Rotation = GOLD_GRADIENT_ROTATION;
    UIGradient.Parent = v115;
    v115.Parent = p114;

    return v115;
end;

function u10.close(p116, u117) -- Line: 601
    if u117.closed then
        return nil;
    end;

    u117.closed = true;
    u117.typeToken = u117.typeToken + 1;

    if p116.active == u117 then
        p116.active = nil;
    end;

    p116:hideOptions(u117);
    p116:fadeOutText(u117);
    p116:setHighlightState(u117.registration, u117.registration.promptVisible and "range" or "hidden");
    task.delay(0.35, function() -- Line: 613
        -- upvalues: u117 (copy)
        u117.janitor:Destroy();
        u117.registration.prompt.Enabled = true;
    end);
end;

function u10.fadeOutText(p118, p119) -- Line: 618
    -- upvalues: TweenService (copy), u5 (copy)
    TweenService:Create(p119.textLabel, u5, {
        TextTransparency = 1
    }):Play();
    local v120 = p119.textLabel:FindFirstChildOfClass("UIStroke");

    if v120 then
        TweenService:Create(v120, u5, {
            Transparency = 1
        }):Play();
    end;

    if p119.overlay then
        TweenService:Create(p119.overlay, u5, {
            TextTransparency = 1
        }):Play();
    end;
end;

function u10.setHighlightState(p121, p122, p123) -- Line: 634
    -- upvalues: u9 (copy), TweenService (copy), u8 (copy)
    TweenService:Create(p122.highlight, u8, {
        OutlineTransparency = u9[p123].outline
    }):Play();
end;

Reflect.defineMetadata(u10, "identifier", "client/controllers/npc/DialogueController@DialogueController");
Reflect.defineMetadata(u10, "flamework:parameters", { "client/controllers/tutorial/TutorialController@TutorialController", "client/controllers/world/IslandController@IslandController" });
Reflect.defineMetadata(u10, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" });
Reflect.decorate(u10, "$:flamework@Controller", Controller, { {} });

return {
    DialogueController = u10
};