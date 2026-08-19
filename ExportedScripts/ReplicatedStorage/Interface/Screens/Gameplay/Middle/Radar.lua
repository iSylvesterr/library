-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local GuiService = game:GetService("GuiService");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local u2 = table.find(GetUserPlatform(), "Mobile") and #GetUserPlatform() <= 1;
local Radar = ReplicatedStorage.Assets.UI.Radar;
local CurrentCamera = workspace.CurrentCamera;

local function GetCurrentCamera() -- Line: 52
    -- upvalues: CurrentCamera (ref), Workspace (copy)
    CurrentCamera = Workspace.CurrentCamera;

    return CurrentCamera;
end;

local u3 = u2 and 120 or 200;

local function GetEffectiveScale(p4) -- Line: 65
    -- upvalues: u2 (copy)
    if u2 then
        return (p4 - 1) * 0.5 + 1;
    end;

    return p4;
end;

local function RoundToPixel(p5) -- Line: 74
    return math.floor(p5 + 0.5);
end;

local Debris = Workspace:WaitForChild("Debris");

local function GetRunningCircleBaseRadius() -- Line: 88
    -- upvalues: u2 (copy)
    return u2 and 30 or 50;
end;

local function GetKnifeCircleRadius() -- Line: 94
    -- upvalues: u2 (copy)
    return u2 and 21 or 35;
end;

local u6 = {
    Vertigo = 387,
    ["Winter Vertigo"] = 387,
    Reactor = 67.388
};

local function IsMirageMap(p7) -- Line: 138
    return p7 == "Mirage" and true or p7 == "Winter Mirage";
end;

local function IsVertigoMap(p8) -- Line: 142
    return p8 == "Vertigo" and true or p8 == "Winter Vertigo";
end;

local function GetUpperLayerHeight(p9) -- Line: 147
    -- upvalues: u6 (copy)
    if p9 then
        return u6[p9];
    end;

    return nil;
end;

local function MapHasUpperLayer(p10) -- Line: 154
    -- upvalues: u6 (copy)
    local v11;

    if p10 then
        v11 = u6[p10];
    else
        v11 = nil;
    end;

    return v11 ~= nil;
end;

local function IsSeasideMap(p12) -- Line: 158
    return p12 == "Seaside";
end;

local function IsDust2Map(p13) -- Line: 162
    return p13 == "Dust 2";
end;

local function IsDeathmatchGamemode() -- Line: 166
    -- upvalues: Workspace (copy)
    return Workspace:GetAttribute("Gamemode") == "Deathmatch" and true or Workspace:GetAttribute("ServerGamemode") == "Deathmatch";
end;

local u14 = Color3.fromRGB(255, 0, 0);
local u15 = nil;
local u16 = {
    CentersPlayer = true,
    Rotation = false,
    Zoom = 0.7,
    Scale = 1
};
local u17 = nil;

local function GetMinimapReference() -- Line: 230
    -- upvalues: CollectionService (copy)
    local Map = workspace:FindFirstChild("Map");

    if not Map then
        return nil;
    end;

    local v18 = CollectionService:GetTagged("Minimap");

    for _, v in ipairs(v18) do
        if v:IsA("BasePart") and v:IsDescendantOf(Map) then
            local Lower = v:FindFirstChild("Lower");
            local Upper = v:FindFirstChild("Upper");
            local v19 = v:GetAttribute("TextureSize");
            local v20 = (typeof(v19) ~= "number" or v19 <= 0) and 1024 or v19;

            return {
                Size = v.Size,
                Upper = Upper,
                Lower = Lower,
                Part = v,
                TextureSize = v20
            };
        end;
    end;

    return nil;
end;

local function GetTeammateDisplayColor(p21, p22) -- Line: 267
    -- upvalues: Colors (copy)
    local Character = p21.Character;

    if p22 then
        return Character and Character:GetAttribute("CompetitivePlayerColor") or Colors["Team Color"][p22];
    end;

    return nil;
end;

local function createRadarForCharacter(u23, p24, p25) -- Line: 285
    -- upvalues: Profiler (copy), u17 (ref), u1 (copy), u15 (ref)
    Profiler.mark("UI.Radar.CreateRadarForCharacter");

    if u17 then
        u17:Destroy();
        u17 = nil;
    end;

    u17 = u1.new(u15, u23);

    if u17 then
        u17.LocalPlayer = p24;
        u17.Team = p24:GetAttribute("Team");
        u17.IsSpectating = p25 or false;

        if p25 then
            u17.MapImage.Rotation = 90;

            if u17.UpperMapImage then
                u17.UpperMapImage.Rotation = 90;
            end;
        end;
    end;

    if u17 and u23 then
        u17.Janitor:Add(u23:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 314
            -- upvalues: u17 (ref), u23 (copy)
            if u17 and u23:GetAttribute("Dead") then
                u17:Destroy();
                u17 = nil;
            end;
        end));
    end;
end;

local function GetSiteParts() -- Line: 325
    -- upvalues: CollectionService (copy)
    local v26 = CollectionService:GetTagged("PlantArea");
    local v27 = {};

    for _, v in ipairs(v26) do
        if v:IsA("BasePart") then
            local v28 = v:GetAttribute("Site");

            if v28 and (v28 == "A" or v28 == "B") then
                if not v27[v28] then
                    v27[v28] = {};
                end;

                table.insert(v27[v28], v.CFrame);
            end;
        end;
    end;

    return v27;
end;

local function GetSiteCenter(p29) -- Line: 347
    if #p29 == 0 then
        return Vector3.new(0, 0, 0);
    end;

    local v30 = Vector3.new(0, 0, 0);

    for _, v in ipairs(p29) do
        v30 = v30 + v.Position;
    end;

    return v30 / #p29;
end;

local function PlayerHasBomb(p31) -- Line: 364
    -- upvalues: HttpService (copy)
    local v32 = p31:GetAttribute("Slot5");

    if not v32 then
        return false;
    end;

    local v33 = HttpService:JSONDecode(v32 or "[]");

    if v33 then
        v33 = v33.Weapon == "C4";
    end;

    return v33;
end;

local function PlayerIsCarryingHostage(p34) -- Line: 378
    return p34:GetAttribute("IsCarryingHostage") == true;
end;

local function DoesRaycastIntersectSmoke(p35, p36, p37) -- Line: 385
    -- upvalues: Debris (copy)
    local function RayIntersectsAABB(p38, p39, p40, p41, p42) -- Line: 387
        local v43 = 0;
        local v44, v45;

        if math.abs(p39.X) < 0.0001 then
            if p38.X < p40.X or p38.X > p41.X then
                return false;
            end;

            v44 = p42;
            v45 = v43;
        else
            local v46 = 1 / p39.X;
            v44 = (p40.X - p38.X) * v46;
            v45 = (p41.X - p38.X) * v46;

            if v45 >= v44 then
                local v47 = v44;
                v44 = v45;
                v45 = v47;
            end;

            if v43 >= v45 then
                v45 = v43;
            end;

            if v44 >= p42 then
                v44 = p42;
            end;

            if v44 < v45 then
                return false;
            end;
        end;

        if math.abs(p39.Y) < 0.0001 then
            if p38.Y < p40.Y or p38.Y > p41.Y then
                return false;
            end;
        else
            local v48 = 1 / p39.Y;
            local v49 = (p40.Y - p38.Y) * v48;
            local v50 = (p41.Y - p38.Y) * v48;

            if v50 >= v49 then
                local v51 = v49;
                v49 = v50;
                v50 = v51;
            end;

            if v45 >= v50 then
                v50 = v45;
            end;

            if v49 >= v44 then
                v49 = v44;
            end;

            if v49 < v50 then
                return false;
            end;

            v44 = v49;
            v45 = v50;
        end;

        if math.abs(p39.Z) < 0.0001 then
            if p38.Z < p40.Z or p38.Z > p41.Z then
                return false;
            end;
        else
            local v52 = 1 / p39.Z;
            local v53 = (p40.Z - p38.Z) * v52;
            local v54 = (p41.Z - p38.Z) * v52;

            if v54 >= v53 then
                local v55 = v53;
                v53 = v54;
                v54 = v55;
            end;

            if v45 >= v54 then
                v54 = v45;
            end;

            if v53 >= v44 then
                v53 = v44;
            end;

            if v53 < v54 then
                return false;
            end;

            v45 = v54;
        end;

        local v56;

        if v45 >= 0 then
            v56 = v45 <= p42;
        else
            v56 = false;
        end;

        return v56;
    end;

    local v57 = Debris;

    if v57 then
        for _, child in ipairs(v57:GetChildren()) do
            if child.Name:match("^VoxelSmoke_") and child:IsA("Folder") then
                for _, child2 in ipairs(child:GetChildren()) do
                    if child2:IsA("BasePart") and child2.Name == "SmokeVoxel" then
                        local Size = child2.Size;
                        local Position = child2.Position;

                        if RayIntersectsAABB(p35, p36, Position - Size / 2, Position + Size / 2, p37) then
                            return true;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return false;
end;

local function ReadCachedVisibility(p58, p59) -- Line: 501
    if p58 and p59 - p58.UpdatedAt <= 0.1 then
        return p58.Visible;
    end;

    return nil;
end;

local u60 = nil;
local u61 = nil;
local u62 = nil;

local function GetEnemyVisibility(p63, p64, p65, p66, p67) -- Line: 513
    -- upvalues: u60 (ref)
    local v68 = p63.EnemyVisibilityCache[p64];
    local v69;

    if v68 and p67 - v68.UpdatedAt <= 0.1 then
        v69 = v68.Visible;
    else
        v69 = nil;
    end;

    if v69 ~= nil then
        return v69;
    end;

    local v70 = u60(p65, p66, p63.Team);
    p63.EnemyVisibilityCache[p64] = {
        Visible = v70,
        UpdatedAt = p67
    };

    return v70;
end;

local function GetBombVisibility(p71, p72, p73, p74) -- Line: 533
    -- upvalues: u61 (ref)
    local BombVisibilityCache = p71.BombVisibilityCache;
    local v75;

    if BombVisibilityCache and p74 - BombVisibilityCache.UpdatedAt <= 0.1 then
        v75 = BombVisibilityCache.Visible;
    else
        v75 = nil;
    end;

    if v75 ~= nil then
        return v75;
    end;

    local v76 = u61(p72, p73, p71.Character, p71.LocalPlayer);
    p71.BombVisibilityCache = {
        Visible = v76,
        UpdatedAt = p74
    };

    return v76;
end;

local function GetHostageVisibility(p77, p78, p79, p80, p81) -- Line: 547
    -- upvalues: u62 (ref)
    local v82 = p77.HostageVisibilityCache[p78];
    local v83;

    if v82 and p81 - v82.UpdatedAt <= 0.1 then
        v83 = v82.Visible;
    else
        v83 = nil;
    end;

    if v83 ~= nil then
        return v83;
    end;

    local v84 = u62(p79, p80, p77.Character, p77.LocalPlayer);
    p77.HostageVisibilityCache[p78] = {
        Visible = v84,
        UpdatedAt = p81
    };

    return v84;
end;

u60 = function(p85, p86, p87) -- Line: 569
    -- upvalues: Players (copy), DoesRaycastIntersectSmoke (copy), CollectionService (copy), Workspace (copy)
    if not (p85 and p85.PrimaryPart) then
        return false;
    end;

    local v88 = p85.PrimaryPart.Position + Vector3.new(0, 1.5, 0);

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= p86 and v:GetAttribute("Team") == p87 then
            local Character = v.Character;

            if Character and Character.PrimaryPart then
                local PrimaryPart = Character.PrimaryPart;
                local v89 = PrimaryPart.Position + Vector3.new(0, 1.5, 0);
                local Magnitude = (v88 - v89).Magnitude;

                if Magnitude <= 200 then
                    local Unit = (v88 - v89).Unit;

                    if Unit:Dot(PrimaryPart.CFrame.LookVector) > 0.5 and not DoesRaycastIntersectSmoke(v89, Unit, Magnitude) then
                        local v90 = CollectionService:GetTagged("Hostage");
                        local v91 = { Character, p85 };

                        for _, v2 in ipairs(v90) do
                            if v2:IsA("Model") then
                                table.insert(v91, v2);
                            end;
                        end;

                        local v92 = RaycastParams.new();
                        v92.FilterType = Enum.RaycastFilterType.Exclude;
                        v92.FilterDescendantsInstances = v91;
                        local v93 = Workspace:Raycast(v89, Unit * Magnitude, v92);

                        if not v93 or v93.Instance:IsDescendantOf(p85) then
                            return true;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return false;
end;

u61 = function(p94, p95, p96, p97) -- Line: 642
    -- upvalues: LocalPlayer (copy), Players (copy), CurrentCamera (ref), Workspace (copy), CollectionService (copy), DoesRaycastIntersectSmoke (copy)
    local v98 = p97 or LocalPlayer;

    for _, v in ipairs(Players:GetPlayers()) do
        if v:GetAttribute("Team") == "Counter-Terrorists" then
            local Character = v.Character;

            if Character and Character.PrimaryPart then
                local v99, v100, v101, v102, v103, v104, v105;

                if v == v98 then
                    CurrentCamera = Workspace.CurrentCamera;
                    local v106 = CurrentCamera;

                    if v106 then
                        local CFrame = v106.CFrame;
                        v99 = CFrame.Position;
                        local LookVector = CFrame.LookVector;
                        local v107 = p94 - v99;
                        v100 = v107.Magnitude;

                        if v100 <= 200 and v100 > 0 then
                            v101 = v107.Unit;

                            if v101:Dot(LookVector) > 0.5 then
                                v102 = { Character };

                                if p95 then
                                    table.insert(v102, p95);
                                end;

                                v103 = CollectionService:GetTagged("Hostage");

                                for i, v2 in ipairs(v103) do
                                    if v2:IsA("Model") then
                                        table.insert(v102, v2);
                                    end;
                                end;

                                if not DoesRaycastIntersectSmoke(v99, v101, v100) then
                                    v104 = RaycastParams.new();
                                    v104.FilterType = Enum.RaycastFilterType.Exclude;
                                    v104.FilterDescendantsInstances = v102;
                                    v105 = Workspace:Raycast(v99, v101 * v100, v104);

                                    if not v105 then
                                        return true;
                                    end;

                                    if p95 and v105.Instance:IsDescendantOf(p95) then
                                        return true;
                                    end;
                                end;
                            end;
                        end;
                    end;
                else
                    local PrimaryPart = Character.PrimaryPart;
                    v99 = PrimaryPart.Position + Vector3.new(0, 1.5, 0);
                    local LookVector = PrimaryPart.CFrame.LookVector;
                    local v108 = p94 - v99;
                    v100 = v108.Magnitude;

                    if v100 <= 200 and v100 > 0 then
                        v101 = v108.Unit;

                        if v101:Dot(LookVector) > 0.5 then
                            v102 = { Character };

                            if p95 then
                                table.insert(v102, p95);
                            end;

                            v103 = CollectionService:GetTagged("Hostage");

                            for i, v2 in ipairs(v103) do
                                if v2:IsA("Model") then
                                    table.insert(v102, v2);
                                end;
                            end;

                            if not DoesRaycastIntersectSmoke(v99, v101, v100) then
                                v104 = RaycastParams.new();
                                v104.FilterType = Enum.RaycastFilterType.Exclude;
                                v104.FilterDescendantsInstances = v102;
                                v105 = Workspace:Raycast(v99, v101 * v100, v104);

                                if not v105 then
                                    return true;
                                end;

                                if p95 and v105.Instance:IsDescendantOf(p95) then
                                    return true;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return false;
end;

u62 = function(p109, p110, p111, p112) -- Line: 758
    -- upvalues: LocalPlayer (copy), Players (copy), CurrentCamera (ref), Workspace (copy), CollectionService (copy), DoesRaycastIntersectSmoke (copy)
    local v113 = p112 or LocalPlayer;

    for _, v in ipairs(Players:GetPlayers()) do
        if v:GetAttribute("Team") == "Terrorists" then
            local Character = v.Character;

            if Character and Character.PrimaryPart then
                local v114, v115, v116, v117, v118, v119, v120;

                if v == v113 then
                    CurrentCamera = Workspace.CurrentCamera;
                    local v121 = CurrentCamera;

                    if v121 then
                        local CFrame = v121.CFrame;
                        v114 = CFrame.Position;
                        local LookVector = CFrame.LookVector;
                        local v122 = p109 - v114;
                        v115 = v122.Magnitude;

                        if v115 <= 200 and v115 > 0 then
                            v116 = v122.Unit;

                            if v116:Dot(LookVector) > 0.5 then
                                v117 = CollectionService:GetTagged("Hostage");
                                v118 = { Character };

                                for i, v2 in ipairs(v117) do
                                    if v2:IsA("Model") then
                                        table.insert(v118, v2);
                                    end;
                                end;

                                if not DoesRaycastIntersectSmoke(v114, v116, v115) then
                                    v119 = RaycastParams.new();
                                    v119.FilterType = Enum.RaycastFilterType.Exclude;
                                    v119.FilterDescendantsInstances = v118;
                                    v120 = Workspace:Raycast(v114, v116 * v115, v119);

                                    if not v120 then
                                        return true;
                                    end;

                                    if p110 and v120.Instance:IsDescendantOf(p110) then
                                        return true;
                                    end;
                                end;
                            end;
                        end;
                    end;
                else
                    local PrimaryPart = Character.PrimaryPart;
                    v114 = PrimaryPart.Position + Vector3.new(0, 1.5, 0);
                    local LookVector = PrimaryPart.CFrame.LookVector;
                    local v123 = p109 - v114;
                    v115 = v123.Magnitude;

                    if v115 <= 200 and v115 > 0 then
                        v116 = v123.Unit;

                        if v116:Dot(LookVector) > 0.5 then
                            v117 = CollectionService:GetTagged("Hostage");
                            v118 = { Character };

                            for i, v2 in ipairs(v117) do
                                if v2:IsA("Model") then
                                    table.insert(v118, v2);
                                end;
                            end;

                            if not DoesRaycastIntersectSmoke(v114, v116, v115) then
                                v119 = RaycastParams.new();
                                v119.FilterType = Enum.RaycastFilterType.Exclude;
                                v119.FilterDescendantsInstances = v118;
                                v120 = Workspace:Raycast(v114, v116 * v115, v119);

                                if not v120 then
                                    return true;
                                end;

                                if p110 and v120.Instance:IsDescendantOf(p110) then
                                    return true;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return false;
end;

local function CreateIcon(p124, p125, p126) -- Line: 871
    -- upvalues: Radar (copy)
    local v127 = nil;

    if p125 == "Teammate" then
        v127 = Radar.Player:Clone();
        v127.ZIndex = 14;
    elseif p125 == "Enemy" then
        v127 = Radar.Enemy:Clone();
        v127.ZIndex = 17;
    elseif p125 == "DeadTeammate" then
        v127 = Radar.Dead:Clone();
        v127.ZIndex = 13;
    end;

    if not v127 then
        error((`Invalid icon type: {p125}`));
    end;

    v127.Position = UDim2.fromScale(0.5, 0.5);
    v127.AnchorPoint = Vector2.new(0.5, 0.5);
    v127.Size = UDim2.fromOffset(p126, p126);
    v127.Parent = p124;

    for _, child in ipairs(v127:GetChildren()) do
        if child.Name == "Direction" and child:IsA("ImageLabel") then
            child.Visible = false;
        end;
    end;

    return v127;
end;

local function GetYawUIDeg(p128, p129) -- Line: 909
    local v130 = Vector3.new(p128.X, 0, p128.Z);
    local v131 = v130.Magnitude < 1e-6 and Vector3.new(0, 0, 1) or v130.Unit;

    if p129 then
        v131 = p129.CFrame:VectorToObjectSpace(v131);
    end;

    local v132 = math.atan2(-v131.Z, -v131.X);

    return (math.deg(v132) + 90) % 360;
end;

function u1.WorldToRadar(p133, p134) -- Line: 949
    if not p133.MinimapReference then
        return nil;
    end;

    if not (p133.Character and p133.Character.PrimaryPart) then
        return nil;
    end;

    local MinimapReference = p133.MinimapReference;
    local Size = MinimapReference.Size;

    if Size.X == 0 or Size.Z == 0 then
        return nil;
    end;

    local ImageRectSize = p133.MapImage.ImageRectSize;

    if ImageRectSize.X == 0 or ImageRectSize.Y == 0 then
        return nil;
    end;

    local v135 = MinimapReference.Part.CFrame:PointToObjectSpace(p134);
    local TextureSize = MinimapReference.TextureSize;
    local ImageRectOffset = p133.MapImage.ImageRectOffset;
    local v136 = ((-v135.X / Size.X + 0.5) * TextureSize - ImageRectOffset.X) / ImageRectSize.X;
    local v137 = ((-v135.Z / Size.Z + 0.5) * TextureSize - ImageRectOffset.Y) / ImageRectSize.Y;

    if p133.MapImage.Rotation ~= 0 then
        local v138 = math.rad(p133.MapImage.Rotation);
        local v139 = math.cos(v138);
        local v140 = math.sin(v138);
        local v141 = v136 - 0.5;
        local v142 = v137 - 0.5;
        v136 = 0.5 + (v141 * v139 - v142 * v140);
        v137 = 0.5 + (v141 * v140 + v142 * v139);
    end;

    return Vector2.new(v136, v137);
end;

local function CalculateClampedPosition(p143, p144, p145) -- Line: 1006
    -- upvalues: CurrentCamera (ref), Workspace (copy), GuiService (copy)
    CurrentCamera = Workspace.CurrentCamera;
    local v146 = CurrentCamera;
    local v147;

    if v146 then
        v147 = v146.ViewportSize;
    else
        v147 = p143.AbsoluteSize;
    end;

    local X = v147.X;
    local Y = v147.Y;

    if X <= 0 or Y <= 0 then
        return p145;
    end;

    local X2 = GuiService:GetGuiInset().X;
    local v148 = X2 + 50;
    local v149 = p143.AnchorPoint or Vector2.new(0, 0);
    local v150;

    if p145.X.Scale == 0 then
        v150 = p145.X.Offset;
    else
        v150 = p145.X.Scale * X + p145.X.Offset;
    end;

    local v151;

    if p145.Y.Scale == 0 then
        v151 = p145.Y.Offset;
    else
        v151 = p145.Y.Scale * Y + p145.Y.Offset;
    end;

    local v152, v153, v154, v155;

    if v149.X == 0 and v149.Y == 0 then
        v152 = v150 + p144;
        v153 = v151 + p144;
        v154 = v151;
        v155 = v150;
    elseif v149.X == 0.5 and v149.Y == 0.5 then
        v155 = v150 - p144 / 2;
        v154 = v151 - p144 / 2;
        v152 = v150 + p144 / 2;
        v153 = v151 + p144 / 2;
    else
        v155 = v150 - v149.X * p144;
        v154 = v151 - v149.Y * p144;
        v152 = v155 + p144;
        v153 = v154 + p144;
    end;

    local v156 = 0;
    local v157 = v155 >= X2 + 10 and 0 or X2 + 10 - v155;

    if X - 0 - 10 < v152 then
        v157 = X - 0 - 10 - v152;
    end;

    if v154 < v148 + 10 then
        v156 = v148 + 10 - v154;
    end;

    if Y - 0 - 10 < v153 then
        v156 = Y - 0 - 10 - v153;
    end;

    local v158 = v150 + v157;
    local v159 = v151 + v156;
    local v160;

    if p145.X.Scale == 0 then
        v160 = UDim.new(0, v158);
    else
        v160 = UDim.new(0, v158);
    end;

    local v161;

    if p145.Y.Scale == 0 then
        v161 = UDim.new(0, v159);
    else
        v161 = UDim.new(0, v159);
    end;

    return UDim2.new(v160, v161);
end;

function u1.UpdateIcon(p162, p163, p164, p165) -- Line: 1131
    local v166 = p162.Icons[p163];

    if not v166 then
        return;
    end;

    local v167 = p162:WorldToRadar(p164);

    if not v167 then
        v166.Instance.Visible = false;

        return;
    end;

    local v168 = v167.X - 0.5;
    local v169 = v167.Y - 0.5;
    local v170 = math.sqrt(v168 * v168 + v169 * v169);
    local X = v167.X;
    local Y = v167.Y;

    if v170 > 0.5 then
        X = 0.5 + v168 / v170 * 0.5;
        Y = 0.5 + v169 / v170 * 0.5;
    end;

    v166.Instance.Visible = true;
    v166.Instance.Position = UDim2.fromScale(X, Y);

    if p165 then
        v166.Instance.Rotation = math.deg(p165);
    end;
end;

function u1.UpdateTeammateIcon(p171, p172, p173, p174) -- Line: 1176
    local v175 = p171.Icons[p172];

    if not v175 then
        return;
    end;

    local Instance2 = v175.Instance;

    if not (Instance2 and Instance2:IsA("GuiObject")) then
        return;
    end;

    if not p171.MinimapReference then
        Instance2.Visible = false;

        return;
    end;

    local MinimapReference = p171.MinimapReference;
    local Size = MinimapReference.Size;
    local TextureSize = MinimapReference.TextureSize;
    local v176 = MinimapReference.Part.CFrame:PointToObjectSpace(p173);
    local ImageRectOffset = p171.MapImage.ImageRectOffset;
    local ImageRectSize = p171.MapImage.ImageRectSize;
    local v177 = ((-v176.X / Size.X + 0.5) * TextureSize - ImageRectOffset.X) / ImageRectSize.X;
    local v178 = ((-v176.Z / Size.Z + 0.5) * TextureSize - ImageRectOffset.Y) / ImageRectSize.Y;

    if p171.MapImage.Rotation ~= 0 then
        local v179 = math.rad(p171.MapImage.Rotation);
        local v180 = math.cos(v179);
        local v181 = math.sin(v179);
        local v182 = v177 - 0.5;
        local v183 = v178 - 0.5;
        v177 = 0.5 + (v182 * v180 - v183 * v181);
        v178 = 0.5 + (v182 * v181 + v183 * v180);
    end;

    local v184 = v177 - 0.5;
    local v185 = v178 - 0.5;
    local v186 = math.sqrt(v184 * v184 + v185 * v185);

    if v186 > 0.5 then
        v177 = 0.5 + v184 / v186 * 0.5;
        v178 = 0.5 + v185 / v186 * 0.5;
    end;

    Instance2.Position = UDim2.fromScale(v177, v178);
    Instance2.Visible = true;

    if p174 and Instance2:IsA("ImageLabel") then
        Instance2.Rotation = math.deg(p174);
    end;
end;

function u1.CreatePlayerIcon(p187, p188, p189) -- Line: 1279
    -- upvalues: HttpService (copy), Radar (copy), Colors (copy), CreateIcon (copy)
    local v190;

    if p189 == "Enemy" then
        local v191 = p188:GetAttribute("Slot5");
        local v192;

        if v191 then
            v192 = HttpService:JSONDecode(v191 or "[]");

            if v192 then
                v192 = v192.Weapon == "C4";
            end;
        else
            v192 = false;
        end;

        local v193 = p188:GetAttribute("IsCarryingHostage") == true;

        if v192 then
            v190 = Radar.Bomb:Clone();
            v190.Size = UDim2.fromOffset(14, 14);
        elseif v193 then
            local Hostage = Radar:FindFirstChild("Hostage");

            if Hostage and Hostage:IsA("ImageLabel") then
                v190 = Hostage:Clone();
            else
                v190 = Radar.Player:Clone();
            end;

            v190.Size = UDim2.fromOffset(30, 30);
        else
            v190 = Radar.Player:Clone();
            v190.Size = UDim2.fromOffset(12, 12);
        end;

        v190.ImageColor3 = Color3.fromRGB(255, 0, 0);
        v190.ZIndex = 17;
        v190.Position = UDim2.fromScale(0.5, 0.5);
        v190.AnchorPoint = Vector2.new(0.5, 0.5);
        v190.Parent = p187.RadarContainer;

        for _, child in ipairs(v190:GetChildren()) do
            if child.Name == "Direction" and child:IsA("ImageLabel") then
                child.Visible = false;
            end;
        end;
    else
        local v194 = p188:GetAttribute("Team");
        local Character = p188.Character;
        local v195;

        if v194 then
            v195 = Character and Character:GetAttribute("CompetitivePlayerColor") or Colors["Team Color"][v194];
        else
            v195 = nil;
        end;

        v190 = CreateIcon(p187.RadarContainer, p189, 12);

        if v195 then
            v190.ImageColor3 = v195;
        end;

        for _, child in ipairs(v190:GetChildren()) do
            if child.Name == "Direction" and child:IsA("ImageLabel") then
                child.Visible = false;
            end;
        end;
    end;

    v190.Name = p188.Name;
    local v196 = p188.UserId .. "_" .. p189;
    p187.Icons[v196] = {
        Target = nil,
        Instance = v190,
        Player = p188,
        Type = p189
    };

    return v196;
end;

function u1.RemoveIcon(p197, p198) -- Line: 1352
    local v199 = p197.Icons[p198];

    if v199 then
        v199.Instance:Destroy();
        p197.Icons[p198] = nil;
    end;
end;

function u1.RefreshPlayerIcon(p200, p201) -- Line: 1362
    local v202 = p201.UserId .. "_Player";
    local v203 = p201.UserId .. "_Dead";

    if p200.Icons[v202] then
        p200:RemoveIcon(v202);
    end;

    if p200.Icons[v203] then
        p200:RemoveIcon(v203);
    end;

    p200.EnemyVisibilityState[v202] = nil;
    p200.EnemyLastSeenPositions[v202] = nil;
    p200.EnemyLastSeenPositions[v202 .. "_Frozen"] = nil;
    p200.EnemyVisibilityCache[v202] = nil;
    p200.DeadPlayerPositions[p201.UserId] = nil;
    p200.FadedDeadIcons[v203] = nil;
end;

function u1.RefreshIconsOnTeamChange(p204) -- Line: 1390
    -- upvalues: LocalPlayer (copy), Colors (copy)
    local Team = p204.Team;
    local v205 = LocalPlayer:GetAttribute("Team");

    if not v205 then
        return;
    end;

    p204.Team = v205;

    if p204.Team == Team then
        return;
    end;

    local v206 = {};

    for i, v in pairs(p204.Icons) do
        if v.Player and v.Player ~= LocalPlayer then
            table.insert(v206, i);
        end;
    end;

    for _, v in ipairs(v206) do
        p204:RemoveIcon(v);
    end;

    p204.EnemyVisibilityState = {};
    p204.EnemyLastSeenPositions = {};
    p204.EnemyVisibilityCache = {};
    p204.HostageVisibilityCache = {};
    p204.BombVisibilityCache = nil;
    p204.DeadPlayerPositions = {};
    p204.FadedDeadIcons = {};

    if p204.Icons.LocalPlayer then
        local Instance2 = p204.Icons.LocalPlayer.Instance;
        local Team2 = p204.Team;
        local Character = p204.LocalPlayer.Character;
        local v207;

        if Team2 then
            v207 = Character and Character:GetAttribute("CompetitivePlayerColor") or Colors["Team Color"][Team2];
        else
            v207 = nil;
        end;

        if v207 then
            Instance2.ImageColor3 = v207;
        end;
    end;
end;

function u1.UpdatePlayerIcons(u208, p209) -- Line: 1441
    -- upvalues: Profiler (copy), Workspace (copy), Colors (copy), Radar (copy), HttpService (copy), Players (copy), CreateIcon (copy), TweenService (copy), GetEnemyVisibility (copy)
    Profiler.mark("UI.Radar.UpdatePlayerIcons");
    local v210 = Workspace:GetAttribute("Gamemode") == "Deathmatch" and true or Workspace:GetAttribute("ServerGamemode") == "Deathmatch";
    local v211 = tick();
    local v212 = u208.MinimapReference and u208.MinimapReference.Part;

    if u208.Character and u208.Character.PrimaryPart then
        if not u208.Icons.LocalPlayer then
            local Team = u208.Team;
            local Character = u208.LocalPlayer.Character;
            local v213;

            if Team then
                v213 = Character and Character:GetAttribute("CompetitivePlayerColor") or Colors["Team Color"][Team];
            else
                v213 = nil;
            end;

            local v214 = Radar.Player:Clone();
            v214.Position = UDim2.fromScale(0.5, 0.5);
            v214.AnchorPoint = Vector2.new(0.5, 0.5);
            v214.ZIndex = 15;
            v214.Parent = u208.RadarContainer;
            v214.Name = "LocalPlayer";

            if v213 then
                v214.ImageColor3 = v213;
            end;

            u208.Icons.LocalPlayer = {
                Target = nil,
                Type = "Teammate",
                Instance = v214,
                Player = u208.LocalPlayer
            };
        end;

        local Instance2 = u208.Icons.LocalPlayer.Instance;
        Instance2.Visible = true;
        local v215 = u208.LocalPlayer:GetAttribute("Slot5");
        local v216;

        if v215 then
            v216 = HttpService:JSONDecode(v215 or "[]");

            if v216 then
                v216 = v216.Weapon == "C4";
            end;
        else
            v216 = false;
        end;

        local ImageColor3 = Instance2.ImageColor3;

        if v216 then
            Instance2.Image = Radar.Bomb.Image;
            Instance2.Size = UDim2.fromOffset(14, 14);
            Instance2.ImageColor3 = ImageColor3;
        else
            Instance2.Image = Radar.Player.Image;
            Instance2.Size = UDim2.fromOffset(12, 12);
            Instance2.ImageColor3 = ImageColor3;
        end;

        local v217;

        if v212 and (u208.Character and u208.Character.PrimaryPart) then
            local LookVector = u208.Character.PrimaryPart.CFrame.LookVector;
            local v218 = Vector3.new(LookVector.X, 0, LookVector.Z);
            local v219 = v218.Magnitude < 1e-6 and Vector3.new(0, 0, 1) or v218.Unit;

            if v212 then
                v219 = v212.CFrame:VectorToObjectSpace(v219);
            end;

            local v220 = math.atan2(-v219.Z, -v219.X);
            v217 = (math.deg(v220) + 90) % 360 + u208.MapImage.Rotation + 0;
        else
            v217 = 0;
        end;

        u208:UpdateIcon("LocalPlayer", u208.Character.PrimaryPart.Position, (math.rad(v217)));
    end;

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= u208.LocalPlayer then
            local Character = v.Character;
            local v221;

            if Character then
                v221 = Character.PrimaryPart;
            else
                v221 = Character;
            end;

            local v222 = v:GetAttribute("Team");

            if v222 and v222 ~= "Spectators" then
                local v223 = u208.DeadPlayerPositions[v.UserId];
                local v224 = v223 ~= nil;
                local v225;

                if Character then
                    v225 = Character:GetAttribute("Dead") == true;
                else
                    v225 = false;
                end;

                if Character and (v221 and (not v225 and v224)) then
                    u208.DeadPlayerPositions[v.UserId] = nil;
                    v224 = false;
                    v223 = nil;
                end;

                local v226 = v210 or v222 ~= u208.Team;
                local u227 = v.UserId .. "_Player";
                local _ = v.UserId .. "_Dead";

                if v225 or v224 then
                    if u208.Icons[u227] then
                        local Instance2 = u208.Icons[u227].Instance;

                        if Instance2 and Instance2:IsA("GuiObject") then
                            Instance2.Visible = false;
                        end;

                        u208:RemoveIcon(u227);
                    end;

                    if not v223 and v221 then
                        v223 = v221.Position;
                        u208.DeadPlayerPositions[v.UserId] = v223;
                    end;

                    if v223 then
                        local u228 = v.UserId .. "_Dead";

                        if not (u208.Icons[u228] or u208.FadedDeadIcons[u228]) then
                            local v229 = v:GetAttribute("Team");
                            local v230 = CreateIcon(u208.RadarContainer, "DeadTeammate", 12);
                            v230.Name = v.Name .. "_Dead";
                            v230.ImageTransparency = 0;

                            for _, child in ipairs(v230:GetChildren()) do
                                if child.Name == "Direction" and child:IsA("ImageLabel") then
                                    child.Visible = false;
                                end;
                            end;

                            if v226 then
                                v230.ImageColor3 = Color3.fromRGB(255, 0, 0);
                            else
                                local Character2 = v.Character;
                                local v231;

                                if v229 then
                                    v231 = Character2 and Character2:GetAttribute("CompetitivePlayerColor") or Colors["Team Color"][v229];
                                else
                                    v231 = nil;
                                end;

                                if v231 then
                                    v230.ImageColor3 = v231;
                                end;
                            end;

                            u208.Icons[u228] = {
                                Target = nil,
                                Type = "DeadTeammate",
                                Instance = v230,
                                Player = v,
                                DefaultSize = Radar.Dead.Size
                            };

                            if v223 and u208.MinimapReference then
                                local MinimapReference = u208.MinimapReference;
                                local Size = MinimapReference.Size;
                                local TextureSize = MinimapReference.TextureSize;
                                local v232 = MinimapReference.Part.CFrame:PointToObjectSpace(v223);
                                local ImageRectOffset = u208.MapImage.ImageRectOffset;
                                local ImageRectSize = u208.MapImage.ImageRectSize;
                                local v233 = ((-v232.X / Size.X + 0.5) * TextureSize - ImageRectOffset.X) / ImageRectSize.X;
                                local v234 = ((-v232.Z / Size.Z + 0.5) * TextureSize - ImageRectOffset.Y) / ImageRectSize.Y;

                                if u208.MapImage.Rotation ~= 0 then
                                    local v235 = math.rad(u208.MapImage.Rotation);
                                    local v236 = math.cos(v235);
                                    local v237 = math.sin(v235);
                                    local v238 = v233 - 0.5;
                                    local v239 = v234 - 0.5;
                                    v233 = 0.5 + (v238 * v236 - v239 * v237);
                                    v234 = 0.5 + (v238 * v237 + v239 * v236);
                                end;

                                local v240 = v233 - 0.5;
                                local v241 = v234 - 0.5;
                                local v242 = math.sqrt(v240 * v240 + v241 * v241);

                                if v242 > 0.5 then
                                    v233 = 0.5 + v240 / v242 * 0.5;
                                    v234 = 0.5 + v241 / v242 * 0.5;
                                end;

                                v230.Position = UDim2.fromScale(v233, v234);
                                v230.Visible = true;
                            end;

                            task.delay(2, function() -- Line: 1695
                                -- upvalues: u208 (copy), u228 (copy), TweenService (ref)
                                local v243 = u208.Icons[u228];

                                if v243 and (v243.Instance and v243.Instance.Parent) then
                                    u208.FadedDeadIcons[u228] = true;
                                    local v244 = TweenService:Create(v243.Instance, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                                        ImageTransparency = 1
                                    });
                                    v244:Play();
                                    v244.Completed:Connect(function() -- Line: 1714
                                        -- upvalues: u208 (ref), u228 (ref)
                                        if u208.Icons[u228] then
                                            u208:RemoveIcon(u228);
                                        end;
                                    end);
                                end;
                            end);
                        end;
                    end;

                    if v226 then
                        u208.EnemyVisibilityState[u227] = nil;
                        u208.EnemyLastSeenPositions[u227] = nil;
                        u208.EnemyLastSeenPositions[u227 .. "_Frozen"] = nil;
                    end;
                else
                    if Character and v221 then
                        local v245 = v.UserId .. "_Dead";

                        if u208.Icons[v245] then
                            u208:RemoveIcon(v245);
                        end;

                        u208.DeadPlayerPositions[v.UserId] = nil;
                        u208.FadedDeadIcons[v245] = nil;

                        if u208.Icons[u227] and (v226 and u208.Icons[u227].Type == "Teammate") then
                            u208:RemoveIcon(u227);
                        end;

                        if not u208.Icons[u227] then
                            if v226 then
                                local v246 = u208:CreatePlayerIcon(v, "Enemy");
                                u208.Icons[u227] = u208.Icons[v246];
                                u208.Icons[v246] = nil;

                                if u208.Icons[u227] then
                                    u208.Icons[u227].Instance.Visible = false;
                                end;
                            else
                                local v247 = u208:CreatePlayerIcon(v, "Teammate");
                                u208.Icons[u227] = u208.Icons[v247];
                                u208.Icons[v247] = nil;
                            end;
                        end;
                    end;

                    local v248;

                    if Character then
                        v248 = Character:GetAttribute("Dead") == true;
                    else
                        v248 = false;
                    end;

                    if not (u208.DeadPlayerPositions[v.UserId] or v248) then
                        if v226 then
                            if u208.Icons[u227] then
                                local v249;

                                if Character then
                                    v249 = Character:GetAttribute("Dead") == true;
                                else
                                    v249 = false;
                                end;

                                local v250 = u208.DeadPlayerPositions[v.UserId];

                                if not Character and true or (v250 and true or v249) then
                                    if u208.Icons[u227] then
                                        u208:RemoveIcon(u227);
                                    end;

                                    if not v250 then
                                        if v221 then
                                            v250 = v221.Position;
                                            u208.DeadPlayerPositions[v.UserId] = v250;
                                        elseif u208.EnemyLastSeenPositions[u227] then
                                            v250 = u208.EnemyLastSeenPositions[u227];
                                            u208.DeadPlayerPositions[v.UserId] = v250;
                                        elseif u208.EnemyLastSeenPositions[u227 .. "_Frozen"] then
                                            v250 = u208.EnemyLastSeenPositions[u227 .. "_Frozen"];
                                            u208.DeadPlayerPositions[v.UserId] = v250;
                                        end;
                                    end;

                                    if v250 then
                                        local u251 = v.UserId .. "_Dead";

                                        if not (u208.Icons[u251] or u208.FadedDeadIcons[u251]) then
                                            local v252 = CreateIcon(u208.RadarContainer, "DeadTeammate", 12);
                                            v252.Name = v.Name .. "_Dead";
                                            v252.ImageTransparency = 0;

                                            for _, child in ipairs(v252:GetChildren()) do
                                                if child.Name == "Direction" and child:IsA("ImageLabel") then
                                                    child.Visible = false;
                                                end;
                                            end;

                                            v252.ImageColor3 = Color3.fromRGB(255, 0, 0);
                                            u208.Icons[u251] = {
                                                Target = nil,
                                                Type = "DeadTeammate",
                                                Instance = v252,
                                                Player = v,
                                                DefaultSize = Radar.Dead.Size
                                            };
                                            task.delay(2, function() -- Line: 1860
                                                -- upvalues: u208 (copy), u251 (copy), TweenService (ref)
                                                local v253 = u208.Icons[u251];

                                                if v253 and (v253.Instance and v253.Instance.Parent) then
                                                    u208.FadedDeadIcons[u251] = true;
                                                    local v254 = TweenService:Create(v253.Instance, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                                                        ImageTransparency = 1
                                                    });
                                                    v254:Play();
                                                    v254.Completed:Connect(function() -- Line: 1879
                                                        -- upvalues: u208 (ref), u251 (ref)
                                                        if u208.Icons[u251] then
                                                            u208:RemoveIcon(u251);
                                                        end;
                                                    end);
                                                end;
                                            end);
                                        end;
                                    end;

                                    u208.EnemyVisibilityState[u227] = nil;
                                    u208.EnemyLastSeenPositions[u227] = nil;
                                    u208.EnemyLastSeenPositions[u227 .. "_Frozen"] = nil;
                                else
                                    local v255 = GetEnemyVisibility(u208, u227, Character, v, v211);
                                    local v256 = u208.EnemyVisibilityState[u227] or false;

                                    if v255 then
                                        if u208.Icons[u227] and u208.Icons[u227].Type == "EnemyQuestionMark" then
                                            local FadeTween = u208.Icons[u227].FadeTween;

                                            if FadeTween then
                                                FadeTween:Cancel();
                                                u208.Icons[u227].FadeTween = nil;
                                            end;

                                            local Instance2 = u208.Icons[u227].Instance;

                                            if Instance2:IsA("TextLabel") then
                                                local Position = Instance2.Position;
                                                local AnchorPoint = Instance2.AnchorPoint;
                                                Instance2:Destroy();
                                                local v257 = v:GetAttribute("Slot5");
                                                local v258;

                                                if v257 then
                                                    v258 = HttpService:JSONDecode(v257 or "[]");

                                                    if v258 then
                                                        v258 = v258.Weapon == "C4";
                                                    end;
                                                else
                                                    v258 = false;
                                                end;

                                                local v259 = v:GetAttribute("IsCarryingHostage") == true;
                                                local ImageLabel = Instance.new("ImageLabel");
                                                ImageLabel.Name = v.Name .. "_Enemy";

                                                if v258 then
                                                    ImageLabel.Image = Radar.Bomb.Image;
                                                    ImageLabel.Size = UDim2.fromOffset(14, 14);
                                                elseif v259 then
                                                    local Hostage = Radar:FindFirstChild("Hostage");

                                                    if Hostage and Hostage:IsA("ImageLabel") then
                                                        ImageLabel.Image = Hostage.Image;
                                                    else
                                                        ImageLabel.Image = Radar.Player.Image;
                                                    end;

                                                    ImageLabel.Size = UDim2.fromOffset(30, 30);
                                                else
                                                    ImageLabel.Image = Radar.Player.Image;
                                                    ImageLabel.Size = UDim2.fromOffset(12, 12);
                                                end;

                                                ImageLabel.ImageColor3 = Color3.fromRGB(255, 0, 0);
                                                ImageLabel.BackgroundTransparency = 1;
                                                ImageLabel.BorderSizePixel = 0;
                                                ImageLabel.Position = Position;
                                                ImageLabel.AnchorPoint = AnchorPoint;
                                                ImageLabel.ZIndex = 17;
                                                ImageLabel.Visible = true;
                                                ImageLabel.Parent = u208.RadarContainer;
                                                u208.Icons[u227].Instance = ImageLabel;
                                                u208.Icons[u227].Type = "Enemy";
                                                u208.Icons[u227].FadeTween = nil;
                                                u208.EnemyLastSeenPositions[u227 .. "_Frozen"] = nil;
                                            end;
                                        end;

                                        if u208.Icons[u227] and v221 then
                                            local Instance2 = u208.Icons[u227].Instance;
                                            Instance2.Visible = true;
                                            local v260 = v:GetAttribute("Slot5");
                                            local v261;

                                            if v260 then
                                                v261 = HttpService:JSONDecode(v260 or "[]");

                                                if v261 then
                                                    v261 = v261.Weapon == "C4";
                                                end;
                                            else
                                                v261 = false;
                                            end;

                                            local v262 = v:GetAttribute("IsCarryingHostage") == true;
                                            Instance2.ImageColor3 = Color3.fromRGB(255, 0, 0);

                                            if v261 then
                                                Instance2.Image = Radar.Bomb.Image;
                                                Instance2.Size = UDim2.fromOffset(14, 14);
                                            elseif v262 then
                                                local Hostage = Radar:FindFirstChild("Hostage");

                                                if Hostage and Hostage:IsA("ImageLabel") then
                                                    Instance2.Image = Hostage.Image;
                                                else
                                                    Instance2.Image = Radar.Player.Image;
                                                end;

                                                Instance2.Size = UDim2.fromOffset(30, 30);
                                            else
                                                Instance2.Image = Radar.Player.Image;
                                                Instance2.Size = UDim2.fromOffset(12, 12);
                                            end;

                                            u208:UpdateTeammateIcon(u227, v221.Position, nil);
                                            u208.EnemyLastSeenPositions[u227] = v221.Position;
                                        elseif u208.Icons[u227] then
                                            u208:RemoveIcon(u227);
                                        end;
                                    else
                                        local v263;

                                        if Character then
                                            v263 = Character:GetAttribute("Dead") == true;
                                        else
                                            v263 = false;
                                        end;

                                        if not Character and true or (u208.DeadPlayerPositions[v.UserId] and true or v263) then
                                            if u208.Icons[u227] then
                                                u208:RemoveIcon(u227);
                                            end;

                                            u208.EnemyVisibilityState[u227] = nil;
                                            u208.EnemyLastSeenPositions[u227] = nil;
                                            u208.EnemyLastSeenPositions[u227 .. "_Frozen"] = nil;
                                        elseif v256 and u208.Icons[u227] then
                                            local Instance2 = u208.Icons[u227].Instance;
                                            local v264 = nil;
                                            local v265 = nil;
                                            local FadeTween = u208.Icons[u227].FadeTween;

                                            if FadeTween then
                                                FadeTween:Cancel();
                                                u208.Icons[u227].FadeTween = nil;
                                            end;

                                            if Instance2:IsA("ImageLabel") then
                                                v264 = Instance2.Position;
                                                v265 = Instance2.AnchorPoint;
                                                Instance2:Destroy();
                                            elseif Instance2:IsA("TextLabel") then
                                                v264 = Instance2.Position;
                                                v265 = Instance2.AnchorPoint;
                                                Instance2:Destroy();
                                            end;

                                            local v266 = Radar.EnemySeen:Clone();
                                            v266.Name = v.Name .. "_QuestionMark";
                                            v266.Position = v264;
                                            v266.AnchorPoint = v265;
                                            v266.ZIndex = 20;
                                            v266.TextTransparency = 0;
                                            v266.Visible = true;
                                            v266.Parent = u208.RadarContainer;
                                            u208.Icons[u227].Instance = v266;
                                            u208.Icons[u227].Type = "EnemyQuestionMark";
                                            u208.Icons[u227].FadeTween = nil;

                                            if u208.EnemyLastSeenPositions[u227] then
                                                u208.EnemyLastSeenPositions[u227 .. "_Frozen"] = u208.EnemyLastSeenPositions[u227];
                                            end;

                                            task.delay(0.1, function() -- Line: 2071
                                                -- upvalues: u208 (copy), u227 (copy), TweenService (ref)
                                                if u208.Icons[u227] and u208.Icons[u227].Instance:IsA("TextLabel") then
                                                    local Instance3 = u208.Icons[u227].Instance;
                                                    Instance3.TextTransparency = 0;
                                                    local v267 = TweenService:Create(Instance3, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                                                        TextTransparency = 1
                                                    });
                                                    v267:Play();
                                                    u208.Icons[u227].FadeTween = v267;
                                                    v267.Completed:Connect(function() -- Line: 2092
                                                        -- upvalues: u208 (ref), u227 (ref)
                                                        if u208.Icons[u227] then
                                                            u208:RemoveIcon(u227);
                                                            u208.EnemyLastSeenPositions[u227 .. "_Frozen"] = nil;
                                                        end;
                                                    end);
                                                end;
                                            end);
                                        end;

                                        if u208.Icons[u227] and u208.Icons[u227].Type == "EnemyQuestionMark" then
                                            local v268 = u208.EnemyLastSeenPositions[u227 .. "_Frozen"];

                                            if v268 then
                                                u208:UpdateQuestionMarkIcon(u227, v268);
                                            end;
                                        elseif u208.Icons[u227] then
                                            u208.Icons[u227].Instance.Visible = false;
                                        end;
                                    end;

                                    if u208.Icons[u227] then
                                        u208.EnemyVisibilityState[u227] = v255;
                                    end;
                                end;
                            end;
                        elseif u208.Icons[u227] and v221 then
                            u208:UpdateTeammateIcon(u227, v221.Position, nil);
                        elseif u208.Icons[u227] then
                            u208:RemoveIcon(u227);
                        end;
                    end;
                end;
            else
                local v269 = v.UserId .. "_Player";
                local v270 = v.UserId .. "_Dead";

                if u208.Icons[v269] then
                    u208:RemoveIcon(v269);
                end;

                if u208.Icons[v270] then
                    u208:RemoveIcon(v270);
                end;

                u208.EnemyVisibilityState[v269] = nil;
                u208.EnemyLastSeenPositions[v269] = nil;
                u208.EnemyLastSeenPositions[v269 .. "_Frozen"] = nil;
                u208.DeadPlayerPositions[v.UserId] = nil;
                u208.FadedDeadIcons[v270] = nil;
            end;
        end;
    end;

    for i, v in pairs(u208.DeadPlayerPositions) do
        local v271 = u208.Icons[i .. "_Dead"];

        if v271 and u208.MinimapReference then
            local MinimapReference = u208.MinimapReference;
            local Size = MinimapReference.Size;
            local TextureSize = MinimapReference.TextureSize;
            local v272 = MinimapReference.Part.CFrame:PointToObjectSpace(v);
            local ImageRectOffset = u208.MapImage.ImageRectOffset;
            local ImageRectSize = u208.MapImage.ImageRectSize;
            local v273 = ((-v272.X / Size.X + 0.5) * TextureSize - ImageRectOffset.X) / ImageRectSize.X;
            local v274 = ((-v272.Z / Size.Z + 0.5) * TextureSize - ImageRectOffset.Y) / ImageRectSize.Y;

            if u208.MapImage.Rotation ~= 0 then
                local v275 = math.rad(u208.MapImage.Rotation);
                local v276 = math.cos(v275);
                local v277 = math.sin(v275);
                local v278 = v273 - 0.5;
                local v279 = v274 - 0.5;
                v273 = 0.5 + (v278 * v276 - v279 * v277);
                v274 = 0.5 + (v278 * v277 + v279 * v276);
            end;

            local v280 = v273 - 0.5;
            local v281 = v274 - 0.5;
            local v282 = math.sqrt(v280 * v280 + v281 * v281);

            if v282 > 0.5 then
                v273 = 0.5 + v280 / v282 * 0.5;
                v274 = 0.5 + v281 / v282 * 0.5;
            end;

            v271.Instance.Position = UDim2.fromScale(v273, v274);
            v271.Instance.Visible = true;
        end;
    end;
end;

function u1.UpdateBombIcon(p283) -- Line: 2217
    -- upvalues: Profiler (copy), Workspace (copy), CollectionService (copy), Radar (copy), u61 (ref), u14 (copy)
    Profiler.mark("UI.Radar.UpdateBombIcon");
    local v284 = nil;
    local v285 = tick();
    local v286 = p283.Team == "Counter-Terrorists";
    local v287 = Workspace:GetAttribute("ServerGamemode") == "Competitive";
    local v288 = CollectionService:GetTagged("Bomb")[1];

    if v287 and v288 then
        v288 = nil;
    end;

    if v288 and (v288:IsA("Model") and v288.PrimaryPart) then
        v284 = v288;
    else
        local v289 = CollectionService:GetTagged("WeaponDropped");

        for _, v in ipairs(v289) do
            if v:IsA("Model") and (v.PrimaryPart and v:GetAttribute("Weapon") == "C4") then
                v284 = v;
                break;
            end;
        end;
    end;

    if v284 then
        if not p283.Icons.Bomb then
            local v290 = Radar.Bomb:Clone();
            v290.Position = UDim2.fromScale(0.5, 0.5);
            v290.AnchorPoint = Vector2.new(0.5, 0.5);
            v290.Parent = p283.RadarContainer;
            v290.Size = UDim2.fromOffset(14, 14);
            v290.ZIndex = 19;
            v290.Name = "Bomb";
            p283.Icons.Bomb = {
                Player = nil,
                Type = "Bomb",
                Instance = v290,
                Target = v284.PrimaryPart
            };
        end;

        local Bomb = p283.Icons.Bomb;

        if not p283.MinimapReference then
            Bomb.Instance.Visible = false;

            return;
        end;

        local Position = v284.PrimaryPart.Position;
        local MinimapReference = p283.MinimapReference;
        local Size = MinimapReference.Size;
        local TextureSize = MinimapReference.TextureSize;
        local v291 = MinimapReference.Part.CFrame:PointToObjectSpace(Position);
        local ImageRectOffset = p283.MapImage.ImageRectOffset;
        local ImageRectSize = p283.MapImage.ImageRectSize;
        local v292 = ((-v291.X / Size.X + 0.5) * TextureSize - ImageRectOffset.X) / ImageRectSize.X;
        local v293 = ((-v291.Z / Size.Z + 0.5) * TextureSize - ImageRectOffset.Y) / ImageRectSize.Y;

        if p283.MapImage.Rotation ~= 0 then
            local v294 = math.rad(p283.MapImage.Rotation);
            local v295 = math.cos(v294);
            local v296 = math.sin(v294);
            local v297 = v292 - 0.5;
            local v298 = v293 - 0.5;
            v292 = 0.5 + (v297 * v295 - v298 * v296);
            v293 = 0.5 + (v297 * v296 + v298 * v295);
        end;

        local v299 = v292 - 0.5;
        local v300 = v293 - 0.5;
        local v301 = math.sqrt(v299 * v299 + v300 * v300);

        if v301 > 0.5 then
            v292 = 0.5 + v299 / v301 * 0.5;
            v293 = 0.5 + v300 / v301 * 0.5;
        end;

        Bomb.Instance.Position = UDim2.fromScale(v292, v293);

        if v286 and not v288 then
            local BombVisibilityCache = p283.BombVisibilityCache;
            local v302;

            if BombVisibilityCache and v285 - BombVisibilityCache.UpdatedAt <= 0.1 then
                v302 = BombVisibilityCache.Visible;
            else
                v302 = nil;
            end;

            if v302 == nil then
                v302 = u61(Position, v284, p283.Character, p283.LocalPlayer);
                p283.BombVisibilityCache = {
                    Visible = v302,
                    UpdatedAt = v285
                };
            end;

            if v302 then
                if not p283.BombIsVisible then
                    p283.BombFadeStartTime = nil;
                end;

                p283.BombIsVisible = true;
                Bomb.Instance.Visible = true;

                if Bomb.Instance:IsA("ImageLabel") then
                    local Instance2 = Bomb.Instance;
                    Instance2.ImageTransparency = 0;
                    Instance2.ImageColor3 = u14;

                    return;
                end;

                if Bomb.Instance:IsA("ImageButton") then
                    local Instance2 = Bomb.Instance;
                    Instance2.ImageTransparency = 0;
                    Instance2.ImageColor3 = u14;

                    return;
                end;

                if Bomb.Instance:IsA("TextLabel") then
                    Bomb.Instance.TextTransparency = 0;

                    return;
                end;

                if Bomb.Instance:IsA("TextButton") then
                    Bomb.Instance.TextTransparency = 0;
                end;
            else
                if p283.BombIsVisible then
                    p283.BombFadeStartTime = v285;
                end;

                p283.BombIsVisible = false;

                if not p283.BombFadeStartTime then
                    Bomb.Instance.Visible = false;

                    return;
                end;

                local v303 = math.clamp((v285 - p283.BombFadeStartTime) / 8, 0, 1);

                if v303 >= 1 then
                    Bomb.Instance.Visible = false;

                    return;
                end;

                Bomb.Instance.Visible = true;

                if Bomb.Instance:IsA("ImageLabel") then
                    Bomb.Instance.ImageTransparency = v303;

                    return;
                end;

                if Bomb.Instance:IsA("ImageButton") then
                    Bomb.Instance.ImageTransparency = v303;

                    return;
                end;

                if Bomb.Instance:IsA("TextLabel") then
                    Bomb.Instance.TextTransparency = v303;

                    return;
                end;

                if Bomb.Instance:IsA("TextButton") then
                    Bomb.Instance.TextTransparency = v303;
                end;
            end;
        else
            Bomb.Instance.Visible = true;

            if Bomb.Instance:IsA("ImageLabel") then
                local Instance2 = Bomb.Instance;
                Instance2.ImageTransparency = 0;

                if v288 and (v286 and v301 > 0.5) then
                    Instance2.ImageColor3 = u14;
                end;
            elseif Bomb.Instance:IsA("ImageButton") then
                local Instance2 = Bomb.Instance;
                Instance2.ImageTransparency = 0;

                if v288 and (v286 and v301 > 0.5) then
                    Instance2.ImageColor3 = u14;
                end;
            else
                if Bomb.Instance:IsA("TextLabel") then
                    Bomb.Instance.TextTransparency = 0;

                    return;
                end;

                if Bomb.Instance:IsA("TextButton") then
                    Bomb.Instance.TextTransparency = 0;
                end;
            end;
        end;
    else
        if p283.Icons.Bomb then
            p283.Icons.Bomb.Instance.Visible = false;
            p283.BombIsVisible = false;
            p283.BombFadeStartTime = nil;
        end;

        p283.BombVisibilityCache = nil;
    end;
end;

function u1.UpdateQuestionMarkIcon(p304, p305, p306) -- Line: 2451
    local v307 = p304.Icons[p305];

    if not (v307 and p304.MinimapReference) then
        return;
    end;

    local Instance2 = v307.Instance;

    if not (Instance2 and Instance2:IsA("TextLabel")) then
        return;
    end;

    local MinimapReference = p304.MinimapReference;
    local Size = MinimapReference.Size;
    local TextureSize = MinimapReference.TextureSize;
    local v308 = MinimapReference.Part.CFrame:PointToObjectSpace(p306);
    local ImageRectOffset = p304.MapImage.ImageRectOffset;
    local ImageRectSize = p304.MapImage.ImageRectSize;
    local v309 = ((-v308.X / Size.X + 0.5) * TextureSize - ImageRectOffset.X) / ImageRectSize.X;
    local v310 = ((-v308.Z / Size.Z + 0.5) * TextureSize - ImageRectOffset.Y) / ImageRectSize.Y;

    if p304.MapImage.Rotation ~= 0 then
        local v311 = math.rad(p304.MapImage.Rotation);
        local v312 = math.cos(v311);
        local v313 = math.sin(v311);
        local v314 = v309 - 0.5;
        local v315 = v310 - 0.5;
        v309 = 0.5 + (v314 * v312 - v315 * v313);
        v310 = 0.5 + (v314 * v313 + v315 * v312);
    end;

    local v316 = v309 - 0.5;
    local v317 = v310 - 0.5;
    local v318 = math.sqrt(v316 * v316 + v317 * v317);

    if v318 > 0.5 then
        v309 = 0.5 + v316 / v318 * 0.5;
        v310 = 0.5 + v317 / v318 * 0.5;
    end;

    Instance2.Position = UDim2.fromScale(v309, v310);
    Instance2.Visible = true;
end;

function u1.UpdateSiteIcons(p319) -- Line: 2545
    -- upvalues: Profiler (copy), Radar (copy)
    Profiler.mark("UI.Radar.UpdateSiteIcons");

    for i, v in pairs(p319.SiteParts) do
        local v320 = "Site_" .. i;
        local v321;

        if #v == 0 then
            v321 = Vector3.new(0, 0, 0);
        else
            local v322 = Vector3.new(0, 0, 0);

            for _, v2 in ipairs(v) do
                v322 = v322 + v2.Position;
            end;

            v321 = v322 / #v;
        end;

        local v323, v324, v325, v326, v327, v328, v329, v330, v331, v332, v333, v334, v335, v336, v337, v338, v339, v340, v341, v342, v343, v344, v345, v346, v347, v348, v349, v350, v351, v352, v353, v354, v355, v356, v357, v358, v359, v360, v361, v362, v363, v364, v365, v366, v367, v368, v369, v370, v371, v372;

        if p319.Icons[v320] then
            v323 = p319.Icons[v320];

            if p319.MinimapReference then
                v324 = p319.MinimapReference;
                v325 = v324.Part;
                v326 = v324.Size;
                v327 = v324.TextureSize;
                v328 = v325.CFrame:PointToObjectSpace(v321);
                v329 = v328.X;
                v330 = v328.Z;
                v331 = -v329;
                v332 = -v330;
                v333 = v331 / v326.X + 0.5;
                v334 = v332 / v326.Z + 0.5;
                v335 = p319.MapImage.ImageRectOffset;
                v336 = p319.MapImage.ImageRectSize;
                v337 = 0.5 / math.clamp(p319.Settings.Zoom or 0.5, 0.1, 1);
                v338 = workspace:GetAttribute("Map");

                if v338 == "Mirage" and true or v338 == "Winter Mirage" then
                    if i == "A" then
                        v339 = v337 * -0.02 * v336.X / v327;
                        v340 = v337 * 0.04 * v336.Y / v327;
                        v333 = v333 + v339;
                        v334 = v334 + v340;
                    elseif i == "B" then
                        v341 = v337 * -0.015 * v336.X / v327;
                        v342 = v337 * -0.005 * v336.Y / v327;
                        v333 = v333 + v341;
                        v334 = v334 + v342;
                    end;
                elseif v338 == "Vertigo" and true or v338 == "Winter Vertigo" then
                    if i == "A" then
                        v343 = v337 * 0.0425 * v336.X / v327;
                        v344 = v337 * 0.005 * v336.Y / v327;
                        v333 = v333 + v343;
                        v334 = v334 + v344;
                    elseif i == "B" then
                        v345 = v337 * -0.01 * v336.X / v327;
                        v346 = v337 * -0.01 * v336.Y / v327;
                        v333 = v333 + v345;
                        v334 = v334 + v346;
                    end;
                elseif v338 == "Seaside" then
                    if i == "A" then
                        v347 = v337 * -0.01 * v336.X / v327;
                        v348 = v337 * -0.01 * v336.Y / v327;
                        v333 = v333 + v347;
                        v334 = v334 + v348;
                    elseif i == "B" then
                        v349 = v337 * 0 * v336.X / v327;
                        v350 = v337 * 0.02 * v336.Y / v327;
                        v333 = v333 + v349;
                        v334 = v334 + v350;
                    end;
                elseif v338 == "Dust 2" then
                    if i == "A" then
                        v351 = v337 * -0.06 * v336.X / v327;
                        v352 = v337 * -0.04 * v336.Y / v327;
                        v333 = v333 + v351;
                        v334 = v334 + v352;
                    elseif i == "B" then
                        v353 = v337 * -0.065 * v336.X / v327;
                        v354 = v337 * -0.02 * v336.Y / v327;
                        v333 = v333 + v353;
                        v334 = v334 + v354;
                    end;
                end;

                v355 = v333 * v327;
                v356 = v334 * v327;
                v357 = v355 - v335.X;
                v358 = v356 - v335.Y;
                v359 = v357 / v336.X;
                v360 = v358 / v336.Y;

                if p319.MapImage.Rotation ~= 0 then
                    v361 = math.rad(p319.MapImage.Rotation);
                    v362 = math.cos(v361);
                    v363 = math.sin(v361);
                    v364 = v359 - 0.5;
                    v365 = v360 - 0.5;
                    v359 = 0.5 + (v364 * v362 - v365 * v363);
                    v360 = 0.5 + (v364 * v363 + v365 * v362);
                end;

                v366 = v359 - 0.5;
                v367 = v360 - 0.5;
                v368 = math.sqrt(v366 * v366 + v367 * v367);

                if v368 > 0.5 then
                    v369 = v366 / v368;
                    v370 = v367 / v368;
                    v359 = 0.5 + v369 * 0.485;
                    v360 = 0.5 + v370 * 0.485;
                end;

                v323.Instance.Position = UDim2.fromScale(v359, v360);
                v323.Instance.Visible = true;
                v371 = v368 > 0.5;
                v372 = v323.DefaultSize;

                if v372 then
                    if v371 then
                        v323.Instance.Size = v372;
                    else
                        v323.Instance.Size = UDim2.new(v372.X.Scale * v337, v372.X.Offset * v337, v372.Y.Scale * v337, v372.Y.Offset * v337);
                    end;
                end;
            else
                v323.Instance.Visible = false;
            end;
        else
            local v373 = Radar:FindFirstChild(i);

            if v373 then
                local v374 = v373:Clone();
                v374.Name = i .. "_Icon";
                v374.Position = UDim2.fromScale(0.5, 0.5);
                v374.AnchorPoint = Vector2.new(0.5, 0.5);
                v374.ZIndex = 16;
                v374.Visible = true;

                if v374:IsA("TextLabel") then
                    v374.TextXAlignment = Enum.TextXAlignment.Center;
                    v374.TextYAlignment = Enum.TextYAlignment.Center;
                end;

                v374.Parent = p319.RadarContainer;
                p319.Icons[v320] = {
                    Player = nil,
                    Target = nil,
                    Type = "Site",
                    Instance = v374,
                    DefaultSize = v373.Size
                };
                v323 = p319.Icons[v320];

                if p319.MinimapReference then
                    v324 = p319.MinimapReference;
                    v325 = v324.Part;
                    v326 = v324.Size;
                    v327 = v324.TextureSize;
                    v328 = v325.CFrame:PointToObjectSpace(v321);
                    v329 = v328.X;
                    v330 = v328.Z;
                    v331 = -v329;
                    v332 = -v330;
                    v333 = v331 / v326.X + 0.5;
                    v334 = v332 / v326.Z + 0.5;
                    v335 = p319.MapImage.ImageRectOffset;
                    v336 = p319.MapImage.ImageRectSize;
                    v337 = 0.5 / math.clamp(p319.Settings.Zoom or 0.5, 0.1, 1);
                    v338 = workspace:GetAttribute("Map");

                    if v338 == "Mirage" and true or v338 == "Winter Mirage" then
                        if i == "A" then
                            v339 = v337 * -0.02 * v336.X / v327;
                            v340 = v337 * 0.04 * v336.Y / v327;
                            v333 = v333 + v339;
                            v334 = v334 + v340;
                        elseif i == "B" then
                            v341 = v337 * -0.015 * v336.X / v327;
                            v342 = v337 * -0.005 * v336.Y / v327;
                            v333 = v333 + v341;
                            v334 = v334 + v342;
                        end;
                    elseif v338 == "Vertigo" and true or v338 == "Winter Vertigo" then
                        if i == "A" then
                            v343 = v337 * 0.0425 * v336.X / v327;
                            v344 = v337 * 0.005 * v336.Y / v327;
                            v333 = v333 + v343;
                            v334 = v334 + v344;
                        elseif i == "B" then
                            v345 = v337 * -0.01 * v336.X / v327;
                            v346 = v337 * -0.01 * v336.Y / v327;
                            v333 = v333 + v345;
                            v334 = v334 + v346;
                        end;
                    elseif v338 == "Seaside" then
                        if i == "A" then
                            v347 = v337 * -0.01 * v336.X / v327;
                            v348 = v337 * -0.01 * v336.Y / v327;
                            v333 = v333 + v347;
                            v334 = v334 + v348;
                        elseif i == "B" then
                            v349 = v337 * 0 * v336.X / v327;
                            v350 = v337 * 0.02 * v336.Y / v327;
                            v333 = v333 + v349;
                            v334 = v334 + v350;
                        end;
                    elseif v338 == "Dust 2" then
                        if i == "A" then
                            v351 = v337 * -0.06 * v336.X / v327;
                            v352 = v337 * -0.04 * v336.Y / v327;
                            v333 = v333 + v351;
                            v334 = v334 + v352;
                        elseif i == "B" then
                            v353 = v337 * -0.065 * v336.X / v327;
                            v354 = v337 * -0.02 * v336.Y / v327;
                            v333 = v333 + v353;
                            v334 = v334 + v354;
                        end;
                    end;

                    v355 = v333 * v327;
                    v356 = v334 * v327;
                    v357 = v355 - v335.X;
                    v358 = v356 - v335.Y;
                    v359 = v357 / v336.X;
                    v360 = v358 / v336.Y;

                    if p319.MapImage.Rotation ~= 0 then
                        v361 = math.rad(p319.MapImage.Rotation);
                        v362 = math.cos(v361);
                        v363 = math.sin(v361);
                        v364 = v359 - 0.5;
                        v365 = v360 - 0.5;
                        v359 = 0.5 + (v364 * v362 - v365 * v363);
                        v360 = 0.5 + (v364 * v363 + v365 * v362);
                    end;

                    v366 = v359 - 0.5;
                    v367 = v360 - 0.5;
                    v368 = math.sqrt(v366 * v366 + v367 * v367);

                    if v368 > 0.5 then
                        v369 = v366 / v368;
                        v370 = v367 / v368;
                        v359 = 0.5 + v369 * 0.485;
                        v360 = 0.5 + v370 * 0.485;
                    end;

                    v323.Instance.Position = UDim2.fromScale(v359, v360);
                    v323.Instance.Visible = true;
                    v371 = v368 > 0.5;
                    v372 = v323.DefaultSize;

                    if v372 then
                        if v371 then
                            v323.Instance.Size = v372;
                        else
                            v323.Instance.Size = UDim2.new(v372.X.Scale * v337, v372.X.Offset * v337, v372.Y.Scale * v337, v372.Y.Offset * v337);
                        end;
                    end;
                else
                    v323.Instance.Visible = false;
                end;
            end;

            warn((`Site icon template not found for: {i}`));
        end;
    end;
end;

function u1.UpdateHostageIcons(p375) -- Line: 2766
    -- upvalues: Profiler (copy), CollectionService (copy), Radar (copy), Players (copy), GetHostageVisibility (copy)
    Profiler.mark("UI.Radar.UpdateHostageIcons");
    local v376 = CollectionService:GetTagged("Hostage");
    local v377 = tick();
    local v378 = {};

    for _, v in ipairs(v376) do
        if v:IsA("Model") and v.PrimaryPart then
            local Name = v.Name;
            local v379 = "Hostage_" .. Name;
            v378[v379] = true;

            if not p375.Icons[v379] then
                local Hostage = Radar:FindFirstChild("Hostage");

                if not (Hostage and Hostage:IsA("ImageLabel")) then
                    Hostage = Radar.Player;
                end;

                local v380 = Hostage:Clone();
                v380.Position = UDim2.fromScale(0.5, 0.5);
                v380.AnchorPoint = Vector2.new(0.5, 0.5);
                v380.Parent = p375.RadarContainer;
                v380.Size = UDim2.fromOffset(30, 30);
                v380.ZIndex = 18;
                v380.Name = "Hostage_" .. Name;
                v380.Visible = true;

                for _, child in ipairs(v380:GetChildren()) do
                    if child.Name == "Direction" and child:IsA("ImageLabel") then
                        child.Visible = false;
                    end;
                end;

                p375.Icons[v379] = {
                    Player = nil,
                    Type = "Hostage",
                    Instance = v380,
                    Target = v.PrimaryPart
                };
            end;

            local v381 = p375.Icons[v379];

            if p375.MinimapReference then
                local v382 = v:GetAttribute("CarryingPlayer");
                local v383;

                if v382 then
                    local v384 = Players:FindFirstChild(v382);

                    if v384 and (v384.Character and v384.Character.PrimaryPart) then
                        v383 = v384.Character.PrimaryPart.Position;
                    else
                        v383 = v.PrimaryPart.Position;
                    end;
                else
                    v383 = v.PrimaryPart.Position;
                end;

                local MinimapReference = p375.MinimapReference;
                local Size = MinimapReference.Size;
                local TextureSize = MinimapReference.TextureSize;
                local v385 = MinimapReference.Part.CFrame:PointToObjectSpace(v383);
                local ImageRectOffset = p375.MapImage.ImageRectOffset;
                local ImageRectSize = p375.MapImage.ImageRectSize;
                local v386 = ((-v385.X / Size.X + 0.5) * TextureSize - ImageRectOffset.X) / ImageRectSize.X;
                local v387 = ((-v385.Z / Size.Z + 0.5) * TextureSize - ImageRectOffset.Y) / ImageRectSize.Y;

                if p375.MapImage.Rotation ~= 0 then
                    local v388 = math.rad(p375.MapImage.Rotation);
                    local v389 = math.cos(v388);
                    local v390 = math.sin(v388);
                    local v391 = v386 - 0.5;
                    local v392 = v387 - 0.5;
                    v386 = 0.5 + (v391 * v389 - v392 * v390);
                    v387 = 0.5 + (v391 * v390 + v392 * v389);
                end;

                local v393 = v386 - 0.5;
                local v394 = v387 - 0.5;
                local v395 = math.sqrt(v393 * v393 + v394 * v394);

                if v395 > 0.5 then
                    v386 = 0.5 + v393 / v395 * 0.5;
                    v387 = 0.5 + v394 / v395 * 0.5;
                end;

                v381.Instance.Position = UDim2.fromScale(v386, v387);
                local Team = p375.Team;

                if v382 ~= nil then
                    if Team == "Counter-Terrorists" then
                        v381.Instance.Visible = true;
                    elseif Team == "Terrorists" then
                        v381.Instance.Visible = GetHostageVisibility(p375, v379, v383, v, v377);
                    else
                        v381.Instance.Visible = true;
                    end;
                else
                    v381.Instance.Visible = Team == "Terrorists";
                end;
            else
                v381.Instance.Visible = false;
            end;
        end;
    end;

    for i, v in pairs(p375.Icons) do
        if v.Type == "Hostage" and not v378[i] then
            p375.HostageVisibilityCache[i] = nil;
            p375:RemoveIcon(i);
        end;
    end;
end;

function u1.UpdateMinimapTexture(p396) -- Line: 2953
    -- upvalues: Profiler (copy), u6 (copy), CurrentCamera (ref), Workspace (copy)
    Profiler.mark("UI.Radar.UpdateMinimapTexture");

    if not p396.MinimapReference then
        return;
    end;

    local MinimapReference = p396.MinimapReference;
    local Part = MinimapReference.Part;

    if Part then
        local Lower = Part:FindFirstChild("Lower");
        local Upper = Part:FindFirstChild("Upper");

        if Lower and Lower:IsA("Decal") then
            MinimapReference.Lower = Lower;
        end;

        if Upper and Upper:IsA("Decal") then
            MinimapReference.Upper = Upper;
        end;
    end;

    local v397 = MinimapReference.Lower or MinimapReference.Upper;

    if not v397 then
        return;
    end;

    p396.MapImage.Image = v397.Texture;
    p396.MapImage.ImageTransparency = 0;

    if not v397.Texture:match("%d+") then
        return;
    end;

    local TextureSize = MinimapReference.TextureSize;
    local v398 = workspace:GetAttribute("Map");
    local v399;

    if v398 then
        v399 = u6[v398];
    else
        v399 = nil;
    end;

    local Upper = MinimapReference.Upper;
    local UpperMapImage = p396.UpperMapImage;
    local v400;

    if v399 == nil or Upper == nil then
        v400 = false;
    else
        v400 = UpperMapImage ~= nil;
    end;

    if p396.Character and p396.Character.PrimaryPart then
        local Y = p396.Character.PrimaryPart.Position.Y;

        if v400 and (UpperMapImage and Upper) then
            UpperMapImage.Image = Upper.Texture;
            local v401;

            if v399 == nil then
                v401 = false;
            else
                v401 = v399 <= Y;
            end;

            UpperMapImage.ImageTransparency = v401 and 0 or 1;
        end;
    else
        p396.MapImage.ImageTransparency = 0;

        if v400 and (UpperMapImage and Upper) then
            UpperMapImage.Image = Upper.Texture;
        end;
    end;

    if p396.Character and p396.Character.PrimaryPart then
        local _ = p396.Settings.CentersPlayer;
        local Part2 = MinimapReference.Part;
        local v402 = Part2.CFrame:PointToObjectSpace(p396.Character.PrimaryPart.Position);
        local Size = MinimapReference.Size;

        if Size.X == 0 or Size.Z == 0 then
            return;
        end;

        local v403 = -v402.X / Size.X + 0.5;
        local v404 = -v402.Z / Size.Z + 0.5;
        local v405 = TextureSize * math.clamp(p396.Settings.Zoom or 0.7, 0.1, 1) * 0.5 + 0.5;
        local v406 = math.floor(v405);
        local v407 = math.clamp(v406, 1, TextureSize);
        local v408 = math.clamp(v403 * TextureSize - v407 / 2, 0, TextureSize - v407);
        local v409 = math.clamp(v404 * TextureSize - v407 / 2, 0, TextureSize - v407);
        local v410 = math.floor(v408 + 0.5);
        local v411 = math.floor(v409 + 0.5);
        p396.ViewCenterLocal = Vector3.new(-(((v410 + v407 / 2) / TextureSize - 0.5) * Size.X), 0, -(((v411 + v407 / 2) / TextureSize - 0.5) * Size.Z));
        local v412 = Vector2.new(v410, v411);
        local v413 = Vector2.new(v407, v407);
        p396.MapImage.ImageRectOffset = v412;
        p396.MapImage.ImageRectSize = v413;

        if v400 and UpperMapImage then
            UpperMapImage.ImageRectOffset = v412;
            UpperMapImage.ImageRectSize = v413;
        end;

        local v414;

        if p396.IsSpectating or not p396.Settings.Rotation then
            v414 = 90;
        else
            CurrentCamera = Workspace.CurrentCamera;
            local v415 = CurrentCamera;

            if v415 then
                local LookVector = v415.CFrame.LookVector;
                local v416 = Vector3.new(LookVector.X, 0, LookVector.Z);
                local v417 = v416.Magnitude < 1e-6 and Vector3.new(0, 0, 1) or v416.Unit;

                if Part2 then
                    v417 = Part2.CFrame:VectorToObjectSpace(v417);
                end;

                local v418 = math.atan2(-v417.Z, -v417.X);
                v414 = -((math.deg(v418) + 90) % 360) + 90 - 90;
            else
                v414 = 90;
            end;
        end;

        p396.MapImage.Rotation = v414;

        if v400 and UpperMapImage then
            UpperMapImage.Rotation = v414;
        end;
    else
        local v419 = Vector2.new(0, 0);
        local v420 = Vector2.new(TextureSize, TextureSize);
        p396.MapImage.ImageRectOffset = v419;
        p396.MapImage.ImageRectSize = v420;
        p396.MapImage.Rotation = 90;

        if v400 and UpperMapImage then
            UpperMapImage.ImageRectOffset = v419;
            UpperMapImage.ImageRectSize = v420;
            UpperMapImage.Rotation = 90;
        end;

        p396.ViewCenterLocal = Vector3.new(0, 0, 0);
    end;
end;

function u1.ApplySettings(p421) -- Line: 3147
    -- upvalues: Profiler (copy), u2 (copy), u3 (copy), CalculateClampedPosition (copy)
    Profiler.mark("UI.Radar.ApplySettings");
    p421.MapImage.Size = UDim2.fromScale(1, 1);

    if p421.UpperMapImage then
        p421.UpperMapImage.Size = UDim2.fromScale(1, 1);
    end;

    local v422 = p421.Settings.Scale or 1;

    if u2 then
        v422 = (v422 - 1) * 0.5 + 1;
    end;

    local v423 = u3 * v422;
    p421.Frame.Size = UDim2.fromOffset(v423, v423);
    p421.RadarContainer.Size = UDim2.fromOffset(v423, v423);
    local v424 = UDim2.new(0, 10, 0, 10);
    local v425 = CalculateClampedPosition(p421.Frame, v423, v424);
    p421.Frame.Position = v425;
    p421:UpdateMinimapTexture();
end;

function u1.CreateRunningCircle(p426) -- Line: 3180
    if p426.RunningCircle then
        return;
    end;

    local Frame = Instance.new("Frame");
    Frame.Name = "RunningCircle";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.ZIndex = 14;
    Frame.Parent = p426.RadarContainer;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(255, 255, 255);
    UIStroke.Thickness = 2;
    UIStroke.Transparency = 1;
    UIStroke.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame;
    p426.RunningCircle = Frame;
end;

function u1.CreateKnifeCircle(p427) -- Line: 3212
    if p427.KnifeCircle then
        return;
    end;

    local Frame = Instance.new("Frame");
    Frame.Name = "KnifeCircle";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.ZIndex = 14;
    Frame.Parent = p427.RadarContainer;
    Frame.Visible = false;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(255, 255, 255);
    UIStroke.Thickness = 2;
    UIStroke.Transparency = 1;
    UIStroke.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame;
    p427.KnifeCircle = Frame;
end;

function u1.CreateWeaponCircle(p428) -- Line: 3245
    if p428.WeaponCircle then
        return;
    end;

    local Frame = Instance.new("Frame");
    Frame.Name = "WeaponCircle";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.ZIndex = 14;
    Frame.Parent = p428.RadarContainer;
    Frame.Visible = false;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(255, 255, 255);
    UIStroke.Thickness = 2;
    UIStroke.Transparency = 1;
    UIStroke.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame;
    p428.WeaponCircle = Frame;
end;

function u1.FlashRadarBorder(u429) -- Line: 3278
    -- upvalues: u15 (ref), GetPreferenceColor (copy)
    if not (u15 and u15.Radar) then
        return;
    end;

    local UIStroke = u15.Radar.UIStroke;

    if not UIStroke then
        return;
    end;

    if not u429.OriginalBorderColor then
        u429.OriginalBorderColor = UIStroke.Color;
    end;

    UIStroke.Color = Color3.fromRGB(255, 255, 255);

    if u429.BorderRestoreTask then
        task.cancel(u429.BorderRestoreTask);
        u429.BorderRestoreTask = nil;
    end;

    u429.BorderRestoreTask = task.delay(0.2, function() -- Line: 3305
        -- upvalues: u15 (ref), GetPreferenceColor (ref), u429 (copy)
        if u15 and (u15.Radar and u15.Radar.UIStroke) then
            u15.Radar.UIStroke.Color = GetPreferenceColor();
        end;

        u429.BorderRestoreTask = nil;
    end);
end;

function u1.ShowWeaponCircle(u430) -- Line: 3316
    -- upvalues: u2 (copy), u3 (copy)
    if not u430.WeaponCircle then
        u430:CreateWeaponCircle();
    end;

    local WeaponCircle = u430.WeaponCircle;

    if not WeaponCircle then
        return;
    end;

    local u431 = WeaponCircle:FindFirstChildOfClass("UIStroke");

    if not u431 then
        return;
    end;

    local v432 = u430.Settings.Scale or 1;

    if u2 then
        v432 = (v432 - 1) * 0.5 + 1;
    end;

    local v433 = u3 / 2 * v432 * 2;
    WeaponCircle.Size = UDim2.fromOffset(v433, v433);
    u431.Thickness = 2;
    u431.Transparency = 0;
    WeaponCircle.Visible = true;

    if u430.WeaponCircleHideTask then
        task.cancel(u430.WeaponCircleHideTask);
        u430.WeaponCircleHideTask = nil;
    end;

    u430.WeaponCircleHideTask = task.delay(0.2, function() -- Line: 3354
        -- upvalues: WeaponCircle (copy), u431 (copy), u430 (copy)
        if WeaponCircle and u431 then
            u431.Transparency = 1;
            WeaponCircle.Visible = false;
        end;

        u430.WeaponCircleHideTask = nil;
    end);
end;

function u1.ShowKnifeCircle(p434) -- Line: 3365
    -- upvalues: u2 (copy), u3 (copy)
    if not p434.KnifeCircle then
        p434:CreateKnifeCircle();
    end;

    local KnifeCircle = p434.KnifeCircle;

    if not KnifeCircle then
        return;
    end;

    local u435 = KnifeCircle:FindFirstChildOfClass("UIStroke");

    if not u435 then
        return;
    end;

    local v436 = math.clamp(p434.Settings.Zoom or 0.5, 0.1, 1);
    local v437 = p434.Settings.Scale or 1;

    if u2 then
        v437 = (v437 - 1) * 0.5 + 1;
    end;

    local v438 = u3 / 2 * v437;
    local v439 = math.min((u2 and 21 or 35) * (0.5 / v436) * v437, v438);
    local v440 = v439 * 2;
    KnifeCircle.Size = UDim2.fromOffset(v440, v440);

    if v439 == v438 then
        u435.Thickness = 2;
        u435.Transparency = 0;
    else
        u435.Thickness = 1;
        u435.Transparency = 0.5;
    end;

    KnifeCircle.Visible = true;
    task.delay(0.2, function() -- Line: 3410
        -- upvalues: KnifeCircle (copy), u435 (copy)
        if KnifeCircle and u435 then
            u435.Transparency = 1;
            KnifeCircle.Visible = false;
        end;
    end);
end;

function u1.UpdateRunningCircle(u441) -- Line: 3420
    -- upvalues: CharacterController (copy), u2 (copy), u3 (copy)
    if not (u441.Character and u441.Character.PrimaryPart) then
        return;
    end;

    if not u441.Character:FindFirstChildOfClass("Humanoid") then
        return;
    end;

    local v442 = CharacterController.getCurrentCharacter();
    local v443 = false;

    if v442 then
        local GlobalDirection = v442.GlobalDirection;
        local GlobalVelocity = v442.GlobalVelocity;

        if GlobalDirection and GlobalVelocity then
            local Magnitude = Vector3.new(GlobalVelocity.X, 0, GlobalVelocity.Z).Magnitude;
            v443 = GlobalDirection.Magnitude > 0.1 and true or Magnitude > 0.1;
        end;
    end;

    local v444 = CharacterController.GetWalkState() or false;

    if v443 then
        v443 = not v444;
    end;

    local v445 = v442 and v442.IsJumping or false;
    local v446 = v443 or v445;

    if not u441.RunningCircle then
        u441:CreateRunningCircle();
    end;

    local RunningCircle = u441.RunningCircle;

    if not RunningCircle then
        return;
    end;

    local v447 = RunningCircle:FindFirstChildOfClass("UIStroke");

    if not v447 then
        return;
    end;

    local v448 = math.clamp(u441.Settings.Zoom or 0.5, 0.1, 1);
    local v449 = u441.Settings.Scale or 1;

    if u2 then
        v449 = (v449 - 1) * 0.5 + 1;
    end;

    local v450 = u3 / 2 * v449;
    local v451 = math.min((u2 and 30 or 50) * (0.5 / v448) * v449, v450);
    local v452 = v451 * 2;
    RunningCircle.Size = UDim2.fromOffset(v452, v452);
    local v453 = v451 == v450;

    if v453 then
        v447.Thickness = 2;
    else
        v447.Thickness = 1;
    end;

    if v446 then
        if v453 then
            v447.Transparency = 0;
        else
            v447.Transparency = 0.5;
        end;

        if v445 then
            if u441.RunningCircleDelayTask then
                task.cancel(u441.RunningCircleDelayTask);
                u441.RunningCircleDelayTask = nil;
            end;

            RunningCircle.Visible = true;
        elseif v443 then
            if u441.WasRunning then
                if not u441.RunningCircleDelayTask then
                    if v453 then
                        v447.Transparency = 0;
                    else
                        v447.Transparency = 0.5;
                    end;

                    RunningCircle.Visible = true;
                end;
            else
                if u441.RunningCircleDelayTask then
                    task.cancel(u441.RunningCircleDelayTask);
                    u441.RunningCircleDelayTask = nil;
                end;

                RunningCircle.Visible = false;
                v447.Transparency = 1;
                u441.RunningCircleDelayTask = task.delay(0.4, function() -- Line: 3524
                    -- upvalues: u441 (copy), CharacterController (ref), u2 (ref), u3 (ref)
                    if not (u441.Character and u441.Character.PrimaryPart) then
                        u441.RunningCircleDelayTask = nil;

                        return;
                    end;

                    local v454 = CharacterController.getCurrentCharacter();
                    local v455 = false;

                    if v454 then
                        local GlobalDirection = v454.GlobalDirection;
                        local GlobalVelocity = v454.GlobalVelocity;

                        if GlobalDirection and GlobalVelocity then
                            local Magnitude = Vector3.new(GlobalVelocity.X, 0, GlobalVelocity.Z).Magnitude;
                            v455 = GlobalDirection.Magnitude > 0.1 and true or Magnitude > 0.1;
                        end;
                    end;

                    local v456 = CharacterController.GetWalkState() or false;

                    if v455 then
                        v455 = not v456;
                    end;

                    if v455 and u441.RunningCircle then
                        local RunningCircle2 = u441.RunningCircle;
                        local v457 = RunningCircle2:FindFirstChildOfClass("UIStroke");

                        if v457 then
                            local v458 = math.clamp(u441.Settings.Zoom or 0.5, 0.1, 1);
                            local v459 = u441.Settings.Scale or 1;

                            if u2 then
                                v459 = (v459 - 1) * 0.5 + 1;
                            end;

                            local v460 = u3 / 2 * v459;

                            if math.min((u2 and 30 or 50) * (0.5 / v458) * v459, v460) == v460 then
                                v457.Transparency = 0;
                            else
                                v457.Transparency = 0.5;
                            end;

                            RunningCircle2.Visible = true;
                        end;
                    end;

                    u441.RunningCircleDelayTask = nil;
                end);
            end;
        end;
    else
        if u441.RunningCircleDelayTask then
            task.cancel(u441.RunningCircleDelayTask);
            u441.RunningCircleDelayTask = nil;
        end;

        RunningCircle.Visible = false;
        v447.Transparency = 1;
    end;

    u441.WasRunning = v446;
end;

function u1.CreateDeadIconForPlayer(u461, p462, p463) -- Line: 3605
    -- upvalues: Workspace (copy), CreateIcon (copy), Colors (copy), Radar (copy), TweenService (copy)
    local v464 = p462.UserId .. "_Player";

    if u461.Icons[v464] then
        u461:RemoveIcon(v464);
    end;

    local u465 = p462.UserId .. "_Dead";

    if not (u461.Icons[u465] or u461.FadedDeadIcons[u465]) then
        local v466 = p462:GetAttribute("Team");
        local v467 = v466 == u461.Team;
        local v468 = Workspace:GetAttribute("Gamemode") == "Deathmatch" and true or Workspace:GetAttribute("ServerGamemode") == "Deathmatch";
        local v469 = CreateIcon(u461.RadarContainer, "DeadTeammate", 12);
        v469.Name = p462.Name .. "_Dead";
        v469.ImageTransparency = 0;

        for _, child in ipairs(v469:GetChildren()) do
            if child.Name == "Direction" and child:IsA("ImageLabel") then
                child.Visible = false;
            end;
        end;

        if v468 or not v467 then
            v469.ImageColor3 = Color3.fromRGB(255, 0, 0);
        else
            local Character = p462.Character;
            local v470;

            if v466 then
                v470 = Character and Character:GetAttribute("CompetitivePlayerColor") or Colors["Team Color"][v466];
            else
                v470 = nil;
            end;

            if v470 then
                v469.ImageColor3 = v470;
            end;
        end;

        u461.Icons[u465] = {
            Target = nil,
            Type = "DeadTeammate",
            Instance = v469,
            Player = p462,
            DefaultSize = Radar.Dead.Size
        };

        if p463 and u461.MinimapReference then
            local MinimapReference = u461.MinimapReference;
            local Size = MinimapReference.Size;
            local TextureSize = MinimapReference.TextureSize;
            local v471 = MinimapReference.Part.CFrame:PointToObjectSpace(p463);
            local ImageRectOffset = u461.MapImage.ImageRectOffset;
            local ImageRectSize = u461.MapImage.ImageRectSize;
            local v472 = ((-v471.X / Size.X + 0.5) * TextureSize - ImageRectOffset.X) / ImageRectSize.X;
            local v473 = ((-v471.Z / Size.Z + 0.5) * TextureSize - ImageRectOffset.Y) / ImageRectSize.Y;

            if u461.MapImage.Rotation ~= 0 then
                local v474 = math.rad(u461.MapImage.Rotation);
                local v475 = math.cos(v474);
                local v476 = math.sin(v474);
                local v477 = v472 - 0.5;
                local v478 = v473 - 0.5;
                v472 = 0.5 + (v477 * v475 - v478 * v476);
                v473 = 0.5 + (v477 * v476 + v478 * v475);
            end;

            local v479 = v472 - 0.5;
            local v480 = v473 - 0.5;
            local v481 = math.sqrt(v479 * v479 + v480 * v480);

            if v481 > 0.5 then
                v472 = 0.5 + v479 / v481 * 0.5;
                v473 = 0.5 + v480 / v481 * 0.5;
            end;

            v469.Position = UDim2.fromScale(v472, v473);
            v469.Visible = true;
        end;

        task.delay(2, function() -- Line: 3731
            -- upvalues: u461 (copy), u465 (copy), TweenService (ref)
            local v482 = u461.Icons[u465];

            if v482 and (v482.Instance and v482.Instance.Parent) then
                u461.FadedDeadIcons[u465] = true;
                local v483 = TweenService:Create(v482.Instance, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                    ImageTransparency = 1
                });
                v483:Play();
                v483.Completed:Connect(function() -- Line: 3746
                    -- upvalues: u461 (ref), u465 (ref)
                    if u461.Icons[u465] then
                        u461:RemoveIcon(u465);
                    end;
                end);
            end;
        end);
    end;
end;

function u1.Render(p484, p485) -- Line: 3758
    -- upvalues: Profiler (copy)
    Profiler.mark("UI.Radar.Render");
    p484:UpdateMinimapTexture();
    p484:UpdatePlayerIcons(p484.Settings.Rotation);
    p484:UpdateBombIcon();
    p484:UpdateSiteIcons();
    p484:UpdateHostageIcons();
    p484:UpdateRunningCircle();
end;

function u1.new(p486, p487) -- Line: 3784
    -- upvalues: Profiler (copy), u1 (copy), Janitor (copy), LocalPlayer (copy), GetMinimapReference (copy), u6 (copy), u16 (copy), GetSiteParts (copy), Router (copy), RunServiceController (copy), Players (copy), Remotes (copy)
    Profiler.mark("UI.Radar.New");
    local u488 = setmetatable({}, u1);
    u488.Janitor = Janitor.new();
    u488.Frame = p486;
    u488.RadarContainer = p486.Radar;
    u488.MapImage = p486.Radar.Map;
    u488.MapImage.AnchorPoint = Vector2.new(0.5, 0.5);
    u488.MapImage.Position = UDim2.fromScale(0.5, 0.5);
    u488.MapImage.ZIndex = 1;
    u488.LocalPlayer = LocalPlayer;
    u488.Character = p487;
    u488.Team = LocalPlayer:GetAttribute("Team");
    u488.MinimapReference = GetMinimapReference();
    local v489 = workspace:GetAttribute("Map");
    local v490;

    if v489 then
        v490 = u6[v489];
    else
        v490 = nil;
    end;

    if v490 ~= nil and (u488.MinimapReference and u488.MinimapReference.Upper) then
        local v491 = u488.MapImage:Clone();
        v491.Name = "UpperMap";
        v491.ZIndex = 2;
        v491.BackgroundTransparency = 1;
        v491.Parent = u488.RadarContainer;
        u488.UpperMapImage = v491;
        u488.Janitor:Add(function() -- Line: 3823
            -- upvalues: u488 (copy)
            if u488.UpperMapImage then
                u488.UpperMapImage:Destroy();
            end;
        end);
    else
        u488.UpperMapImage = nil;
    end;

    u488.Frame.Visible = true;
    u488.Janitor:Add(function() -- Line: 3834
        -- upvalues: u488 (copy)
        u488.Frame.Visible = true;
    end);
    u488.Settings = u16;
    u488.IsSpectating = false;
    u488.Icons = {};
    u488.SiteParts = GetSiteParts();
    u488.DeadPlayerPositions = {};
    u488.FadedDeadIcons = {};
    u488.EnemyVisibilityState = {};
    u488.EnemyLastSeenPositions = {};
    u488.EnemyVisibilityCache = {};
    u488.HostageVisibilityCache = {};
    u488.BombVisibilityCache = nil;
    u488.RunningCircle = nil;
    u488.RunningCircleDelayTask = nil;
    u488.WasRunning = false;
    u488.KnifeCircle = nil;
    u488.WeaponCircle = nil;
    u488.WeaponCircleHideTask = nil;
    u488.OriginalBorderColor = nil;
    u488.BorderRestoreTask = nil;
    u488.BombIsVisible = false;
    u488.BombFadeStartTime = nil;
    u488:ApplySettings();
    local broadcastRouter = Router.broadcastRouter;

    function Router.broadcastRouter(p492, ...) -- Line: 3887
        -- upvalues: broadcastRouter (copy), u488 (copy)
        local v493 = broadcastRouter(p492, ...);

        if p492 == "UpdatePlayerNoiseCone" then
            local v494 = { ... };
            local v495 = v494[1];
            local v496 = v494[2];

            if v496 and (u488.Character and (u488.Character.PrimaryPart and (v496 - u488.Character.PrimaryPart.Position).Magnitude < 5)) then
                if v495 == "Melee" then
                    u488:ShowKnifeCircle();

                    return v493;
                end;

                if v495 == "Weapon" then
                    u488:ShowWeaponCircle();
                    u488:FlashRadarBorder();
                end;
            end;
        end;

        return v493;
    end;

    u488.Janitor:Add(function() -- Line: 3922
        -- upvalues: Router (ref), broadcastRouter (copy)
        Router.broadcastRouter = broadcastRouter;
    end);
    local u497 = 0;
    u488.Janitor:Add(RunServiceController.BindToRenderStep("UI.Radar.Update", function(p498) -- Line: 3928
        -- upvalues: Profiler (ref), u497 (ref), u488 (copy)
        Profiler.mark("UI.Radar.RenderStepped");
        u497 = u497 + p498;

        if u497 >= 0.016666666666666666 then
            u488:Render(p498);
            u497 = u497 - 0.016666666666666666;
        end;
    end));
    u488.Janitor:Add(LocalPlayer:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 3939
        -- upvalues: u488 (copy)
        u488:RefreshIconsOnTeamChange();
    end));

    local function setupPlayerTeamListener(u499) -- Line: 3945
        -- upvalues: u488 (copy)
        if u499 == u488.LocalPlayer then
            return;
        end;

        u488.Janitor:Add(u499:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 3950
            -- upvalues: u488 (ref), u499 (copy)
            u488:RefreshPlayerIcon(u499);
        end));
    end;

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= u488.LocalPlayer then
            u488.Janitor:Add(v:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 3950
                -- upvalues: u488 (copy), v (copy)
                u488:RefreshPlayerIcon(v);
            end));
        end;
    end;

    u488.Janitor:Add(Players.PlayerAdded:Connect(function(u500) -- Line: 3962
        -- upvalues: u488 (copy)
        if u500 == u488.LocalPlayer then
            return;
        end;

        u488.Janitor:Add(u500:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 3950
            -- upvalues: u488 (ref), u500 (copy)
            u488:RefreshPlayerIcon(u500);
        end));
    end));
    u488.Janitor:Add(Players.PlayerRemoving:Connect(function(p501) -- Line: 3967
        -- upvalues: u488 (copy)
        for i, v in pairs(u488.Icons) do
            if v.Player == p501 then
                u488:RemoveIcon(i);
            end;
        end;

        u488.DeadPlayerPositions[p501.UserId] = nil;
        u488.FadedDeadIcons[p501.UserId .. "_Dead"] = nil;
        u488.EnemyVisibilityCache[p501.UserId .. "_Player"] = nil;
    end));
    u488.Janitor:Add(Remotes.UI.UIPlayerKilled.Listen(function(p502) -- Line: 3981
        -- upvalues: Players (ref), LocalPlayer (ref), u488 (copy)
        local v503 = Players:GetPlayerByUserId((tonumber(p502.Victim)));

        if not v503 or v503 == LocalPlayer then
            return;
        end;

        local DeathPosition = p502.DeathPosition;

        if not DeathPosition then
            return;
        end;

        u488.DeadPlayerPositions[v503.UserId] = DeathPosition;
        u488:CreateDeadIconForPlayer(v503, DeathPosition);
    end));
    u488.Janitor:Add(workspace:GetAttributeChangedSignal("Map"):Connect(function() -- Line: 4005
        -- upvalues: u488 (copy), GetMinimapReference (ref), GetSiteParts (ref), u6 (ref)
        u488.MinimapReference = GetMinimapReference();
        u488.SiteParts = GetSiteParts();
        local v504 = workspace:GetAttribute("Map");

        if u488.UpperMapImage then
            u488.UpperMapImage:Destroy();
            u488.UpperMapImage = nil;
        end;

        for _, child in ipairs(u488.RadarContainer:GetChildren()) do
            if child.Name == "UpperMap" and child:IsA("ImageLabel") then
                child:Destroy();
            end;
        end;

        u488.MapImage.Image = "";
        u488.MapImage.ImageTransparency = 0;
        u488.MapImage.ImageRectOffset = Vector2.new(0, 0);
        u488.MapImage.ImageRectSize = Vector2.new(1024, 1024);
        u488.MapImage.Rotation = 0;
        u488.MapImage.Visible = true;
        u488.MapImage.Size = UDim2.fromScale(1, 1);
        local v505;

        if v504 then
            v505 = u6[v504];
        else
            v505 = nil;
        end;

        if v505 ~= nil and (u488.MinimapReference and u488.MinimapReference.Upper) then
            local v506 = u488.MapImage:Clone();
            v506.Name = "UpperMap";
            v506.ZIndex = 2;
            v506.Parent = u488.RadarContainer;
            u488.UpperMapImage = v506;
        else
            u488.UpperMapImage = nil;
        end;

        u488:UpdateMinimapTexture();

        for i, _ in pairs(u488.Icons) do
            u488:RemoveIcon(i);
        end;

        table.clear(u488.EnemyVisibilityState);
        table.clear(u488.EnemyLastSeenPositions);
        table.clear(u488.EnemyVisibilityCache);
        table.clear(u488.HostageVisibilityCache);
        u488.BombVisibilityCache = nil;
        table.clear(u488.DeadPlayerPositions);
        table.clear(u488.FadedDeadIcons);
    end));
    u488.Janitor:Add(function() -- Line: 4069
        -- upvalues: u488 (copy)
        for _, v in pairs(u488.Icons) do
            if v.Instance and v.Instance.Parent then
                v.Instance:Destroy();
            end;
        end;

        table.clear(u488.Icons);
        table.clear(u488.EnemyVisibilityState);
        table.clear(u488.EnemyLastSeenPositions);
        table.clear(u488.EnemyVisibilityCache);
        table.clear(u488.HostageVisibilityCache);
        u488.BombVisibilityCache = nil;

        if u488.UpperMapImage then
            u488.UpperMapImage:Destroy();
            u488.UpperMapImage = nil;
        end;

        if u488.RadarContainer then
            for _, child in ipairs(u488.RadarContainer:GetChildren()) do
                if child.Name == "UpperMap" and child:IsA("ImageLabel") then
                    child:Destroy();
                end;
            end;
        end;

        if u488.RunningCircleDelayTask then
            task.cancel(u488.RunningCircleDelayTask);
            u488.RunningCircleDelayTask = nil;
        end;

        if u488.RunningCircle then
            u488.RunningCircle:Destroy();
            u488.RunningCircle = nil;
        end;

        if u488.KnifeCircle then
            u488.KnifeCircle:Destroy();
            u488.KnifeCircle = nil;
        end;

        if u488.WeaponCircleHideTask then
            task.cancel(u488.WeaponCircleHideTask);
            u488.WeaponCircleHideTask = nil;
        end;

        if u488.WeaponCircle then
            u488.WeaponCircle:Destroy();
            u488.WeaponCircle = nil;
        end;

        local v507 = u488;

        if v507.BorderRestoreTask then
            task.cancel(v507.BorderRestoreTask);
            v507.BorderRestoreTask = nil;
        end;

        if u488.RunningCircle then
            u488.RunningCircle:Destroy();
            u488.RunningCircle = nil;
        end;
    end);

    return u488;
end;

function u1.Destroy(p508) -- Line: 4142
    p508.Janitor:Destroy();
end;

function u1.Initialize(p509, p510) -- Line: 4149
    -- upvalues: Profiler (copy), u15 (ref), DataController (copy), LocalPlayer (copy), u16 (copy), u17 (ref), GetPreferenceColor (copy)
    Profiler.mark("UI.Radar.Initialize");
    u15 = p510;
    DataController.CreateListener(LocalPlayer, "Settings.Game.Radar/Tablet.Radar Centers The Player", function(p511) -- Line: 4157
        -- upvalues: u16 (ref), u17 (ref)
        u16.CentersPlayer = p511;

        if u17 then
            u17:ApplySettings();
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.Radar/Tablet.Radar Hud Size", function(p512) -- Line: 4166
        -- upvalues: u16 (ref), u17 (ref)
        u16.Scale = p512;

        if u17 then
            u17:ApplySettings();
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.Radar/Tablet.Radar Is Rotating", function(p513) -- Line: 4174
        -- upvalues: u16 (ref), u17 (ref)
        u16.Rotation = p513;

        if u17 then
            u17:ApplySettings();
        end;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.Radar/Tablet.Radar Map Zoom", function(p514) -- Line: 4182
        -- upvalues: u16 (ref), u17 (ref)
        u16.Zoom = p514;

        if u17 then
            u17:ApplySettings();
        end;
    end);
    u15.Radar.UIStroke.Color = GetPreferenceColor();
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 4193
        -- upvalues: u15 (ref), GetPreferenceColor (ref)
        u15.Radar.UIStroke.Color = GetPreferenceColor();
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 4198
        -- upvalues: u15 (ref), u17 (ref), GetPreferenceColor (ref)
        if u15 and (u15.Radar and u15.Radar.UIStroke) then
            local UIStroke = u15.Radar.UIStroke;
            local v515;

            if u17 then
                v515 = u17.BorderRestoreTask ~= nil;
            else
                v515 = false;
            end;

            if not v515 or UIStroke.Color ~= Color3.fromRGB(255, 255, 255) then
                UIStroke.Color = GetPreferenceColor();
            end;
        end;
    end);
end;

function u1.Start() -- Line: 4216
    -- upvalues: Profiler (copy), LocalPlayer (copy), createRadarForCharacter (copy), SpectateController (copy)
    debug.setmemorycategory("UI.Radar.Start");
    Profiler.mark("UI.Radar.Start");
    LocalPlayer.CharacterAdded:Connect(function(p516) -- Line: 4220
        -- upvalues: createRadarForCharacter (ref), LocalPlayer (ref)
        createRadarForCharacter(p516, LocalPlayer, false);
    end);
    SpectateController.ListenToSpectate:Connect(function(p517) -- Line: 4226
        -- upvalues: createRadarForCharacter (ref), LocalPlayer (ref)
        if p517 then
            local Character = p517.Character;

            if Character and Character:IsDescendantOf(workspace) then
                createRadarForCharacter(Character, p517, true);
            end;
        else
            local Character = LocalPlayer.Character;

            if Character and Character:IsDescendantOf(workspace) then
                createRadarForCharacter(Character, LocalPlayer, false);
            end;
        end;
    end);
end;

return u1;