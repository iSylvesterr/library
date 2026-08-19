-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Promise = require(ReplicatedStorage.Library.Modules.Packages.Promise);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(script.Private.Types);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local TableInjectAutoRemovalBehavior = require(ReplicatedStorage.Library.Functions.TableInjectAutoRemovalBehavior);
local u1 = Log.new();
local u2 = {
    NOT_FOUND = "_stackNotFound"
};
local u3 = {
    RESOLVED = 1,
    RESOLVING = 2,
    REMOVING = 4,
    DESTROYING = 8,
    BLOCK_LISTENER = 15,
    INVALID_EXECUTABLE_RESOLVER = 6
};
local u4 = {};
u4.__index = u4;
u4.__class = "DeferredListener";
u4.RESULT_STATUS = u2;
u4.STATE_FLAGS = u3;
local u5 = {};
u5.__index = u5;
u5.__class = "ExecutableStack";

function u5.new(p6, p7, p8) -- Line: 52
    -- upvalues: Asserts (copy), Trove (copy), u5 (copy), TableInjectAutoRemovalBehavior (copy)
    Asserts.optional.table(p6);
    local v9 = {
        _flags = 0,
        _stack = {},
        _subStacksContainer = {},
        _stackChainConfig = p6 or {},
        _trove = Trove.new(),
        _sharedListData = p8 or {
            _masterIndex = 0
        }
    };
    local v10 = setmetatable(v9, u5);

    if typeof(p7) ~= "table" then
        return v10;
    end;

    p7.object = v10;

    return TableInjectAutoRemovalBehavior(p7);
end;

function u4.new(p11) -- Line: 77
    -- upvalues: u4 (copy)
    return setmetatable({
        _destroying = false,
        _stackChainConfig = p11,
        _stackContainer = {}
    }, u4);
end;

function u4._safeGetStack(p12, p13) -- Line: 90
    -- upvalues: Asserts (copy)
    Asserts.optional.string(p13);

    if p13 then
        return p12._stackContainer[p13];
    end;
end;

function u4.Destroy(p14) -- Line: 100
    if p14._destroying then
        return;
    end;

    p14._destroying = true;

    for _, v in p14._stackContainer do
        v:Destroy();
    end;

    setmetatable(p14, nil);
    table.clear(p14);
end;

function u4.GetOrCreateExecutableStack(p15, p16, p17) -- Line: 115
    -- upvalues: Asserts (copy), u5 (copy)
    Asserts.string(p16);
    local v18 = p15._stackContainer[p16] or u5.new(p17 or p15._stackChainConfig, {
        removeFrom = p15._stackContainer,
        indexOverride = p16
    });
    p15._stackContainer[p16] = v18;
    v18._name = p16;

    return p15._stackContainer[p16];
end;

function u4.ResolveAll(p19, p20) -- Line: 131
    -- upvalues: Promise (copy)
    local v21 = p20 and {};

    for _, v in p19._stackContainer do
        local v22 = v:ResolveAllListeners();

        if v21 and v22 then
            table.insert(v21, v22);
        end;
    end;

    return v21 and Promise.all(v21) or nil;
end;

function u4.ProxySafeInstructionsToStack(p23, p24, p25, ...) -- Line: 145
    -- upvalues: u2 (copy), Asserts (copy)
    local v26 = p23:_safeGetStack(p25);

    if not v26 then
        return u2.NOT_FOUND;
    end;

    Asserts.string(p24);
    Asserts.func(v26[p24]);

    return v26[p24](v26, ...);
end;

function u5.SetFlag(p27, p28) -- Line: 163
    p27._flags = bit32.bor(p27._flags, p28);
end;

function u5.ClearFlag(p29, p30) -- Line: 167
    local _flags = p29._flags;
    local v31 = bit32.bnot(p30);
    p29._flags = bit32.band(_flags, v31);
end;

function u5.IsFlagSet(p32, p33) -- Line: 171
    return bit32.band(p32._flags, p33) ~= 0;
end;

function u5.Destroy(p34) -- Line: 176
    -- upvalues: u3 (copy), u1 (copy)
    if not p34:IsFlagSet(u3.DESTROYING) then
        p34:SetFlag(u3.DESTROYING);
        local v35 = os.clock();
        u1:AtTrace():Log(`stack:{p34._name} destroying it self, config:`, p34._stackChainConfig);

        for _, v in p34._subStacksContainer do
            if p34._stackChainConfig.resolveSubStacksOnDestroy then
                v:ResolveAllListeners(false, true):await();
            else
                v:Destroy();
            end;
        end;

        if p34._stackChainConfig.selfResolveOnDestroy then
            p34:ResolveAllListeners():await();
        end;

        u1:AtTrace():Log((`stack:{p34._name} successfully destroyed it in: {os.clock() - v35}`));
        p34._trove:Destroy();
        setmetatable(p34, nil);

        return table.clear(p34);
    end;
end;

function u5.Extend(p36, p37) -- Line: 205
    -- upvalues: u5 (copy)
    return u5.new(p37 or p36._stackChainConfig, {
        removeFrom = p36._subStacksContainer
    }, p36._sharedListData);
end;

function u5.MarkAsResolved(p38) -- Line: 211
    -- upvalues: u3 (copy)
    p38:SetFlag(u3.RESOLVED);
end;

function u5.IsStackChainEmpty(p39) -- Line: 215
    return p39._sharedListData._masterIndex == 0;
end;

function u5.AddListener(p40, p41, ...) -- Line: 220
    -- upvalues: u1 (copy), u3 (copy)
    if typeof(p41) ~= "function" then
        return u1:AtTrace():Log("registration request dropped  due to invalid parameters.");
    end;

    if p40:IsFlagSet(u3.BLOCK_LISTENER) then
        return u1:AtTrace():Log((`registration request dropped due to invalid state for {p40._name}`));
    end;

    u1:AtTrace():Log((`registration request successfully registered for: {p40._name}`));
    table.insert(p40._stack, {
        Packet = { ... },
        Callback = p41
    });
    local _sharedListData = p40._sharedListData;
    _sharedListData._masterIndex = _sharedListData._masterIndex + 1;

    return true;
end;

function u5.ResolveAllListeners(u42, u43, u44, ...) -- Line: 237
    -- upvalues: u3 (copy), Promise (copy), u1 (copy)
    if u42:IsFlagSet(u3.INVALID_EXECUTABLE_RESOLVER) then
        return Promise.reject("attempt to resolve listeners in an invalid stack state.");
    end;

    if #u42._stack == 0 then
        return Promise.resolve("instantly resolved. Empty local stack.");
    end;

    u42:SetFlag(u3.RESOLVING);
    u1:AtTrace():Log("successfully resolving user listeners.");
    local u45 = u42._stackChainConfig.passCustomDataToListenerWhenResolving and (select("#", ...) ~= 0 and { ... } or false);
    local u46 = #u42._stack;
    local u47 = 0;
    local throttleThreshold = u42._stackChainConfig.throttleThreshold;

    return Promise.new(function(p48, p49, p50) -- Line: 259
        -- upvalues: u42 (copy), u1 (ref), u3 (ref), u45 (copy), u47 (ref), u43 (copy), throttleThreshold (copy)
        local v51 = 0;
        local u52 = false;
        p50(function() -- Line: 263
            -- upvalues: u52 (ref), u42 (ref)
            u52 = true;
            table.clear(u42._stack);
        end);

        for i, v in ipairs(u42._stack) do
            if typeof(v) == "table" then
                if u52 then
                    return u1:AtInfo():Log((`operation cancelled during iteration during: {i}ts packet.`));
                end;

                if u42:IsFlagSet(u3.REMOVING) then
                    return p48(u42, "_removing");
                end;

                local function processListener() -- Line: 279
                    -- upvalues: v (copy), u45 (ref), u1 (ref)
                    local v53 = {};
                    local v54 = table.clone(v.Packet);

                    if u45 and #u45 ~= 0 then
                        table.move(u45, 1, #u45, 1, v53);
                        table.move(v54, 1, #v54, #v53 + 1, v53);
                    end;

                    local success, result = pcall(v.Callback, unpack(v53));

                    if not success then
                        u1:AtWarning():Log((`Failed to resolve database shared listener protocol: {result}`));
                    end;
                end;

                if u42._stackChainConfig.yieldWhenResolving then
                    processListener();
                else
                    task.spawn(processListener);
                end;

                u47 = u47 + 1;
                local _sharedListData = u42._sharedListData;
                _sharedListData._masterIndex = _sharedListData._masterIndex - 1;

                if not u43 and (throttleThreshold and throttleThreshold > 0) then
                    v51 = v51 + 1;

                    if v51 >= throttleThreshold then
                        task.wait(0.05);
                        v51 = 0;
                    end;
                end;
            end;
        end;

        table.clear(u42._stack);

        return p48(u42, "_completed");
    end):finally(function(...) -- Line: 317
        -- upvalues: u42 (copy), u3 (ref), u46 (copy), u47 (ref), u44 (copy)
        u42:ClearFlag(u3.RESOLVING);
        local _sharedListData = u42._sharedListData;
        _sharedListData._masterIndex = _sharedListData._masterIndex - (u46 - u47);

        if not u44 then
            return ...;
        end;

        u42:Destroy();

        return ...;
    end):catch(function(p55) -- Line: 328
        -- upvalues: u1 (ref)
        u1:AtWarning():Log((`Failed to successfully resolve all listeners: {p55}`));
    end);
end;

return u4;