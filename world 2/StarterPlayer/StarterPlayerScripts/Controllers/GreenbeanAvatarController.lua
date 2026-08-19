-- Decompiled with Potassium's decompiler.

local AvatarEditorService = game:GetService("AvatarEditorService");
local MarketplaceService = game:GetService("MarketplaceService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local GreenbeanAvatarItems = require(ReplicatedStorage.SharedData.GreenbeanAvatarItems);
local GreenbeanCheck = require(ReplicatedStorage.SharedData.GreenbeanCheck);
local GreenbeanHumanoidDescription = ReplicatedStorage.Assets.GreenbeanHumanoidDescription;
local v1 = {};
local LocalPlayer = Players.LocalPlayer;
local u2 = false;
AvatarEditorService.PromptSaveAvatarCompleted:Connect(function(p3, p4) -- Line: 17
    -- upvalues: u2 (ref), GreenbeanCheck (copy), Networking (copy)
    u2 = false;

    if p3 == Enum.AvatarPromptResult.Success and GreenbeanCheck.IsGreenbeanDescription(p4) then
        Networking.Greenbean.Action:Fire("LoadAvatar");
    end;
end);
Networking.Greenbean.Action.OnClientEvent:Connect(function(p5) -- Line: 25
    -- upvalues: MarketplaceService (copy), u2 (ref), AvatarEditorService (copy), GreenbeanHumanoidDescription (copy)
    if p5 == "PromptBulkPurchase" then
        MarketplaceService.PromptBulkPurchaseFinished:Once(function(p6, p7, p8) -- Line: 27
            -- upvalues: u2 (ref), AvatarEditorService (ref), GreenbeanHumanoidDescription (ref)
            if p7 ~= Enum.MarketplaceBulkPurchasePromptStatus.Completed or u2 then
                return;
            end;

            u2 = true;
            pcall(function() -- Line: 33
                -- upvalues: AvatarEditorService (ref), GreenbeanHumanoidDescription (ref)
                AvatarEditorService:PromptSaveAvatar(GreenbeanHumanoidDescription, Enum.HumanoidRigType.R6);
            end);
        end);

        return;
    end;

    if p5 == "PromptSaveAvatar" then
        if u2 then
            return;
        end;

        u2 = true;
        pcall(function() -- Line: 43
            -- upvalues: AvatarEditorService (ref), GreenbeanHumanoidDescription (ref)
            AvatarEditorService:PromptSaveAvatar(GreenbeanHumanoidDescription, Enum.HumanoidRigType.R6);
        end);
    end;
end);
local u9 = nil;

local function getItemsToPrompt(p10) -- Line: 50
    -- upvalues: u9 (ref), MarketplaceService (copy), LocalPlayer (copy)
    if u9 then
        return u9;
    end;

    local v11 = {};

    for _, v in p10 do
        local v12 = false;
        local v13 = false;

        if v.Type == Enum.MarketplaceProductType.AvatarAsset then
            v12, v13 = pcall(function() -- Line: 59
                -- upvalues: MarketplaceService (ref), LocalPlayer (ref), v (copy)
                return MarketplaceService:PlayerOwnsAsset(LocalPlayer, (tonumber(v.Id)));
            end);
        elseif v.Type == Enum.MarketplaceProductType.AvatarBundle then
            v12, v13 = pcall(function() -- Line: 63
                -- upvalues: MarketplaceService (ref), LocalPlayer (ref), v (copy)
                return MarketplaceService:PlayerOwnsBundle(LocalPlayer, (tonumber(v.Id)));
            end);
        end;

        if not (v12 and v13) then
            table.insert(v11, v);
        end;
    end;

    u9 = v11;
    task.delay(20, function() -- Line: 74
        -- upvalues: u9 (ref)
        u9 = nil;
    end);

    return v11;
end;

function v1.Prompt(p14) -- Line: 81
    -- upvalues: u2 (ref), getItemsToPrompt (copy), GreenbeanAvatarItems (copy), Networking (copy)
    if u2 then
        return;
    end;

    if #getItemsToPrompt(GreenbeanAvatarItems) == 0 then
        Networking.Greenbean.Action:Fire("PromptSaveAvatar");

        return;
    end;

    Networking.Greenbean.Action:Fire("PromptBulkPurchase");
end;

return v1;