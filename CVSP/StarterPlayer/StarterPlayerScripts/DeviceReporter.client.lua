-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local ReportDevice = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ReportDevice");

local function classify() -- Line: 18
    -- upvalues: GuiService (copy), UserInputService (copy)
    if GuiService:IsTenFootInterface() then
        return "Console";
    end;

    if not UserInputService.TouchEnabled or (UserInputService.KeyboardEnabled or UserInputService.MouseEnabled) then
        return "Desktop";
    end;

    local v1 = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize;
    local v2 = v1 and math.min(v1.X, v1.Y) or 0;

    return v2 > 0 and v2 <= 500 and "Phone" or "Tablet";
end;

local u3 = classify();
LocalPlayer:SetAttribute("DeviceTier", u3);

local function report() -- Line: 50
    -- upvalues: ReportDevice (copy), u3 (ref)
    ReportDevice:FireServer(u3);
end;

ReportDevice:FireServer(u3);
task.delay(2, function() -- Line: 57
    -- upvalues: classify (copy), u3 (ref), LocalPlayer (copy), ReportDevice (copy)
    local v4 = classify();

    if v4 ~= u3 then
        u3 = v4;
        LocalPlayer:SetAttribute("DeviceTier", u3);
        ReportDevice:FireServer(u3);
    end;
end);