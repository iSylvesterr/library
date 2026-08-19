-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local LocalPlayer = Players.LocalPlayer;
local UNPLACE_PROMPT = Constants.TAGS_MAP.Traps.UNPLACE_PROMPT;
local u1 = {};

local function cleanupPromptConnections(p2) -- Line: 27
    -- upvalues: u1 (copy)
    local v3 = u1[p2];

    if not v3 then
        return;
    end;

    local Owner = v3.Owner;

    if Owner then
        Owner:Disconnect();
    end;

    local Active = v3.Active;

    if Active then
        Active:Disconnect();
    end;

    u1[p2] = nil;
end;

local function updatePromptEnabled(p4) -- Line: 46
    -- upvalues: LocalPlayer (copy)
    local Parent = p4.Parent;

    if not (Parent and Parent:IsA("BasePart")) then
        p4.Enabled = false;

        return;
    end;

    local v5 = Parent:GetAttribute("Owner");
    local v6 = Parent:GetAttribute("TrapActive");
    local v7;

    if v5 == LocalPlayer.Name then
        v7 = v6 ~= true;
    else
        v7 = false;
    end;

    p4.Enabled = v7;
end;

local function bindPromptConnections(u8) -- Line: 58
    -- upvalues: u1 (copy), LocalPlayer (copy)
    local v9 = u1[u8];

    if v9 then
        local Owner = v9.Owner;

        if Owner then
            Owner:Disconnect();
        end;

        local Active = v9.Active;

        if Active then
            Active:Disconnect();
        end;

        u1[u8] = nil;
    end;

    local Parent = u8.Parent;

    if not (Parent and Parent:IsA("BasePart")) then
        return;
    end;

    u1[u8] = {
        Owner = Parent:GetAttributeChangedSignal("Owner"):Connect(function() -- Line: 67
            -- upvalues: u8 (copy), LocalPlayer (ref)
            local v10 = u8;
            local Parent2 = v10.Parent;

            if not (Parent2 and Parent2:IsA("BasePart")) then
                v10.Enabled = false;

                return;
            end;

            local v11 = Parent2:GetAttribute("Owner");
            local v12 = Parent2:GetAttribute("TrapActive");
            local v13;

            if v11 == LocalPlayer.Name then
                v13 = v12 ~= true;
            else
                v13 = false;
            end;

            v10.Enabled = v13;
        end),
        Active = Parent:GetAttributeChangedSignal("TrapActive"):Connect(function() -- Line: 70
            -- upvalues: u8 (copy), LocalPlayer (ref)
            local v14 = u8;
            local Parent2 = v14.Parent;

            if not (Parent2 and Parent2:IsA("BasePart")) then
                v14.Enabled = false;

                return;
            end;

            local v15 = Parent2:GetAttribute("Owner");
            local v16 = Parent2:GetAttribute("TrapActive");
            local v17;

            if v15 == LocalPlayer.Name then
                v17 = v16 ~= true;
            else
                v17 = false;
            end;

            v14.Enabled = v17;
        end)
    };
end;

local function refreshPrompt(p18) -- Line: 76
    -- upvalues: bindPromptConnections (copy), LocalPlayer (copy)
    bindPromptConnections(p18);
    local Parent = p18.Parent;

    if not (Parent and Parent:IsA("BasePart")) then
        p18.Enabled = false;

        return;
    end;

    local v19 = Parent:GetAttribute("Owner");
    local v20 = Parent:GetAttribute("TrapActive");
    local v21;

    if v19 == LocalPlayer.Name then
        v21 = v20 ~= true;
    else
        v21 = false;
    end;

    p18.Enabled = v21;
end;

local function trackPrompt(u22) -- Line: 81
    -- upvalues: bindPromptConnections (copy), LocalPlayer (copy), u1 (copy)
    bindPromptConnections(u22);
    local Parent = u22.Parent;

    if Parent and Parent:IsA("BasePart") then
        local v23 = Parent:GetAttribute("Owner");
        local v24 = Parent:GetAttribute("TrapActive");
        local v25;

        if v23 == LocalPlayer.Name then
            v25 = v24 ~= true;
        else
            v25 = false;
        end;

        u22.Enabled = v25;
    else
        u22.Enabled = false;
    end;

    u22.AncestryChanged:Connect(function(p26, p27) -- Line: 84
        -- upvalues: u22 (copy), u1 (ref), bindPromptConnections (ref), LocalPlayer (ref)
        if p27 then
            local v28 = u22;
            bindPromptConnections(v28);
            local Parent2 = v28.Parent;

            if not (Parent2 and Parent2:IsA("BasePart")) then
                v28.Enabled = false;

                return;
            end;

            local v29 = Parent2:GetAttribute("Owner");
            local v30 = Parent2:GetAttribute("TrapActive");
            local v31;

            if v29 == LocalPlayer.Name then
                v31 = v30 ~= true;
            else
                v31 = false;
            end;

            v28.Enabled = v31;

            return;
        end;

        local v32 = u22;
        local v33 = u1[v32];

        if not v33 then
            return;
        end;

        local Owner = v33.Owner;

        if Owner then
            Owner:Disconnect();
        end;

        local Active = v33.Active;

        if Active then
            Active:Disconnect();
        end;

        u1[v32] = nil;
    end);
    u22.Destroying:Connect(function() -- Line: 93
        -- upvalues: u22 (copy), u1 (ref)
        local v34 = u22;
        local v35 = u1[v34];

        if not v35 then
            return;
        end;

        local Owner = v35.Owner;

        if Owner then
            Owner:Disconnect();
        end;

        local Active = v35.Active;

        if Active then
            Active:Disconnect();
        end;

        u1[v34] = nil;
    end);
end;

local function onPromptAdded(p36) -- Line: 98
    -- upvalues: trackPrompt (copy)
    if not p36:IsA("ProximityPrompt") then
        return;
    end;

    trackPrompt(p36);
end;

local function onPromptRemoved(p37) -- Line: 106
    -- upvalues: u1 (copy)
    if not p37:IsA("ProximityPrompt") then
        return;
    end;

    local v38 = u1[p37];

    if not v38 then
        return;
    end;

    local Owner = v38.Owner;

    if Owner then
        Owner:Disconnect();
    end;

    local Active = v38.Active;

    if Active then
        Active:Disconnect();
    end;

    u1[p37] = nil;
end;

for _, v in ipairs(CollectionService:GetTagged(UNPLACE_PROMPT)) do
    if v:IsA("ProximityPrompt") then
        trackPrompt(v);
    end;
end;

CollectionService:GetInstanceAddedSignal(UNPLACE_PROMPT):Connect(onPromptAdded);
CollectionService:GetInstanceRemovedSignal(UNPLACE_PROMPT):Connect(onPromptRemoved);