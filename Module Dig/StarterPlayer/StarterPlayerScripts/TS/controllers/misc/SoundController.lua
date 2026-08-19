-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local u1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "object-utils");
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services");
local ContentProvider = v2.ContentProvider;
local ReplicatedStorage = v2.ReplicatedStorage;
local SoundService = v2.SoundService;
local MiscEvents = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "MiscNetwork").MiscEvents;
local SFX = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "SFX").SFX;
local playSound = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "sound", "SoundUtil").playSound;
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 18, Name: __tostring
        return "SoundController";
    end
});
u3.__index = u3;

function u3.new(...) -- Line: 23
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(p5) -- Line: 27
end;

function u3.onStart(p6) -- Line: 29
    -- upvalues: MiscEvents (copy), playSound (copy)
    p6:preloadAll();
    MiscEvents.PlaySound:connect(function(p7, p8) -- Line: 31
        -- upvalues: playSound (ref)
        playSound(p7, {
            volume = p8
        });
    end);
end;

function u3.preloadAll(u9) -- Line: 37
    -- upvalues: SoundService (copy), u1 (copy), SFX (copy), ContentProvider (copy)
    local Folder = Instance.new("Folder");
    Folder.Name = "PreloadedSounds";
    Folder.Parent = SoundService;
    local v10 = u1.values(SFX);
    local u11 = table.create(#v10);

    local function _(p12) -- Line: 44
        -- upvalues: Folder (copy)
        local Sound = Instance.new("Sound");
        Sound.SoundId = p12;
        Sound.Parent = Folder;

        return Sound;
    end;

    for i, v in v10 do
        local _ = i - 1;
        local Sound = Instance.new("Sound");
        Sound.SoundId = v;
        Sound.Parent = Folder;
        u11[i] = Sound;
    end;

    task.spawn(function() -- Line: 55
        -- upvalues: ContentProvider (ref), u11 (copy), Folder (copy), u9 (copy)
        pcall(function() -- Line: 56
            -- upvalues: ContentProvider (ref), u11 (ref)
            return ContentProvider:PreloadAsync(u11);
        end);
        Folder:Destroy();
        u9:preloadAssetSounds();
    end);
end;

function u3.preloadAssetSounds(p13) -- Line: 63
    -- upvalues: ReplicatedStorage (copy), ContentProvider (copy)
    local Assets = ReplicatedStorage:WaitForChild("Assets", 10);

    if not Assets then
        return nil;
    end;

    local function _(p14) -- Line: 71
        return p14:IsA("Sound");
    end;

    local v15 = 0;
    local u16 = {};

    for i, descendant in Assets:GetDescendants() do
        local _ = i - 1;

        if descendant:IsA("Sound") == true then
            v15 = v15 + 1;
            u16[v15] = descendant;
        end;
    end;

    if #u16 > 0 then
        pcall(function() -- Line: 84
            -- upvalues: ContentProvider (ref), u16 (copy)
            return ContentProvider:PreloadAsync(u16);
        end);
    end;
end;

Reflect.defineMetadata(u3, "identifier", "client/controllers/misc/SoundController@SoundController");
Reflect.defineMetadata(u3, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u3, "$:flamework@Controller", Controller, { {} });

return {
    SoundController = u3
};