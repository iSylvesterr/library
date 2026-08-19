-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local PlayerStateClient = require(ReplicatedStorage.ClientModules.PlayerStateClient);
local LocalPlayer = Players.LocalPlayer;
local u1 = {
    Raccoon = "Raccoons"
};
local u2 = {};

local function getPetNameFromTool(p3) -- Line: 53
    -- upvalues: u2 (copy)
    if p3:GetAttribute("PetId") ~= nil then
        return nil;
    end;

    for _, v in u2 do
        local v4 = p3:GetAttribute(v);

        if type(v4) == "string" and v4 ~= "" then
            return v4;
        end;
    end;

    return nil;
end;

local v5 = {
    StartOrder = 5
};
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = {};
local u13 = {};

local function setUiEnabled(p14) -- Line: 94
    -- upvalues: u6 (ref)
    if u6 then
        u6.Enabled = p14;
    end;
end;

local function getInventoryCount(p15) -- Line: 100
    -- upvalues: u1 (copy), PlayerStateClient (copy)
    local v16 = u1[p15];

    if not v16 then
        return 0;
    end;

    local v17 = PlayerStateClient:GetLocalReplica();

    if not (v17 and v17.Data) then
        return 0;
    end;

    local Inventory = v17.Data.Inventory;

    if type(Inventory) ~= "table" then
        return 0;
    end;

    local v18 = Inventory[v16];

    return type(v18) == "table" and (tonumber(v18[p15]) or 0) or 0;
end;

local function getFollowerCount(p19) -- Line: 118
    -- upvalues: PlayerStateClient (copy)
    local v20 = PlayerStateClient:GetLocalReplica();

    if not (v20 and v20.Data) then
        return 0;
    end;

    local Inventory = v20.Data.Inventory;

    if type(Inventory) ~= "table" then
        return 0;
    end;

    local Pets = Inventory.Pets;

    return type(Pets) == "table" and (tonumber(Pets[p19]) or 0) or 0;
end;

local function refreshUnequipVisibility() -- Line: 128
    -- upvalues: u9 (ref), u11 (ref), PlayerStateClient (copy), u12 (copy)
    if not u9 then
        return;
    end;

    if not u11 then
        u9.Visible = false;

        return;
    end;

    local v21 = u11;
    local v22 = PlayerStateClient:GetLocalReplica();
    local v23;

    if v22 and v22.Data then
        local Inventory = v22.Data.Inventory;

        if type(Inventory) == "table" then
            local Pets = Inventory.Pets;
            v23 = type(Pets) == "table" and (tonumber(Pets[v21]) or 0) or 0;
        else
            v23 = 0;
        end;
    else
        v23 = 0;
    end;

    local v24 = u12[u11] or 0;

    if v23 > 0 then
        v24 = v23;
    end;

    u9.Visible = v24 > 0;
end;

local function refreshEquipVisibility() -- Line: 147
    -- upvalues: u8 (ref), u11 (ref), u1 (copy), PlayerStateClient (copy)
    if not u8 then
        return;
    end;

    if not u11 then
        u8.Visible = false;

        return;
    end;

    local v25 = u11;
    local v26 = u1[v25];
    local v27;

    if v26 then
        local v28 = PlayerStateClient:GetLocalReplica();

        if v28 and v28.Data then
            local Inventory = v28.Data.Inventory;

            if type(Inventory) == "table" then
                local v29 = Inventory[v26];
                v27 = type(v29) == "table" and (tonumber(v29[v25]) or 0) or 0;
            else
                v27 = 0;
            end;
        else
            v27 = 0;
        end;
    else
        v27 = 0;
    end;

    u8.Visible = v27 > 0;
end;

local function refreshButtonVisibility() -- Line: 156
    -- upvalues: u8 (ref), u11 (ref), u1 (copy), PlayerStateClient (copy), u9 (ref), u12 (copy)
    if u8 then
        if u11 then
            local v30 = u11;
            local v31 = u1[v30];
            local v32;

            if v31 then
                local v33 = PlayerStateClient:GetLocalReplica();

                if v33 and v33.Data then
                    local Inventory = v33.Data.Inventory;

                    if type(Inventory) == "table" then
                        local v34 = Inventory[v31];
                        v32 = type(v34) == "table" and (tonumber(v34[v30]) or 0) or 0;
                    else
                        v32 = 0;
                    end;
                else
                    v32 = 0;
                end;
            else
                v32 = 0;
            end;

            u8.Visible = v32 > 0;
        else
            u8.Visible = false;
        end;
    end;

    if not u9 then
        return;
    end;

    if not u11 then
        u9.Visible = false;

        return;
    end;

    local v35 = u11;
    local v36 = PlayerStateClient:GetLocalReplica();
    local v37;

    if v36 and v36.Data then
        local Inventory = v36.Data.Inventory;

        if type(Inventory) == "table" then
            local Pets = Inventory.Pets;
            v37 = type(Pets) == "table" and (tonumber(Pets[v35]) or 0) or 0;
        else
            v37 = 0;
        end;
    else
        v37 = 0;
    end;

    local v38 = u12[u11] or 0;

    if v37 > 0 then
        v38 = v37;
    end;

    u9.Visible = v38 > 0;
end;

local function setHeldPetTool(p39) -- Line: 161
    -- upvalues: u10 (ref), u11 (ref), getPetNameFromTool (copy), u6 (ref), u8 (ref), u1 (copy), PlayerStateClient (copy), u9 (ref), u12 (copy)
    u10 = p39;
    local v40;

    if p39 then
        v40 = getPetNameFromTool(p39);
    else
        v40 = nil;
    end;

    u11 = v40;

    if not u11 then
        if u6 then
            u6.Enabled = false;
        end;

        return;
    end;

    if u6 then
        u6.Enabled = true;
    end;

    if u8 then
        if u11 then
            local v41 = u11;
            local v42 = u1[v41];
            local v43;

            if v42 then
                local v44 = PlayerStateClient:GetLocalReplica();

                if v44 and v44.Data then
                    local Inventory = v44.Data.Inventory;

                    if type(Inventory) == "table" then
                        local v45 = Inventory[v42];
                        v43 = type(v45) == "table" and (tonumber(v45[v41]) or 0) or 0;
                    else
                        v43 = 0;
                    end;
                else
                    v43 = 0;
                end;
            else
                v43 = 0;
            end;

            u8.Visible = v43 > 0;
        else
            u8.Visible = false;
        end;
    end;

    if not u9 then
        return;
    end;

    if not u11 then
        u9.Visible = false;

        return;
    end;

    local v46 = u11;
    local v47 = PlayerStateClient:GetLocalReplica();
    local v48;

    if v47 and v47.Data then
        local Inventory = v47.Data.Inventory;

        if type(Inventory) == "table" then
            local Pets = Inventory.Pets;
            v48 = type(Pets) == "table" and (tonumber(Pets[v46]) or 0) or 0;
        else
            v48 = 0;
        end;
    else
        v48 = 0;
    end;

    local v49 = u12[u11] or 0;

    if v48 > 0 then
        v49 = v48;
    end;

    u9.Visible = v49 > 0;
end;

local function isPetTool(p50) -- Line: 173
    -- upvalues: getPetNameFromTool (copy)
    if p50:IsA("Tool") then
        return getPetNameFromTool(p50) ~= nil;
    end;

    return false;
end;

function v5.Start(p51) -- Line: 180
    -- upvalues: LocalPlayer (copy), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u11 (ref), Networking (copy), u1 (copy), PlayerStateClient (copy), u12 (copy), u13 (copy), u10 (ref), getPetNameFromTool (copy)
    local EquipPet = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("EquipPet", 30);

    if not (EquipPet and EquipPet:IsA("ScreenGui")) then
        return;
    end;

    local Container = EquipPet:WaitForChild("Container", 10);

    if not (Container and Container:IsA("GuiObject")) then
        return;
    end;

    local EquipButton = Container:WaitForChild("EquipButton", 10);
    local UnequipButton = Container:WaitForChild("UnequipButton", 10);

    if not (EquipButton and EquipButton:IsA("GuiButton")) then
        return;
    end;

    if not (UnequipButton and UnequipButton:IsA("GuiButton")) then
        return;
    end;

    u6 = EquipPet;
    u7 = Container;
    u8 = EquipButton;
    u9 = UnequipButton;
    EquipPet.Enabled = false;
    EquipButton.Visible = false;
    UnequipButton.Visible = false;
    EquipButton.Activated:Connect(function() -- Line: 220
        -- upvalues: u11 (ref), Networking (ref)
        if not u11 then
            return;
        end;

        Networking.Pets.RequestEquipByName:Fire(u11);
    end);
    UnequipButton.Activated:Connect(function() -- Line: 225
        -- upvalues: u11 (ref), Networking (ref)
        if not u11 then
            return;
        end;

        Networking.Pets.RequestUnequipByName:Fire(u11);
    end);
    task.spawn(function() -- Line: 235
        -- upvalues: Networking (ref), u8 (ref), u11 (ref), u1 (ref), PlayerStateClient (ref), u9 (ref), u12 (ref), u13 (ref)
        local success, result = pcall(function() -- Line: 236
            -- upvalues: Networking (ref)
            return Networking.Pets.GetEquippedPets:Fire();
        end);

        if not success or type(result) ~= "table" then
            if u8 then
                if u11 then
                    local v52 = u11;
                    local v53 = u1[v52];
                    local v54;

                    if v53 then
                        local v55 = PlayerStateClient:GetLocalReplica();

                        if v55 and v55.Data then
                            local Inventory = v55.Data.Inventory;

                            if type(Inventory) == "table" then
                                local v56 = Inventory[v53];
                                v54 = type(v56) == "table" and (tonumber(v56[v52]) or 0) or 0;
                            else
                                v54 = 0;
                            end;
                        else
                            v54 = 0;
                        end;
                    else
                        v54 = 0;
                    end;

                    u8.Visible = v54 > 0;
                else
                    u8.Visible = false;
                end;
            end;

            if not u9 then
                return;
            end;

            if not u11 then
                u9.Visible = false;

                return;
            end;

            local v57 = u11;
            local v58 = PlayerStateClient:GetLocalReplica();
            local v59;

            if v58 and v58.Data then
                local Inventory = v58.Data.Inventory;

                if type(Inventory) == "table" then
                    local Pets = Inventory.Pets;
                    v59 = type(Pets) == "table" and (tonumber(Pets[v57]) or 0) or 0;
                else
                    v59 = 0;
                end;
            else
                v59 = 0;
            end;

            local v60 = u12[u11] or 0;

            if v59 > 0 then
                v60 = v59;
            end;

            u9.Visible = v60 > 0;

            return;
        end;

        for _, v in result do
            if type(v) == "table" and (type(v.Name) == "string" and type(v.Id) == "string") then
                u12[v.Name] = (u12[v.Name] or 0) + 1;
                u13[v.Id] = v.Name;
            end;
        end;

        if u8 then
            if u11 then
                local v61 = u11;
                local v62 = u1[v61];
                local v63;

                if v62 then
                    local v64 = PlayerStateClient:GetLocalReplica();

                    if v64 and v64.Data then
                        local Inventory = v64.Data.Inventory;

                        if type(Inventory) == "table" then
                            local v65 = Inventory[v62];
                            v63 = type(v65) == "table" and (tonumber(v65[v61]) or 0) or 0;
                        else
                            v63 = 0;
                        end;
                    else
                        v63 = 0;
                    end;
                else
                    v63 = 0;
                end;

                u8.Visible = v63 > 0;
            else
                u8.Visible = false;
            end;
        end;

        if not u9 then
            return;
        end;

        if not u11 then
            u9.Visible = false;

            return;
        end;

        local v66 = u11;
        local v67 = PlayerStateClient:GetLocalReplica();
        local v68;

        if v67 and v67.Data then
            local Inventory = v67.Data.Inventory;

            if type(Inventory) == "table" then
                local Pets = Inventory.Pets;
                v68 = type(Pets) == "table" and (tonumber(Pets[v66]) or 0) or 0;
            else
                v68 = 0;
            end;
        else
            v68 = 0;
        end;

        local v69 = u12[u11] or 0;

        if v68 > 0 then
            v69 = v68;
        end;

        u9.Visible = v69 > 0;
    end);
    Networking.Pets.PetEquipped.OnClientEvent:Connect(function(p70, p71) -- Line: 255
        -- upvalues: u13 (ref), u12 (ref), u8 (ref), u11 (ref), u1 (ref), PlayerStateClient (ref), u9 (ref)
        if type(p70) ~= "string" or type(p71) ~= "table" then
            return;
        end;

        local Name = p71.Name;

        if type(Name) ~= "string" then
            return;
        end;

        if not u13[p70] then
            u13[p70] = Name;
            u12[Name] = (u12[Name] or 0) + 1;
        end;

        if u8 then
            if u11 then
                local v72 = u11;
                local v73 = u1[v72];
                local v74;

                if v73 then
                    local v75 = PlayerStateClient:GetLocalReplica();

                    if v75 and v75.Data then
                        local Inventory = v75.Data.Inventory;

                        if type(Inventory) == "table" then
                            local v76 = Inventory[v73];
                            v74 = type(v76) == "table" and (tonumber(v76[v72]) or 0) or 0;
                        else
                            v74 = 0;
                        end;
                    else
                        v74 = 0;
                    end;
                else
                    v74 = 0;
                end;

                u8.Visible = v74 > 0;
            else
                u8.Visible = false;
            end;
        end;

        if not u9 then
            return;
        end;

        if not u11 then
            u9.Visible = false;

            return;
        end;

        local v77 = u11;
        local v78 = PlayerStateClient:GetLocalReplica();
        local v79;

        if v78 and v78.Data then
            local Inventory = v78.Data.Inventory;

            if type(Inventory) == "table" then
                local Pets = Inventory.Pets;
                v79 = type(Pets) == "table" and (tonumber(Pets[v77]) or 0) or 0;
            else
                v79 = 0;
            end;
        else
            v79 = 0;
        end;

        local v80 = u12[u11] or 0;

        if v79 > 0 then
            v80 = v79;
        end;

        u9.Visible = v80 > 0;
    end);
    Networking.Pets.PetUnequipped.OnClientEvent:Connect(function(p81) -- Line: 269
        -- upvalues: u13 (ref), u12 (ref), u8 (ref), u11 (ref), u1 (ref), PlayerStateClient (ref), u9 (ref)
        if type(p81) ~= "string" then
            return;
        end;

        local v82 = u13[p81];

        if not v82 then
            return;
        end;

        u13[p81] = nil;
        local v83 = (u12[v82] or 0) - 1;

        if v83 <= 0 then
            v83 = nil;
        end;

        u12[v82] = v83;

        if u8 then
            if u11 then
                local v84 = u11;
                local v85 = u1[v84];
                local v86;

                if v85 then
                    local v87 = PlayerStateClient:GetLocalReplica();

                    if v87 and v87.Data then
                        local Inventory = v87.Data.Inventory;

                        if type(Inventory) == "table" then
                            local v88 = Inventory[v85];
                            v86 = type(v88) == "table" and (tonumber(v88[v84]) or 0) or 0;
                        else
                            v86 = 0;
                        end;
                    else
                        v86 = 0;
                    end;
                else
                    v86 = 0;
                end;

                u8.Visible = v86 > 0;
            else
                u8.Visible = false;
            end;
        end;

        if not u9 then
            return;
        end;

        if not u11 then
            u9.Visible = false;

            return;
        end;

        local v89 = u11;
        local v90 = PlayerStateClient:GetLocalReplica();
        local v91;

        if v90 and v90.Data then
            local Inventory = v90.Data.Inventory;

            if type(Inventory) == "table" then
                local Pets = Inventory.Pets;
                v91 = type(Pets) == "table" and (tonumber(Pets[v89]) or 0) or 0;
            else
                v91 = 0;
            end;
        else
            v91 = 0;
        end;

        local v92 = u12[u11] or 0;

        if v91 > 0 then
            v92 = v91;
        end;

        u9.Visible = v92 > 0;
    end);

    local function attachInventoryListener() -- Line: 284
        -- upvalues: PlayerStateClient (ref), u8 (ref), u11 (ref), u1 (ref), u9 (ref), u12 (ref)
        local v93 = PlayerStateClient:GetLocalReplica();

        if not v93 then
            return;
        end;

        v93:OnChange(function(p94, p95) -- Line: 287
            -- upvalues: u8 (ref), u11 (ref), u1 (ref), PlayerStateClient (ref), u9 (ref), u12 (ref)
            if type(p95) ~= "table" then
                return;
            end;

            if p95[1] ~= "Inventory" then
                return;
            end;

            if u8 then
                if u11 then
                    local v96 = u11;
                    local v97 = u1[v96];
                    local v98;

                    if v97 then
                        local v99 = PlayerStateClient:GetLocalReplica();

                        if v99 and v99.Data then
                            local Inventory = v99.Data.Inventory;

                            if type(Inventory) == "table" then
                                local v100 = Inventory[v97];
                                v98 = type(v100) == "table" and (tonumber(v100[v96]) or 0) or 0;
                            else
                                v98 = 0;
                            end;
                        else
                            v98 = 0;
                        end;
                    else
                        v98 = 0;
                    end;

                    u8.Visible = v98 > 0;
                else
                    u8.Visible = false;
                end;
            end;

            if not u9 then
                return;
            end;

            if not u11 then
                u9.Visible = false;

                return;
            end;

            local v101 = u11;
            local v102 = PlayerStateClient:GetLocalReplica();
            local v103;

            if v102 and v102.Data then
                local Inventory = v102.Data.Inventory;

                if type(Inventory) == "table" then
                    local Pets = Inventory.Pets;
                    v103 = type(Pets) == "table" and (tonumber(Pets[v101]) or 0) or 0;
                else
                    v103 = 0;
                end;
            else
                v103 = 0;
            end;

            local v104 = u12[u11] or 0;

            if v103 > 0 then
                v104 = v103;
            end;

            u9.Visible = v104 > 0;
        end);
    end;

    if PlayerStateClient:GetLocalReplica() then
        local v105 = PlayerStateClient:GetLocalReplica();

        if v105 then
            v105:OnChange(function(p106, p107) -- Line: 287
                -- upvalues: u8 (ref), u11 (ref), u1 (ref), PlayerStateClient (ref), u9 (ref), u12 (ref)
                if type(p107) ~= "table" then
                    return;
                end;

                if p107[1] ~= "Inventory" then
                    return;
                end;

                if u8 then
                    if u11 then
                        local v108 = u11;
                        local v109 = u1[v108];
                        local v110;

                        if v109 then
                            local v111 = PlayerStateClient:GetLocalReplica();

                            if v111 and v111.Data then
                                local Inventory = v111.Data.Inventory;

                                if type(Inventory) == "table" then
                                    local v112 = Inventory[v109];
                                    v110 = type(v112) == "table" and (tonumber(v112[v108]) or 0) or 0;
                                else
                                    v110 = 0;
                                end;
                            else
                                v110 = 0;
                            end;
                        else
                            v110 = 0;
                        end;

                        u8.Visible = v110 > 0;
                    else
                        u8.Visible = false;
                    end;
                end;

                if not u9 then
                    return;
                end;

                if not u11 then
                    u9.Visible = false;

                    return;
                end;

                local v113 = u11;
                local v114 = PlayerStateClient:GetLocalReplica();
                local v115;

                if v114 and v114.Data then
                    local Inventory = v114.Data.Inventory;

                    if type(Inventory) == "table" then
                        local Pets = Inventory.Pets;
                        v115 = type(Pets) == "table" and (tonumber(Pets[v113]) or 0) or 0;
                    else
                        v115 = 0;
                    end;
                else
                    v115 = 0;
                end;

                local v116 = u12[u11] or 0;

                if v115 > 0 then
                    v116 = v115;
                end;

                u9.Visible = v116 > 0;
            end);
        end;
    else
        PlayerStateClient:OnLocalReplica(function() -- Line: 298
            -- upvalues: PlayerStateClient (ref), u8 (ref), u11 (ref), u1 (ref), u9 (ref), u12 (ref)
            local v117 = PlayerStateClient:GetLocalReplica();

            if v117 then
                v117:OnChange(function(p118, p119) -- Line: 287
                    -- upvalues: u8 (ref), u11 (ref), u1 (ref), PlayerStateClient (ref), u9 (ref), u12 (ref)
                    if type(p119) ~= "table" then
                        return;
                    end;

                    if p119[1] ~= "Inventory" then
                        return;
                    end;

                    if u8 then
                        if u11 then
                            local v120 = u11;
                            local v121 = u1[v120];
                            local v122;

                            if v121 then
                                local v123 = PlayerStateClient:GetLocalReplica();

                                if v123 and v123.Data then
                                    local Inventory = v123.Data.Inventory;

                                    if type(Inventory) == "table" then
                                        local v124 = Inventory[v121];
                                        v122 = type(v124) == "table" and (tonumber(v124[v120]) or 0) or 0;
                                    else
                                        v122 = 0;
                                    end;
                                else
                                    v122 = 0;
                                end;
                            else
                                v122 = 0;
                            end;

                            u8.Visible = v122 > 0;
                        else
                            u8.Visible = false;
                        end;
                    end;

                    if not u9 then
                        return;
                    end;

                    if not u11 then
                        u9.Visible = false;

                        return;
                    end;

                    local v125 = u11;
                    local v126 = PlayerStateClient:GetLocalReplica();
                    local v127;

                    if v126 and v126.Data then
                        local Inventory = v126.Data.Inventory;

                        if type(Inventory) == "table" then
                            local Pets = Inventory.Pets;
                            v127 = type(Pets) == "table" and (tonumber(Pets[v125]) or 0) or 0;
                        else
                            v127 = 0;
                        end;
                    else
                        v127 = 0;
                    end;

                    local v128 = u12[u11] or 0;

                    if v127 > 0 then
                        v128 = v127;
                    end;

                    u9.Visible = v128 > 0;
                end);
            end;

            if u8 then
                if u11 then
                    local v129 = u11;
                    local v130 = u1[v129];
                    local v131;

                    if v130 then
                        local v132 = PlayerStateClient:GetLocalReplica();

                        if v132 and v132.Data then
                            local Inventory = v132.Data.Inventory;

                            if type(Inventory) == "table" then
                                local v133 = Inventory[v130];
                                v131 = type(v133) == "table" and (tonumber(v133[v129]) or 0) or 0;
                            else
                                v131 = 0;
                            end;
                        else
                            v131 = 0;
                        end;
                    else
                        v131 = 0;
                    end;

                    u8.Visible = v131 > 0;
                else
                    u8.Visible = false;
                end;
            end;

            if not u9 then
                return;
            end;

            if not u11 then
                u9.Visible = false;

                return;
            end;

            local v134 = u11;
            local v135 = PlayerStateClient:GetLocalReplica();
            local v136;

            if v135 and v135.Data then
                local Inventory = v135.Data.Inventory;

                if type(Inventory) == "table" then
                    local Pets = Inventory.Pets;
                    v136 = type(Pets) == "table" and (tonumber(Pets[v134]) or 0) or 0;
                else
                    v136 = 0;
                end;
            else
                v136 = 0;
            end;

            local v137 = u12[u11] or 0;

            if v136 > 0 then
                v137 = v136;
            end;

            u9.Visible = v137 > 0;
        end);
    end;

    local function watchCharacter(p138) -- Line: 307
        -- upvalues: u10 (ref), u11 (ref), u6 (ref), u8 (ref), u1 (ref), PlayerStateClient (ref), u9 (ref), u12 (ref), getPetNameFromTool (ref)
        u10 = nil;
        u11 = nil;

        if u11 then
            if u6 then
                u6.Enabled = true;
            end;

            if u8 then
                if u11 then
                    local v139 = u11;
                    local v140 = u1[v139];
                    local v141;

                    if v140 then
                        local v142 = PlayerStateClient:GetLocalReplica();

                        if v142 and v142.Data then
                            local Inventory = v142.Data.Inventory;

                            if type(Inventory) == "table" then
                                local v143 = Inventory[v140];
                                v141 = type(v143) == "table" and (tonumber(v143[v139]) or 0) or 0;
                            else
                                v141 = 0;
                            end;
                        else
                            v141 = 0;
                        end;
                    else
                        v141 = 0;
                    end;

                    u8.Visible = v141 > 0;
                else
                    u8.Visible = false;
                end;
            end;

            if u9 then
                if u11 then
                    local v144 = u11;
                    local v145 = PlayerStateClient:GetLocalReplica();
                    local v146;

                    if v145 and v145.Data then
                        local Inventory = v145.Data.Inventory;

                        if type(Inventory) == "table" then
                            local Pets = Inventory.Pets;
                            v146 = type(Pets) == "table" and (tonumber(Pets[v144]) or 0) or 0;
                        else
                            v146 = 0;
                        end;
                    else
                        v146 = 0;
                    end;

                    local v147 = u12[u11] or 0;

                    if v146 > 0 then
                        v147 = v146;
                    end;

                    u9.Visible = v147 > 0;
                else
                    u9.Visible = false;
                end;
            end;
        elseif u6 then
            u6.Enabled = false;
        end;

        for _, child in p138:GetChildren() do
            local v148;

            if child:IsA("Tool") then
                v148 = getPetNameFromTool(child) ~= nil;
            else
                v148 = false;
            end;

            if v148 then
                u10 = child;
                local v149;

                if child then
                    v149 = getPetNameFromTool(child);
                else
                    v149 = nil;
                end;

                u11 = v149;

                if u11 then
                    if u6 then
                        u6.Enabled = true;
                    end;

                    if u8 then
                        if u11 then
                            local v150 = u11;
                            local v151 = u1[v150];
                            local v152;

                            if v151 then
                                local v153 = PlayerStateClient:GetLocalReplica();

                                if v153 and v153.Data then
                                    local Inventory = v153.Data.Inventory;

                                    if type(Inventory) == "table" then
                                        local v154 = Inventory[v151];
                                        v152 = type(v154) == "table" and (tonumber(v154[v150]) or 0) or 0;
                                    else
                                        v152 = 0;
                                    end;
                                else
                                    v152 = 0;
                                end;
                            else
                                v152 = 0;
                            end;

                            u8.Visible = v152 > 0;
                        else
                            u8.Visible = false;
                        end;
                    end;

                    if u9 then
                        if u11 then
                            local v155 = u11;
                            local v156 = PlayerStateClient:GetLocalReplica();
                            local v157;

                            if v156 and v156.Data then
                                local Inventory = v156.Data.Inventory;

                                if type(Inventory) == "table" then
                                    local Pets = Inventory.Pets;
                                    v157 = type(Pets) == "table" and (tonumber(Pets[v155]) or 0) or 0;
                                else
                                    v157 = 0;
                                end;
                            else
                                v157 = 0;
                            end;

                            local v158 = u12[u11] or 0;

                            if v157 > 0 then
                                v158 = v157;
                            end;

                            u9.Visible = v158 > 0;
                        else
                            u9.Visible = false;
                        end;
                    end;
                elseif u6 then
                    u6.Enabled = false;
                end;

                break;
            end;
        end;

        p138.ChildAdded:Connect(function(p159) -- Line: 317
            -- upvalues: getPetNameFromTool (ref), u10 (ref), u11 (ref), u6 (ref), u8 (ref), u1 (ref), PlayerStateClient (ref), u9 (ref), u12 (ref)
            local v160;

            if p159:IsA("Tool") then
                v160 = getPetNameFromTool(p159) ~= nil;
            else
                v160 = false;
            end;

            if v160 then
                u10 = p159;
                local v161;

                if p159 then
                    v161 = getPetNameFromTool(p159);
                else
                    v161 = nil;
                end;

                u11 = v161;

                if u11 then
                    if u6 then
                        u6.Enabled = true;
                    end;

                    if u8 then
                        if u11 then
                            local v162 = u11;
                            local v163 = u1[v162];
                            local v164;

                            if v163 then
                                local v165 = PlayerStateClient:GetLocalReplica();

                                if v165 and v165.Data then
                                    local Inventory = v165.Data.Inventory;

                                    if type(Inventory) == "table" then
                                        local v166 = Inventory[v163];
                                        v164 = type(v166) == "table" and (tonumber(v166[v162]) or 0) or 0;
                                    else
                                        v164 = 0;
                                    end;
                                else
                                    v164 = 0;
                                end;
                            else
                                v164 = 0;
                            end;

                            u8.Visible = v164 > 0;
                        else
                            u8.Visible = false;
                        end;
                    end;

                    if not u9 then
                        return;
                    end;

                    if not u11 then
                        u9.Visible = false;

                        return;
                    end;

                    local v167 = u11;
                    local v168 = PlayerStateClient:GetLocalReplica();
                    local v169;

                    if v168 and v168.Data then
                        local Inventory = v168.Data.Inventory;

                        if type(Inventory) == "table" then
                            local Pets = Inventory.Pets;
                            v169 = type(Pets) == "table" and (tonumber(Pets[v167]) or 0) or 0;
                        else
                            v169 = 0;
                        end;
                    else
                        v169 = 0;
                    end;

                    local v170 = u12[u11] or 0;

                    if v169 > 0 then
                        v170 = v169;
                    end;

                    u9.Visible = v170 > 0;

                    return;
                end;

                if u6 then
                    u6.Enabled = false;
                end;
            end;
        end);
        p138.ChildRemoved:Connect(function(p171) -- Line: 322
            -- upvalues: u10 (ref), u11 (ref), u6 (ref), u8 (ref), u1 (ref), PlayerStateClient (ref), u9 (ref), u12 (ref)
            if u10 and p171 == u10 then
                u10 = nil;
                u11 = nil;

                if u11 then
                    if u6 then
                        u6.Enabled = true;
                    end;

                    if u8 then
                        if u11 then
                            local v172 = u11;
                            local v173 = u1[v172];
                            local v174;

                            if v173 then
                                local v175 = PlayerStateClient:GetLocalReplica();

                                if v175 and v175.Data then
                                    local Inventory = v175.Data.Inventory;

                                    if type(Inventory) == "table" then
                                        local v176 = Inventory[v173];
                                        v174 = type(v176) == "table" and (tonumber(v176[v172]) or 0) or 0;
                                    else
                                        v174 = 0;
                                    end;
                                else
                                    v174 = 0;
                                end;
                            else
                                v174 = 0;
                            end;

                            u8.Visible = v174 > 0;
                        else
                            u8.Visible = false;
                        end;
                    end;

                    if not u9 then
                        return;
                    end;

                    if not u11 then
                        u9.Visible = false;

                        return;
                    end;

                    local v177 = u11;
                    local v178 = PlayerStateClient:GetLocalReplica();
                    local v179;

                    if v178 and v178.Data then
                        local Inventory = v178.Data.Inventory;

                        if type(Inventory) == "table" then
                            local Pets = Inventory.Pets;
                            v179 = type(Pets) == "table" and (tonumber(Pets[v177]) or 0) or 0;
                        else
                            v179 = 0;
                        end;
                    else
                        v179 = 0;
                    end;

                    local v180 = u12[u11] or 0;

                    if v179 > 0 then
                        v180 = v179;
                    end;

                    u9.Visible = v180 > 0;

                    return;
                end;

                if u6 then
                    u6.Enabled = false;
                end;
            end;
        end);
    end;

    if LocalPlayer.Character then
        watchCharacter(LocalPlayer.Character);
    end;

    LocalPlayer.CharacterAdded:Connect(watchCharacter);
end;

return v5;