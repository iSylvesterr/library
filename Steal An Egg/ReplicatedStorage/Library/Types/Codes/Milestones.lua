-- Decompiled with Potassium's decompiler.

game:GetService("ReplicatedStorage");
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = 0;
local u5 = 0;
local u6 = {};

local function createMilestone(p7, p8) -- Line: 43
    local v9 = math.floor(p7);
    local v10 = math.max(1, v9);
    local v11 = math.floor(p8);
    local v12 = math.max(0, v11);
    local v13 = `free{v10}`;

    return {
        RewardLuckyBlockId = "",
        Id = `like_code_{v10}`,
        Code = v13,
        CodeNumber = v10,
        LikesRequired = v12
    };
end;

local function generateNextMilestone() -- Line: 57
    -- upvalues: u4 (ref), u5 (ref), u6 (copy), createMilestone (copy), u1 (copy), u2 (copy), u3 (copy)
    local v14 = u4 + 1;
    local v15 = createMilestone(v14, v14 == 1 and 0 or u5 + u6.GetLikesSeparationForLikes(u5));
    table.insert(u1, v15);
    u2[v15.Id] = v15;
    u3[v15.Code] = v15;
    u4 = v15.CodeNumber;
    u5 = v15.LikesRequired;

    return v15;
end;

local function ensureGeneratedForCodeNumber(p16) -- Line: 74
    -- upvalues: u4 (ref), u5 (ref), u6 (copy), createMilestone (copy), u1 (copy), u2 (copy), u3 (copy)
    local v17 = math.floor(p16);
    local v18 = math.max(0, v17);

    while u4 < v18 do
        local v19 = u4 + 1;
        local v20 = createMilestone(v19, v19 == 1 and 0 or u5 + u6.GetLikesSeparationForLikes(u5));
        table.insert(u1, v20);
        u2[v20.Id] = v20;
        u3[v20.Code] = v20;
        u4 = v20.CodeNumber;
        u5 = v20.LikesRequired;
    end;
end;

local function ensureGeneratedForLikes(p21) -- Line: 81
    -- upvalues: u5 (ref), u4 (ref), u6 (copy), createMilestone (copy), u1 (copy), u2 (copy), u3 (copy)
    local v22 = math.floor(p21);
    local v23 = math.max(0, v22);

    while u5 <= v23 do
        local v24 = u4 + 1;
        local v25 = createMilestone(v24, v24 == 1 and 0 or u5 + u6.GetLikesSeparationForLikes(u5));
        table.insert(u1, v25);
        u2[v25.Id] = v25;
        u3[v25.Code] = v25;
        u4 = v25.CodeNumber;
        u5 = v25.LikesRequired;
    end;
end;

u6.CODE_PREFIX = "free";
u6.REWARD_LUCKY_BLOCK_ID = "";

function u6.GetLikesSeparationForLikes(p26) -- Line: 92
    local v27 = math.floor(p26);
    local v28 = math.max(0, v27);
    local v29 = math.sqrt(v28) * 10.60639937944559 + 0.5;
    local v30 = math.floor(v29);

    return math.max(500, v30);
end;

function u6.GetAllGeneratedMilestones() -- Line: 99
    -- upvalues: u4 (ref), u5 (ref), u6 (copy), createMilestone (copy), u1 (copy), u2 (copy), u3 (copy)
    if u4 <= 0 then
        while u4 < 1 do
            local v31 = u4 + 1;
            local v32 = createMilestone(v31, v31 == 1 and 0 or u5 + u6.GetLikesSeparationForLikes(u5));
            table.insert(u1, v32);
            u2[v32.Id] = v32;
            u3[v32.Code] = v32;
            u4 = v32.CodeNumber;
            u5 = v32.LikesRequired;
        end;
    end;

    return u1;
end;

function u6.GetMilestoneById(p33) -- Line: 107
    -- upvalues: u2 (copy)
    return u2[p33];
end;

function u6.GetMilestoneByCode(p34) -- Line: 111
    -- upvalues: u3 (copy), u4 (ref), u5 (ref), u6 (copy), createMilestone (copy), u1 (copy), u2 (copy)
    local v35 = string.lower(p34);
    local v36 = u3[v35];

    if v36 ~= nil then
        return v36;
    end;

    local v37 = string.sub(v35, 5);
    local v38 = tonumber(v37);

    if v38 == nil then
        return nil;
    end;

    local v39 = math.floor(v38);

    if string.sub(v35, 1, 4) ~= "free" or v39 <= 0 then
        return nil;
    end;

    local v40 = math.floor(v39);
    local v41 = math.max(0, v40);

    while u4 < v41 do
        local v42 = u4 + 1;
        local v43 = createMilestone(v42, v42 == 1 and 0 or u5 + u6.GetLikesSeparationForLikes(u5));
        table.insert(u1, v43);
        u2[v43.Id] = v43;
        u3[v43.Code] = v43;
        u4 = v43.CodeNumber;
        u5 = v43.LikesRequired;
    end;

    return u3[v35];
end;

function u6.GetMilestoneByCodeNumber(p44) -- Line: 132
    -- upvalues: u4 (ref), u5 (ref), u6 (copy), createMilestone (copy), u1 (copy), u2 (copy), u3 (copy)
    local v45 = math.floor(p44);

    if v45 <= 0 then
        return nil;
    end;

    local v46 = math.floor(v45);
    local v47 = math.max(0, v46);

    while u4 < v47 do
        local v48 = u4 + 1;
        local v49 = createMilestone(v48, v48 == 1 and 0 or u5 + u6.GetLikesSeparationForLikes(u5));
        table.insert(u1, v49);
        u2[v49.Id] = v49;
        u3[v49.Code] = v49;
        u4 = v49.CodeNumber;
        u5 = v49.LikesRequired;
    end;

    return u1[v45];
end;

function u6.GetCurrentMilestoneFromLikes(p50) -- Line: 142
    -- upvalues: u5 (ref), u4 (ref), u6 (copy), createMilestone (copy), u1 (copy), u2 (copy), u3 (copy)
    local v51 = math.floor(p50);
    local v52 = math.max(0, v51);
    local v53 = math.floor(v52);
    local v54 = math.max(0, v53);

    while u5 <= v54 do
        local v55 = u4 + 1;
        local v56 = createMilestone(v55, v55 == 1 and 0 or u5 + u6.GetLikesSeparationForLikes(u5));
        table.insert(u1, v56);
        u2[v56.Id] = v56;
        u3[v56.Code] = v56;
        u4 = v56.CodeNumber;
        u5 = v56.LikesRequired;
    end;

    for i = #u1, 1, -1 do
        local v57 = u1[i];

        if v57.LikesRequired <= v52 then
            return v57;
        end;
    end;

    return nil;
end;

function u6.GetNextMilestoneFromLikes(p58) -- Line: 156
    -- upvalues: u5 (ref), u4 (ref), u6 (copy), createMilestone (copy), u1 (copy), u2 (copy), u3 (copy)
    local v59 = math.floor(p58);
    local v60 = math.max(0, v59);
    local v61 = math.floor(v60);
    local v62 = math.max(0, v61);

    while u5 <= v62 do
        local v63 = u4 + 1;
        local v64 = createMilestone(v63, v63 == 1 and 0 or u5 + u6.GetLikesSeparationForLikes(u5));
        table.insert(u1, v64);
        u2[v64.Id] = v64;
        u3[v64.Code] = v64;
        u4 = v64.CodeNumber;
        u5 = v64.LikesRequired;
    end;

    for _, v in ipairs(u1) do
        if v60 < v.LikesRequired then
            return v;
        end;
    end;

    local v65 = u4 + 1;
    local v66 = createMilestone(v65, v65 == 1 and 0 or u5 + u6.GetLikesSeparationForLikes(u5));
    table.insert(u1, v66);
    u2[v66.Id] = v66;
    u3[v66.Code] = v66;
    u4 = v66.CodeNumber;
    u5 = v66.LikesRequired;

    return v66;
end;

return u6;