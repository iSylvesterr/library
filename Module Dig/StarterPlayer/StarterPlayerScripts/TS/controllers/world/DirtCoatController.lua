-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local CollectionService = v1.CollectionService;
local Players = v1.Players;
local Workspace = v1.Workspace;
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "cleaning", "DirtTypes");
local dirtFor = v2.dirtFor;
local dirtForRarity = v2.dirtForRarity;
local Items = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items").Items;
local DirtBudget = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DirtBudget").DirtBudget;
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DirtCoat");
local DirtCoat = v3.DirtCoat;
local TOOL_DIRT = v3.TOOL_DIRT;
local DirtMask = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "DirtMask").DirtMask;
local u4 = setmetatable({}, {
    __tostring = function() -- Line: 32, Name: __tostring
        return "DirtCoatController";
    end
});
u4.__index = u4;

function u4.new(...) -- Line: 37
    -- upvalues: u4 (ref)
    local v5 = setmetatable({}, u4);

    return v5:constructor(...) or v5;
end;

function u4.constructor(p6, p7) -- Line: 41
    p6.data = p7;
    p6.coated = {};
    p6.pendingRemote = {};
    p6.remoteCoatClock = {};
    p6.retryQueued = false;
end;

function u4.onStart(u8) -- Line: 48
    -- upvalues: CollectionService (copy), Players (copy)
    CollectionService:GetInstanceAddedSignal("Dirt"):Connect(function(p9) -- Line: 49
        -- upvalues: u8 (copy)
        return u8:apply(p9);
    end);
    CollectionService:GetInstanceRemovedSignal("Dirt"):Connect(function(p10) -- Line: 52
        -- upvalues: u8 (copy)
        return u8:remove(p10);
    end);

    for _, v in Players:GetPlayers() do
        u8:watchPlayer(v);
    end;

    Players.PlayerAdded:Connect(function(p11) -- Line: 58
        -- upvalues: u8 (copy)
        return u8:watchPlayer(p11);
    end);
    Players.PlayerRemoving:Connect(function(p12) -- Line: 61
        -- upvalues: u8 (copy)
        local remoteCoatClock = u8.remoteCoatClock;
        local v13 = remoteCoatClock[p12] ~= nil;
        remoteCoatClock[p12] = nil;

        return v13;
    end);
    u8:preCoatNext();
end;

function u4.onDataChanged(p14, p15, p16) -- Line: 72
    if table.find(p15, "Inventory") == nil then
        return nil;
    end;

    for i, v in p14.coated do
        local v17 = p14:maskFor(i, p16);

        if v17 ~= v.appliedMask then
            v.appliedMask = v17;
            p14:stripToMask(i, v);
        end;
    end;
end;

function u4.watchPlayer(u18, u19) -- Line: 85
    local function v22(p20) -- Line: 86
        -- upvalues: u18 (copy), u19 (copy)
        for _, child in p20:GetChildren() do
            u18:onCharacterChild(u19, child);
        end;

        p20.ChildAdded:Connect(function(p21) -- Line: 90
            -- upvalues: u18 (ref), u19 (ref)
            return u18:onCharacterChild(u19, p21);
        end);
    end;

    if u19.Character then
        v22(u19.Character);
    end;

    u19.CharacterAdded:Connect(v22);
end;

function u4.onCharacterChild(p23, p24, p25) -- Line: 99
    -- upvalues: CollectionService (copy), Players (copy)
    if not p25:IsA("Tool") then
        return nil;
    end;

    if not CollectionService:HasTag(p25, "Dirt") then
        p23:stripCoat(p25);

        return nil;
    end;

    if p24 ~= Players.LocalPlayer then
        p23:scheduleRemoteCoat(p25);

        return nil;
    end;

    if p23.coated[p25] == nil then
        p23:coatTool(p25);

        return;
    end;

    p23:snapToWelds(p25);
end;

function u4.snapToWelds(p26, p27) -- Line: 119
    -- upvalues: DirtCoat (copy)
    local v28 = p26.coated[p27];

    if v28 ~= nil then
        v28 = v28.container;
    end;

    if v28 then
        DirtCoat.snapWelds(v28);
    end;
end;

function u4.apply(p29, p30) -- Line: 131
    if not p30:IsA("Tool") then
        return nil;
    end;

    if p29:isLocalTool(p30) then
        if p29:ownerOf(p30) then
            p29:coatTool(p30);
        else
            p29:preCoatNext();
        end;

        return nil;
    end;

    if p29:ownerOf(p30) then
        p29:scheduleRemoteCoat(p30);
    end;
end;

function u4.preCoatNext(u31, p32) -- Line: 147
    -- upvalues: Players (copy), CollectionService (copy), DirtBudget (copy)
    if p32 == nil then
        p32 = false;
    end;

    if u31.coatingTool then
        return nil;
    end;

    local LocalPlayer = Players.LocalPlayer;
    local v33 = LocalPlayer:FindFirstChildOfClass("Backpack");

    if not (v33 and LocalPlayer.Character) then
        return nil;
    end;

    local v34 = 0;

    for _, child in v33:GetChildren() do
        if child:IsA("Tool") then
            v34 = v34 + 1;

            if v34 > 10 then
                return nil;
            end;

            if CollectionService:HasTag(child, "Dirt") and u31.coated[child] == nil then
                if not p32 and DirtBudget.isDraining() then
                    u31:retryPreCoat();

                    return nil;
                end;

                u31.coatingTool = child;
                u31:coatTool(child, function() -- Line: 179
                    -- upvalues: u31 (copy), child (copy)
                    return u31:endPreCoat(child);
                end);

                return nil;
            end;
        end;
    end;
end;

function u4.endPreCoat(p35, p36) -- Line: 185
    if p35.coatingTool ~= p36 then
        return nil;
    end;

    p35.coatingTool = nil;
    p35:preCoatNext(true);
end;

function u4.retryPreCoat(u37) -- Line: 192
    if u37.retryQueued then
        return nil;
    end;

    u37.retryQueued = true;
    task.delay(0.25, function() -- Line: 197
        -- upvalues: u37 (copy)
        u37.retryQueued = false;
        u37:preCoatNext();
    end);
end;

function u4.scheduleRemoteCoat(u38, u39) -- Line: 202
    if u38.pendingRemote[u39] ~= nil then
        return nil;
    end;

    u38.pendingRemote[u39] = true;
    task.delay(0.5, function() -- Line: 211
        -- upvalues: u38 (copy), u39 (copy)
        u38.pendingRemote[u39] = nil;

        if u38.coated[u39] ~= nil then
            return nil;
        end;

        local v40 = u38:ownerOf(u39);

        if not v40 then
            return nil;
        end;

        local v41 = os.clock();
        local v42 = u38.remoteCoatClock[v40];

        if v42 ~= nil and v41 - v42 < 2 then
            return nil;
        end;

        u38.remoteCoatClock[v40] = v41;
        u38:coatTool(u39);
    end);
end;

function u4.coatTool(u43, u44, u45) -- Line: 233
    -- upvalues: CollectionService (copy), TOOL_DIRT (copy), Workspace (copy), DirtCoat (copy)
    if u43.coated[u44] ~= nil or (not CollectionService:HasTag(u44, "Dirt") or u44:GetAttribute("dirty") == false) then
        if u45 ~= nil then
            u45();
        end;

        return nil;
    end;

    local u46 = {
        appliedMask = u43:maskFor(u44, u43.data:getDataIfLoaded()),
        destroying = u44.Destroying:Connect(function() -- Line: 249
            -- upvalues: u43 (copy), u44 (copy)
            return u43:forget(u44);
        end),
        cleaned = u44:GetAttributeChangedSignal("dirty"):Connect(function() -- Line: 252
            -- upvalues: u43 (copy), u44 (copy)
            return u43:onCleaned(u44);
        end)
    };
    u43.coated[u44] = u46;
    task.spawn(function() -- Line: 259
        -- upvalues: u43 (copy), u44 (copy), CollectionService (ref), u46 (copy), u45 (copy), TOOL_DIRT (ref), Workspace (ref), DirtCoat (ref)
        if not u43:waitForGeometry(u44) or (not (u44:IsDescendantOf(game) and CollectionService:HasTag(u44, "Dirt")) or u44:GetAttribute("dirty") == false) or u43.coated[u44] ~= u46 then
            if u43.coated[u44] == u46 then
                u43:forget(u44);
            end;

            local v47 = u45;

            if v47 ~= nil then
                v47();
            end;

            return nil;
        end;

        local v48 = u43:resolveDirt(u44);

        local function v51() -- Line: 279
            -- upvalues: u44 (ref), u46 (ref), u43 (ref), u45 (ref)
            local DirtCoat2 = u44:FindFirstChild("DirtCoat");
            local v49;

            if DirtCoat2 == nil then
                v49 = DirtCoat2;
            else
                v49 = DirtCoat2:IsA("Model");
            end;

            if v49 then
                u46.container = DirtCoat2;
                u43:indexCoat(u44);
            elseif u43.coated[u44] == u46 then
                u43:forget(u44);
            end;

            local v50 = u45;

            if v50 ~= nil then
                v50();
            end;
        end;

        local v52 = table.clone(TOOL_DIRT);
        setmetatable(v52, nil);
        v52.weld = true;
        v52.canQuery = false;
        v52.color = v48.color;
        v52.colorJitter = v48.colorJitter;
        v52.material = v48.material;
        v52.onComplete = v51;

        if u44:IsDescendantOf(Workspace) then
            DirtCoat.coat(u44, v52);

            return;
        end;

        DirtCoat.coatDetached(u44, v52);
    end);
end;

function u4.onCleaned(p53, p54) -- Line: 316
    if p54:GetAttribute("dirty") ~= false then
        return nil;
    end;

    p53:stripCoat(p54);
end;

function u4.stripCoat(p55, p56) -- Line: 322
    -- upvalues: DirtCoat (copy)
    local v57 = p55.coated[p56] == nil and not p56:FindFirstChild("DirtCoat");

    if v57 then
        return nil;
    end;

    p55:forget(p56);
    DirtCoat.uncoat(p56);
end;

function u4.forget(p58, p59) -- Line: 335
    local v60 = p58.coated[p59];

    if not v60 then
        return nil;
    end;

    v60.destroying:Disconnect();
    v60.cleaned:Disconnect();
    p58.coated[p59] = nil;

    if p58.coatingTool == p59 then
        p58.coatingTool = nil;
    end;

    p58:preCoatNext();
end;

function u4.ownerOf(p61, p62) -- Line: 352
    -- upvalues: Players (copy)
    local Parent = p62.Parent;
    local v63;

    if Parent == nil then
        v63 = Parent;
    else
        v63 = Parent:IsA("Model");
    end;

    if v63 then
        return Players:GetPlayerFromCharacter(Parent);
    end;

    return nil;
end;

function u4.isLocalTool(p64, p65) -- Line: 363
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;
    local Character = LocalPlayer.Character;
    local v66 = p65:IsDescendantOf(LocalPlayer);

    if not v66 then
        if Character == nil then
            v66 = false;
        else
            v66 = p65:IsDescendantOf(Character);
        end;
    end;

    return v66;
end;

function u4.indexCoat(u67, u68) -- Line: 368
    -- upvalues: DirtMask (copy)
    local u69 = u67.coated[u68];
    local v70;

    if u69 == nil then
        v70 = u69;
    else
        v70 = u69.container;
    end;

    if not v70 or u69.cells then
        return nil;
    end;

    local v71 = DirtMask.frameFor(u68);

    if not v71 then
        return nil;
    end;

    DirtMask.indexBlocks(DirtMask.blocksOf(u69.container), v71, function(p72) -- Line: 387
        -- upvalues: u69 (copy), u67 (copy), u68 (copy)
        u69.cells = p72;
        u67:stripToMask(u68, u69);
    end);
end;

function u4.stripToMask(p73, u74, p75) -- Line: 392
    -- upvalues: DirtMask (copy), DirtCoat (copy)
    local cells = p75.cells;

    if not cells or (not p75.container or p75.appliedMask == "") then
        return nil;
    end;

    local v76 = DirtMask.decode(p75.appliedMask);
    DirtMask.applyFractions(DirtMask.blocksOf(p75.container), cells, v76, function(p77) -- Line: 398
        -- upvalues: DirtCoat (ref), u74 (copy)
        if p77 > 0 then
            DirtCoat.reveal(u74);
        end;
    end);
end;

function u4.maskFor(p78, p79, p80) -- Line: 404
    if not p80 then
        return "";
    end;

    local u81 = p79:GetAttribute("inventoryId");

    if type(u81) ~= "string" then
        return "";
    end;

    local function _(p82) -- Line: 414
        -- upvalues: u81 (copy)
        return p82.uid == u81;
    end;

    local v83 = nil;

    for i, v in p80.Inventory do
        local _ = i - 1;

        if v.uid == u81 == true then
            v83 = v;
            break;
        end;
    end;

    if v83 ~= nil then
        v83 = v83.dirtMask;
    end;

    return v83 == nil and "" or v83;
end;

function u4.resolveDirt(p84, p85) -- Line: 435
    -- upvalues: Items (copy), dirtFor (copy), dirtForRarity (copy)
    local v86 = p85:GetAttribute("itemId");

    if type(v86) == "string" and Items[v86] ~= nil then
        return dirtFor(v86);
    end;

    return dirtForRarity("common");
end;

function u4.remove(p87, p88) -- Line: 442
    -- upvalues: CollectionService (copy)
    if not p88:IsA("Tool") then
        return nil;
    end;

    if CollectionService:HasTag(p88, "Dirt") then
        return nil;
    end;

    p87:stripCoat(p88);
end;

function u4.waitForGeometry(p89, p90) -- Line: 451
    if p90:FindFirstChildWhichIsA("BasePart", true) then
        return true;
    end;

    local v91 = os.clock() + 10;

    while os.clock() < v91 do
        if not p90.Parent then
            return false;
        end;

        if p90:FindFirstChildWhichIsA("BasePart", true) then
            return true;
        end;

        task.wait(0.1);
    end;

    return p90:FindFirstChildWhichIsA("BasePart", true) ~= nil;
end;

Reflect.defineMetadata(u4, "identifier", "client/controllers/world/DirtCoatController@DirtCoatController");
Reflect.defineMetadata(u4, "flamework:parameters", { "client/controllers/data/DataController@DataController" });
Reflect.defineMetadata(u4, "flamework:implements", { "$:flamework@OnStart", "client/controllers/data/DataController@OnDataChanged" });
Reflect.decorate(u4, "$:flamework@Controller", Controller, { {} });

return {
    DirtCoatController = u4
};