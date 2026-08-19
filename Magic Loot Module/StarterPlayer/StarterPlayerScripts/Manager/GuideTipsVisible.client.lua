-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local UIMgr = UtilsSystem.UIMgr;
local AddListen = UtilsSystem.AddListen;
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local u1 = LocalPlayer:WaitForChild("是否弹窗打开中", (1 / 0));
local GuideName = LocalPlayer:WaitForChild("GuideName", (1 / 0));
local v2 = SystemGameConfig.GetValue("引导");
local u3 = v2 and v2.Cfg or {};

local function _getStageCfg() -- Line: 31
    -- upvalues: GetData (copy), GuideName (copy), u3 (copy)
    local v4, v5 = GetData.parseGuideName(GuideName.Value);

    if v4 == nil or v4 == "" then
        return nil;
    end;

    local v6 = u3[v4];

    if not v6 or type(v6) ~= "table" then
        return nil;
    end;

    local v7 = v6[tostring(v5)] or v6["1"];

    if v7 and type(v7) == "table" then
        return v7;
    end;

    return nil;
end;

local function _shouldShowForPopList(p8) -- Line: 52
    -- upvalues: UIMgr (copy)
    for _, v in pairs(p8) do
        if UIMgr.GetUIVisible(v) == true then
            return true;
        end;
    end;

    return false;
end;

local function _isEmptyVisibleList(p9) -- Line: 66
    return (p9 == nil or type(p9) ~= "table") and true or #p9 <= 0;
end;

local function _updateOnGuideName() -- Line: 74
    -- upvalues: GetData (copy), GuideName (copy), u3 (copy), UIMgr (copy), u1 (copy), _shouldShowForPopList (copy)
    local v10, v11 = GetData.parseGuideName(GuideName.Value);
    local v12;

    if v10 == nil or v10 == "" then
        v12 = nil;
    else
        local v13 = u3[v10];

        if v13 and type(v13) == "table" then
            v12 = v13[tostring(v11)] or v13["1"];

            if not v12 or type(v12) ~= "table" then
                v12 = nil;
            end;
        else
            v12 = nil;
        end;
    end;

    if not v12 then
        UIMgr.SetGuideTipsVisible(false);
        UIMgr.SetGuideArrowVisible(false);

        return;
    end;

    if v12.ui then
        local Visible = v12.ui.Visible;

        if Visible == true then
            UIMgr.SetGuideArrowVisible(true);
        elseif (Visible == nil or type(Visible) ~= "table") and true or #Visible <= 0 then
            UIMgr.SetGuideArrowVisible(not u1.Value);
        else
            UIMgr.SetGuideArrowVisible((_shouldShowForPopList(Visible)));
        end;
    else
        UIMgr.SetGuideArrowVisible(false);
    end;

    if v12.Text then
        UIMgr.SetGuideTipsVisible(true);

        return;
    end;

    UIMgr.SetGuideTipsVisible(false);
end;

AddListen.NumValueAdd(u1, function() -- Line: 107, Name: _updateOnPopShow
    -- upvalues: GetData (copy), GuideName (copy), u3 (copy), UIMgr (copy), u1 (copy), _shouldShowForPopList (copy)
    local v14, v15 = GetData.parseGuideName(GuideName.Value);
    local v16;

    if v14 == nil or v14 == "" then
        v16 = nil;
    else
        local v17 = u3[v14];

        if v17 and type(v17) == "table" then
            v16 = v17[tostring(v15)] or v17["1"];

            if not v16 or type(v16) ~= "table" then
                v16 = nil;
            end;
        else
            v16 = nil;
        end;
    end;

    if not v16 then
        UIMgr.SetGuideTipsVisible(false);
        UIMgr.SetGuideArrowVisible(false);

        return;
    end;

    if v16.ui then
        local Visible = v16.ui.Visible;

        if Visible == true then
            UIMgr.SetGuideArrowVisible(true);
        elseif (Visible == nil or type(Visible) ~= "table") and true or #Visible <= 0 then
            UIMgr.SetGuideArrowVisible(not u1.Value);
        else
            UIMgr.SetGuideArrowVisible((_shouldShowForPopList(Visible)));
        end;
    else
        UIMgr.SetGuideArrowVisible(false);
    end;

    if not v16.Text then
        UIMgr.SetGuideTipsVisible(false);

        return;
    end;

    local TextVisible = v16.TextVisible;

    if TextVisible == true then
        UIMgr.SetGuideTipsVisible(true);

        return;
    end;

    if (TextVisible == nil or type(TextVisible) ~= "table") and true or #TextVisible <= 0 then
        UIMgr.SetGuideTipsVisible(not u1.Value);

        return;
    end;

    UIMgr.SetGuideTipsVisible((_shouldShowForPopList(TextVisible)));
end, false);
AddListen.NumValueAdd(GuideName, function() -- Line: 146
    -- upvalues: _updateOnGuideName (copy)
    task.defer(_updateOnGuideName);
end, false);