-- Decompiled with Potassium's decompiler.

local SoundService = game:GetService("SoundService");
local IDSReupload = require(script.Parent.IDSReupload);
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
local AnimationController = Instance.new("AnimationController");
AnimationController.Name = "__ProbeController";
AnimationController.Parent = workspace;
local Animator = Instance.new("Animator");
Animator.Parent = AnimationController;

local function assetIdFromUrl(p5) -- Line: 16
    if not p5 or p5 == "" then
        return nil;
    end;

    local v6 = string.match(p5, "(%d+)%s*$") or string.match(p5, "(%d+)");

    if v6 then
        return tonumber(v6);
    end;

    return nil;
end;

local function tryPlaySoundById(p7) -- Line: 31
    -- upvalues: SoundService (copy), u1 (copy), u2 (copy)
    local Sound = Instance.new("Sound");
    Sound.Name = "__ProbeSound_" .. tostring(p7);
    Sound.SoundId = "rbxassetid://" .. p7;
    Sound.Volume = 0;
    Sound.Parent = SoundService;

    if pcall(function() -- Line: 38
        -- upvalues: Sound (copy)
        Sound:Play();
    end) then
        table.insert(u1, p7);
    else
        table.insert(u2, p7);
    end;

    pcall(function() -- Line: 47
        -- upvalues: Sound (copy)
        Sound:Stop();
    end);
    Sound:Destroy();
end;

local function tryPlayAnimationById(p8) -- Line: 53
    -- upvalues: Animator (copy), u3 (copy), u4 (copy)
    local Animation = Instance.new("Animation");
    Animation.Name = "__ProbeAnim_" .. tostring(p8);
    Animation.AnimationId = "rbxassetid://" .. p8;
    local success, result = pcall(function() -- Line: 58
        -- upvalues: Animator (ref), Animation (copy)
        return Animator:LoadAnimation(Animation);
    end);

    if success and result then
        pcall(function() -- Line: 64
            -- upvalues: result (copy)
            result:Play(0, 1, 1);
        end);
        table.insert(u3, p8);
        pcall(function() -- Line: 68
            -- upvalues: result (copy)
            result:Stop(0);
        end);
        result:Destroy();
    else
        table.insert(u4, p8);
    end;

    Animation:Destroy();
end;

for _, v in ipairs(IDSReupload) do
    if typeof(v) == "number" then
        tryPlaySoundById(v);
        tryPlayAnimationById(v);
    end;
end;

for _, descendant in ipairs(game:GetDescendants()) do
    if descendant and (descendant.Parent and descendant:IsA("Sound")) then
        local SoundId = descendant.SoundId;
        local v9;

        if SoundId and SoundId ~= "" then
            local v10 = string.match(SoundId, "(%d+)%s*$") or string.match(SoundId, "(%d+)");

            if v10 then
                v9 = tonumber(v10);
            else
                v9 = nil;
            end;
        else
            v9 = nil;
        end;

        local u11 = descendant:Clone();
        u11.Name = "__ProbeClone:" .. descendant.Name;
        u11.Volume = 0;
        u11.Parent = SoundService;

        if pcall(function() -- Line: 97
            -- upvalues: u11 (copy)
            u11:Play();
        end) and v9 then
            table.insert(u1, v9);
        elseif v9 then
            table.insert(u2, v9);
        end;

        pcall(function() -- Line: 105
            -- upvalues: u11 (copy)
            u11:Stop();
        end);
        u11:Destroy();
    elseif descendant:IsA("Animation") then
        local AnimationId = descendant.AnimationId;
        local v12;

        if AnimationId and AnimationId ~= "" then
            local v13 = string.match(AnimationId, "(%d+)%s*$") or string.match(AnimationId, "(%d+)");

            if v13 then
                v12 = tonumber(v13);
            else
                v12 = nil;
            end;
        else
            v12 = nil;
        end;

        if v12 then
            local success, result = pcall(function() -- Line: 112
                -- upvalues: Animator (copy), descendant (copy)
                return Animator:LoadAnimation(descendant);
            end);

            if success and result then
                pcall(function() -- Line: 116
                    -- upvalues: result (copy)
                    result:Play(0, 1, 1);
                end);
                table.insert(u3, v12);
                pcall(function() -- Line: 120
                    -- upvalues: result (copy)
                    result:Stop(0);
                end);
                result:Destroy();
            else
                table.insert(u4, v12);
            end;
        end;
    end;
end;

AnimationController:Destroy();
print("SOUND_OK (" .. #u1 .. "): " .. table.concat(u1, ","));
print("SOUND_ERR (" .. #u2 .. "): " .. table.concat(u2, ","));
print("ANIM_OK (" .. #u3 .. "): " .. table.concat(u3, ","));
print("ANIM_ERR (" .. #u4 .. "): " .. table.concat(u4, ","));

return nil;