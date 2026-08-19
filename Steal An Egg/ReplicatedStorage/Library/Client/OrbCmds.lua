-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Types = Library:WaitForChild("Types");
local Items = Library:WaitForChild("Items");
local Client = Library:WaitForChild("Client");
local Orbs = require(Types.Orbs);
local CurrencyItem = require(Items.CurrencyItem);
local Types2 = require(Items.Types);
local BindToRenderStep = require(Library.Functions.BindToRenderStep);
local Network = require(Client.Network);
local GraphicsQuality = require(Library.Functions.GraphicsQuality);
local Orb = require(script.Orb);
local InsertOrReplace = require(ReplicatedStorage.Library.Functions.InsertOrReplace);
local TrimArray = require(ReplicatedStorage.Library.Functions.TrimArray);
local LocalPlayer = Players.LocalPlayer;
local u1 = Random.new();
local u2 = {};
local u3 = 0;
local u4 = 0;
local u5 = 0;
local u6 = {};
local u7 = {};

local function hashPosition(p8) -- Line: 33
    return (bit32.band(p8.X, 262143) * 262144 + bit32.band(p8.Z, 262143)) * 131072 + bit32.band(p8.Y, 131071);
end;

local function combineScale(p9, p10) -- Line: 38
    if p10 <= 5 then
        return math.max(1, 10 - p9 / 10);
    end;

    return math.max(1, 20 - p9 / 10);
end;

BindToRenderStep("Orbs", Enum.RenderPriority.Last.Value, function(p11) -- Line: 45
    -- upvalues: GraphicsQuality (copy), u4 (ref), u5 (ref), Orb (copy), u3 (ref), LocalPlayer (copy), u2 (ref), InsertOrReplace (copy), u6 (copy), u7 (copy), TrimArray (copy), Network (copy)
    debug.profilebegin("OrbCmds :: RenderStep");
    local v12 = GraphicsQuality();
    u4 = u4 + p11;
    u5 = u5 + 1;
    local v13 = {};

    if u5 >= 1 then
        local v14 = 0;
        local CombineDistance = Orb.CombineDistance;
        local v15 = 1;
        local u16 = u4;
        local v17;

        if v12 <= 5 then
            v17 = CombineDistance / math.max(1, 4 - u3 / 10);
            v15 = 0.5;
        else
            v17 = CombineDistance / math.max(1, 8 - u3 / 20);
        end;

        u4 = 0;
        u5 = 0;
        local v18 = {};
        local v19 = {};
        local Gravity = workspace.Gravity;
        local u20 = workspace:GetServerTimeNow();
        local Character = LocalPlayer.Character;
        local u21;

        if Character and Character.PrimaryPart then
            u21 = Character.PrimaryPart.CFrame or nil;
        else
            u21 = nil;
        end;

        local DefaultPickupDistance = Orb.DefaultPickupDistance;

        for i, v in pairs(u2) do
            local success, result = pcall(function() -- Line: 84, Name: safeRenderStepped
                -- upvalues: v (copy), u16 (copy), u20 (copy), Gravity (copy), Character (copy), u21 (copy), DefaultPickupDistance (copy)
                return v:RenderStepped(u16, u20, Gravity, 1, Character, u21, DefaultPickupDistance);
            end);

            if success and result then
                local _cframePhysics = v._cframePhysics;
                local _cframeRender = v._cframeRender;

                if _cframePhysics ~= _cframeRender then
                    v._cframeRender = _cframePhysics;
                    local v22 = _cframeRender * v._pivotOffsetInv;
                    v14 = v14 + 1;
                    InsertOrReplace(u6, v._part, v14);
                    InsertOrReplace(u7, v22, v14);
                end;

                local Position = _cframePhysics.Position;

                if v._anchored or u20 - v._timestamp > 5 then
                    local _combineKey = v._combineKey;

                    if _combineKey and v._combineDelay * v15 <= u20 - v._timestamp then
                        local v23 = v18[_combineKey] or {};
                        v18[_combineKey] = v23;
                        local v24 = Position // v17;
                        local v25 = (bit32.band(v24.X, 262143) * 262144 + bit32.band(v24.Z, 262143)) * 131072 + bit32.band(v24.Y, 131071);
                        local v26 = v23[v25] or {};
                        v23[v25] = v26;
                        table.insert(v26, v);
                    end;
                end;

                local v27 = Position // 300;
                local v28 = (bit32.band(v27.X, 262143) * 262144 + bit32.band(v27.Z, 262143)) * 131072 + bit32.band(v27.Y, 131071);
                v19[v28] = (v19[v28] or 0) + 1;
            else
                if not success then
                    warn("[OrbCmds] Error:", result);
                end;

                u2[i] = nil;
                u3 = u3 - 1;
                v:Destroy();

                if v._collected then
                    table.insert(v13, v._id);
                    table.move(v._combinedIds, 1, #v._combinedIds, #v13 + 1, v13);
                end;
            end;
        end;

        TrimArray(u6, v14);
        TrimArray(u7, v14);

        if v14 > 0 then
            workspace:BulkMoveTo(u6, u7, Enum.BulkMoveMode.FireCFrameChanged);
        end;

        for _, v in pairs(u2) do
            local _combineKey = v._combineKey;

            if _combineKey then
                local v29 = v18[_combineKey];

                if v29 then
                    local v30 = u20 - v._timestamp;

                    if v._combineDelay <= v30 then
                        local Position = v._cframePhysics.Position;
                        local v31 = Position // v17;
                        local _pickupDelay = v._pickupDelay;
                        local v32 = v._combineDelay - v._pickupDelay;
                        local v33 = Position // 300;
                        local v34 = v19[(bit32.band(v33.X, 262143) * 262144 + bit32.band(v33.Z, 262143)) * 131072 + bit32.band(v33.Y, 131071)] or 0;
                        local v35;

                        if v12 <= 5 then
                            v35 = math.max(1, 10 - v34 / 10);
                        else
                            v35 = math.max(1, 20 - v34 / 10);
                        end;

                        if _pickupDelay + v32 * v35 <= v30 then
                            for i = -1, 1 do
                                for i2 = -1, 1 do
                                    for i3 = -1, 1 do
                                        local v36 = v31 + Vector3.new(i, i2, i3);
                                        local v37 = v29[(bit32.band(v36.X, 262143) * 262144 + bit32.band(v36.Z, 262143)) * 131072 + bit32.band(v36.Y, 131071)];

                                        if v37 then
                                            for _, v2 in ipairs(v37) do
                                                if v ~= v2 and not v2._destroyed then
                                                    local Position2 = v2._cframePhysics.Position;
                                                    local _pickupDelay2 = v2._pickupDelay;
                                                    local v38 = v2._combineDelay - v2._pickupDelay;
                                                    local v39 = Position2 // 300;
                                                    local v40 = v19[(bit32.band(v39.X, 262143) * 262144 + bit32.band(v39.Z, 262143)) * 131072 + bit32.band(v39.Y, 131071)] or 0;
                                                    local v41;

                                                    if v12 <= 5 then
                                                        v41 = math.max(1, 10 - v40 / 10);
                                                    else
                                                        v41 = math.max(1, 20 - v40 / 10);
                                                    end;

                                                    if _pickupDelay2 + v38 * v41 <= u20 - v2._timestamp and ((Position2 - Position).Magnitude <= v17 and v:Combine(v2)) then
                                                        u2[v2._id] = nil;
                                                        u3 = u3 - 1;
                                                        v2:Destroy();
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local CurrentCamera = workspace.CurrentCamera;
    local Position = CurrentCamera.CFrame.Position;
    local v42 = math.rad(CurrentCamera.FieldOfView) * 0.5;
    local v43 = math.tan(v42) * 2 / CurrentCamera.ViewportSize.Y;

    for _, v in pairs(u2) do
        v:RenderParticles(Position, v43);
    end;

    if #v13 > 0 then
        Network.Fire("Orbs: Collect", v13);
    end;

    debug.profileend();
end);

local function ProcessCreate(p44) -- Line: 234
    -- upvalues: Orbs (copy), Orb (copy), LocalPlayer (copy), CurrencyItem (copy), Types2 (copy), u2 (ref), u3 (ref)
    local v45 = p44.config or {};

    if not v45.Type then
        v45.Type = Orbs.Types.Orb;
    end;

    local v46 = Orb.ComputeInitialCFrame(p44);

    if not v46 then
        return warn("[OrbCmds] No CFrame!", p44);
    end;

    local Character = LocalPlayer.Character;
    local v47;

    if Character and Character.PrimaryPart then
        v47 = Character:GetPivot();
    else
        v47 = nil;
    end;

    local v48 = Orb.ComputeInitialVelocity(v46, v47, v45);
    local v49 = {};
    local v50 = Orbs.OrbTypesInverse[p44.ct];

    if p44.i then
        for _, v in ipairs(p44.i) do
            table.insert(v49, Types2.DecodeNetwork(v));
        end;
    else
        assert(p44.ct and p44.ca, "Invalid orbConfig");
        local v51 = CurrencyItem(Orbs.OrbTypesInverse[p44.ct]);
        table.insert(v49, v51:SetAmount(p44.ca));
    end;

    local v52 = Orb.new(p44.id, p44.t, v49, v45, v46, v48, v50);
    local v53 = u2[p44.id];
    u2[p44.id] = v52;

    if v53 then
        v53:Destroy();

        return;
    end;

    u3 = u3 + 1;
end;

Network.Fired("Orbs: Create"):Connect(function(p54) -- Line: 278
    -- upvalues: u1 (copy), ProcessCreate (copy)
    for _, v in ipairs(p54) do
        task.delay(u1:NextNumber(0, 0.1), ProcessCreate, v);
    end;
end);
Network.Fired("Orbs: Clear"):Connect(function() -- Line: 284
    -- upvalues: u2 (ref), u3 (ref)
    local v55 = u2;
    u2 = {};
    u3 = 0;

    for _, v in pairs(v55) do
        v:Destroy();
    end;
end);

return {};