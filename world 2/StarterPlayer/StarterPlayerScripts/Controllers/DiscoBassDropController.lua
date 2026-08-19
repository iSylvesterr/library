-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local DiscoFlags = require(ReplicatedStorage.SharedModules.Flags.DiscoFlags);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local FieldOfViewController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.FieldOfViewController);
local u2 = { "MusicTracks", "Disco" };
local u3 = nil;
local u4 = false;
local u5 = nil;
local u6 = nil;
local u7 = 0;
local u8 = false;
local u9 = 0;
local u10 = (-1 / 0);
local u11 = nil;

local function getMusicFolder() -- Line: 132
    -- upvalues: u3 (ref), SoundService (copy), u2 (copy)
    local v12 = u3;

    if v12 and v12.Parent then
        return v12;
    end;

    local v13 = SoundService;

    for _, v in u2 do
        if v13 then
            v13 = v13:FindFirstChild(v);
        end;
    end;

    if not (v13 and v13:IsA("Folder")) then
        return nil;
    end;

    u3 = v13;

    return v13;
end;

local function currentLoudness() -- Line: 152
    -- upvalues: getMusicFolder (copy)
    local v14 = getMusicFolder();

    if not v14 then
        return 0;
    end;

    local v15 = 0;

    for _, child in v14:GetChildren() do
        if child:IsA("Sound") and (child.IsPlaying and v15 < child.PlaybackLoudness) then
            v15 = child.PlaybackLoudness;
        end;
    end;

    return v15;
end;

local function resetDetector() -- Line: 167
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    u5 = nil;
    u6 = nil;
    u7 = 0;
    u8 = false;
    u9 = os.clock();
end;

local function startPunch() -- Line: 175
    -- upvalues: u11 (ref)
    u11 = os.clock();
end;

local function approach(p16, p17, p18, p19) -- Line: 180
    return p16 + (p17 - p16) * (1 - math.exp(-p19 / p18));
end;

local function updateDetector(p20) -- Line: 184
    -- upvalues: currentLoudness (copy), u9 (ref), u5 (ref), u7 (ref), u6 (ref), u8 (ref), u10 (ref), u11 (ref)
    local v21 = currentLoudness();
    local v22 = os.clock();
    local v23 = v22 - u9 < 5;
    local v24 = u5 or v21;
    local v25 = v24 + (v21 - v24) * (1 - math.exp(-p20 / 0.8));
    local v26;

    if v23 then
        u7 = v25;
        v26 = v25;
    else
        local v27 = u6 or v25;
        v26 = v27 + (v25 - v27) * (1 - math.exp(-p20 / 6));

        if u7 < v25 then
            u7 = v25;
        else
            local v28 = u7;
            u7 = v28 + (v25 - v28) * (1 - math.exp(-p20 / 30));
        end;
    end;

    u5 = v25;
    u6 = v26;

    if v23 or u7 < 20 then
        return;
    end;

    local v29 = v25 / u7;

    if v29 <= 0.7 then
        u8 = true;
    end;

    if v22 - u10 < 12 then
        return;
    end;

    local v30;

    if v26 * 1.7 <= v25 then
        v30 = v29 >= 0.7;
    else
        v30 = false;
    end;

    if v30 or u8 and v29 >= 0.9 then
        u8 = false;
        u10 = v22;
        u11 = os.clock();
    end;
end;

local function updatePunch() -- Line: 237
    -- upvalues: u11 (ref), FieldOfViewController (copy)
    local v31 = u11;

    if not v31 then
        return;
    end;

    local v32 = os.clock() - v31;

    if v32 < 0.07 then
        FieldOfViewController:SetPunch(18 * (v32 / 0.07));

        return;
    end;

    local v33 = (v32 - 0.07) / 0.55;

    if v33 < 1 then
        FieldOfViewController:SetPunch(18 * (1 - v33) ^ 2);

        return;
    end;

    u11 = nil;
    FieldOfViewController:SetPunch(0);
end;

local function Step(p34) -- Line: 259
    -- upvalues: u4 (ref), DiscoFlags (copy), updateDetector (copy), updatePunch (copy)
    if u4 and DiscoFlags.FovPunchOnBassDrop:Get() then
        updateDetector(p34);
    end;

    updatePunch();
end;

local function Refresh() -- Line: 268
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    local v35 = workspace:GetAttribute("InDisco") == true;

    if v35 == u4 then
        return;
    end;

    u4 = v35;
    u5 = nil;
    u6 = nil;
    u7 = 0;
    u8 = false;
    u9 = os.clock();
end;

function v1.Init(p36) -- Line: 279
end;

function v1.Start(p37) -- Line: 281
    -- upvalues: Refresh (copy), Networking (copy), startPunch (copy), RunService (copy), Step (copy), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    workspace:GetAttributeChangedSignal("InDisco"):Connect(Refresh);
    Networking.Disco.BassDropPreview.OnClientEvent:Connect(startPunch);
    RunService.RenderStepped:Connect(Step);
    local v38 = workspace:GetAttribute("InDisco") == true;

    if v38 == u4 then
        return;
    end;

    u4 = v38;
    u5 = nil;
    u6 = nil;
    u7 = 0;
    u8 = false;
    u9 = os.clock();
end;

return v1;