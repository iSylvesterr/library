-- Decompiled with Potassium's decompiler.

local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local Items = Library:WaitForChild("Items");
local Container = Items:WaitForChild("Container");
local Asserts = require(Library.Asserts);
local AbstractItem = require(Items.AbstractItem);
local u1 = require(Container);
local InventoryProjection = require(Items.InventoryProjection);
local SimpleStore = require(Container.SimpleStore);
local Save = require(Library.Client.Save);
local u2 = {};
u2.__index = u2;

local function isStateSourceCurrent(p3, p4) -- Line: 31
    -- upvalues: Save (copy)
    return Save.Get(p3) == p4;
end;

local function connectContainerSignals(u5) -- Line: 35
    -- upvalues: AbstractItem (copy)
    u5.container.Added:Connect(function(p6) -- Line: 36
        -- upvalues: AbstractItem (ref), u5 (copy)
        for _, v in ipairs(p6) do
            AbstractItem.Added:FireAsync(v, u5.player);
            v.Class.Module.Added:FireAsync(v, u5.player);
        end;
    end);
    u5.container.Removed:Connect(function(p7) -- Line: 43
        -- upvalues: AbstractItem (ref), u5 (copy)
        for _, v in ipairs(p7) do
            AbstractItem.Removed:FireAsync(v, u5.player);
            v.Class.Module.Removed:FireAsync(v, u5.player);
        end;
    end);
    u5.container.Tracked:Connect(function(p8) -- Line: 50
        -- upvalues: AbstractItem (ref), u5 (copy)
        for _, v in ipairs(p8) do
            AbstractItem.Tracked:FireAsync(v, u5.player);
            v.Class.Module.Tracked:FireAsync(v, u5.player);
        end;
    end);
end;

function u2.new(u9, u10) -- Line: 59
    -- upvalues: Asserts (copy), InventoryProjection (copy), u1 (copy), SimpleStore (copy), Save (copy), u2 (copy), connectContainerSignals (copy)
    Asserts.Player(u9);
    Asserts.table(u10);
    local v11 = InventoryProjection.BuildSnapshot(u10);
    local v12 = {
        player = u9,
        container = u1.new(SimpleStore.new(v11, function() -- Line: 65
            -- upvalues: u9 (copy), u10 (copy), Save (ref)
            return u10 == Save.Get(u9);
        end), u9)
    };
    local v13 = setmetatable(v12, u2);
    connectContainerSignals(v13);

    return v13;
end;

function u2.Destroy(p14) -- Line: 80
    p14.container:Destroy();
end;

return u2;