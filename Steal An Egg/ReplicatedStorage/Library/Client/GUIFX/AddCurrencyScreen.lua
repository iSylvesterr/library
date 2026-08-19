-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ContentProvider = game:GetService("ContentProvider");
local Library = ReplicatedStorage:WaitForChild("Library");
local Tween = require(Library.Functions.Tween);
local Variables = require(Library.Variables);
local GUI = require(Library.Client.GUI);
local Audio = require(Library.Audio);
local GetHolder = require(script.Parent.GetHolder);
local Types = require(script.Types);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local AddCurrencyScreen = ReplicatedStorage.Assets.UI.AddCurrencyScreen;
local u1 = {
    Money = {
        Resolve = function() -- Line: 36, Name: Resolve
            -- upvalues: GUI (copy)
            local Money = GUI.Money().Bottom.Money;

            return Money, Money;
        end,

        SpawnSound = {
            SoundId = "rbxassetid://133581886462636",
            Data = {
                Volume = 1.2
            }
        }
    }
};

if Constants.IS_STUDIO then
    for i in pairs(u1) do
        local v2 = Types.AvailableCurrencyWidgetsTypes(i);
        local v3 = `Unregistered currency widget type: {i}`;
        assert(v2, v3);
    end;
end;

local u4 = Random.new();
local u5 = {};
local u6 = {};
local u7 = 0;
local u8 = { "rbxassetid://130670569123609", "rbxassetid://94335578821857" };
local u9 = {};

local function resolveWidget(p10) -- Line: 74
    -- upvalues: u1 (copy)
    local v11 = u1[p10];
    local v12 = `Currency widget not found for type: {p10}`;
    local v13 = assert(v11, v12);
    local v14, v15 = v13.Resolve();

    return v13, v14, v15 or v14;
end;

local function taskStarted() -- Line: 80
    -- upvalues: u7 (ref)
    u7 = u7 + 1;
end;

local function taskFinished() -- Line: 84
    -- upvalues: u7 (ref)
    u7 = u7 - 1;
end;

local function getTextKey(p16, p17) -- Line: 88
    if p17 and p17.MergeKey then
        return p17.MergeKey;
    end;

    return p16;
end;

local function formatAdditiveText(p18, p19) -- Line: 92
    -- upvalues: Simple (copy)
    if p19 and p19.TextOverride then
        return p19.TextOverride;
    end;

    return "$" .. Simple.FormatCompact(p18, ".");
end;

local function AddCurrencyText(p20, p21, p22, p23, p24) -- Line: 100
    -- upvalues: u7 (ref), u1 (copy), u5 (copy), u6 (copy), AddCurrencyScreen (copy), Audio (copy), GetHolder (copy), Simple (copy), ContentProvider (copy), u8 (copy), u4 (copy), u9 (copy), RunService (copy), Tween (copy)
    u7 = u7 + 1;
    local v25 = u1[p20];
    local v26 = `Currency widget not found for type: {p20}`;
    local v27 = assert(v25, v26);
    local v28, _ = v27.Resolve();
    local v29;

    if p24 and p24.MergeKey then
        v29 = p24.MergeKey;
    else
        v29 = p20;
    end;

    local v30 = u5[v29];
    local v31 = u6[v29] or 0;

    if v30 then
        v30:Destroy();
        u5[v29] = nil;

        if not (p24 and p24.TextOverride) then
            p21 = p21 + v31;
        end;
    end;

    local v32 = AddCurrencyScreen.Amount:Clone();
    u5[v29] = v32;
    u6[v29] = p21;
    v32.AnchorPoint = Vector2.new(0.5, 0.5);
    local Label = v32.Label;
    local UIScale = v32:FindFirstChild("UIScale");
    local UIStroke = Label:FindFirstChild("UIStroke");
    UIScale.Scale = 0.9;
    local SpawnSound = v27.SpawnSound;

    if SpawnSound then
        Audio.PlayFromSoundFile(SpawnSound, script);
    end;

    v32.Parent = GetHolder();
    local v33;

    if p24 and p24.TextOverride then
        v33 = p24.TextOverride;
    else
        v33 = "$" .. Simple.FormatCompact(p21, ".");
    end;

    Label.Text = v33;
    Label.TextTransparency = 0;

    if UIStroke then
        UIStroke.Transparency = 0;
    end;

    Label.Visible = true;
    local fromOffset = UDim2.fromOffset;
    local v34 = math.round(v28.AbsoluteSize.X * 1.35);
    local v35 = math.max(v34, 180);
    local v36 = math.round(v28.AbsoluteSize.Y * 0.95);
    v32.Size = fromOffset(v35, (math.max(v36, 40)));
    pcall(ContentProvider.PreloadAsync, ContentProvider, u8);
    local CurrentCamera = workspace.CurrentCamera;
    local v37;

    if CurrentCamera then
        v37 = CurrentCamera.ViewportSize;
    else
        v37 = Vector2.new(1920, 1080);
    end;

    local v38 = p23 or Vector2.new(v37.X * 0.5 + u4:NextNumber(-260, 260), v37.Y * 0.62 + u4:NextNumber(-140, 140));
    local v39 = u9.GetWidgetIconCenter(p20);
    local v40 = v39 - v38;
    local v41 = v40.X >= 0 and -1 or 1;
    local new = Vector2.new;
    local v42 = math.abs(v40.X) * 0.35;
    local v43 = v41 * math.max(160, v42);
    local v44 = math.abs(v40.Y) * 0.35;
    local v45 = (v38 + v39) / 2 + new(v43, -math.max(140, v44));

    local function quadBezier(p46, p47, p48, p49) -- Line: 171
        local v50 = 1 - p49;

        return p46 * (v50 * v50) + p47 * (v50 * 2 * p49) + p48 * (p49 * p49);
    end;

    local v51 = tick();
    local v52 = 0;

    while v52 < 1 and v32.Parent do
        local v53 = (tick() - v51) / 1.9;
        v52 = math.min(v53, 1);
        local v54 = 1 - v52;
        local v55 = v38 * (v54 * v54) + v45 * (v54 * 2 * v52) + v39 * (v52 * v52);
        local v56 = math.clamp((v52 - 0.8) / 0.2, 0, 1);
        v32.Position = UDim2.fromOffset(v55.X, v55.Y);
        UIScale.Scale = math.sin(v52 * 3.141592653589793) * 0.18 + 0.9;
        Label.TextTransparency = v56;

        if UIStroke then
            UIStroke.Transparency = v56;
        end;

        RunService.RenderStepped:Wait();
    end;

    if u5[v29] == v32 then
        u5[v29] = nil;
        u6[v29] = 0;
    end;

    if v32.Parent then
        v32:Destroy();
    end;

    local v57 = u1[p20];
    local v58 = `Currency widget not found for type: {p20}`;
    local v59, v60 = assert(v57, v58).Resolve();
    local v61 = v60 or v59;
    local v62 = v61:FindFirstChildOfClass("UIScale");

    if not v62 then
        v62 = Instance.new("UIScale");
        v62.Parent = v61;
    end;

    v62.Scale = 1.5;
    Tween(v62, {
        Scale = 1
    }, { 0.05, "Sine", "Out" });
    u7 = u7 - 1;
end;

function u9.GetWidgetIconCenter(p63) -- Line: 235
    -- upvalues: u1 (copy)
    local v64 = u1[p63];
    local v65 = `Currency widget not found for type: {p63}`;
    local v66, v67 = assert(v64, v65).Resolve();
    local v68 = v67 or v66;

    return v68.AbsolutePosition + v68.AbsoluteSize / 2;
end;

function u9.GetOrbAnimationTime() -- Line: 240
    return 1.9;
end;

function u9.Create(u69, p70, p71, p72, p73) -- Line: 244
    -- upvalues: Variables (copy), AddCurrencyText (copy), u7 (ref)
    if p70 <= 0 then
        return;
    end;

    local u74 = p72;
    local u75 = p73;
    local u76, v77;

    if typeof(p71) == "table" then
        u76 = p71;
        v77 = p71.NumOrbs;

        if p71.LowVolumeSound ~= nil then
            u74 = p71.LowVolumeSound;
        end;

        if p71.OverrideStarPosition ~= nil then
            u75 = p71.OverrideStarPosition;
        end;
    else
        v77 = p71;
        u76 = nil;
    end;

    local u78 = Variables.Locks.AddScreenCurrency:ObtainLock();
    local u79 = math.min(v77 or 5, p70);
    local u80 = p70 >= 70 and 0.025 or (p70 >= 40 and 0.035 or (p70 >= 20 and 0.055 or 0.1));
    local u81 = p70 / u79;
    local u82 = u79 >= 10 and 3 or 1;
    task.spawn(function() -- Line: 284
        -- upvalues: u79 (copy), u82 (copy), AddCurrencyText (ref), u69 (copy), u81 (copy), u74 (ref), u75 (ref), u76 (ref), u80 (copy)
        for i = 1, math.max(1, u79 - u82) do
            local v83;

            if i == 1 then
                v83 = u76;
            else
                v83 = nil;
            end;

            task.spawn(AddCurrencyText, u69, u81, u74, u75, v83);
            task.wait(u80);
        end;
    end);
    task.spawn(function() -- Line: 297
        -- upvalues: u7 (ref), u78 (copy)
        repeat
            task.wait();
        until u7 == 0;

        u78();
    end);
end;

return u9;