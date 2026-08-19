-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function B(p2, p3, p4)
    local function fact(p5) -- Line: 23
        -- upvalues: fact (copy)
        return p5 == 0 and 1 or p5 * fact(p5 - 1);
    end;

    local v6 = p2 == 0 and 1 or p2 * fact(p2 - 1);
    local v7 = p3 == 0 and 1 or p3 * fact(p3 - 1);
    local v8 = p2 - p3;

    return v6 / (v7 * (v8 == 0 and 1 or v8 * fact(v8 - 1))) * p4 ^ p3 * (1 - p4) ^ (p2 - p3);
end;

function u1.new(...) -- Line: 38
    -- upvalues: u1 (copy)
    local v9 = setmetatable({}, u1);
    v9.Points = {};
    v9.LengthIterations = 1000;
    v9.LengthIndeces = {};
    v9.Length = 0;
    v9._connections = {};

    for _, v in pairs({ ... }) do
        if typeof(v) == "Vector3" or typeof(v) == "Instance" and v:IsA("BasePart") then
            v9:AddBezierPoint(v);
        else
            error("The Bezier.new() constructor only takes in Vector3s and BaseParts as inputs!");
        end;
    end;

    return v9;
end;

function u1.AddBezierPoint(u10, p11, p12) -- Line: 70
    if (not p11 or (typeof(p11) ~= "Instance" or not p11:IsA("BasePart"))) and typeof(p11) ~= "Vector3" then
        error("Bezier:AddBezierPoint() only accepts a Vector3 or BasePart as the first argument!");

        return;
    end;

    local u13 = {
        Type = typeof(p11) == "Vector3" and "StaicPoint" or "BasePartPoint",
        Point = p11
    };

    if u13.Type == "BasePartPoint" then
        local u15 = p11.Changed:Connect(function(p14) -- Line: 84
            -- upvalues: u10 (copy)
            if p14 == "Position" then
                u10:UpdateLength();
            end;
        end);
        local v19 = p11.AncestryChanged:Connect(function(p16, p17) -- Line: 91
            -- upvalues: u10 (copy), u13 (copy), u15 (ref)
            if p17 == nil then
                local v18 = table.find(u10.Points, u13);

                if v18 then
                    table.remove(u10.Points, v18);
                end;

                u15:Disconnect();
                u15:Disconnect();
            end;
        end);

        if not u10._connections[p11] then
            u10._connections[p11] = {};
        end;

        table.insert(u10._connections[p11], u15);
        table.insert(u10._connections[p11], v19);
    end;

    if p12 and type(p12) == "number" then
        table.insert(u10.Points, p12, u13);
    elseif p12 then
        if type(p12) ~= "number" then
            error("Bezier:AddBezierPoint() only accepts an integer as the second argument!");
        end;
    else
        table.insert(u10.Points, u13);
    end;

    u10:UpdateLength();
end;

function u1.ChangeBezierPoint(p20, p21, p22) -- Line: 137
    if type(p21) ~= "number" then
        error("Bezier:ChangeBezierPoint() only accepts a number index as the first argument!");
    end;

    if (not p22 or (typeof(p22) ~= "Instance" or not p22:IsA("BasePart"))) and typeof(p22) ~= "Vector3" then
        error("Bezier:ChangeBezierPoint() only accepts a Vector3 or BasePart as the second argument!");

        return;
    end;

    local v23 = p20.Points[p21];

    if not v23 then
        error("Did not find BezierPoint at index " .. tostring(p21));

        return;
    end;

    v23.Type = typeof(p22) == "Vector3" and "StaicPoint" or "BasePartPoint";
    v23.Point = p22;
    p20:UpdateLength();
end;

function u1.GetAllPoints(p24) -- Line: 171
    local v25 = {};

    for i = 1, #p24.Points do
        table.insert(v25, p24:GetPoint(i));
    end;

    return v25;
end;

function u1.GetPoint(p26, p27) -- Line: 189
    local Points = p26.Points;

    if Points[p27] then
        return typeof(Points[p27].Point) == "Vector3" and Points[p27].Point or Points[p27].Point.Position;
    end;

    error("Did not find a BezierPoint at index " .. tostring(p27) .. "!");
end;

function u1.RemoveBezierPoint(p28, p29) -- Line: 202
    if p28.Points[p29] then
        local v30 = table.remove(p28.Points, p29);

        if typeof(v30.Point) == "Instance" and v30.Point:IsA("BasePart") then
            for _, v in pairs(p28._connections[v30.Point]) do
                if v.Connected then
                    v:Disconnect();
                end;
            end;

            p28._connections[v30.Point] = nil;
        end;

        p28:UpdateLength();
    end;
end;

function u1.UpdateLength(p31) -- Line: 225
    local v32 = p31:GetAllPoints();
    local LengthIterations = p31.LengthIterations;

    if #v32 < 2 then
        return 0, { { 0, 0, 0 }, { 0, 0, 0 } };
    end;

    local v33 = 0;
    local v34 = {};

    for i = 1, LengthIterations do
        local v35 = p31:CalculateDerivativeAt((i - 1) / (LengthIterations - 1));
        v33 = v33 + v35.Magnitude * (1 / LengthIterations);
        table.insert(v34, { (i - 1) / (LengthIterations - 1), v33, v35 });
    end;

    p31.Length = v33;
    p31.LengthIndeces = v34;
end;

function u1.CalculatePositionAt(p36, p37) -- Line: 251
    if type(p37) ~= "number" then
        error("Bezier:CalculatePositionAt() only accepts a number, got " .. tostring(p37) .. "!");
    end;

    if #p36.Points > 0 then
        local v38 = p36:GetAllPoints();
        local v39 = #v38;
        local v40 = Vector3.new();

        for i = 1, v39 do
            local v41 = v38[i];
            v40 = v40 + B(v39 - 1, i - 1, p37) * v41;
        end;

        return v40;
    end;

    error("Bezier:CalculatePositionAt() only works if there is at least 1 BezierPoint!");
end;

function u1.CalculatePositionRelativeToLength(p42, p43) -- Line: 291
    if type(p43) ~= "number" then
        error("Bezier:CalculatePositionRelativeToLength() only accepts a number, got " .. tostring(p43) .. "!");
    end;

    if #p42.Points <= 0 then
        error("Bezier:CalculatePositionRelativeToLength() only works if there is at least 1 BezierPoint!");

        return;
    end;

    local Length = p42.Length;
    local LengthIndeces = p42.LengthIndeces;
    local _ = p42.LengthIterations;

    if #p42:GetAllPoints() <= 1 then
        return p42:CalculatePositionAt(0);
    end;

    local v44 = Length * p43;
    local v45 = nil;
    local v46 = nil;

    for i, v in ipairs(LengthIndeces) do
        if v44 - v[2] <= 0 or i == #LengthIndeces then
            v46 = v;
            v45 = i;
            break;
        end;
    end;

    local v47, v48;

    if LengthIndeces[v45 - 1] then
        v47 = p42:CalculatePositionAt(LengthIndeces[v45 - 1][1]);
        v48 = p42:CalculatePositionAt(v46[1]);
    else
        v47 = p42:CalculatePositionAt(v46[1]);
        v48 = p42:CalculatePositionAt(LengthIndeces[v45 + 1][1]);
    end;

    return v47 + (v48 - v47) * (1 - (v46[2] - v44) / (v48 - v47).Magnitude);
end;

function u1.CalculateDerivativeAt(p49, p50) -- Line: 357
    if type(p50) ~= "number" then
        error("Bezier:CalculateDerivativeAt() only accepts a number, got " .. tostring(p50) .. "!");
    end;

    if #p49.Points > 1 then
        local v51 = p49:GetAllPoints();
        local v52 = #v51;
        local _ = v52 - 1;
        local v53 = Vector3.new();

        for i = 1, v52 - 1 do
            local v54 = (v52 - 1) * (v51[i + 1] - v51[i]);
            v53 = v53 + B(v52 - 2, i - 1, p50) * v54;
        end;

        return v53;
    end;

    error("Bezier:CalculateDerivativeAt() only works if there are at least 2 BezierPoints!");
end;

function u1.CalculateDerivativeRelativeToLength(p55, p56) -- Line: 400
    if type(p56) ~= "number" then
        error("Bezier:CalculateDerivativeRelativeToLength() only accepts a number, got " .. tostring(p56) .. "!");
    end;

    if #p55.Points <= 1 then
        error("Bezier:CalculateDerivativeRelativeToLength() only works if there are at least 2 BezierPoints!");

        return;
    end;

    local Length = p55.Length;
    local LengthIndeces = p55.LengthIndeces;
    local _ = p55.LengthIterations;
    p55:GetAllPoints();
    local v57 = Length * p56;
    local v58 = nil;
    local v59 = nil;

    for i, v in ipairs(LengthIndeces) do
        if v57 - v[2] <= 0 or i == #LengthIndeces then
            v59 = v;
            v58 = i;
            break;
        end;
    end;

    local v60, v61;

    if LengthIndeces[v58 - 1] then
        v60 = p55:CalculateDerivativeAt(LengthIndeces[v58 - 1][1]);
        v61 = p55:CalculateDerivativeAt(v59[1]);
    else
        v60 = p55:CalculateDerivativeAt(v59[1]);
        v61 = p55:CalculateDerivativeAt(LengthIndeces[v58 + 1][1]);
    end;

    return v60 + (v61 - v60) * (1 - (v59[2] - v57) / (v61 - v60).Magnitude);
end;

function u1.CreateVector3Tween(u62, u63, u64, p65, u66) -- Line: 458
    if #u62.Points == 0 then
        error("Bezier:CreateVector3Tween() only works if there is at least 1 BezierPoint in the Bezier!");
    end;

    if typeof(u63) ~= "Instance" and typeof(u63) ~= "table" then
        error("Bezier:CreateVector3Tween() requires an Instance or a table as the first argument!");
    end;

    if typeof(p65) ~= "TweenInfo" then
        error("Bezier:CreateVector3Tween() requires a TweenInfo object as the third argument!");
    end;

    local success, result = pcall(function() -- Line: 476
        -- upvalues: u64 (copy), u63 (copy)
        for _, v in pairs(u64) do
            if typeof(u63[v]) ~= "Vector3" and typeof(u63[v]) ~= "nil" then
                return false;
            end;
        end;

        return true;
    end);

    if success and result then
        local TweenService = game:GetService("TweenService");
        local NumberValue = Instance.new("NumberValue");
        local u67 = TweenService:Create(NumberValue, p65, {
            Value = 1
        });
        local u68 = nil;
        u67.Changed:Connect(function(p69) -- Line: 493
            -- upvalues: u67 (copy), u68 (ref), NumberValue (copy), u64 (copy), u63 (copy), u66 (copy), u62 (copy)
            if p69 == "PlaybackState" then
                if u67.PlaybackState == Enum.PlaybackState.Playing then
                    u68 = NumberValue.Changed:Connect(function(p70) -- Line: 497
                        -- upvalues: u64 (ref), u63 (ref), u66 (ref), u62 (ref)
                        for _, v in pairs(u64) do
                            u63[v] = u66 and u62:CalculatePositionRelativeToLength(p70) or u62:CalculatePositionAt(p70);
                        end;
                    end);

                    return;
                end;

                if u68 then
                    u68:Disconnect();
                    u68 = nil;
                end;
            end;
        end);

        return u67;
    end;

    error("Bezier:CreateVector3Tween() requires a matching property table with Vector3 or nil property names for the object as the second argument!");
end;

function u1.CreateCFrameTween(u71, u72, u73, p74, u75) -- Line: 519
    if #u71.Points <= 1 then
        error("Bezier:CreateVector3Tween() only works if there are at least 2 BezierPoints in the Bezier!");
    end;

    if typeof(u72) ~= "Instance" and typeof(u72) ~= "table" then
        error("Bezier:CreateCFrameTween() requires an Instance or a table as the first argument!");
    end;

    if typeof(p74) ~= "TweenInfo" then
        error("Bezier:CreateCFrameTween() requires a TweenInfo object as the third argument!");
    end;

    local success, result = pcall(function() -- Line: 537
        -- upvalues: u73 (copy), u72 (copy)
        for _, v in pairs(u73) do
            if typeof(u72[v]) ~= "CFrame" and typeof(u72[v]) ~= "nil" then
                return false;
            end;
        end;

        return true;
    end);

    if success and result then
        local TweenService = game:GetService("TweenService");
        local NumberValue = Instance.new("NumberValue");
        local u76 = TweenService:Create(NumberValue, p74, {
            Value = 1
        });
        local u77 = nil;
        u76.Changed:Connect(function(p78) -- Line: 554
            -- upvalues: u76 (copy), u77 (ref), NumberValue (copy), u73 (copy), u75 (copy), u71 (copy), u72 (copy)
            if p78 == "PlaybackState" then
                if u76.PlaybackState == Enum.PlaybackState.Playing then
                    u77 = NumberValue.Changed:Connect(function(p79) -- Line: 558
                        -- upvalues: u73 (ref), u75 (ref), u71 (ref), u72 (ref)
                        for _, v in pairs(u73) do
                            local v80 = u75 and u71:CalculatePositionRelativeToLength(p79) or u71:CalculatePositionAt(p79);
                            local v81 = u75 and u71:CalculateDerivativeRelativeToLength(p79) or u71:CalculateDerivativeAt(p79);
                            u72[v] = CFrame.new(v80, v80 + v81);
                        end;
                    end);

                    return;
                end;

                if u77 then
                    u77:Disconnect();
                    u77 = nil;
                end;
            end;
        end);

        return u76;
    end;

    error("Bezier:CreateCFrameTween() requires a matching property table with CFrame or nil property names for the object as the second argument!");
end;

return u1;