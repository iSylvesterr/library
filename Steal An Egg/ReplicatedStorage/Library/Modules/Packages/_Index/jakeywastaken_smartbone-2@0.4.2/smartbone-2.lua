-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Components = script:WaitForChild("Components");
local Dependencies = script:WaitForChild("Dependencies");
local CeiveImOverlay = require(Dependencies:WaitForChild("CeiveImOverlay"));
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
    -- upvalues: Utilities (copy), BoneTree (copy), SB_VERBOSE_LOG (copy), SB_INDENT_LOG (copy), SB_UNINDENT_LOG (copy)
    local v17 = Utilities.GatherObjectSettings(p15);
    local u18 = BoneTree.new(p16, p15);
    u18.Settings = v17;
    SB_VERBOSE_LOG((`Creating bone tree {p15.Name}; {p16.Name}`));
    SB_INDENT_LOG();

    local function AddChildren(p19, p20, p21) -- Line: 144
        -- upvalues: SB_VERBOSE_LOG (ref), SB_INDENT_LOG (ref), u14 (copy), u18 (copy), AddChildren (copy), SB_UNINDENT_LOG (ref)
        SB_VERBOSE_LOG((`Adding bone: {p19.Name}; {p20}; {p21}`));
        SB_INDENT_LOG();
        local v22 = false;

        for _, child in p19:GetChildren() do
            if child:IsA("Bone") then
                u14:m_AppendBone(u18, child, p20, p21);
                AddChildren(child, #u18.Bones, p21 + 1);
                v22 = true;
            end;
        end;

        if not v22 then
            SB_VERBOSE_LOG("Adding tail bone");
            local Parent = p19.Parent;
            local v23 = Parent:IsA("Bone") and Parent.WorldPosition or Parent.Position;
            local v24 = p19.WorldCFrame + p19.WorldCFrame.UpVector.Unit * (p19.WorldPosition - v23).Magnitude;
            local Bone2 = Instance.new("Bone");
            Bone2.Parent = p19;
            Bone2.Name = p19.Name .. "_Tail";
            Bone2.WorldCFrame = v24;

            for i, v in p19:GetAttributes() do
                Bone2:SetAttribute(i, v);
            end;

            u14:m_AppendBone(u18, Bone2, #u18.Bones, p21);
        end;

        SB_UNINDENT_LOG();
    end;

    u14:m_AppendBone(u18, p16, 0, 0);
    AddChildren(p16, 1, 1);
    table.insert(u14.BoneTrees, u18);
    SB_UNINDENT_LOG();
end;

function u4.m_UpdateViewFrustum(p25) -- Line: 194
    -- upvalues: Config (copy), Frustum (copy)
    if shared.FrameCounter % Config.FRUSTUM_FREQ ~= 0 then
        return;
    end;

    local v26, v27, v28, v29, v30, v31, v32, v33, v34 = Frustum.GetCFrames(workspace.CurrentCamera, Config.FAR_PLANE);

    for _, v in p25.BoneTrees do
        v.InView = Frustum.ObjectInFrustum({
            CFrame = v.BoundingBoxCFrame,
            Size = v.BoundingBoxSize
        }, v26, v27, v28, v29, v30, v31, v32, v33, v34);
    end;
end;

function u4.m_CleanColliders(p35) -- Line: 219
    -- upvalues: SB_VERBOSE_WARN (copy), SB_INDENT_LOG (copy), SB_UNINDENT_LOG (copy)
    local v36 = false;

    if #p35.ColliderObjects ~= 0 then
        for i, v in p35.ColliderObjects do
            if #v.Colliders == 0 or v.Destroyed == true then
                SB_VERBOSE_WARN("Deleting Collider Object");
                SB_INDENT_LOG();
                v:Destroy();
                SB_UNINDENT_LOG();
                table.remove(p35.ColliderObjects, i);
                v36 = true;
            end;
        end;
    end;
end;

function u4.m_UpdateBoneTree(p37, p38, p39, p40) -- Line: 253
    -- upvalues: SB_VERBOSE_LOG (copy)
    if p38.Destroyed then
        p38:Destroy();
        table.remove(p37.BoneTrees, p39);

        return;
    end;

    p38:PreUpdate(p40);

    if not p38.InView or (math.floor(p38.UpdateRate) == 0 or not p38.InWorkspace) then
        local IsSkippingUpdates = p38.IsSkippingUpdates;
        p38:SkipUpdate();

        if not IsSkippingUpdates then
            task.synchronize();
            p38:ApplyTransform();
            SB_VERBOSE_LOG((`Skipping BoneTree, InView: {p38.InView}, Update Rate == 0: {math.floor(p38.UpdateRate) == 0}, InWorkspace: {p38.InWorkspace}`));
        end;

        return;
    end;

    for _, v in p37.ColliderObjects do
        v:Step();
    end;

    local v41 = 1 / p38.UpdateRate;
    p38.AccumulatedDelta = p38.AccumulatedDelta + p40;
    local v42 = false;

    while v41 < p38.AccumulatedDelta do
        p38.AccumulatedDelta = p38.AccumulatedDelta - v41;
        p38:StepPhysics(v41);
        p38:Constrain(p37.ColliderObjects, v41);
        p38:SolveTransform(v41);
        v42 = true;
    end;

    if v42 then
        task.synchronize();
        p38:ApplyTransform();
    end;
end;

function u4.m_CheckDestroy(p43) -- Line: 323
    p43.ShouldDestroy = false;

    if #p43.BoneTrees ~= 0 then
        return false;
    end;

    p43.ShouldDestroy = true;

    return true;
end;

function u4.LoadObject(p44, p45) -- Line: 339
    local v46 = p45:GetAttribute("Roots");

    if not v46 then
        warn((`[SmartBone2::LoadObject] Cannot load an object with no roots defined {p45.Name}`));

        return;
    end;

    local v47 = v46:split(",");
    local v48 = {};

    for _, descendant in p45:GetDescendants() do
        if descendant:IsA("Bone") then
            if v48[descendant.Name] then
                warn((`[SmartBone2::LoadObject] Duplicate bones of name: {descendant.Name} in RootPart: {p45.Name}`));
            else
                v48[descendant.Name] = descendant;
            end;
        end;
    end;

    for _, v in v47 do
        local v49 = v48[v];

        if v49 then
            p44:m_CreateBoneTree(p45, v49);
        else
            warn((`[SmartBone2::LoadObject] Couldn't find Root Bone of name: {v} in RootPart: {p45.Name}`));
        end;
    end;
end;

function u4.LoadColliderModule(p50, p51, p52) -- Line: 380
    -- upvalues: HttpService (copy), ColliderObject (copy)
    assert(p51, "[SmartBone2::LoadColliderModule] No collider module passed in");
    local v53 = HttpService:JSONDecode((require(p51)));
    local v54 = ColliderObject.new(v53, p52);
    table.insert(p50.ColliderObjects, v54);
end;

function u4.LoadRawCollider(p55, p56, p57) -- Line: 395
    -- upvalues: ColliderObject (copy)
    local v58 = ColliderObject.new(p56, p57);
    table.insert(p55.ColliderObjects, v58);
end;

function u4.SkipUpdate(p59) -- Line: 403
    for _, v in p59.BoneTrees do
        v:SkipUpdate();
    end;
end;

function u4.StepBoneTrees(p60, p61) -- Line: 416
    -- upvalues: SB_VERBOSE_WARN (copy)
    if p60:m_CheckDestroy() then
        return;
    end;

    if p61 <= 0 then
        SB_VERBOSE_WARN("DeltaTime is zero or sub zero, not updating.");

        return;
    end;

    p60:m_CleanColliders();
    p60:m_UpdateViewFrustum();

    for i, v in p60.BoneTrees do
        p60:m_UpdateBoneTree(v, i, p61);
    end;
end;

function u4.DrawDebug(p62, p63, p64, p65, p66, p67, p68, p69, p70, p71, p72, p73, p74, p75) -- Line: 449
    for _, v in p62.BoneTrees do
        v:DrawDebug(p64, p65, p66, p67, p68, p73, p74, p75);
    end;

    if p63 then
        for _, v in p62.ColliderObjects do
            v:DrawDebug(p69, p70, p71, p72);
        end;
    end;
end;

function u4.DrawOverlay(p76, p77) -- Line: 493
    -- upvalues: Config (copy)
    if not Config.DEBUG_OVERLAY_ENABLED then
        return;
    end;

    local v78 = Color3.new(1, 0.431373, 0.713725);
    local v79 = Color3.new(1, 1, 1);
    local v80 = Color3.new(0.486275, 0.431373, 1);
    local v81 = Color3.new(1, 1, 1);
    p77.Begin(`SmartBone Instance ID: {p76.ID}`, v78, v79);
    p77.Text((`Frame Counter: {shared.FrameCounter}`));

    if Config.DEBUG_OVERLAY_TREE then
        for i, v in p76.BoneTrees do
            if Config.DEBUG_OVERLAY_MAX_TREES > 0 and Config.DEBUG_OVERLAY_TREE_OFFSET + Config.DEBUG_OVERLAY_MAX_TREES <= i then
                break;
            end;

            if i >= Config.DEBUG_OVERLAY_TREE_OFFSET then
                p77.Begin(`Bone Tree {i}`, v80, v81);
                v:DrawOverlay(p77);
                p77.End();
            end;
        end;
    end;

    p77.End();
end;

function u4.Destroy(p82) -- Line: 529
    -- upvalues: SB_VERBOSE_LOG (copy)
    SB_VERBOSE_LOG("Deleting SmartBone Object");

    for _, v in p82.BoneTrees do
        v:Destroy();
    end;

    for _, v in p82.ColliderObjects do
        v:Destroy();
    end;

    setmetatable(p82, nil);
end;

function u4.Start() -- Line: 547
    -- upvalues: RunService (copy), u4 (copy), Config (copy), Players (copy), u1 (ref), CollectionService (copy), SB_VERBOSE_LOG (copy), SB_INDENT_LOG (copy), Utilities (copy), Runtime (copy), SB_UNINDENT_LOG (copy), CeiveImOverlay (copy)
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
        BindableEvent.Event:Connect(function(p83, ...) -- Line: 575
            -- upvalues: Config (ref), u1 (ref)
            if not Config.DEBUG_OVERLAY_ENABLED then
                return;
            end;

            if p83 == "Text" then
                u1:Text(...);

                return;
            end;

            if p83 == "Begin" then
                u1:Begin(...);

                return;
            end;

            if p83 == "End" then
                u1:End();
            end;
        end);

        local function GatherColliders() -- Line: 589
            -- upvalues: CollectionService (ref), SB_VERBOSE_LOG (ref), Config (ref)
            local v84 = {
                Key = {},
                Raw = {}
            };

            for _, v in CollectionService:GetTagged("SmartCollider") do
                if v:IsA("BasePart") then
                    local v85 = v:GetAttribute("ColliderKey");

                    if v85 then
                        v85 = tostring(v85);

                        if not v84.Key[v85] then
                            v84.Key[v85] = {};
                        end;

                        table.insert(v84.Key[v85], v);
                    end;

                    SB_VERBOSE_LOG((`Adding collider: {v.Name}, Collider Key: {v85}`));
                    table.insert(v84.Raw, v);

                    if Config.YIELD_ON_COLLIDER_GATHER then
                        task.wait();
                    end;
                end;
            end;

            return v84;
        end;

        local function SetupObject(p86) -- Line: 623
            -- upvalues: SB_VERBOSE_LOG (ref), SB_INDENT_LOG (ref), GatherColliders (copy), Utilities (ref), Runtime (ref), Folder (copy), SB_UNINDENT_LOG (ref)
            if not p86:IsA("BasePart") then
                return;
            end;

            SB_VERBOSE_LOG((`Setup Object: {p86.Name}`));
            SB_INDENT_LOG();
            local v87 = GatherColliders();
            local v88 = p86:GetAttribute("ColliderKey");
            local v89;

            if v88 then
                v89 = v87.Key[tostring(v88)] or {};
            else
                v89 = v87.Raw or {};
            end;

            local v90 = {};

            for _, v in v89 do
                local v91 = { Utilities.GetCollider(v), v };
                table.insert(v90, v91);
            end;

            print("Setting global colliders, for", p86, "with colliders", v87, "descriptions:", v90);
            local Actor = Instance.new("Actor");
            local v92 = Runtime:Clone();
            v92.Parent = Actor;
            v92.Enabled = true;
            Actor.Parent = Folder;
            task.wait();
            Actor:SendMessage("Setup", p86, v90, script);
            SB_VERBOSE_LOG("Runtime Started");
            SB_UNINDENT_LOG();
        end;

        CollectionService:GetInstanceAddedSignal("SmartBone"):Connect(SetupObject);

        for _, v in CollectionService:GetTagged("SmartBone") do
            SetupObject(v);
        end;

        if Config.DEBUG_OVERLAY_ENABLED then
            u1 = CeiveImOverlay.new();
            local PlayerGui = Players.LocalPlayer.PlayerGui;
            local ScreenGui = Instance.new("ScreenGui");
            ScreenGui.Name = "SmartBoneDebugOverlay";
            ScreenGui.IgnoreGuiInset = true;
            ScreenGui.ResetOnSpawn = false;
            ScreenGui.Parent = PlayerGui;
            u1.BackFrame.Parent = ScreenGui;
            RunService.RenderStepped:Connect(function() -- Line: 692
                -- upvalues: u1 (ref)
                u1:Render();
            end);
        end;

        return {
            Stop = function() -- Line: 698, Name: Stop
                -- upvalues: u4 (ref), Config (ref), Folder (copy)
                u4.Running = false;

                if Config.RESET_BONE_ON_DESTROY then
                    for _, child in Folder:GetChildren() do
                        child:SendMessage("Destroy");
                    end;

                    return;
                end;

                Folder:Destroy();
            end
        };
    end;

    warn("Cannot call Smartbone.Start() multiple times");
end;

return u4;