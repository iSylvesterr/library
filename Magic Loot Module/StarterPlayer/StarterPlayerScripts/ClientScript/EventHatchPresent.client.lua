-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Log = UtilsSystem.Log;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local EventHatchTab = require(ReplicatedStorage:WaitForChild("ClientSideCode"):WaitForChild("GuiScripts"):WaitForChild("ModuleScript"):WaitForChild("Event"):WaitForChild("EventHatchTab"));
NetWork.RegisterClientRemoteEvent(NetMsg.EVENT_HATCH_RESULT, function(p1) -- Line: 36, Name: _onHatchResult
    -- upvalues: Log (copy), EventHatchTab (copy)
    if type(p1) ~= "table" then
        return;
    end;

    local itemIds = p1.itemIds;
    local v2 = tonumber(p1.times) or 0;

    if type(itemIds) ~= "table" or #itemIds == 0 then
        return;
    end;

    local v3 = {};

    for _, v in ipairs(itemIds) do
        local v4 = tonumber(v);

        if v4 then
            table.insert(v3, v4);
        end;
    end;

    if #v3 == 0 then
        Log.warn("[EventHatchPresent] 结果无有效 itemId");

        return;
    end;

    EventHatchTab.PlayDrawResult(v3, v2);
end);