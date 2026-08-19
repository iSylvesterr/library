-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;

function v1.setElementAttachTipHandler(p13) -- Line: 34
    -- upvalues: u2 (ref)
    u2 = p13;
end;

function v1.setPlayerHitPresentationHandler(p14) -- Line: 42
    -- upvalues: u3 (ref)
    u3 = p14;
end;

function v1.setHitCameraShakeHandler(p15) -- Line: 50
    -- upvalues: u4 (ref)
    u4 = p15;
end;

function v1.setHitPhysicsHandler(p16) -- Line: 58
    -- upvalues: u5 (ref)
    u5 = p16;
end;

function v1.setSkillHitPresentationHandler(p17) -- Line: 66
    -- upvalues: u6 (ref)
    u6 = p17;
end;

function v1.setNpcCosmeticHitHandler(p18) -- Line: 74
    -- upvalues: u7 (ref)
    u7 = p18;
end;

function v1.setNpcLocomotionHandler(p19) -- Line: 82
    -- upvalues: u8 (ref)
    u8 = p19;
end;

function v1.setNpcAttackPreviewHandler(p20) -- Line: 90
    -- upvalues: u9 (ref)
    u9 = p20;
end;

function v1.setMonsterDisturbedHandler(p21) -- Line: 98
    -- upvalues: u10 (ref)
    u10 = p21;
end;

function v1.setDotHitPresentationHandler(p22) -- Line: 106
    -- upvalues: u11 (ref)
    u11 = p22;
end;

function v1.setDotHitPresentationEndHandler(p23) -- Line: 114
    -- upvalues: u12 (ref)
    u12 = p23;
end;

function v1.connect() -- Line: 121
    -- upvalues: NetWork (copy), NetMsg (copy), u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref)
    NetWork.RegisterClientRemoteEvent(NetMsg.ELEMENT_ATTACH_TIP, function(p24) -- Line: 122
        -- upvalues: u2 (ref)
        if u2 then
            u2(p24);
        end;
    end);
    NetWork.RegisterClientRemoteEvent(NetMsg.PLAYER_HIT_PRESENTATION, function(p25) -- Line: 128
        -- upvalues: u3 (ref)
        if u3 then
            u3(p25);
        end;
    end);
    NetWork.RegisterClientRemoteEvent(NetMsg.HIT_CAMERA_SHAKE, function(p26, p27) -- Line: 134
        -- upvalues: u4 (ref)
        if u4 then
            u4(p26, p27);
        end;
    end);
    NetWork.RegisterClientRemoteEvent(NetMsg.HIT_PHYSICS, function(p28) -- Line: 140
        -- upvalues: u5 (ref)
        if u5 then
            u5(p28);
        end;
    end);
    NetWork.RegisterClientRemoteEvent(NetMsg.SKILL_HIT_PRESENTATION, function(p29) -- Line: 146
        -- upvalues: u6 (ref)
        if u6 then
            u6(p29);
        end;
    end);
    NetWork.RegisterClientRemoteEvent(NetMsg.NPC_COSMETIC_HIT, function(p30) -- Line: 152
        -- upvalues: u7 (ref)
        if u7 then
            u7(p30);
        end;
    end);
    NetWork.RegisterClientRemoteEvent(NetMsg.NPC_LOCOMOTION, function(p31) -- Line: 158
        -- upvalues: u8 (ref)
        if u8 then
            u8(p31);
        end;
    end);
    NetWork.RegisterClientRemoteEvent(NetMsg.NPC_ATTACK_PREVIEW, function(p32) -- Line: 164
        -- upvalues: u9 (ref)
        if u9 then
            u9(p32);
        end;
    end);
    NetWork.RegisterClientRemoteEvent(NetMsg.MONSTER_DISTURBED, function(p33) -- Line: 170
        -- upvalues: u10 (ref)
        if u10 then
            u10(p33);
        end;
    end);
    NetWork.RegisterClientRemoteEvent(NetMsg.DOT_HIT_PRESENTATION, function(p34) -- Line: 176
        -- upvalues: u11 (ref)
        if u11 then
            u11(p34);
        end;
    end);
    NetWork.RegisterClientRemoteEvent(NetMsg.DOT_HIT_PRESENTATION_END, function(p35) -- Line: 182
        -- upvalues: u12 (ref)
        if u12 then
            u12(p35);
        end;
    end);
end;

return v1;