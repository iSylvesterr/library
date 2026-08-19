-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local BackpackCore = require(script.Parent.Backpack.BackpackCore);
local BackpackDrag = require(script.Parent.Backpack.BackpackDrag);
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local u1 = false;

local function _tryInitFromPlayerGui() -- Line: 22
    -- upvalues: u1 (ref), LocalPlayer (copy), Log (copy), BackpackCore (copy), BackpackDrag (copy)
    if u1 then
        return true;
    end;

    local Main = LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Main", (1 / 0));

    if not Main:FindFirstChild("Backpack") then
        Log.warn("[InitBackpack] Main.Backpack missing — check Studio UI / Rojo sync");

        return false;
    end;

    if not BackpackCore.init(Main) then
        Log.warn("[InitBackpack] BackpackCore.init failed");

        return false;
    end;

    BackpackDrag.init();
    u1 = true;

    return true;
end;

if not _tryInitFromPlayerGui() then
    local u2 = nil;
    u2 = LocalPlayer.CharacterAdded:Connect(function() -- Line: 45
        -- upvalues: _tryInitFromPlayerGui (copy), u2 (ref)
        task.defer(function() -- Line: 46
            -- upvalues: _tryInitFromPlayerGui (ref), u2 (ref)
            if _tryInitFromPlayerGui() and u2 then
                u2:Disconnect();
                u2 = nil;
            end;
        end);
    end);
end;