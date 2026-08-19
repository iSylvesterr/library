-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Network = require(ReplicatedStorage.Library.Client.Network);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local TreadmillMediaCommentsConfig = require(ReplicatedStorage.Library.Modules.TreadmillMediaCommentsConfig);
local Schema = require(ReplicatedStorage.Library.Types.TreadmillMediaComments).Schema;
require(script.Types.Interface);
local Treadmills = Constants.NETWORK_MAP.Treadmills;
local u1 = Log.new();
local u2 = {};
local u3 = {};
local u4 = false;
local u5 = false;
local u6 = {};
local u7 = {
    CommentCountChanged = Signal.new()
};

local function getInvokeError(p8) -- Line: 46
    return typeof(p8) ~= "string" and "RequestFailed" or p8;
end;

local function setCachedCommentCount(p9, p10) -- Line: 54
    -- upvalues: u2 (copy), u7 (copy)
    local v11 = math.floor(p10);
    local v12 = math.max(0, v11);
    local v13 = u2[p9];

    if v13 ~= nil then
        v12 = math.max(v13, v12);
    end;

    if v13 == v12 then
        return;
    end;

    u2[p9] = v12;
    u7.CommentCountChanged:Fire(p9, v12);
end;

local function refreshCommentCountCache() -- Line: 68
    -- upvalues: u3 (copy), u6 (copy), u7 (copy), u2 (copy)
    for _, v in u3 do
        local v14 = {};

        for _, v2 in v do
            v14[v2] = u6[v2] or 0;
        end;

        local v15 = u7.RequestCommentCounts(v);

        if not v15.Ok then
            return "failed";
        end;

        if not v15.Loaded then
            return "unloaded";
        end;

        for i, v2 in v15.CountsByMediaKey do
            if (u6[i] or 0) == v14[i] then
                local v16 = math.floor(v2);
                local v17 = math.max(0, v16);
                local v18 = u2[i];

                if v18 ~= nil then
                    v17 = math.max(v18, v17);
                end;

                if v18 ~= v17 then
                    u2[i] = v17;
                    u7.CommentCountChanged:Fire(i, v17);
                end;
            end;
        end;
    end;

    return "loaded";
end;

local function startCommentCountRefreshLoop() -- Line: 93
    -- upvalues: u5 (ref), refreshCommentCountCache (copy), u4 (ref)
    task.spawn(function() -- Line: 94
        -- upvalues: u5 (ref), refreshCommentCountCache (ref), u4 (ref)
        while u5 do
            if refreshCommentCountCache() == "loaded" then
                u4 = true;
            end;

            local v19;

            if u4 then
                v19 = 180;
            else
                v19 = 2;
            end;

            task.wait(v19);
        end;
    end);
end;

function u7.StartCommentCountCache(p20) -- Line: 112
    -- upvalues: Asserts (copy), u5 (ref), TreadmillMediaCommentsConfig (copy), u3 (copy), refreshCommentCountCache (copy), u4 (ref)
    Asserts.table(p20);

    if u5 then
        return;
    end;

    u5 = true;
    local v21 = {};
    local v22 = {};

    for _, v in p20 do
        Asserts.string(v);

        if not v21[v] then
            v21[v] = true;
            table.insert(v22, v);

            if #v22 >= TreadmillMediaCommentsConfig.COMMENT_COUNT_KEYS_PER_REQUEST then
                table.insert(u3, v22);
                v22 = {};
            end;
        end;
    end;

    if #v22 > 0 then
        table.insert(u3, v22);
    end;

    task.spawn(function() -- Line: 94
        -- upvalues: u5 (ref), refreshCommentCountCache (ref), u4 (ref)
        while u5 do
            if refreshCommentCountCache() == "loaded" then
                u4 = true;
            end;

            local v23;

            if u4 then
                v23 = 180;
            else
                v23 = 2;
            end;

            task.wait(v23);
        end;
    end);
end;

function u7.GetCachedCommentCount(p24) -- Line: 142
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.string(p24);

    return u2[p24];
end;

function u7.ReconcileCommentCount(p25, p26) -- Line: 147
    -- upvalues: Asserts (copy), u6 (copy), u2 (copy), u7 (copy)
    Asserts.string(p25);
    Asserts.number(p26);
    u6[p25] = (u6[p25] or 0) + 1;
    local v27 = math.floor(p26);
    local v28 = math.max(0, v27);
    local v29 = u2[p25];

    if v29 ~= nil then
        v28 = math.max(v29, v28);
    end;

    if v29 == v28 then
        return;
    end;

    u2[p25] = v28;
    u7.CommentCountChanged:Fire(p25, v28);
end;

function u7.RequestCommentPage(u30, u31, u32) -- Line: 154
    -- upvalues: Asserts (copy), wcall (copy), Network (copy), Treadmills (copy), u1 (copy), Schema (copy)
    Asserts.string(u30);
    Asserts.optional.number(u31);
    Asserts.optional.number(u32);
    local v33, v34 = wcall(function() -- Line: 163
        -- upvalues: Network (ref), Treadmills (ref), u30 (copy), u31 (copy), u32 (copy)
        return Network.Invoke(Treadmills.REQUEST_COMMENT_PAGE, {
            MediaKey = u30,
            Cursor = u31,
            PageSize = u32
        });
    end);

    if not v33 then
        u1:AtWarning():Log((`Failed treadmill comment page request: {v34}`));

        return {
            Ok = false,
            Error = typeof(v34) ~= "string" and "RequestFailed" or v34
        };
    end;

    if Schema.CommentPageResult(v34) then
        return v34.Ok and {
            Ok = true,
            TotalCreatedCount = v34.TotalCreatedCount or 0,
            Comments = v34.Comments or {},
            NextCursor = v34.NextCursor
        } or {
            Ok = false,
            Error = v34.Error or "RequestFailed"
        };
    end;

    u1:AtWarning():Log("Rejected invalid treadmill comment page response");

    return {
        Ok = false,
        Error = "InvalidResponse"
    };
end;

function u7.RequestCommentCounts(u35) -- Line: 194
    -- upvalues: Asserts (copy), wcall (copy), Network (copy), Treadmills (copy), u1 (copy), Schema (copy)
    Asserts.table(u35);
    local v36, v37 = wcall(function() -- Line: 197
        -- upvalues: Network (ref), Treadmills (ref), u35 (copy)
        return Network.Invoke(Treadmills.REQUEST_COMMENT_COUNTS, {
            MediaKeys = u35
        });
    end);

    if not v36 then
        u1:AtWarning():Log((`Failed treadmill comment counts request: {v37}`));

        return {
            Ok = false,
            Loaded = false,
            Stale = true,
            CountsByMediaKey = {},
            Error = typeof(v37) ~= "string" and "RequestFailed" or v37
        };
    end;

    if Schema.CommentCountsResult(v37) then
        return v37.Ok and {
            Ok = true,
            CountsByMediaKey = v37.CountsByMediaKey or {},
            Loaded = v37.Loaded == true,
            Stale = v37.Stale == true
        } or {
            Ok = false,
            CountsByMediaKey = {},
            Loaded = v37.Loaded == true,
            Stale = v37.Stale ~= false,
            Error = v37.Error or "RequestFailed"
        };
    end;

    u1:AtWarning():Log("Rejected invalid treadmill comment counts response");

    return {
        Ok = false,
        Loaded = false,
        Stale = true,
        Error = "InvalidResponse",
        CountsByMediaKey = {}
    };
end;

function u7.PostComment(u38, u39, u40) -- Line: 244
    -- upvalues: Asserts (copy), wcall (copy), Network (copy), Treadmills (copy), u1 (copy), Schema (copy)
    Asserts.string(u38);
    Asserts.string(u39);
    Asserts.optional.number(u40);
    local v41, v42 = wcall(function() -- Line: 253
        -- upvalues: Network (ref), Treadmills (ref), u38 (copy), u39 (copy), u40 (copy)
        return Network.Invoke(Treadmills.REQUEST_POST_COMMENT, {
            MediaKey = u38,
            Message = u39,
            ImageAssetId = u40
        });
    end);

    if not v41 then
        u1:AtWarning():Log((`Failed treadmill post comment request: {v42}`));

        return {
            Ok = false,
            Error = typeof(v42) ~= "string" and "RequestFailed" or v42
        };
    end;

    if Schema.PostCommentResult(v42) then
        return v42.Ok and v42.Comment ~= nil and {
            Ok = true,
            Comment = v42.Comment,
            Pending = v42.Pending == true
        } or {
            Ok = false,
            Error = v42.Error or "RequestFailed"
        };
    end;

    u1:AtWarning():Log("Rejected invalid treadmill post comment response");

    return {
        Ok = false,
        Error = "InvalidResponse"
    };
end;

function u7.SetCommentLike(u43, u44, u45) -- Line: 283
    -- upvalues: Asserts (copy), wcall (copy), Network (copy), Treadmills (copy), u1 (copy), Schema (copy)
    Asserts.string(u43);
    Asserts.string(u44);
    Asserts.boolean(u45);
    local v46, v47 = wcall(function() -- Line: 292
        -- upvalues: Network (ref), Treadmills (ref), u43 (copy), u44 (copy), u45 (copy)
        return Network.Invoke(Treadmills.REQUEST_SET_COMMENT_LIKE, {
            MediaKey = u43,
            CommentId = u44,
            Liked = u45
        });
    end);

    if not v46 then
        u1:AtWarning():Log((`Failed treadmill comment like request: {v47}`));

        return {
            Ok = false,
            LikeCount = nil,
            Error = typeof(v47) ~= "string" and "RequestFailed" or v47,
            CommentId = u44
        };
    end;

    if Schema.SetCommentLikeResult(v47) then
        return v47.Ok and {
            Ok = true,
            CommentId = v47.CommentId or u44,
            Liked = v47.Liked == true,
            Delta = v47.Delta or 0,
            LikeCount = v47.LikeCount or 0
        } or {
            Ok = false,
            Error = v47.Error or "RequestFailed",
            CommentId = v47.CommentId or u44,
            LikeCount = v47.LikeCount
        };
    end;

    u1:AtWarning():Log("Rejected invalid treadmill comment like response");

    return {
        Ok = false,
        Error = "InvalidResponse",
        LikeCount = nil,
        CommentId = u44
    };
end;

return u7;