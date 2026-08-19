-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CollectionService = UtilsSystem.CollectionService;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local MathMgr = UtilsSystem.MathMgr;
local Players = UtilsSystem.Players;
local ResourceUtil = UtilsSystem.ResourceUtil;
local RunService = UtilsSystem.RunService;
local TranslationHelper = UtilsSystem.TranslationHelper;
local u1 = UtilsSystem.AssetRegistry.BuildCatalogPath("BillBoard", "NameTag");
local u2 = ResourceUtil.GetTemplate(u1);

if not u2 then
    Log.warn("[NameTag.client] 缺少 Assets.BillBoard.NameTag，路径:", u1);
end;

local u3 = not u2 and Vector3.new(0, 3, 0) or u2.StudsOffset;
local u4 = not u2 and Vector3.new(0, 0, 0) or u2.StudsOffsetWorldSpace;
local u5;

if u2 then
    u5 = u2.Size;
else
    u5 = UDim2.new(0, 100, 0, 40);
end;

local u6 = not u2 and 0 or u2.MaxDistance;
local Y = u3.Y;
local v7 = math.abs(Y) < 0.001 and 3 or Y;
local Y2 = u4.Y;

if math.abs(Y2) < 0.001 then
    Y2 = v7;
end;

local u8 = {};
local u9 = nil;

local function _getBodyScaleMul(p10) -- Line: 84
    -- upvalues: LocalPlayer (copy)
    local v11 = p10:GetAttribute("CharMorph_OrigBodyScale");

    if type(v11) ~= "number" or v11 <= 0 then
        return 1;
    end;

    if LocalPlayer and p10 == LocalPlayer.Character then
        local v12 = p10:GetAttribute("CharMorph_VisualScale");

        if type(v12) == "number" and v12 > 0 then
            return v12 / v11;
        end;
    end;

    local v13 = p10:GetScale();

    return (type(v13) ~= "number" or v13 <= 0) and 1 or v13 / v11;
end;

local function _applyBillboardLayout(p14) -- Line: 110
    -- upvalues: _getBodyScaleMul (copy), u5 (copy), u6 (copy), u3 (copy), u4 (copy), Y2 (ref)
    local gui = p14.gui;
    local character = p14.character;

    if not (gui.Parent and character.Parent) then
        return;
    end;

    local v15 = _getBodyScaleMul(character);
    local v16 = v15 < 0.001 and 1 or v15;
    gui.Size = u5;
    gui.MaxDistance = u6;
    gui.StudsOffset = u3;
    gui.StudsOffsetWorldSpace = Vector3.new(u4.X * v16, Y2 * v16, u4.Z * v16);
end;

local function _stopLayoutHeartbeat(p17) -- Line: 138
    local layoutHeartbeat = p17.layoutHeartbeat;

    if layoutHeartbeat then
        layoutHeartbeat:Disconnect();
        p17.layoutHeartbeat = nil;
    end;
end;

local function _syncLayoutHeartbeat(u18) -- Line: 152
    -- upvalues: LocalPlayer (copy), RunService (copy), _getBodyScaleMul (copy), u5 (copy), u6 (copy), u3 (copy), u4 (copy), Y2 (ref)
    local character = u18.character;
    local v19 = LocalPlayer and character == LocalPlayer.Character;
    local v20 = character:GetAttribute("CharMorph_VisualScale");

    if v19 then
        v19 = type(v20) == "number";
    end;

    if v19 then
        if not u18.layoutHeartbeat then
            u18.layoutHeartbeat = RunService.Heartbeat:Connect(function() -- Line: 160
                -- upvalues: u18 (copy), character (copy), _getBodyScaleMul (ref), u5 (ref), u6 (ref), u3 (ref), u4 (ref), Y2 (ref)
                if not (u18.gui.Parent and character.Parent) then
                    local v21 = u18;
                    local layoutHeartbeat = v21.layoutHeartbeat;

                    if layoutHeartbeat then
                        layoutHeartbeat:Disconnect();
                        v21.layoutHeartbeat = nil;
                    end;

                    return;
                end;

                if type(character:GetAttribute("CharMorph_VisualScale")) == "number" then
                    local v22 = u18;
                    local gui = v22.gui;
                    local character2 = v22.character;

                    if gui.Parent then
                        if not character2.Parent then
                            return;
                        end;

                        local v23 = _getBodyScaleMul(character2);
                        local v24 = v23 < 0.001 and 1 or v23;
                        gui.Size = u5;
                        gui.MaxDistance = u6;
                        gui.StudsOffset = u3;
                        gui.StudsOffsetWorldSpace = Vector3.new(u4.X * v24, Y2 * v24, u4.Z * v24);
                    end;

                    return;
                end;

                local v25 = u18;
                local layoutHeartbeat = v25.layoutHeartbeat;

                if layoutHeartbeat then
                    layoutHeartbeat:Disconnect();
                    v25.layoutHeartbeat = nil;
                end;

                local v26 = u18;
                local gui = v26.gui;
                local character2 = v26.character;

                if gui.Parent then
                    if not character2.Parent then
                        return;
                    end;

                    local v27 = _getBodyScaleMul(character2);
                    local v28 = v27 < 0.001 and 1 or v27;
                    gui.Size = u5;
                    gui.MaxDistance = u6;
                    gui.StudsOffset = u3;
                    gui.StudsOffsetWorldSpace = Vector3.new(u4.X * v28, Y2 * v28, u4.Z * v28);
                end;
            end);
        end;

        local gui = u18.gui;
        local character2 = u18.character;

        if gui.Parent then
            if not character2.Parent then
                return;
            end;

            local v29 = _getBodyScaleMul(character2);
            local v30 = v29 < 0.001 and 1 or v29;
            gui.Size = u5;
            gui.MaxDistance = u6;
            gui.StudsOffset = u3;
            gui.StudsOffsetWorldSpace = Vector3.new(u4.X * v30, Y2 * v30, u4.Z * v30);
        end;
    else
        local layoutHeartbeat = u18.layoutHeartbeat;

        if layoutHeartbeat then
            layoutHeartbeat:Disconnect();
            u18.layoutHeartbeat = nil;
        end;

        local gui = u18.gui;
        local character2 = u18.character;

        if gui.Parent then
            if not character2.Parent then
                return;
            end;

            local v31 = _getBodyScaleMul(character2);
            local v32 = v31 < 0.001 and 1 or v31;
            gui.Size = u5;
            gui.MaxDistance = u6;
            gui.StudsOffset = u3;
            gui.StudsOffsetWorldSpace = Vector3.new(u4.X * v32, Y2 * v32, u4.Z * v32);
        end;
    end;
end;

local function _unbindHrp(p33) -- Line: 187
    -- upvalues: u8 (copy)
    local v34 = u8[p33];

    if not v34 then
        return;
    end;

    local layoutHeartbeat = v34.layoutHeartbeat;

    if layoutHeartbeat then
        layoutHeartbeat:Disconnect();
        v34.layoutHeartbeat = nil;
    end;

    for _, v in ipairs(v34.conns) do
        v:Disconnect();
    end;

    if v34.gui.Parent then
        v34.gui:Destroy();
    end;

    u8[p33] = nil;
end;

local function _getOwnerPlayer(p35) -- Line: 208
    -- upvalues: Players (copy)
    local Parent = p35.Parent;

    if Parent and Parent:IsA("Model") then
        return Players:GetPlayerFromCharacter(Parent);
    end;

    return nil;
end;

local function _refreshOtherNameTagVisibility() -- Line: 221
    -- upvalues: u9 (ref), u8 (copy), Players (copy), LocalPlayer (copy)
    local v36 = not u9 and true or u9.Value == 1;

    for i, v in pairs(u8) do
        local Parent = i.Parent;
        local v37;

        if Parent and Parent:IsA("Model") then
            v37 = Players:GetPlayerFromCharacter(Parent);
        else
            v37 = nil;
        end;

        if v37 and v37 ~= LocalPlayer then
            v.gui.Enabled = v36;
        elseif v37 == LocalPlayer then
            v.gui.Enabled = true;
        end;
    end;
end;

local function _resolveLabels(p38) -- Line: 243
    local Frame = p38:FindFirstChild("Frame");

    if not (Frame and Frame:IsA("Frame")) then
        return nil, nil;
    end;

    local v39 = nil;
    local NameLabel = Frame:FindFirstChild("NameLabel");

    if NameLabel then
        if not NameLabel:IsA("TextLabel") then
            NameLabel = v39;
        end;
    else
        NameLabel = v39;
    end;

    local v40 = nil;
    local Magic = Frame:FindFirstChild("Magic");
    local v41;

    if Magic and Magic:IsA("Frame") then
        v41 = Magic:FindFirstChild("Num");

        if v41 then
            if not v41:IsA("TextLabel") then
                v41 = v40;
            end;
        else
            v41 = v40;
        end;
    else
        v41 = v40;
    end;

    return v41, NameLabel;
end;

local function _getOrCloneGui(p42) -- Line: 272
    -- upvalues: CollectionService (copy), u2 (copy)
    local NameTag = p42:FindFirstChild("NameTag");

    if NameTag and NameTag:IsA("BillboardGui") then
        NameTag.Adornee = p42;

        if not CollectionService:HasTag(NameTag, "BillboardGui") then
            CollectionService:AddTag(NameTag, "BillboardGui");
        end;

        return NameTag;
    end;

    if not u2 then
        return nil;
    end;

    local v43 = u2:Clone();
    v43.Name = "NameTag";
    v43.Adornee = p42;
    v43.Parent = p42;
    CollectionService:AddTag(v43, "BillboardGui");

    return v43;
end;

local function _refreshMagicNum(p44, p45) -- Line: 299
    -- upvalues: GetData (copy), TranslationHelper (copy), MathMgr (copy)
    local v46 = GetData.GetTotalMagicValue(p44);
    local v47 = math.floor(v46);
    TranslationHelper.SetText_UnTrans(p45, MathMgr.getNumStr(v47));
end;

local function _applyNameLabel(p48, p49) -- Line: 311
    -- upvalues: TranslationHelper (copy)
    TranslationHelper.SetText_UnTrans(p48, p49.DisplayName);
    p48.Visible = true;
end;

local function _bindHrp(u50) -- Line: 322
    -- upvalues: u8 (copy), Players (copy), _getOrCloneGui (copy), Log (copy), u1 (copy), _resolveLabels (copy), TranslationHelper (copy), _getBodyScaleMul (copy), u5 (copy), u6 (copy), u3 (copy), u4 (copy), Y2 (ref), _syncLayoutHeartbeat (copy), GetData (copy), MathMgr (copy), EnumMgr (copy), AddListen (copy), _unbindHrp (copy), LocalPlayer (copy), u9 (ref)
    if not u50:IsA("BasePart") then
        return;
    end;

    if u8[u50] then
        return;
    end;

    local Parent = u50.Parent;
    local u51;

    if Parent and Parent:IsA("Model") then
        u51 = Players:GetPlayerFromCharacter(Parent);
    else
        u51 = nil;
    end;

    if not u51 then
        return;
    end;

    local Parent2 = u50.Parent;

    if not (Parent2 and Parent2:IsA("Model")) then
        return;
    end;

    local u52 = _getOrCloneGui(u50);

    if not u52 then
        Log.warn("[NameTag.client] 无法克隆 NameTag，模板缺失:", u1);

        return;
    end;

    local u53, v54 = _resolveLabels(u52);

    if v54 then
        TranslationHelper.SetText_UnTrans(v54, u51.DisplayName);
        v54.Visible = true;
    end;

    if not u53 then
        Log.warn("[NameTag.client] NameTag 缺少 Frame.Magic.Num:", u51.Name);
        u52:Destroy();

        return;
    end;

    local v55 = {};
    local u56 = {
        layoutHeartbeat = nil,
        conns = v55,
        gui = u52,
        hrp = u50,
        character = Parent2
    };
    u8[u50] = u56;
    local gui = u56.gui;
    local character = u56.character;

    if gui.Parent and character.Parent then
        local v57 = _getBodyScaleMul(character);
        local v58 = v57 < 0.001 and 1 or v57;
        gui.Size = u5;
        gui.MaxDistance = u6;
        gui.StudsOffset = u3;
        gui.StudsOffsetWorldSpace = Vector3.new(u4.X * v58, Y2 * v58, u4.Z * v58);
    end;

    _syncLayoutHeartbeat(u56);

    local function refresh() -- Line: 368
        -- upvalues: u52 (copy), u51 (copy), u53 (copy), GetData (ref), TranslationHelper (ref), MathMgr (ref)
        if not u52.Parent then
            return;
        end;

        local v59 = GetData.GetTotalMagicValue(u51);
        local v60 = math.floor(v59);
        TranslationHelper.SetText_UnTrans(u53, MathMgr.getNumStr(v60));
    end;

    task.spawn(function() -- Line: 375
        -- upvalues: GetData (ref), u51 (copy), EnumMgr (ref), u8 (ref), u50 (copy), u52 (copy), AddListen (ref), refresh (copy)
        local v61 = GetData.WaitBagNumberValue(u51, EnumMgr.ItemID.Power);
        local v62 = GetData.WaitBagNumberValue(u51, EnumMgr.ItemID.PowerUsed);
        local v63 = u8[u50];

        if not v63 or (v63.gui ~= u52 or not (u52.Parent and u50.Parent)) then
            return;
        end;

        table.insert(v63.conns, AddListen.NumValueAdd(v61, refresh, true));
        table.insert(v63.conns, AddListen.NumValueAdd(v62, refresh, false));
    end);
    table.insert(v55, u50.AncestryChanged:Connect(function() -- Line: 388
        -- upvalues: u50 (copy), _unbindHrp (ref)
        if u50.Parent == nil then
            _unbindHrp(u50);
        end;
    end));
    local v64 = Parent2:GetAttributeChangedSignal("CharMorph_VisualScale");
    table.insert(v55, v64:Connect(function() -- Line: 398
        -- upvalues: _syncLayoutHeartbeat (ref), u56 (copy)
        _syncLayoutHeartbeat(u56);
    end));
    local v65 = Parent2:GetAttributeChangedSignal("CharMorph_OrigBodyScale");
    table.insert(v55, v65:Connect(function() -- Line: 404
        -- upvalues: u56 (copy), _getBodyScaleMul (ref), u5 (ref), u6 (ref), u3 (ref), u4 (ref), Y2 (ref), _syncLayoutHeartbeat (ref)
        local v66 = u56;
        local gui2 = v66.gui;
        local character2 = v66.character;

        if gui2.Parent and character2.Parent then
            local v67 = _getBodyScaleMul(character2);
            local v68 = v67 < 0.001 and 1 or v67;
            gui2.Size = u5;
            gui2.MaxDistance = u6;
            gui2.StudsOffset = u3;
            gui2.StudsOffsetWorldSpace = Vector3.new(u4.X * v68, Y2 * v68, u4.Z * v68);
        end;

        _syncLayoutHeartbeat(u56);
    end));

    if u51 == LocalPlayer then
        u52.Enabled = true;

        return;
    end;

    u52.Enabled = not u9 and true or u9.Value == 1;
end;

local function _initShowOtherSetting() -- Line: 426
    -- upvalues: LocalPlayer (copy), u9 (ref), AddListen (copy), _refreshOtherNameTagVisibility (copy)
    task.spawn(function() -- Line: 427
        -- upvalues: LocalPlayer (ref), u9 (ref), AddListen (ref), _refreshOtherNameTagVisibility (ref)
        local ShowOtherPlrInfo = LocalPlayer:WaitForChild("Setting", (1 / 0)):WaitForChild("ShowOtherPlrInfo", (1 / 0));

        if ShowOtherPlrInfo and ShowOtherPlrInfo:IsA("NumberValue") then
            u9 = ShowOtherPlrInfo;
            AddListen.NumValueAdd(ShowOtherPlrInfo, _refreshOtherNameTagVisibility, true);
        end;
    end);
end;

task.spawn(function() -- Line: 427
    -- upvalues: LocalPlayer (copy), u9 (ref), AddListen (copy), _refreshOtherNameTagVisibility (copy)
    local ShowOtherPlrInfo = LocalPlayer:WaitForChild("Setting", (1 / 0)):WaitForChild("ShowOtherPlrInfo", (1 / 0));

    if ShowOtherPlrInfo and ShowOtherPlrInfo:IsA("NumberValue") then
        u9 = ShowOtherPlrInfo;
        AddListen.NumValueAdd(ShowOtherPlrInfo, _refreshOtherNameTagVisibility, true);
    end;
end);
task.defer(function() -- Line: 439
    -- upvalues: LocalPlayer (copy)
    local NameTagHost = workspace:FindFirstChild("NameTagHost");

    if NameTagHost then
        NameTagHost:Destroy();
    end;

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("ScreenGui");
    end;

    if PlayerGui then
        PlayerGui = PlayerGui:FindFirstChild("NameTag");
    end;

    if PlayerGui then
        PlayerGui:Destroy();
    end;
end);

for _, v in CollectionService:GetTagged("NameTag") do
    task.defer(_bindHrp, v);
end;

CollectionService:GetInstanceAddedSignal("NameTag"):Connect(function(p69) -- Line: 456
    -- upvalues: _bindHrp (copy)
    task.defer(_bindHrp, p69);
end);
CollectionService:GetInstanceRemovedSignal("NameTag"):Connect(function(p70) -- Line: 460
    -- upvalues: _unbindHrp (copy)
    if p70:IsA("BasePart") then
        _unbindHrp(p70);
    end;
end);