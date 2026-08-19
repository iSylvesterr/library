-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
game:GetService("ProximityPromptService");
local Lighting = game:GetService("Lighting");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Signal = require(ReplicatedStorage.Packages.Signal);
local Maid = require(game.ReplicatedStorage.Packages.Maid);
require(ReplicatedStorage.Shared.Info.CustomEnum);
local Hotbar = Players.LocalPlayer.PlayerGui:WaitForChild("HUD"):WaitForChild("Hotbar");
local WindowOpenBlur = Lighting:WaitForChild("WindowOpenBlur");
local Size = WindowOpenBlur.Size;
WindowOpenBlur.Size = 0;
WindowOpenBlur.Enabled = true;
local u1 = Knit.CreateController({
    Name = "UI_Manager"
});
local u2 = {};
local u3 = {};
local u4 = 0;
local u5 = false;
local u6 = false;
local u7 = false;
local u8 = nil;
local u9 = nil;
u1.WindowOpened = Signal.new();
u1.WindowClosed = Signal.new();

function u1.SetTutorialWindowLock(p10, p11, p12) -- Line: 55
    -- upvalues: u8 (ref), u9 (ref)
    u8 = p11;
    u9 = p12;
end;

function u1.CloseOpenWindowsQuick(p13, p14) -- Line: 61
    -- upvalues: u5 (ref), u9 (ref), u6 (ref), u2 (copy)
    if u5 then
        return;
    end;

    if u9 then
        return;
    end;

    u6 = true;

    for _, v in u2 do
        v:Destroy();
    end;

    if not p14 then
        p13.HotbarController:CloseInventory(true);
    end;

    u6 = false;
end;

function u1.ToggleWindow(p15, p16, p17, p18, p19) -- Line: 74
    -- upvalues: u5 (ref), u2 (copy), u1 (copy)
    if u5 then
        return;
    end;

    if u2[p16] then
        u1:CloseWindow(p16, p17, p18);

        return;
    end;

    u1:OpenWindow(p16, p17, p18, p19);
end;

function u1.AdjustWindowPos(p20, p21) -- Line: 84
    -- upvalues: Hotbar (copy)
    local Position = p21.Position;
    local Y = Hotbar.LowerSection.LowerHotbarSlots.AbsolutePosition.Y;
    local v22 = p21.AbsolutePosition.Y + p21.AbsoluteSize.Y;

    if Y < v22 then
        p21.Position = UDim2.new(Position.X.Scale, 0, Position.Y.Scale, -(v22 - Y));

        return;
    end;

    p21.Position = UDim2.new(Position.X.Scale, 0, Position.Y.Scale, 0);
end;

function u1.GetWindowsOpen(p23, p24) -- Line: 104
    -- upvalues: u2 (copy)
    for i, _ in u2 do
        if i ~= p24 then
            return true;
        end;
    end;

    return false;
end;

function u1.OpenWindow(u25, u26, p27, p28, p29, p30) -- Line: 120
    -- upvalues: u5 (ref), u8 (ref), u2 (copy), u7 (ref), u1 (copy), Maid (copy), TweenService (copy), WindowOpenBlur (copy), Size (copy), u4 (ref), u6 (ref)
    if not p28 and u5 then
        return;
    end;

    if u8 and u26 ~= u8 then
        return;
    end;

    if u2[u26] then
        return;
    end;

    if not p29 then
        u7 = true;
        u1:CloseOpenWindowsQuick();
        u7 = false;
    end;

    u2[u26] = Maid.new();
    u25.WindowOpened:Fire(u26);
    local Position = u26.Position;
    u26.Visible = true;
    local u31 = nil;
    local u32 = nil;

    if p27 then
        if typeof(p27) == "string" and (p27 == "fade" and u26:IsA("CanvasGroup")) then
            u26.Position = Position;
            u26.GroupTransparency = 1;
            u31 = TweenService:Create(u26, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                GroupTransparency = 0
            });
            u31:Play();
        else
            if typeof(p27) == "string" and p27 == "down" then
                u26.Position = UDim2.new(0.5, 0, 0, -u26.AbsoluteSize.Y);
            else
                u26.Position = UDim2.new(0.5, 0, 1, u26.AbsoluteSize.Y / 2);
            end;

            u31 = TweenService:Create(u26, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = Position
            });
            u31:Play();
        end;

        if not (u25:GetWindowsOpen(u26) or p30) then
            WindowOpenBlur.Size = 0;
            u32 = TweenService:Create(WindowOpenBlur, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {
                Size = Size
            });
            u32:Play();
        end;
    else
        u26.Position = Position;

        if not p30 then
            WindowOpenBlur.Size = Size;
        end;
    end;

    u2[u26]:GiveTask(function() -- Line: 197
        -- upvalues: u31 (ref), u32 (ref), u26 (copy), Position (copy), u2 (ref), u4 (ref), u25 (copy), WindowOpenBlur (ref), u6 (ref), u7 (ref)
        if u31 then
            u31:Cancel();
        end;

        if u32 then
            u32:Cancel();
        end;

        u26.Position = Position;
        u26.Visible = false;
        u2[u26] = nil;
        u4 = os.clock();
        local v33 = u25:GetWindowsOpen(u26);

        if not v33 then
            WindowOpenBlur.Size = 0;
        end;

        u25.WindowClosed:Fire(u26, u6, u7, v33);
    end);
end;

function u1.CloseWindow(p34, u35, p36, p37) -- Line: 222
    -- upvalues: u5 (ref), u9 (ref), u2 (copy), u3 (copy), TweenService (copy), WindowOpenBlur (copy), Size (copy)
    if not p37 and u5 then
        return;
    end;

    if not p37 and (u9 and u35 == u9) then
        return;
    end;

    if not u2[u35] then
        return;
    end;

    if u3[u35] then
        return;
    end;

    u3[u35] = true;

    if u35 == "Quests" then
        u2[u35]:Destroy();
        u3[u35] = false;

        return;
    end;

    local u38 = nil;

    if p36 then
        local u39;

        if typeof(p36) == "string" and (p36 == "fade" and u35:IsA("CanvasGroup")) then
            u35.GroupTransparency = 0;
            u39 = TweenService:Create(u35, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                GroupTransparency = 1
            });
            u39:Play();
        elseif typeof(p36) == "string" and p36 == "down" then
            u39 = TweenService:Create(u35, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, 0, -u35.AbsoluteSize.Y)
            });
            u39:Play();
        else
            u39 = TweenService:Create(u35, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, 1, u35.AbsoluteSize.Y / 2)
            });
            u39:Play();
        end;

        if not p34:GetWindowsOpen(u35) then
            WindowOpenBlur.Size = Size;
            u38 = TweenService:Create(WindowOpenBlur, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {
                Size = 0
            });
            u38:Play();
        end;

        u2[u35]:GiveTask(function() -- Line: 292
            -- upvalues: u39 (ref), u38 (ref)
            if u39 then
                u39:Cancel();
            end;

            if u38 then
                u38:Cancel();
            end;
        end);
        u2[u35]:GiveTask(u39.Completed:Connect(function() -- Line: 301
            -- upvalues: u2 (ref), u35 (copy)
            u2[u35]:Destroy();
        end));
    else
        u2[u35]:Destroy();
    end;

    u3[u35] = false;
end;

function u1.Lock(p40) -- Line: 312
    -- upvalues: u5 (ref)
    u5 = true;
end;

function u1.Unlock(p41) -- Line: 317
    -- upvalues: u5 (ref)
    u5 = false;
end;

function u1.IsLocked(p42) -- Line: 322
    -- upvalues: u5 (ref)
    return u5;
end;

function u1.IsOpen(p43) -- Line: 326
    -- upvalues: u2 (copy)
    local v44, v45, v46;
    v44, v45, v46 = u2, nil, nil;
    local v47, v48, v49;

    if type(v44) == "function" then
        v47, v48 = v44(v45, v49);
    else
        v47, v48 = next(v44, v49);
    end;

    v49 = v47;

    return true;
end;

function u1.IsOpenBuffered(p50, p51) -- Line: 335
    -- upvalues: u4 (ref)
    return os.clock() - u4 < p51;
end;

function u1.KnitInit(p52) -- Line: 340
    -- upvalues: Knit (copy)
    p52.HotbarController = Knit.GetController("HotbarController");

    for _, child in script:GetChildren() do
        require(child)(p52);
    end;
end;

return u1;