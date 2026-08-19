-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local u1 = {
    StepIds = {
        StealEgg = "StealEgg",
        HeadToPen = "HeadToPen",
        EquipEgg = "EquipEgg",
        PlaceEgg = "PlaceEgg",
        HatchEgg = "HatchEgg",
        PlacePet = "PlacePet",
        ExpandPen = "ExpandPen",
        TreadmillIntro = "TreadmillIntro"
    },
    RunGuidanceStates = {
        Inactive = "Inactive",
        ForwardRun = "ForwardRun"
    },
    DEFAULT_PROGRESS = {
        Completed = false,
        CurrentStepId = nil
    }
};
local v2 = t.union(t.literal(u1.StepIds.StealEgg), t.literal(u1.StepIds.HeadToPen), t.literal(u1.StepIds.EquipEgg), t.literal(u1.StepIds.PlaceEgg), t.literal(u1.StepIds.HatchEgg), t.literal(u1.StepIds.PlacePet), t.literal(u1.StepIds.ExpandPen), t.literal(u1.StepIds.TreadmillIntro));
u1.SchemaValidation = {
    RunGuidanceState = t.union(t.literal(u1.RunGuidanceStates.Inactive), t.literal(u1.RunGuidanceStates.ForwardRun)),
    StepId = v2,
    Progress = t.interface({
        Completed = t.boolean,
        CurrentStepId = t.optional(v2)
    })
};
u1.SchemaValidation.ProgressUpdatePayload = u1.SchemaValidation.Progress;

function u1.IsStepId(p3) -- Line: 90
    -- upvalues: u1 (copy)
    return u1.SchemaValidation.StepId(p3);
end;

function u1.IsRunGuidanceState(p4) -- Line: 94
    -- upvalues: u1 (copy)
    return u1.SchemaValidation.RunGuidanceState(p4);
end;

function u1.CloneProgress(p5) -- Line: 98
    return {
        Completed = p5.Completed == true,
        CurrentStepId = p5.CurrentStepId
    };
end;

function u1.NormalizeProgress(p6) -- Line: 105
    -- upvalues: u1 (copy)
    if p6 == nil then
        return u1.CloneProgress(u1.DEFAULT_PROGRESS);
    end;

    if not u1.SchemaValidation.Progress(p6) then
        return u1.CloneProgress(u1.DEFAULT_PROGRESS);
    end;

    local v7 = {
        Completed = p6.Completed == true,
        CurrentStepId = p6.CurrentStepId
    };

    if v7.Completed then
        v7.CurrentStepId = nil;
    end;

    return v7;
end;

return u1;