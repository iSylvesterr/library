-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local transforms = require(script.transforms);
local MoonUtil = require(script.MoonUtil);
local TaskManager = require(script.TaskManager);
local Effects = script.Effects;
u1.subtitle = require(Effects.subtitle);
u1.vignette = require(Effects.vignette);
u1.fade = require(Effects.fade);
u1.letterbox = require(Effects.letterbox);

function u1.new(p2, p3, p4) -- Line: 73
    -- upvalues: u1 (copy), TaskManager (copy)
    local v5 = setmetatable({}, u1);
    v5.instance = p2;
    v5.file = game:GetService("HttpService"):JSONDecode(p2.Value);
    v5.FPS = v5.file.Information.FPS or 60;
    v5.instances = {};
    v5.objs = {};
    v5.timeElapsed = 0;
    v5.objsComputed = false;
    v5.attachConnections = {};
    v5.task = TaskManager.new();

    if p3 and not p4 then
        p3 = p3:Clone() or p3;
    end;

    v5.map = p3;

    return v5;
end;

local function computeObjects(p6) -- Line: 95
    -- upvalues: u1 (copy)
    p6.objs = {};

    for _, child in p6.instance:GetChildren() do
        u1.addObj(p6, child);
    end;

    p6.objsComputed = true;

    return p6.objs;
end;

local function setPlaying(p7, p8) -- Line: 111
    p7.playing = p8 == true;
    workspace:SetAttribute("cutscene", p8 and p7.instance.Name or nil);
end;

function u1.play(u9, p10) -- Line: 121
    -- upvalues: computeObjects (copy), u1 (copy)
    if p10 then
        u9.task:clone();
        computeObjects(u9);
        u9.timeElapsed = 0;
    elseif not u9.objsComputed then
        computeObjects(u9);
    end;

    local _ = u9.map;

    if not u9.task.cloned then
        u9.task:clone();
    end;

    game:GetService("RunService"):BindToRenderStep("cutscene_play", Enum.RenderPriority.Camera.Value + 1, function(p11) -- Line: 142
        -- upvalues: u9 (copy), u1 (ref)
        local v12 = u9;
        v12.timeElapsed = v12.timeElapsed + p11 * u9.FPS;

        for i, v in u9.task.cloned do
            if tonumber(i) and i <= u9.timeElapsed then
                u9.task.run(v);
                u9.task.cloned[i] = nil;
            end;
        end;

        if u1.setFrame(u9, u9.timeElapsed) then
            u9.task.run(u9.task.cloned[true]);
            u9:stop();
        end;
    end);
    u9.playing = true;
    workspace:SetAttribute("cutscene", u9.instance.Name or nil);
end;

function u1.wait(p13) -- Line: 169
    if p13.playing then
        local u14 = coroutine.running();
        p13.task:onEnd(function() -- Line: 175
            -- upvalues: u14 (copy)
            coroutine.resume(u14);
        end, true);

        return coroutine.yield();
    end;
end;

function u1.stop(p15) -- Line: 186
    if p15.playing then
        game:GetService("RunService"):UnbindFromRenderStep("cutscene_play");
        p15.playing = false;
        workspace:SetAttribute("cutscene", nil);

        if p15.attachConnections then
            for _, v in p15.attachConnections do
                if v and v.Connected then
                    v:Disconnect();
                end;
            end;

            p15.attachConnections = {};
        end;
    end;
end;

function u1.isPlaying(p16) -- Line: 208
    return p16.playing;
end;

function u1.canFindObjects(p17) -- Line: 217
    -- upvalues: MoonUtil (copy)
    for _, v in p17.file.Items do
        if not MoonUtil.getObjectFromPath(v.Path, p17.map) then
            return false, v;
        end;
    end;

    return true;
end;

function u1.waitForObjects(p18) -- Line: 231
    if not p18:canFindObjects() then
        repeat
            task.wait();
        until p18:canFindObjects();
    end;
end;

local u19 = { "MarkerTrack" };
local u20 = { "_RigContainer_collapsed", "_PropertyContainer_collapsed" };

function u1.addObj(p21, p22) -- Line: 247
    -- upvalues: MoonUtil (copy), u20 (copy), u19 (copy), transforms (copy)
    local v23 = tonumber(p22.Name);
    p21.objs[v23] = {};
    p21.instances[v23] = p21.instances[v23] or MoonUtil.getObjectFromPath(p21.file.Items[v23].Path, p21.map);

    local function getEasingData(p24) -- Line: 257
        local v25;

        if p24:FindFirstChild("Eases") then
            v25 = {};
            local v26 = p24:FindFirstChild("Eases") and p24.Eases["0"].Type.Value;
            v25[1] = v26;

            if p24.Eases["0"]:FindFirstChild("Params") then
                v25[2] = p24.Eases["0"].Params.Direction.Value;
            end;
        else
            v25 = nil;
        end;

        return v25;
    end;

    for _, child in p22:GetChildren() do
        if not table.find(u20, child.Name) then
            if table.find(u19, child.Name) then
                warn(child, "is unsupported");
            elseif child.Name == "Rig" then
                p21.objs[v23].Rig = {};

                for _, child2 in child:GetChildren() do
                    if #child2._keyframes:GetChildren() == 0 then
                        print(child2);
                    else
                        local v27 = MoonUtil.getMotor(p21.instances[v23], child2._hier.Value);

                        if v27 then
                            local v28 = #child2._hier.Value:split(".");
                            p21.objs[v23].Rig[v28] = p21.objs[v23].Rig[v28] or {};
                            p21.objs[v23].Rig[v28][child2._hier.Value] = {
                                default = child2.default.Value,
                                joint = v27
                            };

                            for _, child3 in child2._keyframes:GetChildren() do
                                local v29 = tonumber(child3.Name);

                                if v29 then
                                    local v30 = getEasingData(child3);

                                    for _, child4 in child3.Values:GetChildren() do
                                        local v31 = tonumber(child4.Name);

                                        if v31 then
                                            p21.objs[v23].Rig[v28][child2._hier.Value][v29 + v31] = { v30, child4.Value };
                                        end;
                                    end;
                                end;
                            end;
                        else
                            print("Missing joint");
                            print("index:", v23);
                            print("path:", child2._hier.Value);
                        end;
                    end;
                end;
            else
                local v32 = child.default:GetChildren()[1];
                local v33 = p21.objs[v23];
                local Name = child.Name;
                local v34 = {
                    default = child.default.Value
                };

                if v32 then
                    v32 = transforms.Wrappers[v32.Name];
                end;

                v34.wrapper = v32;
                v33[Name] = v34;

                if #child:GetChildren() ~= 0 then
                    for _, child2 in child:GetChildren() do
                        local v35 = tonumber(child2.Name);

                        if v35 then
                            local v36 = getEasingData(child2);

                            for _, child3 in child2.Values:GetChildren() do
                                local v37 = tonumber(child3.Name);

                                if v37 then
                                    p21.objs[v23][child.Name][v35 + v37] = { v36, child3.Value };
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function u1.replace(p38, p39, p40) -- Line: 361
    p38.instances[p39] = p40;
end;

local function isEmpty(p41) -- Line: 370
    local v42, v43, v44;
    v42, v43, v44 = p41, nil, nil;
    local v45, v46, v47;

    if type(v42) == "function" then
        v45, v46 = v42(v43, v47);
    else
        v45, v46 = next(v42, v47);
    end;

    v47 = v45;

    return false;
end;

function u1.reset(p48) -- Line: 382
    -- upvalues: computeObjects (copy), MoonUtil (copy)
    computeObjects(p48);
    local v49 = MoonUtil.getKeyFrames(p48);

    for i, v in v49.Rig do
        i.C1 = v.default;
    end;

    for i, v in v49.Properties do
        i[v[1]] = v[2].default;
    end;
end;

function u1.setFrame(u50, p51) -- Line: 403
    -- upvalues: computeObjects (copy), transforms (copy), MoonUtil (copy)
    if not u50.objsComputed then
        computeObjects(u50);
    end;

    for i, v in u50.objs do
        for i2, v2 in v do
            if i2 == "Rig" then
                for i3, v3 in v2 do
                    for i4, v4 in v3 do
                        local function set(p52, p53, p54) -- Line: 421
                            -- upvalues: transforms (ref), v4 (copy)
                            if not (p54 and p54[2]) then
                                return;
                            end;

                            transforms.C1(v4.joint, p54[2], p53 and p53[2] or v4.default, p52);
                        end;

                        local v55, v56, v57, v58, v59 = MoonUtil.getFrames(p51, v4);

                        if v58 then
                            local v60;

                            if v56 then
                                v60 = v56[1];
                            else
                                v60 = v56;
                            end;

                            local v61 = MoonUtil.getEase(v60)((math.min((p51 - (v57 or 0)) / (v59 - (v57 or 0)), 1)));

                            if v58 then
                                if v58[2] then
                                    transforms.C1(v4.joint, v58[2], v56 and v56[2] or v4.default, v61);
                                end;
                            end;
                        else
                            local v62 = v4[v55[#v55 - 1]];
                            local v63 = v4[v55[#v55]];

                            if v63 and v63[2] then
                                transforms.C1(v4.joint, v63[2], v62 and v62[2] or v4.default, 1);
                            end;

                            u50.objs[i][i2][i3][i4] = nil;
                            local v64;

                            for _, _ in u50.objs[i][i2][i3] do
                                v64 = false;
                                break;
                            end;

                            v64 = true;

                            if v64 then
                                u50.objs[i][i2][i3] = nil;
                                local v65;

                                for _, _ in u50.objs[i][i2] do
                                    v65 = false;
                                    break;
                                end;

                                v65 = true;

                                if v65 then
                                    u50.objs[i][i2] = nil;
                                    local v66;

                                    for _, _ in u50.objs[i] do
                                        v66 = false;
                                        break;
                                    end;

                                    v66 = true;

                                    if v66 then
                                        u50.objs[i] = nil;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            else
                local function v71(p67, p68, p69) -- Line: 473
                    -- upvalues: transforms (ref), i2 (copy), v2 (copy), u50 (copy), i (copy)
                    if type(p69) ~= "table" or p69[2] == nil then
                        return;
                    end;

                    if not transforms[i2] then
                        warn("invalid property", i2);

                        return;
                    end;

                    local v70 = type(p68) == "table" and p68[2] or v2.default;

                    if v2.wrapper then
                        transforms[i2](u50.instances[i], v2.wrapper(p69[2], v70, p67), nil, nil, nil, u50);

                        return;
                    end;

                    transforms[i2](u50.instances[i], p69[2], v70, p67, u50);
                end;

                local v72, v73, v74, v75, v76 = MoonUtil.getFrames(p51, v2);

                if v75 then
                    if v74 and (not v2.lF or v2.lF ~= v74) then
                        local v77 = nil;

                        for i3, v3 in ipairs(v72) do
                            if v3 == v74 then
                                if i3 > 1 then
                                    v77 = v2[v72[i3 - 1]];
                                end;

                                break;
                            end;
                        end;

                        v71(1, v77, v73);
                    end;

                    local v78;

                    if v73 then
                        v78 = v73[1];
                    else
                        v78 = v73;
                    end;

                    local v79 = MoonUtil.getEase(v78)((math.clamp((p51 - (v74 or 0)) / (v76 - (v74 or 0)), 0, 1)));
                    v2.lF = v79 == 1 and v76 and v76 or v74;
                    v71(v79, v73, v75);
                else
                    local v80 = v2[v72[#v72 - 1]];
                    local v81 = v2[v72[#v72]];
                    v2.lF = v76;
                    v71(1, v80, v81);
                    u50.objs[i][i2] = nil;
                    local v82;

                    for _, _ in u50.objs[i] do
                        v82 = false;
                        break;
                    end;

                    v82 = true;

                    if v82 then
                        u50.objs[i] = nil;
                    end;
                end;
            end;
        end;
    end;

    local v83;

    for _, _ in u50.objs do
        v83 = false;
        break;
    end;

    v83 = true;

    return v83 and true or false;
end;

return u1;