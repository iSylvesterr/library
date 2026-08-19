-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ServerStorage = game:GetService("ServerStorage");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local InsMgr = UtilsSystem.InsMgr;
local Log = UtilsSystem.Log;
local UpdateModule = UtilsSystem.UpdateModule;
local u1 = {};
local SEC_300 = UpdateModule.INTERVAL.SEC_300;
local u2 = false;
local u3 = nil;
local u4 = false;

local function _ensureInit() -- Line: 79
    -- upvalues: u2 (ref), u1 (copy)
    if not u2 then
        u1.Init();
    end;
end;

local function _getCacheFolder(p5) -- Line: 91
    -- upvalues: u2 (ref), u1 (copy), InsMgr (copy), u3 (ref)
    if not u2 then
        u1.Init();
    end;

    return InsMgr.GetIns(p5, "Folder", u3);
end;

local function _addUseTag(p6) -- Line: 102
    if not p6 then
        return;
    end;

    p6:SetAttribute("use", 1);
end;

local function _delUnusedCache(p7) -- Line: 115
    -- upvalues: Debris (copy)
    if not p7 then
        return;
    end;

    if p7:GetAttribute("use") == 1 then
        p7:SetAttribute("use", 0);

        return;
    end;

    Debris:AddItem(p7, 0);
end;

local function _fetchPlrNameFromApi(u8) -- Line: 133
    -- upvalues: Players (copy), Log (copy)
    local u9 = "";
    local success, result = pcall(function() -- Line: 135
        -- upvalues: u9 (ref), Players (ref), u8 (copy)
        u9 = Players:GetNameFromUserIdAsync(u8);
    end);

    if success then
        return u9 == "" and "???" or u9;
    end;

    Log.warn("DataCache._fetchPlrNameFromApi failed", u8, result);

    return "???";
end;

local function _fetchPortraitFromApi(u10) -- Line: 157
    -- upvalues: Players (copy), Log (copy)
    local u11 = "";
    local success, result = pcall(function() -- Line: 159
        -- upvalues: Players (ref), u10 (copy), u11 (ref)
        u11 = Players:GetUserThumbnailAsync(u10, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60) or "";
    end);

    if not success then
        Log.warn("DataCache._fetchPortraitFromApi failed", u10, result);
    end;

    return u11;
end;

local function _sweepFolder(p12) -- Line: 181
    -- upvalues: Debris (copy)
    for _, child in p12:GetChildren() do
        if child:IsA("StringValue") then
            if child then
                if child:GetAttribute("use") == 1 then
                    child:SetAttribute("use", 0);
                else
                    Debris:AddItem(child, 0);
                end;
            end;
        end;
    end;
end;

function u1.GetPlrName(u13) -- Line: 199
    -- upvalues: u2 (ref), u1 (copy), InsMgr (copy), u3 (ref), Players (copy), Log (copy)
    if not u13 then
        return "???";
    end;

    if not u2 then
        u1.Init();
    end;

    local v14 = InsMgr.GetIns("玩家名字缓存", "Folder", u3);
    local v15 = v14:FindFirstChild((tostring(u13)));

    if v15 and v15:IsA("StringValue") then
        if v15 then
            v15:SetAttribute("use", 1);
        end;

        return v15.Value;
    end;

    local u16 = "";
    local success, result = pcall(function() -- Line: 135
        -- upvalues: u16 (ref), Players (ref), u13 (copy)
        u16 = Players:GetNameFromUserIdAsync(u13);
    end);
    local v17;

    if success then
        v17 = u16 == "" and "???" or u16;
    else
        Log.warn("DataCache._fetchPlrNameFromApi failed", u13, result);
        v17 = "???";
    end;

    if v17 ~= "???" then
        local v18 = InsMgr.GetIns(tostring(u13), "StringValue", v14);
        v18.Value = v17;
        local v19 = v18;

        if not v19 then
            return v17;
        end;

        v19:SetAttribute("use", 1);
    end;

    return v17;
end;

function u1.GetPortrait(u20) -- Line: 227
    -- upvalues: u2 (ref), u1 (copy), InsMgr (copy), u3 (ref), Players (copy), Log (copy)
    if not u20 then
        return "";
    end;

    if not u2 then
        u1.Init();
    end;

    local v21 = InsMgr.GetIns("玩家头像缓存", "Folder", u3);
    local v22 = v21:FindFirstChild((tostring(u20)));

    if v22 and v22:IsA("StringValue") then
        if v22 then
            v22:SetAttribute("use", 1);
        end;

        u1.UpdatePortrait(u20);

        return v22.Value;
    end;

    local u23 = "";
    local success, result = pcall(function() -- Line: 159
        -- upvalues: Players (ref), u20 (copy), u23 (ref)
        u23 = Players:GetUserThumbnailAsync(u20, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60) or "";
    end);

    if not success then
        Log.warn("DataCache._fetchPortraitFromApi failed", u20, result);
    end;

    local v24 = u23;

    if v24 ~= "" then
        local v25 = InsMgr.GetIns(tostring(u20), "StringValue", v21);
        v25.Value = v24;
        v25:SetAttribute("T", os.time());
        local v26 = v25;

        if not v26 then
            return v24;
        end;

        v26:SetAttribute("use", 1);
    end;

    return v24;
end;

function u1.UpdatePortrait(u27) -- Line: 257
    -- upvalues: u2 (ref), u1 (copy), InsMgr (copy), u3 (ref), Players (copy), Log (copy)
    if not u27 then
        return;
    end;

    if not u2 then
        u1.Init();
    end;

    local u28 = InsMgr.GetIns("玩家头像缓存", "Folder", u3);
    local v29 = u28:FindFirstChild((tostring(u27)));

    if not (v29 and v29:IsA("StringValue")) then
        return;
    end;

    local v30 = v29:GetAttribute("T");

    if not v30 then
        v29:SetAttribute("T", os.time());

        return;
    end;

    if os.time() - v30 <= 3600 then
        return;
    end;

    task.spawn(function() -- Line: 279
        -- upvalues: u27 (copy), Players (ref), Log (ref), u28 (copy)
        local u31 = u27;
        local u32 = "";
        local success, result = pcall(function() -- Line: 159
            -- upvalues: Players (ref), u31 (copy), u32 (ref)
            u32 = Players:GetUserThumbnailAsync(u31, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60) or "";
        end);

        if not success then
            Log.warn("DataCache._fetchPortraitFromApi failed", u31, result);
        end;

        local v33 = u32;

        if v33 == "" then
            return;
        end;

        local v34 = u28:FindFirstChild((tostring(u27)));

        if v34 and v34:IsA("StringValue") then
            v34.Value = v33;
            v34:SetAttribute("T", os.time());

            if not v34 then
                return;
            end;

            v34:SetAttribute("use", 1);
        end;
    end);
end;

function u1.ClearCache() -- Line: 299
    -- upvalues: u2 (ref), u1 (copy), InsMgr (copy), u3 (ref), _sweepFolder (copy), u4 (ref)
    if not u2 then
        u1.Init();
    end;

    if not u2 then
        u1.Init();
    end;

    _sweepFolder((InsMgr.GetIns("玩家头像缓存", "Folder", u3)));

    if u4 then
        if not u2 then
            u1.Init();
        end;

        _sweepFolder((InsMgr.GetIns("玩家名字缓存", "Folder", u3)));
    end;
end;

function u1.Init() -- Line: 320
    -- upvalues: u2 (ref), RunService (copy), u3 (ref), ServerStorage (copy), u4 (ref), UpdateModule (copy), SEC_300 (copy), u1 (copy), ReplicatedStorage (copy)
    if u2 then
        return;
    end;

    u2 = true;

    if not RunService:IsServer() then
        u3 = ReplicatedStorage;
        u4 = false;

        return;
    end;

    u3 = ServerStorage;
    u4 = true;
    UpdateModule.Register(SEC_300, function(p35) -- Line: 330
        -- upvalues: u1 (ref)
        u1.ClearCache();
    end, {
        spawn = true,
        initialElapsed = 200
    });
end;

return u1;