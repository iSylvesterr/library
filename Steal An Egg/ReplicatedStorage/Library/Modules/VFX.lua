-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Observers = require(ReplicatedStorage.Library.Modules.Packages.Observers);
local Timer = require(ReplicatedStorage.Library.Modules.Packages.Timer);
local u11 = {
    copy = function(p1, p2, p3) -- Line: 13, Name: copy
        if p3 == nil then
            p3 = p1:IsA("Attachment") and workspace.Terrain or workspace.CurrentCamera;
        end;

        local v4 = p1:Clone();

        if v4:IsA("Attachment") then
            v4.WorldCFrame = typeof(p2) == "CFrame" and p2 and p2 or CFrame.new(p2);
        elseif v4:IsA("PVInstance") then
            v4:PivotTo(typeof(p2) == "CFrame" and p2 and p2 or CFrame.new(p2));
        else
            v4:Destroy();
            error("Can\'t move Container");
        end;

        v4.Parent = p3;

        return v4;
    end,

    weld = function(p5, p6) -- Line: 38, Name: weld
        local Weld = Instance.new("Weld");
        Weld.Part0 = p5;
        Weld.Part1 = p6;
        Weld.Parent = p5;

        return Weld;
    end,

    rescale = function(p7, p8) -- Line: 46, Name: rescale
        local Parent = p7.Parent;
        local Model = Instance.new("Model");
        p7.Parent = Model;
        Model:ScaleTo(p8);
        p7.Parent = Parent;
    end,

    enable = function(p9) -- Line: 54, Name: enable
        for _, descendant in pairs(p9:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
                descendant.Enabled = true;
            end;
        end;
    end,

    disable = function(p10) -- Line: 62, Name: disable
        for _, descendant in pairs(p10:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
                descendant.Enabled = false;
            end;
        end;
    end
};

local function emitEmitter(u12) -- Line: 70
    local v13 = tonumber(u12:GetAttribute("EmitCount")) or (tonumber(u12.Name) or 0);
    local v14 = tonumber(u12:GetAttribute("EmitDuration")) or 0;
    u12:Emit(v13);

    if v14 > 0 then
        u12.Enabled = true;
        task.delay(v14, function() -- Line: 76
            -- upvalues: u12 (copy)
            u12.Enabled = false;
        end);
    end;
end;

function u11.emit(u15) -- Line: 82
    -- upvalues: emitEmitter (copy)
    for _, descendant in pairs(u15:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            local v16 = descendant:GetAttribute("EmitDelay");

            if v16 == nil then
                emitEmitter(descendant);
            else
                task.delay(v16, emitEmitter, descendant);
            end;
        end;
    end;

    if u15:IsA("ParticleEmitter") then
        local v17 = u15:GetAttribute("EmitDelay");
        local u18 = u15:GetAttribute("EmitCount") or (tonumber(u15.Name) or 0);

        if v17 ~= nil then
            task.delay(v17, function() -- Line: 98
                -- upvalues: u15 (copy), u18 (copy)
                u15:Emit(u18);
            end);

            return;
        end;

        u15:Emit(u18);
    end;
end;

function u11.emitLoop(p19, p20) -- Line: 108
    p19:SetAttribute("LoopTimer", p20);
    p19:AddTag("EmitLoop");
end;

if RunService:IsClient() then
    Observers.observeTag("EmitLoop", function(u21) -- Line: 114
        -- upvalues: Observers (copy), Timer (copy), u11 (copy)
        return Observers.observeAttribute(u21, "LoopTimer", function(p22) -- Line: 115
            -- upvalues: Timer (ref), u11 (ref), u21 (copy)
            if type(p22) ~= "number" then
                return nil;
            end;

            local u23 = Timer.Simple(p22, function() -- Line: 119
                -- upvalues: u11 (ref), u21 (ref)
                u11.emit(u21);
            end, true);

            return function() -- Line: 122
                -- upvalues: u23 (copy)
                u23:Disconnect();
            end;
        end);
    end, { workspace });
end;

return u11;