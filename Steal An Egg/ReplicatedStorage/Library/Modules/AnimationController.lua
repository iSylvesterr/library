-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Core = require(script.Core);
local Action = require(script.Action);
local DefaultAnims = require(script.DefaultAnims);
require(script.Types);
local Preload = require(script.Utility.Preload);
local LoadPackage = require(script.Utility.LoadPackage);
local LoadAnimPackage = script.Async.LoadAnimPackage;
local LoadEmotePackage = script.Async.LoadEmotePackage;
local u1 = {};
local u2 = {};

local function deepCopy(p3) -- Line: 19
    -- upvalues: deepCopy (copy)
    local v4 = {};

    for i, v in p3 do
        if type(v) == "table" then
            v4[i] = deepCopy(v);
        else
            v4[i] = v;
        end;
    end;

    return v4;
end;

local v5 = {};
local u6 = {
    __index = v5
};

function v5.Destroy(p7) -- Line: 42
    -- upvalues: u1 (copy)
    p7.Action:Destroy();
    p7.Core:Destroy();
    p7._destroying:Disconnect();
    u1[p7._rig] = nil;
    setmetatable(p7, nil);
    table.clear(p7);
end;

return {
    new = function(p8, p9, p10, p11, p12) -- Line: 70, Name: new
        -- upvalues: deepCopy (copy), DefaultAnims (copy), Preload (copy), Core (copy), Action (copy), u6 (copy), u1 (copy), u2 (copy)
        local v13 = p9 == nil and true or p9;
        local v14 = p8:FindFirstChildWhichIsA("Animator", true);

        if not v14 then
            error((`Animator not found for rig {p8}`));
        end;

        local v15 = p10 ~= nil and deepCopy(p10) or deepCopy(DefaultAnims.R15.Animations);
        local v16 = p11 ~= nil and deepCopy(p11) or deepCopy(DefaultAnims.R15.Emotes);

        if v13 then
            v15 = Preload.preloadAnimList(v14, v15, "core", Enum.AnimationPriority.Core) or v15;
        end;

        if v13 then
            v16 = Preload.preloadAnimList(v14, v16, "emote", Enum.AnimationPriority.Action) or v16;
        end;

        local v17 = Core.new(p8, v15, p12);
        local v18 = {
            Core = v17,
            Action = Action.new(v17.PoseController, p8, v16, p12),
            _rig = p8
        };
        local u19 = setmetatable(v18, u6);
        u19._destroying = p8.Destroying:Connect(function() -- Line: 107
            -- upvalues: u19 (copy)
            u19:Destroy();
        end);
        u1[p8] = u19;
        local v20 = u2[p8];

        if v20 then
            for _, v in v20 do
                task.spawn(v, u19);
            end;
        end;

        return u19;
    end,

    fromExisting = function(p21) -- Line: 129, Name: fromExisting
        -- upvalues: u1 (copy)
        return u1[p21];
    end,

    waitForController = function(u22, p23) -- Line: 141, Name: waitForController
        -- upvalues: u1 (copy), u2 (copy)
        if u1[u22] then
            return u1[u22];
        end;

        u2[u22] = u2[u22] or {};
        local u24 = u2[u22];
        local u25 = coroutine.running();
        u24[#u24 + 1] = u25;
        task.delay(p23 or 5, function() -- Line: 154
            -- upvalues: u25 (copy), u24 (copy), u22 (copy)
            if coroutine.status(u25) ~= "suspended" then
                return;
            end;

            table.remove(u24, table.find(u24, u25));
            warn((`Infinite yield possible while waiting for {u22} controller.`));
        end);

        return coroutine.yield();
    end,

    getCopyOfAnimsList = function(p26, p27) -- Line: 173, Name: getCopyOfAnimsList
        -- upvalues: DefaultAnims (copy), deepCopy (copy)
        local v28 = DefaultAnims[p26];

        if not v28 then
            error((`{p26} is not a valid default animation list.`));
        end;

        local v29 = v28[p27];

        if not v29 then
            error((`{p27} is not a valid default animation list specifier.`));
        end;

        return deepCopy(v29);
    end,

    getCopyOfAnims = function(p30) -- Line: 194, Name: getCopyOfAnims
        -- upvalues: DefaultAnims (copy), deepCopy (copy)
        local v31 = DefaultAnims[p30];

        if not v31 then
            error((`{p30} is not a valid default animation list.`));
        end;

        return deepCopy(v31.Animations), deepCopy(v31.Emotes);
    end,

    getAnimPackageAsync = function(p32, p33) -- Line: 203, Name: getAnimPackageAsync
        -- upvalues: RunService (copy), deepCopy (copy), DefaultAnims (copy), LoadAnimPackage (copy), LoadPackage (copy)
        if typeof(p32) ~= "Instance" and RunService:IsServer() then
            error("When calling getAnimPackageAsync from the server, the first argument must be a player.");
        end;

        local v34 = p33 or deepCopy(DefaultAnims.R15.Animations);
        local v35;

        if RunService:IsClient() then
            v35 = LoadAnimPackage:InvokeServer();
        else
            v35 = LoadPackage.getPlayerAnimPackage(p32);
        end;

        for i, v in v34 do
            if v35[i] == nil then
                v35[i] = v;
            end;
        end;

        return v35;
    end,

    getEmotePackageAsync = function(p36, p37) -- Line: 228, Name: getEmotePackageAsync
        -- upvalues: RunService (copy), deepCopy (copy), DefaultAnims (copy), LoadEmotePackage (copy), LoadPackage (copy)
        if typeof(p36) ~= "Instance" and RunService:IsServer() then
            error("When calling getEmotePackageAsync from the server, the first argument must be a player.");
        end;

        local v38 = p37 or deepCopy(DefaultAnims.R15.Animations);
        local v39;

        if RunService:IsClient() then
            v39 = LoadEmotePackage:InvokeServer();
        else
            v39 = LoadPackage.getPlayerEmotePackage(p36);
        end;

        for i, v in v38 do
            if v39[i] == nil then
                v39[i] = v;
            end;
        end;

        return v39;
    end,

    Preload = Preload,
    default = DefaultAnims
};