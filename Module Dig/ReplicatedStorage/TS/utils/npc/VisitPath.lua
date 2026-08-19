-- Decompiled with Potassium's decompiler.

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "npc", "VisitorConstants");
local VISIT_STAND_DISTANCE = v1.VISIT_STAND_DISTANCE;
local VISIT_WALK_SPEED = v1.VISIT_WALK_SPEED;

local function horizontalDistance(p2, p3) -- Line: 7
    local v4 = p3.X - p2.X;
    local v5 = p3.Z - p2.Z;

    return math.sqrt(v4 * v4 + v5 * v5);
end;

return {
    VisitPath = {
        build = function(p6, p7, p8, p9, p10) -- Line: 15, Name: build
            -- upvalues: VISIT_STAND_DISTANCE (copy), VISIT_WALK_SPEED (copy)
            local v11 = p10 == nil and 0 or p10;
            local Plot = p6:FindFirstChild("Plot");
            local v12;

            if Plot == nil then
                v12 = Plot;
            else
                v12 = Plot:FindFirstChild("Nodes");
            end;

            local v13;

            if v12 == nil then
                v13 = v12;
            else
                v13 = v12:FindFirstChild("JunctionNode");
            end;

            local v14;

            if v12 == nil then
                v14 = v12;
            else
                v14 = v12:FindFirstChild("WalkwayNode");
            end;

            if v12 ~= nil then
                v12 = v12:FindFirstChild("EntranceNode");
            end;

            if Plot ~= nil then
                Plot = Plot:FindFirstChild("Pedestals");

                if Plot ~= nil then
                    Plot = Plot:FindFirstChild((`Pedestal_{p7}`));
                end;
            end;

            local v15;

            if v13 == nil then
                v15 = v13;
            else
                v15 = v13:IsA("BasePart");
            end;

            local v16 = not v15;

            if not v16 then
                local v17;

                if v14 == nil then
                    v17 = v14;
                else
                    v17 = v14:IsA("BasePart");
                end;

                v16 = not v17;

                if not v16 then
                    local v18;

                    if v12 == nil then
                        v18 = v12;
                    else
                        v18 = v12:IsA("BasePart");
                    end;

                    v16 = not v18;

                    if not v16 then
                        local v19;

                        if Plot == nil then
                            v19 = Plot;
                        else
                            v19 = Plot:IsA("Model");
                        end;

                        v16 = not v19;
                    end;
                end;
            end;

            if v16 then
                return nil;
            end;

            local Position = Plot:GetPivot().Position;
            local Y = v12.Position.Y;
            local v20 = Vector3.new(v12.Position.X - v14.Position.X, 0, v12.Position.Z - v14.Position.Z);
            local v21 = v20.Magnitude <= 0.001 and Vector3.new(0, 0, 1) or v20.Unit;
            local v22 = Vector3.new(Position.X - v12.Position.X, 0, Position.Z - v12.Position.Z):Dot(v21);
            local v23 = math.max(v22, 0);
            local v24 = Vector3.new(v12.Position.X + v21.X * v23, Y, v12.Position.Z + v21.Z * v23);
            local v25 = Vector3.new(v24.X - Position.X, 0, v24.Z - Position.Z);
            local v26;

            if v25.Magnitude > 0.001 then
                v26 = v25.Unit;
            else
                v26 = v21 * -1;
            end;

            local v27 = Vector3.new(Position.X + v26.X * VISIT_STAND_DISTANCE - v26.Z * v11, Y, Position.Z + v26.Z * VISIT_STAND_DISTANCE + v26.X * v11);
            local v28 = {
                Vector3.new(p8, v13.Position.Y, p9),
                v13.Position,
                v14.Position,
                v12.Position
            };

            if v23 > 1 then
                table.insert(v28, v24);
            end;

            table.insert(v28, v27);
            local v29 = 0;

            for i = 0, #v28 - 2 do
                local v30 = v28[i + 1];
                local v31 = v28[i + 2];
                local v32 = v31.X - v30.X;
                local v33 = v31.Z - v30.Z;
                v29 = v29 + math.sqrt(v32 * v32 + v33 * v33) / VISIT_WALK_SPEED;
            end;

            local v34 = 0;

            for i = 1, #v28 - 2 do
                local v35 = v28[i + 1];
                local v36 = v28[i + 2];
                local v37 = v36.X - v35.X;
                local v38 = v36.Z - v35.Z;
                v34 = v34 + math.sqrt(v37 * v37 + v38 * v38) / VISIT_WALK_SPEED;
            end;

            return {
                waypoints = v28,
                arriveDuration = v29,
                returnDuration = v34,
                pedestalPosition = Position
            };
        end
    }
};