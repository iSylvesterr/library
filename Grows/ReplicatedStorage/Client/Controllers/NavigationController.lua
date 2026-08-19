-- Decompiled with Potassium's decompiler.

local u1 = Color3.fromRGB(0, 255, 0);
local u2 = CFrame.new(0, 5, -10);
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local Packages = ReplicatedStorage:WaitForChild("Packages");
ReplicatedStorage:WaitForChild("Shared");
local LocalPlayer = Players.LocalPlayer;
local Modules = ReplicatedStorage.Client:WaitForChild("Modules");
local Character = LocalPlayer.Character;
local Arrow = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Misc"):WaitForChild("Arrow");
local Knit = require(Packages.Knit);
local graphFactory = require(script:WaitForChild("graphFactory"));
require(Modules:WaitForChild("NodeGraph"):WaitForChild("Node"));
require(Modules:WaitForChild("NodeGraph"):WaitForChild("Edge"));
local Visualization = require(Modules:WaitForChild("NodeGraph"):WaitForChild("Visualization"));
local Dijkstra = require(Modules:WaitForChild("PointPathfinding"):WaitForChild("Dijkstra"));
local spr = require(Packages:WaitForChild("spr"));
local FloatingArrow = require(script:WaitForChild("FloatingArrow"));
local v3 = Knit.CreateController({
    Name = "NavigationController",
    TargetNode = nil,
    HiddenTransparencies = {},
    EdgeDebugParts = {},
    EdgeBeams = {}
});

function v3.KnitInit(p4) -- Line: 56
    -- upvalues: graphFactory (copy)
    p4.NavGraph = graphFactory("NavigationNode", false);
end;

function v3.KnitStart(u5) -- Line: 61
    -- upvalues: Visualization (copy), LocalPlayer (copy), Character (ref)
    u5.AttachmentPart = Visualization:CreateDebugPart(Color3.new(0, 0, 0));
    u5.AttachmentPart.CFrame = CFrame.new(0, -100, 0);
    u5.AttachmentPart.Parent = workspace;
    u5.Attachment1 = Instance.new("Attachment");
    u5.Attachment1.Parent = u5.AttachmentPart;
    u5.TargetAttachment = Instance.new("Attachment");
    u5.TargetAttachment.Parent = u5.AttachmentPart;
    LocalPlayer.CharacterAdded:Connect(function(p6) -- Line: 87
        -- upvalues: Character (ref), u5 (copy)
        Character = p6;

        if u5.CharacterBeam then
            task.wait(2);
            u5:_createCharacterBeam(u5.Attachment1.WorldCFrame.Position, u5.CharacterBeam.Color.Keypoints[1].Value);
        end;
    end);
end;

function v3.HideNavigationAids(p7, p8) -- Line: 104
    -- upvalues: Arrow (copy)
    if not p8 then
        p7:_hideDescendants(Arrow);
    end;

    p7.beamsHidden = true;

    if p7.CharacterBeam then
        p7.CharacterBeam.Width0 = 0;
        p7.CharacterBeam.Width1 = 0;
    end;

    for _, v in pairs(p7.EdgeBeams) do
        v.Enabled = false;
    end;
end;

function v3.ShowNavigationAids(p9) -- Line: 118
    -- upvalues: Arrow (copy)
    p9:_showDescendants(Arrow);
    p9.beamsHidden = false;

    if p9.CharacterBeam then
        p9.CharacterBeam.Width0 = 1;
        p9.CharacterBeam.Width1 = 1;
    end;

    for _, v in pairs(p9.EdgeBeams) do
        v.Enabled = true;
    end;
end;

function v3.StartSimpleNavigation(p10, u11, u12, p13, u14) -- Line: 133
    -- upvalues: Character (ref), LocalPlayer (copy), Arrow (copy), FloatingArrow (copy), u2 (copy), RunService (copy)
    p10:StopNavigation();
    Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local u15 = (not p13 or type(p13) ~= "number") and 8 or p13;
    p10:_createCharacterBeam(u11);

    if u12 then
        assert(Arrow, "To display a floating arrow, an Arrow BasePart or Model reference must be set in NavigationController");
        FloatingArrow:SetArrow(Arrow:Clone(), u2);
    end;

    p10.Stepped = RunService.RenderStepped:Connect(function() -- Line: 166
        -- upvalues: Character (ref), u11 (copy), u15 (ref), u14 (copy), u12 (copy), FloatingArrow (ref)
        debug.profilebegin("Simple Navigation");
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        local _ = (HumanoidRootPart.CFrame.Position - u11).Magnitude <= u15;
        local v16 = not u14 and 35 or u14;

        if u12 then
            FloatingArrow:PointAtFloat(u11, u11, v16, 6, 3, 1.5);
        end;

        debug.profileend();
    end);
end;

function v3.StartNavigation(u17, p18, u19) -- Line: 197
    -- upvalues: Character (ref), LocalPlayer (copy), Arrow (copy), FloatingArrow (copy), u2 (copy), RunService (copy)
    u17:StopNavigation();
    Character = LocalPlayer.Character;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not (Character and HumanoidRootPart) then
        return;
    end;

    local v20 = u17:_getClosestNode(HumanoidRootPart.Position);
    local v21 = u17:_getClosestNode(p18);
    u17.TargetNode = u17:_getTargetNode(p18);
    u17.NavGraph:AddEdge(v21, u17.TargetNode, (p18 - v21.Data.Position).Magnitude);
    local u22 = 1;
    local u23 = 1;
    local u24, u25 = u17:_getWaypoints(v20, u17.TargetNode);
    u17:_createBeams(u24);
    u17:_createCharacterBeam(u24[1].Position);
    u17.TargetAttachment.WorldCFrame = CFrame.new(p18);

    if u19 then
        assert(Arrow, "To display a floating arrow, an Arrow BasePart or Model reference must be set in NavigationController");
        FloatingArrow:SetArrow(Arrow:Clone(), u2);
    end;

    u17.Stepped = RunService.RenderStepped:Connect(function() -- Line: 248
        -- upvalues: HumanoidRootPart (ref), Character (ref), u17 (copy), u25 (ref), u24 (ref), u22 (ref), u23 (ref), u19 (copy), FloatingArrow (ref)
        debug.profilebegin("Navigation");
        HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        local v26 = u17:_getClosestNode(HumanoidRootPart.Position);

        if u25[v26] == nil then
            local v27, v28 = u17:_getWaypoints(v26, u17.TargetNode);
            u24 = v27;
            u25 = v28;
            u22 = 1;
            u23 = 1;
            u17:_createUpdateBeams(u24);
        end;

        local v29 = u25[v26];

        if v29 < #u24 then
            if v29 == 1 and u22 ~= 2 then
                local Position = u24[1].Position;
                local v30 = u17:_getClosestPointOnLine(HumanoidRootPart.Position, Position, u24[2].Position);

                if (HumanoidRootPart.Position - Position).Magnitude > (HumanoidRootPart.Position - v30).Magnitude then
                    u22 = v29 + 1;
                end;
            elseif v29 > 1 then
                if v29 < u22 and u22 - v29 >= 2 then
                    local Position = u24[v29].Position;
                    local v31 = u17:_getClosestPointOnLine(HumanoidRootPart.Position, Position, u24[v29 + 1].Position);

                    if (HumanoidRootPart.Position - Position).Magnitude > (HumanoidRootPart.Position - v31).Magnitude then
                        u22 = v29 + 1;
                    else
                        u22 = v29;
                    end;
                elseif u22 <= v29 then
                    if u17:_shouldForwardTrack(HumanoidRootPart.Position, v26.Data.Position, u24[v29 + 1].Position, u24[v29 - 1].Position) then
                        u22 = v29 + 1;
                    else
                        u22 = v29;
                    end;
                end;
            end;
        elseif v29 == #u24 then
            u22 = v29;
            u17:_removeBeams();
        end;

        if u23 < u22 then
            for i = 2, u22 do
                u17:_removeBeam(u24[i - 1].Node, u24[i].Node);
            end;
        elseif u22 < u23 then
            for i = u22, u23 - 1 do
                u17:_createBeamFromNodes(u24[i].Node, u24[i + 1].Node);
            end;
        end;

        u23 = u22;
        u17:_setCharacterBeamCFrame(CFrame.new(u24[u22].Position));

        if u19 then
            FloatingArrow:PointAtFloat(u24[#u24].Position, u24[u22].Position, 35, 6, 3, 1.5);
        end;

        debug.profileend();
    end);
end;

function v3.StopNavigation(p32) -- Line: 371
    -- upvalues: FloatingArrow (copy)
    if p32.Stepped then
        p32.Stepped:Disconnect();
    end;

    if p32.CharacterBeam then
        p32.CharacterBeam:Destroy();
        p32.CharacterBeam = nil;
    end;

    if p32.TargetPart then
        p32.TargetPart:Destroy();
        p32.TargetPart = nil;
    end;

    if p32.TargetNode then
        p32.NavGraph:RemoveNode(p32.TargetNode);
        p32.TargetNode = nil;
    end;

    FloatingArrow:Stop();

    for _, v in p32.EdgeBeams do
        v:Destroy();
    end;

    p32.EdgeBeams = {};
end;

function v3._getTargetNode(p33, p34) -- Line: 401
    if not p33.TargetPart then
        p33.TargetPart = Instance.new("Part");
        p33.TargetPart.Size = Vector3.new(1, 1, 1);
        p33.TargetPart.Anchored = true;
        p33.TargetPart.CanCollide = false;
        p33.TargetPart.CanQuery = false;
        p33.TargetPart.Transparency = 1;
        p33.TargetPart.Parent = workspace;
    end;

    p33.TargetPart.CFrame = CFrame.new(p34);

    return p33.NavGraph:AddNode({
        Part = p33.TargetPart,
        Position = p34
    });
end;

function v3._getWaypoints(p35, p36, p37) -- Line: 424
    -- upvalues: Dijkstra (copy)
    local v38 = Dijkstra(p35.NavGraph, p36, p37);
    local v39 = {};

    for i, v in v38 do
        v39[v.Node] = i;
    end;

    return v38, v39;
end;

function v3._hideDescendants(p40, p41) -- Line: 436
    if not p41 then
        return;
    end;

    if p41:IsA("BasePart") then
        p40.HiddenTransparencies[p41] = p41.Transparency;
        p41.Transparency = 1;
    end;

    for _, descendant in p41:GetDescendants() do
        if descendant:IsA("BasePart") then
            p40.HiddenTransparencies[descendant] = descendant.Transparency;
            descendant.Transparency = 1;
        end;
    end;
end;

function v3._showDescendants(p42, p43) -- Line: 454
    if not p43 then
        return;
    end;

    if p43:IsA("BasePart") and p42.HiddenTransparencies[p43] then
        p43.Transparency = p42.HiddenTransparencies[p43];
        p42.HiddenTransparencies[p43] = nil;
    end;

    for _, descendant in p43:GetDescendants() do
        if descendant:IsA("BasePart") and p42.HiddenTransparencies[descendant] then
            descendant.Transparency = p42.HiddenTransparencies[descendant];
            p42.HiddenTransparencies[descendant] = nil;
        end;
    end;
end;

function v3._shouldForwardTrack(p44, p45, p46, p47, p48) -- Line: 472
    local v49 = p44:_getClosestPointOnLine(p45, p46, p47);
    local v50 = p44:_getClosestPointOnLine(p45, p48, p46);

    return (v49 - p45).Magnitude < (v50 - p45).Magnitude;
end;

function v3._getClosestPointOnLine(p51, p52, p53, p54) -- Line: 492
    local v55 = p54 - p53;
    local v56 = Ray.new(p53, v55.Unit):ClosestPoint(p52);

    if (v56 - p53).Magnitude > v55.Magnitude then
        return p54;
    end;

    if (v56 - p54).Magnitude > v55.Magnitude then
        return p53;
    end;

    return v56;
end;

function v3._getClosestNode(p57, p58) -- Line: 507
    local v59 = (1 / 0);
    local v60 = nil;

    for _, v in p57.NavGraph.Nodes do
        local Magnitude = (v.Data.Position - p58).Magnitude;

        if Magnitude < v59 then
            v60 = v;
            v59 = Magnitude;
        end;
    end;

    return v60;
end;

function v3._visualDebugNavGraph(p61) -- Line: 523
    -- upvalues: Visualization (copy)
    Visualization:DrawGraph(p61.NavGraph);
end;

function v3._visualDebugWaypoints(u62, p63) -- Line: 527
    -- upvalues: Visualization (copy)
    local function getNextEdge(p64, p65) -- Line: 528
        -- upvalues: u62 (copy)
        for _, v in u62.NavGraph:GetEdgesForNode(p64.Node) do
            if v.Node0 == p65.Node or v.Node1 == p65.Node then
                return v;
            end;
        end;
    end;

    for i, v in p63 do
        if i == #p63 then
            return;
        end;

        local v66 = p63[i + 1];
        local v67 = getNextEdge(v, v66);

        if not v67 then
            error((`No next edge for waypoint at index {i}`));
        end;

        local v68 = v.Position - v66.Position;
        local v69 = Visualization:CreateDebugPart(Color3.new(1, 0, 0));
        v69.Size = Vector3.new(0.1, 0.1, v68.Magnitude);
        v69.CFrame = CFrame.new(v.Position, v66.Position) * CFrame.new(0, 0, -v68.Magnitude * 0.5);

        if u62.EdgeDebugParts[v67] then
            u62.EdgeDebugParts[v67]:Destroy();
        end;

        u62.EdgeDebugParts[v67] = v69;
    end;
end;

function v3._removeBeam(p70, p71, p72) -- Line: 569
    if not (p71 and p72) then
        return;
    end;

    local v73 = p70.NavGraph:GetEdgeForNodes(p71, p72);

    if v73 and p70.EdgeBeams[v73] then
        p70.EdgeBeams[v73]:Destroy();
        p70.EdgeBeams[v73] = nil;
    end;
end;

function v3._removeBeams(p74) -- Line: 582
    for _, v in p74.EdgeBeams do
        v:Destroy();
    end;

    p74.EdgeBeams = {};
end;

function v3._createUpdateBeams(p75, p76) -- Line: 591
    local v77 = {};

    for i, v in p76 do
        if i ~= #p76 then
            local v78 = v77[v.Edge] == nil;
            local v79 = `Already created a beam for edge at index: {i}`;
            assert(v78, v79);
            v77[v.Edge] = true;

            if not p75.EdgeBeams[v.Edge] then
                local Part = p76[i + 1].Node.Data.Part;
                local v80 = p75:_findOrCreateBeamAttachment(v.Node.Data.Part);
                local v81 = p75:_findOrCreateBeamAttachment(Part);
                local v82 = p75:_createBeam();
                v82.Attachment0 = v80;
                v82.Attachment1 = v81;
                p75.EdgeBeams[v.Edge] = v82;
                v82.Parent = workspace;
            end;
        end;
    end;

    for i, v in p75.EdgeBeams do
        if v77[i] == nil then
            v:Destroy();
            p75.EdgeBeams[i] = nil;
        end;
    end;
end;

function v3._createBeams(p83, p84) -- Line: 630
    local v85 = {};

    for i, v in p84 do
        if i ~= #p84 then
            local v86 = p84[i + 1];
            local v87 = p83.NavGraph:GetEdgeForNodes(v.Node, v86.Node);

            if v87 then
                local Part = v86.Node.Data.Part;
                local v88 = p83:_findOrCreateBeamAttachment(v.Node.Data.Part);
                local v89 = p83:_findOrCreateBeamAttachment(Part);
                local v90 = p83.EdgeBeams[v87];

                if not v90 then
                    v90 = p83:_createBeam();
                    p83.EdgeBeams[v87] = v90;
                end;

                v90.Attachment0 = v88;
                v90.Attachment1 = v89;
                v90.Parent = workspace;
                table.insert(v85, v90);
            else
                warn((`No edge for nodes at index {i}`));
            end;
        end;
    end;

    return v85;
end;

function v3._createBeamFromNodes(p91, p92, p93) -- Line: 667
    local v94 = p91.NavGraph:GetEdgeForNodes(p92, p93);

    if not p91.EdgeBeams[v94] then
        local Part = p93.Data.Part;
        local v95 = p91:_findOrCreateBeamAttachment(p92.Data.Part);
        local v96 = p91:_findOrCreateBeamAttachment(Part);
        local v97 = p91:_createBeam();
        v97.Attachment0 = v95;
        v97.Attachment1 = v96;
        v97.Parent = workspace;
        p91.EdgeBeams[v94] = v97;

        return v97;
    end;

    warn("Beam already exists for that edge!");
end;

function v3._createBeamFromEdge(p98, p99) -- Line: 689
    error("NavigationController:_createBeamFromEdge() doesn\'t work for undirected graphs. Consider implementing a directed graph (please).");

    if not p98.EdgeBeams[p99] then
        local Part = p99.Node1.Data.Part;
        local v100 = p98:_findOrCreateBeamAttachment(p99.Node0.Data.Part);
        local v101 = p98:_findOrCreateBeamAttachment(Part);
        local v102 = p98:_createBeam();
        v102.Attachment0 = v100;
        v102.Attachment1 = v101;
        v102.Parent = workspace;
        p98.EdgeBeams[p99] = v102;

        return v102;
    end;

    warn("Beam already exists for that edge!");
end;

function v3._findOrCreateBeamAttachment(p103, p104) -- Line: 712
    local BeamAttachment = p104:FindFirstChild("BeamAttachment", true);

    if not BeamAttachment then
        BeamAttachment = Instance.new("Attachment");
        BeamAttachment.Name = "BeamAttachment";

        if p104:IsA("BasePart") then
            BeamAttachment.Parent = p104;

            return BeamAttachment;
        end;

        if p104:IsA("Model") then
            BeamAttachment.Parent = p104.PrimaryPart;
        end;
    end;

    return BeamAttachment;
end;

function v3._setCharacterBeamCFrame(p105, p106) -- Line: 729
    -- upvalues: spr (copy)
    spr.target(p105.CharacterBeam.Attachment1, 1, 4, {
        WorldCFrame = p106
    });
end;

function v3._createCharacterBeam(p107, p108, p109) -- Line: 736
    -- upvalues: spr (copy), Character (ref)
    if p107.CharacterBeam then
        spr.stop(p107.CharacterBeam.Attachment1);
        p107.CharacterBeam:Destroy();
    end;

    if p108 then
        p107.Attachment1.WorldCFrame = CFrame.new(p108);
    end;

    p107.CharacterBeam = p107:_createBeam(p109);
    p107.CharacterBeam.Attachment0 = Character:FindFirstChild("RootAttachment", true);
    p107.CharacterBeam.Attachment1 = p107.Attachment1;
    p107.CharacterBeam.Parent = workspace;
end;

function v3._createBeam(p110, p111) -- Line: 753
    -- upvalues: u1 (copy)
    if p111 == nil then
        p111 = u1;
    end;

    local Beam = Instance.new("Beam");
    Beam.FaceCamera = true;
    Beam.Texture = "rbxassetid://83428691615190";
    Beam.Color = ColorSequence.new(p111);
    Beam.TextureLength = 1.5;
    Beam.Width0 = 1.5;
    Beam.Width1 = 1.5;
    Beam.TextureMode = Enum.TextureMode.Wrap;
    Beam.TextureSpeed = 2;

    return Beam;
end;

return v3;