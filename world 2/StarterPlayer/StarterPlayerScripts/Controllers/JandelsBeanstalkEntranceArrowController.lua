-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TutorialUtils = require(script.Parent.TutorialController.TutorialUtils);
local u1 = assert(Players.LocalPlayer);
local v2 = {};
local u3 = nil;
local u4 = nil;
local u5 = 0;
local u6 = false;
local u7 = false;
local u8 = nil;
local u9 = nil;

local function getTargetPosition() -- Line: 53
    -- upvalues: u3 (ref)
    local v10 = u3;

    if not v10 then
        return nil;
    end;

    local PrimaryPart = v10.PrimaryPart;

    if PrimaryPart then
        return PrimaryPart.Position;
    end;

    return nil;
end;

local function stopArrow() -- Line: 67
    -- upvalues: u9 (ref), u8 (ref)
    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    if u8 then
        u8();
        u8 = nil;
    end;
end;

local function shouldShow() -- Line: 79
    -- upvalues: u3 (ref), u7 (ref), u1 (copy)
    local v11;

    if u3 == nil then
        v11 = false;
    else
        v11 = not u7;

        if v11 then
            if u1:GetAttribute("InBeanstalkClimb") == true then
                v11 = false;
            else
                v11 = workspace:GetAttribute("InTutorial") ~= true;
            end;
        end;
    end;

    return v11;
end;

local function update() -- Line: 86
    -- upvalues: u3 (ref), u7 (ref), u1 (copy), u9 (ref), u8 (ref), TutorialUtils (copy), RunService (copy), u6 (ref), u5 (ref), update (copy)
    local v12;

    if u3 == nil then
        v12 = false;
    else
        v12 = not u7;

        if v12 then
            if u1:GetAttribute("InBeanstalkClimb") == true then
                v12 = false;
            else
                v12 = workspace:GetAttribute("InTutorial") ~= true;
            end;
        end;
    end;

    local v13;

    if v12 then
        local v14 = u3;

        if v14 then
            local PrimaryPart = v14.PrimaryPart;

            if PrimaryPart then
                v13 = PrimaryPart.Position;
            else
                v13 = nil;
            end;
        else
            v13 = nil;
        end;
    else
        v13 = nil;
    end;

    if not v13 then
        if u9 then
            u9:Disconnect();
            u9 = nil;
        end;

        if u8 then
            u8();
            u8 = nil;
        end;

        return;
    end;

    if u8 then
        return;
    end;

    local u15 = TutorialUtils.createArrow(u1, CFrame.new(v13));
    u8 = u15.destroy;
    u9 = RunService.PreRender:Connect(function() -- Line: 102
        -- upvalues: u3 (ref), u15 (copy)
        local v16 = u3;
        local v17;

        if v16 then
            local PrimaryPart = v16.PrimaryPart;

            if PrimaryPart then
                v17 = PrimaryPart.Position;
            else
                v17 = nil;
            end;
        else
            v17 = nil;
        end;

        if v17 then
            u15.move(CFrame.new(v17));
        end;
    end);

    if u6 then
        return;
    end;

    u6 = true;
    local u18 = u5;
    task.delay(60, function() -- Line: 115
        -- upvalues: u18 (copy), u5 (ref), u7 (ref), update (ref)
        if u18 ~= u5 then
            return;
        end;

        u7 = true;
        update();
    end);
end;

local function setPortal(p19) -- Line: 126
    -- upvalues: u4 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), update (copy)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    u3 = p19;
    u5 = u5 + 1;
    u6 = false;
    u7 = false;

    if p19 then
        u4 = p19:GetPropertyChangedSignal("PrimaryPart"):Connect(update);
    end;

    update();
end;

function v2.Start(p20) -- Line: 144
    -- upvalues: u4 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), update (copy), u1 (copy)
    workspace.ChildAdded:Connect(function(p21) -- Line: 145
        -- upvalues: u4 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), update (ref)
        if p21.Name == "JandelsBeanstalkPortal" and p21:IsA("Model") then
            if u4 then
                u4:Disconnect();
                u4 = nil;
            end;

            u3 = p21;
            u5 = u5 + 1;
            u6 = false;
            u7 = false;

            if p21 then
                u4 = p21:GetPropertyChangedSignal("PrimaryPart"):Connect(update);
            end;

            update();
        end;
    end);
    workspace.ChildRemoved:Connect(function(p22) -- Line: 151
        -- upvalues: u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), update (ref)
        if p22 == u3 then
            if u4 then
                u4:Disconnect();
                u4 = nil;
            end;

            u3 = nil;
            u5 = u5 + 1;
            u6 = false;
            u7 = false;
            update();
        end;
    end);
    u1:GetAttributeChangedSignal("InBeanstalkClimb"):Connect(function() -- Line: 159
        -- upvalues: u1 (ref), u7 (ref), update (ref)
        if u1:GetAttribute("InBeanstalkClimb") == true then
            u7 = true;
        end;

        update();
    end);
    workspace:GetAttributeChangedSignal("InTutorial"):Connect(update);
    local JandelsBeanstalkPortal = workspace:FindFirstChild("JandelsBeanstalkPortal");

    if JandelsBeanstalkPortal and JandelsBeanstalkPortal:IsA("Model") then
        if u4 then
            u4:Disconnect();
            u4 = nil;
        end;

        u3 = JandelsBeanstalkPortal;
        u5 = u5 + 1;
        u6 = false;
        u7 = false;

        if JandelsBeanstalkPortal then
            u4 = JandelsBeanstalkPortal:GetPropertyChangedSignal("PrimaryPart"):Connect(update);
        end;

        update();
    end;
end;

return v2;