-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ToolSetup = require(ReplicatedStorage.Library.Util.ToolSetup);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local GunUtil = require(ReplicatedStorage.Library.Util.GunUtil);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local Audio = require(ReplicatedStorage.Library.Audio);
local Gears = require(ReplicatedStorage.Directory.Gears);
require(ReplicatedStorage.Directory.Gears.Types.ToolConfigs);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local v2 = GunUtil.GetAvailableGuns();
local Gun = Constants.NETWORK_MAP.Gun;
local LocalPlayer = Players.LocalPlayer;
local CurrentCamera = workspace.CurrentCamera;
local u3 = nil;

local function createWallCheckParams(p4) -- Line: 33
    local v5 = RaycastParams.new();
    v5.FilterType = Enum.RaycastFilterType.Exclude;
    local v6 = { p4 };
    local v7 = p4:FindFirstChildOfClass("Tool");

    if v7 then
        table.insert(v6, v7);
    end;

    v5.FilterDescendantsInstances = v6;
    v5.IgnoreWater = true;

    return v5;
end;

local function isShootPathBlocked(p8, p9, p10) -- Line: 48
    -- upvalues: createWallCheckParams (copy)
    if not (p10 and p8) then
        return true;
    end;

    local HumanoidRootPart = p10:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return true;
    end;

    local v11 = p10:FindFirstChild("Right Arm");

    if not v11 then
        return true;
    end;

    local RightShoulderAttachment = v11:FindFirstChild("RightShoulderAttachment");

    if not RightShoulderAttachment then
        return true;
    end;

    local v12 = p8.WorldPosition - RightShoulderAttachment.WorldPosition;
    local v13 = createWallCheckParams(p10);

    return workspace:Raycast(RightShoulderAttachment.WorldPosition, v12, v13) ~= nil;
end;

local function getArmShootPosition(p14, p15) -- Line: 75
    -- upvalues: LocalPlayer (copy), CurrentCamera (copy), isShootPathBlocked (copy)
    if not p14 then
        return Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), true;
    end;

    local v16 = LocalPlayer:GetMouse();
    local v17 = CurrentCamera:ScreenPointToRay(v16.X, v16.Y);
    local v18 = v17.Origin + v17.Direction * 1000;
    local v19 = RaycastParams.new();
    v19.FilterType = Enum.RaycastFilterType.Exclude;
    local v20 = { p15 };
    local v21 = p15:FindFirstChildOfClass("Tool");

    if v21 then
        table.insert(v20, v21);
    end;

    v19.FilterDescendantsInstances = v20;
    v19.IgnoreWater = true;
    local v22 = workspace:Raycast(v17.Origin, v17.Direction * 1000, v19);

    if v22 then
        v18 = v22.Position;
    end;

    local WorldPosition = p14.WorldPosition;
    local Unit = (v18 - WorldPosition).Unit;

    return WorldPosition, Unit, isShootPathBlocked(p14, Unit, p15);
end;

u3 = ToolSetup.Initialize(v2, {
    onActivated = function(p23) -- Line: 110, Name: onActivated
        -- upvalues: LocalPlayer (copy), Asserts (copy), getArmShootPosition (copy), u1 (copy), Network (copy), Gun (copy), u3 (ref)
        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        local Shoot = p23:FindFirstChild("Shoot", true);
        local v24 = assert(Shoot, "Shoot Attachment not found");
        Asserts.Attachment(v24);
        local v25, v26, v27 = getArmShootPosition(v24, Character);

        if v27 then
            u1:AtDebug():Log("Shoot blocked by wall - preventing fire");

            return;
        end;

        Network.Fire(Gun.REQUEST_FIRE, u3:GetCurrentToolGearName(), v25, v26);
    end,

    onEquipped = function() -- Line: 128, Name: onEquipped
        -- upvalues: u3 (ref), Gears (copy), Audio (copy)
        local v28 = u3:GetCurrentToolGearName();

        if not v28 then
            return;
        end;

        local EQUIP_SFX = Gears.Directory[v28].EQUIP_SFX;

        if not EQUIP_SFX then
            return;
        end;

        Audio.PlayFromSoundFile(EQUIP_SFX, script);
    end,

    onUnequipped = function() -- Line: 143, Name: onUnequipped
        -- upvalues: Network (copy), Gun (copy), u3 (ref)
        Network.Fire(Gun.CLEAR_PLAYER_CASTER, u3:GetCurrentToolGearName());
    end
});