-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);

function u1.IsObjectA(p2, p3) -- Line: 9
    if typeof(p3) ~= "string" then
        return warn("Invalid type for argument 2. String expected, got : ", (typeof(p3)));
    end;

    local v4;

    if typeof(p2) == "Instance" then
        v4 = p2:IsA(p3);
    else
        v4 = false;
    end;

    return v4;
end;

function u1.PlaySound(p5, p6, p7, p8, p9) -- Line: 16
    -- upvalues: u1 (copy), Trove (copy), Debris (copy)
    if u1.IsObjectA(p5, "Folder") then
        p5 = p5:GetChildren() or p5;
    end;

    if typeof(p5) == "table" then
        local v10 = Trove.new();

        for _, v in p5 do
            local v11 = u1.PlaySound(v, p6, p7, p8, p9);

            if v11 then
                v10:Add(v11);
            end;
        end;

        return v10;
    end;

    if u1.IsObjectA(p5, "Sound") then
        local v12 = p5:GetAttribute("__unprotected") and p5 and p5 or p5:Clone();
        local TimeLength = p5.TimeLength;

        if u1.IsObjectA(p6, "BasePart") and not p9 then
            p6.Transparency = 1;
            p6.Anchored = true;
            p6.CanCollide = false;
            p6.CanQuery = false;
            p6.CanTouch = false;
        end;

        v12.Volume = p7 or v12.Volume;
        v12.Parent = p6 or workspace;
        v12:Play();

        if not p8 then
            Debris:AddItem(v12, TimeLength + 10);
        end;

        return v12;
    end;
end;

function u1.Emit_Cellular(p13, p14) -- Line: 55
    local v15 = typeof(p14) == "table" and p14 and p14 or {};
    local v16;

    if typeof(p13) == "Instance" then
        v16 = p13:GetAttribute("EmitCount");
    else
        v16 = false;
    end;

    if v15.Skip_Check or p13:IsA("ParticleEmitter") then
        if typeof(v16) == "number" then
            v16 = v16 * (Is_Mobile and 0.5 or 1);
        end;

        if not v15.Protected then
            p13:Emit(v16);
        end;

        return v16;
    end;
end;

function u1.EmitVfx(p17, p18, p19) -- Line: 74
    -- upvalues: u1 (copy), Debris (copy)
    if typeof(p17) ~= "Instance" then
        return;
    end;

    for _, descendant in p17:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            if p18 == nil then
                u1.Emit_Cellular(descendant, {
                    Skip_Check = true
                });
            else
                descendant.Enabled = p18;
            end;
        end;
    end;

    if p19 then
        Debris:AddItem(p17, p17:GetAttribute("Destroy_Delay") or (typeof(p19) == "number" and p19 and p19 or 10));
    end;
end;

return u1;