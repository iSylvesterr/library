-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local SocialService = game:GetService("SocialService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local GetData = UtilsSystem.GetData;
local InsMgr = UtilsSystem.InsMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local TipsModule = UtilsSystem.TipsModule;
local TranslationHelper = UtilsSystem.TranslationHelper;

local function _buildUiDataFromAttributes(p1) -- Line: 56
    local v2 = p1:GetAttribute("UiData") or (p1:GetAttribute("UIdata") or p1:GetAttribute("Uidata"));
    local v3 = p1:GetAttribute("Tab");

    if v3 == nil and v2 == nil then
        return nil;
    end;

    if v3 == nil then
        return v2;
    end;

    if v2 == nil then
        return {
            Tab = v3
        };
    end;

    if type(v2) ~= "table" then
        return {
            Tab = v3,
            itemType = v2
        };
    end;

    local v4 = table.clone(v2);
    v4.Tab = v3;

    return v4;
end;

local function _useClickDetector(p5) -- Line: 88
    return p5:GetAttribute("ClickDetector") == true;
end;

local function _getNextUpcomingEventId() -- Line: 97
    -- upvalues: LocalPlayer (copy)
    local v6 = LocalPlayer:FindFirstChild("事件通知") or LocalPlayer:WaitForChild("事件通知", 5);

    if not v6 then
        return nil;
    end;

    local v7 = v6:GetAttribute("NextEventId");

    if v7 == nil then
        local v8 = os.clock() + 5;

        while v7 == nil and os.clock() < v8 do
            task.wait(0.1);
            v7 = v6:GetAttribute("NextEventId");
        end;
    end;

    local v9 = tostring(v7 or "");

    if v9 == "" then
        return nil;
    end;

    return v9;
end;

local function _promptNextEventRsvp(u10) -- Line: 129
    -- upvalues: _getNextUpcomingEventId (copy), Log (copy), SocialService (copy)
    task.spawn(function() -- Line: 130
        -- upvalues: _getNextUpcomingEventId (ref), Log (ref), u10 (copy), SocialService (ref)
        local u11 = _getNextUpcomingEventId();

        if not u11 then
            Log.warn("[OpenUI] 活动预约无即将到来的活动:", u10:GetFullName());

            return;
        end;

        local success, result = pcall(function() -- Line: 137
            -- upvalues: SocialService (ref), u11 (copy)
            SocialService:PromptRsvpToEventAsync(u11);
        end);

        if not success then
            Log.warn("[OpenUI] PromptRsvpToEventAsync 失败:", result);
        end;
    end);
end;

local function _onOpenTriggered(u12, p13, p14) -- Line: 154
    -- upvalues: GetData (copy), LocalPlayer (copy), TipsModule (copy), _getNextUpcomingEventId (copy), Log (copy), SocialService (copy), NetWork (copy), NetMsg (copy)
    if p13 == "Alchemy" and not GetData.Alchemy.CanUseAlchemy(LocalPlayer) then
        TipsModule.ErrorTips(LocalPlayer, "炼金功能需要重生一次", nil);

        return;
    end;

    if p13 == "活动预约" then
        task.spawn(function() -- Line: 130
            -- upvalues: _getNextUpcomingEventId (ref), Log (ref), u12 (copy), SocialService (ref)
            local u15 = _getNextUpcomingEventId();

            if not u15 then
                Log.warn("[OpenUI] 活动预约无即将到来的活动:", u12:GetFullName());

                return;
            end;

            local success, result = pcall(function() -- Line: 137
                -- upvalues: SocialService (ref), u15 (copy)
                SocialService:PromptRsvpToEventAsync(u15);
            end);

            if not success then
                Log.warn("[OpenUI] PromptRsvpToEventAsync 失败:", result);
            end;
        end);

        return;
    end;

    NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, p13, p14, true, true, true);
end;

local u16 = {};
local u17 = {};

local function _unbindOpenUI(p18) -- Line: 179
    -- upvalues: u16 (copy), u17 (copy)
    if not p18 then
        return;
    end;

    local v19 = u16[p18];

    if not v19 then
        return;
    end;

    local v20 = u17[p18];

    if v20 then
        for _, v in ipairs(v20) do
            v:Disconnect();
        end;

        u17[p18] = nil;
    end;

    if v19.Parent then
        v19:Destroy();
    end;

    u16[p18] = nil;
end;

local function _bindClickDetector(u21, u22, u23) -- Line: 210
    -- upvalues: InsMgr (copy), LocalPlayer (copy), _onOpenTriggered (copy), u16 (copy), u17 (copy), _unbindOpenUI (copy)
    local u24 = InsMgr.GetIns("OpenUIClick_OpenUI", "ClickDetector", u21);
    u24.MaxActivationDistance = 100;
    local v26 = u24.MouseClick:Connect(function(p25) -- Line: 214
        -- upvalues: LocalPlayer (ref), _onOpenTriggered (ref), u21 (copy), u22 (copy), u23 (copy)
        if p25 ~= LocalPlayer then
            return;
        end;

        _onOpenTriggered(u21, u22, u23);
    end);
    u16[u21] = u24;
    u17[u21] = { v26 };
    table.insert(u17[u21], u24.AncestryChanged:Connect(function() -- Line: 226
        -- upvalues: u24 (copy), _unbindOpenUI (ref), u21 (copy)
        if not u24.Parent then
            _unbindOpenUI(u21);
        end;
    end));
end;

local function _bindProximityPrompt(u27, u28, u29) -- Line: 242
    -- upvalues: InsMgr (copy), TranslationHelper (copy), AddListen (copy), _onOpenTriggered (copy), u16 (copy), u17 (copy), _unbindOpenUI (copy)
    local u30 = InsMgr.GetIns("OpenUIPrompt_OpenUI", "ProximityPrompt", u27);
    u30.Enabled = true;

    if u27:GetAttribute("Top") == false then
        u30.RequiresLineOfSight = true;
    else
        u30.RequiresLineOfSight = false;
    end;

    u30.HoldDuration = 0.1;
    u30.Style = Enum.ProximityPromptStyle.Custom;
    local v31 = u27:GetAttribute("Prompt");
    local v32 = (typeof(v31) ~= "string" or v31 == "") and "购买" or v31;
    TranslationHelper.SetText(u30, v32);
    local v33 = AddListen.AddProximityPrompt(u30, function() -- Line: 262
        -- upvalues: _onOpenTriggered (ref), u27 (copy), u28 (copy), u29 (copy)
        _onOpenTriggered(u27, u28, u29);
    end);

    if not v33 then
        return;
    end;

    u16[u27] = u30;
    u17[u27] = { v33 };
    table.insert(u17[u27], u30.AncestryChanged:Connect(function() -- Line: 274
        -- upvalues: u30 (copy), _unbindOpenUI (ref), u27 (copy)
        if not u30.Parent then
            _unbindOpenUI(u27);
        end;
    end));
end;

local function _bindOpenUI(p34) -- Line: 288
    -- upvalues: u16 (copy), Log (copy), _buildUiDataFromAttributes (copy), _bindClickDetector (copy), _bindProximityPrompt (copy)
    if not (p34 and p34:IsA("BasePart")) then
        return;
    end;

    if u16[p34] then
        return;
    end;

    local v35 = p34:GetAttribute("UiName");

    if type(v35) ~= "string" or v35 == "" then
        Log.warn("[OpenUI] 缺少 UiName Attribute:", p34:GetFullName());

        return;
    end;

    local v36 = _buildUiDataFromAttributes(p34);

    if p34:GetAttribute("ClickDetector") == true then
        _bindClickDetector(p34, v35, v36);

        return;
    end;

    _bindProximityPrompt(p34, v35, v36);
end;

for _, v in CollectionService:GetTagged("OpenUI") do
    if v:IsA("BasePart") then
        _bindOpenUI(v);
    end;
end;

CollectionService:GetInstanceAddedSignal("OpenUI"):Connect(function(p37) -- Line: 316
    -- upvalues: _bindOpenUI (copy)
    if p37:IsA("BasePart") then
        _bindOpenUI(p37);
    end;
end);
CollectionService:GetInstanceRemovedSignal("OpenUI"):Connect(function(p38) -- Line: 322
    -- upvalues: _unbindOpenUI (copy)
    if p38:IsA("BasePart") then
        _unbindOpenUI(p38);
    end;
end);