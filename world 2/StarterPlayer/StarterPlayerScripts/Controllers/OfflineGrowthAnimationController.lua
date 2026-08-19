-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 4
};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
local UserInputService = game:GetService("UserInputService");
local ContextActionService = game:GetService("ContextActionService");
local HapticService = game:GetService("HapticService");
local Debris = game:GetService("Debris");
local CollectionService = game:GetService("CollectionService");
local LocalPlayer = Players.LocalPlayer;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LightingController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.LightingController);
local GrowEffects = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("GrowEffects"));
local PlantBehaviorRules = require(ReplicatedStorage.SharedModules.PlantBehaviorRules);
local AtlanticGiantRenderScale = require(ReplicatedStorage.SharedModules.AtlanticGiantRenderScale);
local MusicTracks = SoundService:WaitForChild("MusicTracks");
local u2 = {
    Normal = SoundService:WaitForChild("SFX"):WaitForChild("OfflineGrowthNormal"),
    Intense = SoundService:WaitForChild("SFX"):WaitForChild("OfflineGrowthIntense")
};

local function ComputeForeverGrowth(p3, p4) -- Line: 106
    -- upvalues: PlantBehaviorRules (copy), AtlanticGiantRenderScale (copy)
    if not PlantBehaviorRules.GrowsForever(p3) then
        return nil, nil;
    end;

    local v5 = p4.MaxAge or 0;

    if v5 <= 0 or (p4.Age or 0) < v5 then
        return nil, nil;
    end;

    local FinishedGrowingAt = p4.FinishedGrowingAt;

    if type(FinishedGrowingAt) ~= "number" or FinishedGrowingAt <= 0 then
        return nil, nil;
    end;

    local v6 = workspace:GetServerTimeNow() - FinishedGrowingAt;

    if v6 <= 0 then
        return nil, nil;
    end;

    return AtlanticGiantRenderScale(v6), FinishedGrowingAt;
end;

local function getOrdinalSuffix(p7) -- Line: 121
    return (p7 == 1 or (p7 == 21 or p7 == 31)) and "st" or ((p7 == 2 or p7 == 22) and "nd" or ((p7 == 3 or p7 == 23) and "rd" or "th"));
end;

function v1.CalculateCutsceneDuration(p8, p9) -- Line: 133
    local v10 = 0;
    local v11 = 0;

    for _, v in p9 do
        local v12 = v.maxAge or 0;

        if v12 > 0 then
            v10 = v10 + math.max(v.newAge - v.oldAge, 0) / v12;
            v11 = v11 + 1;
        end;

        for _, v2 in v.fruits do
            local v13 = v2.maxAge or 0;

            if v13 > 0 then
                v10 = v10 + math.max(v2.newAge - v2.oldAge, 0) / v13;
                v11 = v11 + 1;
            end;
        end;
    end;

    return v11 == 0 and 5 or math.clamp(v10 / v11, 0, 1) * 5 + 5;
end;

function v1.BuildGrowthChanges(p14, p15, p16) -- Line: 164
    -- upvalues: ComputeForeverGrowth (copy)
    local v17 = {};
    local v18 = {};

    for i, v in p16 do
        local v19 = p15[i];
        local v20 = {
            plantId = i,
            plantName = v.PlantName,
            oldAge = v19 and (v19.Age or 0) or 0,
            newAge = v.Age or 0,
            maxAge = v.MaxAge or 0,
            fruits = {}
        };
        local v21 = v19 and (v19.Fruits or {}) or {};
        local v22 = {};

        for i2, v2 in v.Fruits or {} do
            local v23 = v21[i2];
            local v24, v25 = ComputeForeverGrowth(v.PlantName, v2);
            local v26 = {
                fruitId = i2,
                oldAge = v23 and (v23.Age or 0) or 0,
                newAge = v2.Age or 0,
                oldOvertimeGrowth = v23 and (v23.OvertimeGrowth or 1) or 1,
                newOvertimeGrowth = v2.OvertimeGrowth or 1,
                maxAge = v2.MaxAge or 0,
                foreverEndScale = v24,
                foreverFinishedAt = v25
            };
            table.insert(v20.fruits, v26);
            v22[i2] = v26;
        end;

        table.insert(v17, v20);
        v18[i] = {
            plant = v20,
            fruitsById = v22
        };
    end;

    return v17, v18;
end;

function v1.HasMeaningfulGrowthChanges(p27, p28) -- Line: 214
    for _, v in p28 do
        local v29 = v.oldAge or 0;

        if math.abs((v.newAge or v29) - v29) > 0.0001 then
            return true;
        end;

        for _, v2 in v.fruits do
            local v30 = v2.oldAge or 0;

            if math.abs((v2.newAge or v30) - v30) > 0.0001 then
                return true;
            end;

            local v31 = v2.oldOvertimeGrowth or 1;
            local v32 = v2.newOvertimeGrowth or v31;
            local v33 = math.abs(v31);
            local v34 = math.max(v33, 0.0001);

            if math.abs(v32 - v31) / v34 > 0.05 then
                return true;
            end;
        end;
    end;

    return false;
end;

function v1.ClassifyGrowthIntensity(p35, p36) -- Line: 244
    if not p35:HasMeaningfulGrowthChanges(p36) then
        return "Normal";
    end;

    local v37 = 0;
    local v38 = 0;

    for _, v in p36 do
        local v39 = v.maxAge or 0;

        if v39 > 0 then
            v37 = v37 + math.max(v.newAge - v.oldAge, 0) / v39;
            v38 = v38 + 1;
        end;

        for _, v2 in v.fruits do
            local v40 = v2.maxAge or 0;

            if v40 > 0 then
                v37 = v37 + math.max(v2.newAge - v2.oldAge, 0) / v40;
                v38 = v38 + 1;
            end;
        end;
    end;

    return v38 == 0 and "Normal" or (math.clamp(v37 / v38, 0, 1) >= 0.35 and "Intense" or "Normal");
end;

function v1.DuckMusic(p41, p42) -- Line: 282
    -- upvalues: MusicTracks (copy), TweenService (copy), Debris (copy)
    local v43 = TweenInfo.new(p42 or 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local v44 = {};

    for _, v in MusicTracks:QueryDescendants("Sound[IsPlaying = true]") do
        v44[v] = v.Volume;
        local v45 = TweenService:Create(v, v43, {
            Volume = 0.2
        });
        v45:Play();
        Debris:AddItem(v45, v43.Time);
    end;

    return v44;
end;

function v1.RestoreMusic(p46, p47, p48) -- Line: 302
    -- upvalues: TweenService (copy), Debris (copy)
    local v49 = TweenInfo.new(p48 or 1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);

    for i, v in p47 do
        if i and i.Parent then
            local v50 = TweenService:Create(i, v49, {
                Volume = v
            });
            v50:Play();
            Debris:AddItem(v50, v49.Time);
        end;
    end;
end;

function v1.StartGrowthSound(p51, p52) -- Line: 320
    -- upvalues: u2 (copy)
    if not (p52 and u2[p52]) then
        return nil;
    end;

    local v53 = u2[p52];
    v53.Looped = true;
    v53.Volume = 0.35;
    v53:Play();

    return v53;
end;

function v1.StopGrowthSound(p54, u55, p56) -- Line: 335
    -- upvalues: TweenService (copy), Debris (copy)
    if not u55 then
        return;
    end;

    local v57 = p56 or 1;

    if v57 <= 0 then
        u55:Stop();
        u55.Looped = false;

        return;
    end;

    local v58 = TweenInfo.new(v57, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local v59 = TweenService:Create(u55, v58, {
        Volume = 0
    });
    v59:Play();
    Debris:AddItem(v59, v58.Time);
    v59.Completed:Once(function() -- Line: 347
        -- upvalues: u55 (copy)
        u55:Stop();
        u55.Looped = false;
        u55.Volume = 2;
    end);
end;

function v1.ZeroAllPlantAndFruitAges(p60, p61, p62, p63, p64, p65, p66) -- Line: 358
    local v67 = os.clock();
    local v68 = 0;

    for _, v in p62 do
        local v69 = p63(p61, v.plantId);
        local v70 = p64(p61, v.plantId);

        if v69 and v70 then
            local v71 = v.oldAge or 0;
            v69:SetAttribute("Age", v71);
            v70.CurrentAge = v71;
        end;

        if p65 and p66 then
            for _, v2 in v.fruits do
                local v72 = p65(p61, v.plantId, v2.fruitId);
                local v73 = p66(p61, v.plantId, v2.fruitId);

                if v72 and v73 then
                    local v74 = v2.oldAge or 0;
                    v72:SetAttribute("Age", v74);
                    v73.CurrentAge = v74;
                end;
            end;
        end;

        v68 = v68 + 1;

        if v68 >= 10 and os.clock() - v67 >= 0.004 then
            task.wait();
            v67 = os.clock();
            v68 = 0;
        end;
    end;
end;

function v1.ApplyFinalGrowthState(p75, p76, p77, p78, p79, p80, p81, p82, p83, p84) -- Line: 399
    local v85 = os.clock();
    local v86 = 0;

    for _, v in p77 do
        local v87 = p78(p76, v.plantId);
        local v88 = p79(p76, v.plantId);

        if v87 and v88 then
            v87:SetAttribute("Age", v.newAge);
            v88.CurrentAge = v.newAge;
            v88._syncedAge = nil;

            if (v.maxAge or 0) <= v.newAge then
                local v89 = v87:GetAttribute("SeedName");

                if v89 and p80(v89) then
                    p81(v87);
                end;
            end;
        end;

        if p82 and (p83 and p84) then
            for _, v2 in v.fruits do
                local v90 = p82(p76, v.plantId, v2.fruitId);
                local v91 = p83(p76, v.plantId, v2.fruitId);

                if v90 and v91 then
                    v90:SetAttribute("Age", v2.newAge);
                    v91.CurrentAge = v2.newAge;
                    v91.OvertimeGrowth = v2.newOvertimeGrowth;
                    v91._syncedAge = nil;

                    if v2.foreverFinishedAt then
                        v91.FinishedGrowingAt = v2.foreverFinishedAt;
                    end;

                    if (v2.maxAge or 0) <= v2.newAge then
                        p84(v90, v.plantId, v2.fruitId);
                    end;
                end;
            end;
        end;

        v86 = v86 + 1;

        if v86 >= 10 and os.clock() - v85 >= 0.004 then
            task.wait();
            v85 = os.clock();
            v86 = 0;
        end;
    end;
end;

function v1.AttachModelsToGrowthChanges(p92, p93, p94, p95, p96) -- Line: 466
    for _, v in p94 do
        v.model = p95(p93, v.plantId);

        if p96 then
            for _, v2 in v.fruits do
                v2.model = p96(p93, v.plantId, v2.fruitId);
            end;
        end;
    end;
end;

function v1.AreGrowthVisualsReady(p97, p98, p99, p100, p101, p102, p103) -- Line: 483
    local v104 = false;

    for _, v in p99 do
        local v105 = p100(p98, v.plantId);
        local v106 = p101(p98, v.plantId);

        if v105 or v106 then
            if not (v105 and (v106 and v105.Parent)) then
                return false;
            end;

            if not v105:HasTag("InitializationComplete") then
                return false;
            end;

            v104 = true;
        end;

        if p102 and p103 then
            for _, v2 in v.fruits do
                local v107 = p102(p98, v.plantId, v2.fruitId);
                local v108 = p103(p98, v.plantId, v2.fruitId);

                if v107 or v108 then
                    if not (v107 and (v108 and v107.Parent)) then
                        return false;
                    end;

                    if not v107:HasTag("InitializationComplete") then
                        return false;
                    end;

                    v104 = true;
                end;
            end;
        end;
    end;

    return v104;
end;

function v1.WaitForGrowthVisualsReady(p109, p110, p111, p112, p113, p114, p115) -- Line: 526
    -- upvalues: RunService (copy)
    local v116 = os.clock();
    local v117 = 0;

    while os.clock() - v116 < 20 do
        v117 = v117 + 1;

        if v117 % 3 == 0 and p109:AreGrowthVisualsReady(p110, p111, p112, p113, p114, p115) then
            return true;
        end;

        RunService.Heartbeat:Wait();
    end;

    return false;
end;

function v1.TweenAgeAttribute(p118, p119, p120, p121, p122, p123) -- Line: 557
    -- upvalues: TweenService (copy), RunService (copy)
    if not p119 then
        return false;
    end;

    local v124 = p123 or {};
    local v125 = v124.easingStyle or Enum.EasingStyle.Quad;
    local v126 = v124.easingDirection or Enum.EasingDirection.Out;
    local cancelPredicate = v124.cancelPredicate;
    local onStep = v124.onStep;

    if p120 == nil then
        local v127 = p119:GetAttribute("Age");
        p120 = typeof(v127) ~= "number" and 0 or v127;
    end;

    if p122 <= 0 then
        p119:SetAttribute("Age", p121);

        if onStep then
            onStep(p121, 1);
        end;

        return true;
    end;

    local v128 = os.clock();

    while not (cancelPredicate and cancelPredicate()) do
        if not p119.Parent then
            return false;
        end;

        local v129 = (os.clock() - v128) / p122;
        local v130 = math.clamp(v129, 0, 1);
        local v131 = TweenService:GetValue(v130, v125, v126);
        local v132 = p120 + (p121 - p120) * v131;
        p119:SetAttribute("Age", v132);

        if onStep then
            onStep(v132, v131);
        end;

        if v130 >= 1 then
            return true;
        end;

        RunService.Heartbeat:Wait();
    end;

    return false;
end;

function v1.TweenModelScale(p133, p134, p135, p136, p137, p138) -- Line: 621
    -- upvalues: TweenService (copy), RunService (copy)
    if not p134 then
        return false;
    end;

    local v139 = p138 or {};
    local v140 = v139.easingStyle or Enum.EasingStyle.Quad;
    local v141 = v139.easingDirection or Enum.EasingDirection.Out;
    local cancelPredicate = v139.cancelPredicate;
    local onStep = v139.onStep;
    local v142 = math.max(p135 == nil and 1 or p135, 0.001);
    local v143 = math.max(p136, 0.001);

    if p137 <= 0 then
        p134:ScaleTo(v143);

        if onStep then
            onStep(v143, 1);
        end;

        return true;
    end;

    local v144 = os.clock();

    while not (cancelPredicate and cancelPredicate()) do
        if not p134.Parent then
            return false;
        end;

        local v145 = (os.clock() - v144) / p137;
        local v146 = math.clamp(v145, 0, 1);
        local v147 = TweenService:GetValue(v146, v140, v141);
        local v148 = v142 + (v143 - v142) * v147;
        p134:ScaleTo(v148);

        if onStep then
            onStep(v148, v147);
        end;

        if v146 >= 1 then
            return true;
        end;

        RunService.Heartbeat:Wait();
    end;

    return false;
end;

function v1.RunBatchedAgeTweens(p149, p150, p151, p152, p153, p154) -- Line: 682
    -- upvalues: GrowEffects (copy), TweenService (copy), RunService (copy)
    if #p150 == 0 then
        return;
    end;

    local v155 = GrowEffects.InitialScale ~= 1;

    if p151 <= 0 then
        for _, v in p150 do
            if v.model and v.model.Parent then
                if v155 then
                    local v156 = v.model:GetScale() - 1;

                    if math.abs(v156) > 0.0001 then
                        v.model:ScaleTo(1);
                    end;
                end;

                v.model:SetAttribute("Age", v.endAge);

                if v155 then
                    local v157 = v.maxAge or 0;

                    if v157 > 0 then
                        local v158 = GrowEffects.GetGrowthScale(v.endAge, v157);

                        if math.abs(v158 - 1) > 0.0001 then
                            v.model:ScaleTo(v158);
                        end;
                    end;
                end;
            end;
        end;

        return;
    end;

    local v159 = os.clock();
    local v160 = 0;

    while true do
        if p154 and p154() then
            return;
        end;

        local v161 = (os.clock() - v159) / p151;
        local v162 = math.clamp(v161, 0, 1);
        local v163 = TweenService:GetValue(v162, p152, p153);
        local v164 = os.clock();
        local v165 = math.min(8, #p150);

        for i = 1, v165 do
            local v166 = p150[(v160 + i - 1) % #p150 + 1];

            if v166.model and v166.model.Parent then
                local v167 = v166.startAge + (v166.endAge - v166.startAge) * v163;

                if v155 then
                    local v168 = v166.model:GetScale() - 1;

                    if math.abs(v168) > 0.0001 then
                        v166.model:ScaleTo(1);
                    end;
                end;

                v166.model:SetAttribute("Age", v167);

                if v155 then
                    local v169 = v166.maxAge or 0;

                    if v169 > 0 then
                        local v170 = GrowEffects.GetGrowthScale(v167, v169);

                        if math.abs(v170 - 1) > 0.0001 then
                            v166.model:ScaleTo(v170);
                        end;
                    end;
                end;
            end;

            if os.clock() - v164 >= 0.004 then
                v165 = i;
                break;
            end;
        end;

        v160 = (v160 + v165) % #p150;

        if v162 >= 1 then
            for _, v in p150 do
                if v.model and v.model.Parent then
                    if v155 then
                        local v171 = v.model:GetScale() - 1;

                        if math.abs(v171) > 0.0001 then
                            v.model:ScaleTo(1);
                        end;
                    end;

                    v.model:SetAttribute("Age", v.endAge);

                    if v155 then
                        local v172 = v.maxAge or 0;

                        if v172 > 0 then
                            local v173 = GrowEffects.GetGrowthScale(v.endAge, v172);

                            if math.abs(v173 - 1) > 0.0001 then
                                v.model:ScaleTo(v173);
                            end;
                        end;
                    end;
                end;
            end;

            return;
        end;

        RunService.Heartbeat:Wait();
    end;
end;

function v1.RunBatchedScaleTweens(p174, u175, p176, p177, p178, p179) -- Line: 789
    -- upvalues: TweenService (copy), RunService (copy)
    if #u175 == 0 then
        return;
    end;

    local v180 = table.create(#u175);

    for i, v in u175 do
        v180[i] = not v.model and 1 or v.model:GetScale();
    end;

    local function settle() -- Line: 803
        -- upvalues: u175 (copy)
        for _, v in u175 do
            if v.model and v.model.Parent then
                v.model:ScaleTo((math.max(v.endScale, 0.001)));
            end;
        end;
    end;

    if p176 <= 0 then
        settle();

        return;
    end;

    local v181 = os.clock();
    local v182 = 0;

    while true do
        if p179 and p179() then
            return;
        end;

        local v183 = (os.clock() - v181) / p176;
        local v184 = math.clamp(v183, 0, 1);
        local v185 = TweenService:GetValue(v184, p177, p178);
        local v186 = os.clock();
        local v187 = math.min(8, #u175);

        for i = 1, v187 do
            local v188 = (v182 + i - 1) % #u175 + 1;
            local v189 = u175[v188];

            if v189.model and v189.model.Parent then
                local v190 = math.lerp(v180[v188], v189.endScale, v185);
                v189.model:ScaleTo((math.max(v190, 0.001)));
            end;

            if os.clock() - v186 >= 0.004 then
                v187 = i;
                break;
            end;
        end;

        v182 = v182 + v187;

        if v184 >= 1 then
            settle();

            return;
        end;

        RunService.RenderStepped:Wait();
    end;
end;

function v1.AnimateOfflineGrowthAge(p191, p192, p193) -- Line: 853
    local v194 = p193.animationDuration or 0;
    local isSkipRequested = p193.isSkipRequested;
    local v195 = {};
    local v196 = {};
    local v197 = {};

    for _, v in p192 do
        if v.model then
            v.model:SetAttribute("Age", v.oldAge or 0);
        end;

        local v198 = v.oldAge or 0;
        local v199 = v.newAge or v198;

        if v.model and v199 - v198 > 0.0001 then
            table.insert(v195, {
                model = v.model,
                startAge = v198,
                endAge = v199,
                maxAge = v.maxAge
            });
        end;

        for _, v2 in v.fruits do
            if v2.model then
                v2.model:SetAttribute("Age", v2.oldAge or 0);
            end;

            local v200 = v2.maxAge or 0;
            local v201 = v2.oldAge or 0;
            local v202 = v2.newAge or v201;

            if v2.model and v202 - v201 > 0.0001 then
                table.insert(v196, {
                    model = v2.model,
                    startAge = v201,
                    endAge = v202,
                    maxAge = v200
                });
            end;

            local foreverEndScale = v2.foreverEndScale;

            if v2.model and foreverEndScale then
                local v203 = v2.model:GetScale();

                if math.abs(foreverEndScale - v203) / math.max(v203, 0.0001) > 0.02 then
                    table.insert(v197, {
                        model = v2.model,
                        endScale = foreverEndScale
                    });
                end;
            end;
        end;
    end;

    local v204 = #v195 > 0;
    local v205 = #v196 > 0;
    local v206 = #v197 > 0;
    local v207 = 0;

    if v204 then
        v207 = v207 + 0.5;
    end;

    if v205 then
        v207 = v207 + 0.5;
    end;

    if v206 then
        v207 = v207 + 0.5;
    end;

    if v207 <= 0 then
        return true;
    end;

    local v208 = v204 and (v194 * (0.5 / v207) or 0) or 0;
    local v209 = v205 and (v194 * (0.5 / v207) or 0) or 0;
    local v210 = v206 and v194 * (0.5 / v207) or 0;

    if v204 then
        p191:RunBatchedAgeTweens(v195, v208, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, isSkipRequested);
    end;

    if isSkipRequested and isSkipRequested() then
        return false;
    end;

    if v205 then
        p191:RunBatchedAgeTweens(v196, v209, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, isSkipRequested);
    end;

    if isSkipRequested and isSkipRequested() then
        return false;
    end;

    if v206 then
        p191:RunBatchedScaleTweens(v197, v210, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, isSkipRequested);
    end;

    return true;
end;

function v1.PlayOfflineCutscene(u211, p212) -- Line: 968
    -- upvalues: LocalPlayer (copy), UserInputService (copy), TweenService (copy), CollectionService (copy), HapticService (copy), RunService (copy), ContextActionService (copy), LightingController (copy)
    local oldPlants = p212.oldPlants;
    local newPlants = p212.newPlants;
    local effectiveGrowthTime = p212.effectiveGrowthTime;
    local actualOfflineTime = p212.actualOfflineTime;
    local getSpawnPoint = p212.getSpawnPoint;
    local getSpawnedPlant = p212.getSpawnedPlant;
    local getPlantGrowthData = p212.getPlantGrowthData;
    local isSingleHarvestPlant = p212.isSingleHarvestPlant;
    local addPlantHarvestPrompt = p212.addPlantHarvestPrompt;
    local getSpawnedFruit = p212.getSpawnedFruit;
    local getFruitGrowthData = p212.getFruitGrowthData;
    local addFruitHarvestPrompt = p212.addFruitHarvestPrompt;
    local v213 = p212.skipCamera == true;
    local v214 = p212.skipUI == true;
    local v215 = p212.skipLighting == true;
    local v216 = p212.skipMusicDuck == true;
    local v217 = p212.tweenCameraRestore == true;
    local v218 = p212.skipSFX == true;
    local v219 = p212.outlineGrowthPlants == true;
    local u220 = p212.targetUserId or LocalPlayer.UserId;
    local v221 = u220 == LocalPlayer.UserId;

    if v221 then
        LocalPlayer:SetAttribute("OfflineCutscenePlaying", true);

        if not v214 then
            LocalPlayer:SetAttribute("CutsceneInputBlocked", true);
        end;
    end;

    local u222, u223 = u211:BuildGrowthChanges(oldPlants, newPlants);

    if #u222 == 0 then
        if v221 then
            LocalPlayer:SetAttribute("OfflineCutscenePlaying", false);
            LocalPlayer:SetAttribute("CutsceneInputBlocked", false);
        end;

        return true;
    end;

    local u224 = {};

    if v219 then
        for _, v in u222 do
            if v.model and v.model.Parent then
                local Highlight = Instance.new("Highlight");
                Highlight.Name = "GrowthOutline";
                Highlight.Adornee = v.model;
                Highlight.FillColor = Color3.fromRGB(120, 255, 120);
                Highlight.FillTransparency = 0.6;
                Highlight.OutlineColor = Color3.fromRGB(180, 255, 180);
                Highlight.OutlineTransparency = 0;
                Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
                Highlight.Parent = v.model;
                table.insert(u224, Highlight);
            end;
        end;
    end;

    local function clearGrowthHighlights() -- Line: 1054
        -- upvalues: u224 (copy)
        for _, v in u224 do
            if v and v.Parent then
                v:Destroy();
            end;
        end;

        table.clear(u224);
    end;

    if not u211:WaitForGrowthVisualsReady(u220, u222, getSpawnedPlant, getPlantGrowthData, getSpawnedFruit, getFruitGrowthData) then
        clearGrowthHighlights();

        if v221 then
            LocalPlayer:SetAttribute("OfflineCutscenePlaying", false);
            LocalPlayer:SetAttribute("CutsceneInputBlocked", false);
        end;

        return false;
    end;

    local OfflineAnimation = LocalPlayer.PlayerGui:WaitForChild("OfflineAnimation");

    if not v214 then
        local BottomBar = OfflineAnimation.BottomBar;
        local TopBar = OfflineAnimation.TopBar;
        BottomBar.AnchorPoint = Vector2.new(0, 0);
        BottomBar.Size = UDim2.new(1, 0, 0.141, 0);
        BottomBar.BackgroundTransparency = 0;
        TopBar.AnchorPoint = Vector2.new(0, 1);
        TopBar.Size = UDim2.new(1, 0, 0.141, 0);
        TopBar.BackgroundTransparency = 0;
        local Date = BottomBar:FindFirstChild("Date");
        local Time = BottomBar:FindFirstChild("Time");
        local HTSLabel = BottomBar:FindFirstChild("HTSLabel");
        local Title = TopBar:FindFirstChild("Title");

        if Date then
            Date.Visible = true;
        end;

        if Time then
            Time.Visible = true;
        end;

        if HTSLabel and HTSLabel:IsA("TextLabel") then
            HTSLabel.Visible = true;
            local v225 = UserInputService:GetLastInputType();

            if (v225 == Enum.UserInputType.Gamepad1 or (v225 == Enum.UserInputType.Gamepad2 or v225 == Enum.UserInputType.Gamepad3)) and true or v225 == Enum.UserInputType.Gamepad4 then
                HTSLabel.Text = `Hold ({UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA):find("Cross", 1, true) ~= nil and "X" or "A"}) to skip`;
            else
                HTSLabel.Text = "Hold to skip";
            end;
        end;

        if Title then
            Title.Visible = true;
        end;

        task.wait(0.5);
        TweenService:Create(OfflineAnimation.BottomBar, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            AnchorPoint = Vector2.new(0, 1)
        }):Play();
        TweenService:Create(OfflineAnimation.TopBar, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            AnchorPoint = Vector2.new(0, 0)
        }):Play();
    end;

    local u226 = u211:CalculateCutsceneDuration(u222);
    local CurrentCamera = workspace.CurrentCamera;
    local CameraType = CurrentCamera.CameraType;
    local CameraSubject = CurrentCamera.CameraSubject;
    local CFrame2 = CurrentCamera.CFrame;
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local v227;

    if Character and Character:IsA("BasePart") then
        v227 = Character.CFrame;
    else
        v227 = nil;
    end;

    local v228 = getSpawnPoint(u220);

    if not v228 then
        if not v214 then
            TweenService:Create(OfflineAnimation.BottomBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            }):Play();
            TweenService:Create(OfflineAnimation.TopBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            }):Play();
        end;

        clearGrowthHighlights();

        if v221 then
            LocalPlayer:SetAttribute("OfflineCutscenePlaying", false);
            LocalPlayer:SetAttribute("CutsceneInputBlocked", false);
        end;

        return false;
    end;

    local v229 = nil;
    local v230;

    if v228 and not v213 then
        v230 = v228.Parent:FindFirstChild("Signs");

        if v230 then
            v230.Parent = nil;
        else
            v230 = v229;
        end;
    else
        v230 = v229;
    end;

    local u231 = {};
    local u232 = {};
    local u233 = {};

    local function setBillboardEnabledSilently(p234, p235) -- Line: 1189
        -- upvalues: u233 (copy)
        if p234.Enabled == p235 then
            return;
        end;

        u233[p234] = true;
        p234.Enabled = p235;
    end;

    local function trackOverheadBillboard(u236) -- Line: 1195
        -- upvalues: u231 (copy), LocalPlayer (ref), u233 (copy), u232 (copy)
        if u231[u236] ~= nil then
            return;
        end;

        if not u236:IsDescendantOf(LocalPlayer.PlayerGui) then
            return;
        end;

        u231[u236] = u236.Enabled;

        if u236.Enabled ~= false then
            u233[u236] = true;
            u236.Enabled = false;
        end;

        u232[u236] = u236:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 1202
            -- upvalues: u233 (ref), u236 (copy), u231 (ref)
            if u233[u236] then
                u233[u236] = nil;

                return;
            end;

            u231[u236] = u236.Enabled;

            if u236.Enabled then
                local v237 = u236;

                if v237.Enabled == false then
                    return;
                end;

                u233[v237] = true;
                v237.Enabled = false;
            end;
        end);
    end;

    local v238;

    if v213 then
        v238 = nil;
    else
        for _, v in CollectionService:GetTagged("OverheadUITag") do
            if v:IsA("BillboardGui") then
                trackOverheadBillboard(v);
            end;
        end;

        v238 = CollectionService:GetInstanceAddedSignal("OverheadUITag"):Connect(function(p239) -- Line: 1223
            -- upvalues: trackOverheadBillboard (copy)
            if p239:IsA("BillboardGui") then
                trackOverheadBillboard(p239);
            end;
        end);
    end;

    local Date = OfflineAnimation.BottomBar:FindFirstChild("Date");
    local Time = OfflineAnimation.BottomBar:FindFirstChild("Time");
    local Title = OfflineAnimation.TopBar:FindFirstChild("Title");

    if Title and Title:IsA("TextLabel") then
        Title.Text = p212.titleOverride or "Your garden grew while you were away...";
    end;

    local StarterGui = game:GetService("StarterGui");
    local v240 = {};

    if not v214 then
        for _, child in LocalPlayer.PlayerGui:GetChildren() do
            if child:IsA("ScreenGui") and child.Name ~= "OfflineAnimation" then
                v240[child] = child.Enabled;
                child.Enabled = false;
            end;
        end;

        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
    end;

    local v241 = os.time() - actualOfflineTime;
    local v242 = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" };
    local u243, v244, v245, u246, v247;

    if v213 then
        u243 = nil;
        v244 = nil;
        v245 = nil;
        u246 = nil;
        v247 = nil;
    else
        v244 = 4.2;
        local u248 = 20;
        local u249 = 200;
        local u250 = 1.3;
        local u251 = 1.8;
        local u252 = 0.075;
        local u253 = 0.55;
        local u254 = 1.25;
        local u255 = 2.2;
        local u256 = 2.4;
        local u257 = 2.1;
        local u258 = 2;
        local u259 = 18;
        local u260 = 2;
        local u261 = 7;
        local LookVector = v228.CFrame.LookVector;
        local v262 = Vector3.new(LookVector.X, 0, LookVector.Z);
        u246 = (v262.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v262).Unit;
        local Unit = u246:Cross(Vector3.new(0, 1, 0)).Unit;
        local Position = v228.Position;
        u243 = Position + u246 * 10;
        local u263 = 0;
        local u264 = 24;
        local u265 = {};
        local u266 = 0;

        local function smoothAlpha(p267, p268) -- Line: 1319
            local v269 = math.max(p268, 0.016666666666666666);

            return 1 - math.exp(-p267 * v269);
        end;

        v245 = function(p270, p271, p272, p273) -- Line: 1324
            -- upvalues: u266 (ref), u223 (copy), getSpawnedPlant (copy), u220 (copy), Position (copy), u265 (copy), Unit (ref), u246 (ref), u250 (ref), u248 (ref), u249 (ref), u243 (ref), u255 (ref), u263 (ref), u257 (ref), u264 (ref), u256 (ref), u253 (ref), u252 (ref), u254 (ref), u260 (ref), u261 (ref), u258 (ref), u259 (ref), u251 (ref)
            u266 = u266 + 1;
            local v274 = u266 <= 1 and true or u266 % 10 == 0;
            local v275 = -1;
            local v276 = (1 / 0);
            local v277 = (-1 / 0);
            local v278 = (1 / 0);
            local v279 = (-1 / 0);
            local v280 = (1 / 0);
            local v281 = (-1 / 0);
            local v282 = 0;
            local v283 = 0;
            local v284 = nil;

            for i, v in u223 do
                local plant = v.plant;
                local u285 = getSpawnedPlant(u220, i);

                if u285 and u285.Parent then
                    if v274 then
                        local v286, v287, v288 = pcall(function() -- Line: 1346
                            -- upvalues: u285 (copy)
                            return u285:GetBoundingBox();
                        end);

                        if v286 and (v287 and v288) and ((v287.Position - Position).Magnitude <= 200 and v288.Magnitude <= 400) then
                            local v289 = u285:GetScale();
                            local v290 = math.max(v289, 0.001);

                            if v290 < 1 then
                                v288 = v288 / v290;
                            end;

                            u265[i] = {
                                cframe = v287,
                                size = v288
                            };
                        end;
                    end;

                    local v291 = u265[i];

                    if v291 then
                        local v292 = math.max(plant.newAge - plant.oldAge, 0);

                        for _, v2 in plant.fruits do
                            v292 = v292 + math.max(v2.newAge - v2.oldAge, 0);
                        end;

                        local Position2 = v291.cframe.Position;
                        local v293 = v291.size * 0.5;
                        local v294 = Position2 - Position;
                        local v295 = v294:Dot(Unit);
                        local v296 = v294:Dot(u246);
                        local v297 = math.abs(Unit.X) * v293.X + math.abs(Unit.Z) * v293.Z;
                        local v298 = math.abs(u246.X) * v293.X + math.abs(u246.Z) * v293.Z;
                        v276 = math.min(v276, v295 - v297);
                        v277 = math.max(v277, v295 + v297);
                        v278 = math.min(v278, v296 - v298);
                        v279 = math.max(v279, v296 + v298);
                        v280 = math.min(v280, Position2.Y - v293.Y);
                        v281 = math.max(v281, Position2.Y + v293.Y);
                        v282 = v282 + 1;
                        v283 = math.max(v283, v291.size.Y * 0.35);

                        if v275 < v292 then
                            v284 = {
                                pos = Position2,
                                size = v291.size,
                                radius = v291.size.Magnitude * 0.5,
                                growth = v292
                            };
                            v275 = v292;
                        end;
                    end;
                end;
            end;

            local v299 = Position + u246 * 10;
            local v300;

            if v282 > 0 then
                v299 = Position + Unit * ((v276 + v277) * 0.5) + u246 * ((v278 + v279) * 0.5) + Vector3.new(0, (v280 + v281) * 0.5 - Position.Y, 0);
                local CurrentCamera2 = workspace.CurrentCamera;
                local v301 = math.rad(CurrentCamera2.FieldOfView * 0.5);
                local v302 = CurrentCamera2.ViewportSize.X / math.max(CurrentCamera2.ViewportSize.Y, 1);
                local v303 = math.tan(v301) * v302;
                local v304 = math.atan(v303);
                local v305 = math.max(v304, 0.1);
                local v306 = (v277 - v276) * 0.5 / math.tan(v305);
                local v307 = math.max(v301, 0.1);
                local v308 = (v281 - v280) * 0.5 / math.tan(v307);
                local v309 = (math.max(v306, v308, 5) + (v279 - v278) * 0.5) * u250;
                v300 = math.clamp(v309, u248, u249);
            else
                v300 = u248;
            end;

            local v310;

            if v284 then
                v310 = v284.pos or v299;
            else
                v310 = v299;
            end;

            local v311 = v299:Lerp(v310, (1 - math.abs(0.5 - p271) * 2) * 0.15 + 0.15);
            local v312 = math.max(p273, 0.016666666666666666);
            u243 = u243:Lerp(v311, 1 - math.exp(-u255 * v312));
            local v313 = math.max(p273, 0.016666666666666666);
            u263 = u263 + (v283 - u263) * (1 - math.exp(-u257 * v313));
            local v314 = math.max(p273, 0.016666666666666666);
            u264 = u264 + (v300 - u264) * (1 - math.exp(-u256 * v314));
            local v315 = math.sin(p272 * u253) * u252;
            local Unit2 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v315):VectorToWorldSpace(u246).Unit;
            local v316 = Unit * (math.sin(p272 * u253 * 0.6) * u254);
            local v317 = math.clamp(u260 + (u261 - u260) * p270 + u263 * 0.12, u258, u259);
            local v318 = math.clamp(u251 - u263 * 0.08, 0.35, u251);
            local v319 = u243 - Unit2 * u264 + Vector3.new(0, v317, 0) + v316;
            local v320 = u243 + Vector3.new(0, v318, 0);

            return CFrame.new(v319, v320);
        end;

        CurrentCamera.CameraType = Enum.CameraType.Scriptable;
        v247 = v245(0, 0, 0, 0.016666666666666666);
        CurrentCamera.CFrame = v247;
    end;

    local Lighting = game:GetService("Lighting");
    local ClockTime = Lighting.ClockTime;
    local v321 = math.min(actualOfflineTime / 3600, 120);
    u211:ZeroAllPlantAndFruitAges(u220, u222, getSpawnedPlant, getPlantGrowthData, getSpawnedFruit, getFruitGrowthData);
    u211:AttachModelsToGrowthChanges(u220, u222, getSpawnedPlant, getSpawnedFruit);
    local v322 = u211:ClassifyGrowthIntensity(u222);
    local v323 = v216 and {} or u211:DuckMusic();
    local u324;

    if v218 then
        u324 = nil;
    else
        u324 = u211:StartGrowthSound(v322);
    end;

    local v325 = os.clock();

    local function clearHaptic() -- Line: 1492
        -- upvalues: HapticService (ref)
        pcall(function() -- Line: 1493
            -- upvalues: HapticService (ref)
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0);
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0);
        end);
    end;

    local u326;

    if u324 then
        u326 = true;
        task.spawn(function() -- Line: 1501
            -- upvalues: HapticService (ref), u326 (ref), u324 (copy), RunService (ref)
            local v327 = 0;
            local v328 = (-1 / 0);
            local v329 = os.clock();
            local v330 = 0;
            local u331 = false;
            local u332 = false;
            pcall(function() -- Line: 1513
                -- upvalues: u331 (ref), HapticService (ref), u332 (ref)
                u331 = HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small);
                u332 = HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large);
            end);

            while u326 and (u324 and u324.IsPlaying) do
                local v333 = os.clock();
                math.max(v333 - v329, 0.004166666666666667);
                local PlaybackLoudness = u324.PlaybackLoudness;

                if v330 < PlaybackLoudness then
                    v330 = PlaybackLoudness;
                end;

                local v334 = math.clamp(PlaybackLoudness / 10, 0, 1) ^ 5;

                if v334 >= 0.05 and v333 - v328 >= 0.3 then
                    v327 = math.clamp(v334 * 2, 0, 1);
                    v328 = v333;
                end;

                local v335 = v327 * math.exp(-(v333 - v328) * 8) * 0.6;
                local u336 = math.min(v335, 0.6);

                if u331 then
                    pcall(function() -- Line: 1547
                        -- upvalues: HapticService (ref), u336 (copy)
                        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, u336);
                    end);
                end;

                if u332 then
                    pcall(function() -- Line: 1552
                        -- upvalues: HapticService (ref), u336 (copy)
                        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, u336 * 0.4);
                    end);
                end;

                if v328 == v333 then
                    local u337 = math.clamp(v327 * 0.6 * 1.5, 0, 1);
                    task.spawn(function() -- Line: 1561
                        -- upvalues: u337 (copy)
                        local success, result = pcall(function() -- Line: 1562
                            -- upvalues: u337 (ref)
                            local HapticEffect = Instance.new("HapticEffect");
                            HapticEffect.Type = Enum.HapticEffectType.Custom;
                            HapticEffect:SetWaveformKeys({ FloatCurveKey.new(0, 0, Enum.KeyInterpolationMode.Linear), FloatCurveKey.new(27.5, u337, Enum.KeyInterpolationMode.Linear), FloatCurveKey.new(110, 0, Enum.KeyInterpolationMode.Linear) });
                            HapticEffect.Parent = workspace;

                            return HapticEffect;
                        end);

                        if success and result then
                            result.Ended:Connect(function() -- Line: 1574
                                -- upvalues: result (copy)
                                result:Destroy();
                            end);
                            pcall(function() -- Line: 1577
                                -- upvalues: result (copy)
                                result:Play();
                            end);
                        end;
                    end);
                end;

                RunService.Heartbeat:Wait();
                v329 = v333;
            end;

            pcall(function() -- Line: 1493
                -- upvalues: HapticService (ref)
                HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0);
                HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0);
            end);
        end);
    end;

    local v338 = 0;
    local u339 = 0;
    local u340 = 0;
    local u341 = false;
    local u342 = false;
    local u343 = nil;
    local u344 = false;
    local v345 = {};
    local v346, u347;

    if v214 then
        v346 = false;
        u347 = nil;
    else
        u347 = Instance.new("Frame");
        u347.Name = "HoldProgressBar";
        u347.AnchorPoint = Vector2.new(0, 0);
        u347.Position = UDim2.new(0, 0, 0, 0);
        u347.Size = UDim2.new(0, 0, 0, 4);
        u347.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        u347.BackgroundTransparency = 0.2;
        u347.BorderSizePixel = 0;
        u347.ZIndex = OfflineAnimation.BottomBar.ZIndex + 1;
        u347.Parent = OfflineAnimation.BottomBar;

        local function beginHold() -- Line: 1633
            -- upvalues: u343 (ref)
            u343 = os.clock();
        end;

        local function endHold() -- Line: 1637
            -- upvalues: u343 (ref), u347 (ref), TweenService (ref)
            u343 = nil;

            if u347 then
                TweenService:Create(u347, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 0, 0, 4)
                }):Play();
            end;
        end;

        local function isHoldInput(p348) -- Line: 1645
            return p348.UserInputType == Enum.UserInputType.MouseButton1 and true or p348.UserInputType == Enum.UserInputType.Touch;
        end;

        table.insert(v345, UserInputService.InputBegan:Connect(function(p349, p350) -- Line: 1650
            -- upvalues: u343 (ref)
            if p349.UserInputType == Enum.UserInputType.MouseButton1 and true or p349.UserInputType == Enum.UserInputType.Touch then
                u343 = os.clock();
            end;
        end));
        table.insert(v345, UserInputService.InputEnded:Connect(function(p351, p352) -- Line: 1656
            -- upvalues: endHold (copy)
            if p351.UserInputType == Enum.UserInputType.MouseButton1 and true or p351.UserInputType == Enum.UserInputType.Touch then
                endHold();
            end;
        end));
        ContextActionService:BindActionAtPriority("OfflineCutsceneSkipHold", function(p353, p354, p355) -- Line: 1667
            -- upvalues: u343 (ref), endHold (copy)
            if p354 == Enum.UserInputState.Begin then
                u343 = os.clock();
            elseif p354 == Enum.UserInputState.End or p354 == Enum.UserInputState.Cancel then
                endHold();
            end;

            return Enum.ContextActionResult.Pass;
        end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.ButtonA, Enum.KeyCode.ButtonR2);
        v346 = true;
    end;

    task.spawn(function() -- Line: 1683
        -- upvalues: u211 (copy), u222 (copy), effectiveGrowthTime (copy), actualOfflineTime (copy), u226 (copy), u223 (copy), u340 (ref), u339 (ref), u344 (ref), u342 (ref), u341 (ref)
        local success, result = pcall(function() -- Line: 1684
            -- upvalues: u211 (ref), u222 (ref), effectiveGrowthTime (ref), actualOfflineTime (ref), u226 (ref), u223 (ref), u340 (ref), u339 (ref), u344 (ref)
            return u211:AnimateOfflineGrowthAge(u222, {
                effectiveGrowthTime = effectiveGrowthTime,
                actualOfflineTime = actualOfflineTime,
                animationDuration = u226,
                changesByPlantId = u223,

                getAlpha = function() -- Line: 1690, Name: getAlpha
                    -- upvalues: u340 (ref)
                    return u340;
                end,

                getRawAlpha = function() -- Line: 1691, Name: getRawAlpha
                    -- upvalues: u339 (ref)
                    return u339;
                end,

                isSkipRequested = function() -- Line: 1692, Name: isSkipRequested
                    -- upvalues: u344 (ref)
                    return u344;
                end
            });
        end);

        if success then
            u342 = result == true;
        else
            u342 = false;
        end;

        u341 = true;
    end);

    while true do
        local v356 = os.clock() - v325;
        u339 = math.clamp(v356 / u226, 0, 1);
        u340 = u339 < 0.5 and u339 * 2 * u339 or 1 - (u339 * -2 + 2) ^ 3 / 2;

        if not v215 then
            Lighting.ClockTime = (ClockTime + v321 * u340) % 24;
        end;

        if u324 and u324.IsPlaying then
            u324.Volume = u339 ^ 1.6 * 2.25 + 0.35;
        end;

        if not v214 then
            if Date and Time then
                local v357 = os.date("*t", v241 + actualOfflineTime * u340);
                local day = v357.day;
                Date.Text = string.format("%s %d%s %d", v242[v357.month], v357.day, (day == 1 or (day == 21 or day == 31)) and "st" or ((day == 2 or day == 22) and "nd" or ((day == 3 or day == 23) and "rd" or "th")), v357.year);
                local v358 = v357.hour % 12;
                Time.Text = string.format("%d:%02d %s", v358 == 0 and 12 or v358, v357.min, v357.hour >= 12 and "PM" or "AM");
            end;

            for i in v240 do
                if i:IsA("ScreenGui") then
                    i.Enabled = false;
                end;
            end;
        end;

        if not v213 then
            CurrentCamera.CameraType = Enum.CameraType.Scriptable;
            v247 = v247:Lerp(v245(u340, u339, v356, v338), (math.clamp(v244 * ((1 - u339) * 0.45 + 0.55) * v338, 0, 0.12)));
            CurrentCamera.CFrame = v247;
        end;

        if not v214 and u343 then
            local v359 = (os.clock() - u343) / 1;
            local v360 = math.clamp(v359, 0, 1);

            if u347 then
                u347.Size = UDim2.new(v360, 0, 0, 4);
            end;

            u344 = v360 >= 1 and true or u344;
        end;

        if u344 or u341 and (u342 and u226 <= v356) then
            break;
        end;

        v338 = RunService.Heartbeat:Wait();
    end;

    for _, v in v345 do
        v:Disconnect();
    end;

    if v346 then
        ContextActionService:UnbindAction("OfflineCutsceneSkipHold");
    end;

    u326 = false;
    pcall(function() -- Line: 1493
        -- upvalues: HapticService (ref)
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0);
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0);
    end);

    if u344 then
        u211:StopGrowthSound(u324, 0);
        u211:RestoreMusic(v323, 0.3);
    else
        u211:StopGrowthSound(u324, 1.5);
        u211:RestoreMusic(v323, 1.5);
    end;

    if u347 then
        u347:Destroy();
    end;

    if not (v213 or u344) then
        local v361 = os.clock();

        while os.clock() - v361 < 2 do
            local v362 = (os.clock() - v361) / 2;
            local v363 = math.clamp(v362, 0, 1);
            TweenService:GetValue(v363, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
            local v364 = v245(1, 1, os.clock() - v325, v338);
            v247 = v247:Lerp(v364:Lerp(CFrame.new(v364.Position + Vector3.new(0, -1.25, 0) + u246 * 2, u243 + Vector3.new(0, 0.55, 0)), v363), (math.clamp(3.2 * v338, 0, 0.1)));
            CurrentCamera.CFrame = v247;
            v338 = RunService.Heartbeat:Wait();
        end;
    end;

    if v230 then
        v230.Parent = v228.Parent;
    end;

    if v238 then
        v238:Disconnect();
    end;

    for i, v in u231 do
        local v365 = u232[i];

        if v365 then
            v365:Disconnect();
            u232[i] = nil;
        end;

        u233[i] = nil;

        if i.Parent then
            i.Enabled = v;
        end;
    end;

    table.clear(u231);

    if not v214 then
        if Date then
            Date.Visible = false;
        end;

        if Time then
            Time.Visible = false;
        end;

        if Title then
            Title.Visible = false;
        end;

        local HTSLabel = OfflineAnimation.BottomBar:FindFirstChild("HTSLabel");

        if HTSLabel then
            HTSLabel.Visible = false;
        end;

        TweenService:Create(OfflineAnimation.BottomBar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(1, 0.5)
        }):Play();
        TweenService:Create(OfflineAnimation.TopBar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(1, 0.5)
        }):Play();
        task.wait(0.5);
    end;

    if not v215 then
        LightingController:SetImmediate({
            ClockTime = LightingController:GetCurrentTarget().ClockTime
        });
    end;

    if not v214 then
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true);
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);

        if LocalPlayer:GetAttribute("CustomChatActive") then
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false);
        end;

        for i, v in v240 do
            i.Enabled = v;
        end;
    end;

    if not u341 then
        while not u341 do
            RunService.Heartbeat:Wait();
        end;
    end;

    u211:ApplyFinalGrowthState(u220, u222, getSpawnedPlant, getPlantGrowthData, isSingleHarvestPlant, addPlantHarvestPrompt, getSpawnedFruit, getFruitGrowthData, addFruitHarvestPrompt);

    if not v213 then
        if v217 then
            local CFrame3 = CurrentCamera.CFrame;
            local u366;

            if v227 then
                u366 = v227:ToObjectSpace(CFrame2);
            else
                u366 = nil;
            end;

            local function getLiveTarget() -- Line: 1920
                -- upvalues: LocalPlayer (ref), u366 (copy), CFrame2 (copy)
                local Character2 = LocalPlayer.Character;

                if Character2 then
                    Character2 = Character2:FindFirstChild("HumanoidRootPart");
                end;

                if Character2 and (Character2:IsA("BasePart") and u366) then
                    return Character2.CFrame * u366;
                end;

                return CFrame2;
            end;

            local v367 = os.clock();

            while true do
                local v368 = (os.clock() - v367) / 0.3;
                local v369 = math.clamp(v368, 0, 1);
                local v370 = TweenService:GetValue(v369, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                local Character2 = LocalPlayer.Character;

                if Character2 then
                    Character2 = Character2:FindFirstChild("HumanoidRootPart");
                end;

                local v371;

                if Character2 and (Character2:IsA("BasePart") and u366) then
                    v371 = Character2.CFrame * u366;
                else
                    v371 = CFrame2;
                end;

                CurrentCamera.CFrame = CFrame3:Lerp(v371, v370);

                if v369 >= 1 then
                    break;
                end;

                RunService.Heartbeat:Wait();
            end;

            CurrentCamera.CameraType = CameraType;
            CurrentCamera.CameraSubject = CameraSubject;
        else
            CurrentCamera.CameraType = CameraType;
            CurrentCamera.CameraSubject = CameraSubject;
            CurrentCamera.CFrame = CFrame2;
        end;
    end;

    if not v214 then
        TweenService:Create(OfflineAnimation.BottomBar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        }):Play();
        TweenService:Create(OfflineAnimation.TopBar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        }):Play();
    end;

    clearGrowthHighlights();

    if v221 then
        LocalPlayer:SetAttribute("OfflineCutscenePlaying", false);
        LocalPlayer:SetAttribute("CutsceneInputBlocked", false);
    end;

    return true;
end;

return v1;