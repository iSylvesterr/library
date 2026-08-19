-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Packages = ReplicatedStorage:WaitForChild("Packages");
local Animations = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Animations");
local Knit = require(Packages:WaitForChild("Knit"));
require(Packages:WaitForChild("Signal"));
require(Packages:WaitForChild("Maid"));
local Player = Knit.Player;
local u1 = Knit.CreateController({
    Name = "MainCharAnimController"
});

function u1.validateChar(p2) -- Line: 25
    -- upvalues: Player (copy)
    p2.playerData.char = Player.Character;

    if not p2.playerData.char then
        return false;
    end;

    p2.playerData.hum = p2.playerData.char:FindFirstChild("Humanoid");

    if not p2.playerData.hum then
        return false;
    end;

    p2.playerData.animator = p2.playerData.hum:FindFirstChild("Animator");

    return p2.playerData.animator and true or false;
end;

function u1.LoadAnim(p3, p4, p5) -- Line: 36
    if not p3:validateChar() then
        return;
    end;

    p3:UnloadAnim(p4.Name);
    local v6 = p3.playerData.animator:LoadAnimation(p4);

    if p5 then
        v6.Priority = p5;
    end;

    if p3.playerData.char and (p3.playerData.char:FindFirstChild("FREEZE RAY") and p4.Name == "Shoot") then
        v6.Looped = false;
        v6.Priority = Enum.AnimationPriority.Action;
    end;

    p3.animationTracks[p4.Name] = v6;
end;

function u1.UnloadAnim(p7, p8) -- Line: 58
    if not p7:validateChar() then
        return;
    end;

    if p7.animationTracks[p8] then
        p7.animationTracks[p8]:Stop();
        p7.animationTracks[p8] = nil;
    end;
end;

function u1.LoadAnimations(p9) -- Line: 68
    -- upvalues: Animations (copy)
    if p9.loadedAnimations then
        return true;
    end;

    p9.loadedAnimations = true;

    if not p9:validateChar() then
        return false;
    end;

    p9.animationTracks = {};

    for _, child in Animations:GetChildren() do
        p9:LoadAnim(child);
    end;

    return true;
end;

function u1.ToggleDefaultAnimations(p10, p11) -- Line: 83
    if not p10:validateChar() then
        return;
    end;

    p10.playerData.char:WaitForChild("Animate").Enabled = p11;

    if not p11 then
        for _, v in pairs(game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid"):GetPlayingAnimationTracks()) do
            v:Stop();
        end;
    end;
end;

function u1.Play(p12, p13, p14, p15, p16) -- Line: 97
    if not p12:validateChar() then
        return;
    end;

    if p12.animationTracks[p13] then
        p12.animationTracks[p13]:Play(p14, p15, p16);

        return;
    end;

    warn("no animation of name " .. p13 .. " exists.");
end;

function u1.Stop(p17, p18) -- Line: 104
    if not p17:validateChar() then
        return;
    end;

    if p17.animationTracks[p18] then
        p17.animationTracks[p18]:Stop();

        return;
    end;

    warn("no animation of name " .. p18 .. " exists.");
end;

function u1.GetAnim(p19, p20) -- Line: 112
    if p19.animationTracks[p20] then
        return p19.animationTracks[p20];
    end;

    warn("no animation of name " .. p20 .. " exists.");
end;

function u1.KnitStart(u21) -- Line: 118
    -- upvalues: u1 (copy), Player (copy), Knit (copy)
    u21.playerData = {};

    local function setupChar(p22) -- Line: 121
        -- upvalues: u21 (copy), u1 (ref), Player (ref)
        u21.loadedAnimations = false;
        u21.animationTracks = {};

        while p22 and not u1:LoadAnimations() do
            p22 = Player.Character;
            task.wait(0.5);
        end;
    end;

    Player.CharacterAdded:Connect(function(p23) -- Line: 132
        -- upvalues: setupChar (copy)
        setupChar(p23);
    end);
    local Character = Player.Character;

    if Character then
        setupChar(Character);
    end;

    u21.CharacterAnimService = Knit.GetService("CharacterAnimService");
    u21.CharacterAnimService.PlayAnim:Connect(function(p24, p25, p26, p27) -- Line: 143
        -- upvalues: u21 (copy)
        u21:Play(p24, p25, p26, p27);
    end);
    u21.CharacterAnimService.StopAnim:Connect(function(p28) -- Line: 147
        -- upvalues: u21 (copy)
        u21:Stop(p28);
    end);
end;

return u1;