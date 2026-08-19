-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
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

local function findDescendant(p13, p14, p15) -- Line: 64
    for _, descendant in p13:GetDescendants() do
        if descendant.Name == p14 and descendant:IsA(p15) then
            return descendant;
        end;
    end;

    return nil;
end;

local function BindGui() -- Line: 75
    -- upvalues: PlayerGui (copy), u2 (ref), u4 (ref), u3 (ref), u5 (ref), u11 (ref), u12 (ref), findDescendant (copy)
    local JandelsBeanstalk = PlayerGui:FindFirstChild("JandelsBeanstalk");

    if JandelsBeanstalk == u2 then
        return u4 ~= nil;
    end;

    u2 = JandelsBeanstalk;
    u3 = nil;
    u4 = nil;
    u5 = nil;
    u11 = nil;
    u12 = nil;

    if not (JandelsBeanstalk and JandelsBeanstalk:IsA("ScreenGui")) then
        u2 = nil;

        return false;
    end;

    local v16 = findDescendant(JandelsBeanstalk, "ProgressBar", "GuiObject");

    if not v16 then
        u2 = nil;
        warn("[JandelsBeanstalkProgressController] JandelsBeanstalk has no ProgressBar descendant");

        return false;
    end;

    u3 = JandelsBeanstalk;
    u4 = v16;
    u5 = findDescendant(JandelsBeanstalk, "Height", "TextLabel");

    return true;
end;

local function ResolvePart(p17, p18, p19) -- Line: 110
    -- upvalues: findDescendant (copy)
    local v20 = p17:FindFirstChild(p18);

    if not v20 then
        return nil;
    end;

    local v21 = v20:FindFirstChild(p19);

    if v21 and v21:IsA("BasePart") then
        return v21;
    end;

    return findDescendant(v20, p19, "BasePart");
end;

local function BindTower() -- Line: 124
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), findDescendant (copy), u9 (ref)
    if u6 and (u6.Parent and (u7 and u8)) then
        return true;
    end;

    u6 = nil;
    u7 = nil;
    u8 = nil;
    local JandelsBeanstalkTower = workspace:FindFirstChild("JandelsBeanstalkTower");

    if not JandelsBeanstalkTower then
        return false;
    end;

    local BaseLayer = JandelsBeanstalkTower:FindFirstChild("BaseLayer");
    local v22;

    if BaseLayer then
        v22 = BaseLayer:FindFirstChild("Bottom");

        if not (v22 and v22:IsA("BasePart")) then
            v22 = findDescendant(BaseLayer, "Bottom", "BasePart");
        end;
    else
        v22 = nil;
    end;

    local TopLayer = JandelsBeanstalkTower:FindFirstChild("TopLayer");
    local v23;

    if TopLayer then
        v23 = TopLayer:FindFirstChild("Top");

        if not (v23 and v23:IsA("BasePart")) then
            v23 = findDescendant(TopLayer, "Top", "BasePart");
        end;
    else
        v23 = nil;
    end;

    if not (v22 and v23) then
        if u9 ~= JandelsBeanstalkTower then
            u9 = JandelsBeanstalkTower;
            warn("[JandelsBeanstalkProgressController] JandelsBeanstalkTower is missing BaseLayer.Bottom and/or TopLayer.Top; progress bar cannot fill");
        end;

        return false;
    end;

    u6 = JandelsBeanstalkTower;
    u7 = v22;
    u8 = v23;

    return true;
end;

local function GetRootY() -- Line: 157
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if Character and Character:IsA("BasePart") then
        return Character.Position.Y;
    end;

    return nil;
end;

local function UpdateProgress() -- Line: 166
    -- upvalues: u4 (ref), BindTower (copy), u7 (ref), u8 (ref), LocalPlayer (copy), u11 (ref), u5 (ref), u12 (ref)
    local v24 = u4;

    if not (v24 and BindTower()) then
        return;
    end;

    local v25 = u7;
    local v26 = u8;
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local v27;

    if Character and Character:IsA("BasePart") then
        v27 = Character.Position.Y;
    else
        v27 = nil;
    end;

    if not (v25 and (v26 and v27)) then
        return;
    end;

    local Y = v25.Position.Y;
    local v28 = v26.Position.Y - Y;

    if v28 <= 0 then
        return;
    end;

    local v29 = math.clamp((v27 - Y) / v28, 0, 1);

    if u11 ~= v29 then
        u11 = v29;
        v24.Size = UDim2.new(1, 0, v29, 0);
    end;

    local v30 = u5;

    if v30 then
        local v31 = math.round(v29 * 500);

        if u12 ~= v31 then
            u12 = v31;
            v30.Text = `{v31} Studs`;
        end;
    end;
end;

local function StopRender() -- Line: 202
    -- upvalues: u10 (ref)
    if u10 then
        u10:Disconnect();
        u10 = nil;
    end;
end;

local function Apply() -- Line: 211
    -- upvalues: BindGui (copy), u10 (ref), u3 (ref), LocalPlayer (copy), UpdateProgress (copy), RunService (copy)
    if not BindGui() then
        if u10 then
            u10:Disconnect();
            u10 = nil;
        end;

        return;
    end;

    local v32 = u3;

    if not v32 then
        return;
    end;

    local v33 = LocalPlayer:GetAttribute("InBeanstalkClimb") == true;

    if v32.Enabled ~= v33 then
        v32.Enabled = v33;
    end;

    if not v33 then
        if u10 then
            u10:Disconnect();
            u10 = nil;
        end;

        return;
    end;

    UpdateProgress();

    if not u10 then
        u10 = RunService.RenderStepped:Connect(UpdateProgress);
    end;
end;

function v1.Init(p34) -- Line: 242
    -- upvalues: PlayerGui (copy)
    local JandelsBeanstalk = PlayerGui:FindFirstChild("JandelsBeanstalk");

    if JandelsBeanstalk and JandelsBeanstalk:IsA("ScreenGui") then
        JandelsBeanstalk.Enabled = false;
    end;
end;

function v1.Start(p35) -- Line: 252
    -- upvalues: LocalPlayer (copy), Apply (copy), PlayerGui (copy)
    LocalPlayer:GetAttributeChangedSignal("InBeanstalkClimb"):Connect(Apply);
    PlayerGui.ChildAdded:Connect(function(p36) -- Line: 256
        -- upvalues: Apply (ref)
        if p36.Name == "JandelsBeanstalk" then
            Apply();
        end;
    end);
    Apply();
end;

return v1;