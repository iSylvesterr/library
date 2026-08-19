-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");
local Debris = game:GetService("Debris");
local ReplicatedFirst = game:GetService("ReplicatedFirst");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = {};

local function _getResLoadedCounter() -- Line: 48
    -- upvalues: ReplicatedStorage (copy)
    return ReplicatedStorage:FindFirstChild("ResLoadedNumber");
end;

local function _preloadAsync(u2, u3, p4) -- Line: 59
    -- upvalues: ContentProvider (copy)
    local success, result = pcall(function() -- Line: 60
        -- upvalues: ContentProvider (ref), u2 (copy)
        ContentProvider:PreloadAsync(u2);
    end);

    if success then
        return true;
    end;

    warn("[ResRestore] Preload failed:", u3, result);

    if p4 then
        task.delay(p4, function() -- Line: 70
            -- upvalues: ContentProvider (ref), u2 (copy), u3 (copy)
            local success2, result2 = pcall(function() -- Line: 71
                -- upvalues: ContentProvider (ref), u2 (ref)
                ContentProvider:PreloadAsync(u2);
            end);

            if not success2 then
                warn("[ResRestore] Preload retry failed:", u3, result2);
            end;
        end);
    end;

    return false;
end;

local function _applyTextureDescendant(p5, p6) -- Line: 88
    if p5:IsA("MeshPart") then
        if p6 then
            p5:SetAttribute("TextureID", p5.TextureID);
            p5.TextureID = "";

            return;
        end;

        local v7 = p5:GetAttribute("TextureID");

        if type(v7) == "string" and v7 ~= "" then
            p5.TextureID = v7;
        end;

        return;
    end;

    if p5:IsA("ParticleEmitter") then
        if p6 then
            p5:SetAttribute("Texture", p5.Texture);
            p5.Texture = "";

            return;
        end;

        local v8 = p5:GetAttribute("Texture");

        if type(v8) == "string" and v8 ~= "" then
            p5.Texture = v8;
        end;

        return;
    end;

    if not p5:IsA("Beam") then
        if p5:IsA("Decal") then
            if p6 then
                if p5.Texture == "" then
                    return;
                end;

                p5:SetAttribute("Texture", p5.Texture);
                p5.Texture = "";

                return;
            end;

            local v9 = p5:GetAttribute("Texture");

            if type(v9) == "string" and v9 ~= "" then
                p5.Texture = v9;
            end;
        end;

        return;
    end;

    if not p6 then
        local v10 = p5:GetAttribute("Texture");

        if type(v10) == "string" and v10 ~= "" then
            p5.Texture = v10;
        end;

        return;
    end;

    if p5.Texture == "" then
        return;
    end;

    p5:SetAttribute("Texture", p5.Texture);
    p5.Texture = "";
end;

function u1.Restore(p11) -- Line: 160
    -- upvalues: _applyTextureDescendant (copy)
    if p11:GetAttribute("NoAssetID") ~= 1 then
        return;
    end;

    p11:SetAttribute("NoAssetID", 0);

    if not p11:IsA("Sound") then
        for _, descendant in p11:GetDescendants() do
            _applyTextureDescendant(descendant, false);
        end;

        return;
    end;

    local v12 = p11:GetAttribute("SoundId");

    if type(v12) == "string" and v12 ~= "" then
        p11.SoundId = v12;
    end;
end;

function u1.PrepareInstance(p13) -- Line: 186
    -- upvalues: u1 (copy)
    if p13:IsA("Model") or p13:IsA("Sound") then
        u1.Restore(p13);
    end;
end;

function u1.ClearAssert(p14) -- Line: 198
    -- upvalues: _applyTextureDescendant (copy)
    if p14:GetAttribute("NoAssetID") == 1 then
        return;
    end;

    p14:SetAttribute("NoAssetID", 1);

    for _, descendant in p14:GetDescendants() do
        _applyTextureDescendant(descendant, true);
    end;
end;

function u1.ClearAssertSound(p15) -- Line: 215
    for _, child in p15:GetChildren() do
        child:SetAttribute("NoAssetID", 1);

        if child:IsA("Sound") then
            child:SetAttribute("SoundId", child.SoundId);
            child.SoundId = "";
        end;
    end;
end;

function u1.PreloadAss(p16) -- Line: 235
    -- upvalues: _preloadAsync (copy)
    for _, v in p16 do
        task.defer(function() -- Line: 237
            -- upvalues: _preloadAsync (ref), v (copy)
            _preloadAsync({ v }, v, 2);
        end);
    end;
end;

function u1.PreloadAnimation(u17) -- Line: 249
    -- upvalues: ReplicatedStorage (copy), ReplicatedFirst (copy), ContentProvider (copy), Debris (copy)
    task.defer(function() -- Line: 250
        -- upvalues: ReplicatedStorage (ref), u17 (copy), ReplicatedFirst (ref), ContentProvider (ref), Debris (ref)
        local ResLoadedNumber = ReplicatedStorage:FindFirstChild("ResLoadedNumber");
        local v18 = {};

        for _, v in u17 do
            local Animation = Instance.new("Animation");
            Animation.AnimationId = v;
            Animation.Parent = ReplicatedFirst;
            table.insert(v18, Animation);
        end;

        for _, v in v18 do
            task.defer(function() -- Line: 262
                -- upvalues: v (copy), ContentProvider (ref), ResLoadedNumber (copy), Debris (ref)
                local u19 = { v };
                local AnimationId = v.AnimationId;
                local success, result = pcall(function() -- Line: 60
                    -- upvalues: ContentProvider (ref), u19 (copy)
                    ContentProvider:PreloadAsync(u19);
                end);
                local v20;

                if success then
                    v20 = true;
                else
                    warn("[ResRestore] Preload failed:", AnimationId, result);
                    v20 = false;
                end;

                if v20 then
                    if ResLoadedNumber then
                        local v21 = ResLoadedNumber;
                        v21.Value = v21.Value + 1;
                    end;
                else
                    task.delay(0.5, function() -- Line: 269
                        -- upvalues: v (ref), ContentProvider (ref), ResLoadedNumber (ref)
                        local u22 = { v };
                        local AnimationId2 = v.AnimationId;
                        local success2, result2 = pcall(function() -- Line: 60
                            -- upvalues: ContentProvider (ref), u22 (copy)
                            ContentProvider:PreloadAsync(u22);
                        end);
                        local v23;

                        if success2 then
                            v23 = true;
                        else
                            warn("[ResRestore] Preload failed:", AnimationId2, result2);
                            v23 = false;
                        end;

                        if v23 and ResLoadedNumber then
                            local v24 = ResLoadedNumber;
                            v24.Value = v24.Value + 1;
                        end;
                    end);
                end;

                Debris:AddItem(v, 0);
            end);
        end;
    end);
end;

function u1.DeferPreloadModel(u25, u26) -- Line: 289
    -- upvalues: ContentProvider (copy), u1 (copy)
    task.defer(function() -- Line: 290
        -- upvalues: u25 (copy), ContentProvider (ref), u1 (ref), u26 (copy)
        local u27 = { u25 };
        local v28 = "model:" .. u25.Name;
        local success, result = pcall(function() -- Line: 60
            -- upvalues: ContentProvider (ref), u27 (copy)
            ContentProvider:PreloadAsync(u27);
        end);
        local v29;

        if success then
            v29 = true;
        else
            warn("[ResRestore] Preload failed:", v28, result);
            v29 = false;
        end;

        if v29 then
            u1.Restore(u25);

            if u26 then
                u26();
            end;
        end;
    end);
end;

function u1.DeferPreloadAnimationId(u30, u31) -- Line: 307
    -- upvalues: ReplicatedFirst (copy), ContentProvider (copy), Debris (copy)
    task.defer(function() -- Line: 308
        -- upvalues: u30 (copy), ReplicatedFirst (ref), ContentProvider (ref), u31 (copy), Debris (ref)
        local Animation = Instance.new("Animation");
        Animation.AnimationId = u30;
        Animation.Parent = ReplicatedFirst;
        local u32 = { Animation };
        local v33 = u30;
        local success, result = pcall(function() -- Line: 60
            -- upvalues: ContentProvider (ref), u32 (copy)
            ContentProvider:PreloadAsync(u32);
        end);
        local v34;

        if success then
            v34 = true;
        else
            warn("[ResRestore] Preload failed:", v33, result);
            v34 = false;
        end;

        if v34 and u31 then
            u31();
        end;

        Debris:AddItem(Animation, 0);
    end);
end;

function u1.DeferPreloadSound(u35, u36) -- Line: 328
    -- upvalues: ContentProvider (copy), u1 (copy)
    task.defer(function() -- Line: 329
        -- upvalues: u35 (copy), ContentProvider (ref), u1 (ref), u36 (copy)
        local u37 = { u35 };
        local v38 = "sound:" .. u35.Name;
        local success, result = pcall(function() -- Line: 60
            -- upvalues: ContentProvider (ref), u37 (copy)
            ContentProvider:PreloadAsync(u37);
        end);
        local v39;

        if success then
            v39 = true;
        else
            warn("[ResRestore] Preload failed:", v38, result);
            v39 = false;
        end;

        if v39 then
            u1.Restore(u35);

            if u36 then
                u36();
            end;
        end;
    end);
end;

return u1;