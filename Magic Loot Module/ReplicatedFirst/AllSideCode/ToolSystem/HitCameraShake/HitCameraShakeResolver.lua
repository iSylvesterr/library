-- Decompiled with Potassium's decompiler.

local ReplicatedFirst = game:GetService("ReplicatedFirst");
local UtilsSystem = require(ReplicatedFirst.AllSideCode.UtilsSystem);
local EnumMgr = UtilsSystem.EnumMgr;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local Players = UtilsSystem.Players;
local HitCameraShakeProfile = require(script.Parent.HitCameraShakeProfile);
local v1 = {};
local CameraShakeAudience = EnumMgr.CameraShakeAudience;

local function _resolveVictimUserId(p2) -- Line: 29
    -- upvalues: Players (copy)
    local v3 = Players:GetPlayerFromCharacter(p2);

    return v3 and v3.UserId or nil;
end;

local function _collectNearbyPlayers(p4, p5) -- Line: 41
    -- upvalues: Players (copy)
    local v6 = {};

    for _, v in Players:GetPlayers() do
        local Character = v.Character;

        if Character then
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart and (HumanoidRootPart:IsA("BasePart") and (HumanoidRootPart.Position - p4).Magnitude <= p5) then
                table.insert(v6, v);
            end;
        end;
    end;

    return v6;
end;

local function _resolveAudiencePlayers(p7, p8, p9, p10) -- Line: 66
    -- upvalues: Players (copy), CameraShakeAudience (copy), _collectNearbyPlayers (copy)
    local u11 = {};
    local u12 = {};

    local function addUserId(p13) -- Line: 75
        -- upvalues: u11 (copy), Players (ref), u12 (copy)
        if not p13 or u11[p13] then
            return;
        end;

        local v14 = Players:GetPlayerByUserId(p13);

        if v14 then
            u11[p13] = true;
            table.insert(u12, v14);
        end;
    end;

    local audience = p7.audience;

    if audience == CameraShakeAudience.Attacker then
        if p8 then
            if u11[p8] then
                return u12;
            end;

            local v15 = Players:GetPlayerByUserId(p8);

            if v15 then
                u11[p8] = true;
                table.insert(u12, v15);

                return u12;
            end;
        end;
    elseif audience == CameraShakeAudience.Victim then
        if p9 then
            if u11[p9] then
                return u12;
            end;

            local v16 = Players:GetPlayerByUserId(p9);

            if v16 then
                u11[p9] = true;
                table.insert(u12, v16);

                return u12;
            end;
        end;
    elseif audience == CameraShakeAudience.AttackerAndVictim then
        local v17 = p8 and not u11[p8] and Players:GetPlayerByUserId(p8);

        if v17 then
            u11[p8] = true;
            table.insert(u12, v17);
        end;

        if p9 then
            if u11[p9] then
                return u12;
            end;

            local v18 = Players:GetPlayerByUserId(p9);

            if v18 then
                u11[p9] = true;
                table.insert(u12, v18);

                return u12;
            end;
        end;
    elseif audience == CameraShakeAudience.Nearby and p10 then
        for _, v in _collectNearbyPlayers(p10, p7.nearbyRadius) do
            local UserId = v.UserId;

            if UserId then
                if not u11[UserId] then
                    local v19 = Players:GetPlayerByUserId(UserId);

                    if v19 then
                        u11[UserId] = true;
                        table.insert(u12, v19);
                    end;
                end;
            end;
        end;
    end;

    return u12;
end;

function v1.tryDispatch(p20, p21, p22, p23) -- Line: 113
    -- upvalues: HitCameraShakeProfile (copy), Players (copy), _resolveAudiencePlayers (copy), NetWork (copy), NetMsg (copy)
    if not p20 or (not p21 or (not p22 or type(p23) ~= "table")) then
        return;
    end;

    local v24 = p23.skillDamage or 0;

    if v24 <= 0 then
        return;
    end;

    local v25 = HitCameraShakeProfile.findProfileName(p20.skillModule, p21.hitboxIndex);

    if not v25 then
        return;
    end;

    local v26 = HitCameraShakeProfile.resolve(v25);

    if not v26 then
        return;
    end;

    if v24 < v26.minDamage then
        return;
    end;

    local v27 = p21._cameraShakeCount or 0;

    if v26.maxShakeCount <= v27 then
        return;
    end;

    p21._cameraShakeCount = v27 + 1;
    local attackerUserId = p23.attackerUserId;
    local v28 = Players:GetPlayerFromCharacter(p22);
    local v29 = _resolveAudiencePlayers(v26, attackerUserId, v28 and v28.UserId or nil, p23.hitPos);

    if #v29 == 0 then
        return;
    end;

    for _, v in v29 do
        NetWork.FireClient(v, NetMsg.HIT_CAMERA_SHAKE, v26.shakeType, v26.shakeCooldown);
    end;
end;

return v1;