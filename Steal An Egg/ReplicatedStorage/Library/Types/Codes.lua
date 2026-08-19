-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Milestones = require(script.Milestones);
local u1 = {
    CODE_PREFIX = Milestones.CODE_PREFIX,
    REWARD_LUCKY_BLOCK_ID = Milestones.REWARD_LUCKY_BLOCK_ID,
    SchemaValidation = {
        LikeCodeMilestone = t.interface({
            Id = t.string,
            Code = t.string,
            CodeNumber = t.number,
            LikesRequired = t.number,
            RewardLuckyBlockId = t.string
        }),
        LikeCodeState = t.interface({
            CurrentLikes = t.number,
            CurrentMilestoneId = t.optional(t.string),
            CurrentCodeNumber = t.number,
            CurrentCode = t.optional(t.string),
            ProgressLikes = t.number,
            ProgressTargetLikes = t.number,
            ProgressRatio = t.number,
            NextMilestoneId = t.optional(t.string),
            NextCodeNumber = t.number,
            NextCode = t.optional(t.string),
            NextCodeLikesRequired = t.optional(t.number)
        })
    }
};

function u1.GetCodeFromNumber(p2) -- Line: 63
    -- upvalues: u1 (copy)
    local v3 = math.floor(p2);

    if v3 <= 0 then
        return nil;
    end;

    return `{u1.CODE_PREFIX}{v3}`;
end;

function u1.GetMilestones() -- Line: 72
    -- upvalues: Milestones (copy)
    return Milestones.GetAllGeneratedMilestones();
end;

function u1.GetMilestoneById(p4) -- Line: 76
    -- upvalues: Milestones (copy)
    return Milestones.GetMilestoneById(p4);
end;

function u1.GetMilestoneByCode(p5) -- Line: 80
    -- upvalues: Milestones (copy)
    return Milestones.GetMilestoneByCode(p5);
end;

function u1.GetCurrentMilestoneFromLikes(p6) -- Line: 84
    -- upvalues: Milestones (copy)
    return Milestones.GetCurrentMilestoneFromLikes(p6);
end;

function u1.GetNextMilestoneFromLikes(p7) -- Line: 88
    -- upvalues: Milestones (copy)
    return Milestones.GetNextMilestoneFromLikes(p7);
end;

function u1.HasClaimedMilestone(p8, p9) -- Line: 92
    local v10;

    if p8 == nil then
        v10 = false;
    else
        v10 = p8[p9.Id] == true;
    end;

    return v10;
end;

function u1.GetStateFromLikes(p11) -- Line: 99
    -- upvalues: u1 (copy)
    local v12 = math.floor(p11);
    local v13 = math.max(0, v12);
    local v14 = u1.GetCurrentMilestoneFromLikes(v13);
    local v15 = u1.GetNextMilestoneFromLikes(v13);
    local v16 = not v14 and 0 or v14.LikesRequired;
    local v17;

    if v15 then
        v17 = v15.LikesRequired;
    else
        v17 = v16;
    end;

    local v18 = math.max(1, v17 - v16);
    local v19 = math.clamp(v13 - v16, 0, v18);
    local v20 = math.clamp(v19 / v18, 0, 1);
    local v21 = {
        CurrentLikes = v13
    };
    local v22;

    if v14 then
        v22 = v14.Id;
    else
        v22 = nil;
    end;

    v21.CurrentMilestoneId = v22;
    v21.CurrentCodeNumber = not v14 and 0 or v14.CodeNumber;
    local v23;

    if v14 then
        v23 = v14.Code;
    else
        v23 = nil;
    end;

    v21.CurrentCode = v23;
    v21.ProgressLikes = v19;
    v21.ProgressTargetLikes = v18;
    v21.ProgressRatio = v20;
    local v24;

    if v15 then
        v24 = v15.Id;
    else
        v24 = nil;
    end;

    v21.NextMilestoneId = v24;
    v21.NextCodeNumber = not v15 and 0 or v15.CodeNumber;
    local v25;

    if v15 then
        v25 = v15.Code;
    else
        v25 = nil;
    end;

    v21.NextCode = v25;
    local v26;

    if v15 then
        v26 = v15.LikesRequired;
    else
        v26 = nil;
    end;

    v21.NextCodeLikesRequired = v26;

    return v21;
end;

if Constants.IS_STUDIO then
    local v27 = u1.GetCodeFromNumber(1) == "free1";
    assert(v27, "Like code prefix generation is invalid");
    local v28 = Milestones.GetLikesSeparationForLikes(248) == 500;
    assert(v28, "Like code base separation is invalid");
    local v29 = Milestones.GetLikesSeparationForLikes(8968237) == 31763;
    assert(v29, "Like code curve separation is invalid");
    local v30 = u1.GetMilestones();
    local v31;

    if v30[1] == nil or v30[1].Id ~= "like_code_1" then
        v31 = false;
    else
        v31 = v30[1].LikesRequired == 0;
    end;

    assert(v31, "First like milestone is invalid");
    local v32 = u1.GetMilestoneByCode("FREE3") ~= nil;
    assert(v32, "Like milestone code lookup is invalid");
    local v33 = u1.GetStateFromLikes(0).CurrentCode == "free1";
    assert(v33, "Initial like code state is invalid");
    local v34, v35 = u1.SchemaValidation.LikeCodeMilestone(v30[1]);
    local v36 = `Like code milestone validation failed: {v35}`;
    assert(v34, v36);
    local v37, v38 = u1.SchemaValidation.LikeCodeState(u1.GetStateFromLikes(2345));
    local v39 = `Like code state validation failed: {v38}`;
    assert(v37, v39);
end;

return u1;