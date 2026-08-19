-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AnimationModule = UtilsSystem.AnimationModule;
local AssetPaths = UtilsSystem.AssetPaths;
local Log = UtilsSystem.Log;
local ResRestore = UtilsSystem.ResRestore;
local v1 = {};
local u2 = {};
local u3 = nil;

local function _isPreloaded(p4) -- Line: 113
    -- upvalues: u2 (copy)
    return u2[p4] == true;
end;

local function _markPreloaded(p5) -- Line: 121
    -- upvalues: u2 (copy)
    u2[p5] = true;
end;

local function _ensureAnimationModule(p6) -- Line: 130
    -- upvalues: AnimationModule (copy), Log (copy)
    if AnimationModule and AnimationModule.GetAnimID then
        return true;
    end;

    Log.warn("[SkillPreloadUtil]", p6, "AnimationModule 不可用");

    return false;
end;

local function _dedupeStrings(p7) -- Line: 143
    local v8 = {};
    local v9 = {};

    for _, v in p7 do
        if not v8[v] then
            v8[v] = true;
            table.insert(v9, v);
        end;
    end;

    return v9;
end;

local function _appendBaseSkillLists(p10, p11, p12, p13) -- Line: 162
    if p10.ResNameList then
        for _, v in p10.ResNameList do
            if type(v) == "string" and v ~= "" then
                table.insert(p11, v);
            end;
        end;
    end;

    if p10.AnimateList then
        for _, v in p10.AnimateList do
            if type(v) == "string" and v ~= "" then
                table.insert(p12, v);
            end;
        end;
    end;

    if p10.SoundList then
        for _, v in p10.SoundList do
            if type(v) == "string" and v ~= "" then
                table.insert(p13, v);
            end;
        end;
    end;
end;

local function _getSoundNameIndex() -- Line: 195
    -- upvalues: u3 (ref), SoundService (copy)
    if u3 then
        return u3;
    end;

    local v14 = {};

    for _, descendant in SoundService:GetDescendants() do
        if descendant:IsA("Sound") and v14[descendant.Name] == nil then
            v14[descendant.Name] = descendant;
        end;
    end;

    u3 = v14;

    return v14;
end;

local function _preloadAnimationsByNames(p15, p16) -- Line: 215
    -- upvalues: AnimationModule (copy), Log (copy), u2 (copy), ResRestore (copy)
    local v17;

    if AnimationModule and AnimationModule.GetAnimID then
        v17 = true;
    else
        Log.warn("[SkillPreloadUtil]", p16, "AnimationModule 不可用");
        v17 = false;
    end;

    if not v17 then
        return;
    end;

    for _, v in p15 do
        if type(v) == "string" and v ~= "" then
            local v18 = AnimationModule.GetAnimID(v);

            if v18 then
                local v19 = "rbxassetid://" .. tostring(v18);
                local u20 = "anim:" .. v19;

                if u2[u20] ~= true then
                    ResRestore.DeferPreloadAnimationId(v19, function() -- Line: 236
                        -- upvalues: u20 (copy), u2 (ref)
                        u2[u20] = true;
                    end);
                end;
            end;
        end;
    end;
end;

local function _executePreload(p21, p22, p23, p24) -- Line: 249
    -- upvalues: _getSoundNameIndex (copy), u2 (copy), ResRestore (copy), _preloadAnimationsByNames (copy)
    local v25 = _getSoundNameIndex();

    for _, v in p21 do
        local u26 = "model:" .. v;

        if u2[u26] ~= true then
            local v27 = p24:FindFirstChild(v);

            if v27 and v27:IsA("Model") then
                ResRestore.DeferPreloadModel(v27, function() -- Line: 265
                    -- upvalues: u26 (copy), u2 (ref)
                    u2[u26] = true;
                end);
            end;
        end;
    end;

    _preloadAnimationsByNames(p22, "PreloadSkill/PreloadBaseSkill");

    for _, v in p23 do
        local u28 = "sound:" .. v;

        if u2[u28] ~= true then
            local v29 = v25[v];

            if v29 then
                ResRestore.DeferPreloadSound(v29, function() -- Line: 281
                    -- upvalues: u28 (copy), u2 (ref)
                    u2[u28] = true;
                end);
            end;
        end;
    end;
end;

local function _getSystemSkillFolder() -- Line: 292
    -- upvalues: ReplicatedStorage (copy)
    local ClientSideCode = ReplicatedStorage:FindFirstChild("ClientSideCode");

    if ClientSideCode then
        ClientSideCode = ClientSideCode:FindFirstChild("SystemSkill");
    end;

    if ClientSideCode and ClientSideCode:IsA("Folder") then
        return ClientSideCode;
    end;

    return nil;
end;

local function _getSkillResFolder() -- Line: 305
    -- upvalues: AssetPaths (copy)
    return AssetPaths.Resolve("ModelRes/Skill", AssetPaths.Scope.Shared);
end;

function v1.PreloadAnimations(p30) -- Line: 319
    -- upvalues: _preloadAnimationsByNames (copy)
    _preloadAnimationsByNames(p30, "PreloadAnimations");
end;

function v1.PreloadSounds(p31) -- Line: 330
    -- upvalues: _getSoundNameIndex (copy), u2 (copy), ResRestore (copy)
    local v32 = _getSoundNameIndex();

    for _, v in p31 do
        if type(v) == "string" and v ~= "" then
            local u33 = "sound:" .. v;

            if u2[u33] ~= true then
                local v34 = v32[v];

                if v34 then
                    ResRestore.DeferPreloadSound(v34, function() -- Line: 345
                        -- upvalues: u33 (copy), u2 (ref)
                        u2[u33] = true;
                    end);
                end;
            end;
        end;
    end;
end;

function v1.PreloadBaseSkill(p35) -- Line: 358
    -- upvalues: ReplicatedStorage (copy), AssetPaths (copy), Log (copy), _appendBaseSkillLists (copy), _executePreload (copy)
    local ClientSideCode = ReplicatedStorage:FindFirstChild("ClientSideCode");

    if ClientSideCode then
        ClientSideCode = ClientSideCode:FindFirstChild("SystemSkill");
    end;

    if not (ClientSideCode and ClientSideCode:IsA("Folder")) then
        ClientSideCode = nil;
    end;

    if ClientSideCode then
        ClientSideCode = ClientSideCode:FindFirstChild("SkillModule");
    end;

    local v36 = AssetPaths.Resolve("ModelRes/Skill", AssetPaths.Scope.Shared);

    if not (ClientSideCode and v36) then
        Log.warn("[SkillPreloadUtil.PreloadBaseSkill] 技能配置或资源目录不存在:", p35);

        return;
    end;

    local v37 = ClientSideCode:FindFirstChild(p35);

    if not (v37 and v37:IsA("ModuleScript")) then
        Log.warn("[SkillPreloadUtil.PreloadBaseSkill] 未找到基础技能配置:", p35);

        return;
    end;

    local success, result = pcall(require, v37);

    if not success then
        Log.warn("[SkillPreloadUtil.PreloadBaseSkill] 加载基础技能配置失败:", p35, result);

        return;
    end;

    if not result then
        Log.warn("[SkillPreloadUtil.PreloadBaseSkill] 基础技能配置为空:", p35);

        return;
    end;

    local v38 = {};
    local v39 = {};
    local v40 = {};
    _appendBaseSkillLists(result, v38, v39, v40);
    _executePreload(v38, v39, v40, v36);
end;

function v1.PreloadSkill(p41) -- Line: 399
    -- upvalues: ReplicatedStorage (copy), AssetPaths (copy), Log (copy), _appendBaseSkillLists (copy), _executePreload (copy), _dedupeStrings (copy)
    local ClientSideCode = ReplicatedStorage:FindFirstChild("ClientSideCode");

    if ClientSideCode then
        ClientSideCode = ClientSideCode:FindFirstChild("SystemSkill");
    end;

    if not (ClientSideCode and ClientSideCode:IsA("Folder")) then
        ClientSideCode = nil;
    end;

    local v42;

    if ClientSideCode then
        v42 = ClientSideCode:FindFirstChild("GroupSkillModule");
    else
        v42 = ClientSideCode;
    end;

    if ClientSideCode then
        ClientSideCode = ClientSideCode:FindFirstChild("SkillModule");
    end;

    local v43 = AssetPaths.Resolve("ModelRes/Skill", AssetPaths.Scope.Shared);

    if not (v42 and (ClientSideCode and v43)) then
        Log.warn("[SkillPreloadUtil.PreloadSkill] 技能配置或资源目录不存在:", p41);

        return;
    end;

    local v44 = v42:FindFirstChild(p41);

    if not (v44 and v44:IsA("ModuleScript")) then
        Log.warn("[SkillPreloadUtil.PreloadSkill] 未找到组技能配置:", p41);

        return;
    end;

    local success, result = pcall(require, v44);

    if not success then
        Log.warn("[SkillPreloadUtil.PreloadSkill] 加载组技能配置失败:", p41, result);

        return;
    end;

    if not (result and result.Skill) then
        Log.warn("[SkillPreloadUtil.PreloadSkill] 组技能配置无效或缺少 Skill 字段:", p41);

        return;
    end;

    local v45 = {};
    local v46 = {};
    local v47 = {};

    for _, v in pairs(result.Skill) do
        local baseSkillName = v.baseSkillName;

        if baseSkillName and type(baseSkillName) == "string" then
            local v48 = ClientSideCode:FindFirstChild(baseSkillName);

            if v48 and v48:IsA("ModuleScript") then
                local success2, result2 = pcall(require, v48);

                if success2 then
                    if result2 then
                        _appendBaseSkillLists(result2, v45, v46, v47);
                    end;
                else
                    Log.warn("[SkillPreloadUtil.PreloadSkill] 加载基础技能配置失败:", baseSkillName, result2);
                end;
            end;
        end;
    end;

    _executePreload(_dedupeStrings(v45), _dedupeStrings(v46), _dedupeStrings(v47), v43);
end;

return v1;