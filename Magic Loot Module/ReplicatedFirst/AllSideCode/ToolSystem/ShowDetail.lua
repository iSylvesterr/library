-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local Copy = UtilsSystem.Copy;
local GetData = UtilsSystem.GetData;
local Log = UtilsSystem.Log;
require(game.ReplicatedFirst.AllSideCode.Class.Struct);
local u1 = {};
local u2 = {
    [EnumMgr.ItemType.Material] = "MaterialDetail",
    [EnumMgr.ItemType.Potion] = "PotionDetail",
    [EnumMgr.ItemType.Weapon] = "WeaponDetail",
    [EnumMgr.ItemType.Armor] = "ArmorDetail",
    [EnumMgr.ItemType.Pet] = "PetDetail",
    [EnumMgr.ItemType.PetEgg] = "PetEggDetail"
};
local LocalPlayer = Players.LocalPlayer;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = {};
local u8 = nil;

local function _resolveDetailChildKey(p9) -- Line: 123
    -- upvalues: u2 (copy)
    if type(p9) == "number" then
        return u2[p9] or p9;
    end;

    return p9;
end;

local function _getDetailFrame(p10) -- Line: 139
    -- upvalues: LocalPlayer (copy), u2 (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return nil;
    end;

    local ScreenGui = PlayerGui:FindFirstChild("ScreenGui");

    if not ScreenGui then
        return nil;
    end;

    local Detail = ScreenGui:FindFirstChild("Detail");

    if not Detail then
        return nil;
    end;

    local v11;

    if type(p10) == "number" then
        v11 = u2[p10] or p10;
    else
        v11 = p10;
    end;

    local v12 = Detail:FindFirstChild(v11);

    if v12 and v12:IsA("Frame") then
        return v12;
    end;

    if v11 ~= p10 then
        local v13 = Detail:FindFirstChild(p10);

        if v13 and v13:IsA("Frame") then
            return v13;
        end;
    end;

    return nil;
end;

local function _getDetailScriptsFolder() -- Line: 176
    -- upvalues: u8 (ref), ReplicatedStorage (copy)
    if u8 and u8.Parent then
        return u8;
    end;

    local ClientSideCode = ReplicatedStorage:FindFirstChild("ClientSideCode");

    if not ClientSideCode then
        return nil;
    end;

    local GuiScripts = ClientSideCode:FindFirstChild("GuiScripts");

    if not GuiScripts then
        return nil;
    end;

    local ModuleScript = GuiScripts:FindFirstChild("ModuleScript");

    if not (ModuleScript and ModuleScript:IsA("Folder")) then
        return nil;
    end;

    u8 = ModuleScript;

    return ModuleScript;
end;

local function _requireDetailScript(p14) -- Line: 201
    -- upvalues: u7 (copy), Log (copy)
    local v15 = u7[p14];

    if v15 then
        return v15;
    end;

    local success, result = pcall(require, p14);

    if success then
        u7[p14] = result;

        return result;
    end;

    Log.warn("ShowDetail: require 详情脚本失败", p14:GetFullName(), result);

    return nil;
end;

local function _getDetailScriptModule(p16) -- Line: 222
    -- upvalues: _getDetailScriptsFolder (copy), u7 (copy), Log (copy)
    local v17 = _getDetailScriptsFolder();
    local v18 = v17 and v17:FindFirstChild(p16.Name);

    if v18 then
        if v18:IsA("ModuleScript") then
            local v19 = u7[v18];

            if v19 then
                return v19;
            end;

            local success, result = pcall(require, v18);

            if success then
                u7[v18] = result;

                return result;
            end;

            Log.warn("ShowDetail: require 详情脚本失败", v18:GetFullName(), result);

            return nil;
        end;

        if v18:IsA("Folder") then
            local init = v18:FindFirstChild("init");

            if init and init:IsA("ModuleScript") then
                local v20 = u7[init];

                if v20 then
                    return v20;
                end;

                local success, result = pcall(require, init);

                if success then
                    u7[init] = result;

                    return result;
                end;

                Log.warn("ShowDetail: require 详情脚本失败", init:GetFullName(), result);

                return nil;
            end;
        end;
    end;

    local v21 = p16:FindFirstChildOfClass("ModuleScript");

    if not v21 then
        return nil;
    end;

    local v22 = u7[v21];

    if v22 then
        return v22;
    end;

    local success, result = pcall(require, v21);

    if success then
        u7[v21] = result;

        return result;
    end;

    Log.warn("ShowDetail: require 详情脚本失败", v21:GetFullName(), result);

    return nil;
end;

local function _setDetailPos(p23, p24, p25) -- Line: 254
    -- upvalues: LocalPlayer (copy)
    local ScreenGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui");
    local Scale = ScreenGui.UIScale.Scale;
    local Detail = ScreenGui:WaitForChild("Detail");
    local AbsolutePosition = ScreenGui.AbsolutePosition;
    p23.Visible = true;
    local Parent = p23.Parent;

    if Parent and (Parent:IsA("GuiObject") and Parent.Name == "Detail") then
        Parent.Visible = true;
    end;

    local v26 = p24.AbsolutePosition - AbsolutePosition;
    local v27 = Vector2.new(v26.X / Scale, v26.Y / Scale);
    local AbsoluteSize = p24.AbsoluteSize;
    local v28 = Vector2.new(AbsoluteSize.X / Scale, AbsoluteSize.Y / Scale);

    if p25 == true then
        if p23.Name == "PotionDetail" then
            p23.AnchorPoint = Vector2.new(0, 0.5);
            p23:SetAttribute("LeftRight", 0);
            p23.Position = UDim2.new(0, v27.X + v28.X + 5, 0, v27.Y + v28.Y / 2);

            return;
        end;

        p23.AnchorPoint = Vector2.new(0, 0);
        p23:SetAttribute("LeftRight", 0);
        p23.Position = UDim2.new(0, v27.X + v28.X / 2, 0, v27.Y + v28.Y / 2);

        return;
    end;

    local AbsoluteSize2 = Detail.Parent.AbsoluteSize;

    if v27.X <= AbsoluteSize2.X / 2 and v27.Y <= AbsoluteSize2.Y / 2 then
        p23.AnchorPoint = Vector2.new(0, 0);
        p23:SetAttribute("LeftRight", 1);
        p23.Position = UDim2.new(0, v27.X + v28.X, 0, v27.Y);
    end;

    if v27.X >= AbsoluteSize2.X / 2 and v27.Y <= AbsoluteSize2.Y / 2 then
        p23.AnchorPoint = Vector2.new(1, 0);
        p23:SetAttribute("LeftRight", 2);
        p23.Position = UDim2.new(0, v27.X, 0, v27.Y);
    end;

    if v27.X <= AbsoluteSize2.X / 2 and v27.Y >= AbsoluteSize2.Y / 2 then
        p23.AnchorPoint = Vector2.new(0, 1);
        p23:SetAttribute("LeftRight", 1);
        p23.Position = UDim2.new(0, v27.X + v28.X, 0, v27.Y + v28.Y);
    end;

    if v27.X >= AbsoluteSize2.X / 2 and v27.Y >= AbsoluteSize2.Y / 2 then
        p23.AnchorPoint = Vector2.new(1, 1);
        p23:SetAttribute("LeftRight", 2);
        p23.Position = UDim2.new(0, v27.X, 0, v27.Y + v28.Y);
    end;
end;

function u1.HideAllDetail() -- Line: 329
    -- upvalues: LocalPlayer (copy), u3 (ref), u4 (ref), u5 (ref), u6 (ref)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return;
    end;

    local ScreenGui = PlayerGui:FindFirstChild("ScreenGui");

    if not ScreenGui then
        return;
    end;

    local Detail = ScreenGui:FindFirstChild("Detail");

    if not Detail then
        return;
    end;

    for _, child in pairs(Detail:GetChildren()) do
        if child:IsA("Frame") and child.Visible == true then
            child.Visible = false;
        end;
    end;

    u3 = nil;
    u4 = nil;
    u5 = nil;
    u6 = nil;
end;

function u1.GetDetailVisible(p29) -- Line: 362
    -- upvalues: _getDetailFrame (copy)
    local v30 = _getDetailFrame(p29);

    if v30 then
        return v30.Visible == true;
    end;

    return false;
end;

function u1.ShowDetailByCfgID(p31, p32, p33) -- Line: 378
    -- upvalues: u3 (ref), u1 (copy), CfgFind (copy), EnumMgr (copy), _getDetailFrame (copy), _setDetailPos (copy), _getDetailScriptModule (copy)
    if u3 == p31 then
        u1.HideAllDetail();

        return;
    end;

    u1.HideAllDetail();
    local v34 = CfgFind.FindCfgByID(p31);

    if not v34 then
        return;
    end;

    if v34.tp == EnumMgr.ItemType.Hero then
        return;
    end;

    local v35 = _getDetailFrame(v34.tp);

    if not v35 then
        return;
    end;

    u3 = p31;
    _setDetailPos(v35, p32, p33);
    local v36 = _getDetailScriptModule(v35);

    if v36 and v36.ShowByCfgID then
        v36.ShowByCfgID(v34, p31);
    end;
end;

function u1.ShowDetail(p37, p38, p39) -- Line: 416
    -- upvalues: u3 (ref), u1 (copy), GetData (copy), _getDetailFrame (copy), _setDetailPos (copy), _getDetailScriptModule (copy)
    if u3 == p37 then
        u1.HideAllDetail();

        return;
    end;

    u1.HideAllDetail();
    local v40, v41 = GetData.GetDataAndCfg(p37);

    if not (v40 and v41) then
        return;
    end;

    local v42 = _getDetailFrame(v41.tp);

    if not v42 then
        return;
    end;

    u3 = p37;
    _setDetailPos(v42, p38, p39);
    local v43 = _getDetailScriptModule(v42);

    if v43 and v43.ShowByData then
        v43.ShowByData(v40, v41, p38);
    end;
end;

function u1.HoldShow(p44, p45, p46) -- Line: 450
    -- upvalues: u4 (ref), u1 (copy), GetData (copy), _getDetailFrame (copy), _setDetailPos (copy), _getDetailScriptModule (copy)
    if u4 == p44 then
        u1.HideAllDetail();

        return;
    end;

    u1.HideAllDetail();
    local v47, v48 = GetData.GetDataAndCfg(p44);

    if not (v47 and v48) then
        return;
    end;

    local v49 = _getDetailFrame(v48.tp);

    if not v49 then
        return;
    end;

    u4 = p44;
    _setDetailPos(v49, p45, p46);
    local v50 = _getDetailScriptModule(v49);

    if v50 and v50.HoldShow then
        v50.HoldShow(v47, v48, p45);
    end;
end;

function u1.HoldShowByData(p51, p52, p53, p54, p55) -- Line: 486
    -- upvalues: u4 (ref), u1 (copy), _getDetailFrame (copy), _setDetailPos (copy), _getDetailScriptModule (copy)
    if u4 == p51 then
        u1.HideAllDetail();

        return;
    end;

    u1.HideAllDetail();
    local v56 = _getDetailFrame(p53);

    if not v56 then
        return;
    end;

    u4 = p51;
    _setDetailPos(v56, p52, p55);
    local v57 = _getDetailScriptModule(v56);

    if v57 and v57.HoldShowByData then
        v57.HoldShowByData(p52, p54);
    end;
end;

function u1.ShowDetailSpecial(p58, p59, p60, p61, p62) -- Line: 523
    -- upvalues: u3 (ref), Copy (copy), u5 (ref), u1 (copy), GetData (copy), _getDetailFrame (copy), _setDetailPos (copy), _getDetailScriptModule (copy)
    if u3 == p58 and Copy.IsEqual(u5, p62) then
        u1.HideAllDetail();

        return;
    end;

    u1.HideAllDetail();
    local v63, v64 = GetData.GetDataAndCfg(p58);

    if not (v63 and v64) then
        return;
    end;

    local v65 = _getDetailFrame(p60);

    if not v65 then
        return;
    end;

    u3 = p58;
    u5 = p62;
    _setDetailPos(v65, p59, p61);
    local v66 = _getDetailScriptModule(v65);

    if v66 and v66.ShowSpecial then
        v66.ShowSpecial(v63, v64, p59, p62);
    end;
end;

function u1.ShowDetailByData(p67, p68, p69, p70, ...) -- Line: 566
    -- upvalues: u1 (copy), u3 (ref), _getDetailFrame (copy), _setDetailPos (copy), _getDetailScriptModule (copy)
    if p67 == nil then
        u1.HideAllDetail();

        return;
    end;

    if u3 == p67.onlyID then
        u1.HideAllDetail();

        return;
    end;

    u1.HideAllDetail();
    local v71 = _getDetailFrame(p69);

    if not v71 then
        return;
    end;

    u3 = p67.onlyID;
    _setDetailPos(v71, p68, p70);
    local v72 = _getDetailScriptModule(v71);

    if v72 and v72.ShowByData then
        v72.ShowByData(p67, ...);
    end;
end;

function u1.ShowGamePassDetail(p73, p74, p75) -- Line: 606
    -- upvalues: u6 (ref), u1 (copy), GetData (copy), CfgFind (copy), _getDetailFrame (copy), _setDetailPos (copy)
    if u6 == p74 then
        u1.HideAllDetail();

        return;
    end;

    u1.HideAllDetail();

    if GetData.IsHasPass(p73, p74) then
        return;
    end;

    local v76 = CfgFind.FindCfgByOnlyTag(p74);

    if not v76 then
        return;
    end;

    local v77 = _getDetailFrame(100);

    if not v77 then
        return;
    end;

    local Des = v77:FindFirstChild("Des");

    if not Des then
        return;
    end;

    Des.Text = v76.ZhDes;

    if v76.ZhDes == "" then
        return;
    end;

    _setDetailPos(v77, p75);
    v77.Visible = true;
    u6 = p74;
end;

function u1.HideGamePassDetail(p78) -- Line: 649
    -- upvalues: u6 (ref), u1 (copy)
    if u6 == p78 then
        u6 = nil;
        u1.HideAllDetail();
    end;
end;

return u1;