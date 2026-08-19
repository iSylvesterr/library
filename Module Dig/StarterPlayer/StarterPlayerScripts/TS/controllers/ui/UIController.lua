-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local u1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "object-utils");
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local ContentProvider = v2.ContentProvider;
local ReplicatedStorage = v2.ReplicatedStorage;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local Images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "ui", "Images").Images;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u3 = { "ScreenUI", "WorldUI" };
local u4 = { "Items", "Shovels", "SprayBottles", "Detectors" };
local u5 = setmetatable({}, {
    __tostring = function() -- Line: 23, Name: __tostring
        return "UIController";
    end
});
u5.__index = u5;

function u5.new(...) -- Line: 28
    -- upvalues: u5 (ref)
    local v6 = setmetatable({}, u5);

    return v6:constructor(...) or v6;
end;

function u5.constructor(p7) -- Line: 32
end;

function u5.onStart(u8) -- Line: 34
    task.defer(function() -- Line: 35
        -- upvalues: u8 (copy)
        u8:preloadImages();
        u8:preloadModels();
    end);
end;

function u5.preloadModels(p9) -- Line: 40
    -- upvalues: u4 (copy), WFChain (copy), ReplicatedStorage (copy), ContentProvider (copy)
    for _, v in u4 do
        local u10 = WFChain(ReplicatedStorage, "Assets", v);
        pcall(function() -- Line: 43
            -- upvalues: ContentProvider (ref), u10 (copy)
            return ContentProvider:PreloadAsync(u10:GetChildren());
        end);
    end;
end;

function u5.preloadImages(p11) -- Line: 48
    -- upvalues: PlayerGui (copy), ContentProvider (copy)
    local v12 = p11:collectImageIds();
    local v13 = false;
    local v14 = 0;

    while true do
        local v15;

        if v13 then
            v15 = v14 + 16;
        else
            v15 = v14;
            v13 = true;
        end;

        if v15 >= #v12 then
            return;
        end;

        local ScreenGui = Instance.new("ScreenGui");
        ScreenGui.Name = "PreloadedImages";
        ScreenGui.ResetOnSpawn = false;
        ScreenGui.IgnoreGuiInset = true;
        ScreenGui.Parent = PlayerGui;
        local v16 = math.min(v15 + 16, #v12);
        v14 = v15;
        local v17 = false;
        local u18 = {};

        while true do
            if true then
                if v17 then
                    v15 = v15 + 1;
                else
                    v17 = true;
                end;
            end;

            if v15 >= v16 then
                break;
            end;

            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Image = v12[v15 + 1];
            ImageLabel.Size = UDim2.fromOffset(1, 1);
            ImageLabel.Position = UDim2.fromOffset(v15 % 100 * 1, math.floor(v15 / 100) * 1);
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.ImageTransparency = 0.999;
            ImageLabel.Parent = ScreenGui;
            table.insert(u18, ImageLabel);
        end;

        pcall(function() -- Line: 91
            -- upvalues: ContentProvider (ref), u18 (copy)
            return ContentProvider:PreloadAsync(u18);
        end);
        ScreenGui:Destroy();
        task.wait();
    end;
end;

function u5.collectImageIds(p19) -- Line: 99
    -- upvalues: u1 (copy), Images (copy), ReplicatedStorage (copy), PlayerGui (copy), u3 (copy)
    local u20 = {};
    local u21 = {};

    local function _(p22) -- Line: 102
        -- upvalues: u20 (copy), u21 (copy)
        if p22 == "" or u20[p22] ~= nil then
            return nil;
        end;

        u20[p22] = true;
        table.insert(u21, p22);
    end;

    for _, v in u1.values(Images) do
        if v ~= "" and u20[v] == nil then
            u20[v] = true;
            table.insert(u21, v);
        end;
    end;

    local Assets = ReplicatedStorage:WaitForChild("Assets", 10);
    local v23 = PlayerGui:GetDescendants();

    for _, v in u3 do
        local v24;

        if Assets == nil then
            v24 = Assets;
        else
            v24 = Assets:FindFirstChild(v);
        end;

        if v24 then
            for _, descendant in v24:GetDescendants() do
                table.insert(v23, descendant);
            end;
        end;
    end;

    for _, v in v23 do
        if v:IsA("ImageLabel") or v:IsA("ImageButton") then
            local Image = v.Image;

            if Image ~= "" and u20[Image] == nil then
                u20[Image] = true;
                table.insert(u21, Image);
            end;
        end;
    end;

    return u21;
end;

Reflect.defineMetadata(u5, "identifier", "client/controllers/ui/UIController@UIController");
Reflect.defineMetadata(u5, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u5, "$:flamework@Controller", Controller, { {} });

return {
    UIController = u5
};