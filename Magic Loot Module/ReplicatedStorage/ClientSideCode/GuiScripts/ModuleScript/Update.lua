-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local Log = UtilsSystem.Log;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local TimeTransfer = UtilsSystem.TimeTransfer;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local AllUI = require(script.AllUI);
local u2 = Color3.fromHex("#EEEEEE");
local u3 = Color3.fromHex("#D8B485");
local UIRoot = AllUI.UIRoot;
local UpdateContent = AllUI.UpdateContent;
local UpdatePanelTag = AllUI.UpdatePanelTag;
local UpdateTagTemp = AllUI.UpdateTagTemp;
local u4 = CfgFind.GetCfgByName("updatelogConf") or {};
local u5 = 0;
local u6 = false;
UpdateTagTemp.Visible = false;
local u7 = TweenService:Create(UpdateContent, TweenInfo.new(0.2), {
    Position = UDim2.new(0, 0, 0.5, 0)
});
u7.Completed:Connect(function() -- Line: 61
    -- upvalues: UpdateContent (copy), u6 (ref)
    UpdateContent.Visible = true;
    u6 = false;
end);
local u8 = TweenService:Create(UpdateContent, TweenInfo.new(0.2), {
    Position = UDim2.new(1, 0, 0.5, 0)
});
u8.Completed:Connect(function() -- Line: 69
    -- upvalues: UpdateContent (copy), u6 (ref)
    UpdateContent.Visible = true;
    u6 = false;
end);

local function _setTagSelected(p9, p10) -- Line: 101
    local ChooseBg = p9:FindFirstChild("ChooseBg");
    local Bg = p9:FindFirstChild("Bg");

    if ChooseBg and ChooseBg:IsA("GuiObject") then
        ChooseBg.Visible = p10;
    end;

    if Bg and Bg:IsA("GuiObject") then
        Bg.Visible = not p10;
    end;
end;

local function _applyCurUpdate() -- Line: 116
    -- upvalues: u5 (ref), UpdateContent (copy), UpdatePanelTag (copy), u4 (copy), TimeTransfer (copy), TranslationHelper (copy), AllUI (copy)
    if u5 == 0 then
        return;
    end;

    UpdateContent.Visible = true;

    for _, child in pairs(UpdatePanelTag:GetChildren()) do
        if child:IsA("Frame") then
            local v11 = tonumber(child.Name);

            if v11 then
                local v12 = v11 == u5;
                local ChooseBg = child:FindFirstChild("ChooseBg");
                local Bg = child:FindFirstChild("Bg");

                if ChooseBg and ChooseBg:IsA("GuiObject") then
                    ChooseBg.Visible = v12;
                end;

                if Bg and Bg:IsA("GuiObject") then
                    Bg.Visible = not v12;
                end;
            end;
        end;
    end;

    for _, child in pairs(UpdateContent:GetChildren()) do
        if child:IsA("GuiObject") then
            local v13 = tonumber(child.Name);

            if v13 then
                child.Visible = v13 == u5;
            end;
        end;
    end;

    local v14 = u4[u5];

    if v14 then
        local v15 = TimeTransfer.FormatUnixTimestampToYMD(v14.UpdateTime) .. " - ";
        TranslationHelper.SetText(AllUI.UpdateCfgTitle, "{1}{2}", {
            v15,
            { v14.TagTitle }
        });
    end;
end;

local function _setDefUpdateId() -- Line: 152
    -- upvalues: UpdatePanelTag (copy), u5 (ref), _applyCurUpdate (copy)
    local v16 = {};

    for _, child in pairs(UpdatePanelTag:GetChildren()) do
        if child:IsA("Frame") then
            local v17 = tonumber(child.Name);

            if v17 then
                local v18 = {
                    Time = child:GetAttribute("UpdateTime"),
                    IsRead = child:GetAttribute("IsRead"),
                    key = v17
                };
                table.insert(v16, v18);
            end;
        end;
    end;

    table.sort(v16, function(p19, p20) -- Line: 167
        return p19.Time > p20.Time;
    end);
    local v21 = nil;

    for _, v in ipairs(v16) do
        if v.IsRead ~= 1 then
            v21 = v.key;
            break;
        end;
    end;

    if v21 then
        u5 = v21;
    elseif v16[1] then
        u5 = v16[1].key;
    else
        u5 = 0;
    end;

    _applyCurUpdate();
end;

local function _refreshReadState(p22) -- Line: 79
    -- upvalues: UpdatePanelTag (copy), u2 (copy), u3 (copy)
    if not p22 then
        return;
    end;

    for _, child in pairs(UpdatePanelTag:GetChildren()) do
        if child:IsA("Frame") then
            local v23 = p22[child.Name];

            if v23 then
                child:SetAttribute("IsRead", v23.IsRead);
                local v24;

                if v23.IsRead == 1 then
                    v24 = u2;
                else
                    v24 = u3;
                end;

                child.Time.TextColor3 = v24;
            end;
        end;
    end;
end;

for i, v in pairs(u4) do
    if type(i) == "number" and type(v) == "table" then
        local u25 = UpdateTagTemp:Clone();
        u25.Visible = true;
        u25.Parent = UpdatePanelTag;
        u25.Name = tostring(i);
        u25.LayoutOrder = -(v.UpdateTime or 0);
        local v26 = TimeTransfer.FormatUnixTimestampToYMD(v.UpdateTime);
        TranslationHelper.SetText_UnTrans(u25.Time, v26);
        TranslationHelper.SetText(u25.Title, v.TagTitle);
        u25:SetAttribute("UpdateTime", v.UpdateTime);
        local ChooseBg = u25:FindFirstChild("ChooseBg");
        local Bg = u25:FindFirstChild("Bg");

        if ChooseBg and ChooseBg:IsA("GuiObject") then
            ChooseBg.Visible = false;
        end;

        if Bg and Bg:IsA("GuiObject") then
            Bg.Visible = true;
        end;

        AddListen.AddMouseCLick(u25.Button, function() -- Line: 206
            -- upvalues: u6 (ref), u25 (copy), u5 (ref), u8 (copy), UpdatePanelTag (copy), u7 (copy), _applyCurUpdate (copy), NetWork (copy), NetMsg (copy)
            if u6 then
                return;
            end;

            local v27 = tonumber(u25.Name);

            if not v27 then
                return;
            end;

            if v27 == u5 then
                u5 = 0;
                u6 = true;
                u8:Play();

                for _, child in pairs(UpdatePanelTag:GetChildren()) do
                    if child:IsA("Frame") and tonumber(child.Name) then
                        local ChooseBg2 = child:FindFirstChild("ChooseBg");
                        local Bg2 = child:FindFirstChild("Bg");

                        if ChooseBg2 and ChooseBg2:IsA("GuiObject") then
                            ChooseBg2.Visible = false;
                        end;

                        if Bg2 and Bg2:IsA("GuiObject") then
                            Bg2.Visible = true;
                        end;
                    end;
                end;

                return;
            end;

            if u5 == 0 then
                u6 = true;
                u7:Play();
            else
                u6 = true;
                u8:Play();
                u8.Completed:Wait();
                u7:Play();
            end;

            u5 = v27;
            _applyCurUpdate();

            if (u25:GetAttribute("IsRead") or 0) == 0 then
                NetWork.FireServer(NetMsg.UPDATE_LOG_READ, u5);
            end;
        end, u25);
    end;
end;

UIMgr.SetUIlistSize(UpdatePanelTag);
PlayerData.ListenClientSync(function(p28, p29) -- Line: 252
    -- upvalues: UIRoot (copy), _refreshReadState (copy)
    if p28 ~= "UpdateLog" then
        return;
    end;

    if not UIRoot.Visible then
        return;
    end;

    if type(p29) ~= "table" then
        return;
    end;

    _refreshReadState(p29);
end);
local v30 = UIMgr.FindButtonInFrame(AllUI.Exit);

if v30 then
    AddListen.AddMouseCLick(v30, function() -- Line: 267
        -- upvalues: NetWork (copy), NetMsg (copy)
        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Update", nil, false, true);
    end, AllUI.Exit);
else
    Log.warn("[Update] Exit button missing");
end;

function v1.updateUi(p31, p32) -- Line: 279
end;

function v1.openUi(p33) -- Line: 286
    -- upvalues: UIMgr (copy), UIRoot (copy), PlayerData (copy), LocalPlayer (copy), _refreshReadState (copy), _setDefUpdateId (copy), u5 (ref), UpdatePanelTag (copy), NetWork (copy), NetMsg (copy)
    UIMgr.SetMainUIVisible(false);
    UIRoot.Visible = true;
    _refreshReadState((PlayerData.GetPlrDataByKey(LocalPlayer, "UpdateLog")));
    _setDefUpdateId();

    if u5 ~= 0 then
        local v34 = UpdatePanelTag:FindFirstChild((tostring(u5)));

        if v34 and (v34:GetAttribute("IsRead") or 0) == 0 then
            NetWork.FireServer(NetMsg.UPDATE_LOG_READ, u5);
        end;
    end;

    UIMgr.UpdateBlurVisible();
end;

function v1.closeUi(p35) -- Line: 308
    -- upvalues: UIMgr (copy), UIRoot (copy)
    UIMgr.SetMainUIVisible(true);
    UIRoot.Visible = false;
    UIMgr.UpdateBlurVisible();
end;

return v1;