-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Components = script:WaitForChild("Components");
local Dependencies = script:WaitForChild("Dependencies");
local ImOverlay = require(Dependencies:WaitForChild("Debug"):WaitForChild("ImOverlay"));
local Config = require(Dependencies:WaitForChild("Config"));
local Frustum = require(Dependencies:WaitForChild("Frustum"));
local Utilities = require(Dependencies:WaitForChild("Utilities"));
local u1 = nil;
local Bone = require(Components:WaitForChild("Bone"));
local BoneTree = require(Components:WaitForChild("BoneTree"));
local ColliderObject = require(Components:WaitForChild("Collision"):WaitForChild("ColliderObject"));
local Runtime = Dependencies:WaitForChild("Runtime");

local function CopyPasteAttributes(p2, p3) -- Line: 22
    for i, v in p2:GetAttributes() do
        p3:SetAttribute(i, v);
    end;
end;

local SB_INDENT_LOG = Utilities.SB_INDENT_LOG;
local SB_UNINDENT_LOG = Utilities.SB_UNINDENT_LOG;
local SB_VERBOSE_LOG = Utilities.SB_VERBOSE_LOG;
local SB_VERBOSE_WARN = Utilities.SB_VERBOSE_WARN;
local u4 = {};
u4.__index = u4;

function u4.new() -- Line: 73
    -- upvalues: HttpService (copy), u4 (copy)
    local v5 = {
        ShouldDestroy = false,
        ID = HttpService:GenerateGUID(false),
        BoneTrees = {},
        ColliderObjects = {}
    };

    return setmetatable(v5, u4);
end;

function u4.m_AppendBone(p6, p7, p8, p9, p10) -- Line: 96
    -- upvalues: Utilities (copy), Bone (copy), SB_VERBOSE_LOG (copy)
    local v11 = Utilities.GatherBoneSettings(p8);
    local v12 = Bone.new(p8, p7.Root, p7.RootPart);

    for i, v in v11 do
        if v == "¬" or not v then
            local v = nil;
        end;

        v12[i] = v;
    end;

    local v13 = p7.Bones[p9];

    if p9 > 0 then
        local Magnitude = (v13.Position - v12.Position).Magnitude;
        v12.FreeLength = Magnitude;
        v12.Weight = Magnitude * 0.7;
        v12.HeirarchyLength = p10;
        v13.HasChild = true;
    end;

    if p10 <= p7.Settings.AnchorDepth then
        SB_VERBOSE_LOG("Anchoring bone");
        v12.Anchored = true;
    end;

    v12.ParentIndex = p9;
    table.insert(p7.Bones, v12);
end;

function u4.m_CreateBoneTree(u14, p15, p16) -- Line: 135
    -- upvalues: BoneTree (copy), Utilities (copy), SB_VERBOSE_LOG (copy), SB_INDENT_LOG (copy), SB_UNINDENT_LOG (copy)
    local u17 = BoneTree.new(p16, p15, Utilities.GatherObjectSettings(p15));
    SB_VERBOSE_LOG((`Creating bone tree {p15.Name}; {p16.Name}`));
    SB_INDENT_LOG();

    local function AddChildren(p18, p19, p20) -- Line: 141
        -- upvalues: SB_VERBOSE_LOG (ref), SB_INDENT_LOG (ref), u14 (copy), u17 (copy), AddChildren (copy), SB_UNINDENT_LOG (ref)
        SB_VERBOSE_LOG((`Adding bone: {p18.Name}; {p19}; {p20}`));
        SB_INDENT_LOG();
        local v21 = false;

        for _, child in p18:GetChildren() do
            if child:IsA("Bone") then
                u14:m_AppendBone(u17, child, p19, p20);
                AddChildren(child, #u17.Bones, p20 + 1);
                v21 = true;
            end;
        end;

        if string.sub(p18.Name, #p18.Name - 3, #p18.Name) ~= "_end" and string.sub(p18.Name, #p18.Name - 4, #p18.Name) ~= "_Tail" and not v21 then
            SB_VERBOSE_LOG("Adding tail bone");
            local Parent = p18.Parent;
            local v22 = Parent:IsA("Bone") and Parent.WorldPosition or Parent.Position;
            local v23 = p18.WorldCFrame + p18.WorldCFrame.UpVector.Unit * (p18.WorldPosition - v22).Magnitude;
            local Bone2 = Instance.new("Bone");
            Bone2.Parent = p18;
            Bone2.Name = p18.Name .. "_Tail";
            Bone2.WorldCFrame = v23;

            for i, v in p18:GetAttributes() do
                Bone2:SetAttribute(i, v);
            end;

            u14:m_AppendBone(u17, Bone2, #u17.Bones, p20);
        end;

        SB_UNINDENT_LOG();
    end;

    u14:m_AppendBone(u17, p16, 0, 0);
    AddChildren(p16, 1, 1);
    table.insert(u14.BoneTrees, u17);
    SB_UNINDENT_LOG();
end;

function u4.m_UpdateViewFrustum(p24) -- Line: 194
    -- upvalues: Config (copy), Frustum (copy)
    if shared.FrameCounter % Config.FRUSTUM_FREQ ~= 0 then
        return;
    end;

    local v25, v26, v27, v28, v29, v30, v31, v32, v33 = Frustum.GetCFrames(workspace.CurrentCamera, Config.FAR_PLANE);

    for _, v in p24.BoneTrees do
        v.InView = Frustum.ObjectInFrustum({
            CFrame = v.BoundingBoxCFrame,
            Size = v.BoundingBoxSize
        }, v25, v26, v27, v28, v29, v30, v31, v32, v33);
    end;
end;

function u4.m_CleanColliders(p34) -- Line: 215
    -- upvalues: SB_VERBOSE_WARN (copy), SB_INDENT_LOG (copy), SB_UNINDENT_LOG (copy)
    local v35 = false;

    if #p34.ColliderObjects ~= 0 then
        for i, v in p34.ColliderObjects do
            if #v.Colliders == 0 or v.Destroyed == true then
                SB_VERBOSE_WARN("Deleting Collider Object");
                SB_INDENT_LOG();
                v:Destroy();
                SB_UNINDENT_LOG();
                table.remove(p34.ColliderObjects, i);
                v35 = true;
            end;
        end;
    end;
end;

function u4.m_UpdateBoneTree(p36, p37, p38, p39) -- Line: 247
    -- upvalues: SB_VERBOSE_LOG (copy)
    if p37.Destroyed then
        p37:Destroy();
        table.remove(p36.BoneTrees, p38);

        return;
    end;

    p37:PreUpdate(p39);

    if not p37.InView or (math.floor(p37.UpdateRate) == 0 or not p37.InWorkspace) then
        local IsSkippingUpdates = p37.IsSkippingUpdates;
        p37:SkipUpdate();

        if not IsSkippingUpdates then
            task.synchronize();
            p37:ApplyTransform();
            SB_VERBOSE_LOG((`Skipping BoneTree, InView: {p37.InView}, Update Rate == 0: {math.floor(p37.UpdateRate) == 0}, InWorkspace: {p37.InWorkspace}`));
        end;

        return;
    end;

    for _, v in p36.ColliderObjects do
        v:Step();
    end;

    local v40 = 1 / p37.UpdateRate;
    p37.AccumulatedDelta = p37.AccumulatedDelta + p39;
    local v41 = false;

    while v40 < p37.AccumulatedDelta do
        p37.AccumulatedDelta = p37.AccumulatedDelta - v40;
        p37:StepPhysics(v40);
        p37:Constrain(p36.ColliderObjects, v40);
        p37:SolveTransform(v40);
        v41 = true;
    end;

    if v41 then
        task.synchronize();
        p37:ApplyTransform();
    end;
end;

function u4.m_CheckDestroy(p42) -- Line: 312
    p42.ShouldDestroy = false;

    if #p42.BoneTrees ~= 0 then
        return false;
    end;

    p42.ShouldDestroy = true;

    return true;
end;

function u4.LoadObject(p43, p44) -- Line: 328
    local v45 = p44:GetAttribute("Roots");

    if not v45 then
        warn((`[SmartBone2::LoadObject] Cannot load an object with no roots defined {p44.Name}`));

        return;
    end;

    local v46 = v45:split(",");
    local v47 = {};

    for _, v in p44:QueryDescendants("Bone") do
        if v47[v.Name] then
            warn((`[SmartBone2::LoadObject] Duplicate bones of name: {v.Name} in RootPart: {p44.Name}`));
        else
            v47[v.Name] = v;
        end;
    end;

    for _, v in v46 do
        local v48 = v47[v];

        if v48 then
            p43:m_CreateBoneTree(p44, v48);
        else
            warn((`[SmartBone2::LoadObject] Couldn't find Root Bone of name: {v} in RootPart: {p44.Name}`));
        end;
    end;
end;

function u4.LoadColliderModule(p49, p50, p51) -- Line: 365
    -- upvalues: HttpService (copy), ColliderObject (copy)
    assert(p50, "[SmartBone2::LoadColliderModule] No collider module passed in");
    local v52 = HttpService:JSONDecode((require(p50)));
    local v53 = ColliderObject.new(v52, p51);
    table.insert(p49.ColliderObjects, v53);
end;

function u4.LoadRawCollider(p54, p55, p56) -- Line: 380
    -- upvalues: ColliderObject (copy)
    local v57 = ColliderObject.new(p55, p56);
    table.insert(p54.ColliderObjects, v57);
end;

function u4.SkipUpdate(p58) -- Line: 388
    for _, v in p58.BoneTrees do
        v:SkipUpdate();
    end;
end;

function u4.StepBoneTrees(p59, p60) -- Line: 399
    -- upvalues: SB_VERBOSE_WARN (copy)
    if p59:m_CheckDestroy() then
        return;
    end;

    if p60 <= 0 then
        SB_VERBOSE_WARN("DeltaTime is zero or sub zero, not updating.");

        return;
    end;

    p59:m_CleanColliders();
    p59:m_UpdateViewFrustum();

    for i, v in p59.BoneTrees do
        p59:m_UpdateBoneTree(v, i, p60);
    end;
end;

function u4.DrawDebug(p61, p62, p63, p64, p65, p66, p67, p68, p69, p70, p71, p72, p73, p74) -- Line: 432
    for _, v in p61.BoneTrees do
        v:DrawDebug(p63, p64, p65, p66, p67, p72, p73, p74);
    end;

    if p62 then
        for _, v in p61.ColliderObjects do
            v:DrawDebug(p68, p69, p70, p71);
        end;
    end;
end;

function u4.DrawOverlay(p75, p76) -- Line: 471
    -- upvalues: Config (copy)
    if not Config.DEBUG_OVERLAY_ENABLED then
        return;
    end;

    local v77 = Color3.new(1, 0.431373, 0.713725);
    local v78 = Color3.new(1, 1, 1);
    local v79 = Color3.new(0.486275, 0.431373, 1);
    local v80 = Color3.new(1, 1, 1);
    p76.Begin(`SmartBone Instance ID: {p75.ID}`, v77, v78);
    p76.Text((`Frame Counter: {shared.FrameCounter}`));

    if Config.DEBUG_OVERLAY_TREE then
        for i, v in p75.BoneTrees do
            if Config.DEBUG_OVERLAY_MAX_TREES > 0 and Config.DEBUG_OVERLAY_TREE_OFFSET + Config.DEBUG_OVERLAY_MAX_TREES <= i then
                break;
            end;

            if i >= Config.DEBUG_OVERLAY_TREE_OFFSET then
                p76.Begin(`Bone Tree {i}`, v79, v80);
                v:DrawOverlay(p76);
                p76.End();
            end;
        end;
    end;

    p76.End();
end;

function u4.Destroy(p81) -- Line: 507
    -- upvalues: SB_VERBOSE_LOG (copy)
    SB_VERBOSE_LOG("Deleting SmartBone Object");

    for _, v in p81.BoneTrees do
        v:Destroy();
    end;

    for _, v in p81.ColliderObjects do
        v:Destroy();
    end;

    setmetatable(p81, nil);
end;

function u4.Start() -- Line: 525
    -- upvalues: RunService (copy), u4 (copy), Config (copy), Players (copy), u1 (ref), CollectionService (copy), SB_VERBOSE_LOG (copy), SB_INDENT_LOG (copy), Utilities (copy), Runtime (copy), SB_UNINDENT_LOG (copy), ImOverlay (copy)
    if not RunService:IsClient() then
        warn("Smartbone.Start() can only be called in client context.");

        return;
    end;

    if not u4.Running then
        if Config.STARTUP_PRINT_ENABLED or Config.LOG_VERBOSE then
            print((`SmartBone2 v{Config.VERSION} Starting`));
        end;

        u4.Running = true;
        local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts");
        local Folder = Instance.new("Folder");
        Folder.Name = "SmartBone-Actors";
        Folder.Parent = PlayerScripts;
        local BindableEvent = Instance.new("BindableEvent");
        BindableEvent.Name = "OverlayEvent";
        BindableEvent.Parent = script;
        BindableEvent.Event:Connect(function(p82, ...) -- Line: 553
            -- upvalues: Config (ref), u1 (ref)
            if not Config.DEBUG_OVERLAY_ENABLED then
                return;
            end;

            if p82 == "Text" then
                u1:Text(...);

                return;
            end;

            if p82 == "Begin" then
                u1:Begin(...);

                return;
            end;

            if p82 == "End" then
                u1:End();
            end;
        end);
        local u83 = {};
        local u84 = {};

        local function GetActor() -- Line: 570
            -- upvalues: u84 (copy)
            return table.remove(u84) or Instance.new("Actor");
        end;

        local function GatherColliders() -- Line: 588
            -- upvalues: CollectionService (ref), SB_VERBOSE_LOG (ref), Config (ref)
            local v85 = {
                Key = {},
                Raw = {}
            };

            for _, v in CollectionService:GetTagged("SmartCollider") do
                if v:IsA("BasePart") then
                    local v86 = v:GetAttribute("ColliderKey");

                    if v86 then
                        v86 = tostring(v86);

                        if not v85.Key[v86] then
                            v85.Key[v86] = {};
                        end;

                        table.insert(v85.Key[v86], v);
                    end;

                    SB_VERBOSE_LOG((`Adding collider: {v.Name}, Collider Key: {v86}`));
                    table.insert(v85.Raw, v);

                    if Config.YIELD_ON_COLLIDER_GATHER then
                        task.wait();
                    end;
                end;
            end;

            return v85;
        end;

        local function SetupObject(u87) -- Line: 622
            -- upvalues: SB_VERBOSE_LOG (ref), SB_INDENT_LOG (ref), GatherColliders (copy), Utilities (ref), u84 (copy), Runtime (ref), Folder (copy), u83 (copy), SB_UNINDENT_LOG (ref)
            if not u87:IsA("BasePart") then
                return;
            end;

            SB_VERBOSE_LOG((`Setup Object: {u87.Name}`));
            SB_INDENT_LOG();
            local v88 = GatherColliders();
            local v89 = u87:GetAttribute("ColliderKey");
            local v90;

            if v89 then
                v90 = v88.Key[tostring(v89)] or {};
            else
                v90 = v88.Raw or {};
            end;

            local v91 = {};

            for _, v in v90 do
                local v92 = { Utilities.GetCollider(v), v };
                table.insert(v91, v92);
            end;

            local v93 = table.remove(u84) or Instance.new("Actor");
            local v94 = Runtime:Clone();
            v94.Parent = v93;
            v94.Enabled = true;
            v93.Parent = Folder;
            u83[u87] = v93;
            task.wait();
            v93:SendMessage("Setup", u87, v91, script);
            u87:GetPropertyChangedSignal("Parent"):Connect(function() -- Line: 663
                -- upvalues: u87 (copy), u83 (ref), u84 (ref)
                if u87.Parent ~= nil then
                    return;
                end;

                local v95 = u87;
                local v96 = u83[v95];
                u83[v95] = nil;

                if not v96 then
                    return;
                end;

                v96.Name = "Pooled Actor";
                table.insert(u84, v96);
            end);
            SB_VERBOSE_LOG("Runtime Started");
            SB_UNINDENT_LOG();
        end;

        local u97 = CollectionService:GetInstanceAddedSignal("SmartBone"):Connect(SetupObject);
        local u100 = CollectionService:GetInstanceRemovedSignal("SmartBone"):Connect(function(p98) -- Line: 575, Name: OnObjectFreed
            -- upvalues: u83 (copy), u84 (copy)
            local v99 = u83[p98];
            u83[p98] = nil;

            if not v99 then
                return;
            end;

            v99.Name = "Pooled Actor";
            table.insert(u84, v99);
        end);

        for _, v in CollectionService:GetTagged("SmartBone") do
            SetupObject(v);
        end;

        if Config.DEBUG_OVERLAY_ENABLED then
            u1 = ImOverlay.new();
            local PlayerGui = Players.LocalPlayer.PlayerGui;
            local ScreenGui = Instance.new("ScreenGui");
            ScreenGui.Name = "SmartBoneDebugOverlay";
            ScreenGui.IgnoreGuiInset = true;
            ScreenGui.ResetOnSpawn = false;
            ScreenGui.Parent = PlayerGui;
            u1.BackFrame.Parent = ScreenGui;
            RunService.RenderStepped:Connect(function() -- Line: 695
                -- upvalues: u1 (ref)
                u1:Render();
            end);
        end;

        return {
            Stop = function() -- Line: 701, Name: Stop
                -- upvalues: u4 (ref), Config (ref), Folder (copy), u97 (copy), u100 (copy)
                u4.Running = false;

                if not Config.RESET_BONE_ON_DESTROY then
                    Folder:Destroy();

                    return;
                end;

                for _, child in Folder:GetChildren() do
                    child:SendMessage("Destroy");
                end;

                if u97 then
                    u97:Disconnect();
                end;

                if u100 then
                    u100:Disconnect();
                end;
            end
        };
    end;

    warn("Cannot call Smartbone.Start() multiple times");
end;

return u4;