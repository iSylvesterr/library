-- Decompiled with Potassium's decompiler.

local u1 = {
    Products = {},
    Gamepasses = {}
};
local u2 = {};
local u3 = {};

local function indexProduct(p4) -- Line: 9
    -- upvalues: u2 (copy), u3 (copy)
    if type(p4) == "table" and type(p4.Key) == "string" then
        u2[p4.Key] = p4;
    end;

    if type(p4) == "table" and type(p4.ProductId) == "number" then
        u3[p4.ProductId] = p4;
    end;
end;

local function addProduct(p5) -- Line: 19
    -- upvalues: u1 (copy), u2 (copy), u3 (copy)
    u1.Products[#u1.Products + 1] = p5;

    if type(p5) == "table" and type(p5.Key) == "string" then
        u2[p5.Key] = p5;
    end;

    if type(p5) == "table" and type(p5.ProductId) == "number" then
        u3[p5.ProductId] = p5;
    end;
end;

local u6 = {};

for _, v in u1.Products do
    if type(v) == "table" and type(v.Key) == "string" then
        u2[v.Key] = v;
    end;

    if type(v) == "table" and type(v.ProductId) == "number" then
        u3[v.ProductId] = v;
    end;
end;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.SharedModules.SeedData);
require(ReplicatedStorage.SharedModules.Networking);
local SeedShop = ReplicatedStorage:WaitForChild("StockValues"):WaitForChild("SeedShop");
SeedShop:WaitForChild("Items");
SeedShop:WaitForChild("UnixNextRestock");
SeedShop:WaitForChild("UnixLastRestock");

local function getSeedProductKey(p7) -- Line: 37
    return "Seed:" .. p7;
end;

function u1.GetByKey(p8) -- Line: 41
    -- upvalues: u2 (copy)
    return u2[p8];
end;

function u1.GetByProductId(p9) -- Line: 45
    -- upvalues: u3 (copy)
    return u3[p9];
end;

function u1.GetSeedProductKey(p10) -- Line: 49
    return "Seed:" .. p10;
end;

function u1.AddProduct(p11) -- Line: 53
    -- upvalues: u1 (copy), u2 (copy), u3 (copy)
    u1.Products[#u1.Products + 1] = p11;

    if type(p11) == "table" and type(p11.Key) == "string" then
        u2[p11.Key] = p11;
    end;

    if type(p11) == "table" and type(p11.ProductId) == "number" then
        u3[p11.ProductId] = p11;
    end;
end;

function u1.AddGamepass(p12) -- Line: 57
    -- upvalues: u1 (copy), u6 (copy)
    u1.Gamepasses[p12.Key] = p12;

    if type(p12.GamepassId) == "number" then
        u6[p12.GamepassId] = p12;
    end;
end;

function u1.GetByGamepassId(p13) -- Line: 64
    -- upvalues: u6 (copy)
    return u6[p13];
end;

function u1.GetGamepassByKey(p14) -- Line: 68
    -- upvalues: u1 (copy)
    return u1.Gamepasses[p14];
end;

return u1;