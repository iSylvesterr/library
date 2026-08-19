-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Environment = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Environment"));
local u1 = RunService:IsStudio() or Environment.env == "Dev";
local u2 = setmetatable({}, {
    __mode = "k"
});

local function AllowHeal(p3) -- Line: 46
    -- upvalues: u2 (copy)
    local v4 = os.clock();
    local v5 = u2[p3];

    if v5 and v4 - v5.WindowStart <= 10 then
        v5.Count = v5.Count + 1;

        return v5.Count <= 3;
    end;

    u2[p3] = {
        Count = 1,
        WindowStart = v4
    };

    return true;
end;

return table.freeze({
    WatchHandle = function(u6, u7, u8, u9, u10) -- Line: 69, Name: WatchHandle
        -- upvalues: Players (copy), u1 (copy), AllowHeal (copy)
        local u11 = nil;
        local u12 = nil;

        local function cleanup() -- Line: 79
            -- upvalues: u11 (ref), u12 (ref)
            if u11 then
                u11:Disconnect();
                u11 = nil;
            end;

            if u12 then
                u12:Disconnect();
                u12 = nil;
            end;
        end;

        local function isLocalTool() -- Line: 92
            -- upvalues: Players (ref), u8 (copy)
            local LocalPlayer = Players.LocalPlayer;
            local v13;

            if LocalPlayer == nil then
                v13 = false;
            else
                v13 = u8() == LocalPlayer.Character;
            end;

            return v13;
        end;

        u11 = u7.AncestryChanged:Connect(function() -- Line: 97
            -- upvalues: u7 (copy), u11 (ref), u12 (ref), u8 (copy), u6 (copy), u1 (ref), Players (ref), u9 (copy), AllowHeal (ref), u10 (copy)
            if u7:IsDescendantOf(game) then
                return;
            end;

            if u11 then
                u11:Disconnect();
                u11 = nil;
            end;

            if u12 then
                u12:Disconnect();
                u12 = nil;
            end;

            local v14 = u8();

            if not v14 then
                return;
            end;

            if u6.Parent ~= v14 then
                return;
            end;

            if u1 then
                local LocalPlayer = Players.LocalPlayer;
                local v15;

                if LocalPlayer == nil then
                    v15 = false;
                else
                    v15 = u8() == LocalPlayer.Character;
                end;

                if v15 then
                    print((`[HeldHandleSelfHeal] "{u6.Name}" handle dropped -- rebuilding in {0.4}s (delay is dev-only; prod heals next-frame).`));
                end;
            end;

            local function doHeal() -- Line: 112
                -- upvalues: u6 (ref), u8 (ref), u9 (ref), AllowHeal (ref), u10 (ref), u1 (ref), Players (ref)
                if u6.Parent ~= u8() or u9() then
                    return;
                end;

                if AllowHeal(u6) then
                    u10();

                    if u1 then
                        local LocalPlayer = Players.LocalPlayer;
                        local v16;

                        if LocalPlayer == nil then
                            v16 = false;
                        else
                            v16 = u8() == LocalPlayer.Character;
                        end;

                        if v16 then
                            print((`[HeldHandleSelfHeal] "{u6.Name}" handle rebuilt (self-heal).`));
                        end;
                    end;
                elseif u1 then
                    local LocalPlayer = Players.LocalPlayer;
                    local v17;

                    if LocalPlayer == nil then
                        v17 = false;
                    else
                        v17 = u8() == LocalPlayer.Character;
                    end;

                    if v17 then
                        warn((`[HeldHandleSelfHeal] "{u6.Name}": handle lost more than {3}x in {10}s -- skipping respawn to avoid a loop (something is repeatedly destroying it).`));
                    end;
                end;
            end;

            if u1 then
                task.delay(0.4, doHeal);

                return;
            end;

            task.defer(doHeal);
        end);

        if u1 then
            u12 = u6:GetAttributeChangedSignal("QASimulateHandleLoss"):Connect(function() -- Line: 133
                -- upvalues: u7 (copy), Players (ref), u8 (copy), u6 (copy)
                if u7.Parent then
                    local LocalPlayer = Players.LocalPlayer;
                    local v18;

                    if LocalPlayer == nil then
                        v18 = false;
                    else
                        v18 = u8() == LocalPlayer.Character;
                    end;

                    if v18 then
                        print((`[HeldHandleSelfHeal] QA: dropping "{u6.Name}" handle to test the self-heal...`));
                    end;

                    u7:Destroy();
                end;
            end);
        end;
    end
});