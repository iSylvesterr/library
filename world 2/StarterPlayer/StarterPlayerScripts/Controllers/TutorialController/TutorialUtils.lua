-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local RunService = game:GetService("RunService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local u1 = assert(LocalPlayer);
local TutorialUI = u1.PlayerGui:WaitForChild("TutorialUI");
local Pointer = TutorialUI:WaitForChild("Pointer");
local Focus = TutorialUI:WaitForChild("Focus");

local function createTween(p2, p3, p4, p5) -- Line: 19
    -- upvalues: TweenService (copy)
    local u6 = TweenService:Create(p2, p3, p4);
    u6.Completed:Once(function() -- Line: 28
        -- upvalues: u6 (copy)
        u6:Destroy();
    end);

    if p5 ~= false then
        u6:Play();
    end;

    return u6;
end;

local u7 = 0;
local u8 = nil;

local function getFullScreenFocus() -- Line: 42
    local ViewportSize = workspace.CurrentCamera.ViewportSize;

    return UDim2.fromOffset(ViewportSize.X * 0.5, ViewportSize.Y * 0.5), UDim2.fromOffset(ViewportSize.X * 2, ViewportSize.Y * 2);
end;

local function focusObject(u9) -- Line: 48
    -- upvalues: Focus (copy), u7 (ref), u8 (ref), createTween (copy), RunService (copy)
    local Visible = Focus.Visible;
    u7 = u7 + 1;
    local u10 = u7;

    local function getTarget() -- Line: 53
        -- upvalues: u9 (copy)
        if type(u9) ~= "function" then
            local AbsoluteSize = u9.AbsoluteSize;

            return u9.AbsolutePosition + AbsoluteSize * 0.5, AbsoluteSize;
        end;

        local v11 = u9();

        if v11 == nil then
            return nil, nil;
        end;

        return v11.Position + v11.Size * 0.5, v11.Size;
    end;

    if not Visible then
        local ViewportSize = workspace.CurrentCamera.ViewportSize;
        local v12 = UDim2.fromOffset(ViewportSize.X * 0.5, ViewportSize.Y * 0.5);
        local v13 = UDim2.fromOffset(ViewportSize.X * 2, ViewportSize.Y * 2);
        Focus.Position = v12;
        Focus.Size = v13;
        Focus.UIStroke.Transparency = 0.3;
    end;

    Focus.Visible = true;

    if u8 then
        u8:Cancel();
    end;

    local v14, v15;

    if type(u9) == "function" then
        local v16 = u9();

        if v16 == nil then
            v14 = nil;
            v15 = nil;
        else
            v14 = v16.Position + v16.Size * 0.5;
            v15 = v16.Size;
        end;
    else
        v15 = u9.AbsoluteSize;
        v14 = u9.AbsolutePosition + v15 * 0.5;
    end;

    if v14 and v15 then
        u8 = createTween(Focus, TweenInfo.new(Visible and 0.25 or 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.fromOffset(v14.X, v14.Y),
            Size = UDim2.fromOffset(v15.X, v15.Y)
        });
    end;

    local u20 = RunService.PreRender:Connect(function() -- Line: 90
        -- upvalues: u8 (ref), u9 (copy), Focus (ref)
        if u8 and u8.PlaybackState == Enum.PlaybackState.Playing then
            return;
        end;

        local v17, v18;

        if type(u9) == "function" then
            local v19 = u9();

            if v19 == nil then
                v17 = nil;
                v18 = nil;
            else
                v17 = v19.Position + v19.Size * 0.5;
                v18 = v19.Size;
            end;
        else
            v18 = u9.AbsoluteSize;
            v17 = u9.AbsolutePosition + v18 * 0.5;
        end;

        if not (v17 and v18) then
            return;
        end;

        Focus.Position = UDim2.fromOffset(v17.X, v17.Y);
        Focus.Size = UDim2.fromOffset(v18.X, v18.Y);
    end);

    return function(p21) -- Line: 102
        -- upvalues: u20 (copy), u8 (ref), createTween (ref), Focus (ref), u7 (ref), u10 (copy)
        if not u20.Connected then
            return;
        end;

        u20:Disconnect();

        if u8 then
            u8:Cancel();
        end;

        local ViewportSize = workspace.CurrentCamera.ViewportSize;
        local v22 = UDim2.fromOffset(ViewportSize.X * 0.5, ViewportSize.Y * 0.5);
        local v23 = UDim2.fromOffset(ViewportSize.X * 2, ViewportSize.Y * 2);
        u8 = createTween(Focus, TweenInfo.new(p21 or 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = v22,
            Size = v23
        });
        assert(u8).Completed:Once(function() -- Line: 120
            -- upvalues: u7 (ref), u10 (ref), Focus (ref)
            if u7 == u10 then
                Focus.Visible = false;
            end;
        end);
    end;
end;

function observeTag(u24, u25, u26)
    -- upvalues: CollectionService (copy)
    local u27 = {};
    local u28 = {};
    local u29 = nil;

    local function isGoodAncestor(p30) -- Line: 256
        -- upvalues: u26 (copy)
        if u26 == nil then
            return true;
        end;

        for _, v in u26 do
            if p30:IsDescendantOf(v) then
                return true;
            end;
        end;

        return false;
    end;

    local function attemptStartup(u31) -- Line: 270
        -- upvalues: u27 (copy), u25 (copy)
        u27[u31] = "__inflight__";
        task.defer(function() -- Line: 275
            -- upvalues: u27 (ref), u31 (copy), u25 (ref)
            if u27[u31] ~= "__inflight__" then
                return;
            end;

            local v35, v36 = xpcall(function(p32) -- Line: 281
                -- upvalues: u25 (ref)
                local v33 = u25(p32);

                if v33 ~= nil then
                    local v34 = typeof(v33) == "function";
                    assert(v34, "callback must return a function or nil");
                end;

                return v33;
            end, debug.traceback, u31);

            if v35 then
                if u27[u31] == "__inflight__" then
                    u27[u31] = v36;
                elseif v36 ~= nil then
                    task.spawn(v36);

                    return;
                end;

                return;
            end;

            local v37 = string.split(v36, "\n")[1];
            local v38 = string.find(v37, ": ");

            if v38 then
                v37:sub(v38 + 1);
            end;
        end);
    end;

    local function attemptCleanup(p39) -- Line: 312
        -- upvalues: u27 (copy)
        local v40 = u27[p39];
        u27[p39] = "__dead__";

        if typeof(v40) == "function" then
            task.spawn(v40);
        end;
    end;

    local function onAncestryChanged(u41) -- Line: 321
        -- upvalues: u26 (copy), u27 (copy), u25 (copy)
        local v42;

        if u26 == nil then
            v42 = true;
        else
            v42 = false;

            for _, v in u26 do
                if u41:IsDescendantOf(v) then
                    v42 = true;
                    break;
                end;
            end;
        end;

        if v42 then
            if u27[u41] == "__dead__" then
                u27[u41] = "__inflight__";
                task.defer(function() -- Line: 275
                    -- upvalues: u27 (ref), u41 (copy), u25 (ref)
                    if u27[u41] ~= "__inflight__" then
                        return;
                    end;

                    local v46, v47 = xpcall(function(p43) -- Line: 281
                        -- upvalues: u25 (ref)
                        local v44 = u25(p43);

                        if v44 ~= nil then
                            local v45 = typeof(v44) == "function";
                            assert(v45, "callback must return a function or nil");
                        end;

                        return v44;
                    end, debug.traceback, u41);

                    if v46 then
                        if u27[u41] == "__inflight__" then
                            u27[u41] = v47;
                        elseif v47 ~= nil then
                            task.spawn(v47);

                            return;
                        end;

                        return;
                    end;

                    local v48 = string.split(v47, "\n")[1];
                    local v49 = string.find(v48, ": ");

                    if v49 then
                        v48:sub(v49 + 1);
                    end;
                end);
            end;
        else
            local v50 = u27[u41];
            u27[u41] = "__dead__";

            if typeof(v50) == "function" then
                task.spawn(v50);
            end;
        end;
    end;

    local function onInstanceAdded(u51) -- Line: 331
        -- upvalues: u29 (ref), u27 (copy), u28 (copy), u26 (copy), u25 (copy)
        if not u29.Connected then
            return;
        end;

        if u27[u51] ~= nil then
            return;
        end;

        u27[u51] = "__dead__";
        u28[u51] = u51.AncestryChanged:Connect(function() -- Line: 341
            -- upvalues: u51 (copy), u26 (ref), u27 (ref), u25 (ref)
            local u52 = u51;
            local v53;

            if u26 == nil then
                v53 = true;
            else
                v53 = false;

                for _, v in u26 do
                    if u52:IsDescendantOf(v) then
                        v53 = true;
                        break;
                    end;
                end;
            end;

            if v53 then
                if u27[u52] == "__dead__" then
                    u27[u52] = "__inflight__";
                    task.defer(function() -- Line: 275
                        -- upvalues: u27 (ref), u52 (copy), u25 (ref)
                        if u27[u52] ~= "__inflight__" then
                            return;
                        end;

                        local v57, v58 = xpcall(function(p54) -- Line: 281
                            -- upvalues: u25 (ref)
                            local v55 = u25(p54);

                            if v55 ~= nil then
                                local v56 = typeof(v55) == "function";
                                assert(v56, "callback must return a function or nil");
                            end;

                            return v55;
                        end, debug.traceback, u52);

                        if v57 then
                            if u27[u52] == "__inflight__" then
                                u27[u52] = v58;
                            elseif v58 ~= nil then
                                task.spawn(v58);

                                return;
                            end;

                            return;
                        end;

                        local v59 = string.split(v58, "\n")[1];
                        local v60 = string.find(v59, ": ");

                        if v60 then
                            v59:sub(v60 + 1);
                        end;
                    end);
                end;
            else
                local v61 = u27[u52];
                u27[u52] = "__dead__";

                if typeof(v61) == "function" then
                    task.spawn(v61);
                end;
            end;
        end);
        local v62;

        if u26 == nil then
            v62 = true;
        else
            v62 = false;

            for _, v in u26 do
                if u51:IsDescendantOf(v) then
                    v62 = true;
                    break;
                end;
            end;
        end;

        if v62 then
            if u27[u51] == "__dead__" then
                u27[u51] = "__inflight__";
                task.defer(function() -- Line: 275
                    -- upvalues: u27 (ref), u51 (copy), u25 (ref)
                    if u27[u51] ~= "__inflight__" then
                        return;
                    end;

                    local v66, v67 = xpcall(function(p63) -- Line: 281
                        -- upvalues: u25 (ref)
                        local v64 = u25(p63);

                        if v64 ~= nil then
                            local v65 = typeof(v64) == "function";
                            assert(v65, "callback must return a function or nil");
                        end;

                        return v64;
                    end, debug.traceback, u51);

                    if v66 then
                        if u27[u51] == "__inflight__" then
                            u27[u51] = v67;
                        elseif v67 ~= nil then
                            task.spawn(v67);

                            return;
                        end;

                        return;
                    end;

                    local v68 = string.split(v67, "\n")[1];
                    local v69 = string.find(v68, ": ");

                    if v69 then
                        v68:sub(v69 + 1);
                    end;
                end);
            end;
        else
            local v70 = u27[u51];
            u27[u51] = "__dead__";

            if typeof(v70) == "function" then
                task.spawn(v70);
            end;
        end;
    end;

    u29 = CollectionService:GetInstanceAddedSignal(u24):Connect(onInstanceAdded);
    local u74 = CollectionService:GetInstanceRemovedSignal(u24):Connect(function(p71) -- Line: 347, Name: onInstanceRemoved
        -- upvalues: u27 (copy), u28 (copy)
        local v72 = u27[p71];
        u27[p71] = "__dead__";

        if typeof(v72) == "function" then
            task.spawn(v72);
        end;

        local v73 = u28[p71];

        if v73 then
            v73:Disconnect();
            u28[p71] = nil;
        end;

        u27[p71] = nil;
    end);
    task.defer(function() -- Line: 364
        -- upvalues: u29 (ref), CollectionService (ref), u24 (copy), onInstanceAdded (copy)
        if not u29.Connected then
            return;
        end;

        for _, v in CollectionService:GetTagged(u24) do
            task.spawn(onInstanceAdded, v);
        end;
    end);

    return function() -- Line: 375
        -- upvalues: u29 (ref), u74 (ref), u27 (copy), u28 (copy)
        u29:Disconnect();
        u74:Disconnect();
        local v75 = next(u27);

        while v75 do
            local v76 = u27[v75];
            u27[v75] = "__dead__";

            if typeof(v76) == "function" then
                task.spawn(v76);
            end;

            local v77 = u28[v75];

            if v77 then
                v77:Disconnect();
                u28[v75] = nil;
            end;

            u27[v75] = nil;
            v75 = next(u27);
        end;
    end;
end;

local Gardens = workspace:WaitForChild("Gardens");
local FruitProxyUtil = require(game.ReplicatedStorage.SharedModules.FruitProxyUtil);

local function getTools() -- Line: 404
    -- upvalues: u1 (copy), FruitProxyUtil (copy)
    local v78 = {};

    for _, child in u1.Backpack:GetChildren() do
        if child:IsA("Tool") or FruitProxyUtil.IsFruitProxy(child) then
            table.insert(v78, child);
        end;
    end;

    local Character = u1.Character;
    local v79 = Character and Character:FindFirstChildWhichIsA("Tool");

    if v79 then
        table.insert(v78, v79);
    end;

    return v78;
end;

local function isSeedTool(p80) -- Line: 422
    return p80:GetAttribute("SeedTool") and true or (string.find(p80.Name, "Seed") and true or false);
end;

local u81 = false;

return table.freeze({
    waitUntilDistance = function(p82, p83) -- Line: 190, Name: waitUntilDistance
        -- upvalues: u1 (copy)
        while not u1.Character or u1:DistanceFromCharacter(p82()) > p83 do
            task.wait(0.1);
        end;
    end,

    focusObject = focusObject,

    createArrow = function(u84, p85, p86) -- Line: 128, Name: createArrow
        -- upvalues: HttpService (copy), RunService (copy), TweenService (copy)
        HttpService:GenerateGUID(false);
        local u87 = p86 or 10;
        local u88 = script.Arrow:Clone();
        u88.CFrame = p85;
        u88.Parent = workspace;
        local u89 = u88:FindFirstChildWhichIsA("Beam");
        local u90 = not u89 and 0 or u89.Width0;
        local u91 = not u89 and 0 or u89.Width1;
        local u92 = false;

        local function onCharacterAdded(p93) -- Line: 141
            -- upvalues: u88 (copy)
            local HumanoidRootPart = p93:WaitForChild("HumanoidRootPart");

            if typeof(HumanoidRootPart) ~= "Instance" or not HumanoidRootPart:IsA("BasePart") then
                return;
            end;

            local RootAttachment = HumanoidRootPart:WaitForChild("RootAttachment");

            if typeof(RootAttachment) ~= "Instance" or not RootAttachment:IsA("Attachment") then
                return;
            end;

            u88.Beam.Attachment1 = RootAttachment;
        end;

        local u94 = u84.CharacterAdded:Connect(onCharacterAdded);

        if u84.Character then
            task.spawn(onCharacterAdded, u84.Character);
        end;

        local u97 = RunService.PreRender:Connect(function() -- Line: 160
            -- upvalues: u89 (copy), u84 (copy), u88 (copy), u87 (copy), u92 (ref), TweenService (ref), u90 (copy), u91 (copy)
            if not u89 then
                return;
            end;

            local v95 = u84:DistanceFromCharacter(u88.Position);
            local v96;

            if v95 > 0 then
                v96 = v95 <= u87;
            else
                v96 = false;
            end;

            if v96 == u92 then
                return;
            end;

            u92 = v96;

            if v96 then
                TweenService:Create(u89, TweenInfo.new(0.3), {
                    Width0 = 0,
                    Width1 = 0
                }):Play();

                return;
            end;

            TweenService:Create(u89, TweenInfo.new(0.3), {
                Width0 = u90,
                Width1 = u91
            }):Play();
        end);

        return table.freeze({
            move = function(p98) -- Line: 178, Name: move
                -- upvalues: u88 (copy)
                u88.CFrame = p98;
            end,

            destroy = function() -- Line: 182, Name: destroy
                -- upvalues: u97 (copy), u94 (copy), u88 (copy)
                u97:Disconnect();
                u94:Disconnect();
                u88:Destroy();
            end
        });
    end,

    observeTag = observeTag,

    pointToUI = function(u99, p100, p101, p102) -- Line: 501, Name: pointToUI
        -- upvalues: TutorialUI (copy), u81 (ref), Pointer (copy), createTween (copy), RunService (copy)
        local v103 = p101 or 1;

        while u81 do
            task.wait();
        end;

        u81 = true;

        local function updatePosition() -- Line: 520
            -- upvalues: u99 (copy), Pointer (ref)
            local v104 = u99(Pointer);

            if not v104 then
                Pointer.Visible = false;

                return;
            end;

            Pointer.Position = UDim2.fromOffset(v104.X, v104.Y);
            Pointer.Visible = true;
        end;

        task.spawn(updatePosition);
        Pointer.Image = p102 or "rbxassetid://7553620727";
        Pointer.Parent = p100 or TutorialUI;
        local v105 = Pointer:FindFirstChildWhichIsA("UIScale");

        if v105 then
            v105.Scale = v103;
        end;

        createTween(Pointer, TweenInfo.new(0.3), {
            ImageTransparency = 0
        });
        local u106;

        if v105 then
            u106 = createTween(v105, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                Scale = v103 * 1.1
            }, true);
        else
            u106 = nil;
        end;

        local u107 = RunService.PreRender:Connect(updatePosition);

        return function() -- Line: 550
            -- upvalues: u107 (copy), u106 (copy), createTween (ref), Pointer (ref), TutorialUI (ref), u81 (ref)
            if not u107.Connected then
                return;
            end;

            u107:Disconnect();

            if u106 then
                u106:Cancel();
            end;

            createTween(Pointer, TweenInfo.new(0.3), {
                ImageTransparency = 1
            }).Completed:Wait();
            Pointer.Visible = false;
            Pointer.Parent = TutorialUI;
            u81 = false;
        end;
    end,

    getPlayerPlot = function() -- Line: 390, Name: getPlayerPlot
        -- upvalues: u1 (copy), Gardens (copy)
        local v108 = u1:GetAttribute("PlotId");

        if not v108 then
            return nil;
        end;

        local v109 = Gardens:FindFirstChild((`Plot{v108}`));

        if v109 and v109:IsA("Model") then
            return v109;
        end;

        return nil;
    end,

    getTools = getTools,

    hasSeed = function() -- Line: 432, Name: hasSeed
        -- upvalues: getTools (copy)
        for _, v in getTools() do
            if v:GetAttribute("SeedTool") and true or (string.find(v.Name, "Seed") and true or false) then
                return true;
            end;
        end;

        return false;
    end,

    waitForSeed = function() -- Line: 441, Name: waitForSeed
        -- upvalues: getTools (copy), u1 (copy)
        local v110 = false;

        for _, v in getTools() do
            if v:GetAttribute("SeedTool") and true or (string.find(v.Name, "Seed") and true or false) then
                v110 = true;
                break;
            end;
        end;

        if v110 then
            return;
        end;

        local u111 = false;
        local u112 = nil;
        u112 = u1.Backpack.ChildAdded:Connect(function(p113) -- Line: 448
            -- upvalues: u111 (ref), u112 (ref)
            if p113:IsA("Tool") and (p113:GetAttribute("SeedTool") or string.find(p113.Name, "Seed")) then
                u111 = true;

                if u112 then
                    u112:Disconnect();
                    u112 = nil;
                end;
            end;
        end);

        while not u111 do
            local v114 = false;

            for _, v in getTools() do
                if v:GetAttribute("SeedTool") and true or (string.find(v.Name, "Seed") and true or false) then
                    v114 = true;
                    break;
                end;
            end;

            if v114 then
                u111 = true;
            end;

            task.wait(0.2);
        end;

        if u112 then
            u112:Disconnect();
            u112 = nil;
        end;
    end,

    waitUntilSeedEquipped = function() -- Line: 472, Name: waitUntilSeedEquipped
        -- upvalues: u1 (copy)
        while true do
            local Character = u1.Character;
            local v115;

            if Character then
                v115 = Character:FindFirstChildWhichIsA("Tool");
            else
                v115 = nil;
            end;

            if v115 and v115:GetAttribute("SeedTool") then
                return;
            end;

            task.wait(0.1);
        end;
    end,

    isInsidePlot = function(p116) -- Line: 483, Name: isInsidePlot
        -- upvalues: u1 (copy)
        local Character = u1.Character;

        if not Character then
            return false;
        end;

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
            return false;
        end;

        local v117, v118 = p116:GetBoundingBox();
        local v119 = v117:PointToObjectSpace(HumanoidRootPart.Position);
        local v120 = v118 * 0.5;
        local v121;

        if math.abs(v119.X) <= v120.X + 5 then
            v121 = math.abs(v119.Z) <= v120.Z + 5;
        else
            v121 = false;
        end;

        return v121;
    end
});