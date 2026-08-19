-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Assets = require(ReplicatedStorage.Directory.Assets);
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local AssetModels = ReplicatedStorage.AssetModels;
local u1 = {};
local u8 = {
    _getResolvedAssetModelsFolder = function() -- Line: 38, Name: _getResolvedAssetModelsFolder
        -- upvalues: AssetModels (copy)
        return AssetModels;
    end,

    _assertAssetModel = function(p2, p3) -- Line: 43, Name: _assertAssetModel
        local v4 = `Asset model "{p3}" was not found`;
        local v5 = assert(p2, v4);
        local v6 = v5:IsA("Model");
        local v7 = `Asset model "{p3}" is not a Model`;
        assert(v6, v7);

        return v5;
    end
};

function u8._getAvailableAssetModelTemplate(p9) -- Line: 50
    -- upvalues: u8 (copy)
    local v10 = u8._getResolvedAssetModelsFolder():FindFirstChild(p9);

    if v10 then
        return u8._assertAssetModel(v10, p9);
    end;

    return nil;
end;

function u8._waitForAssetModelTemplate(p11, p12) -- Line: 59
    -- upvalues: u8 (copy)
    local v13 = u8._getResolvedAssetModelsFolder():WaitForChild(p11, p12 or 30);

    return u8._assertAssetModel(v13, p11);
end;

function u8._validateAssetModel(p14, p15) -- Line: 66
    local PrimaryPart = p15.PrimaryPart;
    local v16 = `Asset model for {p14} does not have a PrimaryPart`;
    assert(PrimaryPart, v16);
    local CENTER = p15:FindFirstChild("CENTER");
    local v17 = `Asset model for {p14} does not have a CENTER part`;
    assert(CENTER, v17);
    local v18 = p15.ModelStreamingMode == Enum.ModelStreamingMode.Atomic;
    local v19 = `Asset model for {p14} must have Atomic ModelStreamingMode`;
    assert(v18, v19);
end;

function u8._buildVisibleBoundsData(p20) -- Line: 75
    -- upvalues: Asserts (copy), u8 (copy), BBFromModelVisibleOnly (copy)
    Asserts.string(p20);
    local v21 = u8.GetModelTemplate(p20);
    local v22 = `Asset model "{p20}" was not found`;
    local v23 = assert(v21, v22);
    local v24 = v23.PrimaryPart or v23:FindFirstChild("HumanoidRootPart");
    local v25;

    if v24 == nil then
        v25 = false;
    else
        v25 = v24:IsA("BasePart");
    end;

    local v26 = `Asset model "{p20}" is missing a root part`;
    assert(v25, v26);
    local v27, v28 = BBFromModelVisibleOnly(v23);
    local v29 = v27.Position - Vector3.new(0, v28.Y * 0.5, 0);
    local v30 = v24.CFrame.Rotation + v29;
    local v31 = v23:GetScale();
    local v32 = `Asset model "{p20}" has invalid template scale`;
    assert(v31 > 0, v32);

    return {
        RelativeCFrame = v30:ToObjectSpace(v27),
        Size = v28,
        TemplateScale = v31
    };
end;

function u8.GetAssetModelsFolder() -- Line: 100
    -- upvalues: u8 (copy)
    return u8._getResolvedAssetModelsFolder();
end;

function u8.GetModelTemplate(p33) -- Line: 104
    -- upvalues: Asserts (copy), Constants (copy), u8 (copy)
    Asserts.string(p33);

    if Constants.IS_CLIENT then
        return u8._waitForAssetModelTemplate(p33);
    end;

    return u8._getAvailableAssetModelTemplate(p33);
end;

function u8.GetAssetModelIfReplicated(p34) -- Line: 114
    -- upvalues: Asserts (copy), u8 (copy)
    Asserts.string(p34);

    return u8._getAvailableAssetModelTemplate(p34) or nil;
end;

function u8.WaitForAssetModel(p35, p36) -- Line: 125
    -- upvalues: Asserts (copy), u8 (copy)
    Asserts.string(p35);
    Asserts.optional.number(p36);

    return u8._waitForAssetModelTemplate(p35, p36);
end;

function u8.GetVisibleBoundsData(p37) -- Line: 132
    -- upvalues: Asserts (copy), u1 (copy), u8 (copy)
    Asserts.string(p37);
    local v38 = u1[p37];

    if v38 ~= nil then
        return v38;
    end;

    local v39 = u8._buildVisibleBoundsData(p37);
    u1[p37] = v39;

    return v39;
end;

function u8.HydrateAssetConfigModelScale(p40) -- Line: 145
    -- upvalues: Asserts (copy), Assets (copy), u8 (copy)
    Asserts.string(p40);
    local v41 = Assets.Directory[p40];

    if not v41 then
        return;
    end;

    local v42 = u8.GetAssetModelIfReplicated(p40);

    if v42 then
        v41.BaseModelScale = v42:GetScale();
    end;
end;

function u8.HydrateAvailableAssetConfigModelScales() -- Line: 159
    -- upvalues: Assets (copy), u8 (copy)
    for i in pairs(Assets.Directory) do
        u8.HydrateAssetConfigModelScale(i);
    end;
end;

if Constants.IS_SERVER then
    local function disablePartQueriesClocked(u43) -- Line: 170
        -- upvalues: RunService (copy)
        task.spawn(function() -- Line: 171
            -- upvalues: u43 (copy), RunService (ref)
            local v44 = { u43 };
            local v45 = os.clock() + 0.002;
            local v46 = 1;
            local v47 = 0;

            while v46 <= #v44 do
                local v48 = v44[v46];
                v44[v46] = nil;
                v46 = v46 + 1;

                if v48:IsA("BasePart") then
                    v48.CanQuery = false;
                    v48.CanTouch = false;
                end;

                local v49 = v48:GetChildren();

                for i = 1, #v49 do
                    v44[#v44 + 1] = v49[i];
                end;

                v47 = v47 + 1;

                if v47 >= 64 then
                    v47 = 0;

                    if v45 <= os.clock() then
                        RunService.Heartbeat:Wait();
                        v45 = os.clock() + 0.002;
                    end;
                end;
            end;
        end);
    end;

    local u50 = u8._getResolvedAssetModelsFolder();
    task.spawn(function() -- Line: 171
        -- upvalues: u50 (copy), RunService (copy)
        local v51 = { u50 };
        local v52 = os.clock() + 0.002;
        local v53 = 1;
        local v54 = 0;

        while v53 <= #v51 do
            local v55 = v51[v53];
            v51[v53] = nil;
            v53 = v53 + 1;

            if v55:IsA("BasePart") then
                v55.CanQuery = false;
                v55.CanTouch = false;
            end;

            local v56 = v55:GetChildren();

            for i = 1, #v56 do
                v51[#v51 + 1] = v56[i];
            end;

            v54 = v54 + 1;

            if v54 >= 64 then
                v54 = 0;

                if v52 <= os.clock() then
                    RunService.Heartbeat:Wait();
                    v52 = os.clock() + 0.002;
                end;
            end;
        end;
    end);
    u8.HydrateAvailableAssetConfigModelScales();
end;

return u8;