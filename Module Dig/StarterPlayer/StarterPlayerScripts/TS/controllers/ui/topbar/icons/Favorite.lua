-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Icon = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "topbar-plus", "out").Icon;
local AvatarEditorService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").AvatarEditorService;

return {
    setup = function() -- Line: 5, Name: setup
        -- upvalues: Icon (copy), AvatarEditorService (copy)
        local u1 = nil;
        u1 = Icon.new():setImage("rbxassetid://121614659636483"):setImageScale(0.7):bindEvent("selected", function() -- Line: 7
            -- upvalues: u1 (ref), AvatarEditorService (ref)
            u1:deselect();
            AvatarEditorService:PromptSetFavorite(game.PlaceId, Enum.AvatarItemType.Asset, true);
        end):align("Right"):setOrder(2);
    end
};