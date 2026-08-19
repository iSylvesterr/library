-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
require(script:WaitForChild("Types"));
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Signal = require(ReplicatedStorage.Packages.Signal);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local LocalPlayer = Players.LocalPlayer;
local u2 = table.find(GetUserPlatform(), "Mobile") and #GetUserPlatform() <= 1;
local u3 = nil;
local u4 = 0;
local u5 = Color3.fromRGB(219, 159, 47);
local u6 = Color3.fromRGB(43, 172, 43);
local u7 = Color3.fromRGB(182, 45, 45);
local u8 = nil;
local u9 = nil;

local function formatTime(p10) -- Line: 94
    local v11 = math.floor(p10 / 60);
    local v12 = p10 % 60;
    local v13 = math.floor(v12);
    local v14 = math.floor((v12 - v13) * 1000);

    return string.format("%02d:%02d.%03d", v11, v13, v14);
end;

local function getBackgroundColor(p15) -- Line: 105
    -- upvalues: u7 (copy), u5 (copy), u6 (copy)
    local v16 = math.clamp(p15, 0, 1);

    if v16 <= 0.5 then
        return u7:Lerp(u5, v16 * 2);
    end;

    return u5:Lerp(u6, (v16 - 0.5) * 2);
end;

local function getBombModel() -- Line: 119
    -- upvalues: CollectionService (copy)
    return CollectionService:GetTagged("Bomb")[1];
end;

local function isBombResolvedState(p17) -- Line: 125
    if p17 then
        return (p17:GetAttribute("Defused") == true or p17:GetAttribute("Exploding") == true) and true or p17:GetAttribute("Exploded") == true;
    end;

    return false;
end;

local function getSyncedDefuseStartTime(p18, p19) -- Line: 137
    local v20 = p18:GetAttribute("DefuseStartTime");

    if typeof(v20) ~= "number" then
        return nil;
    end;

    local v21 = workspace:GetServerTimeNow();
    local v22 = v21 - v20;

    if v20 <= v21 and (v22 >= 0 and v22 <= math.max(p19, 12)) then
        return v20;
    end;

    return nil;
end;

function u1.InitializeProgressBar(p23) -- Line: 157
    -- upvalues: u7 (copy)
    if not (p23.Frame and p23.Frame.ProgressBar) then
        warn("DefuseBomb: Frame or ProgressBar not found");

        return;
    end;

    local ProgressBar = p23.Frame.ProgressBar;
    local LeftGradient = ProgressBar:FindFirstChild("LeftGradient");
    local RightGradient = ProgressBar:FindFirstChild("RightGradient");
    local ProgressBarImage = LeftGradient:FindFirstChild("ProgressBarImage");
    local ProgressBarImage2 = RightGradient:FindFirstChild("ProgressBarImage");
    local UIGradient = ProgressBarImage:FindFirstChild("UIGradient");
    local UIGradient2 = ProgressBarImage2:FindFirstChild("UIGradient");
    p23.LeftProgressImage = ProgressBarImage;
    p23.RightProgressImage = ProgressBarImage2;
    p23.LeftGradient = UIGradient;
    p23.RightGradient = UIGradient2;
    ProgressBarImage.ImageColor3 = u7;
    ProgressBarImage2.ImageColor3 = u7;
    ProgressBarImage.ImageTransparency = 0;
    ProgressBarImage2.ImageTransparency = 0;
    LeftGradient.Visible = true;
    RightGradient.Visible = true;
    ProgressBarImage.Visible = true;
    ProgressBarImage2.Visible = true;
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.501, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.501, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Rotation = 0;
    UIGradient2.Rotation = 0;
end;

function u1.UpdateProgressBar(p24, p25) -- Line: 219
    -- upvalues: u7 (copy), u5 (copy), u6 (copy)
    if not (p24.Frame and p24.Frame.ProgressBar) then
        return;
    end;

    if not (p24.LeftGradient and p24.RightGradient) then
        return;
    end;

    if not (p24.LeftProgressImage and p24.RightProgressImage) then
        return;
    end;

    local v26 = math.clamp(p25, 0, 1);
    local v27 = math.clamp(v26, 0, 1);
    local v28;

    if v27 <= 0.5 then
        v28 = u7:Lerp(u5, v27 * 2);
    else
        v28 = u5:Lerp(u6, (v27 - 0.5) * 2);
    end;

    p24.LeftProgressImage.ImageColor3 = v28;
    p24.RightProgressImage.ImageColor3 = v28;
    local v29 = v26 * 180;
    p24.RightGradient.Rotation = 360 - v29;
    p24.LeftGradient.Rotation = v29 + 180;
    p24:AnimateBomb(v26);

    if p24.Frame.UIGradient then
        local v30 = math.clamp(v26, 0, 1);
        local v31;

        if v30 <= 0.5 then
            v31 = u7:Lerp(u5, v30 * 2);
        else
            v31 = u5:Lerp(u6, (v30 - 0.5) * 2);
        end;

        local v32 = v31:Lerp(Color3.new(0, 0, 0), 0.3);
        p24.Frame.UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, v31), ColorSequenceKeypoint.new(1, v32) });
    end;

    local v33 = math.clamp(v26, 0, 1);
    local v34;

    if v33 <= 0.5 then
        v34 = u7:Lerp(u5, v33 * 2);
    else
        v34 = u5:Lerp(u6, (v33 - 0.5) * 2);
    end;

    local v35 = v34:Lerp(Color3.new(0, 0, 0), 0.2);

    if p24.Frame.Frame1 then
        p24.Frame.Frame1.BackgroundColor3 = v35;
    end;

    if p24.Frame.Frame2 then
        p24.Frame.Frame2.BackgroundColor3 = v35;
    end;
end;

function u1.AnimateBomb(p36, p37) -- Line: 263
    if not (p36.Frame and p36.Frame.ProgressBar) then
        return;
    end;

    local Bomb = p36.Frame.ProgressBar:FindFirstChild("Bomb");

    if not Bomb then
        return;
    end;

    local v38 = tick() * (p37 * 0.5 + 0.5) * 3.141592653589793 * 2;
    local v39 = math.sin(v38);
    local v40 = Vector2.new(0.5, 0.45);
    local v41 = v39 * 0.05 + 1;
    local v42 = UDim2.new(v40.X * v41, 0, v40.Y * v41, 0);
    local v43 = Color3.fromRGB(255, 200, 0):Lerp(Color3.fromRGB(255, 255, 255), (v39 + 1) / 2);
    Bomb.Size = v42;
    Bomb.ImageColor3 = v43;
end;

function u1.UpdateTimer(p44, p45) -- Line: 306
    if not (p44.Frame and p44.Frame.Timer) then
        return;
    end;

    local Timer = p44.Frame.Timer;
    local v46 = math.floor(p45 / 60);
    local v47 = p45 % 60;
    local v48 = math.floor(v47);
    local v49 = math.floor((v47 - v48) * 1000);
    Timer.Text = string.format("%02d:%02d.%03d", v46, v48, v49);
    p44.Frame.Timer.TextStrokeColor3 = Color3.new(0, 0, 0);
    p44.Frame.Timer.TextColor3 = Color3.new(1, 1, 1);
    p44.Frame.Timer.TextStrokeTransparency = 0;
end;

function u1.UpdateTitle(p50) -- Line: 322
    if not (p50.Frame and p50.Frame.Title) then
        return;
    end;

    p50.Frame.Title.Text = string.format("%s is defusing the bomb %s a kit.", p50.PlayerName, p50.HasDefuseKit and "with" or "without");
    p50.Frame.Title.TextStrokeColor3 = Color3.new(0, 0, 0);
    p50.Frame.Title.TextColor3 = Color3.new(1, 1, 1);
    p50.Frame.Title.TextStrokeTransparency = 0;
end;

function u1.StartDefuse(u51, p52) -- Line: 341
    -- upvalues: LocalPlayer (copy), SpectateController (copy), CollectionService (copy), RunServiceController (copy), u2 (copy), InputController (copy), Remotes (copy), u4 (ref)
    local v53 = LocalPlayer:GetAttribute("IsSpectating");
    local v54 = SpectateController.GetCurrentSpectateInstance();
    local v55 = p52 or (v53 and (v54 and v54.Player) or LocalPlayer);

    if u51.IsDefusing and u51.PlayerName == v55.Name then
        return;
    end;

    local v56 = CollectionService:GetTagged("Bomb")[1];
    local v57;

    if v56 then
        v57 = (v56:GetAttribute("Defused") == true or v56:GetAttribute("Exploding") == true) and true or v56:GetAttribute("Exploded") == true;
    else
        v57 = false;
    end;

    if v57 then
        return;
    end;

    if v55 == LocalPlayer then
        LocalPlayer:SetAttribute("IsLocallyDefusingBomb", true);
    end;

    u51.HasDefuseKit = v55:GetAttribute("HasDefuseKit") == true;
    u51.PlayerName = v55.Name;
    u51.DefuseTime = u51.HasDefuseKit and 5 or 10;
    local DefuseTime = u51.DefuseTime;
    local v58 = v55:GetAttribute("DefuseStartTime");

    if typeof(v58) == "number" then
        local v59 = workspace:GetServerTimeNow();
        local v60 = v59 - v58;

        if v58 > v59 or (v60 < 0 or v60 > math.max(DefuseTime, 12)) then
            v58 = nil;
        end;
    else
        v58 = nil;
    end;

    u51.DefuseStartTime = v58 or workspace:GetServerTimeNow();
    u51.DefuseProgress = 0;
    u51.IsDefusing = true;
    u51.IsFinished = false;
    u51.HasSentDefuseRequest = false;
    u51.HasReceivedServerStartAck = false;
    u51.DefuseSessionId = nil;

    if u51.Frame then
        u51.Frame.Visible = true;
    end;

    u51:UpdateProgressBar(0);
    u51:UpdateTimer(u51.DefuseTime);
    u51:UpdateTitle();
    u51.Janitor:Add(RunServiceController.BindToHeartbeat("UI.DefuseBomb.UpdateProgress", function() -- Line: 388
        -- upvalues: u51 (copy), CollectionService (ref), LocalPlayer (ref), SpectateController (ref), u2 (ref), InputController (ref), Remotes (ref)
        if not u51.IsDefusing or u51.IsFinished then
            return;
        end;

        local v61 = CollectionService:GetTagged("Bomb")[1];
        local v62;

        if v61 then
            v62 = (v61:GetAttribute("Defused") == true or v61:GetAttribute("Exploding") == true) and true or v61:GetAttribute("Exploded") == true;
        else
            v62 = false;
        end;

        if v62 then
            if v61 and v61:GetAttribute("Defused") == true then
                u51:FinishDefuse(true);

                return;
            end;

            u51:CancelDefuse(true);

            return;
        end;

        local v63 = LocalPlayer:GetAttribute("IsSpectating");
        local v64 = SpectateController.GetCurrentSpectateInstance();

        if v63 then
            if v64 then
                v63 = u51.PlayerName ~= LocalPlayer.Name;
            else
                v63 = v64;
            end;
        end;

        local DefuseTime2 = u51.DefuseTime;
        local v65 = (v63 and v64 and v64.Player or LocalPlayer):GetAttribute("DefuseStartTime");

        if typeof(v65) == "number" then
            local v66 = workspace:GetServerTimeNow();
            local v67 = v66 - v65;

            if v65 > v66 or (v67 < 0 or v67 > math.max(DefuseTime2, 12)) then
                v65 = nil;
            end;
        else
            v65 = nil;
        end;

        if v65 and math.abs(v65 - u51.DefuseStartTime) > 0.001 then
            u51.DefuseStartTime = v65;
        end;

        if v63 and v64 then
            if not v64.Player:GetAttribute("IsDefusingBomb") then
                if v61 and v61:GetAttribute("Defused") == true then
                    u51:FinishDefuse(true);

                    return;
                end;

                u51:CancelDefuse(true);

                return;
            end;
        else
            local Character = LocalPlayer.Character;

            if Character and (Character.PrimaryPart and (v61 and (v61.PrimaryPart and (Character.PrimaryPart.Position - v61.PrimaryPart.Position).Magnitude > 10))) then
                u51:CancelDefuse(false);

                return;
            end;

            if not (u2 or InputController.isActionActive("Use")) then
                u51:CancelDefuse(false);

                return;
            end;
        end;

        local v68;

        if v63 then
            v68 = false;
        else
            v68 = LocalPlayer:GetAttribute("IsDefusingBomb") == true;

            if v68 then
                u51.HasReceivedServerStartAck = true;
            end;

            if not v68 and (u51.HasReceivedServerStartAck or u51.HasSentDefuseRequest) then
                if v61 and v61:GetAttribute("Defused") == true then
                    u51:FinishDefuse(true);

                    return;
                end;

                u51:CancelDefuse(true);

                return;
            end;
        end;

        local v69 = workspace:GetServerTimeNow() - u51.DefuseStartTime;
        u51.DefuseProgress = math.min(v69 / u51.DefuseTime, 1);
        local v70 = math.max(u51.DefuseTime - v69, 0);
        u51:UpdateProgressBar(u51.DefuseProgress);
        u51:UpdateTimer(v70);

        if v63 or (u51.DefuseProgress < 1 or (u51.HasSentDefuseRequest or not v68)) then
            return;
        end;

        u51.HasSentDefuseRequest = true;
        Remotes.C4.Defused.Send();
    end), "Disconnect", "ProgressConnection");

    if not v53 or v55 == LocalPlayer then
        u4 = u4 + 1;
        u51.DefuseSessionId = u4;
        Remotes.C4.StartDefuse.Send({
            SessionId = u51.DefuseSessionId
        });
    end;

    u51.DefuseStarted:Fire();
end;

function u1.CancelDefuse(u71, p72) -- Line: 514
    -- upvalues: LocalPlayer (copy), SpectateController (copy), u9 (ref), Remotes (copy)
    if not u71.IsDefusing then
        return;
    end;

    local v73 = LocalPlayer:GetAttribute("IsSpectating");
    local v74 = SpectateController.GetCurrentSpectateInstance();

    if v73 then
        if v74 then
            v74 = u71.PlayerName ~= LocalPlayer.Name;
        end;
    else
        v74 = v73;
    end;

    u71.IsDefusing = false;
    u71.IsFinished = true;

    if not v74 then
        LocalPlayer:SetAttribute("IsLocallyDefusingBomb", nil);
    end;

    if u9 == u71 then
        u9 = nil;
    end;

    u71:UpdateProgressBar(0);

    if u71.Frame then
        u71.Frame.Visible = false;
    end;

    if not (p72 or v74) then
        Remotes.C4.CancelDefuse.Send({
            SessionId = u71.DefuseSessionId
        });
    end;

    u71.DefuseCancelled:Fire();
    task.defer(function() -- Line: 557
        -- upvalues: u71 (copy)
        u71:Destroy();
    end);
end;

function u1.FinishDefuse(u75, p76) -- Line: 564
    -- upvalues: LocalPlayer (copy), SpectateController (copy), u9 (ref), Remotes (copy)
    if not u75.IsDefusing or u75.IsFinished then
        return;
    end;

    local v77 = LocalPlayer:GetAttribute("IsSpectating");
    local v78 = SpectateController.GetCurrentSpectateInstance();

    if v77 then
        if v78 then
            v78 = u75.PlayerName ~= LocalPlayer.Name;
        end;
    else
        v78 = v77;
    end;

    u75.IsFinished = true;
    u75.IsDefusing = false;

    if not v78 then
        LocalPlayer:SetAttribute("IsLocallyDefusingBomb", nil);
    end;

    if u9 == u75 then
        u9 = nil;
    end;

    if not (p76 or v78) then
        Remotes.C4.Defused.Send();
    end;

    u75.DefuseFinished:Fire();

    if p76 then
        task.defer(function() -- Line: 599
            -- upvalues: u75 (copy)
            u75:Destroy();
        end);

        return;
    end;

    task.delay(0.5, function() -- Line: 603
        -- upvalues: u75 (copy)
        u75:Destroy();
    end);
end;

function u1.new(p79) -- Line: 612
    -- upvalues: u1 (copy), Janitor (copy), Signal (copy)
    local v80 = setmetatable({}, u1);
    v80.Janitor = Janitor.new();
    v80.Frame = p79;
    v80.RightProgressImage = nil;
    v80.LeftProgressImage = nil;
    v80.RightGradient = nil;
    v80.LeftGradient = nil;
    v80.DefuseTime = 10;
    v80.HasDefuseKit = false;
    v80.DefuseStartTime = 0;
    v80.DefuseProgress = 0;
    v80.IsDefusing = false;
    v80.IsFinished = false;
    v80.HasSentDefuseRequest = false;
    v80.HasReceivedServerStartAck = false;
    v80.PlayerName = "";
    v80.DefuseCancelled = v80.Janitor:Add(Signal.new());
    v80.DefuseFinished = v80.Janitor:Add(Signal.new());
    v80.DefuseStarted = v80.Janitor:Add(Signal.new());

    if v80.Frame then
        v80.Frame.Visible = false;
    end;

    v80:InitializeProgressBar();

    return v80;
end;

function u1.Destroy(p81) -- Line: 658
    -- upvalues: u9 (ref), LocalPlayer (copy)
    local v82;

    if u9 == nil then
        v82 = false;
    else
        v82 = u9 ~= p81;
    end;

    if p81.PlayerName == LocalPlayer.Name and not v82 then
        LocalPlayer:SetAttribute("IsLocallyDefusingBomb", nil);
    end;

    if u9 == p81 then
        u9 = nil;
    end;

    if p81.Frame and not v82 then
        p81.Frame.Visible = false;
    end;

    p81.Janitor:Destroy();
end;

function u1.Initialize(p83, p84) -- Line: 682
    -- upvalues: u8 (ref), Router (copy), u3 (ref), CollectionService (copy), u9 (ref), u1 (copy), LocalPlayer (copy), SpectateController (copy)
    u8 = p84;
    Router.observerRouter("Start Defuse Bomb", function() -- Line: 686
        -- upvalues: u3 (ref), CollectionService (ref), u9 (ref), u1 (ref), u8 (ref)
        if u3 and workspace:GetServerTimeNow() < u3 then
            return nil;
        end;

        local v85 = CollectionService:GetTagged("Bomb")[1];
        local v86;

        if v85 then
            v86 = (v85:GetAttribute("Defused") == true or v85:GetAttribute("Exploding") == true) and true or v85:GetAttribute("Exploded") == true;
        else
            v86 = false;
        end;

        if v86 then
            return nil;
        end;

        if not u9 then
            u9 = u1.new(u8);
        end;

        if u9 then
            u9:StartDefuse();
        end;

        return nil;
    end);
    Router.observerRouter("Cancel Defuse Bomb", function() -- Line: 710
        -- upvalues: u9 (ref)
        if u9 then
            u9:CancelDefuse(false);
            u9 = nil;
        end;

        return nil;
    end);
    local u87 = nil;

    local function updateSpectateDefuse() -- Line: 723
        -- upvalues: LocalPlayer (ref), SpectateController (ref), CollectionService (ref), u9 (ref), u1 (ref), u8 (ref)
        local v88 = LocalPlayer:GetAttribute("IsSpectating");
        local v89 = SpectateController.GetCurrentSpectateInstance();

        if v88 and v89 then
            local Player = v89.Player;
            local v90 = Player:GetAttribute("IsDefusingBomb");
            local v91 = CollectionService:GetTagged("Bomb")[1];
            local v92;

            if v91 then
                v92 = (v91:GetAttribute("Defused") == true or v91:GetAttribute("Exploding") == true) and true or v91:GetAttribute("Exploded") == true;
            else
                v92 = false;
            end;

            if v92 then
                if u9 then
                    if v91 and v91:GetAttribute("Defused") == true then
                        u9:FinishDefuse(true);
                    else
                        u9:CancelDefuse(true);
                    end;

                    u9 = nil;
                end;

                return;
            end;

            if v90 then
                if not u9 then
                    u9 = u1.new(u8);
                end;

                if u9 then
                    u9:StartDefuse(Player);
                end;
            elseif u9 then
                u9:CancelDefuse(false);
                u9 = nil;
            end;
        elseif u9 and not LocalPlayer:GetAttribute("IsDefusingBomb") then
            u9:CancelDefuse(false);
            u9 = nil;
        end;
    end;

    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(function() -- Line: 770
        -- upvalues: updateSpectateDefuse (copy)
        updateSpectateDefuse();
    end);

    local function setupSpectateDefuseListener() -- Line: 775
        -- upvalues: u87 (ref), SpectateController (ref), updateSpectateDefuse (copy)
        if u87 then
            u87:Disconnect();
            u87 = nil;
        end;

        local v93 = SpectateController.GetCurrentSpectateInstance();

        if v93 then
            u87 = v93.Player:GetAttributeChangedSignal("IsDefusingBomb"):Connect(function() -- Line: 783
                -- upvalues: updateSpectateDefuse (ref)
                updateSpectateDefuse();
            end);
            updateSpectateDefuse();
        end;
    end;

    SpectateController.ListenToSpectate:Connect(function(p94) -- Line: 792
        -- upvalues: setupSpectateDefuseListener (copy)
        setupSpectateDefuseListener();
    end);
    task.wait(0.1);
    setupSpectateDefuseListener();
end;

function u1.SetDefuseBlockedUntil(p95) -- Line: 801
    -- upvalues: u3 (ref)
    u3 = p95;
end;

return u1;