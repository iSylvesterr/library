-- Decompiled with Potassium's decompiler.

local u1 = {};
local RunService = game:GetService("RunService");
local Debris = game:GetService("Debris");
local TweenService = game:GetService("TweenService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local VisibleMgr = UtilsSystem.VisibleMgr;
local InsMgr = UtilsSystem.InsMgr;
local u2 = {};

local function _disconnectGhostStep(p3) -- Line: 33
    -- upvalues: u2 (copy)
    local v4 = u2[p3];

    if v4 then
        v4:Disconnect();
        u2[p3] = nil;
    end;
end;

local function _prepareShadowVisual(p5, p6, p7, p8) -- Line: 54
    -- upvalues: Debris (copy), TweenService (copy)
    for _, child in pairs(p5:GetChildren()) do
        if child:IsA("LocalScript") or child:IsA("BillboardGui") then
            child:Destroy();
        end;
    end;

    local v9 = {};

    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("Shirt") or (descendant:IsA("Pants") or (descendant:IsA("Decal") or (descendant:IsA("ParticleEmitter") or (descendant:IsA("Beam") or (descendant:IsA("BillboardGui") or (descendant:IsA("SurfaceGui") or descendant:IsA("Texture"))))))) then
            Debris:AddItem(descendant, 0);
        elseif descendant:IsA("MeshPart") then
            descendant.Transparency = descendant.Transparency + (1 - descendant.Transparency) * p7;
            descendant.Material = Enum.Material.Neon;
            descendant.TextureID = "";
            descendant.Color = p6;
            table.insert(v9, descendant);
        elseif descendant:IsA("Part") then
            descendant.Transparency = descendant.Transparency + (1 - descendant.Transparency) * p7;
            descendant.Material = Enum.Material.Neon;
            descendant.Color = p6;
            table.insert(v9, descendant);
        elseif descendant:IsA("SpecialMesh") then
            descendant.TextureId = "";
        elseif descendant:IsA("BasePart") then
            table.insert(v9, descendant);
        end;
    end;

    for _, v in v9 do
        if v.Parent then
            TweenService:Create(v, TweenInfo.new(p8), {
                Transparency = 1
            }):Play();
        end;
    end;
end;

function u1.Spawn_Normal_Ghost(p10, p11, p12, p13, p14) -- Line: 117
    -- upvalues: VisibleMgr (copy), _prepareShadowVisual (copy), Debris (copy)
    if not p10 then
        return;
    end;

    local v15 = p12 or Color3.new(0, 0, 0);
    local v16 = p11 or 0.5;
    p10.Archivable = true;
    local u17 = p10:Clone();
    p10.Archivable = false;

    if u17.PrimaryPart then
        u17.PrimaryPart:RemoveTag("NameTag");
    end;

    u17.Name = p10.Name .. "Shadow";
    u17.Parent = workspace;
    VisibleMgr.AnchoredAll(u17);
    VisibleMgr.UnQueryAll(u17);
    VisibleMgr.UnCollideAll(u17);
    VisibleMgr.UnTouchAll(u17);
    VisibleMgr.SetPlayerCollideID(u17);
    u17:ScaleTo(p14 or 1);
    _prepareShadowVisual(u17, v15, p13 or 0.5, v16);
    task.delay(v16, function() -- Line: 162
        -- upvalues: Debris (ref), u17 (copy)
        Debris:AddItem(u17, 0);
    end);
end;

function u1.Spawn_Several_Ghosts(u18, u19, u20, u21, p22, p23) -- Line: 176
    -- upvalues: u1 (copy)
    local u24 = p22 or 1;
    local u25 = p23 or 0.5;
    task.spawn(function() -- Line: 187
        -- upvalues: u24 (ref), u18 (copy), u1 (ref), u19 (copy), u20 (copy), u21 (copy), u25 (ref)
        for _ = 1, u24 do
            if u18 then
                u1.Spawn_Normal_Ghost(u18, u19, u20, u21);
            end;

            task.wait(u25);
        end;
    end);
end;

function u1.Ghost_Shadow_On(u26, u27, u28, u29, p30) -- Line: 205
    -- upvalues: InsMgr (copy), u2 (copy), RunService (copy), u1 (copy)
    if not u26 then
        return;
    end;

    local u31 = InsMgr.GetIns("GhostShadow", "BoolValue", u26);

    if u31.Value then
        return;
    end;

    u31.Value = true;
    local v32 = u2[u26];

    if v32 then
        v32:Disconnect();
        u2[u26] = nil;
    end;

    local u33 = 0;
    local u34 = p30 or 0.1;
    u2[u26] = RunService.RenderStepped:Connect(function(p35) -- Line: 228
        -- upvalues: u26 (copy), u31 (copy), u2 (ref), u33 (ref), u34 (copy), u1 (ref), u27 (copy), u28 (copy), u29 (copy)
        if u26.Parent and (u31.Parent and u31.Value ~= false) then
            if u34 <= u33 then
                u1.Spawn_Normal_Ghost(u26, u27, u28, u29);
                u33 = 0;
            end;

            u33 = u33 + p35;

            return;
        end;

        local v36 = u26;
        local v37 = u2[v36];

        if v37 then
            v37:Disconnect();
            u2[v36] = nil;
        end;
    end);
end;

function u1.Ghost_Shadow_Off(p38) -- Line: 248
    -- upvalues: u2 (copy)
    if not p38 then
        return;
    end;

    local GhostShadow = p38:FindFirstChild("GhostShadow");

    if GhostShadow and GhostShadow:IsA("BoolValue") then
        GhostShadow.Value = false;
    end;

    local v39 = u2[p38];

    if v39 then
        v39:Disconnect();
        u2[p38] = nil;
    end;
end;

return u1;