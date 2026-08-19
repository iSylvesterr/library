-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");
local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local EnumMgr = UtilsSystem.EnumMgr;
local Log = UtilsSystem.Log;
local ObjectPoolUtil = UtilsSystem.ObjectPoolUtil;
local ResourceUtil = UtilsSystem.ResourceUtil;
local TranslationHelper = UtilsSystem.TranslationHelper;
local MathMgr = UtilsSystem.MathMgr;
local v1 = {};
local u2 = UtilsSystem.AssetRegistry.BuildCatalogPath("BillBoard", "DmgNum");
local v3 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 0)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 0)) });
local v4 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(0.862745, 0.219608, 0.219608)), ColorSequenceKeypoint.new(1, Color3.new(0.862745, 0.219608, 0.219608)) });
local v5 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(0.415686, 0.858824, 0.447059)), ColorSequenceKeypoint.new(1, Color3.new(0.415686, 0.858824, 0.447059)) });
local u6 = {
    [EnumMgr.DmgTp.PlayerDmg] = {
        scale = 1,
        textColor = v4
    },
    [EnumMgr.DmgTp.PlayerDmgCrit] = {
        scale = 1.2,
        critImage = "rbxassetid://139853025490627",
        textColor = v3
    },
    [EnumMgr.DmgTp.NPCDmg] = {
        scale = 1,
        textColor = v4
    },
    [EnumMgr.DmgTp.NPCDmgCrit] = {
        scale = 1.2,
        critImage = "rbxassetid://139853025490627",
        textColor = v3
    },
    [EnumMgr.DmgTp.Heal] = {
        scale = 1,
        textColor = v5
    },
    [EnumMgr.DmgTp.HealCrit] = {
        scale = 1.2,
        critImage = "rbxassetid://139853025490627",
        textColor = v5
    },
    [EnumMgr.DmgTp.Bleed] = {
        scale = 1,
        textColor = v3
    },
    [EnumMgr.DmgTp.Poison] = {
        scale = 1,
        textColor = v3
    },
    [EnumMgr.DmgTp.Burn] = {
        scale = 1,
        textColor = v3
    }
};
local u7 = nil;
local u8 = nil;

local function _getFolder() -- Line: 63
    -- upvalues: u7 (ref), Workspace (copy)
    if u7 and u7.Parent then
        return u7;
    end;

    local v9 = Workspace:FindFirstChild("伤害飘字文件夹");

    if v9 and v9:IsA("Folder") then
        u7 = v9;

        return v9;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "伤害飘字文件夹";
    Folder.Parent = Workspace;
    u7 = Folder;

    return Folder;
end;

local function _getTemplate() -- Line: 79
    -- upvalues: u8 (ref), ResourceUtil (copy), u2 (copy), Log (copy)
    if u8 then
        return u8;
    end;

    local v10 = ResourceUtil.GetTemplate(u2);

    if v10 and v10:IsA("BasePart") then
        u8 = v10;
    else
        Log.warn("[TipsModule.DamageTip] 缺少 BillBoard.DmgNum:", u2);
    end;

    return u8;
end;

local function _isHeal(p11) -- Line: 92
    -- upvalues: EnumMgr (copy)
    return p11 == EnumMgr.DmgTp.Heal and true or p11 == EnumMgr.DmgTp.HealCrit;
end;

local function _isCritType(p12, p13) -- Line: 96
    -- upvalues: EnumMgr (copy)
    return p13 or ((p12 == EnumMgr.DmgTp.PlayerDmgCrit or p12 == EnumMgr.DmgTp.NPCDmgCrit) and true or p12 == EnumMgr.DmgTp.HealCrit);
end;

local function _formatDamageText(p14, p15) -- Line: 110
    -- upvalues: MathMgr (copy)
    local v16 = string.sub(p14, 1, 1);

    if v16 == "+" or v16 == "-" then
        p14 = string.sub(p14, 2);
    end;

    local v17 = tonumber(p14);

    if v17 ~= nil then
        local getNumStr = MathMgr.getNumStr;
        local v18 = math.abs(v17);
        p14 = getNumStr((math.floor(v18)));
    end;

    if p15 then
        return "+" .. p14;
    end;

    return "-" .. p14;
end;

local function _applyStyle(p19, p20, p21) -- Line: 123
    -- upvalues: u6 (copy), EnumMgr (copy)
    local v22 = u6[p20] or u6[EnumMgr.DmgTp.PlayerDmg];
    local v23 = p21 or ((p20 == EnumMgr.DmgTp.PlayerDmgCrit or p20 == EnumMgr.DmgTp.NPCDmgCrit) and true or p20 == EnumMgr.DmgTp.HealCrit);
    local Bao = p19:FindFirstChild("Bao");

    if Bao and Bao:IsA("ImageLabel") then
        Bao.Image = not (v23 and v22.critImage) and "" or v22.critImage;
        Bao.Visible = v23;
        Bao.ImageTransparency = 0;
    end;

    local Damage = p19:FindFirstChild("Damage");

    if Damage and Damage:IsA("TextLabel") then
        local v24 = Damage:FindFirstChildOfClass("UIGradient");

        if v24 then
            v24.Color = v22.textColor;
        end;

        local v25 = Damage:FindFirstChildOfClass("UIStroke");

        if v25 then
            v25.Transparency = 0;
        end;

        Damage.TextTransparency = 0;
        Damage.TextColor3 = Color3.new(1, 1, 1);
    end;

    local v26 = p19:FindFirstChildOfClass("UIScale");

    if v26 then
        v26.Scale = v22.scale;
    end;
end;

local function _playAnim(u27, u28, p29) -- Line: 154
    -- upvalues: RunService (copy), ObjectPoolUtil (copy)
    local u30 = tick();
    u28.StudsOffsetWorldSpace = Vector3.new(0, 0, 0);
    local Damage = p29:FindFirstChild("Damage");
    local u31;

    if Damage and Damage:IsA("TextLabel") then
        u31 = Damage:FindFirstChildOfClass("UIStroke");
    else
        u31 = nil;
    end;

    local Bao = p29:FindFirstChild("Bao");
    local u32 = nil;
    u32 = RunService.Heartbeat:Connect(function() -- Line: 163
        -- upvalues: u30 (copy), u32 (ref), ObjectPoolUtil (ref), u27 (copy), u28 (copy), Damage (copy), u31 (copy), Bao (copy)
        local v33 = tick() - u30;

        if v33 >= 0.6000000000000001 then
            u32:Disconnect();
            ObjectPoolUtil.backToPool(u27);

            return;
        end;

        u28.StudsOffsetWorldSpace = Vector3.new(0, 4 * v33, 0);

        if v33 > 0.2 then
            local v34 = math.clamp((v33 - 0.2) / 0.4, 0, 1);

            if Damage and Damage:IsA("TextLabel") then
                Damage.TextTransparency = v34;
            end;

            if u31 then
                u31.Transparency = v34;
            end;

            if Bao and Bao:IsA("ImageLabel") then
                Bao.ImageTransparency = v34;
            end;
        end;
    end);
end;

function v1.show(p35, p36, p37, p38) -- Line: 195
    -- upvalues: u8 (ref), ResourceUtil (copy), u2 (copy), Log (copy), EnumMgr (copy), ObjectPoolUtil (copy), u7 (ref), Workspace (copy), MathMgr (copy), TranslationHelper (copy), _applyStyle (copy), _playAnim (copy)
    if typeof(p35) ~= "Vector3" or type(p36) ~= "string" then
        return;
    end;

    local v39;

    if u8 then
        v39 = u8;
    else
        local v40 = ResourceUtil.GetTemplate(u2);

        if v40 and v40:IsA("BasePart") then
            u8 = v40;
        else
            Log.warn("[TipsModule.DamageTip] 缺少 BillBoard.DmgNum:", u2);
        end;

        v39 = u8;
    end;

    if not v39 then
        return;
    end;

    local v41 = tonumber(p38) or EnumMgr.DmgTp.PlayerDmg;
    local v42 = ObjectPoolUtil.getObjectFromPool(v39);
    local v43;

    if u7 and u7.Parent then
        v43 = u7;
    else
        v43 = Workspace:FindFirstChild("伤害飘字文件夹");

        if v43 and v43:IsA("Folder") then
            u7 = v43;
        else
            v43 = Instance.new("Folder");
            v43.Name = "伤害飘字文件夹";
            v43.Parent = Workspace;
            u7 = v43;
        end;
    end;

    v42.Parent = v43;
    v42.Anchored = true;
    v42.Position = p35 + Vector3.new(0, 4, 0);
    local v44 = v42:FindFirstChildOfClass("BillboardGui");
    local v45;

    if v44 then
        v45 = v44:FindFirstChild("Frame");
    else
        v45 = v44;
    end;

    local v46;

    if v45 then
        v46 = v45:FindFirstChild("Damage");
    else
        v46 = v45;
    end;

    if not (v44 and (v45 and (v45:IsA("Frame") and (v46 and v46:IsA("TextLabel"))))) then
        ObjectPoolUtil.backToPool(v42);

        return;
    end;

    local v47 = v41 == EnumMgr.DmgTp.Heal and true or v41 == EnumMgr.DmgTp.HealCrit;
    local v48 = string.sub(p36, 1, 1);

    if v48 == "+" or v48 == "-" then
        p36 = string.sub(p36, 2);
    end;

    local v49 = tonumber(p36);

    if v49 ~= nil then
        local getNumStr = MathMgr.getNumStr;
        local v50 = math.abs(v49);
        p36 = getNumStr((math.floor(v50)));
    end;

    local v51;

    if v47 then
        v51 = "+" .. p36;
    else
        v51 = "-" .. p36;
    end;

    TranslationHelper.SetText_UnTrans(v46, v51);
    _applyStyle(v45, v41, p37 == true);
    _playAnim(v42, v44, v45);
end;

return v1;