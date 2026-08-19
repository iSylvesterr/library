-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local u2 = {};
local u3 = {};

local function StopTimer(p4, p5) -- Line: 42
    -- upvalues: Constants (copy), u2 (copy), u1 (copy)
    if Constants.IS_CLIENT then
        local v6 = u2[p4] or os.clock();

        if p5 then
            local v7 = u1:AtTrace();
            local v8 = (os.clock() - v6) * 1000;
            v7:Log((`{p5}: [Time Elapsed: {math.round(v8)} ms]`));
        end;

        u2[p4] = nil;
    end;
end;

local function GetTotalSize(p9) -- Line: 52
    local u10 = 0;

    local function countChildren(p11) -- Line: 54
        -- upvalues: u10 (ref), countChildren (copy)
        for _, child in pairs(p11:GetChildren()) do
            if child.ClassName ~= "PackageLink" and child.ClassName ~= "Status" then
                u10 = u10 + 1;
                countChildren(child);
            end;
        end;
    end;

    countChildren(p9);

    return u10;
end;

function u3.GetTotalSize(p12) -- Line: 67
    local u13 = 0;

    local function u15(p14) -- Line: 54
        -- upvalues: u13 (ref), u15 (copy)
        for _, child in pairs(p14:GetChildren()) do
            if child.ClassName ~= "PackageLink" and child.ClassName ~= "Status" then
                u13 = u13 + 1;
                u15(child);
            end;
        end;
    end;

    u15(p12);

    return u13;
end;

local function FailStream(p16, p17) -- Line: 71
    -- upvalues: u1 (copy)
    p16.Error = p17;
    p16.Failed = true;
    p16.Complete = true;
    u1:AtWarning():Log((`StreamDirectory failed: {p17}`));
end;

local function AssertStreamAlive(p18) -- Line: 78
    assert(not p18.Failed, p18.Error or "StreamDirectory failed");
end;

function u3.SaveTags(p19) -- Line: 86
    -- upvalues: CollectionService (copy), HttpService (copy)
    local v20 = CollectionService:GetTags(p19);
    p19:SetAttribute("_streamingTags", HttpService:JSONEncode(v20));

    for _, v in ipairs(v20) do
        CollectionService:RemoveTag(p19, v);
    end;
end;

function u3.SaveTagsDeep(p21) -- Line: 95
    -- upvalues: u3 (copy)
    for _, child in ipairs(p21:GetChildren()) do
        u3.SaveTags(child);
        u3.SaveTagsDeep(child);
    end;
end;

function u3.LoadTags(u22) -- Line: 102
    -- upvalues: HttpService (copy), CollectionService (copy)
    local v23 = 0;
    local success, result = pcall(function() -- Line: 104
        -- upvalues: HttpService (ref), u22 (copy)
        return HttpService:JSONDecode(u22:GetAttribute("_streamingTags") or "[]");
    end);

    if success then
        for _, v in ipairs(result) do
            v23 = v23 + 1;
            CollectionService:AddTag(u22, v);

            if v23 % 25 == 0 then
                task.wait();
            end;
        end;
    end;

    u22:SetAttribute("_streamingTags", nil);

    return v23;
end;

function u3.StreamDirectory(u24, u25) -- Line: 124
    -- upvalues: Constants (copy), u1 (copy), u2 (copy), wcall (copy), StopTimer (copy), u3 (copy)
    if u25:IsA("ScreenGui") and u25.ResetOnSpawn then
        u25.ResetOnSpawn = false;
        local v26 = `ResetOnSpawn is set to true for {u25.Name} (a screen gui). This can cause issues with streaming, causing the root to be destroyed, never let this to true!`;

        if Constants.IS_STUDIO then
            error(v26);
        else
            u1:AtWarning():Log(v26);
        end;
    end;

    if Constants.IS_CLIENT then
        u2.stream = os.clock();
        u1:AtTrace():Log("Streaming Started..");
    end;

    local u27 = {
        Percent = 0,
        Complete = false,
        Failed = false,
        Error = nil
    };
    task.spawn(function() -- Line: 149
        -- upvalues: wcall (ref), Constants (ref), u2 (ref), u1 (ref), u24 (copy), u27 (copy), u25 (copy), StopTimer (ref), u3 (ref)
        local v40, v41 = wcall(function() -- Line: 150
            -- upvalues: Constants (ref), u2 (ref), u1 (ref), u24 (ref), u27 (ref), u25 (ref), StopTimer (ref), u3 (ref)
            if Constants.IS_CLIENT then
                u2.build = os.clock();
                u1:AtTrace():Log("Building Hierarchy Data..");
            end;

            local v28 = { u24 };
            local v29 = {};

            while #v28 > 0 do
                local v30 = u27;
                assert(not v30.Failed, v30.Error or "StreamDirectory failed");
                local v31 = table.remove(v28);

                if not v31 then
                    break;
                end;

                local v32;

                if v31 == u24 then
                    v32 = u25;
                else
                    v32 = v31;
                end;

                for _, child in pairs(v31:GetChildren()) do
                    if child.ClassName ~= "PackageLink" and child.ClassName ~= "Status" then
                        local v33 = {
                            Instance = child,
                            Parent = v32
                        };
                        local v34;

                        if child:IsA("Model") then
                            v34 = child.PrimaryPart;
                        else
                            v34 = nil;
                        end;

                        v33.PrimaryPart = v34;
                        local v35;

                        if child:IsA("BillboardGui") then
                            v35 = child.Adornee;
                        else
                            v35 = nil;
                        end;

                        v33.Adornee = v35;
                        table.insert(v29, v33);
                        table.insert(v28, child);
                    end;
                end;

                if #v29 % Constants.STREAMING.STREAM_DIR_STACKING_WEIGHT_BUFFER == 0 then
                    task.wait();
                end;
            end;

            StopTimer("build", "Hierarchy Data Successfully Built!");
            local v36 = #v29;
            u27.TotalSize = v36;

            if Constants.IS_CLIENT then
                u2.instances = os.clock();
                u1:AtTrace():Log((`Streaming Instances.. (Instances: {v36})`));
            end;

            if v36 == 0 then
                u27.Percent = 1;
            end;

            for i, v in ipairs(v29) do
                local v37 = u27;
                assert(not v37.Failed, v37.Error or "StreamDirectory failed");
                v.Instance.Parent = v.Parent;
                u27.Percent = math.clamp(i / v36, 0, 1);

                if i % Constants.STREAMING.STREAM_DIR_REPLICATION_WEIGHT_BUFFER == 0 then
                    task.wait();
                end;
            end;

            StopTimer("instances", "Instances Successfully Streamed!");

            if Constants.IS_CLIENT then
                u2.references = os.clock();
                u1:AtTrace():Log("Rebuilding Instance References..");
            end;

            for _, v in ipairs(v29) do
                local v38 = u27;
                assert(not v38.Failed, v38.Error or "StreamDirectory failed");

                if v.Instance:IsA("Model") then
                    v.Instance.PrimaryPart = v.PrimaryPart;
                elseif v.Instance:IsA("BillboardGui") and v.Adornee ~= nil then
                    v.Instance.Adornee = v.Adornee;
                end;
            end;

            StopTimer("references", "Instance References Set!");

            if Constants.IS_CLIENT then
                for _, v in ipairs(v29) do
                    local v39 = u27;
                    assert(not v39.Failed, v39.Error or "StreamDirectory failed");
                    u3.LoadTags(v.Instance);
                end;
            end;

            StopTimer("tags", "Tags Successfully Added!");
            StopTimer("stream", "Streaming Complete!");
            u27.Complete = true;
        end);

        if not v40 then
            local v42 = u27;
            local v43 = tostring(v41);
            v42.Error = v43;
            v42.Failed = true;
            v42.Complete = true;
            u1:AtWarning():Log((`StreamDirectory failed: {v43}`));
        end;
    end);

    return u27;
end;

return u3;