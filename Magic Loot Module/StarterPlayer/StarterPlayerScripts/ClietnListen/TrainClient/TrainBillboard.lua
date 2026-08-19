-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local CollectionService = UtilsSystem.CollectionService;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local ResourceUtil = UtilsSystem.ResourceUtil;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local u1 = {};
local v2 = UtilsSystem.AssetRegistry.BuildCatalogPath("BillBoard", "TrainGui");
local u3 = ResourceUtil.GetTemplate(v2);

local function _getTrainIdFromCrystalRoot(p4) -- Line: 44
    -- upvalues: GetData (copy)
    local v5 = GetData.Train.GetTrainIdFromInstance(p4);

    if v5 then
        return v5;
    end;

    while p4 and p4 ~= workspace do
        if p4:IsA("Model") then
            local v6 = string.match(p4.Name, "^训练场(%d+)$");
            local v7 = tonumber(v6);

            if v7 and v7 > 0 then
                return math.floor(v7);
            end;
        end;

        p4 = p4.Parent;
    end;

    return nil;
end;

local function _getCrystalModelName(p8) -- Line: 69
    local Parent = p8.Parent;

    if Parent and Parent:IsA("Model") then
        return Parent.Name;
    end;

    return nil;
end;

local function _shouldHostGui(p9, p10) -- Line: 84
    -- upvalues: GetData (copy), LocalPlayer (copy)
    local Parent = p9.Parent;
    local v11;

    if Parent and Parent:IsA("Model") then
        v11 = Parent.Name;
    else
        v11 = nil;
    end;

    if v11 ~= "水晶" and v11 ~= "未解锁水晶" then
        return true;
    end;

    if GetData.Train.CanEnterTrainGround(LocalPlayer, p10).ok then
        return v11 == "水晶";
    end;

    return v11 == "未解锁水晶";
end;

local function _destroyGui(p12) -- Line: 103
    local TrainGui = p12:FindFirstChild("TrainGui");

    if TrainGui then
        TrainGui:Destroy();
    end;

    return nil;
end;

local function _getOrCloneGui(p13) -- Line: 117
    -- upvalues: u3 (copy)
    local TrainGui = p13:FindFirstChild("TrainGui");

    if TrainGui and TrainGui:IsA("BillboardGui") then
        TrainGui.Adornee = p13;

        return TrainGui;
    end;

    if not u3 then
        return nil;
    end;

    local v14 = u3:Clone();
    v14.Name = "TrainGui";
    v14.Adornee = p13;
    v14.Parent = p13;

    return v14;
end;

local function _renderGui(p15, p16) -- Line: 140
    -- upvalues: TranslationHelper (copy), GetData (copy), LocalPlayer (copy), UIMgr (copy)
    p15.Enabled = true;
    local Frame = p15:FindFirstChild("Frame");

    if not (Frame and Frame:IsA("CanvasGroup")) then
        return nil;
    end;

    local OnlyTag = p16.OnlyTag;
    local v17;

    if type(OnlyTag) == "string" then
        v17 = OnlyTag ~= "";
    else
        v17 = false;
    end;

    local v18;

    if v17 then
        v18 = 0;
    else
        local v19 = tonumber(p16.Rebirth) or 0;
        local v20 = math.floor(v19);
        v18 = math.max(0, v20);
    end;

    local Rebirth = Frame:FindFirstChild("Rebirth");

    if Rebirth and Rebirth:IsA("Frame") then
        Rebirth.Visible = v18 > 0;
        local Rebirth2 = Rebirth:FindFirstChild("Rebirth");

        if Rebirth2 and Rebirth2:IsA("TextLabel") then
            TranslationHelper.SetText_UnTrans(Rebirth2, (tostring(v18)));
        end;
    end;

    local Robux = Frame:FindFirstChild("Robux");

    if Robux and Robux:IsA("Frame") then
        if v17 then
            v17 = not GetData.IsHasPass(LocalPlayer, OnlyTag);
        end;

        Robux.Visible = v17;

        if v17 then
            local Num = Robux:FindFirstChild("Num");

            if Num and Num:IsA("TextLabel") then
                UIMgr.SetRobuxPriceLabel(Num, OnlyTag);
            end;
        end;
    end;

    local AddFrame = Frame:FindFirstChild("AddFrame");

    if AddFrame and AddFrame:IsA("Frame") then
        AddFrame.Visible = true;
        local Num = AddFrame:FindFirstChild("Num");

        if Num and Num:IsA("TextLabel") then
            TranslationHelper.SetText_UnTrans(Num, GetData.Train.FormatAddMul(tonumber(p16.Add) or 1));
        end;
    end;

    return nil;
end;

local function _refreshOne(p21) -- Line: 193
    -- upvalues: _getTrainIdFromCrystalRoot (copy), GetData (copy), LocalPlayer (copy), CfgFind (copy), u3 (copy), _renderGui (copy)
    if not p21:IsA("BasePart") then
        return nil;
    end;

    local v22 = _getTrainIdFromCrystalRoot(p21);

    if not v22 then
        return nil;
    end;

    local Parent = p21.Parent;
    local v23;

    if Parent and Parent:IsA("Model") then
        v23 = Parent.Name;
    else
        v23 = nil;
    end;

    local v24;

    if v23 == "水晶" or v23 == "未解锁水晶" then
        if GetData.Train.CanEnterTrainGround(LocalPlayer, v22).ok then
            v24 = v23 == "水晶";
        else
            v24 = v23 == "未解锁水晶";
        end;
    else
        v24 = true;
    end;

    if not v24 then
        local TrainGui = p21:FindFirstChild("TrainGui");

        if TrainGui then
            TrainGui:Destroy();
        end;

        return nil;
    end;

    local v25 = CfgFind.FindTrainCfgById(v22);

    if not v25 then
        return nil;
    end;

    local TrainGui = p21:FindFirstChild("TrainGui");

    if TrainGui and TrainGui:IsA("BillboardGui") then
        TrainGui.Adornee = p21;
    elseif u3 then
        TrainGui = u3:Clone();
        TrainGui.Name = "TrainGui";
        TrainGui.Adornee = p21;
        TrainGui.Parent = p21;
    else
        TrainGui = nil;
    end;

    if not TrainGui then
        return nil;
    end;

    _renderGui(TrainGui, v25);

    return nil;
end;

function u1.RefreshAll() -- Line: 222
    -- upvalues: CollectionService (copy), _refreshOne (copy)
    for _, v in CollectionService:GetTagged("Crystal") do
        _refreshOne(v);
    end;

    return nil;
end;

local function _bindGamePassWatch() -- Line: 234
    -- upvalues: CfgFind (copy), LocalPlayer (copy), u1 (copy)
    task.spawn(function() -- Line: 235
        -- upvalues: CfgFind (ref), LocalPlayer (ref), u1 (ref)
        local v26 = CfgFind.CollectTrainPassOnlyTags();

        if #v26 == 0 then
            return nil;
        end;

        local GamePass = LocalPlayer:WaitForChild("GamePass", (1 / 0));

        for _, v in v26 do
            local v27 = GamePass:WaitForChild(v, (1 / 0));

            if v27:IsA("NumberValue") then
                v27.Changed:Connect(u1.RefreshAll);
            end;
        end;
    end);

    return nil;
end;

local function _bindRebirthWatch() -- Line: 256
    -- upvalues: GetData (copy), LocalPlayer (copy), EnumMgr (copy), u1 (copy)
    task.spawn(function() -- Line: 257
        -- upvalues: GetData (ref), LocalPlayer (ref), EnumMgr (ref), u1 (ref)
        local v28 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Rebirth);
        u1.RefreshAll();
        v28.Changed:Connect(u1.RefreshAll);
    end);

    return nil;
end;

function u1.Init() -- Line: 271
    -- upvalues: u1 (copy), CollectionService (copy), _refreshOne (copy), CfgFind (copy), LocalPlayer (copy), GetData (copy), EnumMgr (copy)
    u1.RefreshAll();
    CollectionService:GetInstanceAddedSignal("Crystal"):Connect(function(u29) -- Line: 273
        -- upvalues: _refreshOne (ref)
        task.defer(function() -- Line: 274
            -- upvalues: _refreshOne (ref), u29 (copy)
            _refreshOne(u29);
        end);
    end);
    task.spawn(function() -- Line: 235
        -- upvalues: CfgFind (ref), LocalPlayer (ref), u1 (ref)
        local v30 = CfgFind.CollectTrainPassOnlyTags();

        if #v30 == 0 then
            return nil;
        end;

        local GamePass = LocalPlayer:WaitForChild("GamePass", (1 / 0));

        for _, v in v30 do
            local v31 = GamePass:WaitForChild(v, (1 / 0));

            if v31:IsA("NumberValue") then
                v31.Changed:Connect(u1.RefreshAll);
            end;
        end;
    end);
    task.spawn(function() -- Line: 257
        -- upvalues: GetData (ref), LocalPlayer (ref), EnumMgr (ref), u1 (ref)
        local v32 = GetData.WaitBagNumberValue(LocalPlayer, EnumMgr.ItemID.Rebirth);
        u1.RefreshAll();
        v32.Changed:Connect(u1.RefreshAll);
    end);

    return nil;
end;

return u1;