-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ResourceUtil = UtilsSystem.ResourceUtil;
local AssetRegistry = UtilsSystem.AssetRegistry;
local u1 = {
    CAMERA_MIN_ZOOM_MAX = 30,
    CAMERA_MIN_ZOOM_MIN = 0.5,
    MAX_HATCH_TIME = 5,
    DEFAULT_SCALE = 0.2,
    DEFAULT_REWARD_SCALE = 0.5,
    FALL_TIME = 0.85,
    FALL_DISTANCE = 5,
    CONTAINER_DISTANCE_FROM_CAMERA = -7.5,
    SHAKE_COUNT = 3,
    SHAKE_RESTORE_STEP = 0.4,
    RESTORE_TIME = 0.4,
    ENLARGE_TIME = 0.075,
    END_TIME = 0.5,
    BOX_SHAKE_OFFSET_Z = -2,
    REWARD_SCREEN_RATIO = 0.5,
    REWARD_DEPTH_DIVISOR = 4,
    ROTATE_DURATION = 1,
    WAIT_DURATION = 1.5,
    REWARD_ROTATE_START_Z = -7.35,
    REWARD_ROTATE_MOVE_Z = 4,
    REWARD_WAIT_Z = -3.35,
    END_DROP_Y = -5,
    END_CAMERA_Z = -3.35,
    END_YAW = 180,
    HATCH_FINISH_WAIT = 1.2,
    ITEM_FINISH_WAIT = 0.6,
    STAR_OFFSET = {
        CFrame.new(0, 0, 0),
        CFrame.new(1.5, 0, -1),
        CFrame.new(-1.5, 0, -1),
        CFrame.new(-3, 0, -2),
        CFrame.new(3, 0, -2)
    },
    REWARD_OFFSET = {
        CFrame.new(0, 0, 0),
        CFrame.new(1.8, 0, -1),
        CFrame.new(-1.8, 0, -1),
        CFrame.new(-3.8, 0, -2),
        CFrame.new(3.8, 0, -2)
    },
    SHAKE_SOUND_NAMES = { "抽蛋_左摇1", "抽蛋_右摇1", "抽蛋_左摇2", "抽蛋_右摇2" }
};
local u2 = {};

local function _resolveTemplate(p3) -- Line: 78
    -- upvalues: ResourceUtil (copy), ReplicatedStorage (copy)
    local v4 = ResourceUtil.GetTemplate(p3);

    if v4 then
        return v4;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if not Assets then
        return nil;
    end;

    for _, v in string.split(p3, "/") do
        if v ~= "" then
            Assets = Assets:FindFirstChild(v);

            if not Assets then
                return nil;
            end;
        end;
    end;

    return Assets;
end;

local function _getCachedTemplate(p5, p6) -- Line: 110
    -- upvalues: u2 (copy), _resolveTemplate (copy)
    if u2[p5] == nil then
        u2[p5] = _resolveTemplate(p6) or false;
    end;

    local v7 = u2[p5];

    if v7 == false then
        return nil;
    end;

    return v7;
end;

function u1.getStarParticles() -- Line: 123
    -- upvalues: u2 (copy), _resolveTemplate (copy)
    if u2.starParticles == nil then
        u2.starParticles = _resolveTemplate("Hatch/star_particles") or false;
    end;

    local starParticles = u2.starParticles;

    if starParticles == false then
        return nil;
    end;

    return starParticles;
end;

function u1.getOpenParticles() -- Line: 131
    -- upvalues: u2 (copy), _resolveTemplate (copy)
    if u2.openParticles == nil then
        u2.openParticles = _resolveTemplate("Hatch/OPEN_particles") or false;
    end;

    local openParticles = u2.openParticles;

    if openParticles == false then
        return nil;
    end;

    return openParticles;
end;

function u1.getStarEmitter() -- Line: 139
    -- upvalues: u2 (copy), _resolveTemplate (copy)
    if u2.starEmitter == nil then
        u2.starEmitter = _resolveTemplate("Hatch/StarParticle") or false;
    end;

    local starEmitter = u2.starEmitter;

    if starEmitter == false then
        return nil;
    end;

    return starEmitter;
end;

function u1.getGradientFolder() -- Line: 147
    -- upvalues: AssetRegistry (copy), u2 (copy), _resolveTemplate (copy)
    local v8 = AssetRegistry.BuildCatalogPath(AssetRegistry.Catalog.AllGridients, "UIGradient");

    if u2.gradientFolder == nil then
        u2.gradientFolder = _resolveTemplate(v8) or false;
    end;

    local gradientFolder = u2.gradientFolder;

    if gradientFolder == false then
        gradientFolder = nil;
    end;

    if gradientFolder and gradientFolder:IsA("Folder") then
        return gradientFolder;
    end;

    return nil;
end;

function u1.clampRewardIds(p9) -- Line: 161
    -- upvalues: u1 (copy)
    local v10 = #p9;

    if v10 <= u1.MAX_HATCH_TIME then
        return p9, v10;
    end;

    warn("奖励数量超过最大值", v10, u1.MAX_HATCH_TIME);
    local v11 = table.create(u1.MAX_HATCH_TIME);

    for i = 1, u1.MAX_HATCH_TIME do
        v11[i] = p9[i];
    end;

    return v11, u1.MAX_HATCH_TIME;
end;

return table.freeze(u1);