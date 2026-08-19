-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local UIMgr = UtilsSystem.UIMgr;
local TranslationHelper = UtilsSystem.TranslationHelper;
local v1 = {};
local u2 = {};
local u3 = {};
local u4 = 0;
local u5 = {
    UDim2.new(0.5, 0, -0.3, 0),
    UDim2.new(0.73, 0, -0.5, 0),
    UDim2.new(0.27, 0, -0.5, 0),
    UDim2.new(0.13, 0, -0.5, 0),
    UDim2.new(0.87, 0, -0.5, 0)
};
local u6 = {
    UDim2.new(0.5, 0, 0.72, 0),
    UDim2.new(0.73, 0, 0.7, 0),
    UDim2.new(0.27, 0, 0.7, 0),
    UDim2.new(0.13, 0, 0.68, 0),
    UDim2.new(0.87, 0, 0.68, 0)
};
local u7 = {
    UDim2.new(0.5, 0, 1.5, 0),
    UDim2.new(0.78, 0, 1.1, 0),
    UDim2.new(0.27, 0, 1.1, 0),
    UDim2.new(0.13, 0, 1.1, 0),
    UDim2.new(0.95, 0, 1.1, 0)
};

local function _getRngShowUI() -- Line: 51
    -- upvalues: Players (copy)
    local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui");

    if not PlayerGui then
        warn("缺少玩家GUI");

        return nil;
    end;

    local UIAnimGui = PlayerGui:FindFirstChild("UIAnimGui");

    if not UIAnimGui then
        warn("缺少UI动画GUI");

        return nil;
    end;

    local RngShowUI = UIAnimGui:FindFirstChild("RngShowUI");

    if RngShowUI then
        return RngShowUI;
    end;

    warn("缺少随机展示UI");

    return nil;
end;

function v1.CreateUI(p8, p9) -- Line: 78
    -- upvalues: _getRngShowUI (copy), CfgFind (copy), UIMgr (copy), TranslationHelper (copy)
    local v10 = _getRngShowUI();

    if not v10 then
        return;
    end;

    for i, v in ipairs(p8) do
        local v11 = v10:FindFirstChild("PetInfo" .. i);

        if v11 then
            v11.Visible = false;
            local v12 = i == 1 and v11:FindFirstChild("点击继续");

            if v12 then
                v12.Visible = not p9;
            end;

            local v13 = CfgFind.FindCfgByID(v);

            if v13 then
                if v13.xyd then
                    UIMgr.AddGradientColor(v13.xyd, v11.Rare, true);
                    UIMgr.setXydLabel(v11.Rare, v13.xyd);
                end;

                if v13.ZhName then
                    TranslationHelper.SetText(v11.PetName, v13.ZhName);
                end;
            end;
        end;
    end;
end;

function v1.ShowUI(p14, p15) -- Line: 120
    -- upvalues: _getRngShowUI (copy), u4 (ref), u5 (copy), u6 (copy), u2 (copy), TweenService (copy), u3 (copy)
    local v16 = _getRngShowUI();

    if not v16 then
        return;
    end;

    u4 = u4 + 1;
    local u17 = u4;

    for i = 1, p15 do
        local v18 = v16:FindFirstChild("PetInfo" .. i);

        if v18 then
            local v19 = u6[i];
            local Size = v18.Size;
            v18.Position = u5[i];
            v18.Size = Size;
            v18.Visible = true;
            u2[i] = TweenService:Create(v18, TweenInfo.new(p14 * 0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = Size,
                Position = v19
            });
            u2[i].Completed:Connect(function() -- Line: 149
                -- upvalues: u17 (copy), u4 (ref), u2 (ref), i (copy)
                if u17 ~= u4 then
                    return;
                end;

                if u2[i] then
                    u2[i]:Destroy();
                    u2[i] = nil;
                end;
            end);

            if u3[i] then
                u3[i]:Pause();
                u3[i]:Destroy();
                u3[i] = nil;
            end;

            u2[i]:Play();
        end;
    end;
end;

function v1.HideUI(p20, p21) -- Line: 174
    -- upvalues: _getRngShowUI (copy), u4 (ref), u6 (copy), u7 (copy), u3 (copy), TweenService (copy), u2 (copy)
    local v22 = _getRngShowUI();

    if not v22 then
        return;
    end;

    u4 = u4 + 1;
    local u23 = u4;

    for i = 1, p21 do
        local v24 = v22:FindFirstChild("PetInfo" .. i);

        if v24 then
            v24.Position = u6[i];
            local v25 = u7[i];
            u3[i] = TweenService:Create(v24, TweenInfo.new(p20 * 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Position = v25
            });
            u3[i].Completed:Connect(function() -- Line: 198
                -- upvalues: u23 (copy), u4 (ref), u3 (ref), i (copy)
                if u23 ~= u4 then
                    return;
                end;

                if u3[i] then
                    u3[i]:Destroy();
                    u3[i] = nil;
                end;
            end);

            if u2[i] then
                u2[i]:Pause();
                u2[i]:Destroy();
                u2[i] = nil;
            end;

            u3[i]:Play();
        end;
    end;
end;

return v1;