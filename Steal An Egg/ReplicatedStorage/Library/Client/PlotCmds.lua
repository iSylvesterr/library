-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Network = require(ReplicatedStorage.Library.Client.Network);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Plots = require(ReplicatedStorage.Library.Types.Plots);
local PromptPurchase = require(ReplicatedStorage.Library.Shared.Functions.PromptPurchase);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local Streamable = require(ReplicatedStorage.Library.Modules.Packages.Streamable).Streamable;
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Plots2 = Constants.NETWORK_MAP.Plots;
local u2 = nil;
local u3 = {};
local u4 = nil;
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {
    OnLocalPlotUpdated = Signal.new(),
    OnAnyPlotUpdated = Signal.new(),
    OnPlotsFolderUpdated = Signal.new()
};
local v9 = Streamable.new(Workspace, "Plots");

local function firePlotUpdated(p10) -- Line: 58
    -- upvalues: u8 (copy), u3 (copy), u4 (ref)
    u8.OnAnyPlotUpdated:Fire(p10, u3[p10]);

    if u4 == p10 then
        u8.OnLocalPlotUpdated:Fire(p10);
    end;
end;

local function clearSlotTracker(p11) -- Line: 66
    -- upvalues: u5 (copy), u6 (copy)
    local v12 = u5[p11];

    if not v12 then
        return;
    end;

    u6[p11] = nil;
    u5[p11] = nil;
    v12.trove:Destroy();
end;

local function clearAllSlotTrackers() -- Line: 77
    -- upvalues: u5 (copy), u6 (copy)
    local v13 = {};

    for i in pairs(u5) do
        table.insert(v13, i);
    end;

    for _, v in ipairs(v13) do
        local v14 = u5[v];

        if v14 then
            u6[v] = nil;
            u5[v] = nil;
            v14.trove:Destroy();
        end;
    end;
end;

local function observePlotSlot(u15, p16) -- Line: 88
    -- upvalues: u5 (copy), Trove (copy), Streamable (copy), u8 (copy), u3 (copy), u4 (ref), Asserts (copy), u6 (copy)
    if u5[u15] then
        return;
    end;

    local v17 = Trove.new();
    local u18 = Streamable.new(p16, (tostring(u15)));
    local u19 = {
        trove = v17,
        plotStreamable = u18
    };
    u5[u15] = u19;
    v17:Add(function() -- Line: 102
        -- upvalues: u18 (copy)
        u18:Destroy();
    end);
    v17:Add(function() -- Line: 105
        -- upvalues: u5 (ref), u15 (copy), u19 (copy)
        if u5[u15] == u19 then
            u5[u15] = nil;
        end;
    end);
    v17:Add(u18:Observe(function(p20, p21) -- Line: 111
        -- upvalues: u15 (copy), u8 (ref), u3 (ref), u4 (ref), Streamable (ref), Asserts (ref), u6 (ref), u5 (ref), u19 (copy)
        if not (p20:IsA("Folder") or p20:IsA("Model")) then
            return;
        end;

        local v22 = u15;
        u8.OnAnyPlotUpdated:Fire(v22, u3[v22]);

        if u4 == v22 then
            u8.OnLocalPlotUpdated:Fire(v22);
        end;

        p21:Add(function() -- Line: 118
            -- upvalues: u15 (ref), u8 (ref), u3 (ref), u4 (ref)
            local v23 = u15;
            u8.OnAnyPlotUpdated:Fire(v23, u3[v23]);

            if u4 == v23 then
                u8.OnLocalPlotUpdated:Fire(v23);
            end;
        end);
        local u24 = Streamable.new(p20, "CenterPoint");
        p21:Add(function() -- Line: 123
            -- upvalues: u24 (copy)
            u24:Destroy();
        end);
        u24:Observe(function(p25, p26) -- Line: 126
            -- upvalues: Asserts (ref), u15 (ref), u8 (ref), u3 (ref), u4 (ref)
            Asserts.BasePart(p25);
            local v27 = u15;
            u8.OnAnyPlotUpdated:Fire(v27, u3[v27]);

            if u4 == v27 then
                u8.OnLocalPlotUpdated:Fire(v27);
            end;

            p26:Add(function() -- Line: 130
                -- upvalues: u15 (ref), u8 (ref), u3 (ref), u4 (ref)
                local v28 = u15;
                u8.OnAnyPlotUpdated:Fire(v28, u3[v28]);

                if u4 == v28 then
                    u8.OnLocalPlotUpdated:Fire(v28);
                end;
            end);
        end);
        local u29 = Streamable.new(p20, "SpawnPoint");
        p21:Add(function() -- Line: 136
            -- upvalues: u29 (copy)
            u29:Destroy();
        end);
        u29:Observe(function(p30, p31) -- Line: 139
            -- upvalues: Asserts (ref), u6 (ref), u15 (ref), u8 (ref), u3 (ref), u4 (ref), u5 (ref), u19 (ref)
            Asserts.BasePart(p30);
            u6[u15] = p30.CFrame + Vector3.new(0, 0, 0);
            local v32 = u15;
            u8.OnAnyPlotUpdated:Fire(v32, u3[v32]);

            if u4 == v32 then
                u8.OnLocalPlotUpdated:Fire(v32);
            end;

            p31:Add(function() -- Line: 144
                -- upvalues: u5 (ref), u15 (ref), u19 (ref), u8 (ref), u3 (ref), u4 (ref)
                if u5[u15] == u19 then
                    local v33 = u15;
                    u8.OnAnyPlotUpdated:Fire(v33, u3[v33]);

                    if u4 == v33 then
                        u8.OnLocalPlotUpdated:Fire(v33);
                    end;
                end;
            end);
        end);
        local u34 = Streamable.new(p20, "ToUpdate");
        p21:Add(function() -- Line: 152
            -- upvalues: u34 (copy)
            u34:Destroy();
        end);
        u34:Observe(function(p35, p36) -- Line: 155
            -- upvalues: u15 (ref), u8 (ref), u3 (ref), u4 (ref), Streamable (ref), Asserts (ref)
            if not p35:IsA("Model") then
                return;
            end;

            local v37 = u15;
            u8.OnAnyPlotUpdated:Fire(v37, u3[v37]);

            if u4 == v37 then
                u8.OnLocalPlotUpdated:Fire(v37);
            end;

            p36:Add(function() -- Line: 161
                -- upvalues: u15 (ref), u8 (ref), u3 (ref), u4 (ref)
                local v38 = u15;
                u8.OnAnyPlotUpdated:Fire(v38, u3[v38]);

                if u4 == v38 then
                    u8.OnLocalPlotUpdated:Fire(v38);
                end;
            end);
            local u39 = Streamable.new(p35, "PetArea");
            p36:Add(function() -- Line: 166
                -- upvalues: u39 (copy)
                u39:Destroy();
            end);
            u39:Observe(function(p40, p41) -- Line: 170
                -- upvalues: Asserts (ref), u15 (ref), u8 (ref), u3 (ref), u4 (ref)
                Asserts.BasePart(p40);
                local v42 = u15;
                u8.OnAnyPlotUpdated:Fire(v42, u3[v42]);

                if u4 == v42 then
                    u8.OnLocalPlotUpdated:Fire(v42);
                end;

                p41:Add(function() -- Line: 173
                    -- upvalues: u15 (ref), u8 (ref), u3 (ref), u4 (ref)
                    local v43 = u15;
                    u8.OnAnyPlotUpdated:Fire(v43, u3[v43]);

                    if u4 == v43 then
                        u8.OnLocalPlotUpdated:Fire(v43);
                    end;
                end);
            end);
        end);
        local u44 = Streamable.new(p20, "PlotSign");
        p21:Add(function() -- Line: 180
            -- upvalues: u44 (copy)
            u44:Destroy();
        end);
        u44:Observe(function(p45, p46) -- Line: 183
            -- upvalues: u15 (ref), u8 (ref), u3 (ref), u4 (ref), Streamable (ref), Asserts (ref)
            local v47 = u15;
            u8.OnAnyPlotUpdated:Fire(v47, u3[v47]);

            if u4 == v47 then
                u8.OnLocalPlotUpdated:Fire(v47);
            end;

            p46:Add(function() -- Line: 186
                -- upvalues: u15 (ref), u8 (ref), u3 (ref), u4 (ref)
                local v48 = u15;
                u8.OnAnyPlotUpdated:Fire(v48, u3[v48]);

                if u4 == v48 then
                    u8.OnLocalPlotUpdated:Fire(v48);
                end;
            end);
            local u49 = Streamable.new(p45, "Attachment");
            p46:Add(function() -- Line: 191
                -- upvalues: u49 (copy)
                u49:Destroy();
            end);
            u49:Observe(function(p50, p51) -- Line: 194
                -- upvalues: Asserts (ref), u15 (ref), u8 (ref), u3 (ref), u4 (ref), Streamable (ref)
                Asserts.Attachment(p50);
                local v52 = u15;
                u8.OnAnyPlotUpdated:Fire(v52, u3[v52]);

                if u4 == v52 then
                    u8.OnLocalPlotUpdated:Fire(v52);
                end;

                p51:Add(function() -- Line: 198
                    -- upvalues: u15 (ref), u8 (ref), u3 (ref), u4 (ref)
                    local v53 = u15;
                    u8.OnAnyPlotUpdated:Fire(v53, u3[v53]);

                    if u4 == v53 then
                        u8.OnLocalPlotUpdated:Fire(v53);
                    end;
                end);
                local u54 = Streamable.new(p50, "YourBase");
                p51:Add(function() -- Line: 203
                    -- upvalues: u54 (copy)
                    u54:Destroy();
                end);
                u54:Observe(function(p55, p56) -- Line: 206
                    -- upvalues: Asserts (ref), u15 (ref), u8 (ref), u3 (ref), u4 (ref)
                    Asserts.BillboardGui(p55);
                    local v57 = u15;
                    u8.OnAnyPlotUpdated:Fire(v57, u3[v57]);

                    if u4 == v57 then
                        u8.OnLocalPlotUpdated:Fire(v57);
                    end;

                    p56:Add(function() -- Line: 210
                        -- upvalues: u15 (ref), u8 (ref), u3 (ref), u4 (ref)
                        local v58 = u15;
                        u8.OnAnyPlotUpdated:Fire(v58, u3[v58]);

                        if u4 == v58 then
                            u8.OnLocalPlotUpdated:Fire(v58);
                        end;
                    end);
                end);
            end);
        end);
        local u59 = Streamable.new(p20, "BaseUpgrade");
        p21:Add(function() -- Line: 218
            -- upvalues: u59 (copy)
            u59:Destroy();
        end);
        u59:Observe(function(p60, p61) -- Line: 221
            -- upvalues: u15 (ref), u8 (ref), u3 (ref), u4 (ref), Streamable (ref)
            local v62 = u15;
            u8.OnAnyPlotUpdated:Fire(v62, u3[v62]);

            if u4 == v62 then
                u8.OnLocalPlotUpdated:Fire(v62);
            end;

            p61:Add(function() -- Line: 224
                -- upvalues: u15 (ref), u8 (ref), u3 (ref), u4 (ref)
                local v63 = u15;
                u8.OnAnyPlotUpdated:Fire(v63, u3[v63]);

                if u4 == v63 then
                    u8.OnLocalPlotUpdated:Fire(v63);
                end;
            end);
            local u64 = Streamable.new(p60, "Sign");
            p61:Add(function() -- Line: 229
                -- upvalues: u64 (copy)
                u64:Destroy();
            end);
            u64:Observe(function(p65, p66) -- Line: 232
                -- upvalues: u15 (ref), u8 (ref), u3 (ref), u4 (ref)
                local v67 = u15;
                u8.OnAnyPlotUpdated:Fire(v67, u3[v67]);

                if u4 == v67 then
                    u8.OnLocalPlotUpdated:Fire(v67);
                end;

                p66:Add(function() -- Line: 235
                    -- upvalues: u15 (ref), u8 (ref), u3 (ref), u4 (ref)
                    local v68 = u15;
                    u8.OnAnyPlotUpdated:Fire(v68, u3[v68]);

                    if u4 == v68 then
                        u8.OnLocalPlotUpdated:Fire(v68);
                    end;
                end);
            end);
        end);
    end));
end;

local function ensurePlotTracker(p69) -- Line: 243
    -- upvalues: u2 (ref), observePlotSlot (copy)
    local v70 = u2;

    if not v70 then
        return;
    end;

    observePlotSlot(p69, v70);
end;

local function getPlotBoundsContainer(p71) -- Line: 252
    return p71;
end;

function u8.GetState() -- Line: 260
    -- upvalues: u3 (copy)
    return table.clone(u3);
end;

function u8.GetSlotOwner(p72) -- Line: 264
    -- upvalues: u3 (copy)
    return u3[p72];
end;

function u8.GetMySlot() -- Line: 268
    -- upvalues: u4 (ref)
    return u4;
end;

function u8.GetPlotsFolder() -- Line: 272
    -- upvalues: u2 (ref)
    return u2;
end;

function u8.GetPlotData(p73) -- Line: 276
    -- upvalues: Players (copy), Asserts (copy), u4 (ref), u3 (copy), u2 (ref), u6 (copy)
    local v74 = p73 or Players.LocalPlayer;
    Asserts.Player(v74);
    local v75;

    if v74 == Players.LocalPlayer then
        v75 = u4;
    else
        v75 = nil;
    end;

    if not v75 then
        for i, v in pairs(u3) do
            if v == v74.UserId then
                v75 = i;
                break;
            end;
        end;
    end;

    if not v75 then
        return nil;
    end;

    local v76 = u2;

    if not v76 then
        return nil;
    end;

    local v77 = v76:FindFirstChild((tostring(v75)));

    if not v77 then
        return nil;
    end;

    local ToUpdate = v77:FindFirstChild("ToUpdate");

    if not (ToUpdate and ToUpdate:IsA("Model")) then
        return nil;
    end;

    local PetArea = ToUpdate:FindFirstChild("PetArea");

    if not (PetArea and PetArea:IsA("BasePart")) then
        return nil;
    end;

    local CenterPoint = v77:FindFirstChild("CenterPoint");

    if not (CenterPoint and CenterPoint:IsA("BasePart")) then
        return nil;
    end;

    local SpawnPoint = v77:FindFirstChild("SpawnPoint");

    if SpawnPoint and SpawnPoint:IsA("BasePart") then
        u6[v75] = SpawnPoint.CFrame + Vector3.new(0, 0, 0);
    end;

    return {
        Slot = v75,
        PlotFolder = v77,
        PetArea = PetArea,
        CenterPoint = CenterPoint,
        RespawnPointCFrame = u6[v75]
    };
end;

function u8.GetLocalYourBaseBillboard() -- Line: 332
    -- upvalues: u8 (copy)
    local v78 = u8.GetPlotData();

    if v78 == nil then
        return nil;
    end;

    local PlotSign = v78.PlotFolder:FindFirstChild("PlotSign");

    if PlotSign == nil then
        return nil;
    end;

    local Attachment = PlotSign:FindFirstChild("Attachment");

    if not (Attachment and Attachment:IsA("Attachment")) then
        return nil;
    end;

    local YourBase = Attachment:FindFirstChild("YourBase");

    if YourBase and YourBase:IsA("BillboardGui") then
        return YourBase;
    end;

    return nil;
end;

function u8.IsWorldPositionWithinLocalPlotBounds(p79) -- Line: 356
    -- upvalues: Asserts (copy), u8 (copy)
    Asserts.Vector3(p79);
    local v80 = u8.GetPlotData();

    if not v80 then
        return false;
    end;

    local v81, v82 = v80.PlotFolder:GetBoundingBox();
    local v83 = v81:PointToObjectSpace(p79);
    local v84 = v82 * 0.5;
    local v85;

    if math.abs(v83.X) <= v84.X then
        v85 = math.abs(v83.Z) <= v84.Z;
    else
        v85 = false;
    end;

    return v85;
end;

function u8.GetRespawnPointCFrame(p86) -- Line: 372
    -- upvalues: Players (copy), Asserts (copy), u4 (ref), u3 (copy), u6 (copy)
    local v87 = p86 or Players.LocalPlayer;
    Asserts.Player(v87);
    local v88;

    if v87 == Players.LocalPlayer then
        v88 = u4;
    else
        v88 = nil;
    end;

    if not v88 then
        for i, v in pairs(u3) do
            if v == v87.UserId then
                v88 = i;
                break;
            end;
        end;
    end;

    if v88 then
        return u6[v88];
    end;

    return nil;
end;

local function update(p89, p90) -- Line: 397
    -- upvalues: u4 (ref), u3 (copy), u8 (copy), Players (copy)
    local v91 = u4;
    u3[p89] = p90;
    u8.OnAnyPlotUpdated:Fire(p89, p90);

    if p90 ~= Players.LocalPlayer.UserId then
        if v91 == p89 and p90 ~= Players.LocalPlayer.UserId then
            u4 = nil;
            u8.OnLocalPlotUpdated:Fire(p89);
        end;

        return;
    end;

    u4 = p89;
    u8.OnLocalPlotUpdated:Fire(p89);
end;

local function applyStateUpdate(p92) -- Line: 411
    -- upvalues: u7 (copy), update (copy)
    local v93 = u7[p92.Slot];

    if v93 ~= nil and p92.Revision <= v93 then
        return;
    end;

    u7[p92.Slot] = p92.Revision;
    update(p92.Slot, p92.UserId);
end;

local function applyStateSnapshot(p94) -- Line: 431
    -- upvalues: u7 (copy), update (copy), u3 (copy)
    local v95 = {};

    for i, v in pairs(p94.OwnersBySlot) do
        local v96 = tonumber(i);
        local v97 = `Invalid plot snapshot slot key: {i}`;
        local v98 = assert(v96, v97);
        v95[v98] = true;
        local v99 = u7[v98];

        if v99 == nil or v99 < p94.Revision then
            u7[v98] = p94.Revision;
            update(v98, v);
        end;
    end;

    local v100 = {};

    for i in pairs(u7) do
        table.insert(v100, i);
    end;

    for _, v in ipairs(v100) do
        if v95[v] ~= true and u7[v] < p94.Revision then
            u7[v] = p94.Revision;

            if u3[v] ~= nil then
                update(v, nil);
            end;
        end;
    end;
end;

local function requestStateResync() -- Line: 457
    -- upvalues: Network (copy), Plots2 (copy), Plots (copy), applyStateSnapshot (copy)
    local success, result = pcall(function() -- Line: 458
        -- upvalues: Network (ref), Plots2 (ref)
        return Network.Invoke(Plots2.REQUEST_STATE);
    end);

    if not success then
        return false, tostring(result);
    end;

    local v101, v102 = Plots.SchemaValidation.PlotStateSnapshot(result);

    if not v101 then
        return false, `Invalid plot state snapshot: {v102}`;
    end;

    applyStateSnapshot(result);

    return true, nil;
end;

local function requestStateUntilReady() -- Line: 474
    -- upvalues: requestStateResync (copy), u1 (copy), requestStateUntilReady (copy)
    local v103, v104 = requestStateResync();

    if v103 then
        return;
    end;

    u1:AtError():Log((`Failed to load plot state; retrying: {v104}`));
    task.delay(5, requestStateUntilReady);
end;

Network.Fired(Plots2.STATE_UPDATE_EVENT):Connect(function(p105) -- Line: 421, Name: handleStateUpdated
    -- upvalues: Plots (copy), u1 (copy), u7 (copy), update (copy)
    local v106, v107 = Plots.SchemaValidation.PlotStateUpdate(p105);

    if not v106 then
        u1:AtError():Log((`Ignored invalid plot state update: {v107}`));

        return;
    end;

    local v108 = u7[p105.Slot];

    if v108 ~= nil and p105.Revision <= v108 then
        return;
    end;

    u7[p105.Slot] = p105.Revision;
    update(p105.Slot, p105.UserId);
end);
v9:Observe(function(u109, p110) -- Line: 490
    -- upvalues: Asserts (copy), u2 (ref), u8 (copy), clearAllSlotTrackers (copy), observePlotSlot (copy), u5 (copy), u6 (copy)
    Asserts.Folder(u109);
    u2 = u109;
    u8.OnPlotsFolderUpdated:Fire(u109);
    p110:Add(function() -- Line: 495
        -- upvalues: u2 (ref), u109 (copy), clearAllSlotTrackers (ref), u8 (ref)
        if u2 == u109 then
            u2 = nil;
        end;

        clearAllSlotTrackers();
        u8.OnPlotsFolderUpdated:Fire(nil);
    end);

    for _, child in ipairs(u109:GetChildren()) do
        local v111 = tonumber(child.Name);

        if v111 then
            local v112 = u2;

            if v112 then
                observePlotSlot(v111, v112);
            end;
        end;
    end;

    p110:Connect(u109.ChildAdded, function(p113) -- Line: 511
        -- upvalues: u2 (ref), observePlotSlot (ref), u8 (ref), u109 (copy)
        local v114 = tonumber(p113.Name);
        local v115 = v114 and u2;

        if v115 then
            observePlotSlot(v114, v115);
        end;

        u8.OnPlotsFolderUpdated:Fire(u109);
    end);
    p110:Connect(u109.ChildRemoved, function(p116) -- Line: 520
        -- upvalues: u5 (ref), u6 (ref), u8 (ref), u109 (copy)
        local v117 = tonumber(p116.Name);
        local v118 = v117 and u5[v117];

        if v118 then
            u6[v117] = nil;
            u5[v117] = nil;
            v118.trove:Destroy();
        end;

        u8.OnPlotsFolderUpdated:Fire(u109);
    end);
end);
task.spawn(requestStateUntilReady);
Network.Fired(Plots2.REQUEST_PROXIMITY_PURCHASE):Connect(function(p119) -- Line: 393, Name: requestProximityPurchase
    -- upvalues: PromptPurchase (copy)
    PromptPurchase.Prompt(p119, true);
end);

return u8;