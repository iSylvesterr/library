-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local u1 = {};
local u2 = {};

function u1.new(p3, p4) -- Line: 22
    -- upvalues: u2 (copy)
    local v5 = {
        Tension = p4 or 0.5,
        Points = {},
        LengthIterations = 1000,
        LengthIndices = {},
        Length = 0,
        ConnectedSplines = {},
        _connections = {}
    };

    if p3 ~= nil then
        for _, v in pairs(p3) do
            u2.AddPoint(v5, v);
        end;
    end;

    setmetatable(v5, {
        __index = u2,

        __newindex = function(p6, p7, p8) -- Line: 44, Name: __newindex
            error("Cannot add new indices to CatmullRomSplineObject!");
        end
    });

    return v5;
end;

function u2.ChangeTension(p9, p10) -- Line: 57
    -- upvalues: u2 (copy)
    if type(p10) ~= "number" then
        error("CatmullRomSpline:ChangeTension() expected a number as an input, got " .. tostring(p10) .. "!");
    end;

    p9.Tension = p10;
    u2.UpdateLength(p9);
end;

function u2.ChangeAllSplineTensions(p11, p12) -- Line: 70
    -- upvalues: u2 (copy)
    if type(p12) ~= "number" then
        error("CatmullRomSpline:ChangeAllSplineTensions() expected a number as an input, got " .. tostring(p12) .. "!");
    end;

    local v13 = u2.GetSplines(p11);

    for _, v in pairs(v13) do
        v:ChangeTension(p12);
    end;
end;

function u2.AddPoint(u14, p15, p16) -- Line: 86
    -- upvalues: u2 (copy), u1 (copy)
    local Points = u14.Points;

    local function checkIfPointsMatch(p17) -- Line: 89
        -- upvalues: u2 (ref), u14 (copy)
        local v18 = u2.GetPoints(u14);

        for _, v in pairs(v18) do
            if typeof(v) ~= typeof(p17) then
                return false;
            end;
        end;

        return true;
    end;

    if #Points == 4 then
        if typeof(p15) == "number" or (typeof(p15) == "Vector2" or typeof(p15) == "Vector3") then
            if checkIfPointsMatch(p15) then
                local v19 = u2.GetSplines(u14);
                local v20 = v19[#v19];
                local v21 = u1.new({
                    v20.Points[2],
                    v20.Points[3],
                    v20.Points[4],
                    p15
                }, v20.Tension);
                u2.ConnectSpline(u14, v21);
            end;
        elseif p15:IsA("BasePart") and checkIfPointsMatch(p15.Position) then
            local v22 = u2.GetSplines(u14);
            local v23 = v22[#v22];
            local v24 = u1.new({
                v23.Points[2],
                v23.Points[3],
                v23.Points[4],
                p15
            }, v23.Tension);
            u2.ConnectSpline(u14, v24);
        end;
    elseif typeof(p15) == "number" then
        if checkIfPointsMatch(p15) then
            table.insert(Points, p16 or #Points + 1, p15);
        end;
    elseif typeof(p15) == "Vector2" then
        if checkIfPointsMatch(p15) then
            table.insert(Points, p16 or #Points + 1, p15);
        end;
    elseif typeof(p15) == "Vector3" then
        if checkIfPointsMatch(p15) then
            table.insert(Points, p16 or #Points + 1, p15);
        end;
    elseif p15:IsA("BasePart") then
        if checkIfPointsMatch(p15.Position) then
            table.insert(Points, p16 or #Points + 1, p15);
            u14._connections[p15] = p15.Changed:Connect(function(p25) -- Line: 131
                -- upvalues: u2 (ref), u14 (copy)
                if p25 == "Position" then
                    u2.UpdateLength(u14);
                end;
            end);
        end;
    else
        error("Invalid input received for CatmullRomSpline:AddPoint(), expected Vector3 or BasePart, got " .. tostring(p15) .. "!");
    end;

    if #Points == 4 then
        u2.UpdateLength(u14);
    end;
end;

function u2.RemovePoint(p26, p27) -- Line: 150
    if type(p) ~= "number" then
        error("CatmullRomSpline:RemovePoint() expected a number as the input, got " .. tostring(p27) .. "!");
    end;

    local v28 = table.remove(p26.Points, p27);

    if v28 ~= nil and (typeof(v28) == "Instance" and (v28:IsA("BasePart") and p26._connections[v28])) then
        p26._connections[v28]:Disconnect();
        p26._connections[v28] = nil;
    end;
end;

function u2.GetPoints(p29) -- Line: 170
    local v30 = {};

    for i = 1, #p29.Points do
        v30[i] = typeof(p29.Points[i]) == "Instance" and p29.Points[i].Position or p29.Points[i];
    end;

    return v30;
end;

function u2.ConnectSpline(u31, p32) -- Line: 187
    -- upvalues: u2 (copy)
    local Points = p32.Points;
    local v33 = u2.GetSplines(u31);
    local Points2 = v33[#v33].Points;

    if not (function(p34) -- Line: 195, Name: checkIfPointsMatch
        -- upvalues: u2 (ref), u31 (copy)
        local v35 = u2.GetPoints(u31);

        for _, v in pairs(v35) do
            if typeof(v) ~= typeof(p34) then
                return false;
            end;
        end;

        return true;
    end)((typeof(Points2[1]) == "number" or typeof(Points2[1]) == "Vector3") and Points2[1] or Points2[1].Position) then
        error("Cannot connect the spline because the splines do not have the same types of points!");
    end;

    if Points2[2] ~= Points[1] or (Points2[3] ~= Points[2] or Points2[4] ~= Points[3]) then
        error("Cannot connect the spline because the splines do not share 3 common points!");

        return;
    end;

    table.insert(u31.ConnectedSplines, p32);
    u2.UpdateLength(u31);
end;

function u2.GetSplines(p36) -- Line: 218
    local v37 = { p36 };

    for i = 1, #p36.ConnectedSplines do
        table.insert(v37, p36.ConnectedSplines[i]);
    end;

    return v37;
end;

function u2.GetSplineAt(p38, p39) -- Line: 230
    -- upvalues: u2 (copy)
    local v40 = u2.GetSplines(p38);

    local function percentage(p41, p42, p43) -- Line: 235
        local v44 = 1 / (p43 - p42);

        return v44 * p41 - v44 * p43 + 1;
    end;

    if type(p39) ~= "number" then
        error("CatmullRomSpline:GetSplineAt() expected a number as an input, got " .. tostring(p39) .. "!");
    end;

    if #v40 == 1 then
        return p38, p39;
    end;

    local v45 = 1 / #v40;

    if p39 <= 0 then
        return p38, p39 * v45;
    end;

    if p39 >= 1 then
        return v40[#v40], (p39 - 1) * v45 + 1;
    end;

    local v46 = math.ceil(p39 * #v40);
    local v47 = v46 * v45;
    local v48 = 1 / (v47 - (v46 - 1) * v45);

    return v40[v46], v48 * p39 - v48 * v47 + 1;
end;

function u2.UpdateLength(p49) -- Line: 265
    -- upvalues: u2 (copy)
    local v50 = u2.GetSplines(p49);
    local v51 = {};
    local v52 = 0;

    for i, v in pairs(v50) do
        local v53 = u2.GetPoints(v);

        if #v53 ~= 4 then
            error("Cannot get the length of the CatmullRomSpline object, expected 4 control points for all splines, got " .. tostring(#v51) .. " points for spline " .. tostring(i) .. "!");
        end;

        for _, v2 in pairs(v53) do
            table.insert(v51, v2);
        end;
    end;

    local LengthIterations = p49.LengthIterations;
    local v54 = {};

    for i = 1, LengthIterations do
        local v55 = u2.CalculateDerivativeAt(p49, (i - 1) / (LengthIterations - 1));

        if typeof(v55) == "number" then
            v52 = v52 + v55 * (1 / LengthIterations);
        else
            v52 = v52 + v55.Magnitude * (1 / LengthIterations);
        end;

        table.insert(v54, { (i - 1) / (LengthIterations - 1), v52, v55 });
    end;

    p49.Length = v52;
    p49.LengthIndices = v54;
end;

function u2.CalculatePositionAt(p56, p57) -- Line: 301
    -- upvalues: u2 (copy)
    if type(p57) ~= "number" then
        error("The given t value in CatmullRomSpline:CalculatePositionAt() was not between 0 and 1, got " .. tostring(p57) .. "!");
    end;

    local v58, v59 = u2.GetSplineAt(p56, p57);
    local v60 = u2.GetPoints(v58);

    if #v60 ~= 4 then
        error("The CatmullRomSpline object has an invalid number of points (" .. tostring(#v60) .. "), expected 4 points!");
    end;

    local Tension = v58.Tension;

    return v60[2] + Tension * (v60[3] - v60[1]) * v59 + (3 * (v60[3] - v60[2]) - Tension * (v60[4] - v60[2]) - 2 * Tension * (v60[3] - v60[1])) * v59 ^ 2 + (-2 * (v60[3] - v60[2]) + Tension * (v60[4] - v60[2]) + Tension * (v60[3] - v60[1])) * v59 ^ 3;
end;

function u2.CalculatePositionRelativeToLength(p61, p62) -- Line: 330
    -- upvalues: u2 (copy)
    if type(p62) ~= "number" then
        error("CatmullRomSpline:CalculatePositionRelativeToLength() only accepts a number, got " .. tostring(p62) .. "!");
    end;

    local Points = p61.Points;

    if #Points ~= 4 then
        error("The CatmullRomSpline object has an invalid number of points (" .. tostring(#Points) .. "), expected 4 points!");

        return;
    end;

    local Length = p61.Length;
    local LengthIndices = p61.LengthIndices;
    local _ = p61.LengthIterations;
    u2.GetPoints(p61);
    local v63 = Length * p62;
    local v64 = nil;
    local v65 = nil;

    for i, v in ipairs(LengthIndices) do
        if v63 - v[2] <= 0 or i == #LengthIndices then
            v65 = v;
            v64 = i;
            break;
        end;
    end;

    local v66, v67;

    if LengthIndices[v64 - 1] then
        v66 = u2.CalculatePositionAt(p61, LengthIndices[v64 - 1][1]);
        v67 = u2.CalculatePositionAt(p61, v65[1]);
    else
        v66 = u2.CalculatePositionAt(p61, v65[1]);
        v67 = u2.CalculatePositionAt(p61, LengthIndices[v64 + 1][1]);
    end;

    if typeof(v66) == "number" and typeof(v67) == "number" then
        return v66 + (v67 - v66) * (1 - (v65[2] - v63) / (v67 - v66));
    end;

    return v66 + (v67 - v66) * (1 - (v65[2] - v63) / (v67 - v66).Magnitude);
end;

function u2.CalculateDerivativeAt(p68, p69) -- Line: 387
    -- upvalues: u2 (copy)
    if type(p69) ~= "number" then
        error("The given t value in CatmullRomSpline:CalculateDerivativeAt() was not between 0 and 1, got " .. tostring(p69) .. "!");
    end;

    local v70, v71 = u2.GetSplineAt(p68, p69);
    local v72 = u2.GetPoints(v70);

    if #v72 ~= 4 then
        error("The CatmullRomSpline object has an invalid number of points (" .. tostring(#v72) .. "), expected 4 points!");
    end;

    local Tension = v70.Tension;

    return Tension * (v72[3] - v72[1]) + 2 * (3 * (v72[3] - v72[2]) - Tension * (v72[4] - v72[2]) - 2 * Tension * (v72[3] - v72[1])) * v71 + 3 * (-2 * (v72[3] - v72[2]) + Tension * (v72[4] - v72[2]) + Tension * (v72[3] - v72[1])) * v71 ^ 2;
end;

function u2.CalculateDerivativeRelativeToLength(p73, p74) -- Line: 415
    -- upvalues: u2 (copy)
    if type(p74) ~= "number" then
        error("CatmullRomSpline:CalculateDerivativeRelativeToLength() only accepts a number, got " .. tostring(p74) .. "!");
    end;

    local Points = p73.Points;

    if #Points ~= 4 then
        error("The CatmullRomSpline object has an invalid number of points (" .. tostring(#Points) .. "), expected 4 points!");

        return;
    end;

    local Length = p73.Length;
    local LengthIndices = p73.LengthIndices;
    local _ = p73.LengthIterations;
    u2.GetPoints(p73);
    local v75 = Length * p74;
    local v76 = nil;
    local v77 = nil;

    for i, v in ipairs(LengthIndices) do
        if v75 - v[2] <= 0 or i == #LengthIndices then
            v77 = v;
            v76 = i;
            break;
        end;
    end;

    local v78, v79;

    if LengthIndices[v76 - 1] then
        v78 = u2.CalculateDerivativeAt(p73, LengthIndices[v76 - 1][1]);
        v79 = u2.CalculateDerivativeAt(p73, v77[1]);
    else
        v78 = u2.CalculateDerivativeAt(p73, v77[1]);
        v79 = u2.CalculateDerivativeAt(p73, LengthIndices[v76 + 1][1]);
    end;

    local v80;

    if typeof(v78) == "number" and typeof(v79) == "number" then
        v80 = math.abs(v79 - v78) <= 0 and 0 or (v77[2] - v75) / (v79 - v78);
    else
        v80 = (v79 - v78).Magnitude <= 0 and 0 or (v77[2] - v75) / (v79 - v78).Magnitude;
    end;

    return v78 + (v79 - v78) * (1 - v80);
end;

function u2.CreateTween(u81, u82, p83, u84, u85) -- Line: 483
    -- upvalues: TweenService (copy), u2 (copy)
    if typeof(u82) ~= "Instance" then
        error("CatmullRomSplineObject:CreateTween() expected an instance as the first input, got " .. tostring(u82) .. "!");
    end;

    if typeof(p83) ~= "TweenInfo" then
        error("CatmullRomSplineObject:CreateTween() expected a TweenInfo object as the second input, got " .. tostring(p83) .. "!");
    end;

    local v86 = true;

    for _, v in pairs(u84) do
        local success, result = pcall(function() -- Line: 497
            -- upvalues: u82 (copy), v (copy)
            return u82[v];
        end);

        if not success or result == nil then
            v86 = false;
        end;
    end;

    if not v86 then
        error("CatmullRomSplineObject:CreateTween() was given properties in the property table that do not belong to the instance!");
    end;

    local NumberValue = Instance.new("NumberValue");
    local u87 = TweenService:Create(NumberValue, p83, {
        Value = 1
    });
    local u88 = nil;
    u87.Changed:Connect(function(p89) -- Line: 512
        -- upvalues: u87 (copy), u88 (ref), NumberValue (copy), u84 (copy), u85 (copy), u2 (ref), u81 (copy), u82 (copy)
        if p89 == "PlaybackState" then
            if u87.PlaybackState == Enum.PlaybackState.Playing then
                u88 = NumberValue.Changed:Connect(function(p90) -- Line: 516
                    -- upvalues: u84 (ref), u85 (ref), u2 (ref), u81 (ref), u82 (ref)
                    for _, v in pairs(u84) do
                        local v91 = u85 and u2.CalculatePositionRelativeToLength(u81, p90) or u2.CalculatePositionAt(u81, p90);
                        local v92 = u85 and u2.CalculateDerivativeRelativeToLength(u81, p90) or u2.CalculateDerivativeAt(u81, p90);

                        if typeof(v91) == "Vector3" and typeof(v92) == "Vector3" then
                            v91 = CFrame.new(v91, v91 + v92) or v91;
                        end;

                        if typeof(u82[v]) == "number" or (typeof(u82[v] == "Vector2") or typeof(u82[v]) == "CFrame") then
                            u82[v] = v91;
                        elseif typeof(u82[v] == "Vector3") then
                            u82[v] = v91.Position;
                        else
                            error("CatmullRomSplineObject:CreateTween() could not set the value of the instance property " .. tostring(v) .. ", not a numerical value!");
                        end;
                    end;
                end);

                return;
            end;

            if u88 ~= nil then
                u88:Disconnect();
                u88 = nil;
            end;
        end;
    end);

    return u87;
end;

return u1;