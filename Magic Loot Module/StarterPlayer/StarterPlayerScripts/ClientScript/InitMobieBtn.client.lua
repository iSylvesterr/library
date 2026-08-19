-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local AssetAcquire = UtilsSystem.AssetAcquire;
local EnumMgr = UtilsSystem.EnumMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local UIMgr = UtilsSystem.UIMgr;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", (1 / 0));
local u1 = false;
local u2 = false;
local u3 = nil;
local u4 = {};
local u5 = {};

local function _isOnBroom() -- Line: 70
    -- upvalues: LocalPlayer (copy)
    local v6 = LocalPlayer:FindFirstChild("飞行状态");
    local v7;

    if v6 == nil then
        v7 = false;
    else
        v7 = v6:IsA("BoolValue") and v6.Value == true;
    end;

    return v7;
end;

local function _hasAnyBroom() -- Line: 80
    -- upvalues: PlayerData (copy), LocalPlayer (copy), EnumMgr (copy)
    local v8 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

    if type(v8) ~= "table" then
        return false;
    end;

    local Broom = EnumMgr.ItemType.Broom;

    for _, v in pairs(v8) do
        if type(v) == "table" and (tonumber(v.tp) == Broom and (tonumber(v.count) or 0) > 0) then
            return true;
        end;
    end;

    return false;
end;

local function _toggleBroom() -- Line: 101
    -- upvalues: _hasAnyBroom (copy), LocalPlayer (copy), SystemGameConfig (copy), NetWork (copy), NetMsg (copy), Log (copy)
    if not _hasAnyBroom() then
        return;
    end;

    local v9 = LocalPlayer:FindFirstChild("飞行状态");
    local v10;

    if v9 == nil then
        v10 = false;
    else
        v10 = v9:IsA("BoolValue") and v9.Value == true;
    end;

    if not v10 and SystemGameConfig.GetValue({ "Broom", "启用" }) == false then
        return;
    end;

    local v11 = LocalPlayer:FindFirstChild("飞行状态");
    local v12;

    if v11 == nil then
        v12 = false;
    else
        v12 = v11:IsA("BoolValue") and v11.Value == true;
    end;

    if v12 then
        local StageJumping = LocalPlayer:FindFirstChild("StageJumping");

        if StageJumping and (StageJumping:IsA("NumberValue") and StageJumping.Value > 0) then
            return;
        end;
    end;

    task.spawn(function() -- Line: 115
        -- upvalues: NetWork (ref), NetMsg (ref), Log (ref)
        local success, result = pcall(function() -- Line: 116
            -- upvalues: NetWork (ref), NetMsg (ref)
            NetWork.InvokeServer(NetMsg.TOGGLE_BROOM);
        end);

        if not success then
            Log.warn("[InitMobieBtn] TOGGLE_BROOM failed:", result);
        end;
    end);
end;

local function _disconnectLayout() -- Line: 130
    -- upvalues: u4 (copy)
    for i = #u4, 1, -1 do
        local v13 = u4[i];

        if v13 then
            v13:Disconnect();
        end;

        u4[i] = nil;
    end;
end;

local function _disconnectClick() -- Line: 145
    -- upvalues: AddListen (copy), u5 (copy)
    AddListen.DisconnectAll(u5);
end;

local function _layoutBesideJump(u14, u15) -- Line: 156
    -- upvalues: u4 (copy)
    u14.AnchorPoint = u15.AnchorPoint;

    local function updateLayout() -- Line: 159
        -- upvalues: u14 (copy), u15 (copy)
        if not (u14.Parent and u15.Parent) then
            return;
        end;

        local AbsoluteSize = u15.AbsoluteSize;

        if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
            return;
        end;

        u14.Size = UDim2.fromOffset(AbsoluteSize.X * 0.7142857142857143, AbsoluteSize.Y * 0.7142857142857143);
        local Position = u15.Position;
        u14.Position = UDim2.new(Position.X.Scale, Position.X.Offset - AbsoluteSize.X * 0.6428571428571429, Position.Y.Scale, Position.Y.Offset - AbsoluteSize.Y * 0.6428571428571429);
    end;

    for i = #u4, 1, -1 do
        local v16 = u4[i];

        if v16 then
            v16:Disconnect();
        end;

        u4[i] = nil;
    end;

    updateLayout();
    local v17 = u15:GetPropertyChangedSignal("AbsoluteSize");
    table.insert(u4, v17:Connect(updateLayout));
    local v18 = u15:GetPropertyChangedSignal("AbsolutePosition");
    table.insert(u4, v18:Connect(updateLayout));
    local v19 = u15:GetPropertyChangedSignal("Position");
    table.insert(u4, v19:Connect(updateLayout));
    local v20 = u15:GetPropertyChangedSignal("AnchorPoint");
    table.insert(u4, v20:Connect(updateLayout));
    task.defer(updateLayout);
end;

local function _resolveClickTarget(p21) -- Line: 198
    -- upvalues: UIMgr (copy)
    if p21:IsA("GuiButton") then
        return p21, p21;
    end;

    local v22 = p21:IsA("GuiObject") and UIMgr.FindButtonInFrame(p21);

    if v22 then
        return v22, p21;
    end;

    return nil, nil;
end;

local function _bindClick(p23) -- Line: 217
    -- upvalues: AddListen (copy), u5 (copy), UIMgr (copy), Log (copy), _toggleBroom (copy)
    AddListen.DisconnectAll(u5);
    local v24;

    if p23:IsA("GuiButton") then
        v24 = p23;
    else
        v24 = p23:IsA("GuiObject") and UIMgr.FindButtonInFrame(p23);

        if not v24 then
            v24 = nil;
            p23 = nil;
        end;
    end;

    if not v24 then
        Log.warn("[InitMobieBtn] BroomBtn 无可点击 GuiButton");

        return;
    end;

    if not v24:IsA("ImageButton") then
        table.insert(u5, v24.Activated:Connect(_toggleBroom));

        return;
    end;

    local v25 = AddListen.AddMouseCLick(v24, _toggleBroom, p23);

    for _, v in ipairs(v25) do
        table.insert(u5, v);
    end;
end;

local function _hideBroomBtn(p26) -- Line: 240
    -- upvalues: AddListen (copy), u5 (copy), u4 (copy)
    local BroomBtn = p26:FindFirstChild("BroomBtn");

    if BroomBtn and BroomBtn:IsA("GuiObject") then
        BroomBtn.Visible = false;
    end;

    AddListen.DisconnectAll(u5);

    for i = #u4, 1, -1 do
        local v27 = u4[i];

        if v27 then
            v27:Disconnect();
        end;

        u4[i] = nil;
    end;
end;

local function _showBroomBtn(p28) -- Line: 255
    -- upvalues: _layoutBesideJump (copy), _bindClick (copy), AssetAcquire (copy), Log (copy)
    local Parent = p28.Parent;

    if not Parent then
        return;
    end;

    local BroomBtn = Parent:FindFirstChild("BroomBtn");

    if BroomBtn and BroomBtn:IsA("GuiObject") then
        BroomBtn.Visible = true;
        _layoutBesideJump(BroomBtn, p28);
        _bindClick(BroomBtn);

        return;
    end;

    local v29 = AssetAcquire.GetUI("BroomBtn");

    if not v29 then
        Log.warn("[InitMobieBtn] 未找到资源 UI/BroomBtn");

        return;
    end;

    v29.Name = "BroomBtn";

    if v29:IsA("GuiObject") then
        v29.Visible = true;
    end;

    v29.Parent = Parent;

    if v29:IsA("GuiObject") then
        _layoutBesideJump(v29, p28);
    end;

    _bindClick(v29);
end;

local function _refreshBroomBtn() -- Line: 290
    -- upvalues: u3 (ref), _hasAnyBroom (copy), _showBroomBtn (copy), AddListen (copy), u5 (copy), u4 (copy)
    local v30 = u3;

    if not (v30 and v30.Parent) then
        return;
    end;

    local Parent = v30.Parent;

    if not Parent then
        return;
    end;

    if _hasAnyBroom() then
        _showBroomBtn(v30);

        return;
    end;

    local BroomBtn = Parent:FindFirstChild("BroomBtn");

    if BroomBtn and BroomBtn:IsA("GuiObject") then
        BroomBtn.Visible = false;
    end;

    AddListen.DisconnectAll(u5);

    for i = #u4, 1, -1 do
        local v31 = u4[i];

        if v31 then
            v31:Disconnect();
        end;

        u4[i] = nil;
    end;
end;

local function _bindBagWatch() -- Line: 311
    -- upvalues: u2 (ref), PlayerData (copy), u3 (ref), _hasAnyBroom (copy), _showBroomBtn (copy), AddListen (copy), u5 (copy), u4 (copy)
    if u2 then
        return;
    end;

    u2 = true;
    PlayerData.ListenClientSync(function(p32, p33) -- Line: 316
        -- upvalues: u3 (ref), _hasAnyBroom (ref), _showBroomBtn (ref), AddListen (ref), u5 (ref), u4 (ref)
        if p32 == nil then
            local v34 = u3;

            if v34 then
                if not v34.Parent then
                    return;
                end;

                local Parent = v34.Parent;

                if not Parent then
                    return;
                end;

                if _hasAnyBroom() then
                    _showBroomBtn(v34);

                    return;
                end;

                local BroomBtn = Parent:FindFirstChild("BroomBtn");

                if BroomBtn and BroomBtn:IsA("GuiObject") then
                    BroomBtn.Visible = false;
                end;

                AddListen.DisconnectAll(u5);

                for i = #u4, 1, -1 do
                    local v35 = u4[i];

                    if v35 then
                        v35:Disconnect();
                    end;

                    u4[i] = nil;
                end;
            end;

            return;
        end;

        if type(p32) == "table" then
            p32 = p32[1];
        end;

        local v36 = p32 == "Bag" and u3;

        if v36 then
            if not v36.Parent then
                return;
            end;

            local Parent = v36.Parent;

            if not Parent then
                return;
            end;

            if _hasAnyBroom() then
                _showBroomBtn(v36);

                return;
            end;

            local BroomBtn = Parent:FindFirstChild("BroomBtn");

            if BroomBtn and BroomBtn:IsA("GuiObject") then
                BroomBtn.Visible = false;
            end;

            AddListen.DisconnectAll(u5);

            for i = #u4, 1, -1 do
                local v37 = u4[i];

                if v37 then
                    v37:Disconnect();
                end;

                u4[i] = nil;
            end;
        end;
    end);
end;

local function _setupFromTouchGui(u38) -- Line: 334
    -- upvalues: Log (copy), u3 (ref), u2 (ref), PlayerData (copy), _hasAnyBroom (copy), _showBroomBtn (copy), AddListen (copy), u5 (copy), u4 (copy)
    if u38:GetAttribute("InitMobieBtnSetup") == true then
        return;
    end;

    u38:SetAttribute("InitMobieBtnSetup", true);
    task.spawn(function() -- Line: 340
        -- upvalues: u38 (copy), Log (ref), u3 (ref), u2 (ref), PlayerData (ref), _hasAnyBroom (ref), _showBroomBtn (ref), AddListen (ref), u5 (ref), u4 (ref)
        local TouchControlFrame = u38:WaitForChild("TouchControlFrame", 30);

        if not TouchControlFrame then
            Log.warn("[InitMobieBtn] 未找到 TouchControlFrame");
            u38:SetAttribute("InitMobieBtnSetup", nil);

            return;
        end;

        local JumpButton = TouchControlFrame:FindFirstChild("JumpButton");

        if not (JumpButton and JumpButton:IsA("GuiObject")) then
            JumpButton = TouchControlFrame:WaitForChild("JumpButton", 30);
        end;

        if not (JumpButton and JumpButton:IsA("GuiObject")) then
            Log.warn("[InitMobieBtn] 未找到 JumpButton");
            u38:SetAttribute("InitMobieBtnSetup", nil);

            return;
        end;

        u3 = JumpButton;

        if not u2 then
            u2 = true;
            PlayerData.ListenClientSync(function(p39, p40) -- Line: 316
                -- upvalues: u3 (ref), _hasAnyBroom (ref), _showBroomBtn (ref), AddListen (ref), u5 (ref), u4 (ref)
                if p39 == nil then
                    local v41 = u3;

                    if v41 then
                        if not v41.Parent then
                            return;
                        end;

                        local Parent = v41.Parent;

                        if not Parent then
                            return;
                        end;

                        if _hasAnyBroom() then
                            _showBroomBtn(v41);

                            return;
                        end;

                        local BroomBtn = Parent:FindFirstChild("BroomBtn");

                        if BroomBtn and BroomBtn:IsA("GuiObject") then
                            BroomBtn.Visible = false;
                        end;

                        AddListen.DisconnectAll(u5);

                        for i = #u4, 1, -1 do
                            local v42 = u4[i];

                            if v42 then
                                v42:Disconnect();
                            end;

                            u4[i] = nil;
                        end;
                    end;

                    return;
                end;

                if type(p39) == "table" then
                    p39 = p39[1];
                end;

                local v43 = p39 == "Bag" and u3;

                if v43 then
                    if not v43.Parent then
                        return;
                    end;

                    local Parent = v43.Parent;

                    if not Parent then
                        return;
                    end;

                    if _hasAnyBroom() then
                        _showBroomBtn(v43);

                        return;
                    end;

                    local BroomBtn = Parent:FindFirstChild("BroomBtn");

                    if BroomBtn and BroomBtn:IsA("GuiObject") then
                        BroomBtn.Visible = false;
                    end;

                    AddListen.DisconnectAll(u5);

                    for i = #u4, 1, -1 do
                        local v44 = u4[i];

                        if v44 then
                            v44:Disconnect();
                        end;

                        u4[i] = nil;
                    end;
                end;
            end);
        end;

        local v45 = u3;

        if v45 and v45.Parent then
            local Parent = v45.Parent;

            if Parent then
                if _hasAnyBroom() then
                    _showBroomBtn(v45);
                else
                    local BroomBtn = Parent:FindFirstChild("BroomBtn");

                    if BroomBtn and BroomBtn:IsA("GuiObject") then
                        BroomBtn.Visible = false;
                    end;

                    AddListen.DisconnectAll(u5);

                    for i = #u4, 1, -1 do
                        local v46 = u4[i];

                        if v46 then
                            v46:Disconnect();
                        end;

                        u4[i] = nil;
                    end;
                end;
            end;
        end;

        TouchControlFrame.ChildAdded:Connect(function(p47) -- Line: 363
            -- upvalues: u3 (ref), _hasAnyBroom (ref), _showBroomBtn (ref), AddListen (ref), u5 (ref), u4 (ref)
            if p47.Name == "JumpButton" and p47:IsA("GuiObject") then
                u3 = p47;
                local v48 = u3;

                if v48 then
                    if not v48.Parent then
                        return;
                    end;

                    local Parent = v48.Parent;

                    if not Parent then
                        return;
                    end;

                    if _hasAnyBroom() then
                        _showBroomBtn(v48);

                        return;
                    end;

                    local BroomBtn = Parent:FindFirstChild("BroomBtn");

                    if BroomBtn and BroomBtn:IsA("GuiObject") then
                        BroomBtn.Visible = false;
                    end;

                    AddListen.DisconnectAll(u5);

                    for i = #u4, 1, -1 do
                        local v49 = u4[i];

                        if v49 then
                            v49:Disconnect();
                        end;

                        u4[i] = nil;
                    end;
                end;
            end;
        end);
    end);
end;

local function _init() -- Line: 377
    -- upvalues: u1 (ref), PlayerGui (copy), _setupFromTouchGui (copy)
    if u1 then
        return;
    end;

    u1 = true;
    local TouchGui = PlayerGui:FindFirstChild("TouchGui");

    if TouchGui then
        _setupFromTouchGui(TouchGui);
    end;

    PlayerGui.ChildAdded:Connect(function(p50) -- Line: 388
        -- upvalues: _setupFromTouchGui (ref)
        if p50.Name == "TouchGui" then
            _setupFromTouchGui(p50);
        end;
    end);
end;

if not u1 then
    u1 = true;
    local TouchGui = PlayerGui:FindFirstChild("TouchGui");

    if TouchGui then
        _setupFromTouchGui(TouchGui);
    end;

    PlayerGui.ChildAdded:Connect(function(p51) -- Line: 388
        -- upvalues: _setupFromTouchGui (copy)
        if p51.Name == "TouchGui" then
            _setupFromTouchGui(p51);
        end;
    end);
end;