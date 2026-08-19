-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
game:GetService("ReplicatedStorage");
local u1 = {};
local u2 = {
    BasicAttack = CollectionService:GetTagged("BasicAttack"),
    Skill = CollectionService:GetTagged("SkillAttack"),
    Finisher = CollectionService:GetTagged("FinisherAttack")
};

function u1.deserializeEnum(p3, p4) -- Line: 15
    if Enum[p3] ~= nil then
        for _, v in ipairs(Enum[p3]:GetEnumItems()) do
            if v.Value == p4 then
                return v;
            end;
        end;
    end;

    return nil;
end;

function u1.serializeEnum(p5, p6) -- Line: 26
    if typeof(p6) == "EnumItem" then
        return p6.Value;
    end;

    if Enum[p5] == nil then
        return nil;
    end;

    local v7 = Enum[p5]:GetEnumItems();

    return table.find(v7, p6);
end;

function u1.getRandomInPart(p8) -- Line: 38
    local v9 = Random.new();

    return p8.CFrame * CFrame.new(v9:NextNumber(-p8.Size.X / 2, p8.Size.X / 2), 0, v9:NextNumber(-p8.Size.Z / 2, p8.Size.Z / 2));
end;

function u1.readOnly(p10) -- Line: 44
    -- upvalues: u1 (copy)
    for _, v in pairs(p10) do
        if type(v) == "table" then
            u1.readOnly(v);
        end;
    end;

    return table.freeze(p10);
end;

function u1.alignWithCamera(p11) -- Line: 53
    -- upvalues: RunService (copy)
    if RunService:IsClient() then
        local PrimaryPart = game.Players.LocalPlayer.Character.PrimaryPart;
        local CFrame2 = workspace.CurrentCamera.CFrame;
        local v12 = PrimaryPart.Position + Vector3.new(CFrame2.LookVector.X, 0, CFrame2.LookVector.Z);
        local v13 = CFrame.lookAt(PrimaryPart.Position, v12);
        local BodyGyro = Instance.new("BodyGyro");
        BodyGyro.CFrame = v13;
        BodyGyro.MaxTorque = Vector3.new(0, 100000, 0);
        BodyGyro.P = 10000;
        BodyGyro.Parent = PrimaryPart;
        PrimaryPart.CFrame = v13;
        task.delay(p11, function() -- Line: 71
            -- upvalues: BodyGyro (copy)
            BodyGyro:Destroy();
        end);

        return BodyGyro;
    end;
end;

function u1.TimeFormat(p14) -- Line: 77
    if type(p14) == "string" then
        p14 = tonumber(p14);
    end;

    local v15 = p14 or 0;
    local v16 = (v15 - v15 % 60) / 60;

    return string.format("%02i", v16) .. ":" .. string.format("%02i", v15 - v16 * 60);
end;

function u1.LargeNumber(p17) -- Line: 90
    if p17 then
        local v18 = p17 / 1000;

        if v18 >= 1000 then
            return math.floor(v18 / 1000) .. "M";
        end;

        return math.floor(v18) .. "K";
    end;
end;

function u1.CommaFormat(p19) -- Line: 100
    local v20 = tostring(p19);
    local v21, v22 = v20:match("^(-?%d[%d%.]*)e([+-]%d+)$");

    if not v21 then
        repeat
            local v23;
            v20, v23 = string.gsub(v20, "^(-?%d+)(%d%d%d)", "%1,%2");
            k = v23;
        until k == 0;

        return v20;
    end;

    local format = string.format;
    local v24 = tonumber(v21);
    local v25 = tonumber(format("%.2f", v24));

    if math.abs(v25) >= 10 then
        return tostring(v25 / 10) .. "e" .. string.format("%+03d", tonumber(v22) + 1);
    end;

    return tostring(v25) .. "e" .. v22;
end;

function u1.raycast(p26, p27, p28, p29, p30) -- Line: 120
    local v31 = RaycastParams.new();
    v31.FilterType = p29 or Enum.RaycastFilterType.Blacklist;
    v31.FilterDescendantsInstances = p28;
    v31.CollisionGroup = p30 or "Default";

    return workspace:Raycast(p26, p27, v31);
end;

function u1.getSourceAnim(p32) -- Line: 129
    -- upvalues: u2 (copy)
    for _, v in pairs(u2) do
        for _, v2 in ipairs(v) do
            if v2.AnimationId == p32 then
                return v2;
            end;
        end;
    end;

    return nil;
end;

function u1.getSourceAnimByName(p33, p34) -- Line: 140
    -- upvalues: u2 (copy)
    for _, v in pairs(u2) do
        for _, v2 in ipairs(v) do
            if v2.Name == p33 and v2.Parent.Name == p34 then
                return v2;
            end;
        end;
    end;

    return nil;
end;

function u1.roundNumber(p35, p36) -- Line: 151
    if p35 % (1 / 10 ^ p36) < 1 / 10 ^ p36 then
        return math.ceil(p35 * 10 ^ p36) / 10 ^ p36;
    end;

    return math.floor(p35 * 10 ^ p36) / 10 ^ p36;
end;

function weldAttachments(p37, p38)
    local Weld = Instance.new("Weld");
    Weld.Part0 = p37.Parent;
    Weld.Part1 = p38.Parent;
    Weld.C0 = p37.CFrame;
    Weld.C1 = p38.CFrame;
    Weld.Parent = p37.Parent;

    return Weld;
end;

local function buildWeld(p39, p40, p41, p42, p43, p44) -- Line: 170
    local Weld = Instance.new("Weld");
    Weld.Name = p39;
    Weld.Part0 = p41;
    Weld.Part1 = p42;
    Weld.C0 = p43;
    Weld.C1 = p44;
    Weld.Parent = p40;

    return Weld;
end;

local function findFirstMatchingAttachment(p45, p46) -- Line: 181
    -- upvalues: findFirstMatchingAttachment (copy)
    for _, child in pairs(p45:GetChildren()) do
        if child:IsA("Attachment") and child.Name == p46 then
            return child;
        end;

        if not (child:IsA("Accoutrement") or child:IsA("Tool")) then
            local v47 = findFirstMatchingAttachment(child, p46);

            if v47 then
                return v47;
            end;
        end;
    end;
end;

function u1.getBoxOriginWithDirection(p48, p49, p50) -- Line: 195
    local v51 = p48 + p49 * (p50 * 0.4);

    return CFrame.lookAt(v51, v51 + p49 * (p50 * 0.5));
end;

function getCharactersFromHits(p52)
    local v53 = {};

    for _, v in ipairs(p52) do
        local v54 = v:FindFirstAncestorOfClass("Model");

        if v54 and (not table.find(v53, v54) and v54:FindFirstChild("Humanoid")) then
            table.insert(v53, v54);
        end;
    end;

    return v53;
end;

u1.getCharactersFromHits = getCharactersFromHits;

function u1.getPlayersFromHits(p55) -- Line: 221
    -- upvalues: Players (copy)
    local v56 = getCharactersFromHits(p55);
    local v57 = {};

    for _, v in ipairs(v56) do
        local v58 = Players:GetPlayerFromCharacter(v);

        if v58 then
            table.insert(v57, v58);
        end;
    end;

    return v57, v56;
end;

function u1.addLocalAccessory(p59, p60) -- Line: 234
    -- upvalues: findFirstMatchingAttachment (copy)
    p60.Parent = p59;
    local Handle = p60:FindFirstChild("Handle");

    if Handle then
        local v61 = Handle:FindFirstChildOfClass("Attachment");

        if v61 then
            local v62 = findFirstMatchingAttachment(p59, v61.Name);

            if v62 then
                weldAttachments(v62, v61);
            end;
        else
            local Head = p59:FindFirstChild("Head");

            if Head then
                local v63 = CFrame.new(0, 0.5, 0);
                local AttachmentPoint = p60.AttachmentPoint;
                local Weld = Instance.new("Weld");
                Weld.Name = "HeadWeld";
                Weld.Part0 = Head;
                Weld.Part1 = Handle;
                Weld.C0 = v63;
                Weld.C1 = AttachmentPoint;
                Weld.Parent = Head;
            end;
        end;
    end;
end;

function u1.getAllCharactersInRadius(p64, p65, p66) -- Line: 255
    -- upvalues: CollectionService (copy)
    local v67 = {};

    for _, v in ipairs(CollectionService:GetTagged("TargetableCharacter")) do
        if (v.PrimaryPart.Position - p64).Magnitude <= p65 and v ~= p66.Character then
            table.insert(v67, v);
        end;
    end;

    return v67;
end;

function u1.calculateCustomVelocity(p68, p69, p70, p71, p72) -- Line: 275
    local v73 = p70 / p71;
    local _ = p68.Y;

    return Vector3.new(p69.X * p71, -(v73 ^ 2 * p72) / (v73 * 2), p69.Z * p71);
end;

function u1.generateGUID() -- Line: 291
    -- upvalues: HttpService (copy)
    return HttpService:GenerateGUID(false);
end;

return u1;