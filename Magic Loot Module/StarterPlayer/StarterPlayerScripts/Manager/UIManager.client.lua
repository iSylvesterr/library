-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local UIanima = UtilsSystem.UIanima;
local UIMgr = UtilsSystem.UIMgr;
local InsMgr = UtilsSystem.InsMgr;
local Log = UtilsSystem.Log;
local LocalPlayer = UtilsSystem.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", (1 / 0));
local ScreenGui = PlayerGui:WaitForChild("ScreenGui", (1 / 0));
local ScreenGui_Full = PlayerGui:FindFirstChild("ScreenGui_Full");
local ModuleScript = ReplicatedStorage:WaitForChild("ClientSideCode"):WaitForChild("GuiScripts"):WaitForChild("ModuleScript", (1 / 0));
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = false;
local u5 = nil;
InsMgr.GetIns("是否弹窗打开中", "BoolValue", LocalPlayer).Value = false;

local function _isLoadingClosed() -- Line: 85
    -- upvalues: LocalPlayer (copy)
    local IsCloseLoading = LocalPlayer:FindFirstChild("IsCloseLoading");

    return not (IsCloseLoading and IsCloseLoading:IsA("BoolValue")) and true or IsCloseLoading.Value == true;
end;

local function _cancelDeferredShow(p6) -- Line: 98
    -- upvalues: u3 (ref)
    u3[p6] = nil;
end;

local function _flushDeferredShows() -- Line: 106
    -- upvalues: u3 (ref), u5 (ref)
    local u7 = u3;
    u3 = {};

    if next(u7) == nil then
        return;
    end;

    task.delay(1, function() -- Line: 112
        -- upvalues: u7 (copy), u5 (ref)
        for _, v in pairs(u7) do
            u5(v.uiName, v.uiData, true, v.isAnim, table.unpack(v.args, 1, v.args.n));
        end;
    end);
end;

local function _ensureLoadingFlushListener() -- Line: 123
    -- upvalues: u4 (ref), LocalPlayer (copy), _flushDeferredShows (copy)
    if u4 then
        return;
    end;

    u4 = true;
    task.spawn(function() -- Line: 129
        -- upvalues: LocalPlayer (ref), _flushDeferredShows (ref)
        local IsCloseLoading = LocalPlayer:WaitForChild("IsCloseLoading", 120);

        if not (IsCloseLoading and IsCloseLoading:IsA("BoolValue")) then
            _flushDeferredShows();

            return;
        end;

        if IsCloseLoading.Value == true then
            _flushDeferredShows();

            return;
        end;

        local u8 = nil;
        u8 = IsCloseLoading.Changed:Connect(function(p9) -- Line: 140
            -- upvalues: u8 (ref), _flushDeferredShows (ref)
            if p9 == true then
                if u8 then
                    u8:Disconnect();
                    u8 = nil;
                end;

                _flushDeferredShows();
            end;
        end);
    end);
end;

local function _findPopUiFrame(p10, p11) -- Line: 158
    -- upvalues: ScreenGui (copy), ScreenGui_Full (ref), PlayerGui (copy), Log (copy)
    local v12 = ScreenGui:FindFirstChild(p10);

    if v12 and v12:IsA("Frame") then
        return v12;
    end;

    if not ScreenGui_Full then
        ScreenGui_Full = PlayerGui:FindFirstChild("ScreenGui_Full");
    end;

    if ScreenGui_Full then
        local v13 = ScreenGui_Full:FindFirstChild(p10);

        if v13 and v13:IsA("Frame") then
            return v13;
        end;
    end;

    if p11 then
        Log.warn("没有这个弹窗:", p10);
    end;

    return nil;
end;

local function _loadUiModule(p14) -- Line: 185
    -- upvalues: u2 (copy), ModuleScript (copy), Log (copy)
    local v15 = u2[p14];

    if v15 ~= nil then
        return v15;
    end;

    local v16 = ModuleScript:FindFirstChild(p14);

    if not (v16 and v16:IsA("ModuleScript")) then
        return nil;
    end;

    local success, result = pcall(require, v16);

    if success then
        u2[p14] = result;

        return result;
    end;

    Log.warn("加载 UI 模块失败:", p14, result);

    return nil;
end;

u5 = function(p17, p18, p19, p20, ...) -- Line: 215
    -- upvalues: LocalPlayer (copy), u3 (ref), u4 (ref), _flushDeferredShows (copy), u1 (copy), ScreenGui (copy), ScreenGui_Full (ref), PlayerGui (copy), _loadUiModule (copy), UIanima (copy), UIMgr (copy)
    local v21 = p20 == nil and true or p20;

    if p19 == true then
        local IsCloseLoading = LocalPlayer:FindFirstChild("IsCloseLoading");

        if IsCloseLoading and IsCloseLoading:IsA("BoolValue") and IsCloseLoading.Value ~= true then
            u3[p17] = {
                uiName = p17,
                uiData = p18,
                isAnim = v21,
                args = table.pack(...)
            };

            if u4 then
                return;
            end;

            u4 = true;
            task.spawn(function() -- Line: 129
                -- upvalues: LocalPlayer (ref), _flushDeferredShows (ref)
                local IsCloseLoading2 = LocalPlayer:WaitForChild("IsCloseLoading", 120);

                if not (IsCloseLoading2 and IsCloseLoading2:IsA("BoolValue")) then
                    _flushDeferredShows();

                    return;
                end;

                if IsCloseLoading2.Value == true then
                    _flushDeferredShows();

                    return;
                end;

                local u22 = nil;
                u22 = IsCloseLoading2.Changed:Connect(function(p23) -- Line: 140
                    -- upvalues: u22 (ref), _flushDeferredShows (ref)
                    if p23 == true then
                        if u22 then
                            u22:Disconnect();
                            u22 = nil;
                        end;

                        _flushDeferredShows();
                    end;
                end);
            end);

            return;
        end;
    end;

    if p19 == false then
        u3[p17] = nil;
    end;

    if u1[p17] and (p18 == nil and p19 == true) then
        p18 = table.remove(u1[p17]);

        if p18 == nil then
            return;
        end;
    end;

    local v24 = ScreenGui:FindFirstChild(p17);

    if not (v24 and v24:IsA("Frame")) then
        if not ScreenGui_Full then
            ScreenGui_Full = PlayerGui:FindFirstChild("ScreenGui_Full");
        end;

        if ScreenGui_Full then
            v24 = ScreenGui_Full:FindFirstChild(p17);

            if not (v24 and v24:IsA("Frame")) then
                v24 = nil;
            end;
        else
            v24 = nil;
        end;
    end;

    if not v24 then
        return;
    end;

    local v25 = _loadUiModule(p17);

    if p19 == false then
        if v21 then
            UIanima.PopBack(v24);
        else
            v24.Visible = false;
            local v26 = v24:FindFirstChildOfClass("UIScale");

            if v26 then
                v26.Scale = 1;
            end;
        end;

        if v25 and type(v25.closeUi) == "function" then
            v25:closeUi();
        end;

        UIMgr.UpdateBlurVisible();
        UIMgr.RefreshPopShowState();

        return;
    end;

    if p19 ~= true then
        if v24.Visible and (v25 and type(v25.updateUi) == "function") then
            v25:updateUi(p18, ...);
        end;

        return;
    end;

    if u1[p17] and v24.Visible then
        table.insert(u1[p17], p18);

        return;
    end;

    if v25 and type(v25.updateUi) == "function" then
        v25:updateUi(p18, ...);
    end;

    if v21 then
        UIanima.PopUp(v24);
    else
        v24.Visible = true;
        local v27 = v24:FindFirstChildOfClass("UIScale");

        if v27 then
            v27.Scale = 1;
        end;
    end;

    if v25 and type(v25.openUi) == "function" then
        v25:openUi();
    end;

    UIMgr.UpdateBlurVisible();
    local v28 = v24:FindFirstChild("隐藏主界面");
    local v29 = v24:FindFirstChild("背景模糊");
    local v30;

    if v28 and (v28:IsA("BoolValue") and v28.Value == true) then
        v30 = true;
    else
        v30 = v29 and v29:IsA("BoolValue") and v29.Value == true;
    end;

    if v30 then
        local v31 = v24:GetAttribute("HideButtomLeft") == true;
        UIMgr.SetMainUIVisible(false, v31);
    end;

    UIMgr.RefreshPopShowState();
end;

local function _onShowLocalUI(p32, p33, p34, p35, ...) -- Line: 321
    -- upvalues: _findPopUiFrame (copy), u5 (ref)
    local v36 = _findPopUiFrame(p32, true);

    if not v36 then
        return;
    end;

    if p34 == nil then
        u5(p32, p33, not v36.Visible, p35, ...);

        return;
    end;

    u5(p32, p33, p34, p35, ...);
end;

local function _onShowLocalUIRemote(p37, p38, p39, p40, ...) -- Line: 358
    -- upvalues: u5 (ref)
    u5(p37, p38, p39, p40, ...);
end;

NetWork.RegisterBindableEvent(NetMsg.REFRESH_LOCAL_UI, function(p41, p42, p43) -- Line: 341, Name: _onRefreshLocalUI
    -- upvalues: _findPopUiFrame (copy), u5 (ref)
    if not _findPopUiFrame(p41, true) then
        return;
    end;

    u5(p41, p42, nil, p43);
end);
NetWork.RegisterBindableEvent(NetMsg.SHOW_LOCAL_UI, _onShowLocalUI);
NetWork.RegisterClientRemoteEvent(NetMsg.SHOW_LOCAL_UI, _onShowLocalUIRemote);