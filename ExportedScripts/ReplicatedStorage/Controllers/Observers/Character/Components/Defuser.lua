-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Other = ReplicatedStorage.Assets.Other;
local Defuser = Other.Defuser;
local DefuseA1 = Other.DefuseA1;
local DefuseA2 = Other.DefuseA2;
local DefuseB1 = Other.DefuseB1;
local DefuseB2 = Other.DefuseB2;
local u1 = CFrame.new(0, -0.2, -0.5) * CFrame.Angles(0, 3.141592653589793, 0);
local u2 = {};
u2.__index = u2;

local function cloneDefusePart(p3, p4, p5) -- Line: 33
    local v6 = p3:Clone();
    local Attachment = v6:FindFirstChild("Attachment");
    local Parent = p4.Parent;
    v6.CFrame = Parent.CFrame * p4.CFrame * Attachment.CFrame:Inverse();
    v6.Parent = workspace;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = Parent;
    WeldConstraint.Part1 = v6;
    WeldConstraint.Parent = v6;
    p5:Add(v6);

    return Attachment;
end;

local function disconnectBeam(p7) -- Line: 52
    if p7 then
        p7.Attachment0 = nil;
        p7.Attachment1 = nil;
    end;
end;

local function cleanupVisuals(u8) -- Line: 60
    task.defer(function() -- Line: 62
        -- upvalues: u8 (copy)
        pcall(function() -- Line: 63
            -- upvalues: u8 (ref)
            u8:Destroy();
        end);
    end);
end;

local function cleanup(p9, p10, u11) -- Line: 70
    if p9 then
        p9.Attachment0 = nil;
        p9.Attachment1 = nil;
    end;

    if p10 then
        p10.Attachment0 = nil;
        p10.Attachment1 = nil;
    end;

    if u11 then
        task.defer(function() -- Line: 62
            -- upvalues: u11 (copy)
            pcall(function() -- Line: 63
                -- upvalues: u11 (ref)
                u11:Destroy();
            end);
        end);
    end;
end;

function u2.new(p12, u13) -- Line: 79
    -- upvalues: u2 (copy), Janitor (copy), Observers (copy), CollectionService (copy), Defuser (copy), u1 (copy), cloneDefusePart (copy), DefuseA1 (copy), DefuseA2 (copy), DefuseB1 (copy), DefuseB2 (copy)
    local v14 = setmetatable({}, u2);
    v14.Janitor = Janitor.new();
    local u15 = nil;
    local u16 = nil;
    local u17 = nil;
    v14.Janitor:Add(Observers.observeAttribute(p12, "IsDefusingBomb", function(p18) -- Line: 87
        -- upvalues: u15 (ref), u16 (ref), u17 (ref), Janitor (ref), u13 (copy), CollectionService (ref), Defuser (ref), u1 (ref), cloneDefusePart (ref), DefuseA1 (ref), DefuseA2 (ref), DefuseB1 (ref), DefuseB2 (ref)
        if p18 == true then
            if u15 then
                local v19 = u16;
                local v20 = u17;
                local u21 = u15;

                if v19 then
                    v19.Attachment0 = nil;
                    v19.Attachment1 = nil;
                end;

                if v20 then
                    v20.Attachment0 = nil;
                    v20.Attachment1 = nil;
                end;

                if u21 then
                    task.defer(function() -- Line: 62
                        -- upvalues: u21 (copy)
                        pcall(function() -- Line: 63
                            -- upvalues: u21 (ref)
                            u21:Destroy();
                        end);
                    end);
                end;
            end;

            u16 = nil;
            u17 = nil;
            u15 = Janitor.new();
            local LeftHand = u13:FindFirstChild("LeftHand");
            local v22 = CollectionService:GetTagged("Bomb")[1];

            if not (LeftHand and v22) then
                local u23 = u15;
                task.defer(function() -- Line: 62
                    -- upvalues: u23 (copy)
                    pcall(function() -- Line: 63
                        -- upvalues: u23 (ref)
                        u23:Destroy();
                    end);
                end);
                u15 = nil;

                return function() -- Line: 102
                end;
            end;

            local v24 = Defuser:Clone();
            local Handle = v24.Handle;
            v24.Parent = u13;
            Handle.CFrame = LeftHand.CFrame * u1;
            v24.PrimaryPart = Handle;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = LeftHand;
            WeldConstraint.Part1 = Handle;
            WeldConstraint.Parent = Handle;
            u15:Add(v24);
            local AttachmentA = Handle:FindFirstChild("AttachmentA");
            local AttachmentB = Handle:FindFirstChild("AttachmentB");
            local Body = v22.Weapon.Body;
            local AttachmentA2 = Body:FindFirstChild("AttachmentA");
            local AttachmentB2 = Body:FindFirstChild("AttachmentB");
            local v25 = cloneDefusePart(DefuseA1, AttachmentA, u15);
            local v26 = cloneDefusePart(DefuseA2, AttachmentA2, u15);
            local v27 = cloneDefusePart(DefuseB1, AttachmentB, u15);
            local v28 = cloneDefusePart(DefuseB2, AttachmentB2, u15);
            local v29 = v25.Parent:FindFirstChildWhichIsA("Beam");

            if v29 then
                v29.Attachment0 = v25;
                v29.Attachment1 = v26;
                v29.Enabled = true;
                u16 = v29;
            end;

            local v30 = v27.Parent:FindFirstChildWhichIsA("Beam");

            if v30 then
                v30.Attachment0 = v27;
                v30.Attachment1 = v28;
                v30.Enabled = true;
                u17 = v30;
            end;
        else
            local v31 = u16;
            local v32 = u17;
            local u33 = u15;

            if v31 then
                v31.Attachment0 = nil;
                v31.Attachment1 = nil;
            end;

            if v32 then
                v32.Attachment0 = nil;
                v32.Attachment1 = nil;
            end;

            if u33 then
                task.defer(function() -- Line: 62
                    -- upvalues: u33 (copy)
                    pcall(function() -- Line: 63
                        -- upvalues: u33 (ref)
                        u33:Destroy();
                    end);
                end);
            end;

            u16 = nil;
            u17 = nil;
            u15 = nil;
        end;

        return function() -- Line: 155
            -- upvalues: u16 (ref), u17 (ref), u15 (ref)
            local v34 = u16;
            local v35 = u17;
            local u36 = u15;

            if v34 then
                v34.Attachment0 = nil;
                v34.Attachment1 = nil;
            end;

            if v35 then
                v35.Attachment0 = nil;
                v35.Attachment1 = nil;
            end;

            if u36 then
                task.defer(function() -- Line: 62
                    -- upvalues: u36 (copy)
                    pcall(function() -- Line: 63
                        -- upvalues: u36 (ref)
                        u36:Destroy();
                    end);
                end);
            end;

            u16 = nil;
            u17 = nil;
            u15 = nil;
        end;
    end));

    return v14;
end;

function u2.Destroy(p37) -- Line: 169
    p37.Janitor:Destroy();
end;

return u2;