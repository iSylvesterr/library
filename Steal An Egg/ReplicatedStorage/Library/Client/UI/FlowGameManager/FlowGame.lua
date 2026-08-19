-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local Audio = require(ReplicatedStorage.Library.Audio);
local Generator = require(script.Generator);
local PathFinder = require(script.PathFinder);
local Settings = require(script.Settings);
local defaultButtonColor = Settings.defaultButtonColor;
local Assets = script.Assets;
local LocalPlayer = Players.LocalPlayer;
local u1 = LocalPlayer:GetMouse();
local u2 = 0;
local u3 = {
    Line = {
        updown = { Assets.VerticalLine },
        leftright = { Assets.HorizontalLine },
        downright = { Assets.HalfLineDown, Assets.HalfLineRight },
        downleft = { Assets.HalfLineDown, Assets.HalfLineLeft },
        upright = { Assets.HalfLineUp, Assets.HalfLineRight },
        upleft = { Assets.HalfLineUp, Assets.HalfLineLeft },
        up = { Assets.HalfLineUp },
        down = { Assets.HalfLineDown },
        left = { Assets.HalfLineLeft },
        right = { Assets.HalfLineRight }
    },
    Circle = {
        up = { Assets.HalfLineUp, Assets.Circle },
        down = { Assets.HalfLineDown, Assets.Circle },
        left = { Assets.HalfLineLeft, Assets.Circle },
        right = { Assets.HalfLineRight, Assets.Circle },
        none = { Assets.Circle }
    }
};
local u4 = {};
u4.__index = u4;

local function getDirection(p5, p6, p7, p8) -- Line: 166
    return p7 < p5 and "up" or (p5 < p7 and "down" or (p8 < p6 and "left" or (p6 < p8 and "right" or nil)));
end;

local function resolveSettings(p9) -- Line: 180
    -- upvalues: Settings (copy)
    local v10;

    if p9 and p9.Modifiers then
        v10 = {};
        local v11;

        if p9.Modifiers.NumberSkip == nil then
            v11 = Settings.Modifiers.NumberSkip;
        else
            v11 = p9.Modifiers.NumberSkip;
        end;

        v10.NumberSkip = v11;
        local v12;

        if p9.Modifiers.AllowBadColors == nil then
            v12 = Settings.Modifiers.AllowBadColors;
        else
            v12 = p9.Modifiers.AllowBadColors;
        end;

        v10.AllowBadColors = v12;
    else
        v10 = {
            NumberSkip = Settings.Modifiers.NumberSkip,
            AllowBadColors = Settings.Modifiers.AllowBadColors
        };
    end;

    local v13 = {};
    local v14;

    if p9 and p9.Colors ~= nil then
        v14 = p9.Colors;
    else
        v14 = Settings.Colors;
    end;

    v13.Colors = v14;
    local v15;

    if p9 and p9.DefaultGridSize ~= nil then
        v15 = p9.DefaultGridSize;
    else
        v15 = Settings.DefaultGridSize;
    end;

    v13.DefaultGridSize = v15;
    local v16;

    if p9 and p9.MustFillEntireGrid ~= nil then
        v16 = p9.MustFillEntireGrid;
    else
        v16 = Settings.MustFillEntireGrid;
    end;

    v13.MustFillEntireGrid = v16;
    local v17;

    if p9 and p9.BackgroundTransparency ~= nil then
        v17 = p9.BackgroundTransparency;
    else
        v17 = Settings.BackgroundTransparency;
    end;

    v13.BackgroundTransparency = v17;
    local v18;

    if p9 and p9.ButtonTransparency ~= nil then
        v18 = p9.ButtonTransparency;
    else
        v18 = Settings.ButtonTransparency;
    end;

    v13.ButtonTransparency = v18;
    local v19;

    if p9 and p9.PathFinderLengthLimit ~= nil then
        v19 = p9.PathFinderLengthLimit;
    else
        v19 = Settings.PathFinderLengthLimit;
    end;

    v13.PathFinderLengthLimit = v19;
    local v20;

    if p9 and p9.DefaultUIScaling ~= nil then
        v20 = p9.DefaultUIScaling;
    else
        v20 = Settings.DefaultUIScaling;
    end;

    v13.DefaultUIScaling = v20;
    local v21;

    if p9 and p9.DynamicUIScaling ~= nil then
        v21 = p9.DynamicUIScaling;
    else
        v21 = Settings.DynamicUIScaling;
    end;

    v13.DynamicUIScaling = v21;
    v13.Modifiers = v10;
    local v22;

    if p9 and p9.ConnectToTargetIfNearby ~= nil then
        v22 = p9.ConnectToTargetIfNearby;
    else
        v22 = Settings.ConnectToTargetIfNearby;
    end;

    v13.ConnectToTargetIfNearby = v22;
    local v23;

    if p9 and p9.defaultButtonColor ~= nil then
        v23 = p9.defaultButtonColor;
    else
        v23 = Settings.defaultButtonColor;
    end;

    v13.defaultButtonColor = v23;
    local v24;

    if p9 and p9.showNumbers ~= nil then
        v24 = p9.showNumbers;
    else
        v24 = Settings.showNumbers;
    end;

    v13.showNumbers = v24;

    return v13;
end;

local function shuffleTable(p25) -- Line: 229
    local v26 = table.clone(p25);

    for i = #v26, 2, -1 do
        local v27 = math.random(i);
        local v28 = v26[i];
        v26[i] = v26[v27];
        v26[v27] = v28;
    end;

    return v26;
end;

local function isNeighbour(p29, p30, p31, p32) -- Line: 240
    return p31 == p29 - 1 and p32 == p30 and "up" or (p31 == p29 + 1 and p32 == p30 and "down" or (p31 == p29 and p32 == p30 - 1 and "left" or (p31 == p29 and p32 == p30 + 1 and "right" or nil)));
end;

local function removeAfterCoordinates(p33, p34, p35) -- Line: 254
    local v36 = nil;

    for i, v in ipairs(p33) do
        if v.row == p34 and v.col == p35 then
            v36 = i;
            break;
        end;
    end;

    if v36 then
        for i = #p33, v36 + 1, -1 do
            table.remove(p33, i);
        end;
    end;
end;

local function sameLocation(p37, p38) -- Line: 271
    local v39;

    if p37.row == p38.row then
        v39 = p37.col == p38.col;
    else
        v39 = false;
    end;

    return v39;
end;

local function setConnection(p40, p41) -- Line: 275
    if p41 == "up" then
        p40.up = true;

        return;
    end;

    if p41 == "down" then
        p40.down = true;

        return;
    end;

    if p41 == "left" then
        p40.left = true;

        return;
    end;

    p40.right = true;
end;

local function generateColor(u42, p43) -- Line: 287
    local u44 = 0;

    local function isValidColor(p45) -- Line: 290
        -- upvalues: u44 (ref), u42 (copy)
        local v46 = (p45.R + p45.G + p45.B) / 3;

        if v46 < 0.6 or v46 > 0.8 then
            return false;
        end;

        if u44 <= 500 then
            for _, v in ipairs(u42) do
                if math.sqrt((v.R * 255 - p45.R * 255) ^ 2 + (v.G * 255 - p45.G * 255) ^ 2 + (v.B * 255 - p45.B * 255) ^ 2) < 75 then
                    return false;
                end;
            end;
        end;

        return true;
    end;

    Color3.fromRGB(0, 0, 0);
    local v47;

    repeat
        v47 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255));
        u44 = u44 + 1;
    until isValidColor(v47) or p43;

    return v47;
end;

local function clearGridFrame(p48) -- Line: 326
    for _, child in ipairs(p48:GetChildren()) do
        if not child:IsA("UIGridLayout") then
            child:Destroy();
        end;
    end;
end;

function u4.new(p49, p50, p51) -- Line: 334
    -- upvalues: u4 (copy), resolveSettings (copy), u2 (ref), Settings (copy), shuffleTable (copy)
    local v52 = setmetatable({}, u4);
    local v53 = resolveSettings(p51);
    u2 = u2 + 1;
    v52.id = u2;
    v52.GUI = p49;
    v52.containerFrame = v52.GUI.Container;
    v52.gridHolder = v52.containerFrame.GridHolder;
    v52.gridFrame = v52.gridHolder.Grid;
    v52.gridSize = p50 or Settings.DefaultGridSize;
    v52.colors = shuffleTable(v53.Colors);
    v52.paths = {};
    v52.targetPairs = {};
    v52.isDrawing = false;
    v52.drawingStart = nil;
    v52.gameEnded = false;
    v52.dragDebounce = {};
    v52.Connections = {};
    v52.Settings = v53;
    v52.Solution = {};
    v52.SolutionText = "";
    v52.completedEvent = nil;
    v52.skipNumber = nil;
    v52.connectDotSoundPlaybackSpeed = 0.8;
    v52:Init();

    return v52;
end;

function u4.Init(u54) -- Line: 365
    -- upvalues: clearGridFrame (copy), Assets (copy), UserInputService (copy), Generator (copy), generateColor (copy), TweenService (copy)
    clearGridFrame(u54.gridFrame);
    local v55 = 1 / u54.gridSize;
    u54.gridFrame.UIGridLayout.CellSize = UDim2.fromScale(v55, v55);
    u54.containerFrame.Size = UDim2.fromScale(0, 0);
    u54.containerFrame.Visible = true;
    u54.containerFrame:SetAttribute("ActiveFlowGameId", u54.id);

    for i = 1, u54.gridSize do
        for i2 = 1, u54.gridSize do
            local v56 = Assets.CellTemplate:Clone();
            v56.Name = i .. "-" .. i2;
            v56.Parent = u54.gridFrame;
            v56.BackgroundTransparency = u54.Settings.ButtonTransparency;
            v56.Button.MouseButton1Down:Connect(function() -- Line: 380
                -- upvalues: u54 (copy), i (copy), i2 (copy)
                u54:DragBegin(i, i2);
            end);
        end;
    end;

    table.insert(u54.Connections, UserInputService.InputEnded:Connect(function(p57) -- Line: 388
        -- upvalues: u54 (copy)
        if p57.UserInputType == Enum.UserInputType.MouseButton1 or (p57.UserInputType == Enum.UserInputType.Touch or p57.KeyCode == Enum.KeyCode.ButtonA) then
            u54:DragEnd();
        end;
    end));
    table.insert(u54.Connections, UserInputService.InputChanged:Connect(function(p58) -- Line: 401
        -- upvalues: u54 (copy)
        if p58.UserInputType == Enum.UserInputType.MouseMovement then
            u54:InputChanged(p58.Position);
        end;
    end));
    table.insert(u54.Connections, UserInputService.TouchMoved:Connect(function(p59) -- Line: 410
        -- upvalues: u54 (copy)
        u54:InputChanged(p59.Position);
    end));
    local v60, v61, _, v62 = Generator(u54.gridSize);
    u54.targetPairs = v60;
    u54.Solution = v61;
    u54.SolutionText = v62;

    for i = 1, #u54.targetPairs do
        u54.paths[i] = {};
        u54.dragDebounce[i] = 0;

        if not u54.colors[i] then
            local colors = u54.colors;
            local v63 = generateColor(u54.colors, u54.Settings.Modifiers.AllowBadColors);
            table.insert(colors, v63);
        end;
    end;

    if u54.Settings.Modifiers.NumberSkip then
        u54.skipNumber = math.random(1, #u54.targetPairs);
    end;

    u54:updateGui();
    TweenService:Create(u54.containerFrame, TweenInfo.new(0.45), {
        Size = UDim2.fromScale(0.4, 1)
    }):Play();
end;

function u4.DragBeginConsole(p64) -- Line: 440
end;

function u4.DragBegin(p65, p66, p67) -- Line: 442
    -- upvalues: removeAfterCoordinates (copy)
    if p65.gameEnded then
        return;
    end;

    for i, v in ipairs(p65.targetPairs) do
        for _, v2 in ipairs(v) do
            if v2.row == p66 and v2.col == p67 then
                local v68 = p65.dragDebounce[i];
                assert(v68, "Expected drag debounce for target pair");

                if os.clock() - v68 < 0.25 then
                    return;
                end;

                p65.isDrawing = true;
                p65.drawingStart = {
                    row = p66,
                    col = p67,
                    color = i
                };
                p65.paths[i] = {
                    {
                        row = p66,
                        col = p67
                    }
                };
                local v69 = v[1];
                local v70 = v[2];
                assert(v69 and v70, "Expected pair endpoints");
                p65:CircleEffect(p66, p67);
                p65:CircleEffect(v69.row, v69.col, true);
                p65:CircleEffect(v70.row, v70.col, true);
                p65:DragBeginConsole();
                p65:updateGui();

                return;
            end;
        end;
    end;

    for i, v in ipairs(p65.paths) do
        for _, v2 in ipairs(v) do
            if v2.row == p66 and v2.col == p67 then
                removeAfterCoordinates(v, v2.row, v2.col);
                p65.isDrawing = true;
                local v71 = v[1];
                assert(v71, "Expected existing path start");
                p65.drawingStart = {
                    row = v71.row,
                    col = v71.col,
                    color = i
                };
                p65:DragBeginConsole();
                p65:updateGui();

                return;
            end;
        end;
    end;
end;

function u4.DragEnd(p72) -- Line: 508
    if not p72.isDrawing then
        return;
    end;

    local drawingStart = p72.drawingStart;
    assert(drawingStart, "Expected drawing start while drawing");
    local color = drawingStart.color;
    local v73 = p72.paths[color];
    assert(v73, "Expected path for active color");

    if #v73 <= 1 then
        p72.paths[color] = {};
        v73 = p72.paths[color];
    end;

    if p72.Settings.ConnectToTargetIfNearby and (#v73 > 1 and v73[#v73]) then
        local v74 = v73[#v73];
        assert(v74, "Expected path tail");
        local v75 = p72.targetPairs[color];
        assert(v75, "Expected target pair for active color");
        local v76 = v75[1];
        assert(v76 and v75[2], "Expected target pair endpoints");
        local v77;

        if drawingStart.row == v76.row then
            v77 = drawingStart.col == v76.col;
        else
            v77 = false;
        end;

        local v78 = v75[v77 and 2 or 1];
        assert(v78, "Expected target cell");
        local v79;

        if v74.row == v78.row then
            v79 = v74.col == v78.col;
        else
            v79 = false;
        end;

        local row = v74.row;
        local col = v74.col;
        local row2 = v78.row;
        local col2 = v78.col;
        local v80 = row2 == row - 1 and col2 == col and "up" or (row2 == row + 1 and col2 == col and "down" or (row2 == row and col2 == col - 1 and "left" or (row2 == row and col2 == col + 1 and "right" or nil)));

        if v79 then
            p72.dragDebounce[color] = os.clock();
        elseif v80 then
            table.insert(p72.paths[color], {
                row = v78.row,
                col = v78.col
            });
            p72.dragDebounce[color] = os.clock();
        end;
    end;

    p72.isDrawing = false;
    p72.drawingStart = nil;
    p72:updateGui();
    p72:checkForWin();
end;

function u4.GetCellAtMousePosition(p81, p82) -- Line: 560
    -- upvalues: u1 (copy), LocalPlayer (copy)
    local SelectedObject = game.GuiService.SelectedObject;

    if SelectedObject and SelectedObject.Parent then
        for _, child in pairs(p81.gridFrame:GetChildren()) do
            if SelectedObject.Parent == child then
                return child;
            end;
        end;
    end;

    local v83 = Vector2.new(u1.X, u1.Y);
    local v84 = LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(v83.X, v83.Y);

    for _, v in pairs(v84) do
        if v.Parent == p81.gridFrame then
            return v;
        end;
    end;

    return nil;
end;

function u4.InputChanged(p85, p86) -- Line: 581
    -- upvalues: Audio (copy), removeAfterCoordinates (copy), PathFinder (copy)
    if p85.gameEnded or not p85.isDrawing then
        return;
    end;

    local v87 = p85:GetCellAtMousePosition(p86);

    if not v87 then
        return;
    end;

    local v88, v89 = v87.Name:match("(%d+)-(%d+)");

    if not (v88 and v89) then
        return;
    end;

    local v90 = tonumber(v88);
    local v91 = tonumber(v89);

    if not (v90 and v91) then
        return;
    end;

    local v92 = p85:getGrid();
    local drawingStart = p85.drawingStart;
    assert(drawingStart, "Expected drawing start while drawing");
    local color = drawingStart.color;
    local v93 = p85.paths[color];
    assert(v93, "Expected current path for active color");
    local v94 = v93[#v93];
    local v95 = v93[1];
    assert(v94 and v95, "Expected current path endpoints");
    local row = v94.row;
    local col = v94.col;
    local v96;

    if v92[row][col].status == "target" and v92[row][col].color == color then
        v96 = row ~= v95.row and true or col ~= v95.col;
    else
        v96 = false;
    end;

    local v97;

    if v92[v90][v91].status == "empty" then
        v97 = true;
    elseif v92[v90][v91].status == "target" then
        v97 = v92[v90][v91].color == color;
    else
        v97 = false;
    end;

    local v98 = false;

    for _, v in ipairs(v93) do
        if v.row == v90 and v.col == v91 then
            v98 = true;
            break;
        end;
    end;

    if (v90 == row - 1 and v91 == col and "up" or (v90 == row + 1 and v91 == col and "down" or (v90 == row and v91 == col - 1 and "left" or (v90 == row and v91 == col + 1 and "right" or nil)))) and (v97 and not (v96 or v98)) then
        table.insert(v93, {
            row = v90,
            col = v91
        });
        p85:updateGui();

        if v92[v90][v91].status == "target" then
            p85:CircleEffect(v90, v91);
            Audio.Play(109971761033199, script, p85.connectDotSoundPlaybackSpeed, 1.9);
            p85.connectDotSoundPlaybackSpeed = math.min(p85.connectDotSoundPlaybackSpeed + 0.08, 1.35);
        end;

        return;
    end;

    if not v98 then
        if v97 and (not v96 and p85.Settings.PathFinderLengthLimit > 0) then
            local v99 = PathFinder.new(v92, v94, {
                row = v90,
                col = v91
            }, p85.Settings.PathFinderLengthLimit);

            if v99:isPathAvailable() then
                for _, v in ipairs(v99:shortestPath()) do
                    table.insert(v93, v);
                    p85:updateGui();
                end;
            end;
        end;

        return;
    end;

    removeAfterCoordinates(v93, v90, v91);
    p85:updateGui();
end;

function u4.getGrid(p100, p101) -- Line: 682
    local v102 = {};

    for i = 1, p100.gridSize do
        v102[i] = {};

        for i2 = 1, p100.gridSize do
            v102[i][i2] = {
                status = "empty",
                color = nil,
                connections = {}
            };
        end;
    end;

    if p101 then
        return v102;
    end;

    for i, v in ipairs(p100.paths) do
        if #v > 0 then
            for i2 = 1, #v do
                local v103 = v[i2 - 1];
                local v104 = v[i2];
                local v105 = v[i2 + 1];
                local v106 = {};
                assert(v104, "Expected current path cell");

                if v103 then
                    local row = v104.row;
                    local col = v104.col;
                    local row2 = v103.row;
                    local col2 = v103.col;
                    local v107 = row2 < row and "up" or (row < row2 and "down" or (col2 < col and "left" or (col < col2 and "right" or nil)));

                    if v107 then
                        if v107 == "up" then
                            v106.up = true;
                        elseif v107 == "down" then
                            v106.down = true;
                        elseif v107 == "left" then
                            v106.left = true;
                        else
                            v106.right = true;
                        end;
                    end;
                end;

                if v105 then
                    local row = v104.row;
                    local col = v104.col;
                    local row2 = v105.row;
                    local col2 = v105.col;
                    local v108 = row2 < row and "up" or (row < row2 and "down" or (col2 < col and "left" or (col < col2 and "right" or nil)));

                    if v108 then
                        if v108 == "up" then
                            v106.up = true;
                        elseif v108 == "down" then
                            v106.down = true;
                        elseif v108 == "left" then
                            v106.left = true;
                        else
                            v106.right = true;
                        end;
                    end;
                end;

                v102[v104.row][v104.col].status = "path";
                v102[v104.row][v104.col].color = i;
                v102[v104.row][v104.col].connections = v106;
            end;
        end;
    end;

    for i, v in ipairs(p100.targetPairs) do
        for _, v2 in ipairs(v) do
            v102[v2.row][v2.col].status = "target";
            v102[v2.row][v2.col].color = i;
        end;
    end;

    return v102;
end;

function u4.updateGui(p109) -- Line: 742
    -- upvalues: TweenService (copy), defaultButtonColor (copy)
    local v110 = p109:getGrid();

    for i = 1, p109.gridSize do
        for i2 = 1, p109.gridSize do
            local v111 = p109.gridFrame:FindFirstChild(i .. "-" .. i2);

            if v111 then
                local v112 = v110[i][i2];

                if v112.status == "empty" then
                    p109:clearAssets(i, i2);
                    TweenService:Create(v111.Button, TweenInfo.new(0.15), {
                        BackgroundColor3 = defaultButtonColor
                    }):Play();
                elseif v112.status == "target" then
                    local color = v112.color;
                    assert(color, "Expected color index for target cell");
                    p109:updateAssets(i, i2, "Circle", p109.colors[color], v112.connections);
                    local Circle = v111:FindFirstChild("Circle");
                    assert(Circle, "Expected circle asset for target cell");

                    if p109.Settings.showNumbers then
                        Circle.Number.Text = tostring(color + (p109.skipNumber and p109.skipNumber <= color and 1 or 0));
                        Circle.Number.Visible = true;
                    else
                        Circle.Number.Visible = false;
                    end;

                    local v113 = p109.paths[color];
                    assert(v113, "Expected path collection for target cell");
                    local v114 = false;

                    for _, v in ipairs(v113) do
                        if v.row == i and v.col == i2 then
                            v114 = true;
                            break;
                        end;
                    end;

                    if v114 then
                        TweenService:Create(v111.Button, TweenInfo.new(0.15), {
                            BackgroundColor3 = defaultButtonColor:Lerp(p109.colors[color], 0.3)
                        }):Play();
                    else
                        TweenService:Create(v111.Button, TweenInfo.new(0.15), {
                            BackgroundColor3 = defaultButtonColor
                        }):Play();
                    end;
                elseif v112.status == "path" then
                    local color = v112.color;
                    assert(color, "Expected color index for path cell");
                    p109:updateAssets(i, i2, "Line", p109.colors[color], v112.connections);
                    TweenService:Create(v111.Button, TweenInfo.new(0.15), {
                        BackgroundColor3 = defaultButtonColor:Lerp(p109.colors[color], 0.3)
                    }):Play();
                end;
            end;
        end;
    end;
end;

function u4.clearAssets(p115, p116, p117) -- Line: 807
    local v118 = p115.gridFrame:FindFirstChild(p116 .. "-" .. p117);

    if not v118 then
        return;
    end;

    for _, child in ipairs(v118:GetChildren()) do
        if child.Name ~= "Button" and child.Name ~= "Effects" then
            child:Destroy();
        end;
    end;
end;

function u4.updateAssets(p119, p120, p121, p122, p123, p124) -- Line: 820
    -- upvalues: u3 (copy)
    local v125 = "";

    if p124.up then
        v125 = v125 .. "up";
    end;

    if p124.down then
        v125 = v125 .. "down";
    end;

    if p124.left then
        v125 = v125 .. "left";
    end;

    if p124.right then
        v125 = v125 .. "right";
    end;

    local v126 = u3[p122][v125 == "" and "none" or v125];
    local v127 = p119.gridFrame:FindFirstChild(p120 .. "-" .. p121);

    if not (v126 and v127) then
        return;
    end;

    p119:clearAssets(p120, p121);

    for _, v in v126 do
        local v128 = v:Clone();
        v128.Parent = v127;
        v128.BackgroundColor3 = p123;
    end;
end;

function u4.EndGame(u129, p130) -- Line: 861
    -- upvalues: LocalPlayer (copy), TweenService (copy), clearGridFrame (copy)
    u129.gameEnded = true;
    u129.isDrawing = false;
    u129.drawingStart = nil;

    for _, v in pairs(u129.Connections) do
        v:Disconnect();
    end;

    u129.Connections = {};

    if u129.completedEvent and p130 ~= nil then
        local completedEvent = u129.completedEvent;
        u129.completedEvent = nil;
        completedEvent:Fire(p130 and "finishedPuzzle" or "leaveGenerator");
        completedEvent:Destroy();
    end;

    if p130 then
        LocalPlayer:SetAttribute("CompletedGenPuzzle", true);

        return;
    end;

    task.spawn(function() -- Line: 883
        -- upvalues: u129 (copy), TweenService (ref), clearGridFrame (ref)
        if u129.containerFrame:GetAttribute("ActiveFlowGameId") ~= u129.id then
            return;
        end;

        local v131 = TweenService:Create(u129.containerFrame, TweenInfo.new(0.5), {
            Size = UDim2.new()
        });
        v131.Completed:Once(function() -- Line: 891
            -- upvalues: u129 (ref), clearGridFrame (ref)
            if u129.containerFrame.Parent and u129.containerFrame:GetAttribute("ActiveFlowGameId") == u129.id then
                u129.containerFrame.Visible = false;
                u129.containerFrame:SetAttribute("ActiveFlowGameId", nil);
                clearGridFrame(u129.gridFrame);
            end;
        end);
        v131:Play();
    end);
end;

function u4.checkForWin(p132) -- Line: 905
    if p132:checkWin() then
        p132:EndGame(true);
    end;
end;

function u4.checkWin(p133) -- Line: 911
    for i, v in ipairs(p133.targetPairs) do
        local v134 = p133.paths[i];
        assert(v134, "Expected path for win check");

        if #v134 < 2 then
            return false;
        end;

        local v135 = v[1];
        local v136 = v[2];
        local v137 = v134[1];
        local v138 = v134[#v134];
        local v139;

        if v135 then
            if v136 then
                if v137 then
                    v139 = v138;
                else
                    v139 = v137;
                end;
            else
                v139 = v136;
            end;
        else
            v139 = v135;
        end;

        assert(v139, "Expected path and target endpoints");
        local v140;

        if v137.row == v135.row then
            v140 = v137.col == v135.col;
        else
            v140 = false;
        end;

        if v140 then
            if v138.row == v136.row then
                v140 = v138.col == v136.col;
            else
                v140 = false;
            end;
        end;

        local v141;

        if v137.row == v136.row then
            v141 = v137.col == v136.col;
        else
            v141 = false;
        end;

        if v141 then
            if v138.row == v135.row then
                v141 = v138.col == v135.col;
            else
                v141 = false;
            end;
        end;

        if not (v140 or v141) then
            return false;
        end;
    end;

    if not p133.Settings.MustFillEntireGrid then
        return true;
    end;

    local v142 = 0;

    for _, v in ipairs(p133.paths) do
        for _ in ipairs(v) do
            v142 = v142 + 1;
        end;
    end;

    return v142 == p133.gridSize * p133.gridSize;
end;

function u4.CircleEffect(p143, p144, p145, p146) -- Line: 947
    -- upvalues: TweenService (copy), Debris (copy)
    local v147 = p143.gridFrame:FindFirstChild(p144 .. "-" .. p145);

    if not v147 then
        return;
    end;

    local Circle = v147:FindFirstChild("Circle");

    if not Circle then
        return;
    end;

    local v148 = Circle:Clone();
    local Number = v148:FindFirstChild("Number");

    if Number then
        Number:Destroy();
    end;

    v148.Parent = v147.Effects;

    if p146 then
        TweenService:Create(v148, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, true, 0), {
            Size = UDim2.fromScale(0.8, 0.8)
        }):Play();
        Debris:AddItem(v148, 0.4);

        return;
    end;

    TweenService:Create(v148, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }):Play();
    Debris:AddItem(v148, 0.45);
end;

return u4;