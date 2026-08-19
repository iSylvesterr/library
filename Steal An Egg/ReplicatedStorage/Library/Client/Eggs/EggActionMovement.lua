-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local BulkMoveController = require(ReplicatedStorage.Library.Client.BulkMoveController);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = {};
local u2 = {};

local function newModelState(u3) -- Line: 28
    -- upvalues: Asserts (copy), Trove (copy), BulkMoveController (copy), u1 (copy), u2 (copy)
    local PrimaryPart = u3.PrimaryPart;
    Asserts.BasePart(PrimaryPart);
    PrimaryPart.Anchored = true;
    local v4 = Trove.new();
    local u5 = {};

    for i, v in { PrimaryPart } do
        u5[i] = BulkMoveController.Register(v);
    end;

    v4:Add(function() -- Line: 40
        -- upvalues: u5 (copy)
        for _, v in u5 do
            v:Destroy();
        end;
    end);
    local v6 = {
        Parts = { PrimaryPart },
        Components = u5,
        Trove = v4
    };
    u1[u3] = v6;
    v4:Connect(u3.Destroying, function() -- Line: 52
        -- upvalues: u2 (ref), u3 (copy)
        u2.Remove(u3);
    end);

    return v6;
end;

function u2.SetPivot(p7, p8) -- Line: 63
    -- upvalues: Asserts (copy), u1 (copy), newModelState (copy)
    Asserts.Model(p7);
    Asserts.finiteCFrame(p8);
    local v9 = u1[p7] or newModelState(p7);
    local v10 = p7:GetPivot();

    for i, v in v9.Parts do
        local v11 = v10:ToObjectSpace(v.CFrame);
        v9.Components[i]:SetCFrame(p8 * v11);
    end;
end;

function u2.Remove(p12) -- Line: 75
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.Model(p12);
    local v13 = u1[p12];

    if v13 == nil then
        return;
    end;

    u1[p12] = nil;
    v13.Trove:Destroy();
end;

return u2;