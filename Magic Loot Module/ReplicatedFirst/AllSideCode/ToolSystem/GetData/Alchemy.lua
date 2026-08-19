-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CollectionService = game:GetService("CollectionService");
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local PlayerData = UtilsSystem.PlayerData;
local Bag = require(script.Parent.Bag);
local ItemType = EnumMgr.ItemType;
local u1 = {};
local u2 = Color3.fromRGB(255, 255, 255);
local u3 = Color3.fromRGB(255, 80, 80);

local function _isRecipeShapeValid(p4) -- Line: 94
    if type(p4) ~= "table" then
        return false;
    end;

    local MID = p4.MID;
    local NeedCount = p4.NeedCount;

    if type(MID) == "table" and type(NeedCount) == "table" then
        return #MID ~= 0 and #MID == #NeedCount;
    end;

    return false;
end;

local function _getPlayerRebirthCount(p5) -- Line: 115
    -- upvalues: Bag (copy), EnumMgr (copy)
    if not (p5 and p5.Parent) then
        return 0;
    end;

    local v6 = Bag.GetItemCountByID(p5, EnumMgr.ItemID.Rebirth) or 0;

    return math.floor(v6);
end;

function u1.CanUseAlchemy(p7) -- Line: 128
    -- upvalues: Bag (copy), EnumMgr (copy)
    if not (p7 and p7.Parent) then
        return false;
    end;

    local v8;

    if p7 and p7.Parent then
        local v9 = Bag.GetItemCountByID(p7, EnumMgr.ItemID.Rebirth) or 0;
        v8 = math.floor(v9);
    else
        v8 = 0;
    end;

    return v8 >= 0;
end;

function u1.GetAlchemyNeedRebirth() -- Line: 140
    return 0;
end;

function u1.GetRecipeNeedRebirth(p10) -- Line: 150
    if type(p10) ~= "table" then
        return 0;
    end;

    local v11 = tonumber(p10.Rebirth);

    return (not v11 or v11 <= 0) and 0 or math.floor(v11);
end;

function u1.CanMeetRecipeRebirth(p12, p13) -- Line: 168
    -- upvalues: u1 (copy), Bag (copy), EnumMgr (copy)
    local v14 = u1.GetRecipeNeedRebirth(p13);

    if v14 <= 0 then
        return true;
    end;

    if not (p12 and p12.Parent) then
        return false;
    end;

    local v15;

    if p12 and p12.Parent then
        local v16 = Bag.GetItemCountByID(p12, EnumMgr.ItemID.Rebirth) or 0;
        v15 = math.floor(v16);
    else
        v15 = 0;
    end;

    return v14 <= v15;
end;

function u1.GetRecipeList() -- Line: 184
    -- upvalues: CfgFind (copy)
    local v17 = CfgFind.GetAlchemyRecipeList();
    table.sort(v17, function(p18, p19) -- Line: 186
        local v20 = tonumber(p18.Sort) or 0;
        local v21 = tonumber(p19.Sort) or 0;

        if v20 == v21 then
            return (tonumber(p18.recipeId) or 0) < (tonumber(p19.recipeId) or 0);
        end;

        return v20 < v21;
    end);

    return v17;
end;

function u1.GetMaterialOwnedCount(p22, p23) -- Line: 207
    -- upvalues: ItemType (copy)
    if type(p22) ~= "table" or not p23 then
        return 0;
    end;

    local v24 = 0;

    for _, v in pairs(p22) do
        if type(v) == "table" and (tonumber(v.id) == p23 and tonumber(v.tp) == ItemType.Material) then
            local v25 = tonumber(v.count) or 1;
            v24 = v24 + math.max(1, v25);
        end;
    end;

    return v24;
end;

function u1.CanCraftRecipe(p26, p27) -- Line: 227
    -- upvalues: u1 (copy)
    local v28;

    if type(p27) == "table" then
        local MID = p27.MID;
        local NeedCount = p27.NeedCount;

        if type(MID) == "table" and type(NeedCount) == "table" then
            v28 = #MID ~= 0 and #MID == #NeedCount;
        else
            v28 = false;
        end;
    else
        v28 = false;
    end;

    if not v28 then
        return false;
    end;

    local MID = p27.MID;
    local NeedCount = p27.NeedCount;

    for i = 1, #MID do
        local v29 = tonumber(MID[i]);
        local v30 = tonumber(NeedCount[i]) or 0;

        if not v29 or v30 <= 0 then
            return false;
        end;

        if u1.GetMaterialOwnedCount(p26, v29) < v30 then
            return false;
        end;
    end;

    return true;
end;

function u1.FormatNeedCount(p31, p32) -- Line: 253
    local v33 = tonumber(p31) or 0;
    local v34 = math.floor(v33);
    local v35 = math.max(0, v34);
    local v36 = tonumber(p32) or 0;
    local v37 = math.floor(v36);
    local v38 = math.max(0, v37);

    return tostring(v35) .. "/" .. tostring(v38);
end;

function u1.GetNeedCountColor(p39, p40) -- Line: 266
    -- upvalues: u3 (copy), u2 (copy)
    if (tonumber(p39) or 0) < (tonumber(p40) or 0) then
        return u3;
    end;

    return u2;
end;

function u1.GetPotionBrewRecordKey(p41) -- Line: 279
    return "炼制药水_" .. tostring(p41);
end;

function u1.IsPotionBrewed(p42, p43) -- Line: 290
    -- upvalues: PlayerData (copy), u1 (copy)
    if not (p42 and p43) then
        return false;
    end;

    local v44 = PlayerData.GetPlrDataByKey(p42, "Record");

    if type(v44) ~= "table" then
        return false;
    end;

    local v45 = v44[u1.GetPotionBrewRecordKey(p43)];
    local v46;

    if type(v45) == "number" then
        v46 = v45 > 0;
    else
        v46 = false;
    end;

    return v46;
end;

function u1.GetSkillIdFromPotion(p47) -- Line: 308
    -- upvalues: CfgFind (copy), ItemType (copy)
    local v48 = CfgFind.FindCfgByID(p47, ItemType.Potion);

    if not v48 then
        return nil;
    end;

    local v49 = tonumber(v48.SkillID) or 0;

    if v49 <= 0 then
        return nil;
    end;

    return v49;
end;

function u1.GetBuffIdFromPotion(p50) -- Line: 326
    -- upvalues: CfgFind (copy), ItemType (copy)
    local v51 = CfgFind.FindCfgByID(p50, ItemType.Potion);

    if not v51 then
        return nil;
    end;

    local v52 = tonumber(v51.BuffID) or 0;

    if v52 <= 0 then
        return nil;
    end;

    return v52;
end;

function u1.ShouldGrantEventPotionAsPay(p53) -- Line: 347
    -- upvalues: u1 (copy)
    return u1.GetSkillIdFromPotion(p53) ~= nil;
end;

function u1.GetRecipeCraftTimeSeconds(p54) -- Line: 357
    local v55;

    if type(p54) == "table" then
        v55 = tonumber(p54.Time);
    else
        v55 = nil;
    end;

    return (not v55 or v55 <= 0) and 1 or math.floor(v55);
end;

function u1.GetBrewPotionIdValueName() -- Line: 370
    return "炼金炼制药水ID";
end;

function u1.GetBrewFinishUnixValueName() -- Line: 379
    return "炼金炼制完成Unix";
end;

function u1.GetMarkFolderName() -- Line: 388
    return "炼金标记";
end;

function u1.GetMarkRecipeIdValueName() -- Line: 397
    return "RecipeId";
end;

function u1.GetMarkedRecipeId(p56) -- Line: 407
    -- upvalues: PlayerData (copy)
    if not (p56 and p56.Parent) then
        return 0;
    end;

    local v57 = p56:FindFirstChild("炼金标记");

    if not (v57 and v57:IsA("Folder")) then
        return 0;
    end;

    local RecipeId = v57:FindFirstChild("RecipeId");

    if RecipeId and RecipeId:IsA("NumberValue") then
        local v58 = math.floor(RecipeId.Value);
        local v59 = math.max(0, v58);

        if v59 > 0 then
            return v59;
        end;
    end;

    local v60 = tonumber(PlayerData.GetPlrDataByKey(p56, "AlchemyMarkRecipeId")) or 0;

    return v60 <= 0 and 0 or math.floor(v60);
end;

function u1.GetMarkMaterialRemain(p61, p62) -- Line: 437
    if not (p61 and p61.Parent) then
        return 0;
    end;

    local v63 = tonumber(p62);

    if not v63 or v63 <= 0 then
        return 0;
    end;

    local v64 = p61:FindFirstChild("炼金标记");

    if not (v64 and v64:IsA("Folder")) then
        return 0;
    end;

    local v65 = math.floor(v63);
    local v66 = v64:FindFirstChild((tostring(v65)));

    if not (v66 and v66:IsA("NumberValue")) then
        return 0;
    end;

    local v67 = math.floor(v66.Value);

    return math.max(0, v67);
end;

function u1.IsMarkedRecipeMaterial(p68, p69) -- Line: 463
    -- upvalues: u1 (copy), CfgFind (copy)
    if not (p68 and p68.Parent) then
        return false;
    end;

    local v70 = tonumber(p69);

    if not v70 or v70 <= 0 then
        return false;
    end;

    local v71 = u1.GetMarkedRecipeId(p68);

    if v71 <= 0 then
        return false;
    end;

    local v72 = CfgFind.FindAlchemyRecipeById(v71);

    if not v72 then
        return false;
    end;

    local MID = v72.MID;

    if type(MID) ~= "table" then
        return false;
    end;

    for _, v in MID do
        if tonumber(v) == v70 then
            return true;
        end;
    end;

    return false;
end;

function u1.CalcMarkMaterialRemain(p73, p74, p75) -- Line: 500
    local v76 = tonumber(p73) or 0;
    local v77 = math.floor(v76);
    local v78 = math.max(0, v77);
    local v79 = tonumber(p74) or 0;
    local v80 = math.floor(v79);
    local v81 = math.max(0, v80);
    local v82 = tonumber(p75) or 0;
    local v83 = math.floor(v82);
    local v84 = math.max(0, v83);

    return math.max(0, v78 - v81 - v84);
end;

local function _findFinishSlotModel(p85, p86) -- Line: 514
    -- upvalues: _findFinishSlotModel (copy)
    local v87 = p85:FindFirstChild("镜头动画", true);

    if v87 then
        local v88 = v87:FindFirstChild(p86);

        if v88 and v88:IsA("Model") then
            return v88;
        end;
    end;

    for _, child in p85:GetChildren() do
        if child:IsA("Folder") or child:IsA("Model") then
            local v89 = _findFinishSlotModel(child, p86);

            if v89 then
                return v89;
            end;
        end;
    end;

    return nil;
end;

function u1.ResolveFinishSpawnCFrame(p90) -- Line: 539
    -- upvalues: CfgFind (copy), ItemType (copy), _findFinishSlotModel (copy)
    local v91 = CfgFind.FindCfgByID(p90, ItemType.Potion);
    local v92 = (not v91 or (type(v91.Model) ~= "string" or v91.Model == "")) and "地属性药水瓶Lv1" or v91.Model;
    local v93 = workspace:FindFirstChild("场景");

    if not v93 then
        return nil;
    end;

    local v94 = v93:FindFirstChild("炼药场景", true) or v93;
    local v95 = _findFinishSlotModel(v94, v92);

    if not v95 and v92 ~= "地属性药水瓶Lv1" then
        v95 = _findFinishSlotModel(v94, "地属性药水瓶Lv1");
    end;

    if v95 then
        return v95:GetPivot() * CFrame.Angles(0, 3.141592653589793, 0);
    end;

    return nil;
end;

local function _getWorldCFrame(p96) -- Line: 572
    if p96:IsA("Model") then
        return p96:GetPivot();
    end;

    if p96:IsA("BasePart") then
        return p96.CFrame;
    end;

    if p96:IsA("Attachment") then
        return p96.WorldCFrame;
    end;

    return nil;
end;

local function _findAlchemyScene() -- Line: 590
    local v97 = workspace:FindFirstChild("场景");

    if not v97 then
        return nil;
    end;

    local v98 = v97:FindFirstChild("大厅");
    local v99;

    if v98 then
        v99 = v98:FindFirstChild("功能");
    else
        v99 = nil;
    end;

    local v100;

    if v99 then
        v100 = v99:FindFirstChild("炼药场景");
    else
        v100 = nil;
    end;

    return v100 or v97:FindFirstChild("炼药场景", true);
end;

function u1.FindAlchemyScene() -- Line: 610
    -- upvalues: _findAlchemyScene (copy)
    return _findAlchemyScene();
end;

function u1.ResolveBrewActorCFrame() -- Line: 619
    -- upvalues: _findAlchemyScene (copy), _getWorldCFrame (copy)
    local v101 = _findAlchemyScene() or workspace:FindFirstChild("场景");

    if not v101 then
        return nil;
    end;

    local v102 = v101:FindFirstChild("镜头动画", true);

    if not v102 then
        return nil;
    end;

    local v103 = v102:FindFirstChild("炼金人");

    if v103 then
        return _getWorldCFrame(v103);
    end;

    return nil;
end;

function u1.ResolveStage1CameraCFrame() -- Line: 645
    -- upvalues: _findAlchemyScene (copy), _getWorldCFrame (copy)
    local v104 = _findAlchemyScene();

    if not v104 then
        return nil;
    end;

    local v105 = v104:FindFirstChild("摄像机_1阶段") or v104:FindFirstChild("摄像机_1阶段", true);

    if v105 then
        return _getWorldCFrame(v105);
    end;

    return nil;
end;

function u1.ResolveStage2CameraCFrame() -- Line: 667
    -- upvalues: _findAlchemyScene (copy), _getWorldCFrame (copy)
    local v106 = _findAlchemyScene();

    if not v106 then
        return nil;
    end;

    local v107 = v106:FindFirstChild("摄像机_2阶段") or v106:FindFirstChild("摄像机_2阶段", true);

    if v107 then
        return _getWorldCFrame(v107);
    end;

    return nil;
end;

function u1.ResolveStage3CameraCFrame() -- Line: 689
    -- upvalues: _findAlchemyScene (copy), _getWorldCFrame (copy)
    local v108 = _findAlchemyScene();

    if not v108 then
        return nil;
    end;

    local v109 = v108:FindFirstChild("摄像机_3阶段") or v108:FindFirstChild("摄像机_3阶段", true);

    if v109 then
        return _getWorldCFrame(v109);
    end;

    return nil;
end;

function u1.IsPlayerMaterialBrewing(p110) -- Line: 712
    if not p110 then
        return false;
    end;

    local v111 = p110:FindFirstChild("炼金炼制药水ID");

    if v111 and v111:IsA("NumberValue") then
        return math.floor(v111.Value) > 0;
    end;

    return false;
end;

local function _readBrewMirror(p112) -- Line: 729
    if not p112 then
        return 0, 0;
    end;

    local v113 = p112:FindFirstChild("炼金炼制药水ID");
    local v114 = p112:FindFirstChild("炼金炼制完成Unix");
    local v115 = not (v113 and v113:IsA("NumberValue")) and 0 or math.floor(v113.Value);

    if v114 and v114:IsA("NumberValue") then
        return v115, math.floor(v114.Value);
    end;

    return v115, 0;
end;

function u1.IsBrewInProgress(p116, p117) -- Line: 747
    -- upvalues: _readBrewMirror (copy)
    local v118, v119 = _readBrewMirror(p116);

    if v118 <= 0 or v119 <= 0 then
        return false;
    end;

    local v120;

    if p117 then
        v120 = math.floor(p117);
    else
        v120 = os.time();
    end;

    return v120 < v119;
end;

function u1.IsBrewReadyForPickup(p121, p122) -- Line: 763
    -- upvalues: _readBrewMirror (copy)
    local v123, v124 = _readBrewMirror(p121);

    if v123 <= 0 or v124 <= 0 then
        return false;
    end;

    local v125;

    if p122 then
        v125 = math.floor(p122);
    else
        v125 = os.time();
    end;

    return v124 <= v125;
end;

function u1.GetBrewRemainingSeconds(p126, p127) -- Line: 779
    -- upvalues: _readBrewMirror (copy)
    local v128, v129 = _readBrewMirror(p126);

    if v128 <= 0 or v129 <= 0 then
        return 0;
    end;

    local v130;

    if p127 then
        v130 = math.floor(p127);
    else
        v130 = os.time();
    end;

    return math.max(0, v129 - v130);
end;

function u1.GetFinishModelName(p131) -- Line: 794
    return "AlchemyFinish_" .. tostring(p131);
end;

function u1.GetAlchemyRootTagName() -- Line: 803
    return "AlchemyRoot";
end;

function u1.FindAlchemyRoot() -- Line: 812
    -- upvalues: CollectionService (copy)
    local v132 = CollectionService:GetTagged("AlchemyRoot");

    if #v132 == 0 then
        return nil;
    end;

    return v132[1];
end;

local function _findHeadTagGuiFrom(p133) -- Line: 826
    local v134 = p133:FindFirstChild("HeadTag") or p133:FindFirstChild("HeadTag", true);

    if not v134 then
        return nil;
    end;

    local HeadTag = v134:FindFirstChild("HeadTag");

    if HeadTag and HeadTag:IsA("BillboardGui") then
        return HeadTag;
    end;

    if v134:IsA("BillboardGui") then
        return v134;
    end;

    return nil;
end;

function u1.FindAlchemyHeadTagGui() -- Line: 851
    -- upvalues: u1 (copy), _findHeadTagGuiFrom (copy)
    local v135 = u1.FindAlchemyRoot();

    if v135 then
        local v136 = _findHeadTagGuiFrom(v135);

        if v136 then
            return v136;
        end;

        local v137 = v135:FindFirstChild("炼药场景", true);
        local v138 = v137 and _findHeadTagGuiFrom(v137);

        if v138 then
            return v138;
        end;
    end;

    local v139 = workspace:FindFirstChild("场景");
    local v140 = v139 and v139:FindFirstChild("炼药场景", true);

    if v140 then
        return _findHeadTagGuiFrom(v140);
    end;

    return nil;
end;

function u1.FindBrewTimeTextLabel() -- Line: 882
    -- upvalues: u1 (copy)
    local v141 = u1.FindAlchemyHeadTagGui();

    if not v141 then
        return nil;
    end;

    local Frame = v141:FindFirstChild("Frame");
    local v142;

    if Frame then
        v142 = Frame:FindFirstChild("倒计时");
    else
        v142 = nil;
    end;

    local v143;

    if v142 then
        v143 = v142:FindFirstChild("Text");
    else
        v143 = nil;
    end;

    if v143 and v143:IsA("TextLabel") then
        return v143;
    end;

    return nil;
end;

return u1;