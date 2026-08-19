-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage;
local ModelViewport = RuntimeLib.import(script, script.Parent, "ModelViewport").ModelViewport;
local Items = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items").Items;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local ItemModel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "items", "ItemModel").ItemModel;

return {
    ItemViewport = {
        setItem = function(p1, p2) -- Line: 11, Name: setItem
            -- upvalues: WFChain (copy), ReplicatedStorage (copy), Items (copy), ItemModel (copy), ModelViewport (copy)
            local v3 = WFChain(ReplicatedStorage, "Assets", "Items", Items[p2].displayName);
            local v4 = ItemModel.toModel(v3);

            if v4 then
                ItemModel.applyDisplayRotation(v4, p2);
            end;

            local v5 = Items[p2];
            local viewYaw = v5.viewYaw;
            local viewZoom = v5.viewZoom;
            ModelViewport.setModel(p1, v4, viewYaw == nil and 0 or viewYaw, viewZoom == nil and 1 or viewZoom);
        end
    }
};