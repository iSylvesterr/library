-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local u1 = Color3.fromRGB(238, 255, 0);
local u2 = Color3.fromRGB(255, 145, 0);
local u3 = {};
local u4 = false;
local v5 = {};

local function getCombinedRestock() -- Line: 27
    -- upvalues: u3 (copy), u1 (copy), u2 (copy)
    local ArmorsShop = u3.ArmorsShop;
    local SwordShop = u3.SwordShop;

    if ArmorsShop and SwordShop then
        return {
            Message = string.format("Your <font color=\"#%s\">Pickaxe Shop</font> and <font color=\"#%s\">Sword Shop</font> have been restocked", u1:ToHex(), u2:ToHex()),
            Time = math.max(ArmorsShop.Time or 5, SwordShop.Time or 5),
            ShowShadow = ArmorsShop.ShowShadow or SwordShop.ShowShadow,
            Sound = ArmorsShop.Sound or SwordShop.Sound,
            DelayInRound = ArmorsShop.DelayInRound or SwordShop.DelayInRound
        };
    end;
end;

local function flushRestocks() -- Line: 48
    -- upvalues: getCombinedRestock (copy), Message (copy), u3 (copy), u4 (ref)
    local v6 = getCombinedRestock();

    if v6 then
        Message.Top(v6);
    else
        for _, v in u3 do
            Message.Top(v);
        end;
    end;

    table.clear(u3);
    u4 = false;
end;

function v5.Push(p7, p8) -- Line: 63
    -- upvalues: u3 (copy), u4 (ref), flushRestocks (copy)
    u3[p7] = p8;

    if u4 then
        return;
    end;

    u4 = true;
    task.delay(3, flushRestocks);
end;

return v5;