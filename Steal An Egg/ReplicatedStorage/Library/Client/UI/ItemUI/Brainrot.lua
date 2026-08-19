-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Audio = require(ReplicatedStorage.Library.Audio);
local Variables = require(ReplicatedStorage.Library.Variables);
local InfoOverlay = require(ReplicatedStorage.Library.Client.InfoOverlay);
local Mutations = require(ReplicatedStorage.Library.Modules.Mutations);
require(ReplicatedStorage.Library.Items.BrainrotItem);
local v1 = {};

local function getDisplayMutations(p2) -- Line: 19
    local v3 = {};
    local BaseMutation = p2:GetData().BaseMutation;

    if typeof(BaseMutation) == "string" and (BaseMutation ~= "" and BaseMutation ~= "None") then
        table.insert(v3, BaseMutation);
    end;

    for _, v in ipairs(p2:GetMutations()) do
        if v ~= "" and (v ~= "None" and table.find(v3, v) == nil) then
            table.insert(v3, v);
        end;
    end;

    return v3;
end;

local function formatMutationRichText(p4) -- Line: 35
    -- upvalues: Mutations (copy)
    local v5 = Mutations.GetMutation(p4);

    if v5 then
        return string.format("<font color=\"#%s\">%s</font>", v5.Color:ToHex(), v5.Name);
    end;

    return p4;
end;

local function getMutationLine(p6) -- Line: 44
    -- upvalues: getDisplayMutations (copy), Mutations (copy)
    local v7 = getDisplayMutations(p6);

    if #v7 == 0 then
        return "No Mutations";
    end;

    local v8 = table.create(#v7);

    for i, v in ipairs(v7) do
        local v9 = Mutations.GetMutation(v);

        if v9 then
            local v = string.format("<font color=\"#%s\">%s</font>", v9.Color:ToHex(), v9.Name);
        end;

        v8[i] = v;
    end;

    return table.concat(v8, ", ");
end;

local function showOverlay(p10, p11) -- Line: 58
    -- upvalues: Variables (copy), InfoOverlay (copy), getMutationLine (copy)
    if Variables.DisableInfoOverlay then
        return;
    end;

    InfoOverlay.Add(p10, { "Title", (" %s "):format(p11:GetName()) }, { "Rarity", p11:GetRarity()._id }, { "Div" }, { "Desc", getMutationLine(p11) });
end;

function v1.AddOverlay(u12, u13) -- Line: 73
    -- upvalues: Audio (copy), showOverlay (copy)
    local function handleOverlay() -- Line: 74
        -- upvalues: Audio (ref), showOverlay (ref), u12 (copy), u13 (copy)
        Audio.Play("rbxassetid://89944486811970", script, 1, 0.2);
        showOverlay(u12, u13);
    end;

    u12.MouseEnter:Connect(handleOverlay);
    u12.SelectionGained:Connect(handleOverlay);
    u12.Activated:Connect(handleOverlay);
end;

return v1;