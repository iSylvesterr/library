-- Decompiled with Potassium's decompiler.

if require(game.ReplicatedFirst.AllSideCode.UtilsSystem).SystemGameConfig.GetValue({ "FootStep", "启用" }) == false then
    return;
end;

local Players = game:GetService("Players");
local FootstepSoundModule = require(script.FootstepSoundModule);
local u1 = {};

local function _initFootstepSystem(u2, u3) -- Line: 70
    -- upvalues: u1 (copy), FootstepSoundModule (copy)
    local v4 = u1[u2];

    if v4 then
        if v4.stateConnection then
            v4.stateConnection:Disconnect();
        end;

        if v4.cleanupConnection then
            v4.cleanupConnection:Disconnect();
        end;

        if v4.footstepPlayer then
            v4.footstepPlayer:Destroy();
        end;
    end;

    local Humanoid = u3:WaitForChild("Humanoid", (1 / 0));
    local HumanoidRootPart = u3:WaitForChild("HumanoidRootPart", (1 / 0));
    local Running = HumanoidRootPart:WaitForChild("Running", (1 / 0));
    local Landing = HumanoidRootPart:WaitForChild("Landing", (1 / 0));

    if Running then
        Running.SoundId = "";
        Running.Volume = 0;
    end;

    if Landing then
        Landing.SoundId = "";
        Landing.Volume = 0;
    end;

    local u5 = FootstepSoundModule.new(Humanoid, HumanoidRootPart);
    local v8 = Humanoid.StateChanged:Connect(function(p6, p7) -- Line: 101
        -- upvalues: u5 (copy)
        if p7 == Enum.HumanoidStateType.Freefall then
            u5:RecordFreefallStart();
        end;

        if p6 == Enum.HumanoidStateType.Freefall and p7 == Enum.HumanoidStateType.Landed then
            u5:UpdateLandedSoundByMaterial();
        end;
    end);
    local v10 = u3.AncestryChanged:Connect(function() -- Line: 112
        -- upvalues: u3 (copy), u1 (ref), u2 (copy)
        local v9 = not u3.Parent and u1[u2];

        if v9 then
            if v9.stateConnection then
                v9.stateConnection:Disconnect();
            end;

            if v9.cleanupConnection then
                v9.cleanupConnection:Disconnect();
            end;

            if v9.footstepPlayer then
                v9.footstepPlayer:Destroy();
            end;

            v9.footstepPlayer = nil;
            v9.stateConnection = nil;
            v9.cleanupConnection = nil;
        end;
    end);

    if not v4 then
        u1[u2] = {
            characterAddedConnection = nil,
            footstepPlayer = u5,
            stateConnection = v8,
            cleanupConnection = v10
        };

        return;
    end;

    v4.footstepPlayer = u5;
    v4.stateConnection = v8;
    v4.cleanupConnection = v10;
end;

local function _bindPlayerCharacter(u11) -- Line: 151
    -- upvalues: u1 (copy), _initFootstepSystem (copy)
    local v12 = u1[u11];

    if v12 and v12.characterAddedConnection then
        v12.characterAddedConnection:Disconnect();
    end;

    if not v12 then
        u1[u11] = {
            footstepPlayer = nil,
            stateConnection = nil,
            cleanupConnection = nil,
            characterAddedConnection = nil
        };
        v12 = u1[u11];
    end;

    v12.characterAddedConnection = u11.CharacterAdded:Connect(function(p13) -- Line: 167
        -- upvalues: _initFootstepSystem (ref), u11 (copy)
        _initFootstepSystem(u11, p13);
    end);

    if u11.Character then
        _initFootstepSystem(u11, u11.Character);
    end;
end;

local function _cleanupPlayerFootstep(p14) -- Line: 41
    -- upvalues: u1 (copy)
    local v15 = u1[p14];

    if not v15 then
        return;
    end;

    if v15.stateConnection then
        v15.stateConnection:Disconnect();
    end;

    if v15.cleanupConnection then
        v15.cleanupConnection:Disconnect();
    end;

    if v15.characterAddedConnection then
        v15.characterAddedConnection:Disconnect();
    end;

    if v15.footstepPlayer then
        v15.footstepPlayer:Destroy();
    end;

    u1[p14] = nil;
end;

for _, v in ipairs(Players:GetPlayers()) do
    _bindPlayerCharacter(v);
end;

Players.PlayerAdded:Connect(function(p16) -- Line: 180
    -- upvalues: _bindPlayerCharacter (copy)
    _bindPlayerCharacter(p16);
end);
Players.PlayerRemoving:Connect(function(p17) -- Line: 184
    -- upvalues: _cleanupPlayerFootstep (copy)
    _cleanupPlayerFootstep(p17);
end);