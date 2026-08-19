-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local _ = script.Parent;
local u1 = {
    TotalZoneVolume = 0,
    ActiveZones = {}
};

function u1.registerZone(p2, p3) -- Line: 15
    -- upvalues: u1 (copy)
    u1.ActiveZones[p2] = p3;
end;

function u1.deregisterZone(p4) -- Line: 19
    -- upvalues: u1 (copy)
    u1.ActiveZones[p4] = nil;
end;

RunService.PostSimulation:Connect(function(p5) -- Line: 23
    -- upvalues: u1 (copy)
    for i, v in u1.ActiveZones do
        local QueryOptions = v.QueryOptions;
        local v6, v7, v8, v9, v10;

        if QueryOptions.ThrottlingEnabled then
            local v11 = os.clock();

            if v11 - i._lastUpdate >= QueryOptions.UpdateInterval then
                i._lastUpdate = v11;

                if QueryOptions.FireMode == "OnEnter" or QueryOptions.FireMode == "Both" then
                    v6 = QueryOptions.FireMode ~= "None";
                else
                    v6 = false;
                end;

                if QueryOptions.FireMode == "OnExit" or QueryOptions.FireMode == "Both" then
                    v7 = QueryOptions.FireMode ~= "None";
                else
                    v7 = false;
                end;

                if QueryOptions.InSeperateQuerySpace then
                    v8 = i._worldModel;
                    v9 = i._querySpace.dynamic;
                    v10 = table.create(#v9.replicas);

                    for i2, v2 in v9.index do
                        v10[i2] = v2.CFrame;
                    end;

                    v8:BulkMoveTo(v9.replicas, v10, Enum.BulkMoveMode.FireCFrameChanged);
                end;

                i:Update(v.QueryParams, v6, v7);
            end;
        else
            if QueryOptions.FireMode == "OnEnter" or QueryOptions.FireMode == "Both" then
                v6 = QueryOptions.FireMode ~= "None";
            else
                v6 = false;
            end;

            if QueryOptions.FireMode == "OnExit" or QueryOptions.FireMode == "Both" then
                v7 = QueryOptions.FireMode ~= "None";
            else
                v7 = false;
            end;

            if QueryOptions.InSeperateQuerySpace then
                v8 = i._worldModel;
                v9 = i._querySpace.dynamic;
                v10 = table.create(#v9.replicas);

                for i2, v2 in v9.index do
                    v10[i2] = v2.CFrame;
                end;

                v8:BulkMoveTo(v9.replicas, v10, Enum.BulkMoveMode.FireCFrameChanged);
            end;

            i:Update(v.QueryParams, v6, v7);
        end;
    end;
end);

return u1;