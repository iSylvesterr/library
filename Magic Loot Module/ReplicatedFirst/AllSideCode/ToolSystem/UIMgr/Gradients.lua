-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Log = UtilsSystem.Log;
local Copy = UtilsSystem.Copy;
local EnumMgr = UtilsSystem.EnumMgr;
local CfgFind = UtilsSystem.CfgFind;
local TranslationHelper = UtilsSystem.TranslationHelper;
local SequenceManager = UtilsSystem.SequenceManager;
local AssetPaths = UtilsSystem.AssetPaths;
local AssetRegistry = UtilsSystem.AssetRegistry;
local GradientCfg = require(script.Parent.GradientCfg);
local u1 = AssetPaths.GetCatalog(AssetRegistry.Catalog.AllGridients);

local function _getAllGridientsSubfolder(p2) -- Line: 58
    -- upvalues: u1 (copy)
    if u1 then
        return u1:FindFirstChild(p2);
    end;

    return nil;
end;

local v3;

if u1 then
    v3 = u1:FindFirstChild("Gridient");
else
    v3 = nil;
end;

local u4;

if u1 then
    u4 = u1:FindFirstChild("RarityGridient");
else
    u4 = nil;
end;

local v5;

if u1 then
    v5 = u1:FindFirstChild("UIGradient");
else
    v5 = nil;
end;

local u6 = { v3, u4, v5 };
local u7;

if v3 then
    u7 = v3:FindFirstChild("英雄框");
else
    u7 = nil;
end;

if not u7 and u1 then
    u7 = u1:FindFirstChild("英雄框");
end;

local v8 = AssetRegistry.BuildCatalogPath(AssetRegistry.Catalog.ModelRes, "Title");
local u9 = AssetPaths.Resolve(v8);

if not (u9 and u9:IsA("Folder")) then
    u9 = nil;
end;

local u10 = script.Parent:FindFirstChild("框特效");
local Xyd10 = EnumMgr.Rare.Xyd10;
local u11 = { "常见", "罕见", "稀有", "史诗", "传说", "神话", "秘密", "远古", "至尊", "星界" };
local v12 = Color3.fromHex("E3CC4C");
local v13 = Color3.fromHex("B64AB7");
local v14 = Color3.fromHex("4DC3C9");
local v15 = ColorSequence.new({ ColorSequenceKeypoint.new(0, v12), ColorSequenceKeypoint.new(0.5, v13), ColorSequenceKeypoint.new(1, v14) });
local v16 = Color3.fromHex("1E005B");
local v17 = Color3.fromHex("49FFF0");
local v18 = ColorSequence.new({ ColorSequenceKeypoint.new(0, v16), ColorSequenceKeypoint.new(0.5, v17), ColorSequenceKeypoint.new(1, v16) });
local v19 = Color3.fromHex("3C2A00");
local v20 = Color3.fromHex("FFF073");
local v21 = ColorSequence.new({ ColorSequenceKeypoint.new(0, v19), ColorSequenceKeypoint.new(0.5, v20), ColorSequenceKeypoint.new(1, v19) });
local v22 = Color3.fromHex("460000");
local v23 = Color3.fromHex("FF5C5C");
local v24 = ColorSequence.new({ ColorSequenceKeypoint.new(0, v22), ColorSequenceKeypoint.new(0.5, v23), ColorSequenceKeypoint.new(1, v22) });
local u25 = {
    Color3.fromHex("9F9F9F"),
    Color3.fromHex("85D887"),
    Color3.fromHex("858DD8"),
    Color3.fromHex("9E46DB"),
    Color3.fromHex("DB9A46"),
    Color3.fromHex("D95A5A"),
    v13,
    v17,
    v20,
    v23
};
local u26 = {
    {
        Enter = {
            Color = ColorSequence.new(Color3.fromHex("#454545"), Color3.fromHex("#01050B"))
        },
        Normal = {
            Color = ColorSequence.new(Color3.fromHex("#303030"), Color3.fromHex("#01050B"))
        },
        UIStroke = {
            Color = Color3.fromHex("#6F6F6F")
        },
        BGIcon = {
            ImageColor3 = Color3.fromHex("#9F9F9F")
        },
        Effect = {
            ImageColor3 = Color3.fromHex("#9F9F9F")
        }
    },
    {
        Enter = {
            Color = ColorSequence.new(Color3.fromHex("#355C2F"), Color3.fromHex("#01050B"))
        },
        Normal = {
            Color = ColorSequence.new(Color3.fromHex("#243822"), Color3.fromHex("#01050B"))
        },
        UIStroke = {
            Color = Color3.fromHex("#517347")
        },
        BGIcon = {
            ImageColor3 = Color3.fromHex("#85D887")
        },
        Effect = {
            ImageColor3 = Color3.fromHex("#85D887")
        }
    },
    {
        Enter = {
            Color = ColorSequence.new(Color3.fromHex("#214267"), Color3.fromHex("#01050B"))
        },
        Normal = {
            Color = ColorSequence.new(Color3.fromHex("#192A3C"), Color3.fromHex("#01050B"))
        },
        UIStroke = {
            Color = Color3.fromHex("#234E8F")
        },
        BGIcon = {
            ImageColor3 = Color3.fromHex("#3c6fd7")
        },
        Effect = {
            ImageColor3 = Color3.fromHex("#00d8ff")
        }
    },
    {
        Enter = {
            Color = ColorSequence.new(Color3.fromHex("#592F5F"), Color3.fromHex("#01050B"))
        },
        Normal = {
            Color = ColorSequence.new(Color3.fromHex("#503454"), Color3.fromHex("#01050B"))
        },
        UIStroke = {
            Color = Color3.fromHex("#8D529C")
        },
        BGIcon = {
            ImageColor3 = Color3.fromHex("#9E3CD7")
        },
        Effect = {
            ImageColor3 = Color3.fromHex("#9E3CD7")
        }
    },
    {
        Enter = {
            Color = ColorSequence.new(Color3.fromHex("#573B1D"), Color3.fromHex("#01050B"))
        },
        Normal = {
            Color = ColorSequence.new(Color3.fromHex("#3C2B19"), Color3.fromHex("#01050B"))
        },
        UIStroke = {
            Color = Color3.fromHex("#8F5B23")
        },
        BGIcon = {
            ImageColor3 = Color3.fromHex("#d7853c")
        },
        Effect = {
            ImageColor3 = Color3.fromHex("#d7853c")
        }
    },
    {
        Enter = {
            Color = ColorSequence.new(Color3.fromHex("#562727"), Color3.fromHex("#01050B"))
        },
        Normal = {
            Color = ColorSequence.new(Color3.fromHex("#3A1818"), Color3.fromHex("#01050B"))
        },
        UIStroke = {
            Color = Color3.fromHex("#8F4040")
        },
        BGIcon = {
            ImageColor3 = Color3.fromHex("#D95A5A")
        },
        Effect = {
            ImageColor3 = Color3.fromHex("#D95A5A")
        }
    },
    {
        Enter = {
            Color = v15
        },
        Normal = {
            Color = v15
        },
        UIStroke = {
            Color = v13
        },
        BGIcon = {
            ImageColor3 = v12
        },
        Effect = {
            ImageColor3 = v14
        }
    },
    {
        Enter = {
            Color = v18
        },
        Normal = {
            Color = v18
        },
        UIStroke = {
            Color = v16
        },
        BGIcon = {
            ImageColor3 = v17
        },
        Effect = {
            ImageColor3 = v17
        }
    },
    {
        Enter = {
            Color = v21
        },
        Normal = {
            Color = v21
        },
        UIStroke = {
            Color = v19
        },
        BGIcon = {
            ImageColor3 = v20
        },
        Effect = {
            ImageColor3 = v20
        }
    },
    {
        Enter = {
            Color = v24
        },
        Normal = {
            Color = v24
        },
        UIStroke = {
            Color = v22
        },
        BGIcon = {
            ImageColor3 = v23
        },
        Effect = {
            ImageColor3 = v23
        }
    }
};
local u27 = {
    Color3.fromHex("AFAFAF"),
    Color3.fromHex("67D672"),
    Color3.fromHex("6DAADE"),
    Color3.fromHex("BC69E2"),
    Color3.fromHex("F0AB34"),
    Color3.fromHex("FF4444"),
    Color3.fromHex("C8C8C8"),
    v17,
    v20,
    v23
};
local u28 = { "#9F9F9F", "#85D887", "#858DD8", "#9E46DB", "#DB9A46", "#D95A5A", "#B64AB7", "#49FFF0", "#FFF073", "#FF5C5C" };
local u29 = {};
local u30 = {};

local function _normalizeXyd(p31) -- Line: 301
    -- upvalues: Xyd10 (copy)
    local v32 = tonumber(p31) or 1;
    local v33 = math.floor(v32);

    if v33 < 1 then
        return 1;
    end;

    if Xyd10 < v33 then
        v33 = Xyd10;
    end;

    return v33;
end;

local function _resolvePresetInFolder(p34, p35) -- Line: 317
    if not p34 then
        return nil;
    end;

    local v36 = p34:FindFirstChild(p35);

    if v36 and v36:IsA("UIGradient") then
        return v36;
    end;

    return nil;
end;

local function _copyGradientProperties(p37, p38) -- Line: 334
    p37.Color = p38.Color;
    p37.Rotation = p38.Rotation;
    p37.Transparency = p38.Transparency;
    p37.Offset = p38.Offset;
    p37.Enabled = p38.Enabled;
end;

local function _gradientHasAnimScript(p39) -- Line: 347
    if not p39 then
        return false;
    end;

    local v40 = p39:FindFirstChild("渐变");
    local v41;

    if v40 == nil then
        v41 = false;
    else
        v41 = v40:IsA("LocalScript") or v40:IsA("Script");
    end;

    return v41;
end;

local function _resolvePresetInCatalog(p42, p43) -- Line: 361
    -- upvalues: u6 (copy), GradientCfg (copy)
    local function findInFolders(p44) -- Line: 362
        -- upvalues: u6 (ref)
        for _, v in u6 do
            local v45;

            if v then
                v45 = v:FindFirstChild(p44);

                if not (v45 and v45:IsA("UIGradient")) then
                    v45 = nil;
                end;
            else
                v45 = nil;
            end;

            if v45 then
                return v45;
            end;
        end;

        return nil;
    end;

    local v46;

    for _, v in u6 do
        if v then
            v46 = v:FindFirstChild(p42);

            if not (v46 and v46:IsA("UIGradient")) then
                v46 = nil;
            end;
        else
            v46 = nil;
        end;

        if v46 then
            break;
        end;
    end;

    if not v46 then
        local v47 = GradientCfg[p42];

        if v47 ~= nil then
            for _, v in u6 do
                if v then
                    v46 = v:FindFirstChild(v47);

                    if not (v46 and v46:IsA("UIGradient")) then
                        v46 = nil;
                    end;
                else
                    v46 = nil;
                end;

                if v46 then
                    break;
                end;
            end;
        end;
    end;

    if not v46 then
        return nil;
    end;

    if p43 then
        return v46:Clone();
    end;

    return v46;
end;

local function _watchInstanceDestroyed(p48, u49) -- Line: 391
    return p48.AncestryChanged:Connect(function(p50, p51) -- Line: 392
        -- upvalues: u49 (copy)
        if p51 == nil then
            u49();
        end;
    end);
end;

local function _resetParentWhiteBase(p52) -- Line: 403
    if p52:IsA("TextLabel") or p52:IsA("TextButton") then
        p52.TextColor3 = Color3.new(1, 1, 1);

        return;
    end;

    if p52:IsA("Frame") then
        p52.BackgroundColor3 = Color3.new(1, 1, 1);

        return;
    end;

    if p52:IsA("ImageLabel") or p52:IsA("ImageButton") then
        p52.ImageColor3 = Color3.new(1, 1, 1);

        return;
    end;

    if p52:IsA("UIStroke") then
        p52.Color = Color3.new(1, 1, 1);
    end;
end;

local function _getColorAtTime(p53, p54) -- Line: 421
    local Keypoints = p53.Keypoints;

    if not Keypoints or #Keypoints == 0 then
        return Color3.new(1, 1, 1);
    end;

    if #Keypoints == 1 or p54 <= Keypoints[1].Time then
        return Keypoints[1].Value;
    end;

    if Keypoints[#Keypoints].Time <= p54 then
        return Keypoints[#Keypoints].Value;
    end;

    for i = 1, #Keypoints - 1 do
        if Keypoints[i].Time <= p54 and p54 <= Keypoints[i + 1].Time then
            local Time = Keypoints[i].Time;
            local Time2 = Keypoints[i + 1].Time;

            return Keypoints[i].Value:Lerp(Keypoints[i + 1].Value, Time2 - Time > 0 and (p54 - Time) / (Time2 - Time) or 0);
        end;
    end;

    return Keypoints[#Keypoints].Value;
end;

local function _lerpColorSequence(p55, p56, p57) -- Line: 450
    -- upvalues: _getColorAtTime (copy)
    local v58 = _getColorAtTime(p55, 0):Lerp(_getColorAtTime(p56, 0), p57);
    local v59 = _getColorAtTime(p55, 1):Lerp(_getColorAtTime(p56, 1), p57);

    return ColorSequence.new({ ColorSequenceKeypoint.new(0, v58), ColorSequenceKeypoint.new(1, v59) });
end;

local function _finishGradientTransition(p60) -- Line: 463
    -- upvalues: u30 (copy)
    local v61 = u30[p60];

    if not v61 then
        return;
    end;

    u30[p60] = nil;
    v61.connection:Disconnect();

    if v61.ancestryConnection then
        v61.ancestryConnection:Disconnect();
    end;
end;

local function _startGradientColorTransition(u62, u63, u64, u65) -- Line: 483
    -- upvalues: u30 (copy), RunService (copy), _lerpColorSequence (copy)
    local v66 = u30[u62];

    if v66 then
        u30[u62] = nil;
        v66.connection:Disconnect();

        if v66.ancestryConnection then
            v66.ancestryConnection:Disconnect();
        end;
    end;

    local u67 = tick();

    local function u70() -- Line: 501
        -- upvalues: u62 (copy), u30 (ref)
        local v68 = u62;
        local v69 = u30[v68];

        if not v69 then
            return;
        end;

        u30[v68] = nil;
        v69.connection:Disconnect();

        if v69.ancestryConnection then
            v69.ancestryConnection:Disconnect();
        end;
    end;

    local v73 = u62.AncestryChanged:Connect(function(p71, p72) -- Line: 392
        -- upvalues: u70 (copy)
        if p72 == nil then
            u70();
        end;
    end);
    u30[u62] = {
        connection = RunService.Heartbeat:Connect(function() -- Line: 492
            -- upvalues: u67 (copy), u63 (copy), _lerpColorSequence (ref), u64 (copy), u65 (copy), u62 (copy), u30 (ref)
            local v74 = (tick() - u67) / 0.25;
            local v75 = math.min(1, v74);
            u63.Color = _lerpColorSequence(u64, u65, v75);

            if v75 >= 1 then
                u63.Color = u65;
                local v76 = u62;
                local v77 = u30[v76];

                if not v77 then
                    return;
                end;

                u30[v76] = nil;
                v77.connection:Disconnect();

                if v77.ancestryConnection then
                    v77.ancestryConnection:Disconnect();
                end;
            end;
        end),
        gradient = u63,
        ancestryConnection = v73
    };
end;

local function _applyPresetToParent(p78, p79, p80, p81, p82) -- Line: 522
    -- upvalues: _resetParentWhiteBase (copy), _startGradientColorTransition (copy)
    local v83 = p78:FindFirstChildOfClass("UIGradient");
    local v84;

    if v83 == nil then
        v84 = false;
    else
        local v85;

        if p79 then
            local v86 = p79:FindFirstChild("渐变");

            if v86 == nil then
                v85 = false;
            else
                v85 = v86:IsA("LocalScript") or v86:IsA("Script");
            end;
        else
            v85 = false;
        end;

        v84 = not v85;

        if v84 then
            local v87;

            if v83 then
                local v88 = v83:FindFirstChild("渐变");

                if v88 == nil then
                    v87 = false;
                else
                    v87 = v88:IsA("LocalScript") or v88:IsA("Script");
                end;
            else
                v87 = false;
            end;

            v84 = not v87;
        end;
    end;

    local v89 = p82 ~= false;
    local v90 = nil;

    if v84 then
        if v89 then
            v90 = v83.Color;
        end;

        v83.Color = p79.Color;
        v83.Rotation = p79.Rotation;
        v83.Transparency = p79.Transparency;
        v83.Offset = p79.Offset;
        v83.Enabled = p79.Enabled;
    else
        if v83 and v89 then
            v90 = v83.Color;
        end;

        if v83 then
            v83:Destroy();
        end;

        v83 = p79:Clone();
        v83.Parent = p78;
    end;

    if p81 ~= nil then
        v83.Rotation = p81;
    end;

    _resetParentWhiteBase(p78);
    p78:SetAttribute("xyd", p80);

    if v89 and v90 then
        local Color = p79.Color;
        v83.Color = v90;
        _startGradientColorTransition(p78, v83, v90, Color);
    end;

    return v83;
end;

local function _refreshXydEffect(p91, p92) -- Line: 576
    -- upvalues: u10 (copy), EnumMgr (copy), SequenceManager (copy)
    if p91:GetAttribute("xydEffect") == p92 then
        return;
    end;

    if not p91:FindFirstChild("框特效") and u10 then
        u10:Clone().Parent = p91;
    end;

    local v93 = p91:FindFirstChild("框特效");

    if not v93 then
        return;
    end;

    local v94 = v93:FindFirstChild("框特效");

    if p92 == EnumMgr.Rare.Xyd4 then
        v93.Visible = true;

        if v94 then
            SequenceManager:PlaySequence(v94, "彩虹框", 5, true);
        end;
    elseif p92 == EnumMgr.Rare.Xyd7 then
        v93.Visible = true;

        if v94 then
            SequenceManager:PlaySequence(v94, "秘密框", 5, true);
        end;
    else
        v93.Visible = false;

        if v94 then
            SequenceManager:StopSequence(v94);
        end;
    end;

    p91:SetAttribute("xydEffect", p92);
end;

function u29.getXydName(p95) -- Line: 624
    -- upvalues: u11 (copy)
    return u11[tonumber(p95)];
end;

function u29.setXydLabel(p96, p97, p98, p99) -- Line: 638
    -- upvalues: TranslationHelper (copy), u29 (copy), Xyd10 (copy)
    if not p96:IsA("TextLabel") then
        return;
    end;

    TranslationHelper.SetText(p96, u29.getXydName(p97));
    local AddGradientColor = u29.AddGradientColor;
    local v100 = tonumber(p97) or 1;
    local v101 = math.floor(v100);

    if v101 < 1 then
        v101 = 1;
    elseif Xyd10 < v101 then
        v101 = Xyd10;
    end;

    AddGradientColor(tostring(v101), p96, true, nil, p99);

    if not (p98 ~= false) then
        return;
    end;

    local v102 = p96:FindFirstChildOfClass("UIStroke");

    if v102 and v102.Thickness > 0 then
        return;
    end;

    local v103 = u29.GetXydColor(p97);

    if not v103 then
        return;
    end;

    local Board = v103:FindFirstChild("Board");
    local v104 = Color3.new(1, 1, 1);
    local v105;

    if Board and Board:IsA("Color3Value") then
        v105 = Board.Value;
    elseif Board then
        v105 = Board.Value;

        if typeof(v105) ~= "Color3" then
            v105 = v104;
        end;
    else
        v105 = v104;
    end;

    if v102 then
        v102.Thickness = 1;
        v102.Color = v105;

        return;
    end;

    local UIStroke = Instance.new("UIStroke");
    UIStroke.Thickness = 1;
    UIStroke.Color = v105;
    UIStroke.Parent = p96;
end;

function u29.SetItemXyd(p106, p107) -- Line: 692
    -- upvalues: Xyd10 (copy), u29 (copy)
    local v108 = tonumber(p107) or 1;
    local v109 = math.floor(v108);

    if v109 < 1 then
        v109 = 1;
    elseif Xyd10 < v109 then
        v109 = Xyd10;
    end;

    local v110 = tostring(v109);
    u29.AddGradientColor(v110, p106.BG);
    u29.AddGradientColor(v110, p106);
    local xydStr = p106:FindFirstChild("xydStr");

    if xydStr then
        xydStr.Text = u29.getXydName(p107) or "";
        u29.AddGradientColor(v110, xydStr, true);
    end;
end;

function u29.SetHeroXyd(p111, p112) -- Line: 714
    -- upvalues: u7 (ref), _refreshXydEffect (copy)
    if p111:GetAttribute("OriXyd") == p112 then
        return;
    end;

    local BG = p111:FindFirstChild("BG");
    local v113 = BG and BG:FindFirstChild("Icon");

    if v113 then
        local v114 = v113:FindFirstChildOfClass("UIGradient");

        if v114 then
            v114:Destroy();
        end;

        local v115 = u7 and u7:FindFirstChild((tostring(p112)));

        if v115 then
            v115 = v115:FindFirstChild("BG");
        end;

        if v115 then
            local v116 = v115:Clone();
            v116.Parent = v113;
            v116.Enabled = true;
        end;
    end;

    local Stroke = p111:FindFirstChild("Stroke");
    local v117 = Stroke and Stroke:FindFirstChild("Icon");

    if v117 then
        local v118 = v117:FindFirstChildOfClass("UIGradient");

        if v118 then
            v118:Destroy();
        end;

        local v119 = u7 and u7:FindFirstChild((tostring(p112)));

        if v119 then
            v119 = v119:FindFirstChild("Stroke");
        end;

        if v119 then
            local v120 = v119:Clone();
            v120.Parent = v117;
            v120.Enabled = true;
        end;
    end;

    _refreshXydEffect(p111, p112);
    p111:SetAttribute("OriXyd", p112);
end;

function u29.SetStroke(p121, p122, p123) -- Line: 770
    -- upvalues: Xyd10 (copy), u29 (copy)
    local v124 = tonumber(p122) or 1;
    local v125 = math.floor(v124);

    if v125 < 1 then
        v125 = 1;
    elseif Xyd10 < v125 then
        v125 = Xyd10;
    end;

    local v126 = tostring(v125);
    local BG = p121.BG;
    u29.AddGradientColor(v126, p121.Stroke);
    u29.AddGradientColor(v126, BG);

    if p123 then
        local v127 = p123 * 2;
        BG.Size = UDim2.new(1, -v127, 1, -v127);
    end;
end;

function u29.GetXydColorHex(p128) -- Line: 788
    -- upvalues: u28 (copy), Xyd10 (copy)
    local v129 = tonumber(p128) or 1;
    local v130 = math.floor(v129);

    if v130 < 1 then
        v130 = 1;
    elseif Xyd10 < v130 then
        v130 = Xyd10;
    end;

    return u28[v130];
end;

function u29.GetXydColor(p131) -- Line: 797
    -- upvalues: u4 (copy)
    if not u4 then
        return nil;
    end;

    if p131 then
        return u4:FindFirstChild((tostring(p131)));
    end;

    return u4:FindFirstChild("0");
end;

function u29.GetGradientColor(p132) -- Line: 818
    -- upvalues: u1 (copy), Log (copy), _resolvePresetInCatalog (copy)
    if not u1 then
        Log.warn("Assets/AllGridients 未找到");

        return nil;
    end;

    local v133 = tostring(p132);
    local v134 = _resolvePresetInCatalog(v133, true);

    if not v134 then
        Log.warn("AllGridients 下未找到渐变预设", v133);
    end;

    return v134;
end;

function u29.AddGradientColor(p135, p136, p137, p138, p139) -- Line: 840
    -- upvalues: u30 (copy), _resolvePresetInCatalog (copy), Log (copy), _applyPresetToParent (copy)
    if not p135 then
        return nil;
    end;

    local v140 = tostring(p135);
    local v141;

    if p137 == true then
        v141 = v140 .. "-Text";
    else
        v141 = v140;
    end;

    local v142 = u30[p136];

    if v142 then
        u30[p136] = nil;
        v142.connection:Disconnect();

        if v142.ancestryConnection then
            v142.ancestryConnection:Disconnect();
        end;
    end;

    local v143 = _resolvePresetInCatalog(v141, false);

    if v143 then
        return _applyPresetToParent(p136, v143, v140, p138, p139);
    end;

    Log.warn("AllGridients 下未找到渐变预设", v141);

    return nil;
end;

function u29.RemoveGradientColor(p144) -- Line: 863
    -- upvalues: u30 (copy)
    local v145 = u30[p144];

    if v145 then
        u30[p144] = nil;
        v145.connection:Disconnect();

        if v145.ancestryConnection then
            v145.ancestryConnection:Disconnect();
        end;
    end;

    local v146 = p144:FindFirstChildOfClass("UIGradient");

    if v146 then
        v146:Destroy();
        p144:SetAttribute("xyd", nil);
    end;
end;

function u29.GetUIGradient(p147) -- Line: 877
    return p147:FindFirstChildOfClass("UIGradient");
end;

function u29.ApplyTitleTextFromTemplate(p148, p149, p150) -- Line: 888
    -- upvalues: u30 (copy), u9 (copy)
    if not (p148 and p148:IsA("TextLabel")) then
        return;
    end;

    local v151 = p150 ~= false;
    local v152 = u30[p148];

    if v152 then
        u30[p148] = nil;
        v152.connection:Disconnect();

        if v152.ancestryConnection then
            v152.ancestryConnection:Disconnect();
        end;
    end;

    for _, child in p148:GetChildren() do
        if child:IsA("UIGradient") or v151 and child:IsA("UIStroke") then
            child:Destroy();
        end;
    end;

    local v153 = p149 and tostring(p149) or "";

    if v153 == "" then
        p148.TextColor3 = Color3.new(1, 1, 1);
        p148:SetAttribute("titleTemplate", nil);

        return;
    end;

    local v154 = u9;

    if not v154 then
        p148.TextColor3 = Color3.new(1, 1, 1);

        return;
    end;

    local v155 = v154:FindFirstChild(v153);

    if not (v155 and v155:IsA("TextLabel")) then
        p148.TextColor3 = Color3.new(1, 1, 1);
        p148:SetAttribute("titleTemplate", nil);

        return;
    end;

    p148.TextColor3 = Color3.new(1, 1, 1);
    local v156 = v155:FindFirstChildOfClass("UIGradient");

    if v156 then
        v156:Clone().Parent = p148;
    end;

    local v157 = v151 and v155:FindFirstChildOfClass("UIStroke");

    if v157 then
        v157:Clone().Parent = p148;
    end;

    p148:SetAttribute("titleTemplate", v153);
end;

function u29.ApplyTitleTextByTitleId(p158, p159, p160) -- Line: 945
    -- upvalues: u29 (copy), CfgFind (copy), EnumMgr (copy)
    local v161 = tonumber(p159) or 0;

    if v161 <= 0 then
        u29.ApplyTitleTextFromTemplate(p158, nil, p160);

        return;
    end;

    local v162 = CfgFind.FindCfgByID(v161, EnumMgr.ItemType.Title);

    if v162 then
        v162 = v162.Model;
    end;

    u29.ApplyTitleTextFromTemplate(p158, v162 and tostring(v162) or nil, p160);
end;

function u29.NormalizeXyd(p163) -- Line: 965
    -- upvalues: Xyd10 (copy)
    local v164 = tonumber(p163) or 1;
    local v165 = math.floor(v164);

    if v165 < 1 then
        v165 = 1;
    elseif Xyd10 < v165 then
        v165 = Xyd10;
    end;

    return v165;
end;

function u29.GetXydPassBgStyle(p166) -- Line: 974
    -- upvalues: Xyd10 (copy), u26 (copy), Copy (copy)
    local v167 = tonumber(p166) or 1;
    local v168 = math.floor(v167);

    if v168 < 1 then
        v168 = 1;
    elseif Xyd10 < v168 then
        v168 = Xyd10;
    end;

    local v169 = u26[v168];

    if v169 then
        return Copy.deepCopy(v169);
    end;

    return nil;
end;

function u29.GetColor3ByXYD(p170) -- Line: 994
    -- upvalues: Xyd10 (copy), u25 (copy)
    local v171 = tonumber(p170) or 1;
    local v172 = math.floor(v171);

    if v172 < 1 then
        v172 = 1;
    elseif Xyd10 < v172 then
        v172 = Xyd10;
    end;

    return u25[v172];
end;

function u29.GetRarityBgGlowColor(p173) -- Line: 1004
    -- upvalues: Xyd10 (copy), u27 (copy)
    local v174 = tonumber(p173) or 1;
    local v175 = math.floor(v174);

    if v175 < 1 then
        v175 = 1;
    elseif Xyd10 < v175 then
        v175 = Xyd10;
    end;

    return u27[v175] or u27[1];
end;

function u29.ApplyEquipmentItemBg(p176, p177) -- Line: 1015
    -- upvalues: Xyd10 (copy), u29 (copy)
    if not p176 then
        return;
    end;

    local v178 = tonumber(p177) or 1;
    local v179 = math.floor(v178);

    if v179 < 1 then
        v179 = 1;
    elseif Xyd10 < v179 then
        v179 = Xyd10;
    end;

    local v180 = tostring(v179);
    u29.AddGradientColor(v180, p176, false, nil, false);
    local v181 = p176:FindFirstChild("Bg光");

    if v181 then
        v181.Visible = true;
        v181.ImageColor3 = u29.GetRarityBgGlowColor(v179);
    end;
end;

return u29;