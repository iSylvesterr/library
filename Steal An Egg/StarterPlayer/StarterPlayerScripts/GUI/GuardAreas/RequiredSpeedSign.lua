-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u1 = {};
u1.__index = u1;
u1.__class = "RequiredSpeedSign";
local u2 = Color3.fromRGB(0, 255, 0);
local u3 = Color3.fromRGB(153, 255, 0);
local u4 = Color3.fromRGB(255, 170, 0);
local u5 = Color3.fromRGB(255, 0, 0);

function u1.new(p6) -- Line: 51
    -- upvalues: Asserts (copy), u1 (copy), Constants (copy)
    Asserts.Model(p6);
    local v7 = setmetatable({}, u1);
    local RequiredSpeedSign = p6:WaitForChild("RequiredSpeedSign", Constants.STUDIO_YIELD_TIMEOUT);
    local v8;

    if RequiredSpeedSign then
        v8 = RequiredSpeedSign:IsA("Model");
    else
        v8 = RequiredSpeedSign;
    end;

    local v9 = `{p6:GetFullName()}.RequiredSpeedSign must be a Model`;
    assert(v8, v9);
    local Main = RequiredSpeedSign:WaitForChild("Main", Constants.STUDIO_YIELD_TIMEOUT);
    local v10;

    if Main then
        v10 = Main:IsA("BasePart");
    else
        v10 = Main;
    end;

    local v11 = `{RequiredSpeedSign:GetFullName()}.Main must be a BasePart`;
    assert(v10, v11);
    local SurfaceGui = Main:WaitForChild("SurfaceGui", Constants.STUDIO_YIELD_TIMEOUT);
    local v12;

    if SurfaceGui then
        v12 = SurfaceGui:IsA("SurfaceGui");
    else
        v12 = SurfaceGui;
    end;

    local v13 = `{Main:GetFullName()}.SurfaceGui must be a SurfaceGui`;
    assert(v12, v13);
    local Info = SurfaceGui:WaitForChild("Info", Constants.STUDIO_YIELD_TIMEOUT);
    local v14;

    if Info then
        v14 = Info:IsA("TextLabel");
    else
        v14 = Info;
    end;

    local v15 = `{SurfaceGui:GetFullName()}.Info must be a TextLabel`;
    assert(v14, v15);
    local Required = SurfaceGui:WaitForChild("Required", Constants.STUDIO_YIELD_TIMEOUT);
    local v16;

    if Required then
        v16 = Required:IsA("GuiObject");
    else
        v16 = Required;
    end;

    local v17 = `{SurfaceGui:GetFullName()}.Required must be a GuiObject`;
    assert(v16, v17);
    local Speed = Required:WaitForChild("Speed", Constants.STUDIO_YIELD_TIMEOUT);
    local v18;

    if Speed then
        v18 = Speed:IsA("TextLabel");
    else
        v18 = Speed;
    end;

    local v19 = `{Required:GetFullName()}.Speed must be a TextLabel`;
    assert(v18, v19);
    v7._infoLabel = Info;
    v7._speedLabel = Speed;
    v7:SetSlowdownTolerance(-1);

    return v7;
end;

function u1.SetSlowdownTolerance(p20, p21) -- Line: 80
    -- upvalues: Asserts (copy), u5 (copy), u4 (copy), u3 (copy), u2 (copy)
    Asserts.number(p21);
    local v22;

    if p21 < 0.03 then
        v22 = u5;
    elseif p21 < 0.1 then
        v22 = u4:Lerp(u3, (p21 - 0.03) / 0.07);
    elseif p21 < 0.4 then
        v22 = u3:Lerp(u2, (p21 - 0.1) / 0.30000000000000004);
    else
        v22 = u2;
    end;

    p20._infoLabel.TextColor3 = v22;
    p20._speedLabel.TextColor3 = v22;
end;

function u1.SetSpeedPowerRequirement(p23, p24) -- Line: 104
    -- upvalues: Asserts (copy), TreadmillUtil (copy)
    Asserts.number(p24);
    p23._speedLabel.Text = TreadmillUtil.FormatSpeedPower(p24);
end;

function u1.Destroy(p25) -- Line: 109
end;

return u1;