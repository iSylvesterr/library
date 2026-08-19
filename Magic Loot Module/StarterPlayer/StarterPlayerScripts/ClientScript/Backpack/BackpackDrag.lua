-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local BackpackAllUI = require(script.Parent.BackpackAllUI);
local BackpackCore = require(script.Parent.BackpackCore);
local BackpackLock = require(script.Parent.BackpackLock);
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = {};
local u5 = {};
local u6 = false;
local zero = Vector2.zero;

local function _clearDrag() -- Line: 41
    -- upvalues: u4 (copy), u2 (ref), u3 (ref), u6 (ref)
    for _, v in u4 do
        v:Disconnect();
    end;

    table.clear(u4);

    if u2 then
        u2:Destroy();
        u2 = nil;
    end;

    u3 = nil;
    u6 = false;

    return nil;
end;

local function _getScreenUiScale() -- Line: 59
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return 1;
    end;

    local ScreenGui = PlayerGui:FindFirstChild("ScreenGui");

    if not (ScreenGui and ScreenGui:IsA("ScreenGui")) then
        return 1;
    end;

    local UIScale = ScreenGui:FindFirstChild("UIScale");

    return (not UIScale or (not UIScale:IsA("UIScale") or UIScale.Scale <= 0)) and 1 or UIScale.Scale;
end;

local function _createDragClone(p7) -- Line: 80
    -- upvalues: LocalPlayer (copy), _getScreenUiScale (copy), UserInputService (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return nil;
    end;

    local v8 = PlayerGui:FindFirstChild("ScreenGui") or PlayerGui;
    local v9 = _getScreenUiScale();
    local AbsoluteSize = p7.AbsoluteSize;
    local Frame = Instance.new("Frame");
    Frame.Name = "BackpackDragContainer";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromOffset(AbsoluteSize.X / v9, AbsoluteSize.Y / v9);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.ZIndex = 1000;
    Frame.Parent = v8;
    local v10 = p7:Clone();
    v10.Name = "DragClone";
    v10.AnchorPoint = Vector2.new(0.5, 0.5);
    v10.Size = UDim2.fromScale(1, 1);
    v10.Position = UDim2.fromScale(0.5, 0.5);
    v10.BackgroundTransparency = math.min(v10.BackgroundTransparency + 0.3, 0.85);
    v10.Visible = true;
    v10.Parent = Frame;

    for _, descendant in ipairs(v10:GetDescendants()) do
        if descendant:IsA("GuiButton") then
            descendant.AutoButtonColor = false;
            descendant.Active = false;
            descendant.Selectable = false;
        end;

        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            descendant.TextTransparency = 0.35;
        end;

        if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            descendant.ImageTransparency = math.min(descendant.ImageTransparency + 0.25, 0.7);
        end;
    end;

    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(255, 255, 0);
    UIStroke.Thickness = 3;
    UIStroke.Parent = v10;
    local v11 = UserInputService:GetMouseLocation();
    Frame.Position = UDim2.fromOffset(v11.X / v9, v11.Y / v9);

    return Frame;
end;

local function _commitDrag(p12) -- Line: 136
    -- upvalues: u3 (ref), BackpackCore (copy), NetWork (copy), NetMsg (copy), _clearDrag (copy)
    if not u3 then
        return nil;
    end;

    BackpackCore.applyOptimisticDrag(u3, p12);
    NetWork.FireServer(NetMsg.BACKPACK_TOOLBAR_DRAG, {
        from = u3,
        to = p12
    });
    _clearDrag();

    return nil;
end;

local function _isPointInGui(p13, p14) -- Line: 156
    local AbsolutePosition = p13.AbsolutePosition;
    local AbsoluteSize = p13.AbsoluteSize;
    local v15;

    if p14.X >= AbsolutePosition.X and (p14.X <= AbsolutePosition.X + AbsoluteSize.X and p14.Y >= AbsolutePosition.Y) then
        v15 = p14.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v15 = false;
    end;

    return v15;
end;

local function _resolveDropTarget(p16) -- Line: 171
    -- upvalues: BackpackCore (copy)
    for _, v in BackpackCore.getToolbarSlots() do
        if v.Visible then
            local AbsolutePosition = v.AbsolutePosition;
            local AbsoluteSize = v.AbsoluteSize;
            local v17;

            if p16.X >= AbsolutePosition.X and (p16.X <= AbsolutePosition.X + AbsoluteSize.X and p16.Y >= AbsolutePosition.Y) then
                v17 = p16.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
            else
                v17 = false;
            end;

            if v17 then
                local v18 = tonumber(v:GetAttribute("UiSlotIndex")) or 0;

                if v18 == 1 then
                    return nil;
                end;

                if v18 > 1 then
                    return {
                        zone = "toolbar",
                        equipSlot = v18
                    };
                end;
            end;
        end;
    end;

    for _, v in BackpackCore.getWarehouseSlotFrames() do
        local AbsolutePosition = v.AbsolutePosition;
        local AbsoluteSize = v.AbsoluteSize;
        local v19;

        if p16.X >= AbsolutePosition.X and (p16.X <= AbsolutePosition.X + AbsoluteSize.X and p16.Y >= AbsolutePosition.Y) then
            v19 = p16.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
        else
            v19 = false;
        end;

        if v19 then
            return {
                zone = "warehouse"
            };
        end;
    end;

    return BackpackCore.isWarehouseOpen() and {
        zone = "warehouse"
    } or nil;
end;

local function _updateDragClonePos() -- Line: 208
    -- upvalues: u2 (ref), _getScreenUiScale (copy), UserInputService (copy)
    if not u2 then
        return nil;
    end;

    local v20 = _getScreenUiScale();
    local v21 = UserInputService:GetMouseLocation();
    u2.Position = UDim2.fromOffset(v21.X / v20, v21.Y / v20);

    return nil;
end;

local function _startDragWatch(u22, p23) -- Line: 224
    -- upvalues: _clearDrag (copy), u3 (ref), zero (ref), UserInputService (copy), u6 (ref), u4 (copy), u2 (ref), _createDragClone (copy), _getScreenUiScale (copy), _resolveDropTarget (copy), _commitDrag (copy)
    _clearDrag();
    u3 = p23;
    zero = UserInputService:GetMouseLocation();
    u6 = false;
    table.insert(u4, UserInputService.InputChanged:Connect(function(p24) -- Line: 232
        -- upvalues: u6 (ref), zero (ref), u2 (ref), _createDragClone (ref), u22 (copy), _getScreenUiScale (ref), UserInputService (ref)
        if p24.UserInputType ~= Enum.UserInputType.MouseMovement and p24.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        local v25 = Vector2.new(p24.Position.X, p24.Position.Y);

        if not u6 then
            if (v25 - zero).Magnitude < 12 then
                return;
            end;

            u6 = true;
            u2 = _createDragClone(u22);
        end;

        if not u2 then
            return;
        end;

        local v26 = _getScreenUiScale();
        local v27 = UserInputService:GetMouseLocation();
        u2.Position = UDim2.fromOffset(v27.X / v26, v27.Y / v26);
    end));
    table.insert(u4, UserInputService.InputEnded:Connect(function(p28) -- Line: 252
        -- upvalues: u6 (ref), u3 (ref), _resolveDropTarget (ref), _commitDrag (ref), _clearDrag (ref)
        if p28.UserInputType ~= Enum.UserInputType.MouseButton1 and p28.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        local v29 = u6 and (u3 and _resolveDropTarget(Vector2.new(p28.Position.X, p28.Position.Y)));

        if v29 then
            _commitDrag(v29);

            return;
        end;

        _clearDrag();
    end));

    return nil;
end;

local function _bindDragBegin(p30, u31, u32, u33) -- Line: 279
    -- upvalues: BackpackCore (copy), BackpackLock (copy), PlayerData (copy), LocalPlayer (copy), GetData (copy), _startDragWatch (copy)
    return p30.InputBegan:Connect(function(p34, p35) -- Line: 285
        -- upvalues: u33 (copy), BackpackCore (ref), BackpackLock (ref), u32 (copy), PlayerData (ref), LocalPlayer (ref), GetData (ref), _startDragWatch (ref), u31 (copy)
        if p34.UserInputType ~= Enum.UserInputType.MouseButton1 and p34.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        if u33 and not BackpackCore.isWarehouseOpen() then
            return;
        end;

        if BackpackLock.isActive() then
            return;
        end;

        if u32.zone == "toolbar" and u32.equipSlot then
            local v36 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

            if type(v36) ~= "table" then
                return;
            end;

            if not GetData.GetBackpackToolbarItemAtUiSlot(v36, u32.equipSlot, LocalPlayer) then
                return;
            end;
        end;

        _startDragWatch(u31, u32);
    end);
end;

local function _bindToolbarDrag() -- Line: 318
    -- upvalues: BackpackCore (copy), BackpackAllUI (copy), BackpackLock (copy), PlayerData (copy), LocalPlayer (copy), GetData (copy), _startDragWatch (copy)
    for _, v in BackpackCore.getToolbarSlots() do
        local v37 = tonumber(v:GetAttribute("UiSlotIndex")) or 0;

        if v37 > 1 then
            local v38 = BackpackAllUI.findSlotButton(v, "toolbarDrag:" .. v37);

            if v38 then
                local u39 = {
                    zone = "toolbar",
                    equipSlot = v37
                };
                local u40 = true;
                v38.InputBegan:Connect(function(p41, p42) -- Line: 285
                    -- upvalues: u40 (copy), BackpackCore (ref), BackpackLock (ref), u39 (copy), PlayerData (ref), LocalPlayer (ref), GetData (ref), _startDragWatch (ref), v (copy)
                    if p41.UserInputType ~= Enum.UserInputType.MouseButton1 and p41.UserInputType ~= Enum.UserInputType.Touch then
                        return;
                    end;

                    if u40 and not BackpackCore.isWarehouseOpen() then
                        return;
                    end;

                    if BackpackLock.isActive() then
                        return;
                    end;

                    if u39.zone == "toolbar" and u39.equipSlot then
                        local v43 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

                        if type(v43) ~= "table" then
                            return;
                        end;

                        if not GetData.GetBackpackToolbarItemAtUiSlot(v43, u39.equipSlot, LocalPlayer) then
                            return;
                        end;
                    end;

                    _startDragWatch(v, u39);
                end);
            end;
        end;
    end;

    return nil;
end;

local function _unbindWarehouseDrag(p44) -- Line: 340
    -- upvalues: u5 (copy)
    local v45 = u5[p44];

    if v45 then
        if v45.Connected then
            v45:Disconnect();
        end;

        u5[p44] = nil;
    end;

    return nil;
end;

local function _bindWarehouseDragSlot(p46, u47) -- Line: 358
    -- upvalues: u5 (copy), BackpackAllUI (copy), BackpackCore (copy), BackpackLock (copy), PlayerData (copy), LocalPlayer (copy), GetData (copy), _startDragWatch (copy)
    local v48 = u5[p46];

    if v48 then
        if v48.Connected then
            v48:Disconnect();
        end;

        u5[p46] = nil;
    end;

    local v49 = BackpackAllUI.findSlotButton(u47, "warehouseDrag:" .. p46);

    if not v49 then
        return nil;
    end;

    local u50 = {
        zone = "warehouse",
        onlyID = p46
    };
    local u51 = nil;
    u5[p46] = v49.InputBegan:Connect(function(p52, p53) -- Line: 285
        -- upvalues: u51 (copy), BackpackCore (ref), BackpackLock (ref), u50 (copy), PlayerData (ref), LocalPlayer (ref), GetData (ref), _startDragWatch (ref), u47 (copy)
        if p52.UserInputType ~= Enum.UserInputType.MouseButton1 and p52.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        if u51 and not BackpackCore.isWarehouseOpen() then
            return;
        end;

        if BackpackLock.isActive() then
            return;
        end;

        if u50.zone == "toolbar" and u50.equipSlot then
            local v54 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

            if type(v54) ~= "table" then
                return;
            end;

            if not GetData.GetBackpackToolbarItemAtUiSlot(v54, u50.equipSlot, LocalPlayer) then
                return;
            end;
        end;

        _startDragWatch(u47, u50);
    end);

    return nil;
end;

function v1.rebindWarehouseSlots(p55, p56) -- Line: 382
    -- upvalues: u5 (copy), BackpackCore (copy), _bindWarehouseDragSlot (copy)
    if p55 ~= nil or p56 ~= nil then
        if p56 then
            for _, v in ipairs(p56) do
                local v57 = u5[v];

                if v57 then
                    if v57.Connected then
                        v57:Disconnect();
                    end;

                    u5[v] = nil;
                end;
            end;
        end;

        if p55 then
            for _, v in ipairs(p55) do
                local v58 = BackpackCore.getWarehouseSlotByOnlyId(v);

                if v58 then
                    _bindWarehouseDragSlot(v, v58);
                end;
            end;
        end;

        return nil;
    end;

    for _, v in u5 do
        if v.Connected then
            v:Disconnect();
        end;
    end;

    table.clear(u5);

    for _, v in BackpackCore.getWarehouseSlotFrames() do
        local v59 = tonumber(v:GetAttribute("OnlyID")) or 0;

        if v59 > 0 then
            _bindWarehouseDragSlot(v59, v);
        end;
    end;

    return nil;
end;

function v1.init() -- Line: 420
    -- upvalues: _bindToolbarDrag (copy)
    _bindToolbarDrag();

    return nil;
end;

return v1;