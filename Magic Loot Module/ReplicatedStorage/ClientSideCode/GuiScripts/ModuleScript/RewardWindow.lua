-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local UIanima = UtilsSystem.UIanima;
local EnumMgr = UtilsSystem.EnumMgr;
local ShowDetail = UtilsSystem.ShowDetail;
local AddListen = UtilsSystem.AddListen;
local UIMgr = UtilsSystem.UIMgr;
local HatchEffect = UtilsSystem.HatchEffect;
local GlobalCfg = require(ReplicatedStorage:WaitForChild("GlobalCfg"));

if not Players.LocalPlayer then
    error("LocalPlayer not found");
end;

local u1 = {};
local Parent = script.Parent;
local Frame = Parent:FindFirstChild("Frame");

if Frame and Frame:IsA("Frame") then
    Frame = Frame:FindFirstChild("ScrollingFrame");
end;

if not (Frame and Frame:IsA("ScrollingFrame")) then
    Frame = nil;
end;

local u2 = nil;

if Frame then
    local Temp = Frame:FindFirstChild("Temp");

    if Temp and Temp:IsA("Frame") then
        u2 = Temp;
        u2.Visible = false;
    end;
end;

local u3 = nil;
local BG = Parent:FindFirstChild("BG");

if BG and BG:IsA("Frame") then
    local Exit = BG:FindFirstChild("Exit");
    local v4 = Exit and Exit:IsA("Frame") and Exit:FindFirstChild("Button");

    if v4 then
        AddListen.AddMouseCLick(v4, function() -- Line: 73
            -- upvalues: u1 (copy)
            u1:closeUi();
        end, Exit);
    end;
end;

local Frame2 = Parent:FindFirstChild("Frame");

if Frame2 and Frame2:IsA("Frame") then
    local v5 = Frame2:FindFirstChild("确认");
    local v6 = v5 and v5:IsA("Frame") and v5:FindFirstChild("Button");

    if v6 then
        AddListen.AddMouseCLick(v6, function() -- Line: 87
            -- upvalues: u1 (copy)
            u1:closeUi();
        end, v5);
    end;
end;

function u1.updateUi(p7, p8) -- Line: 99
    -- upvalues: u3 (ref), Frame (ref), u2 (ref), CfgFind (copy), EnumMgr (copy), GlobalCfg (copy), HatchEffect (copy), UIMgr (copy)
    u3 = p8;

    if not (u3 and (Frame and u2)) then
        return;
    end;

    local v9 = {};
    local v10 = {};
    local v11 = {};
    local v12 = {};

    if u3.AwardID and u3.Count then
        for i, v in pairs(u3.AwardID) do
            local v13 = tonumber(v);
            local v14 = tonumber(u3.Count[i]);

            if v13 and v14 then
                local v15 = CfgFind.FindCfgByID(v13, EnumMgr.ItemType.Hero);

                if v15 then
                    if v11[v13] == 1 then
                        v12[v13] = v14 * GlobalCfg["抽取获得碎片"][v15.xyd];
                    else
                        table.insert(v10, v13);
                    end;
                end;

                if v9[v13] then
                    v9[v13] = v9[v13] + v14;
                else
                    v9[v13] = v14;
                end;
            end;
        end;
    end;

    if #v10 > 0 then
        HatchEffect.ShowItemEffect(v10);
    end;

    for _, child in pairs(Frame:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "Temp" then
            child:Destroy();
        end;
    end;

    for i, v in pairs(v9) do
        local v16 = tonumber(i);

        if v16 and CfgFind.FindCfgByID(v16) then
            local v17 = u2:Clone();
            v17.Name = tostring(i);
            v17.Visible = true;
            v17.LayoutOrder = i;
            v17.Parent = Frame;
            local Frame3 = v17:FindFirstChild("Frame");

            if Frame3 and Frame3:IsA("Frame") then
                UIMgr.SetAward(Frame3, v16, v, nil, nil, v12[v16]);
            end;
        end;
    end;

    UIMgr.SetUIlistSize(Frame);
end;

function u1.openUi(p18) -- Line: 177
end;

function u1.closeUi(p19) -- Line: 184
    -- upvalues: u3 (ref), UIanima (copy), Parent (copy), ShowDetail (copy)
    if u3 and (u3.func and type(u3.func) == "function") then
        u3.func();
    end;

    UIanima.PopBack(Parent);
    ShowDetail.HideAllDetail();
end;

return u1;