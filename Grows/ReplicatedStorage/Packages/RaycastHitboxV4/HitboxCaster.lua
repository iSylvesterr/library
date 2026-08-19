-- Decompiled with Potassium's decompiler.

local Heartbeat = game:GetService("RunService").Heartbeat;
local CollectionService = game:GetService("CollectionService");
local VisualizerCache = require(script.Parent.VisualizerCache);
local u1 = {};
local Solvers = script.Parent:WaitForChild("Solvers");
local u2 = {};
u2.__index = u2;
u2.__type = "RaycastHitbox";
u2.CastModes = {
    LinkAttachments = 1,
    Attachment = 2,
    Vector3 = 3,
    Bone = 4
};

function u2.HitStart(p3, p4) -- Line: 54
    if p3.HitboxActive then
        p3:HitStop();
    end;

    if p4 then
        p3.HitboxStopTime = os.clock() + math.max(0.016666666666666666, p4);
    end;

    p3.HitboxActive = true;
end;

function u2.HitStop(p5) -- Line: 68
    p5.HitboxActive = false;
    p5.HitboxStopTime = 0;
    table.clear(p5.HitboxHitList);
end;

function u2.Destroy(p6) -- Line: 75
    -- upvalues: CollectionService (copy)
    p6.HitboxPendingRemoval = true;

    if p6.HitboxObject then
        CollectionService:RemoveTag(p6.HitboxObject, p6.Tag);
    end;

    p6:HitStop();
    p6.OnHit:Destroy();
    p6.OnUpdate:Destroy();
end;

function u2.Recalibrate(p7) -- Line: 88
    -- upvalues: u2 (copy)
    local v8 = p7.HitboxObject:GetDescendants();
    local v9 = 0;

    for _, v in ipairs(v8) do
        if v:IsA("Attachment") and v.Name == "DmgPoint" then
            local v10 = p7:_CreatePoint(v:GetAttribute("Group"), u2.CastModes.Attachment, v.WorldPosition);
            table.insert(v10.Instances, v);
            table.insert(p7.HitboxRaycastPoints, v10);
            v9 = v9 + 1;
        end;
    end;

    if p7.DebugLog then
        print(string.format("%s%s", "[ Raycast Hitbox V4 ]\n", v9 > 0 and string.format("%s attachments found in object: %s.", v9, p7.HitboxObject.Name) or string.format("No attachments found in object: %s. Can be safely ignored if using SetPoints.", p7.HitboxObject.Name)));
    end;
end;

function u2.LinkAttachments(p11, p12, p13) -- Line: 117
    -- upvalues: u2 (copy)
    local v14 = p11:_CreatePoint(p12:GetAttribute("Group"), u2.CastModes.LinkAttachments);
    v14.Instances[1] = p12;
    v14.Instances[2] = p13;
    table.insert(p11.HitboxRaycastPoints, v14);
end;

function u2.UnlinkAttachments(p15, p16) -- Line: 128
    for i = #p15.HitboxRaycastPoints, 1, -1 do
        if #p15.HitboxRaycastPoints[i].Instances >= 2 and (p15.HitboxRaycastPoints[i].Instances[1] == p16 or p15.HitboxRaycastPoints[i].Instances[2] == p16) then
            table.remove(p15.HitboxRaycastPoints, i);
        end;
    end;
end;

function u2.SetPoints(p17, p18, p19, p20) -- Line: 142
    -- upvalues: u2 (copy)
    for _, v in ipairs(p19) do
        local v21 = p17:_CreatePoint(p20, u2.CastModes[p18:IsA("Bone") and "Bone" or "Vector3"]);
        v21.Instances[1] = p18;
        v21.Instances[2] = v;
        table.insert(p17.HitboxRaycastPoints, v21);
    end;
end;

function u2.RemovePoints(p22, p23, p24) -- Line: 155
    for i = #p22.HitboxRaycastPoints, 1, -1 do
        if p22.HitboxRaycastPoints[i].Instances[1] == p23 then
            local v25 = p22.HitboxRaycastPoints[i].Instances[2];

            for _, v in ipairs(p24) do
                if v == v25 then
                    table.remove(p22.HitboxRaycastPoints, i);
                    break;
                end;
            end;
        end;
    end;
end;

function u2._CreatePoint(p26, p27, p28, p29) -- Line: 176
    return {
        WorldSpace = nil,
        Group = p27,
        CastMode = p28,
        LastPosition = p29,
        Instances = {}
    };
end;

function u2._FindHitbox(p30, p31) -- Line: 188
    -- upvalues: u1 (copy)
    for _, v in ipairs(u1) do
        if v.HitboxObject == p31 then
            return v;
        end;
    end;
end;

function u2._Init(u32) -- Line: 198
    -- upvalues: u1 (copy), CollectionService (copy)
    if not u32.HitboxObject then
        return;
    end;

    local u33 = nil;

    local function onTagRemoved(p34) -- Line: 203
        -- upvalues: u32 (copy), u33 (ref)
        if p34 == u32.HitboxObject then
            u33:Disconnect();
            u32:Destroy();
        end;
    end;

    u32:Recalibrate();
    table.insert(u1, u32);
    CollectionService:AddTag(u32.HitboxObject, u32.Tag);
    u33 = CollectionService:GetInstanceRemovedSignal(u32.Tag):Connect(onTagRemoved);
end;

(function() -- Line: 217, Name: Init
    -- upvalues: Solvers (copy), Heartbeat (copy), u1 (copy), VisualizerCache (copy), u2 (copy)
    local u35 = table.create(#Solvers:GetChildren());
    Heartbeat:Connect(function(p36) -- Line: 221
        -- upvalues: u1 (ref), u35 (copy), VisualizerCache (ref)
        for i = #u1, 1, -1 do
            if u1[i].HitboxPendingRemoval then
                local v37 = table.remove(u1, i);
                setmetatable(v37, nil);
            else
                for _, v in ipairs(u1[i].HitboxRaycastPoints) do
                    if u1[i].HitboxActive then
                        local v38 = u35[v.CastMode];
                        local v39, v40 = v38:Solve(v);
                        local v41 = workspace:Raycast(v39, v40, u1[i].RaycastParams);
                        local v42 = u1[i].Visualizer and VisualizerCache:GetAdornment();

                        if v42 then
                            local v43 = v38:Visualize(v);
                            v42.Adornment.Length = v40.Magnitude;
                            v42.Adornment.CFrame = v43;
                        end;

                        v.LastPosition = v38:UpdateToNextPosition(v);

                        if v41 then
                            local Instance = v41.Instance;
                            local v44 = nil;
                            local v45;

                            if u1[i].DetectionMode == 1 then
                                local v46 = Instance:FindFirstAncestorOfClass("Model");

                                if v46 then
                                    v44 = v46:FindFirstChildOfClass("Humanoid");
                                end;

                                v45 = v44;
                            else
                                v45 = v44;
                                v44 = Instance;
                            end;

                            if not v44 then
                                if u1[i].HitboxStopTime > 0 and u1[i].HitboxStopTime <= os.clock() then
                                    u1[i].HitboxStopTime = 0;
                                    u1[i]:HitStop();
                                end;

                                u1[i].OnUpdate:Fire(v.LastPosition);
                            end;

                            if u1[i].DetectionMode > 2 then
                                u1[i].OnHit:Fire(Instance, v45, v41, v.Group);

                                if u1[i].HitboxStopTime > 0 and u1[i].HitboxStopTime <= os.clock() then
                                    u1[i].HitboxStopTime = 0;
                                    u1[i]:HitStop();
                                end;

                                u1[i].OnUpdate:Fire(v.LastPosition);
                            end;

                            if not u1[i].HitboxHitList[v44] then
                                u1[i].HitboxHitList[v44] = true;
                                u1[i].OnHit:Fire(Instance, v45, v41, v.Group);

                                if u1[i].HitboxStopTime > 0 and u1[i].HitboxStopTime <= os.clock() then
                                    u1[i].HitboxStopTime = 0;
                                    u1[i]:HitStop();
                                end;

                                u1[i].OnUpdate:Fire(v.LastPosition);
                            end;
                        else
                            if u1[i].HitboxStopTime > 0 and u1[i].HitboxStopTime <= os.clock() then
                                u1[i].HitboxStopTime = 0;
                                u1[i]:HitStop();
                            end;

                            u1[i].OnUpdate:Fire(v.LastPosition);
                        end;
                    else
                        v.LastPosition = nil;
                    end;
                end;
            end;
        end;

        local v47 = #VisualizerCache._AdornmentInUse;

        if v47 > 0 then
            for i = v47, 1, -1 do
                if os.clock() - VisualizerCache._AdornmentInUse[i].LastUse >= 0.25 then
                    local v48 = table.remove(VisualizerCache._AdornmentInUse, i);

                    if v48 then
                        VisualizerCache:ReturnAdornment(v48);
                    end;
                end;
            end;
        end;
    end);

    for i, v in pairs(u2.CastModes) do
        local v49 = Solvers:FindFirstChild(i);

        if v49 then
            u35[v] = require(v49);
        end;
    end;
end)();

return u2;