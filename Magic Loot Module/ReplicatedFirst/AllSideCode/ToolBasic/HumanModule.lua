-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local EnumMgr = UtilsSystem.EnumMgr;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local VisibleMgr = UtilsSystem.VisibleMgr;
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local u1 = {};

local function _isHumanoidAlive(p2) -- Line: 57
    return p2.Parent ~= nil;
end;

local function _checkPhysicEnd(p3) -- Line: 67
    if p3.Parent == nil then
        return true;
    end;

    local v4 = p3:GetAttribute("PhysicEndTime");

    if not v4 then
        return true;
    end;

    if v4 > tick() then
        return false;
    end;

    local v5 = p3:GetAttribute("oldWalkSpeed");

    if v5 then
        p3.WalkSpeed = v5;
    end;

    p3:SetAttribute("PhysicEndTime", nil);

    return true;
end;

local function _getSpeedBuffValue(p6) -- Line: 95
    return p6:GetAttribute("Control") == 1 and 0 or (p6:GetAttribute("Slow") or 1);
end;

local function _setWalkSpeedFromProperty(p7, p8) -- Line: 111
    -- upvalues: u1 (copy)
    local v9 = p7:FindFirstChild("属性");

    if not v9 then
        return nil;
    end;

    local v10 = v9:FindFirstChild(p8);

    if v10 and v10:IsA("NumberValue") then
        u1.SetHumanWalkSpeed(p7, v10.Value);
    end;

    return nil;
end;

local function _resolveCharacterModel(p11) -- Line: 130
    if p11:IsA("Model") then
        return p11;
    end;

    if p11:IsA("Player") then
        return p11.Character;
    end;

    return nil;
end;

function u1.GetCharacter(p12) -- Line: 150
    if p12:IsA("Model") then
        return p12;
    end;

    if p12:IsA("Player") then
        return p12.Character;
    end;

    return nil;
end;

function u1.GetHumanoidRootPart(p13) -- Line: 160
    if not p13:IsA("Model") then
        if p13:IsA("Player") then
            p13 = p13.Character;
        else
            p13 = nil;
        end;
    end;

    if p13 then
        return p13:FindFirstChild("HumanoidRootPart");
    end;

    return nil;
end;

function u1.GetHeadPart(p14) -- Line: 174
    if not p14:IsA("Model") then
        if p14:IsA("Player") then
            p14 = p14.Character;
        else
            p14 = nil;
        end;
    end;

    if p14 then
        return p14:FindFirstChild("Head");
    end;

    return nil;
end;

function u1.GetHumanoid(p15) -- Line: 188
    if not p15:IsA("Model") then
        if p15:IsA("Player") then
            p15 = p15.Character;
        else
            p15 = nil;
        end;
    end;

    if p15 then
        return p15:FindFirstChildOfClass("Humanoid");
    end;

    return nil;
end;

function u1.IsPlrCharAlive(p16) -- Line: 202
    -- upvalues: u1 (copy)
    local v17 = u1.GetHumanoid(p16);

    if not v17 then
        return false;
    end;

    local v18;

    if v17.Health > 0 then
        v18 = v17:GetState() ~= Enum.HumanoidStateType.Dead;
    else
        v18 = false;
    end;

    return v18;
end;

function u1.PhysicChangeHumanWalkSpeed(u19, p20, p21) -- Line: 218
    -- upvalues: _checkPhysicEnd (copy)
    if not u19 then
        return nil;
    end;

    u19:SetAttribute("PhysicEndTime", tick() + p21);
    u19.WalkSpeed = p20;
    task.delay(p21, function() -- Line: 227
        -- upvalues: u19 (copy), _checkPhysicEnd (ref)
        if u19.Parent ~= nil then
            _checkPhysicEnd(u19);
        end;
    end);
    task.delay(p21 + 0.5, function() -- Line: 232
        -- upvalues: u19 (copy), _checkPhysicEnd (ref)
        if u19.Parent ~= nil then
            _checkPhysicEnd(u19);
        end;
    end);

    return nil;
end;

function u1.PhysicChangeHumanWalkSpeedPercent(p22, p23, p24) -- Line: 248
    -- upvalues: u1 (copy)
    if not p22 then
        return nil;
    end;

    local v25 = p22:GetAttribute("oldWalkSpeed");

    if not v25 then
        return nil;
    end;

    u1.PhysicChangeHumanWalkSpeed(p22, v25 * p23, p24);

    return nil;
end;

function u1.SetHumanWalkSpeed(p26, p27) -- Line: 270
    if not p26 then
        return nil;
    end;

    p26:SetAttribute("oldWalkSpeed", p27);
    p26.WalkSpeed = p27 * (p26:GetAttribute("Control") == 1 and 0 or (p26:GetAttribute("Slow") or 1));

    return nil;
end;

function u1.SetNPCWalkSpeed(p28) -- Line: 288
    -- upvalues: EnumMgr (copy), u1 (copy)
    if not p28 then
        return nil;
    end;

    local Speed = EnumMgr.EnemyProperty.Speed;
    local v29 = p28:FindFirstChild("属性");

    if v29 then
        local v30 = v29:FindFirstChild(Speed);

        if v30 and v30:IsA("NumberValue") then
            u1.SetHumanWalkSpeed(p28, v30.Value);
        end;
    end;

    return nil;
end;

function u1.SetHeroWalkSpeed(p31) -- Line: 303
    -- upvalues: EnumMgr (copy), u1 (copy)
    if not p31 then
        return nil;
    end;

    local Speed = EnumMgr.HeroProperty.Speed;
    local v32 = p31:FindFirstChild("属性");

    if v32 then
        local v33 = v32:FindFirstChild(Speed);

        if v33 and v33:IsA("NumberValue") then
            u1.SetHumanWalkSpeed(p31, v33.Value);
        end;
    end;

    return nil;
end;

function u1.RefreshHumanWalkSpeed(p34) -- Line: 318
    -- upvalues: u1 (copy)
    if not p34 then
        return nil;
    end;

    local v35 = p34:GetAttribute("oldWalkSpeed") or p34.WalkSpeed;
    u1.SetHumanWalkSpeed(p34, v35);

    return nil;
end;

function u1.GetIsShiftLocked() -- Line: 332
    return game.Players.LocalPlayer:GetAttribute("IsShiftLocked");
end;

function u1.SetLocalPlayerSpeedAttribute(p36, p37) -- Line: 345
    -- upvalues: RunService (copy), Players (copy)
    if not RunService:IsClient() then
        return nil;
    end;

    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer or (type(p36) ~= "string" or p36 == "") then
        return nil;
    end;

    if p37 then
        LocalPlayer:SetAttribute(p36, true);
    else
        LocalPlayer:SetAttribute(p36, nil);
    end;

    return nil;
end;

function u1.UpdateLocalPlayerSpeed(p38) -- Line: 367
    -- upvalues: RunService (copy), NetWork (copy), NetMsg (copy)
    if not RunService:IsClient() then
        return nil;
    end;

    NetWork.FireBindable(NetMsg.UPDATE_CHARACTER_SPEED, p38);

    return nil;
end;

function u1.GetHeldItem(p39) -- Line: 381
    -- upvalues: u1 (copy)
    if not p39 then
        return nil, nil;
    end;

    local v40 = u1.GetCharacter(p39);

    if not v40 then
        return nil, nil;
    end;

    local v41 = v40:FindFirstChild("Right Weapon");

    if not (v41 and v41:IsA("BasePart")) then
        return nil, nil;
    end;

    local v42 = v40:FindFirstChild("当前手持");

    if not v42 then
        return nil, nil;
    end;

    for _, child in ipairs(v42:GetChildren()) do
        if child:IsA("Model") then
            local v43 = child:GetAttribute("ItemType");

            if type(v43) == "string" then
                local Weapon = child:FindFirstChild("Weapon");

                if Weapon and (Weapon:IsA("WeldConstraint") or Weapon:IsA("Weld")) and (Weapon.Part0 == v41 or Weapon.Part1 == v41) then
                    return child, v43;
                end;
            end;
        end;
    end;

    return nil, nil;
end;

function u1.GetHeldToolbarOnlyId(p44) -- Line: 425
    if not p44 then
        return 0;
    end;

    local v45 = p44:FindFirstChild("当前手持OnlyID");

    return not (v45 and v45:IsA("NumberValue")) and 0 or math.floor(v45.Value);
end;

function u1.GetHeldItemType(p46) -- Line: 442
    -- upvalues: Players (copy), u1 (copy)
    local v47 = nil;

    if typeof(p46) == "Instance" and p46:IsA("Player") then
        v47 = p46;
    elseif type(p46) == "string" then
        v47 = Players:FindFirstChild(p46);
    elseif type(p46) == "number" then
        v47 = Players:GetPlayerByUserId(p46);
    end;

    if not v47 then
        return nil, nil;
    end;

    local v48, v49 = u1.GetHeldItem(v47);

    if v48 and v49 then
        return v49, v48;
    end;

    return nil, nil;
end;

function u1.ApplyHideSelfHat(p50, p51) -- Line: 468
    -- upvalues: VisibleMgr (copy)
    if not p50 then
        return nil;
    end;

    local Hat = p50:FindFirstChild("Hat");

    if not (Hat and Hat:IsA("Folder")) then
        return nil;
    end;

    if p51 then
        Hat:SetAttribute("SkipBulkFade", true);
        VisibleMgr.fadeAll(Hat);
    else
        Hat:SetAttribute("SkipBulkFade", nil);
        VisibleMgr.showAll(Hat);
    end;

    return nil;
end;

function u1.ApplyHideSelfRobe(p52, p53) -- Line: 492
    -- upvalues: VisibleMgr (copy)
    if not p52 then
        return nil;
    end;

    local Robe = p52:FindFirstChild("Robe");

    if not (Robe and Robe:IsA("Folder")) then
        return nil;
    end;

    if p53 then
        Robe:SetAttribute("SkipBulkFade", true);
        VisibleMgr.fadeAll(Robe);
    else
        Robe:SetAttribute("SkipBulkFade", nil);
        VisibleMgr.showAll(Robe);
    end;

    return nil;
end;

function u1.GetLeftWeaponMountPart(p54) -- Line: 516
    if not p54 then
        return nil;
    end;

    local v55 = p54:FindFirstChild("Left Weapon");

    if v55 and v55:IsA("BasePart") then
        return v55;
    end;

    return nil;
end;

function u1.SnapshotCharacterMotor6DC0C1(p56) -- Line: 539
    if not p56 then
        return;
    end;

    for _, descendant in ipairs(p56:GetDescendants()) do
        if descendant:IsA("Motor6D") then
            descendant:SetAttribute("HumanModule_SnapC0", descendant.C0);
            descendant:SetAttribute("HumanModule_SnapC1", descendant.C1);
        end;
    end;
end;

function u1.RestoreCharacterMotor6DC0C1(p57) -- Line: 556
    if not p57 then
        return;
    end;

    for _, descendant in ipairs(p57:GetDescendants()) do
        if descendant:IsA("Motor6D") then
            local v58 = descendant:GetAttribute("HumanModule_SnapC0");
            local v59 = descendant:GetAttribute("HumanModule_SnapC1");

            if typeof(v58) == "CFrame" and typeof(v59) == "CFrame" then
                descendant.C0 = v58;
                descendant.C1 = v59;
            end;
        end;
    end;
end;

return u1;