-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Spectate = require(ReplicatedStorage.Classes.Spectate);
local Freecam = require(ReplicatedStorage.Classes.Freecam);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Promise = require(ReplicatedStorage.Shared.Promise);
local Signal = require(ReplicatedStorage.Packages.Signal);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local CurrentCamera = workspace.CurrentCamera;
local u2 = Signal.new();
u1.ListenToSpectate = u2;
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local u3 = "First-Person";
local u4 = {};
local u5 = 0;
local u6 = false;
local u7 = 1;
local u8 = 1;
local u9 = 0;
local u10 = nil;
local u11 = nil;
local u12 = { "First-Person", "Third-Person", "Free-Cam" };
local u13 = nil;
local u14 = nil;

local function GetCurrentGamemode() -- Line: 75
    local v15 = workspace:GetAttribute("ServerGamemode");

    return (typeof(v15) ~= "string" or v15 ~= "Casual" and (v15 ~= "Competitive" and v15 ~= "Deathmatch")) and "Casual" or v15;
end;

local function IsOnPlayingTeam(p16) -- Line: 87
    local v17 = p16:GetAttribute("Team");

    return v17 == "Counter-Terrorists" and true or v17 == "Terrorists";
end;

local function HasAliveCharacterReplicated(p18) -- Line: 94
    local Character = p18.Character;

    if not (Character and Character:IsDescendantOf(workspace)) then
        return false;
    end;

    if Character:GetAttribute("Dead") then
        return false;
    end;

    local v19 = Character:FindFirstChildWhichIsA("Humanoid", true);
    local v20;

    if v19 == nil then
        v20 = false;
    else
        v20 = v19.Health > 0;
    end;

    return v20;
end;

local function IsCharacterAlive(p21) -- Line: 110
    -- upvalues: LocalPlayer (copy), u6 (ref)
    local v22 = p21:GetAttribute("Team");

    if v22 ~= "Counter-Terrorists" and v22 ~= "Terrorists" then
        return false;
    end;

    if p21 == LocalPlayer and u6 then
        return false;
    end;

    local Character = p21.Character;
    local v23;

    if Character and Character:IsDescendantOf(workspace) then
        if Character:GetAttribute("Dead") then
            return false;
        end;

        local v24 = Character:FindFirstChildWhichIsA("Humanoid", true);

        if v24 ~= nil then
            return v24.Health > 0;
        end;

        v23 = false;
    else
        v23 = false;
    end;

    return v23;
end;

local function IsCompetitiveRestrictedLocalSpectate() -- Line: 128
    -- upvalues: LocalPlayer (copy), u6 (ref)
    local v25 = workspace:GetAttribute("ServerGamemode");

    if ((typeof(v25) ~= "string" or v25 ~= "Casual" and (v25 ~= "Competitive" and v25 ~= "Deathmatch")) and "Casual" or v25) ~= "Competitive" then
        return false;
    end;

    local v26 = LocalPlayer:GetAttribute("Team");

    if v26 ~= "Counter-Terrorists" and v26 ~= "Terrorists" then
        return false;
    end;

    local v27 = LocalPlayer;
    local v28 = v27:GetAttribute("Team");
    local v29;

    if (v28 == "Counter-Terrorists" and true or v28 == "Terrorists") and (v27 ~= LocalPlayer or not u6) then
        local Character = v27.Character;

        if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
            local v30 = Character:FindFirstChildWhichIsA("Humanoid", true);

            if v30 == nil then
                v29 = false;
            else
                v29 = v30.Health > 0;
            end;
        else
            v29 = false;
        end;
    else
        v29 = false;
    end;

    return not v29;
end;

local function EnforceCompetitiveSpectatePerspective() -- Line: 142
    -- upvalues: LocalPlayer (copy), u6 (ref), u3 (ref), u7 (ref), u13 (ref), u14 (ref)
    local v31 = workspace:GetAttribute("ServerGamemode");
    local v32;

    if ((typeof(v31) ~= "string" or v31 ~= "Casual" and (v31 ~= "Competitive" and v31 ~= "Deathmatch")) and "Casual" or v31) == "Competitive" then
        local v33 = LocalPlayer:GetAttribute("Team");

        if v33 == "Counter-Terrorists" and true or v33 == "Terrorists" then
            local v34 = LocalPlayer;
            local v35 = v34:GetAttribute("Team");
            local v36;

            if (v35 == "Counter-Terrorists" and true or v35 == "Terrorists") and (v34 ~= LocalPlayer or not u6) then
                local Character = v34.Character;

                if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                    local v37 = Character:FindFirstChildWhichIsA("Humanoid", true);

                    if v37 == nil then
                        v36 = false;
                    else
                        v36 = v37.Health > 0;
                    end;
                else
                    v36 = false;
                end;
            else
                v36 = false;
            end;

            v32 = not v36;
        else
            v32 = false;
        end;
    else
        v32 = false;
    end;

    if not v32 then
        return;
    end;

    u3 = "First-Person";
    u7 = 1;

    if u13 and u13.PerspectiveState ~= "First-Person" then
        u13:Switch("First-Person");
    end;

    if u14 then
        u14:Destroy();
        u14 = nil;
    end;
end;

local function IsValidSpectateTargetForLocalPlayer(p38) -- Line: 162
    -- upvalues: LocalPlayer (copy), u6 (ref)
    if p38 == LocalPlayer then
        return false;
    end;

    local v39 = p38:GetAttribute("Team");
    local v40;

    if (v39 == "Counter-Terrorists" and true or v39 == "Terrorists") and (p38 ~= LocalPlayer or not u6) then
        local Character = p38.Character;

        if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
            local v41 = Character:FindFirstChildWhichIsA("Humanoid", true);

            if v41 == nil then
                v40 = false;
            else
                v40 = v41.Health > 0;
            end;
        else
            v40 = false;
        end;
    else
        v40 = false;
    end;

    if not v40 then
        return false;
    end;

    local v42 = workspace:GetAttribute("ServerGamemode");
    local v43;

    if ((typeof(v42) ~= "string" or v42 ~= "Casual" and (v42 ~= "Competitive" and v42 ~= "Deathmatch")) and "Casual" or v42) == "Competitive" then
        local v44 = LocalPlayer:GetAttribute("Team");

        if v44 == "Counter-Terrorists" and true or v44 == "Terrorists" then
            local v45 = LocalPlayer;
            local v46 = v45:GetAttribute("Team");
            local v47;

            if (v46 == "Counter-Terrorists" and true or v46 == "Terrorists") and (v45 ~= LocalPlayer or not u6) then
                local Character = v45.Character;

                if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                    local v48 = Character:FindFirstChildWhichIsA("Humanoid", true);

                    if v48 == nil then
                        v47 = false;
                    else
                        v47 = v48.Health > 0;
                    end;
                else
                    v47 = false;
                end;
            else
                v47 = false;
            end;

            v43 = not v47;
        else
            v43 = false;
        end;
    else
        v43 = false;
    end;

    return (not v43 or LocalPlayer:GetAttribute("Team") == p38:GetAttribute("Team")) and true or false;
end;

local function GetSpectateBombModel() -- Line: 184
    -- upvalues: CollectionService (copy)
    for _, v in ipairs(CollectionService:GetTagged("Bomb")) do
        if v:IsA("Model") and (v.PrimaryPart and v:IsDescendantOf(workspace)) then
            return v;
        end;
    end;

    return nil;
end;

local function StopBombSpectate() -- Line: 200
    -- upvalues: u11 (ref), LocalPlayer (copy), u10 (ref)
    if u11 and LocalPlayer.ReplicationFocus == u11 then
        LocalPlayer.ReplicationFocus = nil;
    end;

    u10 = nil;
    u11 = nil;
end;

local function RenderBombSpectate(p49) -- Line: 211
    -- upvalues: u10 (ref), u11 (ref), LocalPlayer (copy), CurrentCamera (copy)
    local v50 = u10;

    if not (v50 and v50.Parent) then
        return false;
    end;

    local PrimaryPart = v50.PrimaryPart;

    if not PrimaryPart then
        return false;
    end;

    if u11 ~= PrimaryPart then
        u11 = PrimaryPart;
        LocalPlayer.ReplicationFocus = PrimaryPart;
    end;

    CurrentCamera.CameraType = Enum.CameraType.Follow;
    CurrentCamera.CameraSubject = PrimaryPart;

    return true;
end;

local function GetKillerPlayer() -- Line: 236
    -- upvalues: LocalPlayer (copy), Players (copy), u6 (ref)
    local v51 = LocalPlayer:GetAttribute("LastKiller");

    if v51 then
        LocalPlayer:SetAttribute("LastKiller", nil);
        local v52 = Players:FindFirstChild(v51);

        if v52 then
            local v53;

            if v52 == LocalPlayer then
                v53 = false;
            else
                local v54 = v52:GetAttribute("Team");
                local v55;

                if (v54 == "Counter-Terrorists" and true or v54 == "Terrorists") and (v52 ~= LocalPlayer or not u6) then
                    local Character = v52.Character;

                    if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                        local v56 = Character:FindFirstChildWhichIsA("Humanoid", true);

                        if v56 == nil then
                            v55 = false;
                        else
                            v55 = v56.Health > 0;
                        end;
                    else
                        v55 = false;
                    end;
                else
                    v55 = false;
                end;

                if v55 then
                    local v57 = workspace:GetAttribute("ServerGamemode");
                    local v58;

                    if ((typeof(v57) ~= "string" or v57 ~= "Casual" and (v57 ~= "Competitive" and v57 ~= "Deathmatch")) and "Casual" or v57) == "Competitive" then
                        local v59 = LocalPlayer:GetAttribute("Team");

                        if v59 == "Counter-Terrorists" and true or v59 == "Terrorists" then
                            local v60 = LocalPlayer;
                            local v61 = v60:GetAttribute("Team");
                            local v62;

                            if (v61 == "Counter-Terrorists" and true or v61 == "Terrorists") and (v60 ~= LocalPlayer or not u6) then
                                local Character = v60.Character;

                                if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                                    local v63 = Character:FindFirstChildWhichIsA("Humanoid", true);

                                    if v63 == nil then
                                        v62 = false;
                                    else
                                        v62 = v63.Health > 0;
                                    end;
                                else
                                    v62 = false;
                                end;
                            else
                                v62 = false;
                            end;

                            v58 = not v62;
                        else
                            v58 = false;
                        end;
                    else
                        v58 = false;
                    end;

                    v53 = (not v58 or LocalPlayer:GetAttribute("Team") == v52:GetAttribute("Team")) and true or false;
                else
                    v53 = false;
                end;
            end;

            if v53 then
                return v52;
            end;
        end;
    end;

    return nil;
end;

local function IsReturningToMainMenu() -- Line: 256
    -- upvalues: MenuState (copy)
    if not MenuState.WantsMainMenu() then
        return false;
    end;

    local v64 = MenuState.GetMenuFrame();
    local v65;

    if v64 == nil then
        v65 = false;
    else
        v65 = v64.Visible == true;
    end;

    return v65;
end;

local function ShouldBeSpectating() -- Line: 264
    -- upvalues: MenuState (copy), ReplicatedStorage (copy), LocalPlayer (copy), u6 (ref)
    if MenuState.IsCaseSceneActive() then
        return false;
    end;

    local v66;

    if MenuState.WantsMainMenu() then
        local v67 = MenuState.GetMenuFrame();

        if v67 == nil then
            v66 = false;
        else
            v66 = v67.Visible == true;
        end;
    else
        v66 = false;
    end;

    if v66 then
        return false;
    end;

    if require(ReplicatedStorage.Controllers.EndScreenController).IsActive() then
        return false;
    end;

    local v68 = LocalPlayer;
    local v69 = v68:GetAttribute("Team");
    local v70;

    if (v69 == "Counter-Terrorists" and true or v69 == "Terrorists") and (v68 ~= LocalPlayer or not u6) then
        local Character = v68.Character;

        if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
            local v71 = Character:FindFirstChildWhichIsA("Humanoid", true);

            if v71 == nil then
                v70 = false;
            else
                v70 = v71.Health > 0;
            end;
        else
            v70 = false;
        end;
    else
        v70 = false;
    end;

    if v70 then
        return false;
    end;

    local v72 = LocalPlayer:GetAttribute("Team");

    if v72 ~= "Counter-Terrorists" and v72 ~= "Terrorists" then
        return false;
    end;

    local v73 = require(ReplicatedStorage.Database.Components.GameState).GetState();

    return v73 ~= "Game Ending" and v73 ~= "Map Voting";
end;

local function StartSpectatingOnDeath() -- Line: 303
    -- upvalues: ShouldBeSpectating (copy), u13 (ref), u14 (ref), CameraController (copy), Constants (copy), LocalPlayer (copy), Players (copy), u6 (ref), u1 (copy)
    if not ShouldBeSpectating() then
        return;
    end;

    if u13 or u14 then
        return;
    end;

    CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    CameraController.setPerspective(true, false);
    local v74 = LocalPlayer:GetAttribute("LastKiller");
    local v75;

    if v74 then
        LocalPlayer:SetAttribute("LastKiller", nil);
        v75 = Players:FindFirstChild(v74);

        if v75 then
            local v76;

            if v75 == LocalPlayer then
                v76 = false;
            else
                local v77 = v75:GetAttribute("Team");
                local v78;

                if (v77 == "Counter-Terrorists" and true or v77 == "Terrorists") and (v75 ~= LocalPlayer or not u6) then
                    local Character = v75.Character;

                    if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                        local v79 = Character:FindFirstChildWhichIsA("Humanoid", true);

                        if v79 == nil then
                            v78 = false;
                        else
                            v78 = v79.Health > 0;
                        end;
                    else
                        v78 = false;
                    end;
                else
                    v78 = false;
                end;

                if v78 then
                    local v80 = workspace:GetAttribute("ServerGamemode");
                    local v81;

                    if ((typeof(v80) ~= "string" or v80 ~= "Casual" and (v80 ~= "Competitive" and v80 ~= "Deathmatch")) and "Casual" or v80) == "Competitive" then
                        local v82 = LocalPlayer:GetAttribute("Team");

                        if v82 == "Counter-Terrorists" and true or v82 == "Terrorists" then
                            local v83 = LocalPlayer;
                            local v84 = v83:GetAttribute("Team");
                            local v85;

                            if (v84 == "Counter-Terrorists" and true or v84 == "Terrorists") and (v83 ~= LocalPlayer or not u6) then
                                local Character = v83.Character;

                                if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                                    local v86 = Character:FindFirstChildWhichIsA("Humanoid", true);

                                    if v86 == nil then
                                        v85 = false;
                                    else
                                        v85 = v86.Health > 0;
                                    end;
                                else
                                    v85 = false;
                                end;
                            else
                                v85 = false;
                            end;

                            v81 = not v85;
                        else
                            v81 = false;
                        end;
                    else
                        v81 = false;
                    end;

                    v76 = (not v81 or LocalPlayer:GetAttribute("Team") == v75:GetAttribute("Team")) and true or false;
                else
                    v76 = false;
                end;
            end;

            if not v76 then
                v75 = nil;
            end;
        else
            v75 = nil;
        end;
    else
        v75 = nil;
    end;

    if v75 then
        u1.SetNextPlayer(v75);

        return;
    end;

    u1.Next();
end;

local function UpdateCharacters() -- Line: 329
    -- upvalues: u4 (copy), Players (copy), LocalPlayer (copy), u6 (ref)
    local v87 = workspace:GetAttribute("ServerGamemode");
    local v88 = (typeof(v87) ~= "string" or v87 ~= "Casual" and (v87 ~= "Competitive" and v87 ~= "Deathmatch")) and "Casual" or v87;
    table.clear(u4);

    for _, v in ipairs(Players:GetPlayers()) do
        local v89 = LocalPlayer:GetAttribute("Team");
        local v90 = v:GetAttribute("Team");
        local v91;

        if v == LocalPlayer then
            v91 = false;
        else
            local v92 = v:GetAttribute("Team");

            if (v92 == "Counter-Terrorists" and true or v92 == "Terrorists") and (v ~= LocalPlayer or not u6) then
                local Character = v.Character;

                if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                    local v93 = Character:FindFirstChildWhichIsA("Humanoid", true);

                    if v93 == nil then
                        v91 = false;
                    else
                        v91 = v93.Health > 0;
                    end;
                else
                    v91 = false;
                end;
            else
                v91 = false;
            end;
        end;

        if v88 == "Competitive" then
            if (v89 == "Spectators" and true or v90 == v89) and v91 then
                table.insert(u4, v);
            end;
        elseif v91 then
            table.insert(u4, v);
        end;
    end;
end;

local function IncrementSpectateIndex(p94) -- Line: 353
    -- upvalues: UpdateCharacters (copy), u4 (copy), u8 (ref)
    UpdateCharacters();

    if #u4 > 0 then
        u8 = u8 + p94;

        if u8 <= 0 then
            u8 = #u4;

            return;
        end;

        if u8 > #u4 then
            u8 = 1;
        end;
    end;
end;

function u1.GetCurrentSpectateInstance() -- Line: 372
    -- upvalues: u13 (ref)
    return u13;
end;

function u1.IsLocalPlayerDead() -- Line: 379
    -- upvalues: u6 (ref)
    return u6;
end;

function u1.GetPlayer() -- Line: 385
    -- upvalues: LocalPlayer (copy), u6 (ref), u1 (copy)
    local v95 = LocalPlayer;
    local v96 = v95:GetAttribute("Team");
    local v97;

    if (v96 == "Counter-Terrorists" and true or v96 == "Terrorists") and (v95 ~= LocalPlayer or not u6) then
        local Character = v95.Character;

        if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
            local v98 = Character:FindFirstChildWhichIsA("Humanoid", true);

            if v98 == nil then
                v97 = false;
            else
                v97 = v98.Health > 0;
            end;
        else
            v97 = false;
        end;
    else
        v97 = false;
    end;

    if v97 then
        return LocalPlayer;
    end;

    local v99 = u1.GetCurrentSpectateInstance();

    if v99 then
        return v99.Player;
    end;

    return nil;
end;

function u1.SetNextPlayer(p100) -- Line: 402
    -- upvalues: u13 (ref), LocalPlayer (copy), u1 (copy), u6 (ref), Spectate (copy), Remotes (copy)
    local v101 = u13 and u13.Player;

    if p100 == LocalPlayer then
        u1.Next();

        return;
    end;

    local v102;

    if p100 == LocalPlayer then
        v102 = false;
    else
        local v103 = p100:GetAttribute("Team");
        local v104;

        if (v103 == "Counter-Terrorists" and true or v103 == "Terrorists") and (p100 ~= LocalPlayer or not u6) then
            local Character = p100.Character;

            if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                local v105 = Character:FindFirstChildWhichIsA("Humanoid", true);

                if v105 == nil then
                    v104 = false;
                else
                    v104 = v105.Health > 0;
                end;
            else
                v104 = false;
            end;
        else
            v104 = false;
        end;

        if v104 then
            local v106 = workspace:GetAttribute("ServerGamemode");
            local v107;

            if ((typeof(v106) ~= "string" or v106 ~= "Casual" and (v106 ~= "Competitive" and v106 ~= "Deathmatch")) and "Casual" or v106) == "Competitive" then
                local v108 = LocalPlayer:GetAttribute("Team");

                if v108 == "Counter-Terrorists" and true or v108 == "Terrorists" then
                    local v109 = LocalPlayer;
                    local v110 = v109:GetAttribute("Team");
                    local v111;

                    if (v110 == "Counter-Terrorists" and true or v110 == "Terrorists") and (v109 ~= LocalPlayer or not u6) then
                        local Character = v109.Character;

                        if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                            local v112 = Character:FindFirstChildWhichIsA("Humanoid", true);

                            if v112 == nil then
                                v111 = false;
                            else
                                v111 = v112.Health > 0;
                            end;
                        else
                            v111 = false;
                        end;
                    else
                        v111 = false;
                    end;

                    v107 = not v111;
                else
                    v107 = false;
                end;
            else
                v107 = false;
            end;

            v102 = (not v107 or LocalPlayer:GetAttribute("Team") == p100:GetAttribute("Team")) and true or false;
        else
            v102 = false;
        end;
    end;

    if not v102 then
        u1.Next();

        return;
    end;

    local Character = p100.Character;
    local v113 = u13 and u13.Character == Character;
    local v114 = p100:GetAttribute("Team");
    local v115;

    if (v114 == "Counter-Terrorists" and true or v114 == "Terrorists") and (p100 ~= LocalPlayer or not u6) then
        local Character2 = p100.Character;

        if Character2 and Character2:IsDescendantOf(workspace) and not Character2:GetAttribute("Dead") then
            local v116 = Character2:FindFirstChildWhichIsA("Humanoid", true);

            if v116 == nil then
                v115 = false;
            else
                v115 = v116.Health > 0;
            end;
        else
            v115 = false;
        end;
    else
        v115 = false;
    end;

    if not (v101 == p100 and (v113 and v115)) then
        u1.Stop(false, true);
        local v117 = Character and (v115 and Character:FindFirstChildWhichIsA("Humanoid", true));

        if v117 then
            local v118 = Spectate.new(p100, Character, v117);
            u13 = v118;
            u1.ListenToSpectate:Fire(p100);
            v118.StopSpectating:Once(function() -- Line: 434
                -- upvalues: u1 (ref)
                u1.Stop(false, true);
                u1.Next();
            end);
            Remotes.Spectate.SpectatePlayer.Send(p100.Name);

            return;
        end;

        u1.Next();
    end;
end;

function u1.Switch() -- Line: 452
    -- upvalues: LocalPlayer (copy), u6 (ref), u3 (ref), u7 (ref), u13 (ref), u14 (ref), u12 (copy)
    local v119 = workspace:GetAttribute("ServerGamemode");
    local v120;

    if ((typeof(v119) ~= "string" or v119 ~= "Casual" and (v119 ~= "Competitive" and v119 ~= "Deathmatch")) and "Casual" or v119) == "Competitive" then
        local v121 = LocalPlayer:GetAttribute("Team");

        if v121 == "Counter-Terrorists" and true or v121 == "Terrorists" then
            local v122 = LocalPlayer;
            local v123 = v122:GetAttribute("Team");
            local v124;

            if (v123 == "Counter-Terrorists" and true or v123 == "Terrorists") and (v122 ~= LocalPlayer or not u6) then
                local Character = v122.Character;

                if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                    local v125 = Character:FindFirstChildWhichIsA("Humanoid", true);

                    if v125 == nil then
                        v124 = false;
                    else
                        v124 = v125.Health > 0;
                    end;
                else
                    v124 = false;
                end;
            else
                v124 = false;
            end;

            v120 = not v124;
        else
            v120 = false;
        end;
    else
        v120 = false;
    end;

    if not v120 then
        local v126 = u7 + 1;

        if #u12 < v126 then
            u3 = u12[1];
            u7 = 1;
        elseif v126 <= #u12 then
            u3 = u12[v126];
            u7 = v126;
        end;

        if u13 then
            u13:Switch(u3);
        end;

        return;
    end;

    u3 = "First-Person";
    u7 = 1;

    if u13 then
        u13:Switch("First-Person");
    end;

    if u14 then
        u14:Destroy();
        u14 = nil;
    end;
end;

function u1.UpdateIndex(p127) -- Line: 485
    -- upvalues: UpdateCharacters (copy), u4 (copy), u8 (ref), Promise (copy), LocalPlayer (copy), u6 (ref), u1 (copy)
    UpdateCharacters();

    if #u4 > 0 then
        u8 = u8 + p127;

        if u8 <= 0 then
            u8 = #u4;
        elseif u8 > #u4 then
            u8 = 1;
        end;
    end;

    return Promise.new(function(p128, p129) -- Line: 489
        -- upvalues: u4 (ref), u8 (ref), LocalPlayer (ref), u6 (ref), UpdateCharacters (ref), u1 (ref)
        local v130 = u4[u8];

        if v130 then
            local v131 = v130:GetAttribute("Team");
            local v132;

            if (v131 == "Counter-Terrorists" and true or v131 == "Terrorists") and (v130 ~= LocalPlayer or not u6) then
                local Character = v130.Character;

                if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                    local v133 = Character:FindFirstChildWhichIsA("Humanoid", true);

                    if v133 == nil then
                        v132 = false;
                    else
                        v132 = v133.Health > 0;
                    end;
                else
                    v132 = false;
                end;
            else
                v132 = false;
            end;

            if v132 then
                p128(v130);

                return;
            end;
        end;

        UpdateCharacters();

        if #u4 > 0 then
            u8 = 1;
            p128(u4[1]);

            return;
        end;

        u1.Stop(false, false);
        p129("No players alive to spectate");
    end);
end;

function u1.Next() -- Line: 510
    -- upvalues: u1 (copy)
    return u1.UpdateIndex(1):andThen(function(p134) -- Line: 511
        -- upvalues: u1 (ref)
        u1.SetNextPlayer(p134);
    end):catch(function() -- Line: 513
    end);
end;

function u1.Previous() -- Line: 518
    -- upvalues: u1 (copy)
    return u1.UpdateIndex(-1):andThen(function(p135) -- Line: 519
        -- upvalues: u1 (ref)
        u1.SetNextPlayer(p135);
    end):catch(function() -- Line: 521
    end);
end;

function u1.Stop(p136, p137) -- Line: 528
    -- upvalues: u11 (ref), LocalPlayer (copy), u10 (ref), u13 (ref), Remotes (copy), u14 (ref), u2 (copy)
    if u11 and LocalPlayer.ReplicationFocus == u11 then
        LocalPlayer.ReplicationFocus = nil;
    end;

    u10 = nil;
    u11 = nil;

    if u13 then
        u13:Destroy();
        u13 = nil;
    end;

    if p136 and LocalPlayer:GetAttribute("IsSpectating") then
        Remotes.Spectate.StopSpectating.Send();
    end;

    if p137 and u14 then
        u14:Destroy();
        u14 = nil;
    end;

    u2:Fire();
end;

function u1.Broadcast() -- Line: 553
    -- upvalues: LocalPlayer (copy), u9 (ref), InventoryController (copy), MenuState (copy), Remotes (copy), CurrentCamera (copy)
    local v138 = LocalPlayer:GetAttribute("Spectators");
    local v139 = v138 and v138 > 0 and 0.016666666666666666 or 0.2;

    if v139 <= u9 then
        local v140 = InventoryController.getCurrentEquipped();
        u9 = u9 - v139;

        if v140 then
            local v141 = LocalPlayer.PlayerGui:FindFirstChild("MainGui") and LocalPlayer.PlayerGui.MainGui:FindFirstChild("Menu");

            if v141 then
                v141 = v141:FindFirstChild("Inspect");
            end;

            if v141 and v141.Visible then
                return;
            end;

            if MenuState.IsCaseSceneActive() then
                return;
            end;

            Remotes.Spectate.UpdateCameraCFrame.Send(CurrentCamera.CFrame);
        end;
    end;
end;

function u1.Render(p142) -- Line: 588
    -- upvalues: u5 (ref), u9 (ref), LocalPlayer (copy), u6 (ref), u3 (ref), u7 (ref), u13 (ref), u14 (ref), u1 (copy), u11 (ref), u10 (ref), CurrentCamera (copy), CameraController (copy), ShouldBeSpectating (copy), MenuState (copy), Router (copy), UpdateCharacters (copy), u4 (copy), u8 (ref), GetSpectateBombModel (copy), Constants (copy), Freecam (copy)
    u5 = u5 + p142;
    u9 = u9 + p142;
    local v143 = workspace:GetAttribute("ServerGamemode");
    local v144;

    if ((typeof(v143) ~= "string" or v143 ~= "Casual" and (v143 ~= "Competitive" and v143 ~= "Deathmatch")) and "Casual" or v143) == "Competitive" then
        local v145 = LocalPlayer:GetAttribute("Team");

        if v145 == "Counter-Terrorists" and true or v145 == "Terrorists" then
            local v146 = LocalPlayer;
            local v147 = v146:GetAttribute("Team");
            local v148;

            if (v147 == "Counter-Terrorists" and true or v147 == "Terrorists") and (v146 ~= LocalPlayer or not u6) then
                local Character = v146.Character;

                if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                    local v149 = Character:FindFirstChildWhichIsA("Humanoid", true);

                    if v149 == nil then
                        v148 = false;
                    else
                        v148 = v149.Health > 0;
                    end;
                else
                    v148 = false;
                end;
            else
                v148 = false;
            end;

            v144 = not v148;
        else
            v144 = false;
        end;
    else
        v144 = false;
    end;

    if v144 then
        local v150 = workspace:GetAttribute("ServerGamemode");
        local v151;

        if ((typeof(v150) ~= "string" or v150 ~= "Casual" and (v150 ~= "Competitive" and v150 ~= "Deathmatch")) and "Casual" or v150) == "Competitive" then
            local v152 = LocalPlayer:GetAttribute("Team");

            if v152 == "Counter-Terrorists" and true or v152 == "Terrorists" then
                local v153 = LocalPlayer;
                local v154 = v153:GetAttribute("Team");
                local v155;

                if (v154 == "Counter-Terrorists" and true or v154 == "Terrorists") and (v153 ~= LocalPlayer or not u6) then
                    local Character = v153.Character;

                    if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                        local v156 = Character:FindFirstChildWhichIsA("Humanoid", true);

                        if v156 == nil then
                            v155 = false;
                        else
                            v155 = v156.Health > 0;
                        end;
                    else
                        v155 = false;
                    end;
                else
                    v155 = false;
                end;

                v151 = not v155;
            else
                v151 = false;
            end;
        else
            v151 = false;
        end;

        if v151 then
            u3 = "First-Person";
            u7 = 1;

            if u13 and u13.PerspectiveState ~= "First-Person" then
                u13:Switch("First-Person");
            end;

            if u14 then
                u14:Destroy();
                u14 = nil;
            end;
        end;
    end;

    if u6 then
        local Character = LocalPlayer.Character;
        local v157;

        if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
            local v158 = Character:FindFirstChildWhichIsA("Humanoid", true);

            if v158 == nil then
                v157 = false;
            else
                v157 = v158.Health > 0;
            end;
        else
            v157 = false;
        end;

        if v157 then
            u6 = false;
        end;
    end;

    local v159 = LocalPlayer;
    local v160 = v159:GetAttribute("Team");
    local v161;

    if (v160 == "Counter-Terrorists" and true or v160 == "Terrorists") and (v159 ~= LocalPlayer or not u6) then
        local Character = v159.Character;

        if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
            local v162 = Character:FindFirstChildWhichIsA("Humanoid", true);

            if v162 == nil then
                v161 = false;
            else
                v161 = v162.Health > 0;
            end;
        else
            v161 = false;
        end;
    else
        v161 = false;
    end;

    if v161 then
        u1.Broadcast();

        if u11 and LocalPlayer.ReplicationFocus == u11 then
            LocalPlayer.ReplicationFocus = nil;
        end;

        u10 = nil;
        u11 = nil;

        if u13 then
            u1.Stop(true, true);
        end;

        if u14 then
            u14:Destroy();
            u14 = nil;
        end;

        local v163 = LocalPlayer;
        local v164 = v163:GetAttribute("Team");
        local v165;

        if (v164 == "Counter-Terrorists" and true or v164 == "Terrorists") and (v163 ~= LocalPlayer or not u6) then
            local Character = v163.Character;

            if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                local v166 = Character:FindFirstChildWhichIsA("Humanoid", true);

                if v166 == nil then
                    v165 = false;
                else
                    v165 = v166.Health > 0;
                end;
            else
                v165 = false;
            end;
        else
            v165 = false;
        end;

        if v165 then
            local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid");

            if Humanoid then
                CurrentCamera.CameraType = Enum.CameraType.Custom;
                CurrentCamera.CameraSubject = Humanoid;
            end;

            CameraController.setPerspective(true, false);
        end;
    elseif ShouldBeSpectating() or LocalPlayer:GetAttribute("IsSpectating") then
        local v167;

        if MenuState.WantsMainMenu() then
            local v168 = MenuState.GetMenuFrame();

            if v168 == nil then
                v167 = false;
            else
                v167 = v168.Visible == true;
            end;
        else
            v167 = false;
        end;

        if v167 then
            if u13 then
                u1.Stop(false, true);

                return;
            end;

            if u11 and LocalPlayer.ReplicationFocus == u11 then
                LocalPlayer.ReplicationFocus = nil;
            end;

            u10 = nil;
            u11 = nil;
        else
            if MenuState.IsCaseSceneActive() then
                return;
            end;

            if u13 then
                if u11 and LocalPlayer.ReplicationFocus == u11 then
                    LocalPlayer.ReplicationFocus = nil;
                end;

                u10 = nil;
                u11 = nil;

                if Router.broadcastRouter("IsInspectActive") then
                    return;
                end;

                u13:Render(p142);

                if u14 then
                    u14:Destroy();
                    u14 = nil;
                end;
            else
                if u5 >= 0.2 then
                    u5 = 0;
                    UpdateCharacters();

                    if #u4 > 0 then
                        u8 = u8 + 1;

                        if u8 <= 0 then
                            u8 = #u4;
                        elseif u8 > #u4 then
                            u8 = 1;
                        end;
                    end;
                end;

                if u4[u8] then
                    if u11 and LocalPlayer.ReplicationFocus == u11 then
                        LocalPlayer.ReplicationFocus = nil;
                    end;

                    u10 = nil;
                    u11 = nil;
                    u1.Next();

                    return;
                end;

                if v144 then
                    u10 = not (u10 and u10.Parent) and GetSpectateBombModel();

                    if u10 then
                        CameraController.setPerspective(false, false);
                        CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
                    end;

                    if u10 then
                        local v169 = u10;
                        local v170;

                        if v169 and v169.Parent then
                            local PrimaryPart = v169.PrimaryPart;

                            if PrimaryPart then
                                if u11 ~= PrimaryPart then
                                    u11 = PrimaryPart;
                                    LocalPlayer.ReplicationFocus = PrimaryPart;
                                end;

                                CurrentCamera.CameraType = Enum.CameraType.Follow;
                                CurrentCamera.CameraSubject = PrimaryPart;
                                v170 = true;
                            else
                                v170 = false;
                            end;
                        else
                            v170 = false;
                        end;

                        if v170 then
                            if u14 then
                                u14:Destroy();
                                u14 = nil;
                            end;

                            return;
                        end;
                    end;

                    if u11 and LocalPlayer.ReplicationFocus == u11 then
                        LocalPlayer.ReplicationFocus = nil;
                    end;

                    u10 = nil;
                    u11 = nil;

                    if u14 then
                        u14:Destroy();
                        u14 = nil;
                    end;

                    return;
                end;

                if u11 and LocalPlayer.ReplicationFocus == u11 then
                    LocalPlayer.ReplicationFocus = nil;
                end;

                u10 = nil;
                u11 = nil;
                u14 = not u14 and Freecam.new();

                if u14 then
                    u14:Start();
                end;
            end;
        end;
    else
        if u13 then
            u1.Stop(false, true);

            return;
        end;

        if u11 and LocalPlayer.ReplicationFocus == u11 then
            LocalPlayer.ReplicationFocus = nil;
        end;

        u10 = nil;
        u11 = nil;
    end;
end;

function u1.Initialize() -- Line: 715
    -- upvalues: Observers (copy), LocalPlayer (copy), MenuState (copy), u1 (copy), CameraController (copy), Constants (copy), u13 (ref), Players (copy), u6 (ref), Remotes (copy), StartSpectatingOnDeath (copy), ReplicatedStorage (copy), RunServiceController (copy)
    Observers.observeAttribute(LocalPlayer, "IsSpectating", function(p171) -- Line: 717
        -- upvalues: LocalPlayer (ref), MenuState (ref), u1 (ref), CameraController (ref), Constants (ref), u13 (ref), Players (ref), u6 (ref)
        if p171 then
            LocalPlayer:SetAttribute("PendingSpectateRequestAt", nil);

            if MenuState.IsCaseSceneActive() then
                return function() -- Line: 723
                    -- upvalues: u1 (ref)
                    u1.Stop(false, true);
                end;
            end;

            local v172;

            if MenuState.WantsMainMenu() then
                local v173 = MenuState.GetMenuFrame();

                if v173 == nil then
                    v172 = false;
                else
                    v172 = v173.Visible == true;
                end;
            else
                v172 = false;
            end;

            if v172 then
                return function() -- Line: 730
                    -- upvalues: u1 (ref)
                    u1.Stop(false, true);
                end;
            end;

            CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
            CameraController.setPerspective(true, false);

            if not u13 then
                local v174 = LocalPlayer:GetAttribute("LastKiller");
                local v175;

                if v174 then
                    LocalPlayer:SetAttribute("LastKiller", nil);
                    v175 = Players:FindFirstChild(v174);

                    if v175 then
                        local v176;

                        if v175 == LocalPlayer then
                            v176 = false;
                        else
                            local v177 = v175:GetAttribute("Team");
                            local v178;

                            if (v177 == "Counter-Terrorists" and true or v177 == "Terrorists") and (v175 ~= LocalPlayer or not u6) then
                                local Character = v175.Character;

                                if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                                    local v179 = Character:FindFirstChildWhichIsA("Humanoid", true);

                                    if v179 == nil then
                                        v178 = false;
                                    else
                                        v178 = v179.Health > 0;
                                    end;
                                else
                                    v178 = false;
                                end;
                            else
                                v178 = false;
                            end;

                            if v178 then
                                local v180 = workspace:GetAttribute("ServerGamemode");
                                local v181;

                                if ((typeof(v180) ~= "string" or v180 ~= "Casual" and (v180 ~= "Competitive" and v180 ~= "Deathmatch")) and "Casual" or v180) == "Competitive" then
                                    local v182 = LocalPlayer:GetAttribute("Team");

                                    if v182 == "Counter-Terrorists" and true or v182 == "Terrorists" then
                                        local v183 = LocalPlayer;
                                        local v184 = v183:GetAttribute("Team");
                                        local v185;

                                        if (v184 == "Counter-Terrorists" and true or v184 == "Terrorists") and (v183 ~= LocalPlayer or not u6) then
                                            local Character = v183.Character;

                                            if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
                                                local v186 = Character:FindFirstChildWhichIsA("Humanoid", true);

                                                if v186 == nil then
                                                    v185 = false;
                                                else
                                                    v185 = v186.Health > 0;
                                                end;
                                            else
                                                v185 = false;
                                            end;
                                        else
                                            v185 = false;
                                        end;

                                        v181 = not v185;
                                    else
                                        v181 = false;
                                    end;
                                else
                                    v181 = false;
                                end;

                                v176 = (not v181 or LocalPlayer:GetAttribute("Team") == v175:GetAttribute("Team")) and true or false;
                            else
                                v176 = false;
                            end;
                        end;

                        if not v176 then
                            v175 = nil;
                        end;
                    else
                        v175 = nil;
                    end;
                else
                    v175 = nil;
                end;

                if v175 then
                    u1.SetNextPlayer(v175);
                else
                    u1.Next();
                end;
            end;
        end;

        return function() -- Line: 752
            -- upvalues: u1 (ref)
            u1.Stop(false, true);
        end;
    end);
    Remotes.Character.CharacterDied.Listen(function() -- Line: 760
        -- upvalues: LocalPlayer (ref), u6 (ref), StartSpectatingOnDeath (ref)
        local Character = LocalPlayer.Character;
        local v187;

        if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
            local v188 = Character:FindFirstChildWhichIsA("Humanoid", true);

            if v188 == nil then
                v187 = false;
            else
                v187 = v188.Health > 0;
            end;
        else
            v187 = false;
        end;

        if v187 then
            u6 = false;

            return;
        end;

        u6 = true;
        StartSpectatingOnDeath();
    end);
    LocalPlayer.CharacterAdded:Connect(function(u189) -- Line: 773
        -- upvalues: u6 (ref), LocalPlayer (ref), MenuState (ref), u1 (ref), Remotes (ref), u13 (ref), StartSpectatingOnDeath (ref)
        u6 = false;
        local v190 = LocalPlayer:GetAttribute("Team");
        local v191 = u189:FindFirstChildWhichIsA("Humanoid", true);

        if v191 then
            if v191.Health > 0 then
                v191 = not u189:GetAttribute("Dead");
            else
                v191 = false;
            end;
        end;

        local v192 = LocalPlayer:GetAttribute("PendingSpectateRequestAt");
        local v193;

        if v192 == nil then
            v193 = false;
        else
            v193 = os.clock() - v192 < 3;
        end;

        if (v190 == "Counter-Terrorists" and true or v190 == "Terrorists") and v191 then
            MenuState.SetWantsMainMenu(false);
            u1.Stop(not v193, true);

            if not v193 and LocalPlayer:GetAttribute("IsSpectating") then
                Remotes.Spectate.StopSpectating.Send();
            end;
        elseif u13 and u13.Player then
            Remotes.Spectate.SpectatePlayer.Send(u13.Player.Name);
        end;

        local u194 = u189:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 806
            -- upvalues: u189 (copy), StartSpectatingOnDeath (ref)
            if not u189:GetAttribute("Dead") then
                return;
            end;

            StartSpectatingOnDeath();
        end);
        local u195 = nil;
        u195 = u189.AncestryChanged:Connect(function(p196, p197) -- Line: 813
            -- upvalues: u194 (ref), u195 (ref)
            if not p197 then
                if u194 then
                    u194:Disconnect();
                    u194 = nil;
                end;

                if u195 then
                    u195:Disconnect();
                    u195 = nil;
                end;
            end;
        end);
    end);
    require(ReplicatedStorage.Database.Components.GameState).ListenToState(function(p198, p199) -- Line: 829
        -- upvalues: u1 (ref)
        if p199 ~= "Game Ending" and p199 ~= "Map Voting" then
            return;
        end;

        u1.Stop(false, true);
    end);
    RunServiceController.BindToRenderStep("SpectateController.Render", function(p200) -- Line: 837
        -- upvalues: u1 (ref)
        u1.Render(p200);
    end);
end;

function u1.Start() -- Line: 842
    -- upvalues: Remotes (copy), u13 (ref), UserInputService (copy), LocalPlayer (copy), u1 (copy), CurrentCamera (copy)
    Remotes.Spectate.ReplicateSpectateEvent.Listen(function(...) -- Line: 844
        -- upvalues: u13 (ref)
        if not u13 then
            return;
        end;

        u13:AddSpectateEvent(...);
    end);
    UserInputService.InputBegan:Connect(function(p201) -- Line: 852
        -- upvalues: LocalPlayer (ref), u1 (ref)
        if not LocalPlayer:GetAttribute("IsSpectating") or (p201.KeyCode ~= Enum.KeyCode.Space or LocalPlayer:GetAttribute("IsPlayerChatting")) then
            return;
        end;

        u1.Switch();
    end);

    if UserInputService.TouchEnabled then
        UserInputService.TouchStarted:Connect(function(p202, p203) -- Line: 861
            -- upvalues: LocalPlayer (ref), CurrentCamera (ref), u1 (ref)
            if p203 or LocalPlayer:GetAttribute("IsPlayerChatting") then
                return;
            end;

            if not LocalPlayer:GetAttribute("IsSpectating") then
                return;
            end;

            if CurrentCamera.ViewportSize.X / 2 > p202.Position.X then
                u1.Previous();

                return;
            end;

            u1.Next();
        end);
    end;
end;

return u1;