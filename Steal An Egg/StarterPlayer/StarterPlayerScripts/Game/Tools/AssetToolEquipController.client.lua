-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AssetCmds = require(ReplicatedStorage.Library.Client.AssetCmds);
local Assets = require(ReplicatedStorage.Directory.Assets);
local AssetPlacementHints = require(script.Parent.Parent.Plots.ActiveAssetsController.AssetPlacementHints);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local Player = require(ReplicatedStorage.Library.Player);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = Color3.fromRGB(85, 255, 85);
local u2 = Color3.fromRGB(255, 70, 70);
local LocalPlayer = Players.LocalPlayer;
local u3 = Trove.new();
local u4 = Trove.new();
local u5 = nil;
local u6 = nil;

local function isAssetTool(p7) -- Line: 32
    return p7:GetAttribute("ItemType") == "Asset";
end;

local function getAssetToolUid(p8) -- Line: 36
    local v9 = p8:GetAttribute("UID");

    if typeof(v9) == "string" and v9 ~= "" then
        return v9;
    end;

    return nil;
end;

local function getAssetToolCategory(p10) -- Line: 41
    local v11 = p10:GetAttribute("Category");

    if typeof(v11) == "string" and v11 ~= "" then
        return v11;
    end;

    return nil;
end;

local function isNearPetAreaSurface(p12, p13) -- Line: 46
    local v14 = p12.CFrame:PointToObjectSpace(p13);
    local v15 = p12.Size * 0.5;
    local v16 = math.clamp(v14.X, -v15.X, v15.X);
    local v17 = math.clamp(v14.Y, -v15.Y, v15.Y);
    local v18 = math.clamp(v14.Z, -v15.Z, v15.Z);
    local v19 = Vector3.new(v16, v17, v18);

    return (p13 - p12.CFrame:PointToWorldSpace(v19)).Magnitude <= 20;
end;

local function showGetCloserNotification() -- Line: 59
    -- upvalues: Message (copy), u2 (copy)
    Message.Bottom({
        Message = "Get closer to your Pen to place pets!",
        Time = 2,
        PreventDuplicateText = true,
        Color = u2
    });
end;

local function showEquipSuccessNotification(p20) -- Line: 68
    -- upvalues: Assets (copy), Message (copy), u1 (copy)
    local v21 = p20:GetAttribute("Category");

    if typeof(v21) ~= "string" or v21 == "" then
        v21 = nil;
    end;

    if v21 == nil then
        return;
    end;

    local v22 = Assets.Directory[v21];

    if v22.DisplayName ~= "" then
        v21 = v22.DisplayName;
    end;

    local v23;

    if v22.Rarity then
        v23 = v22.Rarity.Color;
    else
        v23 = Color3.new(1, 1, 1);
    end;

    Message.Bottom({
        Time = 2,
        Message = `Sucessfully equipped <font color="#{v23:ToHex()}">{v21}!</font>`,
        Color = u1
    });
end;

local function showEquipErrorNotification(p24) -- Line: 84
    -- upvalues: Message (copy), u2 (copy)
    Message.Bottom({
        Time = 2,
        PreventDuplicateText = true,
        Message = p24,
        Color = u2
    });
end;

local function tryEquipToolAsset(p25) -- Line: 93
    -- upvalues: u6 (ref), Player (copy), LocalPlayer (copy), AssetCmds (copy), isNearPetAreaSurface (copy), Message (copy), u2 (copy), AssetPlacementHints (copy), u5 (ref), showEquipSuccessNotification (copy), u4 (copy)
    local v26 = p25:GetAttribute("UID");

    if typeof(v26) ~= "string" or v26 == "" then
        v26 = nil;
    end;

    if v26 == nil or u6 == v26 then
        return;
    end;

    local v27 = Player.Optional.HumanoidRootPart(LocalPlayer);

    if v27 ~= nil and not v27:IsA("BasePart") then
        return;
    end;

    local v28 = AssetCmds.ResolveAssetArea(LocalPlayer);

    if v27 == nil or v28 == nil then
        return;
    end;

    if not isNearPetAreaSurface(v28, v27.Position) then
        Message.Bottom({
            Message = "Get closer to your Pen to place pets!",
            Time = 2,
            PreventDuplicateText = true,
            Color = u2
        });

        return;
    end;

    u6 = v26;
    AssetPlacementHints.SetFrontPlacement(v26, v27.CFrame);
    local v29, v30 = AssetCmds.RequestEquipAsset(v26);

    if u6 == v26 then
        u6 = nil;
    end;

    if not v29 then
        AssetPlacementHints.ClearFrontPlacement(v26);

        if v30 ~= nil then
            Message.Bottom({
                Time = 2,
                PreventDuplicateText = true,
                Message = v30,
                Color = u2
            });
        end;
    end;

    if v29 and u5 == p25 then
        showEquipSuccessNotification(p25);
        u4:Clean();
        u5 = nil;
    end;
end;

local function bindTool(u31) -- Line: 133
    -- upvalues: u4 (copy), u5 (ref), tryEquipToolAsset (copy)
    u4:Clean();
    u5 = u31;
    u4:Connect(u31.Activated, function() -- Line: 136
        -- upvalues: tryEquipToolAsset (ref), u31 (copy)
        tryEquipToolAsset(u31);
    end);
end;

local function refreshCharacter(p32) -- Line: 141
    -- upvalues: u4 (copy), u5 (ref), tryEquipToolAsset (copy)
    u4:Clean();
    u5 = nil;
    local u33 = p32:FindFirstChildOfClass("Tool");

    if u33 ~= nil and u33:GetAttribute("ItemType") == "Asset" then
        u4:Clean();
        u5 = u33;
        u4:Connect(u33.Activated, function() -- Line: 136
            -- upvalues: tryEquipToolAsset (ref), u33 (copy)
            tryEquipToolAsset(u33);
        end);
    end;
end;

local function bindCharacter(p34) -- Line: 150
    -- upvalues: u3 (copy), u4 (copy), u5 (ref), tryEquipToolAsset (copy)
    u3:Clean();
    u4:Clean();
    u5 = nil;
    local u35 = p34:FindFirstChildOfClass("Tool");

    if u35 ~= nil and u35:GetAttribute("ItemType") == "Asset" then
        u4:Clean();
        u5 = u35;
        u4:Connect(u35.Activated, function() -- Line: 136
            -- upvalues: tryEquipToolAsset (ref), u35 (copy)
            tryEquipToolAsset(u35);
        end);
    end;

    u3:Connect(p34.ChildAdded, function(u36) -- Line: 154
        -- upvalues: u4 (ref), u5 (ref), tryEquipToolAsset (ref)
        if u36:IsA("Tool") and u36:GetAttribute("ItemType") == "Asset" then
            u4:Clean();
            u5 = u36;
            u4:Connect(u36.Activated, function() -- Line: 136
                -- upvalues: tryEquipToolAsset (ref), u36 (copy)
                tryEquipToolAsset(u36);
            end);
        end;
    end);
    u3:Connect(p34.ChildRemoved, function(p37) -- Line: 160
        -- upvalues: u5 (ref), u4 (ref)
        if p37 == u5 then
            u4:Clean();
            u5 = nil;
        end;
    end);
end;

LocalPlayer.CharacterAdded:Connect(bindCharacter);
LocalPlayer.CharacterRemoving:Connect(function() -- Line: 173
    -- upvalues: u3 (copy), u4 (copy), u5 (ref), u6 (ref)
    u3:Clean();
    u4:Clean();
    u5 = nil;
    u6 = nil;
end);

if LocalPlayer.Character ~= nil then
    bindCharacter(LocalPlayer.Character);
end;