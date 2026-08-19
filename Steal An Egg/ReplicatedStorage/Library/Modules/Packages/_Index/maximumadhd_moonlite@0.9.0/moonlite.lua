-- Decompiled with Potassium's decompiler.

local v1 = {};
require(script.Types);
local Specials = require(script.Specials);
local EaseFuncs = require(script.EaseFuncs);
local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");

if RunService:IsServer() then
    warn("Moonlite should NOT be used on the server! Rig transforms will not be replicated.");
end;

local u2 = {};
u2.__index = u2;
local u3 = {
    Instance = true,
    boolean = true,
    string = true,
    ["nil"] = true
};
local u4 = {};

local function lerp(p5, p6, p7) -- Line: 84
    if type(p5) ~= "number" then
        return p5:Lerp(p6, p7);
    end;

    local v8 = type(p6) == "number";
    local v9 = "lerp: Expected b to be a number, got " .. type(p6);
    assert(v8, v9);

    return p5 + (p6 - p5) * p7;
end;

local function toPath(p10) -- Line: 93
    return table.concat(p10.InstanceNames, ".");
end;

local function resolveAnimPath(u11, p12) -- Line: 97
    if not u11 then
        return nil;
    end;

    local u13 = #u11.InstanceNames;
    local u14 = p12 or game;

    if pcall(function() -- Line: 105
        -- upvalues: u13 (copy), u11 (copy), u14 (ref)
        for i = 2, u13 do
            local v15 = u11.InstanceNames[i];
            local v16 = u11.InstanceTypes[i];
            local v17 = u14[v15];
            local v18 = typeof(v17) == "Instance";
            local v19 = "resolveAnimPath: Expected " .. v15 .. " to be an Instance, got " .. typeof(v17);
            assert(v18, v19);
            assert(v17.ClassName == v16, "resolveAnimPath: Expected instance of class " .. v16 .. " but got " .. v17.ClassName);
            u14 = v17;
        end;
    end) then
        return u14;
    end;

    warn("!! PATH RESOLVE FAILED:", table.concat(u11.InstanceNames, "."));

    return nil;
end;

local function resolveJoints(p20) -- Line: 131
    local v21 = {};

    for _, descendant in p20:GetDescendants() do
        if descendant:IsA("Motor6D") and descendant.Active then
            local Part1 = descendant.Part1;

            if Part1 then
                Part1 = Part1.Name;
            end;

            if Part1 then
                v21[Part1] = {
                    Name = Part1,
                    Joint = descendant,
                    Children = {}
                };
            end;
        end;
    end;

    for i, v in v21 do
        local Part0 = v.Joint.Part0;

        if Part0 then
            local v22 = v21[Part0.Name];

            if v22 then
                v22.Children[i] = v;
                v.Parent = v22;
            end;
        end;
    end;

    return v21;
end;

local function parseEase(p23) -- Line: 169
    local Type = p23:FindFirstChild("Type");
    local Params = p23:FindFirstChild("Params");
    local v24 = {};
    local v25;

    if Type and Type:IsA("StringValue") then
        v25 = Type.Value;
    else
        v25 = nil;
    end;

    v24.Type = assert(v25, "");
    v24.Params = {};

    if Params then
        for _, child in Params:GetChildren() do
            if child:IsA("ValueBase") then
                v24.Params[child.Name] = child.Value;
            end;
        end;
    end;

    return v24;
end;

local function parseEaseOld(p26) -- Line: 193
    local Style = p26:FindFirstChild("Style");
    local v27;

    if Style then
        v27 = Style:IsA("StringValue");
    else
        v27 = Style;
    end;

    assert(v27, "parseEaseOld: No style in legacy ease!");
    local Direction = p26:FindFirstChild("Direction");
    local v28;

    if Direction then
        v28 = Direction:IsA("StringValue");
    else
        v28 = Direction;
    end;

    assert(v28, "parseEaseOld: No direction in legacy ease!");

    return {
        Type = Style.Value,
        Params = {
            Direction = Direction.Value
        }
    };
end;

local function readValue(p29) -- Line: 208
    if not p29:IsA("ValueBase") then
        return p29:GetAttribute("Value");
    end;

    local v30;

    if tonumber(p29.Name) then
        v30 = assert(p29.Parent, "readValue: Expected a parent for numbered value");
    else
        v30 = p29;
    end;

    local Value = p29.Value;
    local EnumType = v30:FindFirstChild("EnumType");

    if EnumType and EnumType:IsA("StringValue") then
        return Enum[EnumType.Value][Value];
    end;

    if v30:FindFirstChild("Vector2") then
        return Vector2.new(Value.X, Value.Y);
    end;

    if v30:FindFirstChild("ColorSequence") then
        return ColorSequence.new(Value);
    end;

    if v30:FindFirstChild("NumberSequence") then
        return NumberSequence.new(Value);
    end;

    if v30:FindFirstChild("NumberRange") then
        Value = NumberRange.new(Value);
    end;

    return Value;
end;

local function getPropValue(p31, u32, u33) -- Line: 236
    -- upvalues: Specials (copy)
    local v34 = u32 and Specials.Get(p31._scratch, u32, u33);

    if not v34 then
        return pcall(function() -- Line: 251
            -- upvalues: u32 (copy), u33 (copy)
            return u32[u33];
        end);
    end;

    local Get = v34.Get;

    if Get then
        return pcall(Get, u32);
    end;

    return true, v34.Default;
end;

local function setPropValue(p35, u36, u37, u38, p39) -- Line: 256
    -- upvalues: Specials (copy)
    local v40 = u36 and Specials.Get(p35._scratch, u36, u37);

    if not v40 then
        return pcall(function() -- Line: 273
            -- upvalues: u36 (copy), u37 (copy), u38 (ref)
            u36[u37] = u38;
        end);
    end;

    if v40.Get == nil and (p39 and u38 == true) then
        u38 = false;
    end;

    return pcall(v40.Set, u38);
end;

local function parseKeyframePack(p41) -- Line: 278
    -- upvalues: readValue (copy), parseEase (copy), parseEaseOld (copy)
    local v42 = tonumber(p41.Name);
    assert(v42, "parseKeyframePack: Bad frame number");
    local Values = p41:FindFirstChild("Values");
    assert(Values, "parseKeyframePack: No value folder!");
    local v43 = Values:FindFirstChild("0");
    assert(v43, "parseKeyframePack: No starting value!");
    local v44 = {};
    local v45 = 0;

    for _, child in Values:GetChildren() do
        local v46 = tonumber(child.Name);

        if v46 then
            local success, result = pcall(readValue, child);

            if success then
                v44[v46] = result;
                v45 = math.max(v46, v45);
            end;
        end;
    end;

    local Eases = p41:FindFirstChild("Eases");
    local Ease = p41:FindFirstChild("Ease");
    local v47 = {};

    if Eases then
        for _, child in Eases:GetChildren() do
            local v48 = tonumber(child.Name);
            local v49 = "parseKeyframePack: Bad index on ease at " .. child:GetFullName();
            assert(v48, v49);
            v47[v48] = parseEase(child);
        end;
    elseif Ease then
        v47[v45] = parseEaseOld(Ease);
    end;

    return {
        FrameIndex = v42,
        FrameCount = v45,
        Values = v44,
        Eases = v47
    };
end;

local function unpackKeyframes(p50, p51) -- Line: 328
    -- upvalues: parseKeyframePack (copy)
    local v52 = {};
    local v53 = {};
    local v54 = {};

    for _, child in p50:GetChildren() do
        local v55 = tonumber(child.Name);

        if v55 then
            v52[v55] = parseKeyframePack(child);
            table.insert(v53, v55);
        end;
    end;

    table.sort(v53);

    for i = 2, #v53 do
        local v56 = v52[v53[i - 1]];
        local v57 = v52[v53[i]];
        v56.Next = v57;
        v57.Prev = v56;
    end;

    local v58 = v52[v53[1]];

    while v58 do
        local FrameIndex = v58.FrameIndex;
        local v59 = nil;

        for i = 0, v58.FrameCount do
            local v60 = v58.Eases[i] or v59;
            local v61 = v58.Values[i];

            if v61 ~= nil then
                if p51 then
                    v61 = p51(v61);
                end;

                table.insert(v54, {
                    Time = FrameIndex + i,
                    Value = v61,
                    Ease = v60
                });

                if v60 then
                    v59 = v60;
                end;
            end;
        end;

        v58 = v58.Next;
    end;

    return v54;
end;

local function readValueBase(p62, p63) -- Line: 386
    local v64 = p62:FindFirstChild(p63);
    local v65;

    if v64 then
        v65 = v64:IsA("ValueBase");
    else
        v65 = v64;
    end;

    local v66 = "readValueBase: Expected a ValueBase named " .. p63 .. " in " .. p62:GetFullName();
    assert(v65, v66);

    return v64.Value;
end;

local function compileItem(p67, p68, p69) -- Line: 395
    -- upvalues: resolveAnimPath (copy), resolveJoints (copy), readValue (copy), unpackKeyframes (copy), Specials (copy)
    local v70 = table.find(p67._data.Items, p68);

    if not v70 then
        return;
    end;

    local Path = p68.Path;
    local ItemType = Path.ItemType;
    local v71 = p68.Override or resolveAnimPath(Path, p67._root);
    local v72 = p67._save:FindFirstChild((tostring(v70)));
    local v73 = "compileItem: Target instance not found for path: " .. table.concat(Path.InstanceNames, ".");
    assert(v71, v73);
    local v74 = "compileItem: Frame not found for item with id " .. tostring(v70);
    assert(v72, v74);
    local Rig = v72:FindFirstChild("Rig");
    local MarkerTrack = v72:FindFirstChild("MarkerTrack");

    if Rig and ItemType == "Rig" then
        local v75 = resolveJoints(v71);

        for _, child in Rig:GetChildren() do
            if child.Name == "_joint" then
                local _hier = child:FindFirstChild("_hier");
                local default = child:FindFirstChild("default");
                local _keyframes = child:FindFirstChild("_keyframes");

                if default then
                    default = readValue(default);
                end;

                if _hier and _keyframes then
                    local v76 = readValue(_hier);
                    local v77 = v76:gmatch("[^%.]+");
                    local v78 = v75[v77()];

                    while v78 do
                        local Children = v78.Children;
                        local v79 = v77();

                        if v79 == nil then
                            break;
                        end;

                        if Children[v79] then
                            v78 = Children[v79];
                        else
                            warn((`failed to resolve joint '{v76}' (could not find child '{v79}' in {v78.Name}!)`));
                            v78 = nil;
                        end;
                    end;

                    if v78 then
                        local Joint = v78.Joint;
                        p69[Joint] = {
                            Props = {
                                Transform = {
                                    Static = false,
                                    Default = CFrame.identity,
                                    Sequence = unpackKeyframes(_keyframes, function(p80) -- Line: 458
                                        -- upvalues: default (ref)
                                        return p80:Inverse() * default;
                                    end)
                                }
                            },
                            Target = Joint
                        };
                    end;
                end;
            end;
        end;
    end;

    local v81 = {};

    for _, child in v72:GetChildren() do
        if child:IsA("Folder") and (child ~= MarkerTrack and child.Name ~= "Rig") then
            local default = child:FindFirstChild("default");
            local Name = child.Name;

            if default then
                default = readValue(default);
            end;

            v81[Name] = {
                Default = default,
                Static = Specials.Static(v71, Name),
                Sequence = unpackKeyframes(child)
            };
        end;
    end;

    p69[v71] = {
        Props = v81,
        Target = v71
    };

    if MarkerTrack then
        local v82 = {};
        p67._markers[v71] = v82;

        for _, child in MarkerTrack:GetChildren() do
            if child:FindFirstChild("name") then
                local v83 = tonumber(child.Name);
                local v84 = assert(v83, "compileItem: Expected marker name to be a number");
                local width = child:FindFirstChild("width");
                local v85;

                if width then
                    v85 = width:IsA("ValueBase");
                else
                    v85 = width;
                end;

                local v86 = "readValueBase: Expected a ValueBase named " .. "width" .. " in " .. child:GetFullName();
                assert(v85, v86);
                local Value = width.Value;
                local name = child:FindFirstChild("name");
                local v87;

                if name then
                    v87 = name:IsA("ValueBase");
                else
                    v87 = name;
                end;

                local v88 = "readValueBase: Expected a ValueBase named " .. "name" .. " in " .. child:GetFullName();
                assert(v87, v88);
                local Value2 = name.Value;
                local v89 = {};
                local KFMarkers = child:FindFirstChild("KFMarkers");

                if KFMarkers then
                    for _, child2 in KFMarkers:GetChildren() do
                        if child2:IsA("ValueBase") then
                            local Value3 = child2.Value;
                            local Val = child2:FindFirstChild("Val");
                            local v90;

                            if Val then
                                v90 = Val:IsA("ValueBase");
                            else
                                v90 = Val;
                            end;

                            local v91 = "readValueBase: Expected a ValueBase named " .. "Val" .. " in " .. child2:GetFullName();
                            assert(v90, v91);
                            v89[Value3] = Val.Value;
                        end;
                    end;
                end;

                local v92 = v82[v84];

                if not v92 then
                    v92 = {
                        StartMarkers = {},
                        EndMarkers = {}
                    };
                    v82[v84] = v92;
                end;

                if Value > 0 then
                    local v93 = math.min(v84 + Value, p67.Frames);
                    local v94 = v82[v93];

                    if not v94 then
                        v94 = {
                            StartMarkers = {},
                            EndMarkers = {}
                        };
                        v82[v93] = v94;
                    end;

                    v94.EndMarkers[Value2] = v89;
                end;

                v92.StartMarkers[Value2] = v89;
            end;
        end;
    end;
end;

local function getInterpolator(p95) -- Line: 556
    -- upvalues: u3 (copy), lerp (copy)
    return typeof(p95) == "ColorSequence" and function(p96, p97, p98) -- Line: 558
        local Value = p96.Keypoints[1].Value;
        local Value2 = p97.Keypoints[1].Value;
        local v99;

        if type(Value) == "number" then
            local v100 = type(Value2) == "number";
            local v101 = "lerp: Expected b to be a number, got " .. type(Value2);
            assert(v100, v101);
            v99 = Value + (Value2 - Value) * p98;
        else
            v99 = Value:Lerp(Value2, p98);
        end;

        return ColorSequence.new(v99);
    end or (typeof(p95) == "NumberSequence" and function(p102, p103, p104) -- Line: 563
        local Value = p102.Keypoints[1].Value;
        local Value2 = p103.Keypoints[1].Value;
        local v105;

        if type(Value) == "number" then
            local v106 = type(Value2) == "number";
            local v107 = "lerp: Expected b to be a number, got " .. type(Value2);
            assert(v106, v107);
            v105 = Value + (Value2 - Value) * p104;
        else
            v105 = Value:Lerp(Value2, p104);
        end;

        return NumberSequence.new(v105);
    end or (typeof(p95) == "NumberRange" and function(p108, p109, p110) -- Line: 568
        local Min = p108.Min;
        local Min2 = p109.Min;
        local v111;

        if type(Min) == "number" then
            local v112 = type(Min2) == "number";
            local v113 = "lerp: Expected b to be a number, got " .. type(Min2);
            assert(v112, v113);
            v111 = Min + (Min2 - Min) * p110;
        else
            v111 = Min:Lerp(Min2, p110);
        end;

        return NumberRange.new(v111);
    end or (u3[typeof(p95)] and function(p114, p115, p116) -- Line: 573
        if p116 >= 1 then
            return p115;
        end;

        return p114;
    end or lerp)));
end;

local function compileFrames(p117, p118) -- Line: 585
    -- upvalues: getInterpolator (copy), EaseFuncs (copy)
    local _buffer = p117._buffer;

    for i, v in p118 do
        local v119 = {};
        _buffer[i] = v119;

        for i2, v2 in v.Props do
            if v2.Sequence[1] then
                local Default = v2.Default;
                local v120 = getInterpolator(v2.Sequence[1].Value);
                local v121 = nil;
                local v122 = 0;

                for _, v3 in v2.Sequence do
                    if not v119[v3.Time] then
                        v119[v3.Time] = {};
                    end;

                    local v123 = v3.Time - v122;
                    v119[v3.Time][i2] = v3.Value;

                    if v123 <= 1 then
                        Default = v3.Value;
                        v121 = v3.Ease;
                        v122 = v3.Time;
                    else
                        if not v2.Static then
                            local v124 = EaseFuncs.Get(v121);

                            for i3 = 0, v123 do
                                local v125 = v124(i3 / v123);
                                local v126 = v122 + i3;

                                if not v119[v126] then
                                    v119[v126] = {};
                                end;

                                v119[v126][i2] = v120(Default, v3.Value, v125);
                            end;
                        end;

                        v121 = v3.Ease;
                        Default = v3.Value;
                        v122 = v3.Time;
                    end;
                end;

                if not v2.Static and v122 < p117.Frames then
                    local v127 = v119[v122][i2];

                    for i3 = v122, p117.FrameRate do
                        if not v119[i3] then
                            v119[i3] = {};
                        end;

                        v119[i3][i2] = v127;
                    end;
                end;
            end;
        end;
    end;
end;

local function compileRouting(p128) -- Line: 652
    -- upvalues: compileItem (copy), compileFrames (copy)
    table.clear(p128._buffer);
    table.clear(p128._elements);
    table.clear(p128._markers);
    local v129 = {};

    for _, v in p128._data.Items do
        compileItem(p128, v, v129);
    end;

    compileFrames(p128, v129);
    p128._compiled = true;
end;

local function restoreTrack(p130) -- Line: 667
    -- upvalues: u4 (copy), setPropValue (copy)
    local v131 = u4[p130];

    if not v131 then
        return;
    end;

    if p130.RestoreDefaults then
        for i, v in v131 do
            for i2, v2 in v do
                setPropValue(p130, i, i2, v2);
            end;
        end;
    end;

    u4[p130] = nil;
end;

local function stepTrack(p132, p133) -- Line: 685
    -- upvalues: setPropValue (copy)
    local v134 = math.floor(p132.TimePosition * p132.FrameRate);
    local v135 = math.min(p133, 1 / p132.FrameRate);

    if p132.Frames < v134 then
        if not p132.Looped then
            p132._completed:Fire(Enum.PlaybackState.Completed);

            return true;
        end;

        p132.TimePosition = 0;
        v134 = 0;
    end;

    for i, v in p132._buffer do
        if p132._locks[i] == nil then
            local v136 = v[v134];

            if v136 then
                for i2, v2 in v136 do
                    setPropValue(p132, i, i2, v2);
                end;
            end;
        end;
    end;

    for i, v in p132._markers do
        local v137 = v[v134];

        if v137 then
            for i2, v2 in v137.StartMarkers do
                if p132._markerSignals[i2] then
                    p132._markerSignals[i2]:Fire(i, v2);
                end;
            end;

            for i2, v2 in v137.EndMarkers do
                if p132._endMarkerSignals[i2] then
                    p132._endMarkerSignals[i2]:Fire(i, v2);
                end;
            end;
        end;
    end;

    p132.TimePosition = p132.TimePosition + v135;

    return false;
end;

function v1.CreatePlayer(p138, p139) -- Line: 738
    -- upvalues: HttpService (copy), u2 (copy), compileRouting (copy)
    local v140 = HttpService:JSONDecode(p138.Value);
    local BindableEvent = Instance.new("BindableEvent");
    local v141 = setmetatable({
        RestoreDefaults = true,
        TimePosition = 0,
        _compiled = false,
        Completed = BindableEvent.Event,
        Looped = v140.Information.Looped,
        Frames = v140.Information.Length,
        FrameRate = v140.Information.FPS or 60,
        _save = p138,
        _data = v140,
        _completed = BindableEvent,
        _markers = {},
        _markerSignals = {},
        _endMarkerSignals = {},
        _locks = {},
        _elements = {},
        _buffer = {},
        _scratch = {},
        _root = p139
    }, u2);
    compileRouting(v141);

    return v141;
end;

function u2.Destroy(p142) -- Line: 772
    for _, v in p142._markerSignals do
        v:Destroy();
    end;

    for _, v in p142._endMarkerSignals do
        v:Destroy();
    end;

    p142._completed:Destroy();
    table.clear(p142._markerSignals);
    table.clear(p142._endMarkerSignals);
end;

function u2.IsPlaying(p143) -- Line: 786
    -- upvalues: u4 (copy)
    return u4[p143] ~= nil;
end;

function u2.GetTimeLength(p144) -- Line: 790
    return p144.Frames / p144.FrameRate;
end;

function u2.GetMarkerReachedSignal(p145, p146) -- Line: 794
    if not p145._markerSignals[p146] then
        p145._markerSignals[p146] = Instance.new("BindableEvent");
    end;

    return p145._markerSignals[p146].Event;
end;

function u2.GetMarkerEndedSignal(p147, p148) -- Line: 802
    if not p147._endMarkerSignals[p148] then
        p147._endMarkerSignals[p148] = Instance.new("BindableEvent");
    end;

    return p147._endMarkerSignals[p148].Event;
end;

function u2.GetSetting(p149, p150) -- Line: 810
    return p149._scratch[p150];
end;

function u2.SetSetting(p151, p152, p153) -- Line: 814
    p151._scratch[p152] = p153;
end;

function u2.GetElements(p154) -- Line: 818
    return table.clone(p154._elements);
end;

function u2.LockElement(p155, p156, p157) -- Line: 822
    if not p155._locks[p156] then
        p155._locks[p156] = {};
    end;

    if p157 then
        p155._locks[p156][p157 or "Default"] = true;
    end;

    return true;
end;

function u2.UnlockElement(p158, p159, p160) -- Line: 834
    local v161 = p158._locks[p159];

    if v161 then
        v161[p160 or "Default"] = nil;

        if not next(v161) then
            p158._locks[p159] = nil;
        end;
    end;

    return true;
end;

function u2.IsElementLocked(p162, p163) -- Line: 848
    return p162._locks[p163] ~= nil;
end;

function u2.ReplaceElementByPath(p164, p165, p166) -- Line: 852
    -- upvalues: compileRouting (copy)
    for _, v in p164._data.Items do
        local Path = v.Path;
        local v167 = table.concat(Path.InstanceNames, ".");

        if p165:lower() == v167:lower() and (Path.ItemType == "Rig" or p166:IsA(Path.ItemType)) then
            v.Override = p166;
            compileRouting(p164);

            return true;
        end;
    end;

    return false;
end;

function u2.FindElement(p168, p169) -- Line: 872
    for _, v in p168._elements do
        if v and v.Name == p169 then
            return v;
        end;
    end;

    return nil;
end;

function u2.FindElementOfType(p170, p171) -- Line: 882
    for _, v in p170._elements do
        if v and v:IsA(p171) then
            return v;
        end;
    end;

    return nil;
end;

function u2.Stop(p172) -- Line: 892
    -- upvalues: restoreTrack (copy)
    p172.TimePosition = 0;
    task.spawn(restoreTrack, p172);
    p172._completed:Fire(Enum.PlaybackState.Cancelled);
end;

function u2.Reset(p173) -- Line: 898
    -- upvalues: stepTrack (copy)
    p173.TimePosition = 0;
    stepTrack(p173, 0);

    return true;
end;

function u2.Play(p174) -- Line: 905
    -- upvalues: u4 (copy), getPropValue (copy)
    if u4[p174] then
        return;
    end;

    if p174.TimePosition >= p174:GetTimeLength() then
        p174.TimePosition = 0;
    end;

    local v175 = {};

    for i, v in p174._buffer do
        if v[0] then
            local v176 = {};
            v175[i] = v176;

            for i2 in v[0] do
                local v177, v178 = getPropValue(p174, i, i2);

                if v177 then
                    v176[i2] = v178;
                end;
            end;
        end;
    end;

    u4[p174] = v175;
    p174._completed:Fire(Enum.PlaybackState.Playing);
end;

RunService:BindToRenderStep("__UPDATE_MOONLITE_TRACKS", Enum.RenderPriority.Camera.Value + 1, function(p179) -- Line: 935
    -- upvalues: u4 (copy), stepTrack (copy), restoreTrack (copy)
    for i in u4 do
        if stepTrack(i, p179) then
            restoreTrack(i);
        end;
    end;
end);

return v1;