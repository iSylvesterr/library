-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Debris = game:GetService("Debris");
local ContentProvider = game:GetService("ContentProvider");
local Players = game:GetService("Players");
local Log = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).Log;
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = false;

local function _init() -- Line: 162
    -- upvalues: u6 (ref), ReplicatedStorage (copy), Log (copy), u5 (copy)
    if u6 then
        return;
    end;

    u6 = true;
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if not Assets then
        Log.warn("[SequenceManager] 未找到 ReplicatedStorage.Assets");

        return;
    end;

    local Sequence = Assets:FindFirstChild("Sequence");

    if Sequence then
        for _, child in Sequence:GetChildren() do
            if child:IsA("Folder") then
                local Name = child.Name;
                local v7 = {};

                for _, child2 in child:GetChildren() do
                    if child2:IsA("StringValue") then
                        local v8 = tonumber(child2.Name);

                        if v8 then
                            table.insert(v7, {
                                index = v8,
                                imageId = child2.Value
                            });
                        end;
                    end;
                end;

                table.sort(v7, function(p9, p10) -- Line: 206
                    return p9.index < p10.index;
                end);
                local v11 = {};

                for _, v in ipairs(v7) do
                    table.insert(v11, v.imageId);
                end;

                u5[Name] = {
                    frames = v11,
                    count = #v11
                };
            end;
        end;

        return;
    end;

    Log.warn("[SequenceManager] 未找到 Assets.Sequence");
end;

local function _getScreenGui() -- Line: 226
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return nil;
    end;

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui then
        return PlayerGui:FindFirstChild("ScreenGui");
    end;

    return nil;
end;

local function _getSequenceData(p12) -- Line: 245
    -- upvalues: _init (copy), u5 (copy)
    _init();

    return u5[p12];
end;

local function _disableLocalScripts(p13) -- Line: 254
    for _, descendant in p13:GetDescendants() do
        if descendant:IsA("LocalScript") then
            descendant.Enabled = false;
        end;
    end;
end;

local function _ensureCloneFrames(p14, p15) -- Line: 267
    -- upvalues: u4 (copy), _disableLocalScripts (copy)
    if u4[p14] then
        return;
    end;

    local v16 = {};
    u4[p14] = v16;

    for i, v in ipairs(p15) do
        local v17 = p14:Clone();
        _disableLocalScripts(v17);
        v17.Parent = p14.Parent;
        v17.Name = "SEQ" .. i;
        v17.Image = v;
        v17.Visible = false;
        v16[i] = v17;
    end;
end;

local function _schedulePreloadObjectCleanup(p18) -- Line: 290
    -- upvalues: Debris (copy)
    for _, v in ipairs(p18) do
        Debris:AddItem(v, 10);
    end;
end;

local function _clampFrame(p19, p20) -- Line: 302
    if p20 <= 0 then
        return 1;
    end;

    local v21 = math.floor(p19);

    return math.clamp(v21, 1, p20);
end;

local function _advanceFrameIndex(p22, p23) -- Line: 315
    for _ = 1, math.max(1, p23) do
        local v24 = p22.currentFrame + p22.direction;

        if p22.frameCount < v24 then
            if p22.pingPong then
                p22.direction = -1;
                local v25 = p22.frameCount - 1;
                v24 = v25 < 1 and 1 or v25;
            else
                if not p22.loop then
                    return false;
                end;

                p22.stopTime = p22.loopInterval;
                v24 = 1;
            end;
        elseif v24 < 1 then
            if p22.pingPong then
                if not p22.loop then
                    return false;
                end;

                p22.direction = 1;
                local v26 = 2;
                v24 = p22.frameCount < v26 and 1 or v26;
            else
                if not p22.loop then
                    return false;
                end;

                p22.stopTime = p22.loopInterval;
                v24 = p22.frameCount;
            end;
        end;

        p22.currentFrame = v24;
    end;

    return true;
end;

local function _applyLayerTransparency(p27) -- Line: 358
    local layerTransparency = p27.layerTransparency;

    if p27.mode == "CloneAll" then
        if p27.nowShow then
            p27.nowShow.ImageTransparency = layerTransparency;
        end;

        return;
    end;

    if p27.mode == "Swap" then
        if p27.bufferA then
            p27.bufferA.ImageTransparency = layerTransparency;
        end;

        return;
    end;

    if p27.crossfading then
        return;
    end;

    local v28;

    if p27.activeIsA then
        v28 = p27.bufferA;
    else
        v28 = p27.bufferB;
    end;

    local v29;

    if p27.activeIsA then
        v29 = p27.bufferB;
    else
        v29 = p27.bufferA;
    end;

    if v28 then
        v28.ImageTransparency = layerTransparency;
        v28.Visible = true;
    end;

    if v29 then
        v29.ImageTransparency = 1;
        v29.Visible = false;
    end;
end;

local function _showCloneFrame(p30, p31) -- Line: 395
    local clones = p30.clones;

    if not clones then
        return;
    end;

    if p30.nowShow then
        p30.nowShow.Visible = false;
    end;

    local v32 = clones[p31];

    if not v32 then
        return;
    end;

    v32.ImageTransparency = p30.layerTransparency;
    v32.Visible = true;
    p30.nowShow = v32;
    p30.currentFrame = p31;
end;

local function _showSwapFrame(p33, p34) -- Line: 418
    local bufferA = p33.bufferA;

    if not bufferA then
        return;
    end;

    local v35 = p33.frames[p34];

    if not v35 then
        return;
    end;

    bufferA.Image = v35;
    bufferA.ImageTransparency = p33.layerTransparency;
    bufferA.Visible = true;
    p33.currentFrame = p34;
end;

local function _beginCrossfade(p36, p37) -- Line: 438
    local v38;

    if p36.activeIsA then
        v38 = p36.bufferA;
    else
        v38 = p36.bufferB;
    end;

    local v39;

    if p36.activeIsA then
        v39 = p36.bufferB;
    else
        v39 = p36.bufferA;
    end;

    local v40 = p36.frames[p37];

    if not (v38 and (v39 and v40)) then
        return;
    end;

    v39.Image = v40;
    v39.Visible = true;
    v39.ImageTransparency = 1;
    v38.Visible = true;
    v38.ImageTransparency = p36.layerTransparency;
    p36.currentFrame = p37;
    p36.crossfadeElapsed = 0;
    p36.crossfading = true;

    if p36.crossfadeSec <= 0 then
        v38.ImageTransparency = 1;
        v38.Visible = false;
        v39.ImageTransparency = p36.layerTransparency;
        p36.activeIsA = not p36.activeIsA;
        p36.crossfading = false;
    end;
end;

local function _tickCrossfade(p41, p42) -- Line: 470
    if not p41.crossfading then
        return;
    end;

    p41.crossfadeElapsed = p41.crossfadeElapsed + p42;
    local v43 = math.max(p41.crossfadeSec, 0.0001);
    local v44 = math.clamp(p41.crossfadeElapsed / v43, 0, 1);
    local layerTransparency = p41.layerTransparency;
    local v45;

    if p41.activeIsA then
        v45 = p41.bufferA;
    else
        v45 = p41.bufferB;
    end;

    local v46;

    if p41.activeIsA then
        v46 = p41.bufferB;
    else
        v46 = p41.bufferA;
    end;

    if v45 then
        v45.ImageTransparency = layerTransparency + (1 - layerTransparency) * v44;
    end;

    if v46 then
        v46.ImageTransparency = 1 - (1 - layerTransparency) * v44;
    end;

    if v44 >= 1 then
        if v45 then
            v45.ImageTransparency = 1;
            v45.Visible = false;
        end;

        if v46 then
            v46.ImageTransparency = layerTransparency;
            v46.Visible = true;
        end;

        p41.activeIsA = not p41.activeIsA;
        p41.crossfading = false;
        p41.crossfadeElapsed = 0;
    end;
end;

local function _ensureCrossfadeBufferB(p47) -- Line: 509
    -- upvalues: _disableLocalScripts (copy)
    local Parent = p47.Parent;

    if not Parent then
        return nil;
    end;

    local v48 = "SEQ_CF_B" .. "_" .. p47.Name;
    local v49 = Parent:FindFirstChild(v48);

    if v49 and v49:IsA("ImageLabel") then
        return v49;
    end;

    local v50 = p47:Clone();
    _disableLocalScripts(v50);
    v50.Name = v48;
    v50.Visible = false;
    v50.ImageTransparency = 1;
    v50.Parent = Parent;

    return v50;
end;

local function _cleanupClones(p51) -- Line: 534
    -- upvalues: u4 (copy), Debris (copy)
    local v52 = u4[p51];

    if not v52 then
        return;
    end;

    for _, v in ipairs(v52) do
        if v then
            v.Visible = false;
            Debris:AddItem(v, 10);
        end;
    end;

    u4[p51] = nil;
end;

local function _cleanupCrossfadeBuffers(p53) -- Line: 552
    local bufferB = p53.bufferB;

    if bufferB then
        bufferB:Destroy();
    end;

    p53.bufferB = nil;
end;

local function _bindDestroyCleanup(u54) -- Line: 565
    -- upvalues: u1 (copy)
    if u54.Parent then
        return u54.Destroying:Connect(function() -- Line: 570
            -- upvalues: u1 (ref), u54 (copy)
            u1:StopSequence(u54);
        end);
    end;

    return nil;
end;

local function _bindPlaybackConnection(u55, u56) -- Line: 581
    -- upvalues: RunService (copy), u2 (copy), _tickCrossfade (copy), _advanceFrameIndex (copy), u1 (copy), _beginCrossfade (copy)
    return RunService.Stepped:Connect(function(p57, p58) -- Line: 582
        -- upvalues: u2 (ref), u55 (copy), u56 (copy), _tickCrossfade (ref), _advanceFrameIndex (ref), u1 (ref), _beginCrossfade (ref)
        local v59 = u2[u55];

        if not v59 or v59.state ~= u56 then
            return;
        end;

        if u56.crossfading then
            _tickCrossfade(u56, p58);

            return;
        end;

        if u56.stopTime > 0 then
            local v60 = u56;
            v60.stopTime = v60.stopTime - p58;
            u56.elapsed = 0;

            return;
        end;

        local v61 = u56.frameDuration * 0.016 / math.max(u56.speedScale, 0.01);
        local v62 = u56;
        v62.elapsed = v62.elapsed + p58;

        if u56.elapsed < v61 then
            return;
        end;

        local v63 = math.floor(u56.elapsed / v61);
        u56.elapsed = 0;

        if not _advanceFrameIndex(u56, v63) then
            if u56.mode == "CloneAll" then
                u55.Image = "";
            end;

            u1:StopSequence(u55);

            return;
        end;

        if u56.mode == "CloneAll" then
            local v64 = u56;
            local currentFrame = u56.currentFrame;
            local clones = v64.clones;

            if not clones then
                return;
            end;

            if v64.nowShow then
                v64.nowShow.Visible = false;
            end;

            local v65 = clones[currentFrame];

            if not v65 then
                return;
            end;

            v65.ImageTransparency = v64.layerTransparency;
            v65.Visible = true;
            v64.nowShow = v65;
            v64.currentFrame = currentFrame;

            return;
        end;

        if u56.mode ~= "Swap" then
            _beginCrossfade(u56, u56.currentFrame);

            return;
        end;

        local v66 = u56;
        local currentFrame = u56.currentFrame;
        local bufferA = v66.bufferA;

        if not bufferA then
            return;
        end;

        local v67 = v66.frames[currentFrame];

        if not v67 then
            return;
        end;

        bufferA.Image = v67;
        bufferA.ImageTransparency = v66.layerTransparency;
        bufferA.Visible = true;
        v66.currentFrame = currentFrame;
    end);
end;

local function _normalizeOptions(p68, p69) -- Line: 633
    local frameDuration = p68.frameDuration;
    local v70 = p68.mode or "CloneAll";
    local v71 = p68.startFrame or 1;
    local v72;

    if p69 <= 0 then
        v72 = 1;
    else
        local v73 = math.floor(v71);
        v72 = math.clamp(v73, 1, p69);
    end;

    return {
        frameDuration = frameDuration,
        loop = p68.loop == nil and true or p68.loop,
        loopInterval = p68.loopInterval or 0,
        startFrame = v72,
        pingPong = p68.pingPong == true,
        mode = v70,
        crossfadeSec = p68.crossfadeSec or 0.04,
        speedScale = p68.speedScale or 1,
        layerTransparency = p68.layerTransparency or 0
    };
end;

function u1.StopSequence(p74, p75) -- Line: 659
    -- upvalues: u2 (copy), _cleanupClones (copy)
    if not p75 then
        return nil;
    end;

    local v76 = u2[p75];

    if v76 then
        v76.connection:Disconnect();

        if v76.destroyConnection then
            v76.destroyConnection:Disconnect();
        end;

        local state = v76.state;

        if state.mode == "CloneAll" then
            _cleanupClones(p75);
            p75.Visible = false;
        elseif state.mode == "Crossfade" then
            local bufferB = state.bufferB;

            if bufferB then
                bufferB:Destroy();
            end;

            state.bufferB = nil;
            p75.Visible = false;
        else
            p75.Visible = false;
        end;

        u2[p75] = nil;
    else
        _cleanupClones(p75);
        p75.Visible = false;
    end;

    return nil;
end;

function u1.SetPlaybackSpeed(p77, p78, p79) -- Line: 697
    -- upvalues: u2 (copy)
    local v80 = u2[p78];

    if not v80 then
        return nil;
    end;

    if typeof(p79) ~= "number" or p79 <= 0 then
        return nil;
    end;

    v80.state.speedScale = p79;

    return nil;
end;

function u1.SetLayerTransparency(p81, p82, p83) -- Line: 715
    -- upvalues: u2 (copy), _applyLayerTransparency (copy)
    local v84 = u2[p82];

    if not v84 then
        return nil;
    end;

    if typeof(p83) ~= "number" then
        return nil;
    end;

    v84.state.layerTransparency = math.clamp(p83, 0, 1);
    _applyLayerTransparency(v84.state);

    return nil;
end;

function u1.Preload(u85, u86) -- Line: 733
    -- upvalues: Players (copy), Debris (copy)
    task.defer(function() -- Line: 734
        -- upvalues: u85 (copy), u86 (copy), Players (ref), Debris (ref)
        u85:PreloadImages(u86);
        local LocalPlayer = Players.LocalPlayer;
        local v87;

        if LocalPlayer then
            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

            if PlayerGui then
                v87 = PlayerGui:FindFirstChild("ScreenGui");
            else
                v87 = nil;
            end;
        else
            v87 = nil;
        end;

        if not v87 then
            return;
        end;

        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Parent = v87;
        ImageLabel.Visible = false;
        u85:PlaySequence(ImageLabel, u86, 1, false);
        task.delay(5, function() -- Line: 748
            -- upvalues: u85 (ref), ImageLabel (copy), Debris (ref)
            u85:StopSequence(ImageLabel);
            Debris:AddItem(ImageLabel, 0);
        end);
    end);

    return nil;
end;

function u1.PreloadImages(p88, p89) -- Line: 761
    -- upvalues: _init (copy), u5 (copy), Log (copy), u3 (copy), Players (copy), ContentProvider (copy), Debris (copy)
    _init();
    local v90 = u5[p89];

    if not v90 or v90.count == 0 then
        Log.warn("[SequenceManager] 不存在资源:", p89);

        return nil;
    end;

    local v91 = {};

    for _, v in ipairs(v90.frames) do
        if not u3[v] then
            table.insert(v91, v);
        end;
    end;

    if #v91 == 0 then
        return nil;
    end;

    local LocalPlayer = Players.LocalPlayer;
    local v92;

    if LocalPlayer then
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

        if PlayerGui then
            v92 = PlayerGui:FindFirstChild("ScreenGui");
        else
            v92 = nil;
        end;
    else
        v92 = nil;
    end;

    if not v92 then
        return nil;
    end;

    local u93 = {};

    for _, v in ipairs(v91) do
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Parent = v92;
        ImageLabel.Image = v;
        ImageLabel.Size = UDim2.new(0, 1, 0, 1);
        ImageLabel.Visible = false;
        table.insert(u93, ImageLabel);
    end;

    local success, result = pcall(function() -- Line: 794
        -- upvalues: ContentProvider (ref), u93 (copy)
        ContentProvider:PreloadAsync(u93);
    end);

    if not success then
        Log.warn("[SequenceManager] PreloadAsync 失败:", p89, result);
    end;

    for _, v in ipairs(u93) do
        Debris:AddItem(v, 10);
    end;

    for _, v in ipairs(v91) do
        u3[v] = true;
    end;

    return nil;
end;

function u1.PlaySequenceEx(p94, u95, p96, p97) -- Line: 817
    -- upvalues: Log (copy), _init (copy), u5 (copy), _normalizeOptions (copy), _ensureCloneFrames (copy), u4 (copy), _ensureCrossfadeBufferB (copy), RunService (copy), u2 (copy), _tickCrossfade (copy), _advanceFrameIndex (copy), u1 (copy), _beginCrossfade (copy)
    if not u95 or typeof(p97) ~= "table" then
        Log.warn("[SequenceManager] PlaySequenceEx 参数无效");

        return nil;
    end;

    local frameDuration = p97.frameDuration;

    if not frameDuration or frameDuration <= 0 then
        Log.warn("[SequenceManager] PlaySequenceEx frameDuration 无效");

        return nil;
    end;

    p94:StopSequence(u95);
    _init();
    local v98 = u5[p96];

    if not v98 or v98.count == 0 then
        Log.warn("[SequenceManager] 序列不存在:", p96);

        return nil;
    end;

    local v99 = _normalizeOptions(p97, v98.count);
    local mode = v99.mode;
    local startFrame = v99.startFrame;
    local u100 = {
        direction = 1,
        elapsed = 0,
        stopTime = 0,
        crossfading = false,
        crossfadeElapsed = 0,
        activeIsA = true,
        bufferA = nil,
        bufferB = nil,
        clones = nil,
        nowShow = nil,
        mode = mode,
        frames = v98.frames,
        frameCount = v98.count,
        currentFrame = startFrame,
        frameDuration = frameDuration,
        speedScale = v99.speedScale,
        loop = v99.loop,
        loopInterval = v99.loopInterval,
        pingPong = v99.pingPong,
        crossfadeSec = v99.crossfadeSec,
        layerTransparency = math.clamp(v99.layerTransparency, 0, 1)
    };

    if mode == "CloneAll" then
        _ensureCloneFrames(u95, v98.frames);
        u100.clones = u4[u95];
        u95.Visible = false;
        u95.Image = "";
        local clones = u100.clones;

        if clones then
            if u100.nowShow then
                u100.nowShow.Visible = false;
            end;

            local v101 = clones[startFrame];

            if v101 then
                v101.ImageTransparency = u100.layerTransparency;
                v101.Visible = true;
                u100.nowShow = v101;
                u100.currentFrame = startFrame;
            end;
        end;
    elseif mode == "Swap" then
        u100.bufferA = u95;
        local bufferA = u100.bufferA;
        local v102 = bufferA and u100.frames[startFrame];

        if v102 then
            bufferA.Image = v102;
            bufferA.ImageTransparency = u100.layerTransparency;
            bufferA.Visible = true;
            u100.currentFrame = startFrame;
        end;
    else
        local v103 = _ensureCrossfadeBufferB(u95);

        if not v103 then
            Log.warn("[SequenceManager] Crossfade 无法创建缓冲");

            return nil;
        end;

        u100.bufferA = u95;
        u100.bufferB = v103;
        u100.activeIsA = true;
        u95.Image = v98.frames[startFrame] or "";
        u95.ImageTransparency = u100.layerTransparency;
        u95.Visible = true;
        v103.Visible = false;
        v103.ImageTransparency = 1;
    end;

    local v115 = {
        connection = RunService.Stepped:Connect(function(p104, p105) -- Line: 582
            -- upvalues: u2 (ref), u95 (copy), u100 (copy), _tickCrossfade (ref), _advanceFrameIndex (ref), u1 (ref), _beginCrossfade (ref)
            local v106 = u2[u95];

            if not v106 or v106.state ~= u100 then
                return;
            end;

            if u100.crossfading then
                _tickCrossfade(u100, p105);

                return;
            end;

            if u100.stopTime > 0 then
                local v107 = u100;
                v107.stopTime = v107.stopTime - p105;
                u100.elapsed = 0;

                return;
            end;

            local v108 = u100.frameDuration * 0.016 / math.max(u100.speedScale, 0.01);
            local v109 = u100;
            v109.elapsed = v109.elapsed + p105;

            if u100.elapsed < v108 then
                return;
            end;

            local v110 = math.floor(u100.elapsed / v108);
            u100.elapsed = 0;

            if not _advanceFrameIndex(u100, v110) then
                if u100.mode == "CloneAll" then
                    u95.Image = "";
                end;

                u1:StopSequence(u95);

                return;
            end;

            if u100.mode == "CloneAll" then
                local v111 = u100;
                local currentFrame = u100.currentFrame;
                local clones = v111.clones;

                if not clones then
                    return;
                end;

                if v111.nowShow then
                    v111.nowShow.Visible = false;
                end;

                local v112 = clones[currentFrame];

                if not v112 then
                    return;
                end;

                v112.ImageTransparency = v111.layerTransparency;
                v112.Visible = true;
                v111.nowShow = v112;
                v111.currentFrame = currentFrame;

                return;
            end;

            if u100.mode ~= "Swap" then
                _beginCrossfade(u100, u100.currentFrame);

                return;
            end;

            local v113 = u100;
            local currentFrame = u100.currentFrame;
            local bufferA = v113.bufferA;

            if not bufferA then
                return;
            end;

            local v114 = v113.frames[currentFrame];

            if not v114 then
                return;
            end;

            bufferA.Image = v114;
            bufferA.ImageTransparency = v113.layerTransparency;
            bufferA.Visible = true;
            v113.currentFrame = currentFrame;
        end)
    };
    local v116;

    if u95.Parent then
        v116 = u95.Destroying:Connect(function() -- Line: 570
            -- upvalues: u1 (ref), u95 (copy)
            u1:StopSequence(u95);
        end);
    else
        v116 = nil;
    end;

    v115.destroyConnection = v116;
    v115.state = u100;
    u2[u95] = v115;

    return nil;
end;

function u1.PlaySequence(p117, p118, p119, p120, p121, p122) -- Line: 915
    return p117:PlaySequenceEx(p118, p119, {
        mode = "CloneAll",
        startFrame = 1,
        pingPong = false,
        speedScale = 1,
        layerTransparency = 0,
        frameDuration = p120,
        loop = p121,
        loopInterval = p122 or 0
    });
end;

u1.PreLoad = u1.Preload;

return u1;