-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Debris = UtilsSystem.Debris;
local CfgFind = UtilsSystem.CfgFind;
local UIanima = UtilsSystem.UIanima;
local TipsModule = UtilsSystem.TipsModule;
local UIMgr = UtilsSystem.UIMgr;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local AddListen = UtilsSystem.AddListen;
local LocalPlayer = UtilsSystem.LocalPlayer;
local u1 = {};
local RewardsClaimWithoutWord = LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("RewardsClaimWithoutWord");
local Frame = RewardsClaimWithoutWord:FindFirstChild("Frame");
local u2 = nil;
local u3 = nil;
local v4, u5;

if Frame then
    v4 = Frame:FindFirstChild("Confirm");
    u5 = Frame:FindFirstChild("ScrollingFrame");
else
    v4 = nil;
    u5 = nil;
end;

local v6 = v4 and v4:FindFirstChild("Button");

if v6 then
    AddListen.AddMouseCLick(v6, function() -- Line: 52
        -- upvalues: u2 (ref), GetData (copy), TipsModule (copy), LocalPlayer (copy), u1 (copy)
        if u2 and u2.func then
            if u2.ItemData then
                for i, v in pairs(u2.ItemData) do
                    local v7 = GetData.GetItemCountByIDOnClient(i);

                    if v7 < v then
                        TipsModule.TipsNotEnoughItem(LocalPlayer, i, v, v7);

                        return;
                    end;
                end;

                u2.func();
            else
                u2.func();
            end;
        end;

        u1:closeUi();
    end, v4);
end;

if u5 then
    local Temp = u5:FindFirstChild("Temp");

    if Temp and Temp:IsA("Frame") then
        u3 = Temp;
        u3.Visible = false;
    end;
end;

function u1.updateUi(p8, p9) -- Line: 85
    -- upvalues: u2 (ref), u5 (ref), u3 (ref), Debris (copy), CfgFind (copy), EnumMgr (copy), UIMgr (copy)
    u2 = p9;

    if not (u2 and (u2.AwardID and (u5 and u3))) then
        return;
    end;

    local v10 = {};

    for i, v in pairs(u2.AwardID) do
        local v11 = tonumber(u2.Count[i]);

        if v11 then
            local v12 = tostring(v);

            if v10[v12] then
                v10[v12] = v10[v12] + v11;
            else
                v10[v12] = v11;
            end;
        end;
    end;

    for _, child in pairs(u5:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "Temp" then
            Debris:AddItem(child, 0);
        end;
    end;

    local UIListLayout = u5.UIListLayout;
    local v13 = 0;

    for i, v in pairs(v10) do
        local v14 = tonumber(i);

        if v14 then
            local v15 = CfgFind.FindCfgByID(v14);

            if v15 then
                local v16 = u3:Clone();
                local ZhName = v16:FindFirstChild("ZhName");
                local Lv = v16.Lv;

                if v15.tp == EnumMgr.ItemType.Weapon then
                    Lv.Visible = true;
                    Lv.Text = "LV." .. v15.lvNeed;
                else
                    Lv.Visible = false;
                end;

                v16.Name = i;
                v16.Visible = true;
                v16.Parent = u5;
                UIMgr.SetAward(v16, v14, v);

                if v15.xyd then
                    UIMgr.AddGradientColor("武器边框-" .. v15.xyd, ZhName);
                    v16.LayoutOrder = 10 - v15.xyd;
                end;

                v13 = v13 + u5.Size.Y.Offset + UIListLayout.Padding.Offset;
            end;
        end;
    end;

    u5.CanvasSize = UDim2.new(0, v13, 0, 0);
end;

function u1.openUi(p17) -- Line: 160
end;

function u1.closeUi(p18) -- Line: 167
    -- upvalues: UIanima (copy), RewardsClaimWithoutWord (copy)
    UIanima.PopBack(RewardsClaimWithoutWord);
end;

return u1;