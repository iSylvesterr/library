-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Library.Types.Eggs);
local LimitedEgg = require(ReplicatedStorage.Directory.LimitedEgg);
local LotteryCustom = require(ReplicatedStorage.Library.Functions.LotteryCustom);
require(script.Parent.Parent.Types.Interface);
local GenerateUID = require(ReplicatedStorage.Library.Functions.GenerateUID);

local function buildReceiptGrants(p1) -- Line: 19
    -- upvalues: ReplicatedStorage (copy), LotteryCustom (copy), LimitedEgg (copy), Asserts (copy), GenerateUID (copy)
    local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil);
    local v2 = {};

    for _ = 1, p1 do
        local v3 = LotteryCustom(nil, LimitedEgg.DropTable);
        Asserts.string(v3);
        local v4 = {
            Uid = GenerateUID(),
            Record = EggItemUtil.BuildSavedEgg(v3)
        };
        table.insert(v2, v4);
    end;

    return v2;
end;

return function(p5, u6) -- Line: 36
    -- upvalues: Asserts (copy), ServerScriptService (copy), ReplicatedStorage (copy), buildReceiptGrants (copy)
    Asserts.number(p5);
    Asserts.positiveInteger(u6);
    assert(p5 > 0, "Limited egg product id must be positive");

    local function ServerTest(p7) -- Line: 41
        -- upvalues: Asserts (ref), ServerScriptService (ref)
        Asserts.Player(p7);

        if require(ServerScriptService.Library.Database).IsPlayerLoaded(p7) then
            return true;
        end;

        return false, "Data not loaded";
    end;

    local function ClientTest() -- Line: 52
        -- upvalues: ReplicatedStorage (ref)
        if require(ReplicatedStorage.Library.Client.Save).Get() == nil then
            return false, "Data not loaded";
        end;

        return true;
    end;

    local function Callback(p8) -- Line: 61
        -- upvalues: Asserts (ref), ServerScriptService (ref), buildReceiptGrants (ref), u6 (copy)
        Asserts.Player(p8);
        local Eggs = require(ServerScriptService.Controllers.Eggs);
        local v9 = buildReceiptGrants(u6);

        return Eggs.GrantPaidEggBatch(p8, v9);
    end;

    return {
        Icon = "",
        LockWhileProcessing = true,
        DisableNotification = true,
        ProductId = p5,
        DisplayName = `Limited Egg x{u6}`,
        Desc = u6 == 1 and "A limited pet egg." or `{u6} limited pet eggs.`,
        ServerTest = ServerTest,
        ClientTest = ClientTest,
        Callback = Callback
    };
end;