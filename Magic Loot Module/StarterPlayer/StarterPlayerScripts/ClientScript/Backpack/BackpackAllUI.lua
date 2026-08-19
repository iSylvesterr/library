-- Decompiled with Potassium's decompiler.

local Log = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).Log;
local v3 = {
    findSlotButton = function(p1, p2) -- Line: 58, Name: findSlotButton
        -- upvalues: Log (copy)
        if p1:IsA("GuiButton") then
            return p1;
        end;

        local Button = p1:FindFirstChild("Button");

        if Button and Button:IsA("GuiButton") then
            return Button;
        end;

        Log.warn("[BackpackAllUI] slot button missing (need GuiButton root or child Button)", p2 or p1.Name, p1:GetFullName());

        return nil;
    end
};

local function _collectLockUi(p4) -- Line: 75
    -- upvalues: Log (copy)
    local v5 = p4:FindFirstChild("锁定");

    if not v5 then
        Log.warn("[BackpackAllUI] 锁定节点缺失", p4:GetFullName());

        return nil;
    end;

    local v6 = v5:FindFirstChild("锁定状态");
    local v7 = v5:FindFirstChild("锁定全部");
    local v8 = v5:FindFirstChild("解锁全部");
    local v9 = v5:FindFirstChild("回退");

    if v6 and (v7 and (v8 and v9)) then
        return {
            root = v5,
            listLayout = v5:FindFirstChildOfClass("UIListLayout"),
            statusFrame = v6,
            lockAllFrame = v7,
            unlockAllFrame = v8,
            backFrame = v9
        };
    end;

    Log.warn("[BackpackAllUI] 锁定子节点不完整", v5:GetFullName());

    return nil;
end;

function v3.collect(p10) -- Line: 105
    -- upvalues: _collectLockUi (copy)
    local Backpack = p10:FindFirstChild("Backpack");

    if not Backpack then
        return nil;
    end;

    local v11 = Backpack:WaitForChild("仓库", (1 / 0));
    local ScrollingFrame = v11:WaitForChild("ScrollingFrame", (1 / 0));
    local Temp = ScrollingFrame:WaitForChild("Temp", (1 / 0));
    local v12 = v11:FindFirstChild("容量");

    if v12 then
        v12 = v12:FindFirstChild("Size");
    end;

    local v13 = v11:FindFirstChild("搜索");

    if v13 then
        v13 = v13:FindFirstChildWhichIsA("TextBox", true);
    end;

    local v14 = v11:WaitForChild("页签", (1 / 0));
    local All = v14:WaitForChild("All", (1 / 0));
    local Potion = v14:WaitForChild("Potion", (1 / 0));
    local Material = v14:WaitForChild("Material", (1 / 0));
    local v15 = v11:FindFirstChild("拖动替换区");
    local v16 = Backpack:WaitForChild("工具栏", (1 / 0));

    return {
        root = Backpack,
        warehouse = v11,
        warehouseScroll = ScrollingFrame,
        warehouseTemp = Temp,
        capacitySize = v12,
        searchBox = v13,
        tabContainer = v14,
        tabFrames = {
            All = All,
            Potion = Potion,
            Material = Material
        },
        dragReplaceZone = v15,
        toolbar = v16,
        toolbarTemp = v16:WaitForChild("Temp", (1 / 0)),
        lockUi = _collectLockUi(v11)
    };
end;

return v3;