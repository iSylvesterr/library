-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local MathMgr = UtilsSystem.MathMgr;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local TimeTransfer = UtilsSystem.TimeTransfer;
local TipsModule = UtilsSystem.TipsModule;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local AllUI = require(script.Parent.AllUI);
local TaskResetType = EnumMgr.TaskResetType;
local u1 = {};
local u2 = {
    {
        key = "Timed",
        layoutBase = 100,
        resetType = TaskResetType.Timed
    },
    {
        key = "Daily",
        layoutBase = 200,
        resetType = TaskResetType.Daily
    },
    {
        key = "Once",
        layoutBase = 300,
        resetType = TaskResetType.Once
    }
};
local u3 = false;
local u4 = 0;

local function _timedRemainSec() -- Line: 81
    -- upvalues: CfgFind (copy)
    local TimedTaskResetSec = CfgFind.GetEventGameConfig().TimedTaskResetSec;
    local v5 = tonumber(TimedTaskResetSec) or 3600;
    local v6 = math.max(1, v5);
    local v7 = workspace:GetServerTimeNow();

    return v6 - math.floor(v7) % v6;
end;

local function _splitHMS(p8) -- Line: 94
    local v9 = math.floor(p8);
    local v10 = math.max(0, v9);

    return math.floor(v10 / 3600), math.floor(v10 % 3600 / 60), v10 % 60;
end;

local function _activeOnlyTags(p11, p12) -- Line: 110
    -- upvalues: CfgFind (copy), TaskResetType (copy)
    local v13 = (type(p12.Once) ~= "table" or type(p12.Once.Completed) ~= "table") and {} or p12.Once.Completed;
    local v14 = CfgFind.GetEventGameConfig();
    local v15 = v14.OnceTaskRefill == true;
    local v16 = tonumber(v14.MaxTasksPerResetType) or 3;
    local v17 = math.max(1, v16);

    if p11 == TaskResetType.Once and not v15 then
        local v18;

        if type(p12.Once) == "table" then
            v18 = p12.Once.Accepted;
        else
            v18 = nil;
        end;

        if type(v18) == "table" and #v18 > 0 then
            local v19 = {};

            for _, v in ipairs(v18) do
                local v20 = tostring(v or "");

                if v20 ~= "" then
                    table.insert(v19, v20);
                end;
            end;

            return v19;
        end;
    end;

    local v21 = CfgFind.GetTaskListByResetType(p11);
    local v22 = {};

    for _, v in ipairs(v21) do
        local v23 = tostring(v.onlyTag or "");

        if v23 ~= "" then
            if p11 ~= TaskResetType.Once or tonumber(v13[v23]) ~= 1 then
                table.insert(v22, v23);

                if v17 <= #v22 then
                    break;
                end;
            end;
        end;
    end;

    return v22;
end;

local function _getTaskRoot() -- Line: 156
    -- upvalues: PlayerData (copy), LocalPlayer (copy)
    local v24 = PlayerData.GetPlrDataByKey(LocalPlayer, "Event");

    if type(v24) == "table" and type(v24.EventTask) == "table" then
        return v24.EventTask;
    end;

    return nil;
end;

local function _buildRows(p25, p26) -- Line: 170
    -- upvalues: TaskResetType (copy), _activeOnlyTags (copy), CfgFind (copy)
    local v27 = p26[p25 == TaskResetType.Timed and "Timed" or (p25 == TaskResetType.Daily and "Daily" or "Once")];
    local v28 = {};
    local v29 = {};

    if type(v27) == "table" then
        if type(v27.Progress) == "table" then
            v28 = v27.Progress;
        end;

        if type(v27.Completed) == "table" then
            v29 = v27.Completed;
        end;
    end;

    local v30 = {};

    for _, v in ipairs((_activeOnlyTags(p25, p26))) do
        local v31 = CfgFind.GetTaskCfgByOnlyTag(v);

        if v31 then
            local need = v31.need;
            local v32;

            if type(need) == "table" then
                local v33 = tonumber(need[1]) or 1;
                v32 = math.max(1, v33);
            else
                local v34 = tonumber(need) or 1;
                v32 = math.max(1, v34);
            end;

            local v35 = tonumber(v28[v]) or 0;
            local v36 = tonumber(v29[v]) == 1;
            local v37 = {
                onlyTag = v,
                need = v32,
                progress = v35,
                claimed = v36
            };
            v37.canClaim = not v36 and v32 <= v35;
            v37.ResetType = p25;
            v37.cfg = v31;
            table.insert(v30, v37);
        end;
    end;

    return v30;
end;

local function _applyTitleText(p38, p39) -- Line: 219
    -- upvalues: CfgFind (copy), TranslationHelper (copy), TimeTransfer (copy)
    local TaskType = p38:FindFirstChild("TaskType");

    if not (TaskType and TaskType:IsA("TextLabel")) then
        return;
    end;

    if p39 ~= "Timed" then
        if p39 ~= "Daily" then
            TranslationHelper.SetText(TaskType, "赛季一次性任务");

            return;
        end;

        local v40 = TimeTransfer.GetSecondsUntilNextDay();
        local v41 = math.floor(v40);
        local v42 = math.max(0, v41);
        local v43 = { math.floor(v42 / 3600), math.floor(v42 % 3600 / 60), v42 % 60 };
        TranslationHelper.SetText(TaskType, "还要刷新每日任务", v43);

        return;
    end;

    local TimedTaskResetSec = CfgFind.GetEventGameConfig().TimedTaskResetSec;
    local v44 = tonumber(TimedTaskResetSec) or 3600;
    local v45 = math.max(1, v44);
    local v46 = workspace:GetServerTimeNow();
    local v47 = v45 - math.floor(v46) % v45;
    local v48 = math.floor(v47);
    local v49 = math.max(0, v48);
    local v50 = { math.floor(v49 / 3600), math.floor(v49 % 3600 / 60), v49 % 60 };
    TranslationHelper.SetText(TaskType, "还要刷新限时任务", v50);
end;

local function _applyTaskDes(p51, p52) -- Line: 240
    -- upvalues: TranslationHelper (copy), UIMgr (copy)
    local TaskDes = p51:FindFirstChild("TaskDes");

    if not (TaskDes and TaskDes:IsA("TextLabel")) then
        return;
    end;

    local TaskType = p52.TaskType;

    if type(TaskType) ~= "table" or #TaskType == 0 then
        TranslationHelper.SetText(TaskDes, p52.ZhName or "");

        return;
    end;

    local v53 = tostring(TaskType[1] or "");
    local v54, v55 = UIMgr.GetTaskDesText(p52, 1, v53);

    if v54 and v55 then
        TranslationHelper.SetText(TaskDes, v55, v54);

        return;
    end;

    TranslationHelper.SetText(TaskDes, p52.ZhName or v53);
end;

local function _applyReward(p56, p57) -- Line: 264
    -- upvalues: CfgFind (copy), UIMgr (copy), TranslationHelper (copy), MathMgr (copy)
    local Value = p56:FindFirstChild("Value");

    if not Value then
        return;
    end;

    local award = p57.award;
    local count = p57.count;
    local v58;

    if type(award) == "table" then
        v58 = tonumber(award[1]) or 0;
    else
        v58 = tonumber(award) or 0;
    end;

    local v59;

    if type(count) == "table" then
        v59 = tonumber(count[1]) or 0;
    else
        v59 = tonumber(count) or 0;
    end;

    local Icon = Value:FindFirstChild("Icon");

    if Icon and (Icon:IsA("ImageLabel") and v58 > 0) then
        local v60 = CfgFind.FindCfgByID(v58);
        local v61 = v60 and tostring(v60.Icon or "") or "";

        if v61 ~= "" and v61 ~= "0" then
            UIMgr.SetImage(Icon, v61);
            Icon.Visible = true;
        end;
    end;

    local Num = Value:FindFirstChild("Num");

    if Num and Num:IsA("TextLabel") then
        TranslationHelper.SetText_UnTrans(Num, MathMgr.getNumStr(v59));
    end;
end;

local function _applyProgress(p62, p63) -- Line: 304
    -- upvalues: TaskResetType (copy), TranslationHelper (copy)
    local v64 = p62:FindFirstChild("已完成Bg");

    if v64 and v64:IsA("GuiObject") then
        local v65 = p63.claimed == true;
        v64.Visible = v65;

        if v65 then
            local v66 = v64:FindFirstChild("等待刷新");
            local v67 = v64:FindFirstChild("已完成");
            local v68 = p63.ResetType == TaskResetType.Once;

            if v66 and v66:IsA("TextLabel") then
                v66.Visible = not v68;

                if not v68 then
                    TranslationHelper.SetText(v66, "等待刷新");
                end;
            end;

            if v67 and v67:IsA("TextLabel") then
                v67.Visible = v68;

                if v68 then
                    TranslationHelper.SetText(v67, "已完成");
                end;
            end;
        end;
    end;

    local v69 = p62:FindFirstChild("进度条");

    if not v69 then
        return;
    end;

    local v70 = p63.need <= 0 and 0 or math.clamp(p63.progress / p63.need, 0, 1);
    local v71 = p63.progress >= p63.need;
    local Bar = v69:FindFirstChild("Bar");
    local v72 = v69:FindFirstChild("已完成任务Bar");

    if Bar and Bar:IsA("GuiObject") then
        local Y = Bar.Size.Y;
        Bar.Size = UDim2.new(v70, 0, Y.Scale, Y.Offset);
        Bar.Visible = not v71;
    end;

    if v72 and v72:IsA("GuiObject") then
        v72.Visible = v71;

        if v71 then
            local Y = v72.Size.Y;
            v72.Size = UDim2.new(1, 0, Y.Scale, Y.Offset);
        end;
    end;

    local v73 = v69:FindFirstChild("进度");

    if v73 and v73:IsA("TextLabel") then
        local v74 = math.min(p63.progress, p63.need);

        if v71 then
            TranslationHelper.SetText_UnTrans(v73, tostring(v74) .. "/" .. tostring(p63.need));

            return;
        end;

        v73.RichText = true;
        TranslationHelper.SetText(v73, "活动任务进度未完成", { v74, p63.need });
    end;
end;

local function _applyOkBtn(p75, p76) -- Line: 372
    local OkBtn = p75:FindFirstChild("OkBtn");

    if not OkBtn then
        return;
    end;

    if p76.claimed then
        OkBtn.Visible = false;

        return;
    end;

    OkBtn.Visible = true;
    local UnBg = OkBtn:FindFirstChild("UnBg");
    local Bg = OkBtn:FindFirstChild("Bg");
    local canClaim = p76.canClaim;

    if UnBg and UnBg:IsA("GuiObject") then
        UnBg.Visible = not canClaim;
    end;

    if Bg and Bg:IsA("GuiObject") then
        Bg.Visible = canClaim;
    end;
end;

local function _bindClaim(u77, u78) -- Line: 399
    -- upvalues: UIMgr (copy), Log (copy), AddListen (copy), TipsModule (copy), LocalPlayer (copy), u3 (ref), NetWork (copy), NetMsg (copy), u1 (copy)
    if u77:GetAttribute("EventTaskBound") == true then
        return;
    end;

    local OkBtn = u77:FindFirstChild("OkBtn");

    if not OkBtn then
        return;
    end;

    local v79 = UIMgr.FindButtonInFrame(OkBtn);
    local v80;

    if v79 then
        v80 = v79;
    else
        v80 = OkBtn:FindFirstChild("Btn");

        if v80 then
            if not v80:IsA("GuiButton") then
                v80 = v79;
            end;
        else
            v80 = v79;
        end;
    end;

    if not v80 then
        Log.warn("[EventTaskTab] 缺少 OkBtn.Btn:", u77:GetFullName());

        return;
    end;

    u77:SetAttribute("EventTaskBound", true);
    AddListen.AddMouseCLick(v80, function() -- Line: 419
        -- upvalues: u77 (copy), TipsModule (ref), LocalPlayer (ref), u3 (ref), NetWork (ref), NetMsg (ref), u78 (copy), Log (ref), u1 (ref)
        local v81 = u77:GetAttribute("EventTaskClaimed") == true;
        local v82 = u77:GetAttribute("EventTaskCanClaim") == true;

        if v81 then
            return;
        end;

        if not v82 then
            TipsModule.ErrorTips(LocalPlayer, "还未完成任务");

            return;
        end;

        if u3 then
            return;
        end;

        u3 = true;
        local success, result = pcall(function() -- Line: 433
            -- upvalues: NetWork (ref), NetMsg (ref), u78 (ref)
            return NetWork.InvokeServer(NetMsg.EVENT_TASK_CLAIM, u78);
        end);
        u3 = false;

        if success then
            if result == true then
                u1.Refresh();
            end;

            return;
        end;

        Log.warn("[EventTaskTab] claim fail:", u78, result);
    end, OkBtn);
end;

local function _applyRowState(p83, p84) -- Line: 452
    -- upvalues: _applyProgress (copy), _applyOkBtn (copy)
    p83:SetAttribute("EventTaskCanClaim", p84.canClaim);
    p83:SetAttribute("EventTaskClaimed", p84.claimed);
    _applyProgress(p83, p84);
    _applyOkBtn(p83, p84);
end;

local function _scrollToFirstClaimable() -- Line: 462
    -- upvalues: AllUI (copy), UIMgr (copy)
    local Task = AllUI.Task;

    if not (Task and Task:IsA("ScrollingFrame")) then
        return;
    end;

    local v85 = (1 / 0);
    local v86 = nil;

    for _, child in ipairs(Task:GetChildren()) do
        if child:IsA("GuiObject") and (string.sub(child.Name, 1, 5) == "Task_" and child:GetAttribute("EventTaskCanClaim") == true) then
            local LayoutOrder = child.LayoutOrder;

            if LayoutOrder < v85 then
                v86 = child;
                v85 = LayoutOrder;
            end;
        end;
    end;

    if not v86 then
        return;
    end;

    UIMgr.ScheduleScrollToChild(Task, v86, {
        alignY = "top",
        skipLayoutRefresh = true
    });
end;

function u1.HasClaimable() -- Line: 499
    -- upvalues: CfgFind (copy), PlayerData (copy), LocalPlayer (copy), u2 (copy), _buildRows (copy)
    if not CfgFind.IsEventActive() then
        return false;
    end;

    local v87 = PlayerData.GetPlrDataByKey(LocalPlayer, "Event");
    local v88;

    if type(v87) == "table" and type(v87.EventTask) == "table" then
        v88 = v87.EventTask;
    else
        v88 = nil;
    end;

    if not v88 then
        return false;
    end;

    for _, v in ipairs(u2) do
        for _, v2 in ipairs((_buildRows(v.resetType, v88))) do
            if v2.canClaim then
                return true;
            end;
        end;
    end;

    return false;
end;

function u1.RefreshTitleCountdown() -- Line: 520
    -- upvalues: AllUI (copy), _applyTitleText (copy)
    for _, child in ipairs(AllUI.Task:GetChildren()) do
        if child:IsA("GuiObject") then
            local v89 = child:GetAttribute("EventTaskSection");

            if type(v89) == "string" and string.sub(child.Name, 1, 10) == "TaskTitle_" then
                _applyTitleText(child, v89);
            end;
        end;
    end;
end;

function u1.StartTitleLoop() -- Line: 534
    -- upvalues: u4 (ref), u1 (copy), AllUI (copy)
    u4 = u4 + 1;
    local u90 = u4;
    u1.RefreshTitleCountdown();
    task.spawn(function() -- Line: 538
        -- upvalues: u90 (copy), u4 (ref), AllUI (ref), u1 (ref)
        while u90 == u4 and (AllUI.UIRoot.Visible and AllUI.Task.Visible) do
            task.wait(1);

            if u90 ~= u4 or not (AllUI.UIRoot.Visible and AllUI.Task.Visible) then
                return;
            end;

            u1.RefreshTitleCountdown();
        end;
    end);
end;

function u1.StopTitleLoop() -- Line: 552
    -- upvalues: u4 (ref)
    u4 = u4 + 1;
end;

function u1.Clear() -- Line: 559
    -- upvalues: u1 (copy), UIMgr (copy), AllUI (copy)
    u1.StopTitleLoop();
    UIMgr.ClearScrollItems(AllUI.Task, {
        keepInstances = { AllUI.TaskTemp, AllUI.TaskTitleTemp }
    });
end;

function u1.Refresh() -- Line: 569
    -- upvalues: AllUI (copy), UIMgr (copy), PlayerData (copy), LocalPlayer (copy), u2 (copy), _buildRows (copy), _applyTitleText (copy), _applyTaskDes (copy), _applyReward (copy), _applyProgress (copy), _applyOkBtn (copy), _bindClaim (copy), u1 (copy), _scrollToFirstClaimable (copy)
    AllUI.TaskTemp.Visible = false;
    AllUI.TaskTitleTemp.Visible = false;
    UIMgr.ClearScrollItems(AllUI.Task, {
        keepInstances = { AllUI.TaskTemp, AllUI.TaskTitleTemp }
    });
    local v91 = PlayerData.GetPlrDataByKey(LocalPlayer, "Event");
    local v92;

    if type(v91) == "table" and type(v91.EventTask) == "table" then
        v92 = v91.EventTask;
    else
        v92 = nil;
    end;

    if not v92 then
        UIMgr.SetUIlistSize(AllUI.Task);

        return;
    end;

    for _, v in ipairs(u2) do
        local v93 = _buildRows(v.resetType, v92);

        if #v93 > 0 then
            local v94 = AllUI.TaskTitleTemp:Clone();
            v94.Name = "TaskTitle_" .. v.key;
            v94.Visible = true;
            v94.LayoutOrder = v.layoutBase;
            v94:SetAttribute("EventTaskSection", v.key);
            v94.Parent = AllUI.Task;
            _applyTitleText(v94, v.key);

            for i, v2 in ipairs(v93) do
                local v95 = AllUI.TaskTemp:Clone();
                v95.Name = "Task_" .. v2.onlyTag;
                v95.Visible = true;
                v95.LayoutOrder = v.layoutBase + i;
                v95.Parent = AllUI.Task;
                _applyTaskDes(v95, v2.cfg);
                _applyReward(v95, v2.cfg);
                v95:SetAttribute("EventTaskCanClaim", v2.canClaim);
                v95:SetAttribute("EventTaskClaimed", v2.claimed);
                _applyProgress(v95, v2);
                _applyOkBtn(v95, v2);
                _bindClaim(v95, v2.onlyTag);
            end;
        end;
    end;

    UIMgr.SetUIlistSize(AllUI.Task);
    u1.StartTitleLoop();
    _scrollToFirstClaimable();
end;

function u1.RefreshStates() -- Line: 615
    -- upvalues: PlayerData (copy), LocalPlayer (copy), u2 (copy), _buildRows (copy), AllUI (copy), _applyProgress (copy), _applyOkBtn (copy), u1 (copy)
    local v96 = PlayerData.GetPlrDataByKey(LocalPlayer, "Event");
    local v97;

    if type(v96) == "table" and type(v96.EventTask) == "table" then
        v97 = v96.EventTask;
    else
        v97 = nil;
    end;

    if not v97 then
        return;
    end;

    local v98 = {};
    local v99 = false;

    for _, v in ipairs(u2) do
        local v100 = _buildRows(v.resetType, v97);

        if #v100 > 0 and not AllUI.Task:FindFirstChild("TaskTitle_" .. v.key) then
            v99 = true;
        end;

        for _, v2 in ipairs(v100) do
            v98[v2.onlyTag] = true;
            local v101 = AllUI.Task:FindFirstChild("Task_" .. v2.onlyTag);

            if not (v101 and v101:IsA("Frame")) then
                v99 = true;
                break;
            end;

            v101:SetAttribute("EventTaskCanClaim", v2.canClaim);
            v101:SetAttribute("EventTaskClaimed", v2.claimed);
            _applyProgress(v101, v2);
            _applyOkBtn(v101, v2);
        end;

        if v99 then
            break;
        end;
    end;

    if v99 then
        u1.Refresh();

        return;
    end;

    for _, child in ipairs(AllUI.Task:GetChildren()) do
        if child:IsA("GuiObject") and (string.sub(child.Name, 1, 5) == "Task_" and not v98[string.sub(child.Name, 6)]) then
            u1.Refresh();

            return;
        end;
    end;

    u1.RefreshTitleCountdown();
end;

return u1;