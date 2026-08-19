-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Players = UtilsSystem.Players;
local CollectionService = UtilsSystem.CollectionService;
local LocalPlayer = UtilsSystem.LocalPlayer;
local InsMgr = UtilsSystem.InsMgr;
local HumanModule = UtilsSystem.HumanModule;
local AddListen = UtilsSystem.AddListen;
local TranslationHelper = UtilsSystem.TranslationHelper;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local GetData = UtilsSystem.GetData;
local TipsModule = UtilsSystem.TipsModule;
local ItemType = UtilsSystem.EnumMgr.ItemType;
local u1 = {};
local u2 = {};
local u3 = false;

local function _isGiftableHeldType(p4) -- Line: 48
    -- upvalues: ItemType (copy)
    return p4 == ItemType.Potion and true or p4 == ItemType.Material;
end;

local function _isPaidPotion(p5) -- Line: 57
    -- upvalues: GetData (copy), ItemType (copy)
    local v6 = tonumber(p5:GetAttribute("OnlyID"));

    if not v6 or v6 <= 0 then
        return false;
    end;

    local v7 = GetData.GetDataAndCfg(v6);

    if not v7 then
        return false;
    end;

    local v8;

    if tonumber(v7.tp) == ItemType.Potion then
        v8 = v7.Pay == true;
    else
        v8 = false;
    end;

    return v8;
end;

local function _updatePrompts() -- Line: 74
    -- upvalues: u2 (copy), u3 (ref)
    for _, v in pairs(u2) do
        if v then
            v.Enabled = u3;
        end;
    end;
end;

local function _addFunc(u9) -- Line: 87
    -- upvalues: LocalPlayer (copy), InsMgr (copy), TranslationHelper (copy), u3 (ref), u2 (copy), u1 (copy), AddListen (copy), HumanModule (copy), GetData (copy), ItemType (copy), TipsModule (copy), Players (copy), NetWork (copy), NetMsg (copy)
    if not u9 then
        return;
    end;

    if u9.Parent == LocalPlayer.Character then
        return;
    end;

    local u10 = InsMgr.GetIns("GiftPrompt", "ProximityPrompt", u9);
    TranslationHelper.SetText(u10, "赠送");
    u10.Style = Enum.ProximityPromptStyle.Custom;
    u10.HoldDuration = 3;
    u10.MaxActivationDistance = 10;
    u10.RequiresLineOfSight = false;
    u10.Enabled = u3;
    u2[u9] = u10;
    u1[u9] = AddListen.AddProximityPrompt(u10, function() -- Line: 107
        -- upvalues: HumanModule (ref), LocalPlayer (ref), GetData (ref), ItemType (ref), TipsModule (ref), u10 (copy), Players (ref), u9 (copy), NetWork (ref), NetMsg (ref)
        local v11 = HumanModule.GetHeldItem(LocalPlayer);

        if not v11 then
            return;
        end;

        local v12 = tonumber(v11:GetAttribute("OnlyID"));
        local v13;

        if v12 and v12 > 0 then
            local v14 = GetData.GetDataAndCfg(v12);

            if v14 and tonumber(v14.tp) == ItemType.Potion then
                v13 = v14.Pay == true;
            else
                v13 = false;
            end;
        else
            v13 = false;
        end;

        if v13 then
            TipsModule.ErrorTips(LocalPlayer, "付费药水不能赠送");
            u10:InputHoldEnd();

            return;
        end;

        local v15 = Players:GetPlayerFromCharacter(u9.Parent);

        if v15 then
            NetWork.FireServer(NetMsg.GIFT_REQUEST, v15.UserId);
            u10:InputHoldEnd();
            u10.Enabled = true;
        end;
    end);
end;

local function _removeFunc(p16) -- Line: 133
    -- upvalues: u1 (copy), u2 (copy)
    if u1[p16] then
        u1[p16]:Disconnect();
        u1[p16] = nil;
    end;

    if u2[p16] then
        u2[p16]:Destroy();
        u2[p16] = nil;
    end;
end;

local v17 = LocalPlayer:WaitForChild("当前手持类型", (1 / 0));

if v17:IsA("NumberValue") then
    AddListen.NumValueAdd(v17, function(p18) -- Line: 147
        -- upvalues: u3 (ref), ItemType (copy), u2 (copy)
        u3 = p18 == ItemType.Potion and true or p18 == ItemType.Material;

        for _, v in pairs(u2) do
            if v then
                v.Enabled = u3;
            end;
        end;
    end);
end;

for _, v in ipairs(CollectionService:GetTagged("Giftable")) do
    if v:IsA("BasePart") then
        _addFunc(v);
    end;
end;

CollectionService:GetInstanceAddedSignal("Giftable"):Connect(function(p19) -- Line: 159
    -- upvalues: _addFunc (copy)
    if p19:IsA("BasePart") then
        _addFunc(p19);
    end;
end);
CollectionService:GetInstanceRemovedSignal("Giftable"):Connect(function(p20) -- Line: 165
    -- upvalues: u1 (copy), u2 (copy)
    if p20:IsA("BasePart") then
        if u1[p20] then
            u1[p20]:Disconnect();
            u1[p20] = nil;
        end;

        if u2[p20] then
            u2[p20]:Destroy();
            u2[p20] = nil;
        end;
    end;
end);