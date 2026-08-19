-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Shared = ReplicatedStorage:WaitForChild("Shared");
local Client = ReplicatedStorage:WaitForChild("Client");
local Packages = ReplicatedStorage:WaitForChild("Packages");
local Constants = require(Shared:WaitForChild("Info"):WaitForChild("Constants"));
require(Client:WaitForChild("Modules"):WaitForChild("Utility"):WaitForChild("ItemIconGen"));
local ItemDescGen = require(Client:WaitForChild("Modules"):WaitForChild("Utility"):WaitForChild("ItemDescGen"));
local CustomEnum = require(Shared:WaitForChild("Info"):WaitForChild("CustomEnum"));
local ItemHelperFunctions = require(Shared:WaitForChild("Utility"):WaitForChild("ItemHelperFunctions"));
local Maid = require(Packages:WaitForChild("Maid"));
local u2 = {};
local u3 = {};
local u4 = {};

function v1.setupButtonConnections(p5, u6, u7) -- Line: 41
    -- upvalues: u2 (copy), Maid (copy), Constants (copy)
    if u2[u6] then
        return;
    end;

    if not u7.unhover then
        function u7.unhover() -- Line: 45
        end;
    end;

    if not u7.hover then
        function u7.hover() -- Line: 46
        end;
    end;

    if not u7.click then
        function u7.click() -- Line: 47
        end;
    end;

    u2[u6] = {};
    u2[u6].maid = Maid.new();
    u2[u6].maid:GiveTask(u6.MouseLeave:Connect(function() -- Line: 53
        -- upvalues: u7 (copy)
        u7.unhover();
    end));
    u2[u6].maid:GiveTask(u6.InputChanged:Connect(function(p8) -- Line: 57
        -- upvalues: u7 (copy)
        if p8.UserInputType == Enum.UserInputType.MouseMovement then
            local v9 = UDim2.new(0, p8.Position.X, 0, p8.Position.Y);
            u7.hover(v9);
        end;
    end));
    u2[u6].maid:GiveTask(u6.InputBegan:Connect(function(p10) -- Line: 64
        -- upvalues: u2 (ref), u6 (copy), Constants (ref), u7 (copy)
        if p10.UserInputType ~= Enum.UserInputType.Touch then
            if p10.UserInputType == Enum.UserInputType.MouseButton1 then
                u7.click();
            end;

            return;
        end;

        u2[u6].touchTime = os.clock();
        u2[u6].longPressTaskGoing = true;
        u2[u6].longPressTask = task.delay(Constants.LONG_PRESS_TIME, function() -- Line: 69
            -- upvalues: u7 (ref), u2 (ref), u6 (ref)
            u7.hover();
            u2[u6].longPressTaskGoing = false;
        end);
    end));
    u2[u6].maid:GiveTask(u6.InputEnded:Connect(function(p11) -- Line: 78
        -- upvalues: u2 (ref), u6 (copy), Constants (ref), u7 (copy)
        if p11.UserInputType == Enum.UserInputType.Touch and os.clock() - u2[u6].touchTime < Constants.LONG_PRESS_TIME then
            if u2[u6].longPressTaskGoing then
                task.cancel(u2[u6].longPressTask);
                u2[u6].longPressTaskGoing = false;
            end;

            u7.click();
        end;
    end));
    u2[u6].maid:GiveTask(function() -- Line: 93
        -- upvalues: u2 (ref), u6 (copy)
        if u2[u6].longPressTaskGoing then
            task.cancel(u2[u6].longPressTask);
            u2[u6].longPressTaskGoing = false;
        end;
    end);
end;

function v1.removeButtonConnections(p12, p13) -- Line: 101
    -- upvalues: u2 (copy)
    if not u2[p13] then
        return;
    end;

    if u2[p13].maid then
        u2[p13].maid:Destroy();
    end;

    u2[p13] = nil;
end;

local function hoverItem(p14, p15, p16) -- Line: 111
    -- upvalues: ItemDescGen (copy), u4 (copy), CustomEnum (copy), ItemHelperFunctions (copy)
    if ItemDescGen:IsButtonWindowOpen() then
        return;
    end;

    local v17;

    if p15 then
        v17 = 0;
    else
        p15 = UDim2.new(0, p14.AbsolutePosition.X, 0, p14.AbsolutePosition.Y);
        v17 = p14.AbsoluteSize.X;
    end;

    if ItemDescGen:IsItemDescOpen(u4[p14]) then
        ItemDescGen:AdjustWindowPos(u4[p14], p15, CustomEnum.SUB_WINDOW_TYPE.DESC, v17);

        return;
    end;

    if not p16.itemData then
        u4[p14] = ItemDescGen:OpenDesc(p15, v17, p16.title, p16.rarityData, p16.desc);

        return;
    end;

    ItemHelperFunctions:GetItemModule(p16.itemData[1]);
    u4[p14] = ItemDescGen:OpenItemDesc(p16.itemData, p15, v17, p16.descAppend);
end;

local function unhoverItem(p18) -- Line: 136
    -- upvalues: ItemDescGen (copy), u4 (copy)
    ItemDescGen:CloseDesc(u4[p18]);
    u4[p18] = nil;
end;

function v1.setupStandardItemHoverCon(p19, u20, u21, u22) -- Line: 141
    -- upvalues: ItemDescGen (copy), u4 (copy), hoverItem (copy)
    p19:setupButtonConnections(u20, {
        unhover = function() -- Line: 143, Name: unhover
            -- upvalues: u20 (copy), ItemDescGen (ref), u4 (ref)
            local v23 = u20;
            ItemDescGen:CloseDesc(u4[v23]);
            u4[v23] = nil;
        end,

        hover = function(p24) -- Line: 145, Name: hover
            -- upvalues: hoverItem (ref), u20 (copy), u22 (copy), u21 (copy)
            hoverItem(u20, p24, {
                descAppend = u22,
                itemData = u21
            });
        end,

        click = function() -- Line: 147, Name: click
        end
    });
end;

function v1.setupCustomItemHoverCon(p25, u26, u27, u28, u29) -- Line: 151
    -- upvalues: ItemDescGen (copy), u4 (copy), hoverItem (copy)
    p25:setupButtonConnections(u26, {
        unhover = function() -- Line: 153, Name: unhover
            -- upvalues: u26 (copy), ItemDescGen (ref), u4 (ref)
            local v30 = u26;
            ItemDescGen:CloseDesc(u4[v30]);
            u4[v30] = nil;
        end,

        hover = function(p31) -- Line: 155, Name: hover
            -- upvalues: hoverItem (ref), u26 (copy), u27 (copy), u28 (copy), u29 (copy)
            hoverItem(u26, p31, {
                title = u27,
                rarityData = u28,
                desc = u29
            });
        end,

        click = function() -- Line: 157, Name: click
        end
    });
end;

function v1.makeIconFlash(p32, p33) -- Line: 161
    -- upvalues: u3 (copy), Maid (copy), TweenService (copy)
    if u3[p33] then
        return;
    end;

    u3[p33] = {};
    u3[p33].maid = Maid.new();
    local u34 = TweenService:Create(p33, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {
        BackgroundColor3 = Color3.new(1, 1, 1)
    });
    local u35 = TweenService:Create(p33.Inner, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {
        BackgroundColor3 = Color3.new(0.713725, 0.713725, 0.713725)
    });
    u34:Play();
    u35:Play();
    u3[p33].maid:GiveTask(function() -- Line: 183
        -- upvalues: u34 (copy), u35 (copy)
        if u34 then
            u34:Cancel();
        end;

        if u35 then
            u35:Cancel();
        end;
    end);
end;

function v1.stopIconFlash(p36, p37) -- Line: 189
    -- upvalues: u3 (copy)
    if not u3[p37] then
        return;
    end;

    if u3[p37].maid then
        u3[p37].maid:Destroy();
    end;

    u3[p37] = nil;
end;

return v1;