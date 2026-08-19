-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local InsMgr = UtilsSystem.InsMgr;
local MathMgr = UtilsSystem.MathMgr;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local u1 = {};
local UIanima = ReplicatedStorage.Assets.UIanima;
local u2 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local u3 = Color3.new(1, 1, 1);
local u4 = Color3.new(1.8627450980392157, 1.8627450980392157, 1.8627450980392157);
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = {};
local u10 = {};

local function _ensureScaleValues(p11) -- Line: 153
    -- upvalues: InsMgr (copy)
    local v12 = InsMgr.GetIns("scaleValueX", "Vector3Value", p11);

    if v12.Value == Vector3.new(0, 0, 0) then
        v12.Value = Vector3.new(p11.Size.X.Scale, p11.Size.X.Offset, 0);
    end;

    local v13 = InsMgr.GetIns("scaleValueY", "Vector3Value", p11);

    if v13.Value == Vector3.new(0, 0, 0) then
        v13.Value = Vector3.new(p11.Size.Y.Scale, p11.Size.Y.Offset, 0);
    end;
end;

local function _getOrCreateUIScale(p14, p15) -- Line: 171
    local UIScale = p14:FindFirstChild("UIScale");

    if not (UIScale and UIScale:IsA("UIScale")) then
        UIScale = Instance.new("UIScale");
        UIScale.Name = "UIScale";
        UIScale.Scale = p15 or 1;
        UIScale.Parent = p14;
    end;

    return UIScale;
end;

local function _cancelPopScaleTween(p16) -- Line: 187
    -- upvalues: u9 (copy), u8 (copy)
    local v17 = u9[p16];

    if v17 then
        v17:Disconnect();
        u9[p16] = nil;
    end;

    local v18 = u8[p16];

    if v18 then
        v18:Cancel();
        u8[p16] = nil;
    end;
end;

local function _getScreenGuiScale() -- Line: 206
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return nil, 1;
    end;

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return nil, 1;
    end;

    local ScreenGui = PlayerGui:FindFirstChild("ScreenGui");

    if not (ScreenGui and ScreenGui:IsA("ScreenGui")) then
        return nil, 1;
    end;

    local v19 = ScreenGui:FindFirstChildOfClass("UIScale");

    return ScreenGui, not v19 and 1 or v19.Scale;
end;

local function _getViewportHoverModel(p20) -- Line: 236
    local v21 = p20:FindFirstChildWhichIsA("WorldModel");

    if v21 then
        for _, child in v21:GetChildren() do
            if child:IsA("Model") then
                return child;
            end;
        end;
    end;

    for _, child in p20:GetChildren() do
        if child:IsA("Model") then
            return child;
        end;
    end;

    return nil;
end;

local function _buildWeaponHoverSnapshot(u22) -- Line: 260
    local v23, v24, v25 = pcall(function() -- Line: 261
        -- upvalues: u22 (copy)
        return u22:GetBoundingBox();
    end);

    if not (v23 and (v24 and v25)) then
        return nil, nil, nil;
    end;

    local Position = v24.Position;
    local X = v25.X;
    local Y = v25.Y;
    local Z = v25.Z;
    local v26 = v24:VectorToWorldSpace(Y <= X and Z <= X and Vector3.new(1, 0, 0) or (Z <= Y and Vector3.new(0, 1, 0) or Vector3.new(0, 0, 1)));
    local v27 = v26.Magnitude < 1e-6 and Vector3.new(0, 1, 0) or v26.Unit;
    local v28 = {};

    for _, descendant in u22:GetDescendants() do
        if descendant:IsA("BasePart") and (descendant.Name ~= "绝对中心" and descendant.Name ~= "ViewportWeaponPivot") then
            v28[descendant] = descendant.CFrame;
        end;
    end;

    if next(v28) == nil then
        return nil, nil, nil;
    end;

    return Position, v28, v27;
end;

local function _rotateVectorAroundUnitAxis(p29, p30, p31) -- Line: 302
    if p30.Magnitude < 1e-6 then
        return p29;
    end;

    local Unit = p30.Unit;
    local v32 = math.cos(p31);
    local v33 = math.sin(p31);
    local v34 = Unit:Dot(p29);

    return p29 * v32 + Unit:Cross(p29) * v33 + Unit * v34 * (1 - v32);
end;

local function _getWeaponTwistAxisScreenVerticalLeftTilt(p35, p36) -- Line: 319
    local CurrentCamera = p35.CurrentCamera;

    if not CurrentCamera or CurrentCamera.CFrame.LookVector.Magnitude < 0.0001 then
        return nil;
    end;

    local Unit = CurrentCamera.CFrame.LookVector.Unit;
    local UpVector = CurrentCamera.CFrame.UpVector;

    if UpVector.Magnitude < 1e-6 then
        return nil;
    end;

    local Unit2 = UpVector.Unit;
    local v37 = math.rad(-p36);

    if Unit.Magnitude >= 1e-6 then
        local Unit3 = Unit.Unit;
        local v38 = math.cos(v37);
        local v39 = math.sin(v37);
        local v40 = Unit3:Dot(Unit2);
        Unit2 = Unit2 * v38 + Unit3:Cross(Unit2) * v39 + Unit3 * v40 * (1 - v38);
    end;

    if Unit2.Magnitude < 1e-6 then
        return nil;
    end;

    return Unit2.Unit;
end;

local function _applyWeaponRigidTwistAroundAxis(p41, p42, p43, p44) -- Line: 345
    if p43.Magnitude < 0.0001 then
        return;
    end;

    local v45 = CFrame.fromAxisAngle(p43.Unit, p44);
    local v46 = CFrame.new(p42);

    for i, v in p41 do
        if i.Parent then
            i.CFrame = v46 * v45 * v46:Inverse() * v;
        end;
    end;
end;

local function _pivotHoverSpinDelta(p47, p48, p49) -- Line: 371
    if p49 then
        return p47 * CFrame.Angles(0, 0, p48);
    end;

    return p47 * CFrame.Angles(0, p48, 0);
end;

local function _viewportFrameShowsWeapon(p50) -- Line: 383
    -- upvalues: CfgFind (copy), EnumMgr (copy)
    local v51 = tonumber(p50:GetAttribute("ID"));

    if v51 and v51 ~= 0 then
        return CfgFind.FindCfgByID(v51, EnumMgr.ItemType.Weapon) and true or CfgFind.GetCfgByNameAndID("weaponConf", v51) ~= nil;
    end;

    return false;
end;

local function _viewportFrameShowsBroom(p52) -- Line: 400
    -- upvalues: CfgFind (copy), EnumMgr (copy)
    local v53 = tonumber(p52:GetAttribute("ID"));

    if not v53 or v53 == 0 then
        return false;
    end;

    local v54 = CfgFind.FindCfgByID(v53, EnumMgr.ItemType.Broom);
    local v55;

    if v54 == nil then
        v55 = false;
    else
        v55 = tonumber(v54.tp) == EnumMgr.ItemType.Broom;
    end;

    return v55;
end;

local function _getOrCreateHoverUIScale(p56) -- Line: 414
    local v57 = p56:FindFirstChildOfClass("UIScale");

    if not v57 then
        v57 = Instance.new("UIScale");
        v57.Scale = 1;
        v57.Parent = p56;
    end;

    return v57;
end;

function u1.PopUp(p58) -- Line: 433
    -- upvalues: _ensureScaleValues (copy), u1 (copy), UtilsSystem (copy)
    _ensureScaleValues(p58);
    u1.UIScaleOut(p58);
    local UIMgr = UtilsSystem.UIMgr;

    if UIMgr then
        UIMgr.RefreshPopShowState();
    end;
end;

function u1.PopBack(u59) -- Line: 448
    -- upvalues: _ensureScaleValues (copy), u9 (copy), u8 (copy), TweenService (copy), UtilsSystem (copy)
    _ensureScaleValues(u59);
    local v60 = u9[u59];

    if v60 then
        v60:Disconnect();
        u9[u59] = nil;
    end;

    local v61 = u8[u59];

    if v61 then
        v61:Cancel();
        u8[u59] = nil;
    end;

    local UIScale = u59:FindFirstChild("UIScale");

    if not (UIScale and UIScale:IsA("UIScale")) then
        UIScale = Instance.new("UIScale");
        UIScale.Name = "UIScale";
        UIScale.Scale = 1;
        UIScale.Parent = u59;
    end;

    UIScale.Scale = 1;
    local u62 = TweenService:Create(UIScale, TweenInfo.new(0.1), {
        Scale = 0
    });
    u8[u59] = u62;
    local u63 = nil;
    u63 = u62.Completed:Connect(function(p64) -- Line: 459
        -- upvalues: u9 (ref), u59 (copy), u63 (ref), u8 (ref), u62 (copy), UtilsSystem (ref)
        if u9[u59] == u63 then
            u9[u59] = nil;
        end;

        if u63 then
            u63:Disconnect();
            u63 = nil;
        end;

        if u8[u59] == u62 then
            u8[u59] = nil;
        end;

        if p64 ~= Enum.PlaybackState.Completed then
            return;
        end;

        u59.Visible = false;
        local UIMgr = UtilsSystem.UIMgr;

        if UIMgr then
            UIMgr.UpdateBlurVisible();
            UIMgr.RefreshPopShowState();
        end;
    end);
    u9[u59] = u63;
    u62:Play();
end;

function u1.ButtonDown(p65) -- Line: 498
    -- upvalues: InsMgr (copy), TweenService (copy)
    local v66 = InsMgr.GetIns("按钮缩放动画", "UIScale", p65);
    v66.Scale = 1;
    TweenService:Create(v66, TweenInfo.new(0.1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out, 0, false), {
        Scale = 0.9
    }):Play();
end;

function u1.ButtonUp(p67) -- Line: 517
    -- upvalues: InsMgr (copy), TweenService (copy)
    local v68 = InsMgr.GetIns("按钮缩放动画", "UIScale", p67);
    v68.Scale = 0.9;
    TweenService:Create(v68, TweenInfo.new(0.1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out, 0, false), {
        Scale = 1
    }):Play();
end;

function u1.BtnScaleAnimEnter(p69) -- Line: 536
    -- upvalues: InsMgr (copy), TweenService (copy)
    local v70 = InsMgr.GetIns("按钮缩放动画", "UIScale", p69);
    v70.Scale = 1;
    TweenService:Create(v70, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false), {
        Scale = 1.1
    }):Play();
end;

function u1.BtnScaleAnimLeave(p71) -- Line: 554
    -- upvalues: InsMgr (copy), TweenService (copy)
    TweenService:Create(InsMgr.GetIns("按钮缩放动画", "UIScale", p71), TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false), {
        Scale = 1
    }):Play();
end;

function u1.BtnIconHoverEnter(p72, p73) -- Line: 572
    -- upvalues: InsMgr (copy), TweenService (copy)
    local v74 = InsMgr.GetIns("按钮缩放动画", "UIScale", p72);
    v74.Scale = 1;
    TweenService:Create(v74, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false), {
        Scale = p73 or 1.2
    }):Play();
end;

function u1.BtnIconHoverLeave(p75) -- Line: 591
    -- upvalues: InsMgr (copy), TweenService (copy)
    TweenService:Create(InsMgr.GetIns("按钮缩放动画", "UIScale", p75), TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false), {
        Scale = 1
    }):Play();
end;

local function _isRedPointAnimActive(p76, p77) -- Line: 610
    -- upvalues: u5 (copy)
    local v78;

    if u5[p76] == p77 and p76.Parent ~= nil then
        v78 = p76.Visible;
    else
        v78 = false;
    end;

    return v78;
end;

local function _tweenRedPointRotation(p79, p80, p81) -- Line: 622
    -- upvalues: u5 (copy), TweenService (copy), u6 (copy)
    local v82;

    if u5[p79] == p81 and p79.Parent ~= nil then
        v82 = p79.Visible;
    else
        v82 = false;
    end;

    if not v82 then
        return false;
    end;

    local v83 = TweenService:Create(p79, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Rotation = p80
    });
    u6[p79] = v83;
    v83:Play();
    v83.Completed:Wait();

    if u6[p79] == v83 then
        u6[p79] = nil;
    end;

    local v84;

    if u5[p79] == p81 and p79.Parent ~= nil then
        v84 = p79.Visible;
    else
        v84 = false;
    end;

    return v84;
end;

function u1.StopRedPointAnim(p85) -- Line: 646
    -- upvalues: u5 (copy), u6 (copy)
    u5[p85] = (u5[p85] or 0) + 1;
    local v86 = u6[p85];

    if v86 then
        v86:Cancel();
        u6[p85] = nil;
    end;

    p85.Rotation = 0;
end;

function u1.RedPointAnim(u87) -- Line: 662
    -- upvalues: u1 (copy), u5 (copy), _tweenRedPointRotation (copy)
    u1.StopRedPointAnim(u87);
    local u88 = u5[u87];
    task.spawn(function() -- Line: 666
        -- upvalues: u87 (copy), u88 (copy), u5 (ref), _tweenRedPointRotation (ref)
        while true do
            local v89 = u87;
            local v90;

            if u88 == u5[v89] and v89.Parent ~= nil then
                v90 = v89.Visible;
            else
                v90 = false;
            end;

            if not v90 then
                if u5[u87] == u88 then
                    u87.Rotation = 0;
                end;

                return;
            end;

            for _ = 1, 2 do
                if not _tweenRedPointRotation(u87, -30, u88) then
                    return;
                end;

                if not _tweenRedPointRotation(u87, 30, u88) then
                    return;
                end;
            end;

            if not _tweenRedPointRotation(u87, 0, u88) then
                return;
            end;

            local v91 = os.clock() + 1;

            while os.clock() < v91 do
                local v92 = u87;
                local v93;

                if u88 == u5[v92] and v92.Parent ~= nil then
                    v93 = v92.Visible;
                else
                    v93 = false;
                end;

                if not v93 then
                    u87.Rotation = 0;

                    return;
                end;

                task.wait(0.05);
            end;
        end;
    end);
end;

function u1.StopRedPointScaleAnim(p94) -- Line: 702
    -- upvalues: u7 (copy)
    local v95 = u7[p94];

    if v95 then
        v95:Cancel();
        u7[p94] = nil;
    end;

    local UIScale = p94:FindFirstChild("UIScale");

    if UIScale and UIScale:IsA("UIScale") then
        UIScale.Scale = 1;
    end;
end;

function u1.RedPointScaleAnim(p96) -- Line: 720
    -- upvalues: u1 (copy), TweenService (copy), u2 (copy), u7 (copy)
    u1.StopRedPointScaleAnim(p96);
    local UIScale = p96:FindFirstChild("UIScale");

    if not (UIScale and UIScale:IsA("UIScale")) then
        UIScale = Instance.new("UIScale");
        UIScale.Name = "UIScale";
        UIScale.Scale = 1;
        UIScale.Parent = p96;
    end;

    UIScale.Scale = 1;
    local v97 = TweenService:Create(UIScale, u2, {
        Scale = 1.2
    });
    u7[p96] = v97;
    v97:Play();
end;

function u1.shakeUI(p98) -- Line: 740
    -- upvalues: _ensureScaleValues (copy), InsMgr (copy), TweenService (copy)
    _ensureScaleValues(p98);
    local v99 = InsMgr.GetIns("scaleValueX", "Vector3Value", p98);
    local v100 = InsMgr.GetIns("scaleValueY", "Vector3Value", p98);
    local v101 = UDim2.new(v99.Value.X, v99.Value.Y, v100.Value.X, v100.Value.Y);
    p98.Size = v101;
    local v102 = UDim2.new(v101.X.Scale * 1.1, v101.X.Offset * 1.1, v101.Y.Scale * 1.1, v101.Y.Offset * 1.1);
    local v103 = TweenService:Create(p98, TweenInfo.new(0.05, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = v102
    });
    local u104 = TweenService:Create(p98, TweenInfo.new(0.05, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = v101
    });
    local u105 = nil;
    u105 = v103.Completed:Connect(function() -- Line: 767
        -- upvalues: u105 (ref), u104 (copy)
        if u105 then
            u105:Disconnect();
            u105 = nil;
        end;

        u104:Play();
    end);
    v103:Play();
end;

function u1.PopDownShow(p106) -- Line: 783
    -- upvalues: TweenService (copy)
    p106.Visible = true;
    local Scale = p106.Size.Y.Scale;
    local v107 = UDim2.new(0.5, 0, 0, 0);
    p106.Position = UDim2.new(v107.X.Scale, v107.X.Offset, v107.Y.Scale - Scale, v107.Y.Offset);
    local v108 = TweenService:Create(p106, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = v107
    });
    v108:Play();

    return v108;
end;

function u1.PopUpDispear(u109) -- Line: 806
    -- upvalues: TweenService (copy)
    local v110 = UDim2.new(0.5, 0, 0, 0);
    local Scale = u109.Size.Y.Scale;
    local v111 = TweenService:Create(u109, TweenInfo.new(0.5), {
        Position = UDim2.new(v110.X.Scale, v110.X.Offset, v110.Y.Scale - Scale, v110.Y.Offset)
    });
    v111:Play();
    local u112 = nil;
    u112 = v111.Completed:Connect(function() -- Line: 816
        -- upvalues: u112 (ref), u109 (copy)
        if u112 then
            u112:Disconnect();
            u112 = nil;
        end;

        u109.Visible = false;
    end);

    return v111;
end;

function u1.GetItemAnimation(p113, p114, u115) -- Line: 834
    -- upvalues: CfgFind (copy), _getScreenGuiScale (copy), UIanima (copy), UtilsSystem (copy), MathMgr (copy), EnumMgr (copy), TweenService (copy), Debris (copy), u1 (copy)
    local v116 = p114 or 1;
    local v117 = CfgFind.FindCfgByID(p113);

    if not v117 then
        return;
    end;

    local v118, u119 = _getScreenGuiScale();

    if not v118 then
        return;
    end;

    local v120 = UIanima:FindFirstChild("获取物品动画");

    if not v120 then
        return;
    end;

    local u121 = v120:Clone();
    local v122 = u121:FindFirstChild("物品数量");

    if v122 and v122:IsA("GuiObject") then
        local UIMgr = UtilsSystem.UIMgr;

        if UIMgr then
            UIMgr.AddGradientColor(v117.xyd, v122);
        end;

        if v122:IsA("TextLabel") or v122:IsA("TextButton") then
            v122.Text = "+" .. MathMgr.getNumStr((math.floor(v116)));
        end;

        local Icon = v117.Icon;

        if Icon then
            local v123 = v122:FindFirstChild("物品图片");

            if v123 and v123:IsA("ImageLabel") then
                v123.Image = "rbxassetid://" .. Icon;
            end;
        end;
    end;

    local v124 = UDim2.new(0.5, 0, 0.3, 0) + UDim2.new(0.2 * (1 - 2 * math.random()), 0, 0.2 * (1 - 2 * math.random()), 0);
    u121.Size = UDim2.new(0, 1, 0, 1);
    u121.Position = v124;
    u121.Parent = v118;
    local v125 = UDim2.new(0, 150, 0, 150);

    if p113 == EnumMgr.ItemID.Coin then
        v125 = UDim2.new(0, 100, 0, 100);
    end;

    local v126 = TweenService:Create(u121, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = v125
    });
    local u127 = nil;
    u127 = v126.Completed:Connect(function() -- Line: 890
        -- upvalues: u127 (ref), u115 (copy), u119 (copy), TweenService (ref), u121 (copy), Debris (ref), u1 (ref)
        if u127 then
            u127:Disconnect();
            u127 = nil;
        end;

        local v128 = UDim2.new(0, (u115.AbsolutePosition.X + 3 * u115.AbsoluteSize.X / 4) / u119, 0, (u115.AbsolutePosition.Y + 3 * u115.AbsoluteSize.Y / 4) / u119);
        local v129 = TweenService:Create(u121, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 1, 0, 1)
        });
        local v130 = TweenService:Create(u121, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = v128
        });
        local u131 = nil;
        u131 = v129.Completed:Connect(function() -- Line: 912
            -- upvalues: u131 (ref), Debris (ref), u121 (ref)
            if u131 then
                u131:Disconnect();
                u131 = nil;
            end;

            Debris:AddItem(u121, 0);
        end);
        local u132 = nil;
        u132 = v130.Completed:Connect(function() -- Line: 921
            -- upvalues: u132 (ref), u1 (ref), u115 (ref)
            if u132 then
                u132:Disconnect();
                u132 = nil;
            end;

            u1.shakeUI(u115);
        end);
        v130:Play();
        v129:Play();
    end);
    v126:Play();
end;

function u1.UIScaleOut(u133, p134) -- Line: 941
    -- upvalues: u9 (copy), u8 (copy), TweenService (copy)
    local v135 = u9[u133];

    if v135 then
        v135:Disconnect();
        u9[u133] = nil;
    end;

    local v136 = u8[u133];

    if v136 then
        v136:Cancel();
        u8[u133] = nil;
    end;

    u133.Visible = true;
    local UIScale = u133:FindFirstChild("UIScale");

    if not (UIScale and UIScale:IsA("UIScale")) then
        UIScale = Instance.new("UIScale");
        UIScale.Name = "UIScale";
        UIScale.Scale = 0;
        UIScale.Parent = u133;
    end;

    UIScale.Scale = 0;
    local v137 = UIScale:GetAttribute("PopScale") or 1;
    local u138 = TweenService:Create(UIScale, TweenInfo.new(p134 or 0.1), {
        Scale = v137
    });
    u8[u133] = u138;
    local u139 = nil;
    u139 = u138.Completed:Connect(function() -- Line: 955
        -- upvalues: u9 (ref), u133 (copy), u139 (ref), u8 (ref), u138 (copy)
        if u9[u133] == u139 then
            u9[u133] = nil;
        end;

        if u139 then
            u139:Disconnect();
            u139 = nil;
        end;

        if u8[u133] == u138 then
            u8[u133] = nil;
        end;
    end);
    u9[u133] = u139;
    u138:Play();
end;

function u1.SetViewportItemHoverEffect(u140, p141, p142) -- Line: 983
    -- upvalues: TweenService (copy), u4 (copy), CfgFind (copy), EnumMgr (copy), _getViewportHoverModel (copy), _buildWeaponHoverSnapshot (copy), RunService (copy), u10 (copy), _applyWeaponRigidTwistAroundAxis (copy), u3 (copy)
    if not (u140 and u140:IsA("GuiObject")) then
        return;
    end;

    local u143 = (u140:FindFirstChild("Frame") or u140):FindFirstChildOfClass("ViewportFrame") or u140:FindFirstChildOfClass("ViewportFrame");

    if not u143 and u140:IsA("ViewportFrame") then
        u143 = u140;
    end;

    if not u143 then
        return;
    end;

    local v144 = (type(p142) ~= "number" or (p142 <= 0 or not p142)) and 1.05 or p142;
    local v145 = u140:FindFirstChildOfClass("UIScale");

    if not v145 then
        v145 = Instance.new("UIScale");
        v145.Scale = 1;
        v145.Parent = u140;
    end;

    local v146 = u143;
    local v147 = v146:FindFirstChildOfClass("UIScale");

    if not v147 then
        v147 = Instance.new("UIScale");
        v147.Scale = 1;
        v147.Parent = v146;
    end;

    local Parent = u143.Parent;

    if Parent then
        Parent = Parent:FindFirstChild(u143.Name .. "Shadow");
    end;

    local v148;

    if Parent then
        v148 = Parent:FindFirstChildOfClass("UIScale");

        if not v148 then
            v148 = Instance.new("UIScale");
            v148.Scale = 1;
            v148.Parent = Parent;
        end;
    else
        v148 = nil;
    end;

    if p141 then
        TweenService:Create(v145, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = v144
        }):Play();
        TweenService:Create(v147, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = 1.1
        }):Play();

        if v148 then
            TweenService:Create(v148, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Scale = 1.1
            }):Play();
        end;

        local LightColor = u143.LightColor;
        local v149 = u143:GetAttribute("hover_color") or u4;
        u143.LightColor = v149;
        local v150;

        if Parent then
            v150 = Parent.LightColor or nil;
        else
            v150 = nil;
        end;

        if Parent then
            Parent.LightColor = v149;
        end;

        local v151 = tonumber(u143:GetAttribute("ID"));
        local u152;

        if v151 and v151 ~= 0 then
            u152 = CfgFind.FindCfgByID(v151, EnumMgr.ItemType.Weapon) and true or CfgFind.GetCfgByNameAndID("weaponConf", v151) ~= nil;
        else
            u152 = false;
        end;

        local v153 = tonumber(u143:GetAttribute("ID"));
        local u154;

        if v153 and v153 ~= 0 then
            local v155 = CfgFind.FindCfgByID(v153, EnumMgr.ItemType.Broom);

            if v155 == nil then
                u154 = false;
            else
                u154 = tonumber(v155.tp) == EnumMgr.ItemType.Broom;
            end;
        else
            u154 = false;
        end;

        local u156 = _getViewportHoverModel(u143);

        if not u156 then
            u143.LightColor = LightColor;

            if Parent and v150 then
                Parent.LightColor = v150;
            end;

            return;
        end;

        local u157;

        if Parent then
            u157 = _getViewportHoverModel(Parent) or nil;
        else
            u157 = nil;
        end;

        local u158 = u156:GetPivot();
        local u159;

        if u157 then
            u159 = u157:GetPivot() or nil;
        else
            u159 = nil;
        end;

        local u160, u161, v162 = _buildWeaponHoverSnapshot(u156);
        local u163 = v162;

        if u152 and (u160 ~= nil and (u161 ~= nil and v162 ~= nil)) then
            local CurrentCamera = u143.CurrentCamera;
            local v164;

            if CurrentCamera and CurrentCamera.CFrame.LookVector.Magnitude >= 0.0001 then
                local Unit = CurrentCamera.CFrame.LookVector.Unit;
                local UpVector = CurrentCamera.CFrame.UpVector;

                if UpVector.Magnitude < 1e-6 then
                    v164 = nil;
                else
                    local Unit2 = UpVector.Unit;

                    if Unit.Magnitude >= 1e-6 then
                        local Unit3 = Unit.Unit;
                        local v165 = Unit3:Dot(Unit2);
                        Unit2 = Unit2 * 1 + Unit3:Cross(Unit2) * -0 + Unit3 * v165 * 0;
                    end;

                    if Unit2.Magnitude < 1e-6 then
                        v164 = nil;
                    else
                        v164 = Unit2.Unit;
                    end;
                end;
            else
                v164 = nil;
            end;

            u163 = v164 or u163;
        end;

        if u152 then
            if u160 == nil or u161 == nil then
                u152 = false;
            else
                u152 = u163 ~= nil;
            end;
        end;

        local u166 = nil;

        if u152 and u157 then
            local v167, v168 = _buildWeaponHoverSnapshot(u157);
            u166 = v167 and v168 and {
                pivotPos = v167,
                partBases = v168
            } or u166;
        end;

        local u169 = 0;
        local u170 = nil;
        u170 = RunService.Heartbeat:Connect(function(p171) -- Line: 1076
            -- upvalues: u143 (ref), u156 (copy), u170 (ref), u10 (ref), u140 (copy), u169 (ref), u152 (copy), u161 (copy), u160 (copy), u163 (ref), _applyWeaponRigidTwistAroundAxis (ref), u166 (ref), Parent (copy), u157 (copy), u159 (copy), u158 (copy), u154 (copy)
            if not (u143.Parent and u156.Parent) then
                if u170 then
                    u170:Disconnect();
                end;

                u10[u140] = nil;

                return;
            end;

            u169 = u169 + 45 * p171;
            local v172 = math.rad(u169);

            if u152 and (u161 and (u160 and u163)) then
                _applyWeaponRigidTwistAroundAxis(u161, u160, u163, v172);

                if u166 and Parent then
                    _applyWeaponRigidTwistAroundAxis(u166.partBases, u166.pivotPos, u163, v172);

                    return;
                end;

                if u157 and (u157.Parent and u159) then
                    u157:PivotTo(u159 * CFrame.Angles(0, v172, 0));
                end;
            else
                local v173 = u158;
                local v174;

                if u154 then
                    v174 = v173 * CFrame.Angles(0, 0, v172);
                else
                    v174 = v173 * CFrame.Angles(0, v172, 0);
                end;

                u156:PivotTo(v174);

                if u157 and (u157.Parent and u159) then
                    local v175 = u159;
                    local v176;

                    if u154 then
                        v176 = v175 * CFrame.Angles(0, 0, v172);
                    else
                        v176 = v175 * CFrame.Angles(0, v172, 0);
                    end;

                    u157:PivotTo(v176);
                end;
            end;
        end);
        local v177 = {
            connection = u170,
            oriLightColor = LightColor,
            shadowFrame = Parent,
            shadowOriLightColor = v150
        };

        if u152 then
            u158 = nil;
        end;

        v177.basePivot = u158;

        if u152 then
            u159 = nil;
        end;

        v177.shadowBasePivot = u159;
        v177.weaponMode = u152;
        v177.mainPartBases = u152 and u161 and u161 or nil;
        v177.shadowPartBases = u166 and u166.partBases or nil;
        v177.pivotPos = u152 and u160 and u160 or nil;
        u10[u140] = v177;
    else
        TweenService:Create(v145, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play();
        TweenService:Create(v147, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play();

        if v148 then
            TweenService:Create(v148, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Scale = 1
            }):Play();
        end;

        local v178 = u10[u140];

        if v178 then
            u143.LightColor = v178.oriLightColor or u3;

            if v178.shadowFrame and (v178.shadowFrame.Parent and v178.shadowOriLightColor) then
                v178.shadowFrame.LightColor = v178.shadowOriLightColor;
            end;

            if v178.connection then
                v178.connection:Disconnect();
            end;

            local v179 = _getViewportHoverModel(u143);

            if v178.weaponMode and v178.mainPartBases then
                for i, v in v178.mainPartBases do
                    if i.Parent then
                        i.CFrame = v;
                    end;
                end;

                if v178.shadowPartBases then
                    for i, v in v178.shadowPartBases do
                        if i.Parent then
                            i.CFrame = v;
                        end;
                    end;
                end;
            else
                if v179 and (v179.Parent and v178.basePivot) then
                    v179:PivotTo(v178.basePivot);
                end;

                if v178.shadowFrame and (v178.shadowFrame.Parent and v178.shadowBasePivot) then
                    local v180 = _getViewportHoverModel(v178.shadowFrame);

                    if v180 and v180.Parent then
                        v180:PivotTo(v178.shadowBasePivot);
                    end;
                end;
            end;

            u10[u140] = nil;
        else
            u143.LightColor = u3;

            if Parent and Parent.Parent then
                Parent.LightColor = u3;
            end;
        end;
    end;
end;

local u181 = { { 0.04, 36, -0.05, -28 }, { -0.04, -36, -0.05, -28 }, { 0.04, 36, 0.05, 28 }, { -0.04, -36, 0.05, 28 }, { 0, 0, -0.07, -42 }, { 0, 0, 0.07, 42 } };

local function _findFloatPopCanvasGroup(p182) -- Line: 1203
    local v183 = p182:FindFirstChildWhichIsA("CanvasGroup", true);

    if v183 and v183:IsA("CanvasGroup") then
        return v183;
    end;

    return nil;
end;

function u1.PlayFrameFloatPop(u184, p185) -- Line: 1219
    -- upvalues: u181 (copy), TweenService (copy), Debris (copy)
    if not (u184 and u184.Parent) then
        return nil;
    end;

    local Parent = u184.Parent;
    local v186 = p185 and (p185.holdSec or 0.5) or 0.5;
    local u187 = p185 and (p185.fadeSec or 0.25) or 0.25;
    local v188 = p185 and (p185.startScale or 1.35) or 1.35;
    local v189 = p185 and p185.goalSize or u184.Size;
    local v190 = p185 and (p185.goalOffsetScaleX or 0) or 0;
    local v191 = p185 and (p185.goalOffsetPxX or 0) or 0;
    local v192 = p185 and (p185.goalOffsetScaleY or 0) or 0;
    local v193 = p185 and (p185.goalOffsetPxY or 0) or 0;
    local v194 = p185 == nil and true or p185.randomDirection ~= false;
    local v195 = p185 == nil and true or p185.autoDestroy ~= false;
    local u196 = u184:FindFirstChildWhichIsA("CanvasGroup", true);

    if not (u196 and u196:IsA("CanvasGroup")) then
        u196 = nil;
    end;

    if u196 then
        u196.GroupTransparency = 0;
    end;

    if v194 then
        local v197 = u181[math.random(1, #u181)];
        v190 = v197[1];
        v191 = v197[2];
        v192 = v197[3];
        v193 = v197[4];
    end;

    u184.Size = UDim2.new(v189.X.Scale * v188, v189.X.Offset * v188, v189.Y.Scale * v188, v189.Y.Offset * v188);
    local AbsoluteSize = Parent.AbsoluteSize;
    local v198 = v190 * math.max(AbsoluteSize.X, 1) + v191;
    local v199 = v192 * math.max(AbsoluteSize.Y, 1) + v193;
    local v200 = UDim2.new(u184.Position.X.Scale, u184.Position.X.Offset + v198, u184.Position.Y.Scale, u184.Position.Y.Offset + v199);
    TweenService:Create(u184, TweenInfo.new(v186 + u187, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = v200,
        Size = v189
    }):Play();
    task.delay(v186, function() -- Line: 1268
        -- upvalues: u184 (copy), u187 (copy), u196 (copy), TweenService (ref)
        if not u184.Parent then
            return;
        end;

        local v201 = TweenInfo.new(u187, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

        if u196 and u196.Parent then
            TweenService:Create(u196, v201, {
                GroupTransparency = 1
            }):Play();

            return;
        end;

        for _, descendant in u184:GetDescendants() do
            if descendant:IsA("TextLabel") then
                TweenService:Create(descendant, v201, {
                    BackgroundTransparency = 1,
                    TextTransparency = 1
                }):Play();
            elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
                TweenService:Create(descendant, v201, {
                    BackgroundTransparency = 1,
                    ImageTransparency = 1
                }):Play();
            elseif descendant:IsA("GuiObject") then
                TweenService:Create(descendant, v201, {
                    BackgroundTransparency = 1
                }):Play();
            end;
        end;
    end);

    if v195 then
        Debris:AddItem(u184, v186 + u187 + 0.15);
    end;

    return u184;
end;

return u1;