-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local Component = require(ReplicatedStorage.Packages.Component);
local Maid = require(ReplicatedStorage.Packages.Maid);
local PetAssets = require(ReplicatedStorage.Shared.Utility.PetAssets);
local PetConfig = require(ReplicatedStorage.Shared.Info.PetConfig);
local CustomEnum = require(ReplicatedStorage.Shared.Info.CustomEnum);
require(ReplicatedStorage.Shared.Info.Constants);
require(ReplicatedStorage.Client.Controllers.UI_Manager);
local EggshellVfx = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Greedy"):WaitForChild("VFX"):WaitForChild("EggshellVfx");
local v1 = Component.new({
    Tag = "PlotEgg"
});
local u2 = Color3.fromHex("#d3be96");
local u3 = Color3.fromHex("#0989cf");
local u4 = Color3.fromHex("#ff66cc");
local u5 = Color3.fromHex("#d53c52");
local u6 = Color3.fromHex("#d5c500");
local u7 = Random.new();

function v1.Start(u8) -- Line: 36
    -- upvalues: Knit (copy), Maid (copy), u2 (copy), u3 (copy), u4 (copy), u5 (copy), u6 (copy), CustomEnum (copy), RunService (copy), u7 (copy), TweenService (copy), PetAssets (copy), EggshellVfx (copy), Debris (copy), Players (copy), PetConfig (copy)
    Knit.OnStart():await();
    u8.ParticleController = Knit.GetController("ParticleController");
    u8.SoundController = Knit.GetController("SoundController");
    u8._maid = Maid.new();
    local v9 = u8.Instance:GetAttribute("EggId");
    local u10;

    if v9 == "EggCommon" then
        u10 = u2;
    elseif v9 == "EggRare" then
        u10 = u3;
    elseif v9 == "EggEpic" then
        u10 = u4;
    elseif v9 == "EggLegendary" then
        u10 = u5;
    elseif v9 == "EggMythic" then
        u10 = u6;
    else
        u10 = u2;
    end;

    local PrimaryPart = u8.Instance.PrimaryPart;

    if not PrimaryPart then
        local v11 = os.clock();

        repeat
            task.wait();
            PrimaryPart = u8.Instance.PrimaryPart;
        until PrimaryPart or (not u8.Instance.Parent or os.clock() - v11 > 10);

        if not PrimaryPart then
            return;
        end;
    end;

    local CFrame2 = PrimaryPart.CFrame;
    local NumberValue = Instance.new("NumberValue", script);
    local NumberValue2 = Instance.new("NumberValue", script);
    local u12 = 0;
    u8._maid:GiveTask(NumberValue.Changed:Connect(function() -- Line: 79
        -- upvalues: NumberValue2 (copy), NumberValue (copy), u8 (copy), CFrame2 (copy), u12 (ref)
        local v13 = NumberValue2.Value * math.sin(NumberValue.Value);
        local v14 = math.rad(v13);
        u8.Instance:PivotTo(CFrame2 * CFrame.Angles(math.cos(u12) * v14, 0, math.sin(u12) * v14));
    end));
    local u15 = nil;
    local u16 = nil;

    local function processEggState(p17) -- Line: 89
        -- upvalues: u15 (ref), CustomEnum (ref), u16 (ref), Maid (ref), RunService (ref), u7 (ref), NumberValue (copy), NumberValue2 (copy), u12 (ref), TweenService (ref), u8 (copy), PetAssets (ref), CFrame2 (copy), EggshellVfx (ref), u10 (ref), Debris (ref), Players (ref), PetConfig (ref)
        if u15 == p17 then
            return;
        end;

        if u15 == CustomEnum.EGG_STATE.HATCHING then
            return;
        end;

        u15 = p17;

        if u16 then
            u16:Destroy();
        end;

        u16 = Maid.new();

        if p17 == CustomEnum.EGG_STATE.IDLE then
            return;
        end;

        if p17 ~= CustomEnum.EGG_STATE.READY then
            if p17 == CustomEnum.EGG_STATE.HATCHING then
                local v18 = u8.Instance:GetAttribute("PetID");
                local v19 = PetAssets.resolvePet(v18);
                local u20, u21;

                if v19 then
                    u20 = v19:Clone();
                    u20.Parent = script;

                    for _, descendant in u20:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            descendant.CanCollide = false;
                            descendant.CanTouch = false;
                            descendant.CanQuery = false;
                        end;
                    end;

                    u21 = Instance.new("NumberValue", script);
                    u16:GiveTask(u21.Changed:Connect(function() -- Line: 162
                        -- upvalues: u20 (ref), u21 (ref)
                        if not u20 then
                            return;
                        end;

                        u20:ScaleTo(u21.Value);
                    end));
                    u16:GiveTask(function() -- Line: 167
                        -- upvalues: u21 (ref)
                        if u21 then
                            u21:Destroy();
                        end;
                    end);
                    u21.Value = 0.5;
                else
                    u20 = nil;
                    u21 = nil;
                end;

                u8.SoundController:PlaySoundAtPosition("EggHatch", CFrame2.Position, {
                    RollOffMinDistance = 30,
                    RollOffMaxDistance = 350,
                    AcousticSimulationEnabled = false,
                    RollOffMode = Enum.RollOffMode.Linear
                });
                local v22 = nil;
                local v23 = nil;

                for i = 1, 3 do
                    if v22 then
                        v22:Cancel();
                    end;

                    if v23 then
                        v23:Cancel();
                    end;

                    NumberValue.Value = 0;
                    NumberValue2.Value = i * 5 + 15;
                    u12 = u7:NextNumber(0, 6.283185307179586);
                    u8.ParticleController:SimpleParticleAt("Hatching", CFrame2.Position, 3);
                    local v24 = i == 3 and 0.4 or 0.5;
                    v22 = TweenService:Create(NumberValue, TweenInfo.new(v24, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                        Value = (i >= 2 and 3 or 2) * 2 * 3.141592653589793
                    });
                    v22:Play();

                    if i < 3 then
                        v23 = TweenService:Create(NumberValue2, TweenInfo.new(v24, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                            Value = 0
                        });
                        v23:Play();
                    end;

                    task.wait(v24);

                    if i < 3 then
                        task.wait(0.5);
                    end;
                end;

                for _, child in u8.Instance:GetChildren() do
                    if child:IsA("BasePart") then
                        child.Transparency = 1;
                    end;
                end;

                local v25 = EggshellVfx:Clone();

                for _, descendant in v25:GetDescendants() do
                    if descendant:isA("BasePart") then
                        descendant.CollisionGroup = "NoCollide";
                        descendant.Anchored = false;
                        descendant.Color = u10;
                        local v26 = descendant.Name == "Base" and descendant:FindFirstChild("LaunchDir");

                        if v26 then
                            descendant.Velocity = (v26.WorldCFrame.Position - descendant.CFrame.Position).Unit * 25;
                        end;

                        TweenService:Create(descendant, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 3), {
                            Transparency = 1
                        }):Play();
                    end;
                end;

                v25:PivotTo(CFrame2);
                v25.Parent = workspace;
                Debris:AddItem(v25, 4);

                if u20 then
                    local v27 = CFrame2;
                    local Character = Players.LocalPlayer.Character;

                    if Character then
                        Character = Character:FindFirstChild("HumanoidRootPart");
                    end;

                    if Character then
                        local v28 = Character.Position - CFrame2.Position;
                        local v29 = Vector3.new(v28.X, 0, v28.Z);

                        if v29.Magnitude > 0.01 then
                            v27 = CFrame.new(CFrame2.Position) * CFrame.Angles(0, math.atan2(-v29.X, -v29.Z) + PetConfig.DefaultYawFlip, 0);
                        end;
                    end;

                    u20:PivotTo(v27);
                    u20.Parent = workspace;
                    Debris:AddItem(u20, 2.5);
                    TweenService:Create(u21, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Value = 1
                    }):Play();
                end;

                u8.ParticleController:SimpleParticleAt("EggHatch", CFrame2.Position + Vector3.new(0, 2, 0), 3);
            end;

            return;
        end;

        local u30 = nil;
        local u31 = nil;
        local u32 = 0;
        local u33 = 0;
        u16:GiveTask(RunService.RenderStepped:Connect(function(p34) -- Line: 108
            -- upvalues: u33 (ref), u32 (ref), u7 (ref), u30 (ref), u31 (ref), NumberValue (ref), NumberValue2 (ref), u12 (ref), TweenService (ref)
            u33 = u33 + p34;

            if u33 < u32 then
                return;
            end;

            u32 = u7:NextNumber(2, 5);
            u33 = 0;

            if u30 then
                u30:Cancel();
            end;

            if u31 then
                u31:Cancel();
            end;

            NumberValue.Value = 0;
            NumberValue2.Value = 5;
            u12 = u7:NextNumber(0, 6.283185307179586);
            u30 = TweenService:Create(NumberValue, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                Value = 12.566370614359172
            });
            u30:Play();
            u31 = TweenService:Create(NumberValue2, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                Value = 0
            });
            u31:Play();
        end));
        u16:GiveTask(function() -- Line: 135
            -- upvalues: u30 (ref), NumberValue (ref)
            if u30 then
                u30:Cancel();
            end;

            NumberValue.Value = 0;
        end);
    end;

    processEggState(u8.Instance:GetAttribute("EggState"));
    u8._maid:GiveTask(u8.Instance:GetAttributeChangedSignal("EggState"):Connect(function() -- Line: 285
        -- upvalues: processEggState (copy), u8 (copy)
        processEggState(u8.Instance:GetAttribute("EggState"));
    end));
    u8._maid:GiveTask(function() -- Line: 289
        -- upvalues: NumberValue (copy), NumberValue2 (copy), u16 (ref)
        if NumberValue then
            NumberValue:Destroy();
        end;

        if NumberValue2 then
            NumberValue2:Destroy();
        end;

        if u16 then
            u16:Destroy();
        end;
    end);
end;

function v1.Stop(p35) -- Line: 297
    if p35._maid then
        p35._maid:Destroy();
    end;
end;

return v1;