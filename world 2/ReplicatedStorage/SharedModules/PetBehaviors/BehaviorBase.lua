-- Decompiled with Potassium's decompiler.

local v1 = {};
v1.__index = v1;
v1.Name = "BehaviorBase";

function v1.New(p2, p3) -- Line: 9
    local v4 = setmetatable({}, p2);
    v4.Player = p3.Player;
    v4.PetId = p3.PetId;
    v4.Slot = p3.Slot;
    v4.Species = p3.Species;
    v4.Module = p3.Module;
    v4.Config = p3.Config or {};
    v4.Control = p3.Control;
    v4.State = nil;
    v4.StateEnteredAt = 0;
    v4.StartedAt = 0;
    v4.Done = false;
    v4.StopReason = nil;
    v4.States = v4.States or {};

    return v4;
end;

function v1.CanStart(p5) -- Line: 37
    return true;
end;

function v1.GetInitialState(p6) -- Line: 42
    return nil;
end;

function v1.Start(p7) -- Line: 47
    p7.StartedAt = os.clock();
    p7.Done = false;
    p7.StopReason = nil;

    if p7.Slot then
        p7.Slot:SetAttribute("PetClaim", p7.Name);
    end;

    local v8 = p7:GetInitialState();

    if v8 then
        p7:TransitionTo(v8);
    end;
end;

function v1.Update(p9, p10, p11) -- Line: 65
    if p9.Done then
        return;
    end;

    if not (p9.Slot and p9.Slot.Parent) then
        p9:Stop("SlotGone");

        return;
    end;

    if not (p9.Player and p9.Player.Parent) then
        p9:Stop("PlayerLeft");

        return;
    end;

    local v12 = p9.State and p9.States[p9.State];

    if v12 and v12.Update then
        v12.Update(p9, p10, p11);
    end;
end;

function v1.TransitionTo(p13, p14) -- Line: 87
    local v15 = p13.State and p13.States[p13.State];

    if v15 and v15.Exit then
        v15.Exit(p13);
    end;

    p13.State = p14;
    p13.StateEnteredAt = os.clock();
    local v16 = p13.States[p14];

    if v16 and v16.Enter then
        v16.Enter(p13);
    end;
end;

function v1.TimeInState(p17) -- Line: 103
    return os.clock() - p17.StateEnteredAt;
end;

function v1.Stop(p18, p19) -- Line: 108
    if p18.Done then
        return;
    end;

    p18.Done = true;
    p18.StopReason = p19 or "Unknown";
    local v20 = p18.State and p18.States[p18.State];

    if v20 and v20.Exit then
        v20.Exit(p18);
    end;

    if p18.OnStop then
        p18:OnStop(p18.StopReason);
    end;

    if p18.Control and p18.Control.ClearGoal then
        p18.Control:ClearGoal();
    end;

    if p18.Slot and p18.Slot.Parent then
        p18.Slot:SetAttribute("PetClaim", nil);
    end;
end;

function v1.OnEvent(p21, p22, p23) -- Line: 136
    local v24 = p21.State and p21.States[p21.State];

    if v24 and v24.OnEvent then
        v24.OnEvent(p21, p22, p23);
    end;
end;

function v1.IsDone(p25) -- Line: 147
    return p25.Done;
end;

return v1;