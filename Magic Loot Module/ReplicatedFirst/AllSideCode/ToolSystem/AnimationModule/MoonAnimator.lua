-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local PartIcles = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).PartIcles;
local u1 = {};
local u2 = {};
local u3 = nil;
local u4 = 0;
local u5 = false;
local u6 = nil;

local function _getSavesFolder() -- Line: 50
    -- upvalues: ReplicatedStorage (copy)
    return ReplicatedStorage:FindFirstChild("MoonAnimator2Saves");
end;

local function _getAnimFile(p7) -- Line: 59
    -- upvalues: ReplicatedStorage (copy)
    local MoonAnimator2Saves = ReplicatedStorage:FindFirstChild("MoonAnimator2Saves");

    if not MoonAnimator2Saves then
        return nil;
    end;

    local v8 = MoonAnimator2Saves:FindFirstChild(p7);

    if v8 and v8:IsA("StringValue") then
        return v8;
    end;

    return nil;
end;

local function _requireCutscene() -- Line: 75
    -- upvalues: ReplicatedStorage (copy)
    local MoonAnimator2Script = ReplicatedStorage:FindFirstChild("MoonAnimator2Script");

    if MoonAnimator2Script then
        MoonAnimator2Script = MoonAnimator2Script:FindFirstChild("Moon2Cutscene");
    end;

    if not (MoonAnimator2Script and MoonAnimator2Script:IsA("ModuleScript")) then
        warn("[MoonAnimator] 缺少 Moon2Cutscene");

        return nil;
    end;

    local success, result = pcall(require, MoonAnimator2Script);

    if success then
        return result;
    end;

    warn("[MoonAnimator] require Moon2Cutscene 失败:", result);

    return nil;
end;

local function _decodeMoonJson(u9) -- Line: 95
    -- upvalues: HttpService (copy)
    local success, result = pcall(function() -- Line: 96
        -- upvalues: HttpService (ref), u9 (copy)
        return HttpService:JSONDecode(u9);
    end);

    if not success then
        return nil;
    end;

    if type(result) == "string" then
        local success2, result2 = pcall(function() -- Line: 103
            -- upvalues: HttpService (ref), result (ref)
            return HttpService:JSONDecode(result);
        end);
        result = result2;

        if not success2 then
            return nil;
        end;
    end;

    return result;
end;

local function _readBoolKeyframeValue(u10) -- Line: 118
    if u10:IsA("BoolValue") then
        return u10.Value;
    end;

    if u10:IsA("NumberValue") or u10:IsA("IntValue") then
        return u10.Value ~= 0;
    end;

    if u10:IsA("StringValue") then
        local v11 = string.lower(u10.Value);

        if v11 == "true" or v11 == "1" then
            return true;
        end;

        if v11 == "false" or v11 == "0" then
            return false;
        end;
    end;

    local success, result = pcall(function() -- Line: 134
        -- upvalues: u10 (copy)
        return u10.Value;
    end);

    if not success then
        return nil;
    end;

    if typeof(result) == "boolean" then
        return result;
    end;

    if type(result) == "number" then
        return result ~= 0;
    end;

    if type(result) == "string" then
        local v12 = string.lower(result);

        if v12 == "true" or v12 == "1" then
            return true;
        end;

        if v12 == "false" or v12 == "0" then
            return false;
        end;
    end;

    return nil;
end;

local function _resolveInstanceNames(p13) -- Line: 163
    if type(p13) ~= "table" or #p13 == 0 then
        return nil;
    end;

    local v14 = game;

    for _, v in ipairs(p13) do
        if v == "game" or v == "Game" then
            v14 = game;
        else
            if not v14 then
                return nil;
            end;

            v14 = v14:FindFirstChild(v);
        end;
    end;

    return v14;
end;

local function _resolveCutsceneItem(p15, p16, p17) -- Line: 188
    -- upvalues: _resolveInstanceNames (copy)
    if p15 then
        p15 = p15.objs or p15.objects or (p15.Objects or p15.Items);
    end;

    if type(p15) == "table" then
        local v18 = p15[p17];

        if typeof(v18) == "Instance" then
            return v18;
        end;
    end;

    if type(p16) == "table" and type(p16.Items) == "table" then
        local v19 = p16.Items[p17];
        local v20;

        if type(v19) == "table" then
            v20 = v19.Path or v19.path or nil;
        else
            v20 = nil;
        end;

        local v21;

        if type(v20) == "table" then
            v21 = v20.InstanceNames or v20.instanceNames or nil;
        else
            v21 = nil;
        end;

        if type(v21) == "table" then
            return _resolveInstanceNames(v21);
        end;
    end;

    return nil;
end;

local function _collectEnabledApplyTargets(p22) -- Line: 219
    local u23 = {};

    local function tryAdd(p24) -- Line: 221
        -- upvalues: u23 (copy)
        if p24:IsA("ParticleEmitter") or (p24:IsA("Beam") or (p24:IsA("Trail") or p24:IsA("Light"))) then
            table.insert(u23, p24);
        end;
    end;

    if p22:IsA("ParticleEmitter") or (p22:IsA("Beam") or (p22:IsA("Trail") or p22:IsA("Light"))) then
        table.insert(u23, p22);
    end;

    if not (p22:IsA("ParticleEmitter") or (p22:IsA("Beam") or (p22:IsA("Trail") or p22:IsA("Light")))) then
        for _, descendant in ipairs(p22:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or (descendant:IsA("Beam") or (descendant:IsA("Trail") or descendant:IsA("Light"))) then
                table.insert(u23, descendant);
            end;
        end;
    end;

    return u23;
end;

local function _applyEnabledValue(u25, u26) -- Line: 241
    -- upvalues: _collectEnabledApplyTargets (copy), PartIcles (copy)
    if u25.lastApplied == u26 then
        return;
    end;

    local v27;

    if u26 == true then
        v27 = u25.lastApplied ~= true;
    else
        v27 = false;
    end;

    u25.lastApplied = u26;
    local v28 = _collectEnabledApplyTargets(u25.target);

    if #v28 == 0 then
        pcall(function() -- Line: 251
            -- upvalues: u25 (copy), u26 (copy)
            u25.target.Enabled = u26;
        end);

        if v27 and u25.target.Parent then
            pcall(function() -- Line: 255
                -- upvalues: PartIcles (ref), u25 (copy)
                PartIcles:AbsoluteEmit(u25.target);
            end);
        end;

        return;
    end;

    for _, v in ipairs(v28) do
        pcall(function() -- Line: 262
            -- upvalues: v (copy), u26 (copy)
            v.Enabled = u26;
        end);
    end;

    if v27 and u25.target.Parent then
        pcall(function() -- Line: 268
            -- upvalues: PartIcles (ref), u25 (copy)
            PartIcles:AbsoluteEmit(u25.target);
        end);
    end;
end;

local function _collectEnabledKeyframes(p29) -- Line: 279
    -- upvalues: _readBoolKeyframeValue (copy)
    local u30 = {};
    local u31 = {};

    local function addKf(p32, p33) -- Line: 283
        -- upvalues: u31 (copy), u30 (copy)
        if p33 == nil or u31[p32] then
            return;
        end;

        u31[p32] = true;
        table.insert(u30, {
            frame = p32,
            value = p33
        });
    end;

    local default = p29:FindFirstChild("default");

    if default then
        local v34 = _readBoolKeyframeValue(default);

        if v34 ~= nil and not u31[0] then
            u31[0] = true;
            table.insert(u30, {
                frame = 0,
                value = v34
            });
        end;
    end;

    for _, child in ipairs(p29:GetChildren()) do
        if child.Name ~= "default" then
            local v35 = tonumber(child.Name);

            if v35 then
                local v36 = nil;

                if child:IsA("ValueBase") then
                    v36 = _readBoolKeyframeValue(child);
                else
                    local Values = child:FindFirstChild("Values");
                    local v37;

                    if Values then
                        v37 = Values:FindFirstChild("0") or (Values:FindFirstChild("1") or Values:GetChildren()[1]);
                    else
                        v37 = nil;
                    end;

                    local v38 = v37 or (child:FindFirstChild("default") or child:FindFirstChildWhichIsA("ValueBase", true));

                    if v38 then
                        v36 = _readBoolKeyframeValue(v38);
                    end;
                end;

                if v36 ~= nil then
                    if not u31[v35] then
                        u31[v35] = true;
                        table.insert(u30, {
                            frame = v35,
                            value = v36
                        });
                    end;
                end;
            end;
        end;
    end;

    table.sort(u30, function(p39, p40) -- Line: 328
        return p39.frame < p40.frame;
    end);

    return u30;
end;

local function _collectEnabledKeyframesFromJsonItem(p41) -- Line: 339
    local u42 = {};

    if type(p41) ~= "table" then
        return u42;
    end;

    local v43 = p41.Tracks or p41.tracks;

    if type(v43) ~= "table" then
        return u42;
    end;

    local v44 = v43.Enabled or v43.enabled;

    if type(v44) ~= "table" then
        return u42;
    end;

    local function addFromValue(p45, p46) -- Line: 353
        -- upvalues: u42 (copy)
        local v47 = nil;

        if typeof(p46) == "boolean" then
            v47 = p46;
        elseif type(p46) == "number" then
            v47 = p46 ~= 0;
        elseif type(p46) == "string" then
            local v48 = string.lower(p46);

            if v48 == "true" or v48 == "1" then
                v47 = true;
            elseif v48 == "false" or v48 == "0" then
                v47 = false;
            end;
        elseif type(p46) == "table" then
            local v49 = p46.Value or p46.value or (p46.Default or p46.default);

            if typeof(v49) == "boolean" then
                v47 = v49;
            elseif type(v49) == "number" then
                v47 = v49 ~= 0;
            end;
        end;

        if v47 ~= nil then
            table.insert(u42, {
                frame = p45,
                value = v47
            });
        end;
    end;

    local v50 = v44.Default or v44.default;

    if v50 ~= nil then
        addFromValue(0, v50);
    end;

    local v51 = v44.Keyframes or v44.keyframes or (v44.Frames or v44.frames);

    if type(v51) == "table" then
        if v51[1] == nil then
            for i, v in pairs(v51) do
                local v52 = tonumber(i);

                if v52 and type(v) == "table" then
                    addFromValue(v52, v.Value or (v.value or v));
                elseif v52 then
                    addFromValue(v52, v);
                end;
            end;
        else
            for _, v in ipairs(v51) do
                if type(v) == "table" then
                    addFromValue(tonumber(v.Frame or v.frame or (v.Time or v.time)) or 0, v.Value or (v.value or v));
                end;
            end;
        end;
    end;

    table.sort(u42, function(p53, p54) -- Line: 405
        return p53.frame < p54.frame;
    end);

    return u42;
end;

local function _mergeEnabledKeyframes(p55, p56) -- Line: 417
    local v57 = {};
    local v58 = {};

    for _, v in ipairs(p55) do
        v57[v.frame] = true;
        table.insert(v58, v);
    end;

    for _, v in ipairs(p56) do
        if not v57[v.frame] then
            table.insert(v58, v);
        end;
    end;

    table.sort(v58, function(p59, p60) -- Line: 432
        return p59.frame < p60.frame;
    end);

    return v58;
end;

local function _collectEnabledTracks(p61, p62) -- Line: 444
    -- upvalues: _decodeMoonJson (copy), _collectEnabledKeyframes (copy), _collectEnabledKeyframesFromJsonItem (copy), _mergeEnabledKeyframes (copy), _resolveCutsceneItem (copy)
    local v63 = _decodeMoonJson(p61.Value);
    local v64 = {};
    local v65;

    if type(v63) == "table" then
        v65 = v63.Items or nil;
    else
        v65 = nil;
    end;

    for _, child in ipairs(p61:GetChildren()) do
        local v66 = tonumber(child.Name);

        if v66 then
            local Enabled = child:FindFirstChild("Enabled");
            local v67 = _mergeEnabledKeyframes(not Enabled and {} or _collectEnabledKeyframes(Enabled), not (v65 and v65[v66]) and {} or _collectEnabledKeyframesFromJsonItem(v65[v66]));

            if #v67 ~= 0 then
                local v68 = _resolveCutsceneItem(p62, v63, v66);

                if typeof(v68) == "Instance" then
                    table.insert(v64, {
                        lastApplied = nil,
                        target = v68,
                        keyframes = v67
                    });
                end;
            end;
        end;
    end;

    if #v64 == 0 and type(v65) == "table" then
        for i, v in ipairs(v65) do
            local v69 = _collectEnabledKeyframesFromJsonItem(v);

            if #v69 ~= 0 then
                local v70 = _resolveCutsceneItem(p62, v63, i);

                if typeof(v70) == "Instance" then
                    table.insert(v64, {
                        lastApplied = nil,
                        target = v70,
                        keyframes = v69
                    });
                end;
            end;
        end;
    end;

    return v64;
end;

local function _sampleEnabledAtFrame(p71, p72) -- Line: 500
    local v73 = nil;

    for _, v in ipairs(p71) do
        if v.frame > p72 then
            break;
        end;

        v73 = v.value;
    end;

    if v73 == nil then
        return false;
    end;

    return v73;
end;

local function _startEnabledTrackDriver(u74, u75, u76, u77) -- Line: 523
    -- upvalues: u4 (ref), _collectEnabledTracks (copy), _applyEnabledValue (copy), _sampleEnabledAtFrame (copy), RunService (copy)
    task.spawn(function() -- Line: 524
        -- upvalues: u76 (copy), u4 (ref), u75 (copy), u77 (ref), _collectEnabledTracks (ref), u74 (copy), _applyEnabledValue (ref), _sampleEnabledAtFrame (ref), RunService (ref)
        if u76 ~= u4 then
            return;
        end;

        pcall(function() -- Line: 530
            -- upvalues: u75 (ref), u77 (ref)
            local v78 = tonumber(u75.FPS) or (tonumber(u75.fps) or tonumber(u75.FrameRate));

            if v78 and v78 ~= 0 then
                u77 = math.abs(v78);
            end;
        end);
        task.wait();

        if u76 ~= u4 then
            return;
        end;

        local u79 = _collectEnabledTracks(u74, u75);

        if #u79 == 0 then
            return;
        end;

        for _, v in ipairs(u79) do
            v.lastApplied = nil;
            _applyEnabledValue(v, false);
        end;

        local v80 = os.clock();
        local v81 = false;

        while u76 == u4 do
            local u82 = false;
            pcall(function() -- Line: 558
                -- upvalues: u82 (ref), u75 (ref)
                u82 = u75:isPlaying() == true;
            end);

            if u82 then
                v81 = true;
                break;
            end;

            if os.clock() - v80 > 2 then
                break;
            end;

            task.wait();
        end;

        if u76 ~= u4 then
            return;
        end;

        local u83 = os.clock();

        for _, v in ipairs(u79) do
            v.lastApplied = nil;
            _applyEnabledValue(v, (_sampleEnabledAtFrame(v.keyframes, 0)));
        end;

        local u84 = nil;
        u84 = RunService.RenderStepped:Connect(function() -- Line: 586
            -- upvalues: u76 (ref), u4 (ref), u84 (ref), u74 (ref), u75 (ref), u83 (copy), u77 (ref), u79 (copy), _applyEnabledValue (ref), _sampleEnabledAtFrame (ref)
            if u76 ~= u4 then
                if u84 then
                    u84:Disconnect();
                end;

                return;
            end;

            if not u74.Parent then
                if u84 then
                    u84:Disconnect();
                end;

                return;
            end;

            local u85 = false;
            pcall(function() -- Line: 601
                -- upvalues: u85 (ref), u75 (ref)
                u85 = u75:isPlaying() == true;
            end);

            if not u85 and os.clock() - u83 > 0.25 then
                if u84 then
                    u84:Disconnect();
                end;

                return;
            end;

            local v86 = (os.clock() - u83) * u77;
            local u87 = math.max(0, v86);
            pcall(function() -- Line: 614
                -- upvalues: u75 (ref), u87 (ref), u77 (ref)
                local v88 = nil;

                if type(u75.getFrame) == "function" then
                    v88 = tonumber(u75:getFrame());
                elseif type(u75.GetFrame) == "function" then
                    v88 = tonumber(u75:GetFrame());
                elseif u75.frame == nil then
                    if u75.Frame ~= nil then
                        v88 = tonumber(u75.Frame);
                    end;
                else
                    v88 = tonumber(u75.frame);
                end;

                if v88 and (v88 >= 0 and math.abs(v88 - u87) < u77 * 0.5) then
                    u87 = v88;
                end;
            end);

            for _, v in ipairs(u79) do
                if v.target.Parent then
                    _applyEnabledValue(v, (_sampleEnabledAtFrame(v.keyframes, u87)));
                end;
            end;
        end);
    end);
end;

local function _getMoonFps(p89) -- Line: 644
    -- upvalues: _decodeMoonJson (copy)
    local v90 = _decodeMoonJson(p89.Value);

    if type(v90) == "table" and type(v90.Information) == "table" then
        local v91 = tonumber(v90.Information.FPS) or tonumber(v90.Information.Fps);

        if v91 and v91 > 0 then
            return v91;
        end;
    end;

    return 60;
end;

local function _isMarkerTrack(p92) -- Line: 672
    if type(p92) ~= "table" then
        return false;
    end;

    local v93 = p92.Type or (p92.type or p92.TrackType or (p92.Name or p92.name));

    return v93 == "MarkerTrack" and true or v93 == "Marker";
end;

local function _readMarkerNameFromFrameNode(p94) -- Line: 685
    if p94:IsA("StringValue") or p94:IsA("NumberValue") then
        return tostring(p94.Value);
    end;

    local Values = p94:FindFirstChild("Values");
    local v95;

    if Values then
        v95 = Values:FindFirstChild("0") or (Values:FindFirstChild("1") or Values:GetChildren()[1]);
    else
        v95 = nil;
    end;

    local u96 = v95 or p94:FindFirstChildWhichIsA("ValueBase", true);

    if not u96 then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 700
        -- upvalues: u96 (ref)
        return u96.Value;
    end);

    if success and (type(result) == "string" or type(result) == "number") then
        local v97 = tostring(result);

        if v97 ~= "" then
            return v97;
        end;
    end;

    return nil;
end;

local function _collectMarkerFramesFromJsonTrack(p98, p99, p100) -- Line: 719
    if type(p98) ~= "table" then
        return;
    end;

    local v101 = p98.Keyframes or p98.keyframes or (p98.Frames or p98.frames or (p98.Markers or p98.markers));

    if type(v101) == "table" then
        if v101[1] == nil then
            for i, v in pairs(v101) do
                local v102 = tonumber(i);

                if not v102 and type(v) == "table" then
                    v102 = tonumber(v.Frame or v.frame);
                end;

                if v102 then
                    local v103 = nil;
                    local v;

                    if type(v) == "table" then
                        v = v.Value or (v.value or v.Name or (v.name or v.Marker));
                    elseif type(v) ~= "string" then
                        v = v103;
                    end;

                    local v104 = {
                        itemIndex = p99,
                        frame = v102
                    };

                    if type(v) ~= "string" or v == "" then
                        v = nil;
                    end;

                    v104.markerName = v;
                    table.insert(p100, v104);
                end;
            end;

            return;
        end;

        for _, v in ipairs(v101) do
            if type(v) == "table" then
                local v105 = tonumber(v.Frame or v.frame or (v.Time or v.time));

                if v105 then
                    local v106 = v.Value or (v.value or v.Name or (v.name or v.Marker));
                    local v107 = {
                        itemIndex = p99,
                        frame = v105
                    };

                    if type(v106) ~= "string" or v106 == "" then
                        v106 = nil;
                    end;

                    v107.markerName = v106;
                    table.insert(p100, v107);
                end;
            end;
        end;

        return;
    end;

    local v108 = tonumber(p98.Frame or p98.frame);

    if v108 then
        local v109 = p98.Value or (p98.value or p98.Name or (p98.name or p98.Marker));
        local v110 = {
            itemIndex = p99,
            frame = v108
        };

        if type(v109) ~= "string" or v109 == "" then
            v109 = nil;
        end;

        v110.markerName = v109;
        table.insert(p100, v110);
    end;
end;

local function _extractMarkerPlan(p111) -- Line: 779
    -- upvalues: _decodeMoonJson (copy), _collectMarkerFramesFromJsonTrack (copy), _readMarkerNameFromFrameNode (copy)
    local v112 = {};
    local v113 = _decodeMoonJson(p111.Value);
    local v114;

    if type(v113) == "table" then
        v114 = v113.Items or nil;
    else
        v114 = nil;
    end;

    if type(v114) == "table" then
        for i, v in ipairs(v114) do
            if type(v) == "table" then
                local v115 = v.Tracks or v.tracks;

                if type(v115) == "table" then
                    if v115[1] == nil then
                        for i2, v2 in pairs(v115) do
                            if i2 == "MarkerTrack" or i2 == "Marker" then
                                _collectMarkerFramesFromJsonTrack(v2, i, v112);
                            else
                                local v116;

                                if type(v2) == "table" then
                                    local v117 = v2.Type or (v2.type or v2.TrackType or (v2.Name or v2.name));
                                    v116 = v117 == "MarkerTrack" and true or v117 == "Marker";
                                else
                                    v116 = false;
                                end;

                                if v116 then
                                    _collectMarkerFramesFromJsonTrack(v2, i, v112);
                                end;
                            end;
                        end;
                    else
                        for _, v2 in ipairs(v115) do
                            local v118;

                            if type(v2) == "table" then
                                local v119 = v2.Type or (v2.type or v2.TrackType or (v2.Name or v2.name));
                                v118 = v119 == "MarkerTrack" and true or v119 == "Marker";
                            else
                                v118 = false;
                            end;

                            if v118 then
                                _collectMarkerFramesFromJsonTrack(v2, i, v112);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    for _, child in ipairs(p111:GetChildren()) do
        local v120 = tonumber(child.Name);

        if v120 then
            local v121 = child:FindFirstChild("MarkerTrack") or child:FindFirstChild("Marker");

            if v121 then
                for _, child2 in ipairs(v121:GetChildren()) do
                    local v122 = tonumber(child2.Name);

                    if v122 then
                        local v123 = {
                            itemIndex = v120,
                            frame = v122,
                            markerName = _readMarkerNameFromFrameNode(child2)
                        };
                        table.insert(v112, v123);
                    end;
                end;
            end;
        end;
    end;

    table.sort(v112, function(p124, p125) -- Line: 832
        if p124.frame == p125.frame then
            return p124.itemIndex < p125.itemIndex;
        end;

        return p124.frame < p125.frame;
    end);

    return v112;
end;

local function _stripMarkerTracksForCutscene(p126) -- Line: 846
    -- upvalues: _decodeMoonJson (copy), HttpService (copy)
    local u127 = _decodeMoonJson(p126.Value);

    if type(u127) == "table" and type(u127.Items) == "table" then
        for _, v in ipairs(u127.Items) do
            if type(v) == "table" then
                local v128 = v.Tracks or v.tracks;

                if type(v128) == "table" then
                    if v128[1] == nil then
                        for i, v2 in pairs(v128) do
                            if i == "MarkerTrack" or i == "Marker" then
                                v128[i] = nil;
                            else
                                local v129;

                                if type(v2) == "table" then
                                    local v130 = v2.Type or (v2.type or v2.TrackType or (v2.Name or v2.name));
                                    v129 = v130 == "MarkerTrack" and true or v130 == "Marker";
                                else
                                    v129 = false;
                                end;

                                if v129 then
                                    v128[i] = nil;
                                end;
                            end;
                        end;
                    else
                        for i = #v128, 1, -1 do
                            local v131 = v128[i];
                            local v132;

                            if type(v131) == "table" then
                                local v133 = v131.Type or (v131.type or v131.TrackType or (v131.Name or v131.name));
                                v132 = v133 == "MarkerTrack" and true or v133 == "Marker";
                            else
                                v132 = false;
                            end;

                            if v132 then
                                table.remove(v128, i);
                            end;
                        end;
                    end;
                end;
            end;
        end;

        local success, result = pcall(function() -- Line: 871
            -- upvalues: HttpService (ref), u127 (copy)
            return HttpService:JSONEncode(u127);
        end);

        if success and type(result) == "string" then
            p126.Value = result;
        end;
    end;

    local v134 = {};

    for _, descendant in ipairs(p126:GetDescendants()) do
        if descendant.Name == "MarkerTrack" or descendant.Name == "Marker" then
            table.insert(v134, descendant);
        end;
    end;

    for _, v in ipairs(v134) do
        v:Destroy();
    end;
end;

local function _resolveMarkerEffect(p135, p136) -- Line: 896
    if type(p136) == "string" and p136 ~= "" then
        local v137 = p135:FindFirstChild(p136) or p135:FindFirstChild(p136, true);

        if v137 then
            return v137;
        end;

        local Parent = p135.Parent;
        local v138 = Parent and (Parent:FindFirstChild(p136) or Parent:FindFirstChild(p136, true));

        if v138 then
            return v138;
        end;
    end;

    return p135;
end;

local function _bindMarkerPlan(p139, p140, p141) -- Line: 921
    -- upvalues: _decodeMoonJson (copy), _resolveCutsceneItem (copy), _resolveMarkerEffect (copy)
    local v142 = _decodeMoonJson(p141.Value);
    local v143 = {};

    for _, v in ipairs(p139) do
        local v144 = _resolveCutsceneItem(p140, v142, v.itemIndex);

        if typeof(v144) == "Instance" then
            local v145 = {
                fired = false,
                frame = v.frame,
                effect = _resolveMarkerEffect(v144, v.markerName)
            };
            table.insert(v143, v145);
        end;
    end;

    return v143;
end;

local function _startMarkerTrackDriver(u146, u147, u148, u149) -- Line: 950
    -- upvalues: PartIcles (copy), u4 (ref), RunService (copy)
    if #u146 == 0 then
        return;
    end;

    if type(PartIcles.AbsoluteEmit) == "function" then
        task.spawn(function() -- Line: 959
            -- upvalues: u148 (copy), u4 (ref), u147 (copy), u149 (ref), RunService (ref), u146 (copy), PartIcles (ref)
            if u148 ~= u4 then
                return;
            end;

            pcall(function() -- Line: 963
                -- upvalues: u147 (ref), u149 (ref)
                local v150 = tonumber(u147.FPS) or (tonumber(u147.fps) or tonumber(u147.FrameRate));

                if v150 and v150 ~= 0 then
                    u149 = math.abs(v150);
                end;
            end);
            local v151 = os.clock();

            while u148 == u4 do
                local u152 = false;
                pcall(function() -- Line: 974
                    -- upvalues: u152 (ref), u147 (ref)
                    u152 = u147:isPlaying() == true;
                end);

                if u152 or os.clock() - v151 > 2 then
                    break;
                end;

                task.wait();
            end;

            if u148 ~= u4 then
                return;
            end;

            local u153 = os.clock();
            local u154 = nil;
            u154 = RunService.RenderStepped:Connect(function() -- Line: 992
                -- upvalues: u148 (ref), u4 (ref), u154 (ref), u147 (ref), u153 (copy), u149 (ref), u146 (ref), PartIcles (ref)
                if u148 ~= u4 then
                    if u154 then
                        u154:Disconnect();
                    end;

                    return;
                end;

                local u155 = false;
                pcall(function() -- Line: 1001
                    -- upvalues: u155 (ref), u147 (ref)
                    u155 = u147:isPlaying() == true;
                end);

                if not u155 and os.clock() - u153 > 0.25 then
                    if u154 then
                        u154:Disconnect();
                    end;

                    return;
                end;

                local v156 = (os.clock() - u153) * u149;
                local u157 = math.max(0, v156);
                pcall(function() -- Line: 1012
                    -- upvalues: u147 (ref), u157 (ref), u149 (ref)
                    local v158 = nil;

                    if type(u147.getFrame) == "function" then
                        v158 = tonumber(u147:getFrame());
                    elseif type(u147.GetFrame) == "function" then
                        v158 = tonumber(u147:GetFrame());
                    elseif u147.frame == nil then
                        if u147.Frame ~= nil then
                            v158 = tonumber(u147.Frame);
                        end;
                    else
                        v158 = tonumber(u147.frame);
                    end;

                    if v158 and (v158 >= 0 and math.abs(v158 - u157) < u149 * 0.5) then
                        u157 = v158;
                    end;
                end);

                for _, v in ipairs(u146) do
                    if not v.fired and u157 + 0.001 >= v.frame then
                        v.fired = true;

                        if v.effect.Parent then
                            pcall(function() -- Line: 1032
                                -- upvalues: PartIcles (ref), v (copy)
                                PartIcles:AbsoluteEmit(v.effect);
                            end);
                        end;
                    end;
                end;
            end);
        end);

        return;
    end;

    warn("[MoonAnimator] PartIcles.AbsoluteEmit 不可用，无法驱动 MarkerTrack");
end;

local function _getPathDataFromInstance(p159) -- Line: 1047
    local v160 = p159;
    local v161 = {};
    local v162 = {};

    while p159 do
        table.insert(v161, 1, p159.Name);
        table.insert(v162, 1, p159.ClassName);
        p159 = p159.Parent;
    end;

    if #v161 > 0 and (v161[1] == "Game" or v162[1] == "DataModel") then
        v161[1] = "game";
    end;

    return {
        Path = {
            InstanceTypes = v162,
            ItemType = v160.ClassName,
            InstanceNames = v161
        }
    };
end;

local function _changeItems(u163, p164) -- Line: 1076
    -- upvalues: HttpService (copy), _getPathDataFromInstance (copy)
    if not u163:IsA("StringValue") then
        return false, "stringValue 必须是 StringValue";
    end;

    if type(p164) ~= "table" then
        return false, "newInstances 必须是 table";
    end;

    local u165 = nil;
    local success, result = pcall(function() -- Line: 1085
        -- upvalues: u165 (ref), HttpService (ref), u163 (copy)
        u165 = HttpService:JSONDecode(u163.Value);
    end);

    if not (success and u165) then
        return false, "JSON 解析失败: " .. tostring(result);
    end;

    if not u165.Information then
        u165.Information = {};
    end;

    local v166 = u165.Items or {};
    local v167 = {};

    for _, v in ipairs(p164) do
        if typeof(v) == "Instance" then
            local v168 = _getPathDataFromInstance(v);
            table.insert(v167, v168);
        end;
    end;

    for i = 1, #v167 do
        v166[i] = v167[i];
    end;

    u165.Items = v166;
    local u169 = nil;
    local success2, result2 = pcall(function() -- Line: 1109
        -- upvalues: u169 (ref), HttpService (ref), u165 (ref)
        u169 = HttpService:JSONEncode(u165);
    end);

    if not (success2 and u169) then
        return false, "JSON 编码失败: " .. tostring(result2);
    end;

    u163.Value = u169;

    return true;
end;

local function _getMaxFrameFromMoonAnimatorJson(p170) -- Line: 1125
    if not p170 then
        return nil;
    end;

    local v171 = p170.Information or {};
    local v172 = tonumber(v171.FPS) or 60;
    local v173 = tonumber(v171.Duration) or tonumber(v171.Length);

    if v173 and v173 > 0 then
        return math.floor(v173 * v172);
    end;

    local v174 = tonumber(v171.FrameCount) or tonumber(v171.TotalFrames);

    if v174 and v174 > 0 then
        return v174;
    end;

    local v175 = 0;

    for _, v in ipairs(p170.Items or {}) do
        for _, v2 in ipairs(v.Tracks or (v.tracks or {})) do
            for _, v3 in ipairs(v2.Keyframes or (v2.keyframes or v2.Frames or (v2.frames or {}))) do
                local v176 = tonumber(v3.Frame);

                if not v176 and tonumber(v3.Time) then
                    local v177 = tonumber(v3.Time) * v172;
                    v176 = math.floor(v177);
                end;

                if v176 and v175 < v176 then
                    v175 = v176;
                end;
            end;
        end;
    end;

    if v175 > 0 then
        return v175;
    end;

    return nil;
end;

local function _getAnimFirstFrameCameraCFrame(u178) -- Line: 1165
    -- upvalues: HttpService (copy)
    local u179 = nil;

    if not (pcall(function() -- Line: 1167
        -- upvalues: u179 (ref), HttpService (ref), u178 (copy)
        u179 = HttpService:JSONDecode(u178.Value);
    end) and u179) then
        return nil;
    end;

    local v180 = nil;

    for i, v in ipairs(u179.Items or {}) do
        local v181 = v.Path or v.path;

        if v181 and (v181.ItemType == "Camera" or v181.itemType == "Camera") then
            v180 = i;
            break;
        end;
    end;

    if not v180 then
        return nil;
    end;

    local v182 = u178:FindFirstChild((tostring(v180)));

    if not v182 then
        return nil;
    end;

    local CFrame = v182:FindFirstChild("CFrame");

    if not CFrame then
        return nil;
    end;

    local v183 = nil;
    local v184 = nil;

    for _, child in CFrame:GetChildren() do
        local v185 = tonumber(child.Name);

        if v185 then
            local Values = child:FindFirstChild("Values");

            if Values then
                local v186 = Values:FindFirstChild("0") or Values:GetChildren()[1];

                if v186 and (typeof(v186.Value) == "CFrame" and (v183 == nil or v185 < v183)) then
                    v184 = v186.Value;
                    v183 = v185;
                end;
            end;
        end;
    end;

    return v184;
end;

local function _applyOffsetToCFrameValues(p187, p188) -- Line: 1224
    -- upvalues: _applyOffsetToCFrameValues (copy)
    if p187.Name == "Rig" then
        return;
    end;

    for _, child in p187:GetChildren() do
        local success, result = pcall(function() -- Line: 1229
            -- upvalues: child (copy)
            return child.Value;
        end);

        if success and typeof(result) == "CFrame" then
            child.Value = p188 * result;
        end;

        if child.Name ~= "Rig" then
            _applyOffsetToCFrameValues(child, p188);
        end;
    end;
end;

local function _resolvePrefixRoot(p189, p190) -- Line: 1243
    if p189.Name == p190 then
        return p189.Parent or p189;
    end;

    local v191 = p189:FindFirstChild(p190, true);

    if v191 then
        return v191.Parent or p189;
    end;

    local v192 = p189;

    while p189 and p189 ~= game do
        if p189.Name == p190 then
            return p189.Parent or v192;
        end;

        p189 = p189.Parent;
    end;

    return v192;
end;

local function _shouldIncludeMarkerInPath(p193, p194) -- Line: 1261
    return p193:FindFirstChild(p194, true) ~= nil;
end;

local function _getPrefixFromInstance(p195) -- Line: 1265
    local v196 = {};

    while p195 and p195 ~= game do
        table.insert(v196, 1, {
            Name = p195.Name,
            ClassName = p195.ClassName
        });
        p195 = p195.Parent;
    end;

    local v197 = {};
    local v198 = {};

    for _, v in ipairs(v196) do
        table.insert(v197, v.Name);
        table.insert(v198, v.ClassName);
    end;

    if v197[1] ~= "game" then
        table.insert(v197, 1, "game");
        table.insert(v198, 1, "DataModel");
    end;

    return v197, v198;
end;

local function _findMarkerIndex(p199, p200) -- Line: 1288
    for i, v in ipairs(p199) do
        if v == p200 then
            return i;
        end;
    end;

    return nil;
end;

local function _copyArray(p201) -- Line: 1297
    local v202 = {};

    for i, v in ipairs(p201) do
        v202[i] = v;
    end;

    return v202;
end;

local function _mergePath(p203, p204, p205, p206) -- Line: 1305
    local v207 = {};

    for i, v in ipairs(p203) do
        v207[i] = v;
    end;

    local v208 = {};

    for i, v in ipairs(p204) do
        v208[i] = v;
    end;

    for i = 1, #p205 do
        table.insert(v207, p205[i]);
        table.insert(v208, p206[i] or "Instance");
    end;

    return v207, v208;
end;

local function _writePathArrays(p209, p210, p211) -- Line: 1320
    for i = 1, #p210 do
        p209.InstanceNames[i] = p210[i];
    end;

    for i = #p210 + 1, #p209.InstanceNames do
        p209.InstanceNames[i] = nil;
    end;

    if type(p209.InstanceTypes) ~= "table" then
        p209.InstanceTypes = {};
    end;

    for i = 1, #p211 do
        p209.InstanceTypes[i] = p211[i];
    end;

    for i = #p211 + 1, #p209.InstanceTypes do
        p209.InstanceTypes[i] = nil;
    end;
end;

local function _tryReplacePath(p212, p213, p214, p215, p216) -- Line: 1338
    -- upvalues: _mergePath (copy), _writePathArrays (copy)
    if type(p212) ~= "table" or type(p212.InstanceNames) ~= "table" then
        return false;
    end;

    for i, v in ipairs(p212.InstanceNames) do
        if v == p215 then
            break;
        end;
    end;

    if not i or i < 2 then
        return false;
    end;

    if not p216 then
        local i = i + 1;
    end;

    if #p212.InstanceNames < i then
        return false;
    end;

    local InstanceTypes = p212.InstanceTypes;
    local v217 = {};
    local v218 = {};

    for i = i, #p212.InstanceNames do
        table.insert(v217, p212.InstanceNames[i]);
        table.insert(v218, InstanceTypes and (InstanceTypes[i] or "Instance") or "Instance");
    end;

    local v219, v220 = _mergePath(p213, p214, v217, v218);
    _writePathArrays(p212, v219, v220);

    return true;
end;

local function _forEachPathTable(p221, p222, p223) -- Line: 1368
    -- upvalues: _forEachPathTable (copy)
    if type(p221) ~= "table" then
        return;
    end;

    local v224 = p223 or {};

    if v224[p221] then
        return;
    end;

    v224[p221] = true;

    if type(p221.InstanceNames) == "table" then
        p222(p221);
    end;

    if type(p221.Path) == "table" then
        _forEachPathTable(p221.Path, p222, v224);
    end;

    for _, v in pairs(p221) do
        if type(v) == "table" then
            _forEachPathTable(v, p222, v224);
        end;
    end;
end;

local function _replacePathsInData(p225, p226, u227, u228) -- Line: 1390
    -- upvalues: _resolvePrefixRoot (copy), _getPrefixFromInstance (copy), _forEachPathTable (copy), _tryReplacePath (copy)
    local u229, u230 = _getPrefixFromInstance((_resolvePrefixRoot(p226, u227)));
    local u231 = 0;
    _forEachPathTable(p225, function(p232) -- Line: 1399
        -- upvalues: _tryReplacePath (ref), u229 (copy), u230 (copy), u227 (copy), u228 (copy), u231 (ref)
        if _tryReplacePath(p232, u229, u230, u227, u228) then
            u231 = u231 + 1;
        end;
    end);

    return u231;
end;

local function _buildNamesPrefixChunk(p233, p234, p235) -- Line: 1407
    -- upvalues: HttpService (copy)
    local v236 = {};

    for _, v in ipairs(p233) do
        table.insert(v236, HttpService:JSONEncode(v));
    end;

    if p235 then
        table.insert(v236, HttpService:JSONEncode(p234));
    end;

    return table.concat(v236, ",");
end;

local function _replacePathsInJsonString(p237, p238, p239, p240, p241) -- Line: 1418
    -- upvalues: HttpService (copy), _buildNamesPrefixChunk (copy)
    local v242 = HttpService:JSONEncode(p240);
    local v243 = _buildNamesPrefixChunk(p238, p240, p241);
    local v244 = {};
    local v245 = 0;

    for _, v in ipairs(p239) do
        table.insert(v244, HttpService:JSONEncode(v));
    end;

    local v246 = table.concat(v244, ",");
    local v247, v248 = string.gsub(p237, "(\"InstanceNames\":%[)\"game\",\"Workspace\",.-," .. v242 .. ",([^%]]*)%]", "%1" .. v243 .. "%2]");

    if v248 > 0 then
        v245 = v245 + v248;
    else
        v247 = p237;
    end;

    local v249;

    if p241 then
        v249 = v247;
    else
        local v250;
        v249, v250 = string.gsub(v247, "\"game\",\"Workspace\",\"场景\"," .. v242, _buildNamesPrefixChunk(p238, p240, false));

        if v250 > 0 then
            v245 = v245 + v250;
        else
            v249 = v247;
        end;
    end;

    local v251;

    if p241 then
        local v252, v253 = string.gsub(v249, "\"InstanceTypes\":%[\"DataModel\",\"Workspace\",.-,\"Model\",\"Folder\",\"Model\"", "\"InstanceTypes\":[" .. v246 .. ",\"Model\",\"Folder\",\"Model\"");

        if v253 > 0 then
            v245 = v245 + v253;
        else
            v252 = v249;
        end;

        local v254;
        v251, v254 = string.gsub(v252, "\"InstanceTypes\":%[\"DataModel\",\"Workspace\",.-,\"Folder\",\"Part\"", "\"InstanceTypes\":[" .. v246 .. ",\"Folder\",\"Part\"");

        if v254 > 0 then
            v245 = v245 + v254;
        else
            v251 = v252;
        end;
    else
        local v255, v256 = string.gsub(v249, "\"InstanceTypes\":%[\"DataModel\",\"Workspace\",.-,\"Model\",\"Folder\",\"Model\"", "\"InstanceTypes\":[" .. v246 .. ",\"Folder\",\"Model\"");

        if v256 > 0 then
            v245 = v245 + v256;
        else
            v255 = v249;
        end;

        local v257;
        v251, v257 = string.gsub(v255, "\"InstanceTypes\":%[\"DataModel\",\"Workspace\",.-,\"Model\",\"Folder\",\"Part\"", "\"InstanceTypes\":[" .. v246 .. ",\"Folder\",\"Part\"");

        if v257 > 0 then
            v245 = v245 + v257;
        else
            v251 = v255;
        end;
    end;

    return v251, v245;
end;

function u1.PlayMoonAnimator(u258, p259, u260) -- Line: 1508
    -- upvalues: _requireCutscene (copy), ReplicatedStorage (copy), _changeItems (copy), _extractMarkerPlan (copy), _stripMarkerTracksForCutscene (copy), Workspace (copy), u5 (ref), u4 (ref), u3 (ref), u6 (ref), _decodeMoonJson (copy), _bindMarkerPlan (copy), _collectEnabledTracks (copy), _applyEnabledValue (copy), _sampleEnabledAtFrame (copy), RunService (copy), _startMarkerTrackDriver (copy)
    if type(u258) ~= "string" or u258 == "" then
        warn("[MoonAnimator] 动画名称不能为空");

        return false;
    end;

    local v261 = _requireCutscene();

    if not v261 then
        return false;
    end;

    local MoonAnimator2Saves = ReplicatedStorage:FindFirstChild("MoonAnimator2Saves");
    local u262;

    if MoonAnimator2Saves then
        u262 = MoonAnimator2Saves:FindFirstChild(u258);

        if not (u262 and u262:IsA("StringValue")) then
            u262 = nil;
        end;
    else
        u262 = nil;
    end;

    if not u262 then
        warn("[MoonAnimator] 没找到动画", u258);

        return false;
    end;

    if p259 then
        local v263, v264 = _changeItems(u262, p259);

        if not v263 then
            warn("[MoonAnimator] ChangeItems 失败:", v264);
        end;
    end;

    local v265 = _extractMarkerPlan(u262);
    _stripMarkerTracksForCutscene(u262);
    local u266 = v261.new(u262, Workspace, true);
    local v267, v268 = u266:canFindObjects();

    if not v267 then
        warn("[MoonAnimator] Missing object:", v268);
    end;

    u266:waitForObjects();
    u5 = true;
    u4 = u4 + 1;
    local u269 = u3;
    u3 = nil;

    if u269 then
        pcall(function() -- Line: 1553
            -- upvalues: u269 (copy)
            u269:stop();
        end);
    end;

    local v270 = u6;

    if v270 and v270 ~= u262 then
        u6 = nil;

        if v270.Parent then
            v270:Destroy();
        end;
    end;

    u4 = u4 + 1;
    local u271 = u4;
    u5 = false;
    u3 = u266;
    local v272 = _decodeMoonJson(u262.Value);
    local v273;

    if type(v272) == "table" and type(v272.Information) == "table" then
        local v274 = tonumber(v272.Information.FPS) or tonumber(v272.Information.Fps);
        v273 = (not v274 or v274 <= 0) and 60 or v274;
    else
        v273 = 60;
    end;

    local v275 = _bindMarkerPlan(v265, u266, u262);
    u266:play();
    local u276 = v273;
    task.spawn(function() -- Line: 524
        -- upvalues: u271 (copy), u4 (ref), u266 (copy), u276 (ref), _collectEnabledTracks (ref), u262 (copy), _applyEnabledValue (ref), _sampleEnabledAtFrame (ref), RunService (ref)
        if u271 ~= u4 then
            return;
        end;

        pcall(function() -- Line: 530
            -- upvalues: u266 (ref), u276 (ref)
            local v277 = tonumber(u266.FPS) or (tonumber(u266.fps) or tonumber(u266.FrameRate));

            if v277 and v277 ~= 0 then
                u276 = math.abs(v277);
            end;
        end);
        task.wait();

        if u271 ~= u4 then
            return;
        end;

        local u278 = _collectEnabledTracks(u262, u266);

        if #u278 == 0 then
            return;
        end;

        for _, v in ipairs(u278) do
            v.lastApplied = nil;
            _applyEnabledValue(v, false);
        end;

        local v279 = os.clock();
        local v280 = false;

        while u271 == u4 do
            local u281 = false;
            pcall(function() -- Line: 558
                -- upvalues: u281 (ref), u266 (ref)
                u281 = u266:isPlaying() == true;
            end);

            if u281 then
                v280 = true;
                break;
            end;

            if os.clock() - v279 > 2 then
                break;
            end;

            task.wait();
        end;

        if u271 ~= u4 then
            return;
        end;

        local u282 = os.clock();

        for _, v in ipairs(u278) do
            v.lastApplied = nil;
            _applyEnabledValue(v, (_sampleEnabledAtFrame(v.keyframes, 0)));
        end;

        local u283 = nil;
        u283 = RunService.RenderStepped:Connect(function() -- Line: 586
            -- upvalues: u271 (ref), u4 (ref), u283 (ref), u262 (ref), u266 (ref), u282 (copy), u276 (ref), u278 (copy), _applyEnabledValue (ref), _sampleEnabledAtFrame (ref)
            if u271 ~= u4 then
                if u283 then
                    u283:Disconnect();
                end;

                return;
            end;

            if not u262.Parent then
                if u283 then
                    u283:Disconnect();
                end;

                return;
            end;

            local u284 = false;
            pcall(function() -- Line: 601
                -- upvalues: u284 (ref), u266 (ref)
                u284 = u266:isPlaying() == true;
            end);

            if not u284 and os.clock() - u282 > 0.25 then
                if u283 then
                    u283:Disconnect();
                end;

                return;
            end;

            local v285 = (os.clock() - u282) * u276;
            local u286 = math.max(0, v285);
            pcall(function() -- Line: 614
                -- upvalues: u266 (ref), u286 (ref), u276 (ref)
                local v287 = nil;

                if type(u266.getFrame) == "function" then
                    v287 = tonumber(u266:getFrame());
                elseif type(u266.GetFrame) == "function" then
                    v287 = tonumber(u266:GetFrame());
                elseif u266.frame == nil then
                    if u266.Frame ~= nil then
                        v287 = tonumber(u266.Frame);
                    end;
                else
                    v287 = tonumber(u266.frame);
                end;

                if v287 and (v287 >= 0 and math.abs(v287 - u286) < u276 * 0.5) then
                    u286 = v287;
                end;
            end);

            for _, v in ipairs(u278) do
                if v.target.Parent then
                    _applyEnabledValue(v, (_sampleEnabledAtFrame(v.keyframes, u286)));
                end;
            end;
        end);
    end);
    _startMarkerTrackDriver(v275, u266, u271, v273);
    task.spawn(function() -- Line: 1577
        -- upvalues: u271 (copy), u4 (ref), u262 (copy), u258 (copy), u266 (copy), u5 (ref), u3 (ref), u260 (copy)
        local v288 = os.clock();
        local v289 = false;
        local v290 = nil;

        while u271 == u4 do
            task.wait();

            if not u262.Parent then
                warn("[MoonAnimator] 过场资源已销毁，中止等待:", u258);
                break;
            end;

            local u291 = false;
            pcall(function() -- Line: 1590
                -- upvalues: u291 (ref), u266 (ref)
                u291 = u266:isPlaying() == true;
            end);

            if u291 then
                v289 = true;
                v290 = nil;
            elseif v289 then
                if v290 == nil then
                    v290 = os.clock();
                elseif os.clock() - v290 >= 0.25 then
                    break;
                end;
            elseif os.clock() - v288 > 2 then
                warn("[MoonAnimator] 过场未进入播放状态:", u258);
                break;
            end;
        end;

        if u3 == u266 then
            u3 = nil;
        end;

        pcall(function() -- Line: 1612
            -- upvalues: u266 (ref)
            u266:stop();
        end);

        if not (u5 or u271 ~= u4) and u260 then
            u260();
        end;
    end);

    return true;
end;

function u1.StopActiveMoonAnimator() -- Line: 1627
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), u6 (ref)
    u5 = true;
    u4 = u4 + 1;
    local u292 = u3;
    u3 = nil;

    if u292 then
        pcall(function() -- Line: 1633
            -- upvalues: u292 (copy)
            u292:stop();
        end);
    end;

    local v293 = u6;
    u6 = nil;

    if v293 and v293.Parent then
        v293:Destroy();
    end;

    return nil;
end;

function u1.PlayMoonAnimatorWithCameraOffset(p294, p295, u296) -- Line: 1653
    -- upvalues: ReplicatedStorage (copy), Workspace (copy), _getAnimFirstFrameCameraCFrame (copy), u1 (copy), _applyOffsetToCFrameValues (copy), u6 (ref)
    local MoonAnimator2Saves = ReplicatedStorage:FindFirstChild("MoonAnimator2Saves");
    local v297;

    if MoonAnimator2Saves then
        v297 = MoonAnimator2Saves:FindFirstChild(p294);

        if not (v297 and v297:IsA("StringValue")) then
            v297 = nil;
        end;
    else
        v297 = nil;
    end;

    if not v297 then
        warn("[MoonAnimator] PlayMoonAnimatorWithCameraOffset: 未找到动画", p294);

        return nil;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        warn("[MoonAnimator] PlayMoonAnimatorWithCameraOffset: 无摄像机");

        return nil;
    end;

    local v298 = _getAnimFirstFrameCameraCFrame(v297);

    if not v298 then
        warn("[MoonAnimator] 未找到摄像机首帧，回退无偏移播放");

        return u1.PlayMoonAnimator(p294, p295, u296);
    end;

    local v299 = CurrentCamera.CFrame * v298:Inverse();
    local MoonAnimator2Saves2 = ReplicatedStorage:FindFirstChild("MoonAnimator2Saves");

    if not MoonAnimator2Saves2 then
        return u1.PlayMoonAnimator(p294, p295, u296);
    end;

    local u300 = v297:Clone();
    u300.Name = p294 .. "_offset_" .. tostring(os.clock());
    u300.Parent = MoonAnimator2Saves2;
    _applyOffsetToCFrameValues(u300, v299);
    local v301 = u1.PlayMoonAnimator(u300.Name, p295, function() -- Line: 1687
        -- upvalues: u6 (ref), u300 (copy), u296 (copy)
        if u6 == u300 then
            u6 = nil;
        end;

        if u300.Parent then
            u300:Destroy();
        end;

        if u296 then
            u296();
        end;
    end);

    if v301 then
        u6 = u300;

        return v301;
    end;

    if u300.Parent then
        u300:Destroy();
    end;

    return v301;
end;

function u1.GetMoonAnimatorStartEndPositions(p302, u303) -- Line: 1716
    -- upvalues: _requireCutscene (copy), ReplicatedStorage (copy), _changeItems (copy), _decodeMoonJson (copy), _getMaxFrameFromMoonAnimatorJson (copy), Workspace (copy)
    local v304 = _requireCutscene();

    if not v304 then
        return nil;
    end;

    local MoonAnimator2Saves = ReplicatedStorage:FindFirstChild("MoonAnimator2Saves");
    local u305;

    if MoonAnimator2Saves then
        u305 = MoonAnimator2Saves:FindFirstChild(p302);

        if not (u305 and u305:IsA("StringValue")) then
            u305 = nil;
        end;
    else
        u305 = nil;
    end;

    if not u305 then
        warn("[MoonAnimator] GetStartEndPositions: 未找到动画", p302);

        return nil;
    end;

    if not u303 or #u303 < 1 then
        warn("[MoonAnimator] GetStartEndPositions: 需要 pathReplacements");

        return nil;
    end;

    local success, result = pcall(function() -- Line: 1732
        -- upvalues: _changeItems (ref), u305 (copy), u303 (copy)
        _changeItems(u305, u303);
    end);

    if not success then
        warn("[MoonAnimator] GetStartEndPositions: ChangeItems 失败", result);

        return nil;
    end;

    local u306 = _getMaxFrameFromMoonAnimatorJson((_decodeMoonJson(u305.Value))) or 0;
    local u307 = v304.new(u305, Workspace, true);
    local v308, v309 = u307:canFindObjects();

    if not v308 then
        warn("[MoonAnimator] GetStartEndPositions: 找不到对象", v309);

        return nil;
    end;

    u307:waitForObjects();
    local u310 = u303[1];

    if not (u310 and u310.Parent) then
        warn("[MoonAnimator] GetStartEndPositions: 模型无效");

        return nil;
    end;

    local function getPivot() -- Line: 1757
        -- upvalues: u310 (copy)
        if u310:IsA("Model") then
            return u310:GetPivot();
        end;

        if u310:IsA("BasePart") then
            return u310.CFrame;
        end;

        return nil;
    end;

    pcall(function() -- Line: 1767
        -- upvalues: u307 (copy)
        if type(u307.setFrame) == "function" then
            u307:setFrame(0);
        end;
    end);
    local v311;

    if u310:IsA("Model") then
        v311 = u310:GetPivot();
    elseif u310:IsA("BasePart") then
        v311 = u310.CFrame;
    else
        v311 = nil;
    end;

    local v312;

    if u306 > 0 then
        pcall(function() -- Line: 1776
            -- upvalues: u307 (copy), u306 (copy)
            if type(u307.setFrame) == "function" then
                u307:setFrame(u306);
            end;
        end);
        local v313;

        if u310:IsA("Model") then
            v313 = u310:GetPivot();
        elseif u310:IsA("BasePart") then
            v313 = u310.CFrame;
        else
            v313 = nil;
        end;

        v312 = v313 or v311;
    else
        v312 = v311;
    end;

    pcall(function() -- Line: 1784
        -- upvalues: u307 (copy)
        if type(u307.setFrame) == "function" then
            u307:setFrame(0);
        end;

        u307:stop();
    end);

    return {
        startCFrame = v311,
        endCFrame = v312
    };
end;

function u1.ChangeRootFolder(p314, p315, p316) -- Line: 1805
    -- upvalues: ReplicatedStorage (copy), u2 (copy), _resolvePrefixRoot (copy), _getPrefixFromInstance (copy), _decodeMoonJson (copy), _forEachPathTable (copy), _tryReplacePath (copy), HttpService (copy), _replacePathsInJsonString (copy)
    if type(p314) ~= "string" or p314 == "" then
        warn("[MoonAnimator] ChangeRootFolder: 动画名为空");

        return;
    end;

    if typeof(p315) ~= "Instance" then
        warn("[MoonAnimator] ChangeRootFolder: rootFolder 无效");

        return;
    end;

    local MoonAnimator2Saves = ReplicatedStorage:FindFirstChild("MoonAnimator2Saves");
    local v317;

    if MoonAnimator2Saves then
        v317 = MoonAnimator2Saves:FindFirstChild(p314);

        if not (v317 and v317:IsA("StringValue")) then
            v317 = nil;
        end;
    else
        v317 = nil;
    end;

    if not v317 then
        warn("[MoonAnimator] 没找到动画", p314);

        return;
    end;

    local Value = v317.Value;

    if Value == "" then
        warn("[MoonAnimator] 动画内容为空", p314);

        return;
    end;

    local u318 = u2[p314] or (p316 or "炼药场景");
    u2[p314] = p315.Name;
    local v319 = _resolvePrefixRoot(p315, u318);
    local v320, v321 = _getPrefixFromInstance(v319);
    local u322 = v319:FindFirstChild(u318, true) ~= nil;
    local v323 = _decodeMoonJson(Value);

    if v323 then
        local u324, u325 = _getPrefixFromInstance((_resolvePrefixRoot(p315, u318)));
        local u326 = 0;
        _forEachPathTable(v323, function(p327) -- Line: 1399
            -- upvalues: _tryReplacePath (ref), u324 (copy), u325 (copy), u318 (copy), u322 (copy), u326 (ref)
            if _tryReplacePath(p327, u324, u325, u318, u322) then
                u326 = u326 + 1;
            end;
        end);

        if u326 > 0 then
            v317.Value = HttpService:JSONEncode(v323);

            return;
        end;
    end;

    local v328, v329 = _replacePathsInJsonString(Value, v320, v321, u318, u322);

    if v329 > 0 then
        v317.Value = v328;

        return;
    end;

    warn("[MoonAnimator] ChangeRootFolder 未替换任何路径", p314, "marker=", u318, "新前缀=", table.concat(v320, "/"), "includeMarker=", u322, "prefixRoot=", v319:GetFullName());
end;

return u1;