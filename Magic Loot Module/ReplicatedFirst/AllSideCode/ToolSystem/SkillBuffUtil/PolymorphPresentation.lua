-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local FXUtil = UtilsSystem.FXUtil;
local AssetPaths = UtilsSystem.AssetPaths;
local AssetRegistry = UtilsSystem.AssetRegistry;
local SoundModule = UtilsSystem.SoundModule;
local u1 = {};
local u2 = false;
local u3 = {};
local u4 = { {
        t = 0,
        s = 0.1
    }, {
        t = 0.2,
        s = 0.2
    }, {
        t = 0.36666666666666664,
        s = 1.8
    }, {
        t = 0.4666666666666667,
        s = 0.7
    }, {
        t = 0.6,
        s = 1
    } };

local function _cloneSkillFxModel(p5) -- Line: 51
    -- upvalues: AssetPaths (copy), AssetRegistry (copy)
    if type(p5) ~= "string" or p5 == "" then
        return nil;
    end;

    local v6 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, p5));

    if v6 and v6:IsA("Model") then
        return v6:Clone();
    end;

    return nil;
end;

local function _findHrp(p7) -- Line: 69
    local HumanoidRootPart = p7:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart;
    end;

    return p7.PrimaryPart;
end;

local function _cleanup(p8) -- Line: 81
    -- upvalues: u3 (copy)
    local v9 = u3[p8];

    if not v9 then
        return;
    end;

    u3[p8] = nil;

    if v9.ancestryConn then
        v9.ancestryConn:Disconnect();
    end;

    if v9.appearFx and v9.appearFx.Parent then
        v9.appearFx:Destroy();
    end;
end;

local function _playScaleAnimation(u10) -- Line: 99
    -- upvalues: u4 (copy)
    if not (u10 and u10.Parent) then
        return;
    end;

    u10:ScaleTo(u4[1].s);
    task.spawn(function() -- Line: 105
        -- upvalues: u4 (ref), u10 (copy)
        for i = 2, #u4 do
            local v11 = u4[i];
            local v12 = v11.t - u4[i - 1].t;

            if v12 > 0 then
                local v13 = u10:GetScale();
                local s = v11.s;
                local v14 = 0;

                while v14 < v12 do
                    v14 = v14 + task.wait();

                    if not (u10 and u10.Parent) then
                        return;
                    end;

                    local v15 = math.min(v14 / v12, 1);
                    u10:ScaleTo(v13 + (s - v13) * v15);
                end;
            end;

            if u10 and u10.Parent then
                u10:ScaleTo(v11.s);
            end;
        end;
    end);
end;

function u1.PlayOnEnemy(u16) -- Line: 136
    -- upvalues: RunService (copy), u3 (copy), u4 (copy), SoundModule (copy), Workspace (copy), AssetPaths (copy), AssetRegistry (copy), FXUtil (copy)
    if not (RunService:IsClient() and (u16 and (u16:IsA("Model") and u16.Parent))) then
        return;
    end;

    local v17 = u3[u16];

    if v17 then
        u3[u16] = nil;

        if v17.ancestryConn then
            v17.ancestryConn:Disconnect();
        end;

        if v17.appearFx and v17.appearFx.Parent then
            v17.appearFx:Destroy();
        end;
    end;

    local HumanoidRootPart = u16:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        HumanoidRootPart = u16.PrimaryPart;
    end;

    if not HumanoidRootPart then
        return;
    end;

    if u16 and u16.Parent then
        u16:ScaleTo(u4[1].s);
        task.spawn(function() -- Line: 105
            -- upvalues: u4 (ref), u16 (copy)
            for i = 2, #u4 do
                local v18 = u4[i];
                local v19 = v18.t - u4[i - 1].t;

                if v19 > 0 then
                    local v20 = u16:GetScale();
                    local s = v18.s;
                    local v21 = 0;

                    while v21 < v19 do
                        v21 = v21 + task.wait();

                        if not (u16 and u16.Parent) then
                            return;
                        end;

                        local v22 = math.min(v21 / v19, 1);
                        u16:ScaleTo(v20 + (s - v20) * v22);
                    end;
                end;

                if u16 and u16.Parent then
                    u16:ScaleTo(v18.s);
                end;
            end;
        end);
    end;

    if SoundModule then
        SoundModule:PlaySoundLocal({
            SoundName = "音效-变羊",
            Is2D = false,
            PlayPosition = HumanoidRootPart.Position
        });
    end;

    local v23 = Workspace:FindFirstChild("Debris") or Workspace;
    local v24 = AssetPaths.Resolve(AssetRegistry.BuildModelPath(AssetRegistry.ModelCategory.Skill, "变羊_羊出现特效"));
    local u25;

    if v24 and v24:IsA("Model") then
        u25 = v24:Clone();
    else
        u25 = nil;
    end;

    if not u25 then
        return;
    end;

    u25:PivotTo(HumanoidRootPart:GetPivot());
    u25.Parent = v23;
    FXUtil.Emit_Particles_GetDescendants(u25, true);
    local v26 = {
        ancestryConn = nil,
        appearFx = u25
    };
    u3[u16] = v26;
    v26.ancestryConn = u16.AncestryChanged:Connect(function(p27, p28) -- Line: 172
        -- upvalues: u16 (copy), u3 (ref)
        if p28 == nil then
            local v29 = u16;
            local v30 = u3[v29];

            if not v30 then
                return;
            end;

            u3[v29] = nil;

            if v30.ancestryConn then
                v30.ancestryConn:Disconnect();
            end;

            if v30.appearFx and v30.appearFx.Parent then
                v30.appearFx:Destroy();
            end;
        end;
    end);
    task.delay(2, function() -- Line: 178
        -- upvalues: u25 (copy), u3 (ref), u16 (copy)
        if u25 and u25.Parent then
            u25:Destroy();
        end;

        local v31 = u3[u16];

        if v31 and v31.appearFx == u25 then
            v31.appearFx = nil;
        end;
    end);
end;

local function _onPolymorphAppearTagged(p32) -- Line: 193
    -- upvalues: u1 (copy)
    if not (p32:IsA("Model") and p32.Parent) then
        return;
    end;

    u1.PlayOnEnemy(p32);
end;

function u1.InitTagListen() -- Line: 203
    -- upvalues: u2 (ref), RunService (copy), CollectionService (copy), _onPolymorphAppearTagged (copy)
    if u2 or not RunService:IsClient() then
        return;
    end;

    u2 = true;
    CollectionService:GetInstanceAddedSignal("PolymorphAppear"):Connect(_onPolymorphAppearTagged);

    for _, v in CollectionService:GetTagged("PolymorphAppear") do
        task.defer(_onPolymorphAppearTagged, v);
    end;
end;

if RunService:IsClient() then
    task.defer(function() -- Line: 216
        -- upvalues: u1 (copy)
        u1.InitTagListen();
    end);
end;

return u1;