-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ToolSetup = require(ReplicatedStorage.Library.Util.ToolSetup);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Audio = require(ReplicatedStorage.Library.Audio);
local SubspaceMine = require(ReplicatedStorage.Directory.Gears._Index.Other.SubspaceMine);
local COOLDOWN = SubspaceMine.COOLDOWN;
local SubspaceMine2 = Constants.NETWORK_MAP.SubspaceMine;
local LocalPlayer = Players.LocalPlayer;
local u1 = 0;
local u9 = ToolSetup.Initialize(SubspaceMine.DisplayName, {
    onActivated = function(p2) -- Line: 27, Name: onActivated
        -- upvalues: u1 (ref), LocalPlayer (copy), Network (copy), SubspaceMine2 (copy)
        local v3 = tick();

        if v3 - u1 < 1 then
            return;
        end;

        if not (LocalPlayer.Character and LocalPlayer.Character.PrimaryPart) then
            return;
        end;

        u1 = v3;
        local Character = LocalPlayer.Character;
        local PrimaryPart = Character.PrimaryPart;
        local LookVector = PrimaryPart.CFrame.LookVector;
        local v4 = PrimaryPart.Position + LookVector * 4;
        local v5 = RaycastParams.new();
        v5.FilterType = Enum.RaycastFilterType.Exclude;
        v5.FilterDescendantsInstances = { Character };

        if workspace:Raycast(PrimaryPart.Position, LookVector * 4, v5) then
            return;
        end;

        local v6 = Vector3.new(v4.X, v4.Y + 5, v4.Z);
        local v7 = workspace:Raycast(v6, Vector3.new(0, -100, 0), v5);

        if v7 then
            v4 = v7.Position;
        end;

        local v8 = p2:GetAttribute("GearName");

        if typeof(v8) ~= "string" then
            v8 = p2.Name;
        end;

        Network.Fire(SubspaceMine2.REQUEST_PLACE, v8, v4);
    end
});
Network.Fired(SubspaceMine2.TRAP_PLACED):Connect(function() -- Line: 78
    -- upvalues: ToolSetup (copy), u9 (ref), COOLDOWN (copy), Audio (copy)
    ToolSetup.StartCooldown(u9, COOLDOWN);
    Audio.Play(6290067239, script, { 0.9, 1.1 }, 0.43);
end);
Network.Fired(SubspaceMine2.APPLY_HIGHLIGHT):Connect(function(p10, p11) -- Line: 84
    -- upvalues: SubspaceMine (copy)
    if not (p10 and p10.Character) then
        return;
    end;

    local Character = p10.Character;
    local Highlight = Instance.new("Highlight");
    Highlight.Name = "SubspaceMineHighlight";
    Highlight.OutlineColor = SubspaceMine.HIGHLIGHT_COLOR;
    Highlight.FillColor = SubspaceMine.HIGHLIGHT_COLOR;
    Highlight.FillTransparency = 0.5;
    Highlight.OutlineTransparency = 0;
    Highlight.Parent = Character;
    task.delay(p11, function() -- Line: 99
        -- upvalues: Highlight (copy)
        if Highlight and Highlight.Parent then
            Highlight:Destroy();
        end;
    end);
end);