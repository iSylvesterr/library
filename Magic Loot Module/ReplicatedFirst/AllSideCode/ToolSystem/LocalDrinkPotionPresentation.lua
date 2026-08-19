-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AnimationModule = UtilsSystem.AnimationModule;
local HumanModule = UtilsSystem.HumanModule;
local Log = UtilsSystem.Log;
local SoundModule = UtilsSystem.SoundModule;
local VisibleMgr = UtilsSystem.VisibleMgr;
local u1 = {};
local u2 = {};

local function _resolvePotionCapSubtree(p3) -- Line: 55
    return p3:FindFirstChild("瓶盖") or p3:FindFirstChild("瓶塞");
end;

local function _prepareDrinkingCapTimeline(p4) -- Line: 69
    -- upvalues: VisibleMgr (copy)
    local v5 = p4:FindFirstChild("瓶盖") or p4:FindFirstChild("瓶塞");

    if not v5 then
        return nil;
    end;

    local v6 = VisibleMgr.BuildBridgeSnapshots(p4, v5);

    return #v6 ~= 0 and {
        attachedAlready = false,
        restoredAlready = false,
        model = p4,
        capInst = v5,
        snapshot = v6
    } or nil;
end;

local function _tryAttachDrinkingCapToLeftHand(p7, p8) -- Line: 94
    -- upvalues: HumanModule (copy), Log (copy), VisibleMgr (copy)
    if p8.attachedAlready or p8.restoredAlready then
        return nil;
    end;

    local model = p8.model;

    if not model.Parent then
        return nil;
    end;

    local v9 = HumanModule.GetLeftWeaponMountPart(p7) or p7:FindFirstChild("Left Weapon");

    if v9 and v9:IsA("BasePart") then
        if VisibleMgr.AttachSubtreePrimaryToMount(model, p8.capInst, v9, p8.snapshot[1].movingPart, "PotionCapSelf_", "PotionCapMeshLW_", "PotionDrinkCapHand") then
            p8.attachedAlready = true;
        end;

        return nil;
    end;

    Log.print("[LocalDrinkPotionPresentation] 未找到 Left Weapon，跳过瓶盖手部焊");

    return nil;
end;

local function _restoreDrinkingCapIfNeeded(p10) -- Line: 131
    -- upvalues: VisibleMgr (copy)
    if p10.restoredAlready or not p10.attachedAlready then
        return nil;
    end;

    local model = p10.model;

    if not model.Parent then
        return nil;
    end;

    VisibleMgr.RestoreBridgeAndCleanupWelds(model, p10.snapshot, "PotionCapAnchor", "PotionCapSelf_", "PotionCapMeshLW_", "PotionDrinkCapHand");
    p10.restoredAlready = true;

    return nil;
end;

local function _ensureAnimator(p11) -- Line: 157
    local v12 = p11:FindFirstChildOfClass("Humanoid");

    if not v12 then
        return nil;
    end;

    local v13 = v12:FindFirstChildOfClass("Animator");

    if not v13 then
        v13 = Instance.new("Animator");
        v13.Parent = v12;
    end;

    return v13;
end;

function u1.Stop(p14) -- Line: 176
    -- upvalues: u2 (copy), VisibleMgr (copy), AnimationModule (copy)
    local v15 = u2[p14];

    if not v15 then
        return nil;
    end;

    u2[p14] = nil;

    if v15.drinkCapTimeline then
        local drinkCapTimeline = v15.drinkCapTimeline;

        if not drinkCapTimeline.restoredAlready and drinkCapTimeline.attachedAlready then
            local model = drinkCapTimeline.model;

            if model.Parent then
                VisibleMgr.RestoreBridgeAndCleanupWelds(model, drinkCapTimeline.snapshot, "PotionCapAnchor", "PotionCapSelf_", "PotionCapMeshLW_", "PotionDrinkCapHand");
                drinkCapTimeline.restoredAlready = true;
            end;
        end;
    end;

    AnimationModule.StopAnimByModel(v15.character, v15.animName, 0.05);

    return nil;
end;

function u1.Play(u16) -- Line: 195
    -- upvalues: u1 (copy), _prepareDrinkingCapTimeline (copy), u2 (copy), SoundModule (copy), AnimationModule (copy), _tryAttachDrinkingCapToLeftHand (copy), VisibleMgr (copy)
    local character = u16.character;
    local potionModel = u16.potionModel;
    local token = u16.token;
    local isTokenValid = u16.isTokenValid;

    if not (character and (potionModel and isTokenValid)) then
        return false;
    end;

    local v17 = (type(u16.animName) ~= "string" or u16.animName == "") and "喝下药水" or u16.animName;
    u1.Stop(token);
    local v18 = character:FindFirstChildOfClass("Humanoid");
    local v19;

    if v18 then
        v19 = v18:FindFirstChildOfClass("Animator");

        if not v19 then
            v19 = Instance.new("Animator");
            v19.Parent = v18;
        end;
    else
        v19 = nil;
    end;

    if not v19 then
        return false;
    end;

    local u20 = _prepareDrinkingCapTimeline(potionModel);
    u2[token] = {
        character = character,
        drinkCapTimeline = u20,
        animName = v17
    };
    task.delay(1, function() -- Line: 220
        -- upvalues: isTokenValid (copy), SoundModule (ref)
        if not isTokenValid() then
            return;
        end;

        SoundModule:PlaySoundLocal({
            SoundName = "喝下药水",
            Is2D = true
        });
    end);
    AnimationModule.PlayAnim(v19, v17, 1, nil, nil, Enum.AnimationPriority.Action3);

    if u20 then
        task.delay(0.3, function() -- Line: 233
            -- upvalues: isTokenValid (copy), _tryAttachDrinkingCapToLeftHand (ref), character (copy), u20 (copy)
            if not isTokenValid() then
                return;
            end;

            _tryAttachDrinkingCapToLeftHand(character, u20);
        end);
        task.delay(2.2, function() -- Line: 239
            -- upvalues: isTokenValid (copy), u20 (copy), VisibleMgr (ref)
            if not isTokenValid() then
                return;
            end;

            local v21 = u20;

            if not v21.restoredAlready then
                if not v21.attachedAlready then
                    return;
                end;

                local model = v21.model;

                if not model.Parent then
                    return;
                end;

                VisibleMgr.RestoreBridgeAndCleanupWelds(model, v21.snapshot, "PotionCapAnchor", "PotionCapSelf_", "PotionCapMeshLW_", "PotionDrinkCapHand");
                v21.restoredAlready = true;
            end;
        end);
    end;

    AnimationModule.BindEndFunc(v19, v17, function() -- Line: 247
        -- upvalues: isTokenValid (copy), u20 (copy), VisibleMgr (ref), u2 (ref), token (copy), u16 (copy)
        if not isTokenValid() then
            return;
        end;

        if u20 then
            local v22 = u20;

            if not v22.restoredAlready and v22.attachedAlready then
                local model = v22.model;

                if model.Parent then
                    VisibleMgr.RestoreBridgeAndCleanupWelds(model, v22.snapshot, "PotionCapAnchor", "PotionCapSelf_", "PotionCapMeshLW_", "PotionDrinkCapHand");
                    v22.restoredAlready = true;
                end;
            end;
        end;

        u2[token] = nil;

        if u16.onAnimEnd then
            u16.onAnimEnd();
        end;
    end);

    return true;
end;

return u1;