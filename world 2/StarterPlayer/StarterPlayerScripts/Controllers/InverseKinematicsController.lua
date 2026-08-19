-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local EffectLoadManager = require(game.ReplicatedStorage.SharedModules.EffectLoadManager);
local v1 = {};
local u2 = {};
local u3 = {};
local u4 = 0;
local u5 = false;

local function profileBegin(p6) -- Line: 24
    debug.profilebegin("Controllers/InverseKinematicsController/" .. p6);
end;

local function profileEnd() -- Line: 28
    debug.profileend();
end;

local function getGardenOwner(p7) -- Line: 32
    local v8 = p7 and p7.Parent and p7.Parent.Parent;

    if v8 then
        return v8:GetAttribute("Owner");
    end;

    return nil;
end;

local function isOwner(p9, p10) -- Line: 40
    local v11 = p10 and p10.Parent and p10.Parent.Parent;
    local v12;

    if v11 then
        v12 = v11:GetAttribute("Owner");
    else
        v12 = nil;
    end;

    if v12 then
        return p9.Name == v12 and true or tostring(p9.UserId) == v12;
    end;

    return false;
end;

local function unregisterPlant(p13) -- Line: 46
    -- upvalues: u3 (copy), u2 (copy)
    local v14 = u3[p13];

    if not v14 then
        return;
    end;

    u3[p13] = nil;
    u2[p13] = nil;

    if v14.jawValue then
        v14.jawValue:Destroy();
    end;

    if v14.lungeValue then
        v14.lungeValue:Destroy();
    end;
end;

local function updateRegisteredPlant(p15, p16) -- Line: 55
    -- upvalues: u3 (copy), u2 (copy), Players (copy)
    if not p15.Parent then
        local v17 = u3[p15];

        if not v17 then
            return;
        end;

        u3[p15] = nil;
        u2[p15] = nil;

        if v17.jawValue then
            v17.jawValue:Destroy();
        end;

        if v17.lungeValue then
            v17.lungeValue:Destroy();
        end;

        return;
    end;

    debug.profilebegin("Controllers/InverseKinematicsController/Update");
    local basePart = p16.basePart;
    local topPart = p16.topPart;
    local chain = p16.chain;
    local attachmentData = p16.attachmentData;
    local baseData = p16.baseData;
    local topJawData = p16.topJawData;
    local bottomJawData = p16.bottomJawData;
    local topJawPivot = p16.topJawPivot;
    local bottomJawPivot = p16.bottomJawPivot;
    local jawValue = p16.jawValue;
    local lungeValue = p16.lungeValue;
    local v18 = os.clock();
    local Value = lungeValue.Value;
    local v19 = math.sin(v18 * 1.5) * 0.03 + math.sin(v18 * 3.1) * 0.01;
    local Position = basePart.Position;
    debug.profilebegin("Controllers/InverseKinematicsController/Update/scanPlayers");
    local v20 = (1 / 0);
    local v21 = nil;

    for _, v in Players:GetPlayers() do
        local v22 = p15 and p15.Parent and p15.Parent.Parent;
        local v23;

        if v22 then
            v23 = v22:GetAttribute("Owner");
        else
            v23 = nil;
        end;

        local v24;

        if v23 then
            v24 = v.Name == v23 and true or tostring(v.UserId) == v23;
        else
            v24 = false;
        end;

        if not v24 then
            local Character = v.Character;

            if Character then
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                if HumanoidRootPart then
                    local Magnitude = (HumanoidRootPart.Position - Position).Magnitude;

                    if Magnitude < v20 then
                        v21 = HumanoidRootPart;
                        v20 = Magnitude;
                    end;
                end;
            end;
        end;
    end;

    debug.profileend();

    if v21 and v20 <= 15 then
        local v25 = v21.Position - Position;
        local v26 = Vector3.new(v25.X, 0, v25.Z);

        if v26.Magnitude > 0.1 then
            local v27 = math.atan2(-v26.X, -v26.Z);
            local _, v28, _ = basePart.CFrame:ToEulerAnglesYXZ();
            basePart.CFrame = CFrame.new(Position) * CFrame.Angles(0, v28 + ((v27 - v28 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * 0.08, 0);
        end;
    elseif p15:FindFirstChildOfClass("Highlight") == nil then
        local _, v29, _ = basePart.CFrame:ToEulerAnglesYXZ();
        local v30 = (p16.originalBaseAngle - v29 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793;

        if math.abs(v30) > 0.001 then
            basePart.CFrame = CFrame.new(Position) * CFrame.Angles(0, v29 + v30 * 0.05, 0);
        end;
    end;

    debug.profilebegin("Controllers/InverseKinematicsController/Update/computeSwayChain");
    local v31 = { basePart.CFrame };
    local CFrame2 = basePart.CFrame;

    for i, v in chain do
        CFrame2 = CFrame2 * v.restOffset * CFrame.Angles(v19, 0, 0);
        v31[i + 1] = CFrame2;
    end;

    debug.profileend();
    local Position2 = (v31[#v31] * CFrame.new(0, chain[#chain].part.Size.Y / 2, 0)).Position;
    local v32 = Vector3.new(0, 1, 0);
    local v33 = 0;
    local v34 = p15:GetAttribute("LungeTarget");

    if Value > 0.001 and v34 then
        local Position3 = basePart.Position;
        local v35 = Position2 - Position3;
        local v36 = v34 - Position3;

        if v35.Magnitude > 0.01 and v36.Magnitude > 0.01 then
            local Unit = v35.Unit;
            local Unit2 = v36.Unit;
            local v37 = Unit:Cross(Unit2);

            if v37.Magnitude > 0.0001 then
                v32 = v37.Unit;
                local v38 = Unit:Dot(Unit2);
                local v39 = math.clamp(v38, -1, 1);
                v33 = math.acos(v39) * Value / #chain;
            end;
        end;
    end;

    debug.profilebegin("Controllers/InverseKinematicsController/Update/rebuildChain");
    local CFrame3 = basePart.CFrame;
    local v40 = CFrame.fromAxisAngle(v32, v33);

    for _, v in chain do
        CFrame3 = CFrame3 * v.restOffset * CFrame.Angles(v19, 0, 0);

        if v33 > 0.0001 then
            local v41 = v40 * (CFrame3 - CFrame3.Position);
            CFrame3 = CFrame.new(CFrame3.Position) * v41;
        end;

        v.part.CFrame = CFrame3;
    end;

    debug.profileend();
    debug.profilebegin("Controllers/InverseKinematicsController/Update/updateAttachments");

    for _, v in attachmentData do
        v.part.CFrame = v.parent.CFrame * v.offset;
    end;

    debug.profileend();
    debug.profilebegin("Controllers/InverseKinematicsController/Update/updateHeadBase");

    for _, v in baseData do
        v.part.CFrame = topPart.CFrame * v.offset;
    end;

    debug.profileend();
    local v42 = jawValue.Value * 0.45;

    if topJawPivot then
        local v43 = topPart.CFrame * topJawPivot * CFrame.Angles(0, 0, v42);

        for _, v in topJawData do
            v.part.CFrame = v43 * v.offset;
        end;
    end;

    if bottomJawPivot then
        local v44 = topPart.CFrame * bottomJawPivot * CFrame.Angles(0, 0, -v42);

        for _, v in bottomJawData do
            v.part.CFrame = v44 * v.offset;
        end;
    end;

    debug.profileend();
end;

local function ensureSharedHeartbeat() -- Line: 228
    -- upvalues: u5 (ref), RunService (copy), u4 (ref), u3 (copy), EffectLoadManager (copy), updateRegisteredPlant (copy)
    if u5 then
        return;
    end;

    u5 = true;
    RunService.Heartbeat:Connect(function(p45) -- Line: 232
        -- upvalues: u4 (ref), u3 (ref), EffectLoadManager (ref), updateRegisteredPlant (ref)
        u4 = u4 + p45;

        if u4 < 0.15 then
            return;
        end;

        u4 = 0;
        debug.profilebegin("Controllers/InverseKinematicsController/SharedHeartbeat");

        for i, v in u3 do
            if EffectLoadManager.ShouldAnimateInstance(i, 80) then
                updateRegisteredPlant(i, v);
            end;
        end;

        debug.profileend();
    end);
end;

function v1.Init(p46) -- Line: 248
    -- upvalues: u5 (ref), RunService (copy), u4 (ref), u3 (copy), EffectLoadManager (copy), updateRegisteredPlant (copy)
    if u5 then
        return;
    end;

    u5 = true;
    RunService.Heartbeat:Connect(function(p47) -- Line: 232
        -- upvalues: u4 (ref), u3 (ref), EffectLoadManager (ref), updateRegisteredPlant (ref)
        u4 = u4 + p47;

        if u4 < 0.15 then
            return;
        end;

        u4 = 0;
        debug.profilebegin("Controllers/InverseKinematicsController/SharedHeartbeat");

        for i, v in u3 do
            if EffectLoadManager.ShouldAnimateInstance(i, 80) then
                updateRegisteredPlant(i, v);
            end;
        end;

        debug.profileend();
    end);
end;

function v1.SetupPlant(p48, p49) -- Line: 252
    -- upvalues: u2 (copy), u3 (copy), u5 (ref), RunService (copy), u4 (ref), EffectLoadManager (copy), updateRegisteredPlant (copy)
    local u50 = {};
    local v51 = {};

    for _, child in p49:GetChildren() do
        local v52 = tonumber(child.Name);

        if v52 then
            if child:IsA("Part") then
                table.insert(u50, {
                    part = child,
                    index = v52
                });
            elseif child:IsA("BasePart") then
                if not v51[v52] then
                    v51[v52] = {};
                end;

                table.insert(v51[v52], child);
            end;
        end;
    end;

    table.sort(u50, function(p53, p54) -- Line: 270
        return p53.index < p54.index;
    end);

    if #u50 < 2 then
        return;
    end;

    local u55 = {};

    for _, v in u50 do
        u55[v.index] = v.part;
    end;

    local part = u50[#u50].part;

    local function findParentPart(p56) -- Line: 281
        -- upvalues: u55 (copy), u50 (copy), part (copy)
        if u55[p56] then
            return u55[p56];
        end;

        local v57 = nil;

        for _, v in u50 do
            if v.index <= p56 and (not v57 or v.index > v57.index) then
                v57 = v;
            end;
        end;

        if v57 then
            return v57.part;
        end;

        return part;
    end;

    local v58 = {};

    for i, v in v51 do
        local v59 = findParentPart(i);

        for _, v2 in v do
            local v60 = {
                part = v2,
                parent = v59,
                offset = v59.CFrame:ToObjectSpace(v2.CFrame)
            };
            table.insert(v58, v60);
        end;
    end;

    local PlantModel = p49:FindFirstChild("PlantModel");
    local v61 = {};
    local v62 = {};
    local v63 = {};
    local v64 = nil;
    local v65 = nil;

    if PlantModel and PlantModel:IsA("Model") then
        local Base = PlantModel:FindFirstChild("Base");
        local TopJaw = PlantModel:FindFirstChild("TopJaw");
        local BottomJaw = PlantModel:FindFirstChild("BottomJaw");

        if Base then
            for _, descendant in Base:GetDescendants() do
                if descendant:IsA("BasePart") then
                    local v66 = {
                        part = descendant,
                        offset = part.CFrame:ToObjectSpace(descendant.CFrame)
                    };
                    table.insert(v61, v66);
                end;
            end;
        end;

        if TopJaw then
            v64 = part.CFrame:ToObjectSpace(TopJaw:GetPivot());

            for _, descendant in TopJaw:GetDescendants() do
                if descendant:IsA("BasePart") then
                    local v67 = {
                        part = descendant,
                        offset = TopJaw:GetPivot():ToObjectSpace(descendant.CFrame)
                    };
                    table.insert(v62, v67);
                end;
            end;
        end;

        if BottomJaw then
            v65 = part.CFrame:ToObjectSpace(BottomJaw:GetPivot());

            for _, descendant in BottomJaw:GetDescendants() do
                if descendant:IsA("BasePart") then
                    local v68 = {
                        part = descendant,
                        offset = BottomJaw:GetPivot():ToObjectSpace(descendant.CFrame)
                    };
                    table.insert(v63, v68);
                end;
            end;
        end;

        for _, descendant in PlantModel:GetDescendants() do
            if descendant:IsA("BasePart") then
                local Parent = descendant.Parent;
                local v69 = false;

                while Parent and Parent ~= PlantModel do
                    if Parent.Name == "Base" or (Parent.Name == "TopJaw" or Parent.Name == "BottomJaw") then
                        v69 = true;
                        break;
                    end;

                    Parent = Parent.Parent;
                end;

                if not v69 then
                    local v70 = {
                        part = descendant,
                        offset = part.CFrame:ToObjectSpace(descendant.CFrame)
                    };
                    table.insert(v61, v70);
                end;
            end;
        end;
    end;

    local part2 = u50[1].part;
    local v71 = {};

    for i = 2, #u50 do
        local part3 = u50[i].part;
        local v72 = {
            part = part3,
            restOffset = u50[i - 1].part.CFrame:ToObjectSpace(part3.CFrame)
        };
        table.insert(v71, v72);
    end;

    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = 0;
    NumberValue.Name = "JawValue";
    NumberValue.Parent = p49;
    local NumberValue2 = Instance.new("NumberValue");
    NumberValue2.Value = 0;
    NumberValue2.Name = "LungeValue";
    NumberValue2.Parent = p49;
    u2[p49] = {
        basePart = part2
    };
    local _, v73, _ = part2.CFrame:ToEulerAnglesYXZ();
    local u74 = {
        basePart = part2,
        topPart = part,
        chain = v71,
        attachmentData = v58,
        baseData = v61,
        topJawData = v62,
        bottomJawData = v63,
        topJawPivot = v64,
        bottomJawPivot = v65,
        jawValue = NumberValue,
        lungeValue = NumberValue2,
        originalBaseAngle = v73
    };
    p49.ChildRemoved:Connect(function(p75) -- Line: 423
        -- upvalues: part2 (copy), u74 (copy)
        if p75:IsA("Highlight") then
            local _, v76, _ = part2.CFrame:ToEulerAnglesYXZ();
            u74.originalBaseAngle = v76;
        end;
    end);
    u3[p49] = u74;

    if u5 then
        return;
    end;

    u5 = true;
    RunService.Heartbeat:Connect(function(p77) -- Line: 232
        -- upvalues: u4 (ref), u3 (ref), EffectLoadManager (ref), updateRegisteredPlant (ref)
        u4 = u4 + p77;

        if u4 < 0.15 then
            return;
        end;

        u4 = 0;
        debug.profilebegin("Controllers/InverseKinematicsController/SharedHeartbeat");

        for i, v in u3 do
            if EffectLoadManager.ShouldAnimateInstance(i, 80) then
                updateRegisteredPlant(i, v);
            end;
        end;

        debug.profileend();
    end);
end;

function v1.GetBasePart(p78, p79) -- Line: 437
    -- upvalues: u2 (copy)
    local v80 = u2[p79];

    return v80 and v80.basePart or nil;
end;

function v1.OpenMouth(p81, p82) -- Line: 442
    -- upvalues: TweenService (copy)
    local JawValue = p82:FindFirstChild("JawValue");

    if not JawValue then
        return;
    end;

    TweenService:Create(JawValue, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Value = 1
    }):Play();
end;

function v1.CloseMouth(p83, p84) -- Line: 448
    -- upvalues: TweenService (copy)
    local JawValue = p84:FindFirstChild("JawValue");

    if not JawValue then
        return;
    end;

    TweenService:Create(JawValue, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Value = -0.25
    }):Play();
end;

function v1.LungeAt(p85, p86, p87) -- Line: 454
    -- upvalues: TweenService (copy)
    p86:SetAttribute("LungeTarget", p87);
    local LungeValue = p86:FindFirstChild("LungeValue");

    if not LungeValue then
        return;
    end;

    TweenService:Create(LungeValue, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Value = 1
    }):Play();
end;

function v1.ReturnToRest(p88, p89) -- Line: 461
    -- upvalues: TweenService (copy)
    local LungeValue = p89:FindFirstChild("LungeValue");

    if not LungeValue then
        return;
    end;

    TweenService:Create(LungeValue, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Value = 0
    }):Play();
end;

return v1;