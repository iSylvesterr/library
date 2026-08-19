-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local DeviceType = UtilsSystem.DeviceType;
local LocalPlayer = UtilsSystem.LocalPlayer;
local ShowDetail = UtilsSystem.ShowDetail;
local TimeTransfer = UtilsSystem.TimeTransfer;
local TranslationHelper = UtilsSystem.TranslationHelper;
local BUFF = LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Main", (1 / 0)):WaitForChild("ButtomRight", (1 / 0)):WaitForChild("BUFF", (1 / 0));
local BuffFrame = BUFF:WaitForChild("BuffFrame", (1 / 0));
local BuffTemp = BuffFrame:WaitForChild("BuffTemp", (1 / 0));
BuffTemp.Visible = false;
local u1 = BUFF:WaitForChild("箭头", (1 / 0));
local Btn = u1:WaitForChild("Btn", (1 / 0));
local u2 = {};
local u3 = false;
local u4 = false;
local u5 = DeviceType.IsMobile();

local function _fmtTime(p6) -- Line: 55
    -- upvalues: TimeTransfer (copy)
    local v7 = math.floor(p6);
    local v8 = math.max(0, v7);

    if v8 >= 3600 then
        return TimeTransfer.FormatTime(v8);
    end;

    return TimeTransfer.FormatTimeMMSS(v8);
end;

local function _setSlotTimeLabel(p9, p10) -- Line: 69
    -- upvalues: TranslationHelper (copy), _fmtTime (copy)
    if p10 and p10 > 0 then
        p9.Visible = true;
        TranslationHelper.SetText_UnTrans(p9, _fmtTime(p10));

        return;
    end;

    if p10 and p10 < 0 then
        p9.Visible = false;

        return;
    end;

    p9.Visible = false;
end;

local function _bindBuffSlotDetail(p11, u12) -- Line: 86
    -- upvalues: ShowDetail (copy), u5 (copy), AddListen (copy)
    local function showDetail() -- Line: 87
        -- upvalues: u12 (copy), ShowDetail (ref)
        local v13 = u12:GetAttribute("id");

        if v13 then
            ShowDetail.ShowDetailByCfgID(v13, u12);
        end;
    end;

    if u5 then
        AddListen.AddMouseCLick(p11, showDetail, nil);

        return;
    end;

    AddListen.AddMouseHover(p11, showDetail, function() -- Line: 97
        -- upvalues: ShowDetail (ref)
        ShowDetail.HideAllDetail();
    end);
end;

local function _collectSlotList() -- Line: 108
    -- upvalues: u2 (copy), BuffFrame (copy)
    local v14 = {};

    for _, v in pairs(u2) do
        if v.Parent == BuffFrame then
            table.insert(v14, v);
        end;
    end;

    table.sort(v14, function(p15, p16) -- Line: 115
        if p15.LayoutOrder == p16.LayoutOrder then
            return p15.Name < p16.Name;
        end;

        return p15.LayoutOrder < p16.LayoutOrder;
    end);

    return v14;
end;

local function _applyExpandVisibility(p17) -- Line: 129
    -- upvalues: u2 (copy), BuffFrame (copy), u3 (ref), Btn (copy), u1 (copy)
    for _, v in pairs(u2) do
        if v.Parent == BuffFrame then
            v.Visible = u3 or (v:GetAttribute("BuffRow") or 1) == 1;
        end;
    end;

    local ImageLabel = Btn:FindFirstChild("ImageLabel");

    if p17 > 1 then
        u1.Visible = true;

        if ImageLabel and ImageLabel:IsA("GuiObject") then
            ImageLabel.Rotation = u3 and 0 or 180;
        end;
    else
        u1.Visible = false;

        if ImageLabel and ImageLabel:IsA("GuiObject") then
            ImageLabel.Rotation = 0;
        end;
    end;
end;

local function _remeasureBuffRows() -- Line: 154
    -- upvalues: _collectSlotList (copy), u1 (copy), Btn (copy), _applyExpandVisibility (copy)
    local v18 = _collectSlotList();

    if #v18 == 0 then
        u1.Visible = false;
        local ImageLabel = Btn:FindFirstChild("ImageLabel");

        if ImageLabel and ImageLabel:IsA("GuiObject") then
            ImageLabel.Rotation = 0;
        end;

        return;
    end;

    for _, v in ipairs(v18) do
        v.Visible = true;
    end;

    local v19 = {};

    for _, v in ipairs(v18) do
        local Y = v.AbsolutePosition.Y;
        local v20 = nil;

        for i, v2 in ipairs(v19) do
            if math.abs(v2.y - Y) <= 2 then
                v20 = i;
                break;
            end;
        end;

        if not v20 then
            v20 = #v19 + 1;
            v19[v20] = {
                y = Y,
                slots = {}
            };
        end;

        table.insert(v19[v20].slots, v);
    end;

    table.sort(v19, function(p21, p22) -- Line: 186
        return p21.y > p22.y;
    end);

    for i, v in ipairs(v19) do
        for _, v2 in ipairs(v.slots) do
            v2:SetAttribute("BuffRow", i);
        end;
    end;

    _applyExpandVisibility(#v19);
end;

local function _scheduleBuffRowLayout() -- Line: 201
    -- upvalues: u4 (ref), RunService (copy), _remeasureBuffRows (copy)
    if u4 then
        return;
    end;

    u4 = true;
    task.defer(function() -- Line: 206
        -- upvalues: RunService (ref), u4 (ref), _remeasureBuffRows (ref)
        RunService.Heartbeat:Wait();
        u4 = false;
        _remeasureBuffRows();
    end);
end;

local function _setSlot(p23, p24, p25, p26) -- Line: 221
    -- upvalues: u2 (copy), u4 (ref), RunService (copy), _remeasureBuffRows (copy), BuffTemp (copy), BuffFrame (copy), _bindBuffSlotDetail (copy), TranslationHelper (copy), _fmtTime (copy)
    local v27 = false;

    if not p24 or (p24 == "" or p25 ~= nil and p25 <= 0) then
        if u2[p23] then
            u2[p23]:Destroy();
            u2[p23] = nil;
            v27 = true;
        end;

        if v27 then
            if u4 then
                return;
            end;

            u4 = true;
            task.defer(function() -- Line: 206
                -- upvalues: RunService (ref), u4 (ref), _remeasureBuffRows (ref)
                RunService.Heartbeat:Wait();
                u4 = false;
                _remeasureBuffRows();
            end);
        end;

        return;
    end;

    local v28 = u2[p23];

    if not v28 then
        v28 = BuffTemp:Clone();
        v28.Name = "Buff_" .. p23;
        v28.Visible = true;
        v28.Parent = BuffFrame;
        v28:SetAttribute("id", p26);
        u2[p23] = v28;
        v27 = true;
        local Button = v28:FindFirstChild("Button");

        if Button and Button:IsA("ImageButton") then
            _bindBuffSlotDetail(Button, v28);
        end;
    end;

    local v29 = v28:FindFirstChild("img") or v28:FindFirstChild("Img");

    if v29 and v29:IsA("ImageLabel") then
        v29.Image = "rbxassetid://" .. tostring(p24);
    end;

    local Time = v28:FindFirstChild("Time");

    if Time and Time:IsA("TextLabel") then
        if p25 and p25 > 0 then
            Time.Visible = true;
            TranslationHelper.SetText_UnTrans(Time, _fmtTime(p25));
        elseif p25 and p25 < 0 then
            Time.Visible = false;
        else
            Time.Visible = false;
        end;
    end;

    if v27 then
        if u4 then
            return;
        end;

        u4 = true;
        task.defer(function() -- Line: 206
            -- upvalues: RunService (ref), u4 (ref), _remeasureBuffRows (ref)
            RunService.Heartbeat:Wait();
            u4 = false;
            _remeasureBuffRows();
        end);
    end;
end;

local function _bindNumberValue(u30) -- Line: 272
    -- upvalues: AddListen (copy), u2 (copy), u4 (ref), RunService (copy), _remeasureBuffRows (copy), CfgFind (copy), _setSlot (copy)
    AddListen.NumValueAdd(u30, function(p31) -- Line: 273
        -- upvalues: u30 (copy), u2 (ref), u4 (ref), RunService (ref), _remeasureBuffRows (ref), CfgFind (ref), _setSlot (ref)
        local v32 = tonumber(u30.Name);

        if not v32 or p31 <= 0 then
            local Name = u30.Name;
            local v33;

            if u2[Name] then
                u2[Name]:Destroy();
                u2[Name] = nil;
                v33 = true;
            else
                v33 = false;
            end;

            if v33 then
                if u4 then
                    return;
                end;

                u4 = true;
                task.defer(function() -- Line: 206
                    -- upvalues: RunService (ref), u4 (ref), _remeasureBuffRows (ref)
                    RunService.Heartbeat:Wait();
                    u4 = false;
                    _remeasureBuffRows();
                end);
            end;

            return;
        end;

        local v34 = CfgFind.GetBuffCfgByID(v32);

        if v34 and tonumber(v34.isShow) == 1 then
            _setSlot(u30.Name, v34.Icon, p31, v32);

            return;
        end;

        local Name = u30.Name;
        local v35;

        if u2[Name] then
            u2[Name]:Destroy();
            u2[Name] = nil;
            v35 = true;
        else
            v35 = false;
        end;

        if v35 then
            if u4 then
                return;
            end;

            u4 = true;
            task.defer(function() -- Line: 206
                -- upvalues: RunService (ref), u4 (ref), _remeasureBuffRows (ref)
                RunService.Heartbeat:Wait();
                u4 = false;
                _remeasureBuffRows();
            end);
        end;
    end, true);
end;

local function _hookBuffFolder(p36) -- Line: 293
    -- upvalues: AddListen (copy), u2 (copy), u4 (ref), RunService (copy), _remeasureBuffRows (copy), CfgFind (copy), _setSlot (copy)
    if p36:GetAttribute("BuffLocalHook") then
        return;
    end;

    p36:SetAttribute("BuffLocalHook", true);

    for _, child in p36:GetChildren() do
        if child:IsA("NumberValue") then
            AddListen.NumValueAdd(child, function(p37) -- Line: 273
                -- upvalues: child (copy), u2 (ref), u4 (ref), RunService (ref), _remeasureBuffRows (ref), CfgFind (ref), _setSlot (ref)
                local v38 = tonumber(child.Name);

                if not v38 or p37 <= 0 then
                    local Name = child.Name;
                    local v39;

                    if u2[Name] then
                        u2[Name]:Destroy();
                        u2[Name] = nil;
                        v39 = true;
                    else
                        v39 = false;
                    end;

                    if v39 then
                        if u4 then
                            return;
                        end;

                        u4 = true;
                        task.defer(function() -- Line: 206
                            -- upvalues: RunService (ref), u4 (ref), _remeasureBuffRows (ref)
                            RunService.Heartbeat:Wait();
                            u4 = false;
                            _remeasureBuffRows();
                        end);
                    end;

                    return;
                end;

                local v40 = CfgFind.GetBuffCfgByID(v38);

                if v40 and tonumber(v40.isShow) == 1 then
                    _setSlot(child.Name, v40.Icon, p37, v38);

                    return;
                end;

                local Name = child.Name;
                local v41;

                if u2[Name] then
                    u2[Name]:Destroy();
                    u2[Name] = nil;
                    v41 = true;
                else
                    v41 = false;
                end;

                if v41 then
                    if u4 then
                        return;
                    end;

                    u4 = true;
                    task.defer(function() -- Line: 206
                        -- upvalues: RunService (ref), u4 (ref), _remeasureBuffRows (ref)
                        RunService.Heartbeat:Wait();
                        u4 = false;
                        _remeasureBuffRows();
                    end);
                end;
            end, true);
        end;
    end;

    p36.ChildAdded:Connect(function(u42) -- Line: 304
        -- upvalues: AddListen (ref), u2 (ref), u4 (ref), RunService (ref), _remeasureBuffRows (ref), CfgFind (ref), _setSlot (ref)
        if u42:IsA("NumberValue") then
            AddListen.NumValueAdd(u42, function(p43) -- Line: 273
                -- upvalues: u42 (copy), u2 (ref), u4 (ref), RunService (ref), _remeasureBuffRows (ref), CfgFind (ref), _setSlot (ref)
                local v44 = tonumber(u42.Name);

                if not v44 or p43 <= 0 then
                    local Name = u42.Name;
                    local v45;

                    if u2[Name] then
                        u2[Name]:Destroy();
                        u2[Name] = nil;
                        v45 = true;
                    else
                        v45 = false;
                    end;

                    if v45 then
                        if u4 then
                            return;
                        end;

                        u4 = true;
                        task.defer(function() -- Line: 206
                            -- upvalues: RunService (ref), u4 (ref), _remeasureBuffRows (ref)
                            RunService.Heartbeat:Wait();
                            u4 = false;
                            _remeasureBuffRows();
                        end);
                    end;

                    return;
                end;

                local v46 = CfgFind.GetBuffCfgByID(v44);

                if v46 and tonumber(v46.isShow) == 1 then
                    _setSlot(u42.Name, v46.Icon, p43, v44);

                    return;
                end;

                local Name = u42.Name;
                local v47;

                if u2[Name] then
                    u2[Name]:Destroy();
                    u2[Name] = nil;
                    v47 = true;
                else
                    v47 = false;
                end;

                if v47 then
                    if u4 then
                        return;
                    end;

                    u4 = true;
                    task.defer(function() -- Line: 206
                        -- upvalues: RunService (ref), u4 (ref), _remeasureBuffRows (ref)
                        RunService.Heartbeat:Wait();
                        u4 = false;
                        _remeasureBuffRows();
                    end);
                end;
            end, true);
        end;
    end);
    p36.ChildRemoved:Connect(function(p48) -- Line: 309
        -- upvalues: u2 (ref), u4 (ref), RunService (ref), _remeasureBuffRows (ref)
        if p48:IsA("NumberValue") then
            local Name = p48.Name;
            tonumber(p48.Name);
            local v49;

            if u2[Name] then
                u2[Name]:Destroy();
                u2[Name] = nil;
                v49 = true;
            else
                v49 = false;
            end;

            if v49 then
                if u4 then
                    return;
                end;

                u4 = true;
                task.defer(function() -- Line: 206
                    -- upvalues: RunService (ref), u4 (ref), _remeasureBuffRows (ref)
                    RunService.Heartbeat:Wait();
                    u4 = false;
                    _remeasureBuffRows();
                end);
            end;
        end;
    end);
end;

AddListen.AddMouseCLick(Btn, function() -- Line: 316
    -- upvalues: u3 (ref), u2 (copy), u4 (ref), RunService (copy), _remeasureBuffRows (copy), _applyExpandVisibility (copy)
    u3 = not u3;
    local v50 = 0;

    for _, v in pairs(u2) do
        local v51 = v:GetAttribute("BuffRow");

        if type(v51) == "number" and v50 < v51 then
            v50 = v51;
        end;
    end;

    if v50 > 1 then
        _applyExpandVisibility(v50);

        return;
    end;

    if u4 then
        return;
    end;

    u4 = true;
    task.defer(function() -- Line: 206
        -- upvalues: RunService (ref), u4 (ref), _remeasureBuffRows (ref)
        RunService.Heartbeat:Wait();
        u4 = false;
        _remeasureBuffRows();
    end);
end, u1);
BuffFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 332
    -- upvalues: u4 (ref), RunService (copy), _remeasureBuffRows (copy)
    if u4 then
        return;
    end;

    u4 = true;
    task.defer(function() -- Line: 206
        -- upvalues: RunService (ref), u4 (ref), _remeasureBuffRows (ref)
        RunService.Heartbeat:Wait();
        u4 = false;
        _remeasureBuffRows();
    end);
end);
local BUFF2 = LocalPlayer:FindFirstChild("BUFF");

if BUFF2 and BUFF2:IsA("Folder") then
    _hookBuffFolder(BUFF2);
end;

LocalPlayer.ChildAdded:Connect(function(p52) -- Line: 340
    -- upvalues: _hookBuffFolder (copy)
    if p52.Name == "BUFF" and p52:IsA("Folder") then
        _hookBuffFolder(p52);
    end;
end);