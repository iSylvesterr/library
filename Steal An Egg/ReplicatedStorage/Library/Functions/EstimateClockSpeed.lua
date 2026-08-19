-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");

local function benchmarkCpu() -- Line: 3
    local v1 = os.clock();
    local v2 = v1;

    for i = 1, 1000000 do
        v1 = v1 + v1 - i;
    end;

    local v3 = os.clock();

    return v1 == -1 and -1 or v3 - v2;
end;

local function measureCpu() -- Line: 13
    local v4 = os.clock();
    local v5 = v4;

    for i = 1, 1000000 do
        v4 = v4 + v4 - i;
    end;

    local v6 = os.clock();

    if v4 ~= -1 then
        local _ = v6 - v5;
    end;

    task.wait();
    local v7 = os.clock();
    local v8 = v7;

    for i = 1, 1000000 do
        v7 = v7 + v7 - i;
    end;

    local v9 = os.clock();

    if v7 ~= -1 then
        local _ = v9 - v8;
    end;

    task.wait();
    local v10 = os.clock();
    local v11 = v10;

    for i = 1, 1000000 do
        v10 = v10 + v10 - i;
    end;

    local v12 = os.clock();
    local v13 = os.clock();
    local v14 = v13;

    for i = 1, 1000000 do
        v13 = v13 + v13 - i;
    end;

    local v15 = os.clock();
    local v16 = os.clock();
    local v17 = v16;

    for i = 1, 1000000 do
        v16 = v16 + v16 - i;
    end;

    local v18 = os.clock();
    local v19 = os.clock();
    local v20 = v19;

    for i = 1, 1000000 do
        v19 = v19 + v19 - i;
    end;

    local v21 = os.clock();

    return 0.01798125 / ((v10 == -1 and -1 or v12 - v11) + (v13 == -1 and -1 or v15 - v14) + (v16 == -1 and -1 or v18 - v17) + (v19 == -1 and -1 or v21 - v20)) / 4;
end;

local function isLoaded() -- Line: 21
    -- upvalues: Players (copy)
    if not game:IsLoaded() then
        return false;
    end;

    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer and (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) then
        return LocalPlayer:GetAttribute("__LOADED") and true or false;
    end;

    return false;
end;

local u22 = nil;
local u23 = nil;

return function() -- Line: 37
    -- upvalues: u22 (ref), u23 (ref), Players (copy), measureCpu (copy)
    if u22 then
        return u22;
    end;

    if not u23 then
        local v24;

        if game:IsLoaded() then
            local LocalPlayer = Players.LocalPlayer;

            if LocalPlayer and (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) then
                v24 = LocalPlayer:GetAttribute("__LOADED") and true or false;
            else
                v24 = false;
            end;
        else
            v24 = false;
        end;

        if v24 then
            u23 = os.clock();
        end;

        return nil;
    end;

    if os.clock() - u23 < 10 then
        return nil;
    end;

    local v25 = measureCpu();
    u22 = v25;

    return v25;
end;