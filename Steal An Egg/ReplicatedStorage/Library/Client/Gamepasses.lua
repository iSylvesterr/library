-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Asserts = require(Library.Asserts);
local Directory = require(ReplicatedStorage.Directory.Gamepasses).Directory;
local Save = require(Library:WaitForChild("Client"):WaitForChild("Save"));
local u1 = {};

for _, v in pairs(Directory) do
    local ProductId = v.ProductId;

    if ProductId and not u1[ProductId] then
        u1[ProductId] = v;
    end;
end;

local v2 = {};

local function parseGamepassId(p3) -- Line: 24
    -- upvalues: Directory (copy), Asserts (copy)
    if type(p3) ~= "number" then
        if type(p3) == "string" then
            local v4 = Directory[p3];
            local v5 = `Unknown gamepass: {p3}`;
            assert(v4, v5);
            p3 = v4.ProductId;
        else
            local v6 = Directory[p3._id] == p3;
            local v7 = `Unknown gamepass: {p3}`;
            assert(v6, v7);
            p3 = p3.ProductId;
        end;
    end;

    Asserts.integer(p3);

    return p3;
end;

function v2.GetById(p8) -- Line: 40
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.integer(p8);

    return u1[p8];
end;

function v2.Owns(p9, p10) -- Line: 45
    -- upvalues: parseGamepassId (copy), u1 (copy), Save (copy)
    local v11 = u1[parseGamepassId(p9)];
    local v12 = `Unknown gamepass: {p9}`;
    assert(v11, v12);
    local v13 = Save.Get(p10);

    if v13 then
        return v13.Gamepasses[v11._id] == true;
    end;

    return false;
end;

function v2.GetAll(p14) -- Line: 58
    -- upvalues: Players (copy), Save (copy)
    local v15 = Save.Get(p14 or Players.LocalPlayer);

    return not v15 and {} or v15.Gamepasses;
end;

return v2;