-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};

local function GetFinisherData(p6) -- Line: 40
    -- upvalues: u4 (copy)
    local v7 = u4[p6.Finisher];
    local v8 = `"{p6.Finisher}" is not a valid member of database.custom.finishers`;
    assert(v7, v8);

    return v7;
end;

local function IsDeadCharacterModel(p9) -- Line: 48
    if typeof(p9) ~= "Instance" or not p9:IsA("Model") then
        return false;
    end;

    if p9:HasTag("Ragdoll") then
        return false;
    end;

    if p9:GetAttribute("Dead") == true then
        return true;
    end;

    local v10 = p9:FindFirstChildOfClass("Humanoid");
    local v11;

    if v10 == nil then
        v11 = false;
    else
        v11 = v10.Health <= 0;
    end;

    return v11;
end;

local function ResolveEnemyCharacter(p12) -- Line: 66
    -- upvalues: Players (copy), u5 (copy), IsDeadCharacterModel (copy)
    local Victim = p12.Victim;

    if not Victim then
        return nil;
    end;

    local v13 = Players:GetPlayerByUserId(Victim);
    local v14 = v13 and v13.Name or u5[Victim];

    if not v14 then
        return nil;
    end;

    local v15 = workspace:WaitForChild("Debris"):QueryDescendants((`#{v14}`))[1];

    if IsDeadCharacterModel(v15) then
        return v15;
    end;

    if v13 then
        v13 = v13.Character;
    end;

    if IsDeadCharacterModel(v13) then
        return v13;
    end;

    if v13 and (v13:IsA("Model") and not v13:HasTag("Ragdoll")) then
        return v13;
    end;

    return nil;
end;

function u1.IsFinisherValidForReplication(p16) -- Line: 102
    -- upvalues: u4 (copy), LocalPlayer (copy)
    local v17 = u4[p16.Finisher];
    local v18 = `"{p16.Finisher}" is not a valid member of database.custom.finishers`;
    assert(v17, v18);
    local UserId = LocalPlayer.UserId;

    return v17.Replication == "Killer" and p16.Killer == UserId and true or (v17.Replication == "Victim" and p16.Victim == UserId and true or (v17.Replication == "Both" and (p16.Killer == UserId or p16.Victim == UserId) and true or v17.Replication == "All"));
end;

function u1.ExecuteFinisher(u19) -- Line: 116
    -- upvalues: u1 (copy), u4 (copy), ResolveEnemyCharacter (copy), u3 (copy), u2 (copy)
    if u1.IsFinisherValidForReplication(u19) then
        local u20 = u4[u19.Finisher];
        local v21 = `"{u19.Finisher}" is not a valid member of database.custom.finishers`;
        assert(u20, v21);
        local success, result = pcall(function() -- Line: 122
            -- upvalues: ResolveEnemyCharacter (ref), u19 (copy), u3 (ref), u2 (ref), u20 (copy)
            local v22 = ResolveEnemyCharacter(u19);

            if not v22 then
                local v23 = os.clock() + 0.35;

                repeat
                    task.wait(0.05);
                    v22 = ResolveEnemyCharacter(u19);
                until v22 or v23 <= os.clock();
            end;

            if not v22 then
                warn((`Failed to execute finisher "{u19.Finisher}": missing victim character "{u19.Victim}"`));

                return nil;
            end;

            v22.Archivable = true;
            local u24 = tostring(u19.Victim);
            local v25 = u3[u24];

            if v25 then
                v25.Destroy();
            end;

            while #u2 >= 8 do
                local v26 = table.remove(u2, 1);

                if v26 then
                    v26.Destroy();
                end;
            end;

            local u27 = u20.Finisher(v22, u19);
            local u28 = {
                Name = u24,

                Destroy = function() -- Line: 162, Name: Destroy
                    -- upvalues: u3 (ref), u24 (copy), u27 (copy)
                    u3[u24] = nil;
                    u27.Destroy();
                end
            };
            u3[u24] = u27;
            table.insert(u2, u28);
            u27.OnDestroy:Once(function() -- Line: 173
                -- upvalues: u2 (ref), u28 (copy)
                local v29 = table.find(u2, u28);

                if not v29 then
                    return;
                end;

                table.remove(u2, v29);
            end);
        end);

        if not success then
            warn((`Failed to execute finisher "{u19.Finisher}": {result}`));
        end;
    end;
end;

for _, v in Players:GetPlayers() do
    u5[v.UserId] = v.Name;
end;

Players.PlayerAdded:Connect(function(p30) -- Line: 200
    -- upvalues: u5 (copy)
    u5[p30.UserId] = p30.Name;
end);

for _, child in ipairs(ReplicatedStorage.Database.Custom.Finishers:GetChildren()) do
    if child:IsA("ModuleScript") then
        u4[child.Name] = require(child);
    end;
end;

return u1;