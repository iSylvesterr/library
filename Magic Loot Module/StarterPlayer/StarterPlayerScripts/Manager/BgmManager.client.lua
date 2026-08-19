-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SystemGameConfig = UtilsSystem.SystemGameConfig;

if SystemGameConfig.GetValue({ "Bgm", "启用" }) == false then
    return;
end;

local SoundInstance = UtilsSystem.SoundInstance;
local LocalPlayer = UtilsSystem.LocalPlayer;
local HumanModule = UtilsSystem.HumanModule;
local CollectionService = UtilsSystem.CollectionService;
local u1 = SystemGameConfig.GetValue({ "Bgm", "默认BGM" });
local u2 = SystemGameConfig.GetValue({ "Bgm", "区域标签" });
local u3 = SystemGameConfig.GetValue({ "Bgm", "区域BGM属性" });
local u4 = SystemGameConfig.GetValue({ "Bgm", "淡入淡出秒" });
local u5 = SystemGameConfig.GetValue({ "Bgm", "检测间隔秒" });
local u6 = SystemGameConfig.GetValue({ "Bgm", "区域边界容差" });
local u7 = "";

local function _getPartVolume(p8) -- Line: 71
    local Size = p8.Size;

    return Size.X * Size.Y * Size.Z;
end;

local function _isPointInsidePart(p9, p10) -- Line: 82
    -- upvalues: u6 (copy)
    local v11 = p10.CFrame:PointToObjectSpace(p9);
    local v12 = p10.Size.X / 2;
    local v13 = p10.Size.Y / 2;
    local v14 = p10.Size.Z / 2;
    local v15;

    if math.abs(v11.X) <= v12 + u6 and math.abs(v11.Y) <= v13 + u6 then
        v15 = math.abs(v11.Z) <= v14 + u6;
    else
        v15 = false;
    end;

    return v15;
end;

local function _resolveTargetBgm(p16) -- Line: 97
    -- upvalues: CollectionService (copy), u2 (copy), _isPointInsidePart (copy), u3 (copy), u1 (copy)
    local v17 = (1 / 0);
    local v18 = false;
    local v19 = nil;

    for _, v in CollectionService:GetTagged(u2) do
        if _isPointInsidePart(p16, v) then
            local v20 = v:GetAttribute(u3);

            if type(v20) == "string" and v20 ~= "" then
                v18 = true;
                local Size = v.Size;
                local v21 = Size.X * Size.Y * Size.Z;

                if v21 < v17 then
                    v19 = v20;
                    v17 = v21;
                end;
            end;
        end;
    end;

    if v18 then
        return v19 or u1;
    end;

    return nil;
end;

local function _playBgm(p22) -- Line: 131
    -- upvalues: u7 (ref), SoundInstance (copy), u4 (copy)
    if p22 == u7 then
        return;
    end;

    if u7 ~= "" then
        for _, v in SoundInstance:GetSoundByName(u7) do
            v:stopSound(u4, true);
        end;
    end;

    local v23 = "AreaBGM_" .. p22;
    local v24 = SoundInstance:GetSoundByTag(v23);

    if v24 then
        v24:playSound(u4);
        u7 = p22;

        return;
    end;

    local v25 = SoundInstance:new({
        Is2D = true,
        SoundName = p22,
        SoundTag = v23
    });

    if not v25 then
        return;
    end;

    v25:playSound(u4);
    u7 = p22;
end;

local function _updateBgm() -- Line: 167
    -- upvalues: HumanModule (copy), LocalPlayer (copy), _resolveTargetBgm (copy), _playBgm (copy)
    local v26 = HumanModule.GetHumanoidRootPart(LocalPlayer);

    if not v26 then
        return;
    end;

    local v27 = _resolveTargetBgm(v26.Position);

    if not v27 then
        return;
    end;

    _playBgm(v27);
end;

local u28 = 0;
RunService.Heartbeat:Connect(function(p29) -- Line: 186
    -- upvalues: u28 (ref), u5 (copy), HumanModule (copy), LocalPlayer (copy), _resolveTargetBgm (copy), _playBgm (copy)
    u28 = u28 + p29;

    if u28 < u5 then
        return;
    end;

    u28 = 0;
    local v30 = HumanModule.GetHumanoidRootPart(LocalPlayer);

    if not v30 then
        return;
    end;

    local v31 = _resolveTargetBgm(v30.Position);

    if not v31 then
        return;
    end;

    _playBgm(v31);
end);