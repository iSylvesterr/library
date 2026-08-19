-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local GetMouseToWorld = require(ReplicatedStorage.Library.Functions.GetMouseToWorld);
local Arrows = script:WaitForChild("Arrows");
local Attachment1 = Arrows.Attachment1;
local Attachment2 = Arrows.Attachment2;
local u1 = {
    Handler = nil,
    CurrentTarget = nil,
    LastHover = nil
};
local u2 = {};
local Highlight = Instance.new("Highlight");
Highlight.FillTransparency = 1;

local function resetState() -- Line: 22
    -- upvalues: u1 (copy), Highlight (copy), Arrows (copy)
    u1.LastHover = nil;
    u1.CurrentTarget = nil;
    u1.Handler = nil;
    Highlight.Parent = nil;
    Arrows.Parent = script;
end;

local u3 = false;

local function confirmTarget() -- Line: 32
    -- upvalues: u3 (ref), u1 (copy), Highlight (copy), Arrows (copy)
    if u3 then
        return;
    end;

    local Handler = u1.Handler;

    if not Handler then
        return;
    end;

    Handler.OnUnhover(u1.LastHover);

    if u1.CurrentTarget then
        Handler.OnConfirm(u1.CurrentTarget);
        u1.LastHover = nil;
        u1.CurrentTarget = nil;
        u1.Handler = nil;
        Highlight.Parent = nil;
        Arrows.Parent = script;

        return;
    end;

    Handler.OnCancelled();
    u1.LastHover = nil;
    u1.CurrentTarget = nil;
    u1.Handler = nil;
    Highlight.Parent = nil;
    Arrows.Parent = script;
end;

function u1.CreateTargetingHandler(p4, p5) -- Line: 50
    -- upvalues: u3 (ref), u1 (copy), Highlight (copy), Arrows (copy)
    u3 = true;
    u1.LastHover = nil;
    u1.CurrentTarget = nil;
    u1.Handler = nil;
    Highlight.Parent = nil;
    Arrows.Parent = script;
    u1.Handler = p5;
    p5.OnHover = p5.OnHover or function() -- Line: 54
    end;
    p5.OnUnhover = p5.OnUnhover or function() -- Line: 55
    end;
    p5.OnCancelled = p5.OnCancelled or function() -- Line: 56
    end;
    p5.OnConfirm = p5.OnConfirm or function() -- Line: 57
    end;
    task.delay(0.5, function() -- Line: 58
        -- upvalues: u3 (ref)
        u3 = false;
    end);
end;

RunService.RenderStepped:Connect(function() -- Line: 63
    -- upvalues: u1 (copy), u2 (copy), GetMouseToWorld (copy), Arrows (copy), Highlight (copy), Attachment1 (copy), Attachment2 (copy)
    local Handler = u1.Handler;

    if not Handler then
        return;
    end;

    local v6 = u2[Handler.TargetType];

    if not v6 then
        return;
    end;

    local v7 = GetMouseToWorld(RaycastParams.new(), 100);
    local v8;

    if v7 then
        v8 = v7.Instance;
    else
        v8 = v7;
    end;

    local v9;

    if v8 then
        v9 = v6(v8);
    else
        v9 = v8;
    end;

    u1.CurrentTarget = v9;
    Arrows.Parent = v8 and workspace or script;
    Highlight.Adornee = v9;
    Highlight.Parent = v9;

    if v7 then
        Attachment1.WorldCFrame = Handler.Targeter:GetPivot();
        Attachment2.WorldCFrame = v9 and v9:GetPivot() or CFrame.new(v7.Position);
    end;

    local LastHover = u1.LastHover;

    if LastHover == v9 then
        return;
    end;

    Handler.OnUnhover(LastHover);
    Handler.OnHover(v9);
end);
local u10 = {
    [Enum.UserInputType.MouseButton1] = {}
};
local u11 = {
    [Enum.UserInputType.MouseButton1] = { confirmTarget }
};
UserInputService.InputBegan:Connect(function(u12) -- Line: 99
    -- upvalues: u10 (copy)
    local v13 = u10[u12.KeyCode] or u10[u12.UserInputType];

    if not v13 then
        return;
    end;

    for _, v in v13 do
        task.spawn(function() -- Line: 105
            -- upvalues: v (copy), u12 (copy)
            v(u12);
        end);
    end;
end);
UserInputService.InputEnded:Connect(function(u14) -- Line: 111
    -- upvalues: u11 (copy)
    local v15 = u11[u14.KeyCode] or u11[u14.UserInputType];

    if not v15 then
        return;
    end;

    for _, v in v15 do
        task.spawn(function() -- Line: 117
            -- upvalues: v (copy), u14 (copy)
            v(u14);
        end);
    end;
end);
UserInputService.TouchTap:Connect(function() -- Line: 123
    -- upvalues: u3 (ref), u1 (copy), Highlight (copy), Arrows (copy)
    if u3 then
        return;
    end;

    local Handler = u1.Handler;

    if not Handler then
        return;
    end;

    Handler.OnUnhover(u1.LastHover);

    if u1.CurrentTarget then
        Handler.OnConfirm(u1.CurrentTarget);
        u1.LastHover = nil;
        u1.CurrentTarget = nil;
        u1.Handler = nil;
        Highlight.Parent = nil;
        Arrows.Parent = script;

        return;
    end;

    Handler.OnCancelled();
    u1.LastHover = nil;
    u1.CurrentTarget = nil;
    u1.Handler = nil;
    Highlight.Parent = nil;
    Arrows.Parent = script;
end);

return u1;