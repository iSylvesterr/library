-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local LocalPlayer = Players.LocalPlayer;
local u1 = CollectionService:HasTag(LocalPlayer, "PersistentLoaded") and true or false;
local v3 = CollectionService:GetInstanceAddedSignal("PersistentLoaded"):Connect(function(p2) -- Line: 10
    -- upvalues: LocalPlayer (copy), u1 (ref)
    if p2 == LocalPlayer then
        u1 = true;
    end;
end);
local v4 = workspace.PersistentLoaded:Connect(function() -- Line: 17
    -- upvalues: u1 (ref)
    u1 = true;
end);

repeat
    task.wait();
until u1;

if v3 then
    v3:Disconnect();
end;

if v4 then
    v4:Disconnect();
end;

repeat
    task.wait();
until game:IsLoaded();

local RunService = game:GetService("RunService");
local Controllers = script.Parent:WaitForChild("Controllers");
local v5 = os.clock();

local function runWatched(p6, p7, u8) -- Line: 53
    local u9 = false;
    local u10 = false;
    local u11 = nil;
    task.spawn(function() -- Line: 58
        -- upvalues: u10 (ref), u11 (ref), u8 (copy), u9 (ref)
        local success, result = pcall(u8);
        u10 = success;
        u11 = result;
        u9 = true;
    end);
    local v12 = os.clock();
    local v13 = 3;

    while not u9 do
        task.wait(0.1);

        if u9 then
            break;
        end;

        local v14 = os.clock() - v12;

        if v14 >= 30 then
            warn(string.format("%s \'%s\' %s exceeded %ds and was abandoned -- this controller likely yields forever (e.g. WaitForChild for an instance that never replicates). Continuing startup so the player can still load.", "[ControllerStarter]", p7, p6, 30));

            return false, "timeout";
        end;

        if v13 <= v14 then
            warn(string.format("%s \'%s\' still running %s after %.1fs -- this is blocking all remaining controllers and the loading screen.", "[ControllerStarter]", p7, p6, v14));
            v13 = v13 + 3;
        end;
    end;

    local v15 = os.clock() - v12;

    if v15 >= 1 then
        warn(string.format("%s \'%s\' %s took %.0fms.", "[ControllerStarter]", p7, p6, v15 * 1000));
    end;

    if not u10 then
        warn(string.format("%s \'%s\' %s errored: %s", "[ControllerStarter]", p7, p6, (tostring(u11))));
    end;

    return u10, u11;
end;

local v16 = {};
local v17 = 3;

while not LocalPlayer.Character do
    task.wait(0.1);
    local v18 = os.clock() - v5;

    if v17 <= v18 then
        warn(string.format("%s Still waiting for the character to spawn after %.1fs -- spawn is gated on profile data load; controllers can\'t start until StarterGui has cloned into PlayerGui.", "[ControllerStarter]", v18));
        v17 = v17 + 3;
    end;
end;

local v19 = os.clock();
local u20 = require;

for _, child in Controllers:GetChildren() do
    local v21, v22 = runWatched("require", child.Name, function() -- Line: 131
        -- upvalues: u20 (copy), child (copy)
        return u20(child);
    end);

    if v21 then
        table.insert(v16, {
            name = child.Name,
            module = v22
        });
    end;
end;

table.sort(v16, function(p23, p24) -- Line: 141
    return (p23.module.StartOrder or 0) < (p24.module.StartOrder or 0);
end);

for _, v in v16 do
    if v.module.Init and (not (v.module.Disabled or runWatched("Init", v.name, function() -- Line: 150
        -- upvalues: v (copy)
        v.module:Init();
    end)) and true or false) then
        v.failed = true;
    end;
end;

for _, v in v16 do
    if not v.failed and v.module.Start then
        runWatched("Start", v.name, function() -- Line: 164
            -- upvalues: v (copy)
            v.module:Start();
        end);
    end;
end;

if not RunService:IsStudio() then
    print(string.format("%s All controllers started in %.0fms (%d loaded).", "[ControllerStarter]", (os.clock() - v19) * 1000, #v16));
end;

LocalPlayer:AddTag("ControllersStarted");