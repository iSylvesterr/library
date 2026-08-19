-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local GenerateUID = require(ReplicatedStorage.Library.Functions.GenerateUID);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local StreamDirectory = require(ReplicatedStorage.Library.Modules.StreamDirectory);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = Log.new({
    EnableStringRead = true
});
local u2 = {};

local function getElapsedMilliseconds(p3) -- Line: 55
    local v4 = (os.clock() - p3) * 1000;

    return math.floor(v4);
end;

function u2._assertModel(p5, p6, p7) -- Line: 59
    local v8 = `{p7} model "{p6}" was not found`;
    local v9 = assert(p5, v8);
    local v10 = v9:IsA("Model");
    local v11 = `{p7} model "{p6}" is not a Model`;
    assert(v10, v11);

    return v9;
end;

function u2._waitForDownloadContainer(p12, p13, p14) -- Line: 66
    -- upvalues: Players (copy), u1 (copy)
    local v15 = os.clock();
    local v16 = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild(p12.DownloadGUID, p13);
    local v17 = `{p14} download "{p12.DownloadGUID}" was not replicated`;
    assert(v16 ~= nil, v17);
    local v18 = v16:IsA("ScreenGui");
    local v19 = `{p14} download "{p12.DownloadGUID}" is not a ScreenGui`;
    assert(v18, v19);
    local v20 = u1:AtInfo();
    local v21 = `{p14} download "{p12.DownloadGUID}" container replicated`;
    local v22 = {};
    local v23 = (os.clock() - v15) * 1000;
    v22.ElapsedMs = math.floor(v23);
    v22.ExpectedDownloadSize = p12.DownloadSize;
    v20:Log(v21, v22);
    local v24 = os.clock();

    while #v16:GetDescendants() < p12.DownloadSize do
        local v25 = os.clock() - v24 <= p13;
        local v26 = `Timed out waiting for {p14} download "{p12.DownloadGUID}"`;
        assert(v25, v26);
        task.wait();
    end;

    local v27 = u1:AtInfo();
    local v28 = `{p14} download "{p12.DownloadGUID}" descendants replicated`;
    local v29 = {};
    local v30 = (os.clock() - v24) * 1000;
    v29.ElapsedMs = math.floor(v30);
    local v31 = (os.clock() - v15) * 1000;
    v29.TotalElapsedMs = math.floor(v31);
    v29.DownloadSize = p12.DownloadSize;
    v27:Log(v28, v29);

    return v16;
end;

function u2._collectExistingModels(p32, p33, p34) -- Line: 99
    -- upvalues: u2 (copy)
    local v35 = {};

    for _, v in ipairs(p33) do
        local v36 = p32:FindFirstChild(v);

        if v36 ~= nil then
            v35[v] = u2._assertModel(v36, v, p34);
        end;
    end;

    return v35;
end;

function u2._resolveStreamedModel(p37, p38, p39, p40) -- Line: 115
    -- upvalues: u2 (copy)
    local v41 = p40[p38];

    for _, child in ipairs(p37:GetChildren()) do
        if child.Name == p38 then
            local v42 = u2._assertModel(child, p38, p39);

            if v41 == nil then
                v41 = v42;
            elseif v42 ~= v41 then
                v42:Destroy();
            end;
        end;
    end;

    return v41;
end;

function u2.RequestModelDownload(u43) -- Line: 142
    -- upvalues: Asserts (copy), GenerateUID (copy), Trove (copy), u1 (copy), Network (copy)
    Asserts.table(u43);
    Asserts.string(u43.RequestRemote);
    Asserts.string(u43.ReadyRemote);
    Asserts.string(u43.FailedRemote);

    if u43.RequestedModelNames ~= nil then
        Asserts.array.string(u43.RequestedModelNames);
    end;

    Asserts.number(u43.DownloadWaitTimeoutSeconds);
    Asserts.string(u43.ModelLabel);
    Asserts.string(u43.FailureMessage);
    local u44 = GenerateUID();
    local v45 = Trove.new();
    local u46 = nil;
    local u47 = nil;
    local u48 = os.clock();
    u1:AtInfo():Log(`{u43.ModelLabel} download request "{u44}" started`, {
        RequestedCount = u43.RequestedModelNames ~= nil and #u43.RequestedModelNames or nil
    });
    v45:Connect(Network.Fired(u43.ReadyRemote), function(p49, p50, p51, p52) -- Line: 166
        -- upvalues: Asserts (ref), u44 (copy), u46 (ref), u1 (ref), u43 (copy), u48 (copy)
        Asserts.string(p49);

        if p49 ~= u44 then
            return;
        end;

        Asserts.string(p50);
        Asserts.number(p51);
        Asserts.array.string(p52);
        u46 = {
            DownloadGUID = p50,
            DownloadSize = p51,
            ModelNames = p52
        };
        local v53 = u1:AtInfo();
        local v54 = `{u43.ModelLabel} download request "{u44}" ready event received`;
        local v55 = {};
        local v56 = (os.clock() - u48) * 1000;
        v55.ElapsedMs = math.floor(v56);
        v55.DownloadGUID = p50;
        v55.DownloadSize = p51;
        v55.ModelCount = #p52;
        v53:Log(v54, v55);
    end);
    v45:Connect(Network.Fired(u43.FailedRemote), function(p57, p58) -- Line: 188
        -- upvalues: Asserts (ref), u44 (copy), u47 (ref), u1 (ref), u43 (copy), u48 (copy)
        Asserts.string(p57);

        if p57 ~= u44 then
            return;
        end;

        Asserts.string(p58);
        u47 = p58;
        local v59 = u1:AtWarning();
        local v60 = `{u43.ModelLabel} download request "{u44}" failed event received`;
        local v61 = {};
        local v62 = (os.clock() - u48) * 1000;
        v61.ElapsedMs = math.floor(v62);
        v61.Error = p58;
        v59:Log(v60, v61);
    end);
    local v63, v64, v65 = pcall(Network.Invoke, u43.RequestRemote, u44, u43.RequestedModelNames);

    if not v63 then
        v45:Destroy();
        error(tostring(v64), 2);
    end;

    if v64 == false then
        v45:Destroy();
        error(tostring(v65 or u43.FailureMessage), 2);
    end;

    assert(v64 == true, u43.FailureMessage);
    local v66 = u1:AtInfo();
    local v67 = `{u43.ModelLabel} download request "{u44}" accepted`;
    local v68 = {};
    local v69 = (os.clock() - u48) * 1000;
    v68.ElapsedMs = math.floor(v69);
    v66:Log(v67, v68);
    local v70 = os.clock();

    while u46 == nil and u47 == nil do
        if os.clock() - v70 > u43.DownloadWaitTimeoutSeconds then
            u47 = `Timed out waiting for {u43.ModelLabel} download "{u44}" readiness`;
            break;
        end;

        task.wait();
    end;

    v45:Destroy();
    assert(u46 ~= nil, u47 or u43.FailureMessage);
    local v71 = u1:AtInfo();
    local v72 = `{u43.ModelLabel} download request "{u44}" ready wait completed`;
    local v73 = {};
    local v74 = (os.clock() - v70) * 1000;
    v73.ElapsedMs = math.floor(v74);
    local v75 = (os.clock() - u48) * 1000;
    v73.TotalElapsedMs = math.floor(v75);
    v73.DownloadGUID = u46.DownloadGUID;
    v73.DownloadSize = u46.DownloadSize;
    v73.ModelCount = #u46.ModelNames;
    v71:Log(v72, v73);

    return u46;
end;

function u2.StreamDownloadedModels(u76) -- Line: 237
    -- upvalues: Asserts (copy), u2 (copy), u1 (copy), StreamDirectory (copy)
    Asserts.table(u76);
    Asserts.table(u76.DownloadInfo);
    Asserts.number(u76.DownloadWaitTimeoutSeconds);
    Asserts.string(u76.ModelLabel);
    Asserts.string(u76.FailureMessage);
    local DownloadInfo = u76.DownloadInfo;
    Asserts.string(DownloadInfo.DownloadGUID);
    Asserts.number(DownloadInfo.DownloadSize);
    Asserts.array.string(DownloadInfo.ModelNames);
    local v77 = os.clock();
    local v78 = u2._waitForDownloadContainer(DownloadInfo, u76.DownloadWaitTimeoutSeconds, u76.ModelLabel);
    local v79 = os.clock();
    local v80 = v78:Clone();
    v78:Destroy();
    local v81 = u1:AtInfo();
    local v82 = `{u76.ModelLabel} download "{DownloadInfo.DownloadGUID}" cloned locally`;
    local v83 = {};
    local v84 = (os.clock() - v79) * 1000;
    v83.ElapsedMs = math.floor(v84);
    local v85 = (os.clock() - v77) * 1000;
    v83.TotalElapsedMs = math.floor(v85);
    v81:Log(v82, v83);
    task.defer(function() -- Line: 263
        -- upvalues: u76 (copy), DownloadInfo (copy)
        u76.AcknowledgeDownload(DownloadInfo.DownloadGUID);
    end);
    local v86 = u2._collectExistingModels(u76.DestinationFolder, DownloadInfo.ModelNames, u76.ModelLabel);
    local v87 = os.clock();
    local v88 = StreamDirectory.StreamDirectory(v80, u76.DestinationFolder);

    while not v88.Complete do
        assert(not v88.Failed, v88.Error or u76.FailureMessage);
        task.wait();
    end;

    assert(not v88.Failed, v88.Error or u76.FailureMessage);
    local v89 = u1:AtInfo();
    local v90 = `{u76.ModelLabel} final stream "{DownloadInfo.DownloadGUID}" completed`;
    local v91 = {};
    local v92 = (os.clock() - v87) * 1000;
    v91.ElapsedMs = math.floor(v92);
    local v93 = (os.clock() - v77) * 1000;
    v91.TotalElapsedMs = math.floor(v93);
    v91.ModelCount = #DownloadInfo.ModelNames;
    v91.DownloadSize = DownloadInfo.DownloadSize;
    v89:Log(v90, v91);
    v80:Destroy();
    local v94 = {};

    for _, v in ipairs(DownloadInfo.ModelNames) do
        local v95 = u2._resolveStreamedModel(u76.DestinationFolder, v, u76.ModelLabel, v86);

        if v95 ~= nil then
            v94[v] = v95;
        end;
    end;

    return v94;
end;

function u2.CreateStreamGate() -- Line: 304
    -- upvalues: Signal (copy)
    return {
        Active = false,
        Released = Signal.new()
    };
end;

function u2.RunWithStreamGate(p96, p97) -- Line: 311
    while p96.Active do
        p96.Released:Wait();
    end;

    p96.Active = true;
    local success, result = pcall(p97);
    p96.Active = false;
    p96.Released:Fire();

    if not success then
        error(result, 2);
    end;

    return result;
end;

return u2;