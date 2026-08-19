-- Decompiled with Potassium's decompiler.

local BehaviorBase = require(script.Parent.BehaviorBase);
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RagdollModule = require(ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("RagdollModule"));
local PetSizes = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetSizes"));
local PetTypes = require(ReplicatedStorage:WaitForChild("SharedData"):WaitForChild("PetTypes"));
local PetFlags = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Flags"):WaitForChild("PetFlags"));
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Services = game:GetService("ServerScriptService"):WaitForChild("Services");

local function PlayEagleSound(p1, p2, p3) -- Line: 38
    -- upvalues: SoundService (copy), Debris (copy)
    if not (p1 and p1.Parent) then
        return;
    end;

    local SFX = SoundService:FindFirstChild("SFX");

    if SFX then
        SFX = SFX:FindFirstChild("BaldEagle");
    end;

    if SFX then
        SFX = SFX:FindFirstChild(p2);
    end;

    if not (SFX and SFX:IsA("Sound")) then
        return;
    end;

    local v4 = SFX:Clone();
    v4.Volume = p3;
    v4.Parent = p1;
    v4:Play();
    Debris:AddItem(v4, (v4.TimeLength <= 0 and 5 or v4.TimeLength) + 1);
end;

local u5 = nil;

local function GetBeeDefenseService() -- Line: 53
    -- upvalues: u5 (ref), Services (copy)
    if not u5 then
        u5 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    return u5;
end;

local u6 = nil;
local u7 = 20;

local function ExemptVictim(u8) -- Line: 65
    -- upvalues: u6 (ref), Services (copy), u7 (ref)
    if not (u8 and u8.Parent) then
        return;
    end;

    if not u6 then
        local AntiCheatService = Services:WaitForChild("AntiCheatService");
        u6 = require(AntiCheatService:WaitForChild("Exemptions"));
        u7 = require(AntiCheatService:WaitForChild("Config")).Exemption.BEAR_TACKLE_DURATION or u7;
    end;

    pcall(function() -- Line: 73
        -- upvalues: u6 (ref), u8 (copy), u7 (ref)
        u6:Exempt(u8, u7);
    end);
end;

local u9 = nil;

local function DropStolenFruit(u10, u11) -- Line: 82
    -- upvalues: u9 (ref), Services (copy)
    if not (u11 and u11.Parent) then
        return;
    end;

    if not u9 then
        local success, result = pcall(require, Services:WaitForChild("StealService"));

        if success then
            u9 = result;
        end;
    end;

    if u9 then
        pcall(function() -- Line: 89
            -- upvalues: u9 (ref), u11 (copy)
            u9:CancelActiveSteal(u11);
        end);
        pcall(function() -- Line: 90
            -- upvalues: u9 (ref), u10 (copy), u11 (copy)
            u9:RecoverStolenFruit(u10, u11, true);
        end);
    end;
end;

local u12 = setmetatable({}, {
    __mode = "k"
});

local function IsShovelAggroOnCooldown(p13) -- Line: 142
    -- upvalues: u12 (copy)
    if not p13 then
        return false;
    end;

    local v14 = u12[p13];
    local v15;

    if v14 == nil then
        v15 = false;
    else
        v15 = os.clock() < v14;
    end;

    return v15;
end;

local function MarkShovelAggroStarted(p16, p17) -- Line: 148
    -- upvalues: u12 (copy)
    if not p16 then
        return;
    end;

    u12[p16] = os.clock() + p17;
end;

local u18 = {};

local function ShooKey(p19, p20) -- Line: 159
    return tostring(p19) .. ":" .. tostring(p20);
end;

local function IsVictimShooed(p21, p22) -- Line: 163
    -- upvalues: u18 (copy)
    local v23 = u18[tostring(p21) .. ":" .. tostring(p22)];
    local v24;

    if v23 == nil then
        v24 = false;
    else
        v24 = os.clock() < v23;
    end;

    return v24;
end;

local function MarkVictimShooed(p25, p26, p27) -- Line: 168
    -- upvalues: u18 (copy)
    u18[tostring(p25) .. ":" .. tostring(p26)] = os.clock() + p27;
end;

local function PickBySize(p28, p29, p30, p31) -- Line: 173
    -- upvalues: PetSizes (copy)
    local v32 = PetSizes.Normalize(p28);

    if v32 == "Huge" then
        return p31;
    end;

    if v32 == "Big" then
        return p30;
    end;

    return p29;
end;

local u33 = {
    Slot = Color3.fromRGB(0, 170, 255),
    Base = Color3.fromRGB(0, 255, 0),
    Target = Color3.fromRGB(255, 40, 40),
    Victim = Color3.fromRGB(255, 230, 0)
};

local function DebugLog(p34, ...) -- Line: 191
    if not p34.Debug then
        return;
    end;

    print("[EagleDive]", ...);
end;

local function SetMarker(p35, p36, p37) -- Line: 196
    -- upvalues: u33 (copy)
    if not p35.Debug then
        return;
    end;

    if not p35._Markers then
        p35._Markers = {};
    end;

    local v38 = p35._Markers[p36];

    if not p37 then
        if v38 then
            v38:Destroy();
            p35._Markers[p36] = nil;
        end;

        return;
    end;

    if not (v38 and v38.Parent) then
        v38 = Instance.new("Part");
        v38.Name = "EagleDebug_" .. p36;
        v38.Shape = Enum.PartType.Ball;
        v38.Size = Vector3.new(1.5, 1.5, 1.5);
        v38.Color = u33[p36] or Color3.new(1, 1, 1);
        v38.Material = Enum.Material.Neon;
        v38.Anchored = true;
        v38.CanCollide = false;
        v38.CanQuery = false;
        v38.CanTouch = false;
        v38.Transparency = 0.4;
        v38.Parent = workspace;
        p35._Markers[p36] = v38;
    end;

    v38.Position = p37;
end;

local function ClearMarkers(p39) -- Line: 225
    if not p39._Markers then
        return;
    end;

    for _, v in p39._Markers do
        if v then
            v:Destroy();
        end;
    end;

    p39._Markers = nil;
end;

local u40 = setmetatable({}, {
    __index = BehaviorBase
});
u40.__index = u40;
u40.Name = "EagleDive";

local function MakeGoalCFrame(p41, p42) -- Line: 239
    local v43 = p42 - p41;

    if v43.Magnitude < 0.001 then
        return CFrame.new(p42);
    end;

    return CFrame.lookAt(p42, p42 + v43.Unit);
end;

local function FlyTo(p44, p45, p46) -- Line: 252
    local v47 = p44.Control:GetSlotPosition();

    if not v47 then
        return;
    end;

    local v48 = (not p44.Module or (not p44.Module.IsFlying or type(p44.Module.AirHeight) ~= "number")) and 0 or p44.Module.AirHeight;
    local v49 = Vector3.new(p45.X, p45.Y - v48, p45.Z);
    p44.Control:SetSlotAttribute("Hovering", true);
    local Control = p44.Control;
    local v50 = v49 - v47;
    local v51;

    if v50.Magnitude < 0.001 then
        v51 = CFrame.new(v49);
    else
        v51 = CFrame.lookAt(v49, v49 + v50.Unit);
    end;

    Control:SetGoal(v51, p46);
end;

local function ClearCombatHover(p52) -- Line: 264
    if p52.Control and p52.Control.SetSlotAttribute then
        p52.Control:SetSlotAttribute("Hovering", nil);
    end;
end;

local function DistanceTo(p53, p54) -- Line: 270
    local v55 = p53.Control:GetSlotPosition();

    return not v55 and (1 / 0) or (p54 - v55).Magnitude;
end;

local function TargetPosition(p56) -- Line: 276
    if not (p56 and p56.Player) then
        return nil;
    end;

    local Character = p56.Player.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart.Position;
    end;

    return nil;
end;

local function OwnerPosition(p57) -- Line: 286
    local Player = p57.Player;

    if not (Player and Player.Parent) then
        return nil;
    end;

    local Character = Player.Character;

    if not Character then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart.Position;
    end;

    return nil;
end;

local function IsUnattackable(p58) -- Line: 299
    return not p58 and true or (p58:GetAttribute("InSafeZone") == true and true or (p58:GetAttribute("IsInOwnGarden") == true and true or p58:GetAttribute("InMinigame") == true));
end;

local function IsTargetStillValid(p59, p60) -- Line: 311
    -- upvalues: u5 (ref), Services (copy)
    if not p60 then
        return false;
    end;

    local Player = p60.Player;

    if not (Player and Player.Parent) then
        return false;
    end;

    if not Player and true or (Player:GetAttribute("InSafeZone") == true and true or (Player:GetAttribute("IsInOwnGarden") == true and true or Player:GetAttribute("InMinigame") == true)) then
        return false;
    end;

    local Character = Player.Character;

    if not Character then
        return false;
    end;

    if not Character:FindFirstChild("HumanoidRootPart") then
        return false;
    end;

    local v61 = Character:FindFirstChildOfClass("Humanoid");

    if not v61 or v61.Health <= 0 then
        return false;
    end;

    if not p60.ShovelAggro then
        return true;
    end;

    if not u5 then
        u5 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    local v62 = u5;

    if v62 then
        v62 = v62:GetShovelAggroTarget(p59.Player);
    end;

    return v62 == Player;
end;

local function PickTarget(p63) -- Line: 331
    -- upvalues: u5 (ref), Services (copy), u12 (copy), u18 (copy)
    if not u5 then
        u5 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    local v64 = u5;

    if not v64 then
        return nil;
    end;

    local v65 = p63.Player and p63.Player.UserId;
    local Slot = p63.Slot;
    local v66;

    if Slot then
        local v67 = u12[Slot];

        if v67 == nil then
            v66 = false;
        else
            v66 = os.clock() < v67;
        end;
    else
        v66 = false;
    end;

    if not v66 then
        local v68 = v64:GetShovelAggroTarget(p63.Player);

        if v68 and (v68 and (v68:GetAttribute("InSafeZone") ~= true and (v68:GetAttribute("IsInOwnGarden") ~= true and v68:GetAttribute("InMinigame") ~= true))) then
            local v69, v70;

            if not v65 then
                v69 = p63.Slot;
                v70 = p63.ShovelAggroCooldown;

                if v69 then
                    u12[v69] = os.clock() + v70;
                end;

                return {
                    ShovelAggro = true,
                    Player = v68
                };
            end;

            local UserId = v68.UserId;
            local v71 = u18[tostring(v65) .. ":" .. tostring(UserId)];
            local v72;

            if v71 == nil then
                v72 = false;
            else
                v72 = os.clock() < v71;
            end;

            if not v72 then
                v69 = p63.Slot;
                v70 = p63.ShovelAggroCooldown;

                if v69 then
                    u12[v69] = os.clock() + v70;
                end;

                return {
                    ShovelAggro = true,
                    Player = v68
                };
            end;
        end;
    end;

    local v73 = v64:PickTargetFor(p63.Player);

    if not (v73 and v73.Player) then
        return nil;
    end;

    local Player = v73.Player;

    if not Player and true or (Player:GetAttribute("InSafeZone") == true and true or (Player:GetAttribute("IsInOwnGarden") == true and true or Player:GetAttribute("InMinigame") == true)) then
        return nil;
    end;

    if v65 then
        local UserId = v73.Player.UserId;
        local v74 = u18[tostring(v65) .. ":" .. tostring(UserId)];
        local v75;

        if v74 == nil then
            v75 = false;
        else
            v75 = os.clock() < v74;
        end;

        if v75 then
            return nil;
        end;
    end;

    return {
        ShovelAggro = false,
        Player = v73.Player
    };
end;

local function BeginPin(p76, p77, p78) -- Line: 356
    -- upvalues: RagdollModule (copy), ExemptVictim (copy)
    local Character = p77.Character;

    if not Character then
        return false;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return false;
    end;

    pcall(function() -- Line: 364
        -- upvalues: RagdollModule (ref), Character (copy)
        RagdollModule:Ragdoll(Character);
    end);
    ExemptVictim(p77);
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "EagleDiveAttachment";
    Attachment.Parent = HumanoidRootPart;
    local AlignPosition = Instance.new("AlignPosition");
    AlignPosition.Name = "EagleDiveAlign";
    AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment;
    AlignPosition.Attachment0 = Attachment;
    AlignPosition.Position = p78;
    AlignPosition.MaxForce = 1000000;
    AlignPosition.MaxVelocity = 120;
    AlignPosition.Responsiveness = 50;
    AlignPosition.ApplyAtCenterOfMass = true;
    AlignPosition.Parent = HumanoidRootPart;
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    p76._PinnedChar = Character;
    p76._PinnedHRP = HumanoidRootPart;
    p76._PinAttachment = Attachment;
    p76._PinAlign = AlignPosition;

    return true;
end;

local function SetPinPosition(p79, p80) -- Line: 392
    if p79._PinAlign and p79._PinAlign.Parent then
        p79._PinAlign.Position = p80;
    end;
end;

local function DestroyPinConstraints(p81) -- Line: 399
    if p81._PinAlign then
        if p81._PinAlign.Parent then
            p81._PinAlign:Destroy();
        end;

        p81._PinAlign = nil;
    end;

    if p81._PinAttachment then
        if p81._PinAttachment.Parent then
            p81._PinAttachment:Destroy();
        end;

        p81._PinAttachment = nil;
    end;
end;

local function ReleasePin(p82) -- Line: 413
    -- upvalues: RagdollModule (copy)
    if p82._PinAlign then
        if p82._PinAlign.Parent then
            p82._PinAlign:Destroy();
        end;

        p82._PinAlign = nil;
    end;

    if p82._PinAttachment then
        if p82._PinAttachment.Parent then
            p82._PinAttachment:Destroy();
        end;

        p82._PinAttachment = nil;
    end;

    if p82._PinnedChar then
        local _PinnedChar = p82._PinnedChar;
        pcall(function() -- Line: 417
            -- upvalues: RagdollModule (ref), _PinnedChar (copy)
            RagdollModule:Unragdoll(_PinnedChar);
        end);
    end;

    p82._PinnedChar = nil;
    p82._PinnedHRP = nil;
end;

local function SpeciesPivotCFrame(p83) -- Line: 428
    if p83 then
        p83 = p83.Pivot;
    end;

    if typeof(p83) == "Vector3" then
        return CFrame.Angles(math.rad(p83.X), math.rad(p83.Y), (math.rad(p83.Z)));
    end;

    return CFrame.identity;
end;

local function ComputeFootOffset(p84) -- Line: 436
    local Y = p84:GetPivot().Position.Y;
    local v85 = (1 / 0);

    for _, descendant in p84:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            local CFrame2 = descendant.CFrame;
            local Size = descendant.Size;
            local v86 = Size.X * 0.5;
            local v87 = Size.Y * 0.5;
            local v88 = Size.Z * 0.5;

            for i = -1, 1, 2 do
                for i2 = -1, 1, 2 do
                    local Y2 = (CFrame2 * Vector3.new(i * v86, i2 * v87, -1 * v88)).Y;

                    if Y2 >= v85 then
                        Y2 = v85;
                    end;

                    v85 = (CFrame2 * Vector3.new(i * v86, i2 * v87, 1 * v88)).Y;

                    if v85 >= Y2 then
                        v85 = Y2;
                    end;
                end;
            end;
        end;
    end;

    return v85 == (1 / 0) and 0 or Y - v85;
end;

local u89 = {};

local function ComputeSlotLocalBase(p90, p91, p92) -- Line: 463
    -- upvalues: u89 (copy), Assets (copy), ComputeFootOffset (copy)
    local v93;

    if p90 then
        v93 = p90.AssetName;
    else
        v93 = p90;
    end;

    if type(v93) ~= "string" then
        return nil;
    end;

    local v94 = v93 .. "|" .. tostring(p91);
    local v95 = u89[v94];

    if v95 ~= nil then
        if v95 == false then
            return nil;
        end;

        return v95;
    end;

    local Pets = Assets:FindFirstChild("Pets");
    local v96 = Pets and Pets:FindFirstChild(v93) or Assets:FindFirstChild(v93);

    if not (v96 and v96:IsA("Model")) then
        if p92 then
            print((`[EagleDive] Base: asset '{v93}' not found under Assets.Pets -- using CarryOffset fallback`));
        end;

        u89[v94] = false;

        return nil;
    end;

    local v97 = v96:Clone();
    local PrimaryPart = v97.PrimaryPart;
    local v98;

    if PrimaryPart then
        v98 = PrimaryPart;
    else
        v98 = v97:FindFirstChild("Torso") or (v97:FindFirstChild("RootPart") or v97:FindFirstChildWhichIsA("BasePart"));

        if v98 then
            if not v98:IsA("BasePart") then
                v98 = PrimaryPart;
            end;
        else
            v98 = PrimaryPart;
        end;
    end;

    if not v98 then
        v97:Destroy();
        u89[v94] = false;

        return nil;
    end;

    v97.PrimaryPart = v98;

    if p90 then
        p90 = p90.Pivot;
    end;

    local v99;

    if typeof(p90) == "Vector3" then
        v99 = CFrame.Angles(math.rad(p90.X), math.rad(p90.Y), (math.rad(p90.Z)));
    else
        v99 = CFrame.identity;
    end;

    v97:PivotTo(v99);

    if p91 ~= 1 then
        v97:ScaleTo(p91);
    end;

    local v100 = nil;

    for _, descendant in v97:GetDescendants() do
        if descendant:IsA("Attachment") and descendant.Name == "Base" then
            v100 = descendant;
            break;
        end;
    end;

    if not v100 then
        if p92 then
            print((`[EagleDive] Base: no attachment named 'Base' in '{v93}' (primary '{v98.Name}') -- using CarryOffset fallback`));
        end;

        v97:Destroy();
        u89[v94] = false;

        return nil;
    end;

    local v101 = ComputeFootOffset(v97);
    local v102 = CFrame.new(0, v101, 0) * v99 * v97:GetPivot():Inverse() * v100.WorldCFrame;

    if p92 then
        local v103 = print;
        local Name = v98.Name;
        local v104 = string.format("%.2f", v101);
        v103((`[EagleDive] Base resolved for '{v93}' scale={p91}: primary='{Name}' footOffset={v104} baseParent='{v100.Parent and v100.Parent.Name}' slotLocalOffset={tostring(v102.Position)}`));
    end;

    v97:Destroy();
    u89[v94] = v102;

    return v102;
end;

local function BasePosition(p105) -- Line: 528
    local Slot = p105.Slot;

    if not (Slot and Slot.Parent) then
        return nil;
    end;

    if p105._BaseLocal then
        return (Slot.CFrame * p105._BaseLocal).Position;
    end;

    return Slot.Position - Vector3.new(0, p105.CarryOffset, 0);
end;

local function ShooEagle(u106, p107) -- Line: 541
    -- upvalues: u18 (copy), u5 (ref), Services (copy), DebugLog (copy)
    if p107 == u106.Player then
        return;
    end;

    local v108 = u106.Target and u106.Target.Player;

    if u106.Player and v108 then
        local UserId = v108.UserId;
        local ShooCooldown = u106.ShooCooldown;
        u18[tostring(u106.Player.UserId) .. ":" .. tostring(UserId)] = os.clock() + ShooCooldown;

        if u106.Target.ShovelAggro then
            if not u5 then
                u5 = require(Services:WaitForChild("BeeDefenseService"));
            end;

            local u109 = u5;

            if u109 then
                pcall(function() -- Line: 551
                    -- upvalues: u109 (copy), u106 (copy)
                    u109:ClearShovelAggro(u106.Player);
                end);
            end;
        end;
    end;

    if p107 and p107.Parent then
        u106.Control:NotifyPlayer(p107, (`You shooed away {u106.Player and (u106.Player.Name or "a player") or "a player"}'s Bald Eagle!`));
    end;

    if u106.Player and (u106.Player.Parent and p107 ~= u106.Player) then
        u106.Control:Notify((`{p107 and (p107.Name or "Someone") or "Someone"} shooed away your Bald Eagle!`));
    end;

    if p107 then
        p107 = p107.Name;
    end;

    local v110 = tostring(p107);

    if v108 then
        v108 = v108.Name;
    end;

    DebugLog(u106, (`Shooed by {v110} off {tostring(v108)}`));
    u106:TransitionTo("ReturnFlight");
end;

local function BuildStates() -- Line: 566
    -- upvalues: PickTarget (copy), DebugLog (copy), FlyTo (copy), IsTargetStillValid (copy), SetMarker (copy), ShooEagle (copy), ComputeSlotLocalBase (copy), BeginPin (copy), DropStolenFruit (copy), PlayEagleSound (copy), ExemptVictim (copy), u5 (ref), Services (copy), RagdollModule (copy)
    return {
        Acquire = {
            Enter = function(p111) -- Line: 570, Name: Enter
                -- upvalues: PickTarget (ref)
                p111.Control:SetSlotAttribute("VisualChaseSpeed", p111.VisualChaseSpeed);
                local v112 = PickTarget(p111);

                if not v112 then
                    p111:TransitionTo("Return");

                    return;
                end;

                p111.Target = v112;
                p111:TransitionTo("Chase");
            end
        },
        Chase = {
            Enter = function(p113) -- Line: 589, Name: Enter
                -- upvalues: DebugLog (ref), FlyTo (ref)
                p113.Control:SetSlotAttribute("AnimOverride", "targetplayer");
                DebugLog(p113, (`Chase start: DiveRadius={p113.DiveRadius} size={tostring(p113._SizeLabel)} attackSpeed={p113.AttackSpeed}`));
                local Target = p113.Target;
                local v114;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v114 = HumanoidRootPart.Position;
                        else
                            v114 = nil;
                        end;
                    else
                        v114 = nil;
                    end;
                else
                    v114 = nil;
                end;

                if v114 then
                    FlyTo(p113, v114, p113.AttackSpeed);
                end;
            end,

            Update = function(p115, p116, p117) -- Line: 597, Name: Update
                -- upvalues: IsTargetStillValid (ref), FlyTo (ref), SetMarker (ref), DebugLog (ref)
                if not IsTargetStillValid(p115, p115.Target) then
                    p115:TransitionTo("Acquire");

                    return;
                end;

                local Target = p115.Target;
                local v118;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v118 = HumanoidRootPart.Position;
                        else
                            v118 = nil;
                        end;
                    else
                        v118 = nil;
                    end;
                else
                    v118 = nil;
                end;

                if not v118 then
                    p115:TransitionTo("Acquire");

                    return;
                end;

                FlyTo(p115, v118, p115.AttackSpeed);
                local v119 = p115.Control:GetSlotPosition();
                SetMarker(p115, "Slot", v119);
                SetMarker(p115, "Target", v118);
                local v120 = p115.Control:GetSlotPosition();
                local v121 = not v120 and (1 / 0) or (v118 - v120).Magnitude;

                if v121 <= p115.DiveRadius then
                    if v119 then
                        local Magnitude = Vector3.new(v118.X - v119.X, 0, v118.Z - v119.Z).Magnitude;
                        DebugLog(p115, (`DIVE trigger: dist3D={string.format("%.2f", v121)} flatXZ={string.format("%.2f", Magnitude)} vertical={string.format("%.2f", v118.Y - v119.Y)} DiveRadius={p115.DiveRadius}`));
                    end;

                    p115:TransitionTo("Dive");

                    return;
                end;

                if p115:TimeInState() < p115.ChaseLegTimeout then
                    return;
                end;

                p115:TransitionTo("Acquire");
            end,

            OnEvent = function(p122, p123, p124) -- Line: 632, Name: OnEvent
                -- upvalues: ShooEagle (ref)
                if p123 == "Scared" then
                    if p124 then
                        p124 = p124.Scarer;
                    end;

                    ShooEagle(p122, p124);
                end;
            end
        },
        Dive = {
            Enter = function(p125) -- Line: 644, Name: Enter
                -- upvalues: ComputeSlotLocalBase (ref), DebugLog (ref), SetMarker (ref), BeginPin (ref), DropStolenFruit (ref), PlayEagleSound (ref)
                local Target = p125.Target;
                local v126;

                if Target and Target.Player then
                    local Character = Target.Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v126 = HumanoidRootPart.Position;
                        else
                            v126 = nil;
                        end;
                    else
                        v126 = nil;
                    end;
                else
                    v126 = nil;
                end;

                local v127 = p125.Target and p125.Target.Player;

                if not (v126 and v127) then
                    p125:TransitionTo("Return");

                    return;
                end;

                p125._BaseLocal = ComputeSlotLocalBase(p125.Module, p125.Scale, p125.Debug);
                local Slot = p125.Slot;
                local v128;

                if Slot and Slot.Parent then
                    if p125._BaseLocal then
                        v128 = (Slot.CFrame * p125._BaseLocal).Position;
                    else
                        v128 = Slot.Position - Vector3.new(0, p125.CarryOffset, 0);
                    end;
                else
                    v128 = nil;
                end;

                if not v128 then
                    p125:TransitionTo("Return");

                    return;
                end;

                if p125.Debug then
                    local v129 = p125.Control:GetSlotPosition();
                    DebugLog(p125, (`Grab: holding via {p125._BaseLocal and "Base attachment" or `CarryOffset {p125.CarryOffset} below slot`}; slot={tostring(v129)} hold={tostring(v128)} (hold is {string.format("%.2f", not v129 and 0 or (v128 - v129).Magnitude)} studs from slot)`));
                    SetMarker(p125, "Slot", v129);
                    SetMarker(p125, "Base", v128);
                end;

                if not BeginPin(p125, v127, v128) then
                    p125:TransitionTo("Return");

                    return;
                end;

                DropStolenFruit(p125.Player, v127);
                PlayEagleSound(p125.Slot, "EagleAttack", 1);
                p125.Control:SetSlotAttribute("AnimOverride", "grabplayer");
                p125._CarryAnimAt = os.clock() + p125.GrabAnimDuration;
                local v130 = p125.Control:GetSlotPosition() or v126;
                local v131 = Vector3.new(v126.X - v130.X, 0, v126.Z - v130.Z);
                local v132 = v131.Magnitude <= 0.001 and Vector3.new(0, 0, -1) or v131.Unit;
                p125._FlyHoriz = v132;
                local v133 = math.rad(p125.AscendAngleDeg);
                p125._AscendDir = (v132 * math.cos(v133) + Vector3.new(0, 1, 0) * math.sin(v133)).Unit;
                p125._CarryEndsAt = os.clock() + p125.CarryDuration;
                p125:TransitionTo("Carry");
            end
        },
        Carry = {
            Update = function(p134, p135, p136) -- Line: 701, Name: Update
                -- upvalues: FlyTo (ref), SetMarker (ref)
                local v137 = p134.Target and p134.Target.Player;

                if not (v137 and (v137.Parent and (p134._PinnedHRP and p134._PinnedHRP.Parent))) then
                    p134:TransitionTo("Return");

                    return;
                end;

                local _PinnedChar = p134._PinnedChar;

                if _PinnedChar then
                    _PinnedChar = _PinnedChar:FindFirstChildOfClass("Humanoid");
                end;

                if not _PinnedChar or (not _PinnedChar.Parent or _PinnedChar.Health <= 0) then
                    p134:TransitionTo("Return");

                    return;
                end;

                if p134._CarryAnimAt and p134._CarryAnimAt <= p135 then
                    p134.Control:SetSlotAttribute("AnimOverride", "targetplayer");
                    p134._CarryAnimAt = nil;
                end;

                local v138 = p134.Control:GetSlotPosition();
                local v139 = p134._AscendDir or Vector3.new(0, 1, 0);

                if v138 then
                    FlyTo(p134, v138 + v139 * p134.AttackSpeed, p134.AttackSpeed);
                end;

                local Slot = p134.Slot;
                local v140;

                if Slot and Slot.Parent then
                    if p134._BaseLocal then
                        v140 = (Slot.CFrame * p134._BaseLocal).Position;
                    else
                        v140 = Slot.Position - Vector3.new(0, p134.CarryOffset, 0);
                    end;
                else
                    v140 = nil;
                end;

                if v140 and (p134._PinAlign and p134._PinAlign.Parent) then
                    p134._PinAlign.Position = v140;
                end;

                if p134.Debug then
                    SetMarker(p134, "Slot", v138);
                    SetMarker(p134, "Base", v140);
                    SetMarker(p134, "Victim", p134._PinnedHRP and p134._PinnedHRP.Position);
                end;

                if p134._CarryEndsAt <= p135 then
                    p134:TransitionTo("Throw");
                end;
            end
        },
        Throw = {
            Enter = function(u141) -- Line: 747, Name: Enter
                -- upvalues: ExemptVictim (ref), u5 (ref), Services (ref), PlayEagleSound (ref), DebugLog (ref), RagdollModule (ref)
                local _PinnedHRP = u141._PinnedHRP;
                local _PinnedChar = u141._PinnedChar;
                u141.Control:SetSlotAttribute("AnimOverride", nil);
                local v142 = u141.Target and u141.Target.Player;

                if v142 then
                    ExemptVictim(v142);
                end;

                if not u5 then
                    u5 = require(Services:WaitForChild("BeeDefenseService"));
                end;

                local u143 = u5;

                if u143 then
                    pcall(function() -- Line: 767
                        -- upvalues: u143 (copy), u141 (copy)
                        u143:ClearShovelAggro(u141.Player);
                    end);
                end;

                if u141._PinAlign then
                    if u141._PinAlign.Parent then
                        u141._PinAlign:Destroy();
                    end;

                    u141._PinAlign = nil;
                end;

                if u141._PinAttachment then
                    if u141._PinAttachment.Parent then
                        u141._PinAttachment:Destroy();
                    end;

                    u141._PinAttachment = nil;
                end;

                u141._PinnedChar = nil;
                u141._PinnedHRP = nil;
                PlayEagleSound(u141.Slot, "EagleThrow", 1.75);

                if _PinnedHRP and _PinnedHRP.Parent then
                    local v144 = (u141._FlyHoriz or Vector3.new(0, 0, -1)) * u141.ThrowForce + Vector3.new(0, u141.ThrowUp, 0);
                    DebugLog(u141, (`Throw: velocity={tostring(v144)} (mag {string.format("%.1f", v144.Magnitude)})`));
                    local BodyVelocity = Instance.new("BodyVelocity");
                    BodyVelocity.MaxForce = Vector3.new(inf, inf, inf);
                    BodyVelocity.Velocity = v144;
                    BodyVelocity.Parent = _PinnedHRP;
                    task.delay(0.35, function() -- Line: 791
                        -- upvalues: BodyVelocity (copy)
                        if BodyVelocity and BodyVelocity.Parent then
                            BodyVelocity:Destroy();
                        end;
                    end);
                end;

                if _PinnedChar then
                    task.delay(1.5, function() -- Line: 799
                        -- upvalues: RagdollModule (ref), _PinnedChar (copy)
                        pcall(function() -- Line: 800
                            -- upvalues: RagdollModule (ref), _PinnedChar (ref)
                            RagdollModule:Unragdoll(_PinnedChar);
                        end);
                    end);
                end;

                u141._ThrowEndsAt = os.clock() + u141.ThrowAnimDuration;
            end,

            Update = function(p145, p146, p147) -- Line: 807, Name: Update
                if p145._ThrowEndsAt <= p146 then
                    p145:TransitionTo("ReturnFlight");
                end;
            end
        },
        ReturnFlight = {
            Enter = function(p148) -- Line: 820, Name: Enter
                p148.Control:SetSlotAttribute("AnimOverride", nil);
                p148._ReturnEndsAt = os.clock() + p148.ReturnTimeout;
            end,

            Update = function(p149, p150, p151) -- Line: 826, Name: Update
                -- upvalues: FlyTo (ref), SetMarker (ref)
                local Player = p149.Player;
                local v152;

                if Player and Player.Parent then
                    local Character = Player.Character;

                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                            v152 = HumanoidRootPart.Position;
                        else
                            v152 = nil;
                        end;
                    else
                        v152 = nil;
                    end;
                else
                    v152 = nil;
                end;

                if not v152 then
                    p149:TransitionTo("Return");

                    return;
                end;

                local v153 = v152 + Vector3.new(0, p149.Module and (p149.Module.FollowAirHeight or (p149.Module.AirHeight or 0)) or 0, 0);
                FlyTo(p149, v153, p149.ReturnSpeed);

                if p149.Debug then
                    SetMarker(p149, "Slot", p149.Control:GetSlotPosition());
                    SetMarker(p149, "Target", v153);

                    if p149.Debug then
                        if not p149._Markers then
                            p149._Markers = {};
                        end;

                        local Base = p149._Markers.Base;

                        if Base then
                            Base:Destroy();
                            p149._Markers.Base = nil;
                        end;
                    end;

                    if p149.Debug then
                        if not p149._Markers then
                            p149._Markers = {};
                        end;

                        local Victim = p149._Markers.Victim;

                        if Victim then
                            Victim:Destroy();
                            p149._Markers.Victim = nil;
                        end;
                    end;
                end;

                local v154 = p149.Control:GetSlotPosition();

                if (not v154 and (1 / 0) or (v153 - v154).Magnitude) <= p149.ReturnArriveRadius then
                    p149:TransitionTo("Return");

                    return;
                end;

                if p149._ReturnEndsAt > p150 then
                    return;
                end;

                p149:TransitionTo("Return");
            end
        },
        Return = {
            Enter = function(p155) -- Line: 858, Name: Enter
                if p155.Control and p155.Control.SetSlotAttribute then
                    p155.Control:SetSlotAttribute("Hovering", nil);
                end;

                p155:Stop("Disengaged");
            end
        }
    };
end;

function u40.new(p156) -- Line: 868
    -- upvalues: BehaviorBase (copy), u40 (copy), PetSizes (copy), PetTypes (copy), BuildStates (copy)
    local v157 = BehaviorBase.New(u40, p156);
    local v158 = v157.Slot and v157.Slot:GetAttribute("PetSize");
    local v159 = v157.Slot and v157.Slot:GetAttribute("PetType");
    v157.Debug = v157.Config.Debug == true;
    v157._SizeLabel = v158;
    v157.AttackSpeed = v157.Config.AttackSpeed or 21.84;
    local v160 = v157.Config.DiveRadius or 3;
    local v161 = v157.Config.DiveRadiusBig or 4.5;
    local v162 = v157.Config.DiveRadiusHuge or 6;
    local v163 = PetSizes.Normalize(v158);

    if v163 == "Huge" then
        v160 = v162;
    elseif v163 == "Big" then
        v160 = v161;
    end;

    v157.DiveRadius = v160;
    v157.CarryOffset = v157.Config.CarryOffset or 3;
    local v164 = v157.Config.CarryDuration or 1.5;
    local v165 = v157.Config.CarryDurationBig or 2.25;
    local v166 = v157.Config.CarryDurationHuge or 3;
    local v167 = PetSizes.Normalize(v158);

    if v167 == "Huge" then
        v164 = v166;
    elseif v167 == "Big" then
        v164 = v165;
    end;

    local GetBoostMultiplier = PetTypes.GetBoostMultiplier;

    if type(v159) ~= "string" then
        v159 = nil;
    end;

    v157.CarryDuration = v164 * GetBoostMultiplier(v159);
    v157.AscendAngleDeg = v157.Config.AscendAngleDeg or 25;
    v157.ThrowForce = v157.Config.ThrowForce or 16.25;
    v157.ThrowUp = v157.Config.ThrowUp or 10;
    v157.GrabAnimDuration = v157.Config.GrabAnimDuration or 0.5;
    v157.ThrowAnimDuration = v157.Config.ThrowAnimDuration or 0.7;
    v157.ChaseLegTimeout = v157.Config.ChaseLegTimeout or 6;
    v157.ShovelAggroCooldown = v157.Config.ShovelAggroCooldown or 10;
    v157.ReturnSpeed = v157.Config.ReturnSpeed or 21.84;
    v157.ReturnArriveRadius = v157.Config.ReturnArriveRadius or 6;
    v157.ReturnTimeout = v157.Config.ReturnTimeout or 5;
    v157.ShooCooldown = v157.Config.ShooCooldown or 15;
    v157.VisualChaseSpeed = v157.AttackSpeed * 1.75;
    local GetScale = PetSizes.GetScale;
    local v168 = {};
    v168.Big = v157.Module and v157.Module.BigScale;
    v168.Huge = v157.Module and v157.Module.HugeScale;
    v157.Scale = GetScale(v158, v168);
    v157.Target = nil;
    v157._BaseLocal = nil;
    v157._FlyHoriz = nil;
    v157._AscendDir = nil;
    v157._CarryEndsAt = 0;
    v157._ThrowEndsAt = 0;
    v157._ReturnEndsAt = 0;
    v157._PinnedChar = nil;
    v157._PinnedHRP = nil;
    v157._PinAttachment = nil;
    v157._PinAlign = nil;
    v157._Markers = nil;
    v157.States = BuildStates();

    return v157;
end;

function u40.GetInitialState(p169) -- Line: 932
    return "Acquire";
end;

function u40.OnStop(p170, p171) -- Line: 939
    -- upvalues: DebugLog (copy), RagdollModule (copy)
    DebugLog(p170, (`Stop: {tostring(p171)}`));

    if p170._Markers then
        for _, v in p170._Markers do
            if v then
                v:Destroy();
            end;
        end;

        p170._Markers = nil;
    end;

    if p170._PinAlign then
        if p170._PinAlign.Parent then
            p170._PinAlign:Destroy();
        end;

        p170._PinAlign = nil;
    end;

    if p170._PinAttachment then
        if p170._PinAttachment.Parent then
            p170._PinAttachment:Destroy();
        end;

        p170._PinAttachment = nil;
    end;

    if p170._PinnedChar then
        local _PinnedChar = p170._PinnedChar;
        pcall(function() -- Line: 417
            -- upvalues: RagdollModule (ref), _PinnedChar (copy)
            RagdollModule:Unragdoll(_PinnedChar);
        end);
    end;

    p170._PinnedChar = nil;
    p170._PinnedHRP = nil;

    if p170.Control and p170.Control.SetSlotAttribute then
        p170.Control:SetSlotAttribute("Hovering", nil);
    end;

    if p170.Control then
        p170.Control:SetSlotAttribute("AnimOverride", nil);
        p170.Control:SetSlotAttribute("VisualChaseSpeed", nil);
    end;
end;

function u40.GetCooldownSeconds(p172, p173) -- Line: 954
    -- upvalues: PetFlags (copy)
    return PetFlags.BaldEagleCooldown:Get();
end;

function u40.CanStart(p174) -- Line: 958
    -- upvalues: u5 (ref), Services (copy), u12 (copy), u18 (copy)
    local Player = p174.Player;

    if not (Player and Player.Parent) then
        return false;
    end;

    if not u5 then
        u5 = require(Services:WaitForChild("BeeDefenseService"));
    end;

    local v175 = u5;

    if not v175 then
        return false;
    end;

    local Slot = p174.Slot;
    local v176;

    if Slot then
        local v177 = u12[Slot];

        if v177 == nil then
            v176 = false;
        else
            v176 = os.clock() < v177;
        end;
    else
        v176 = false;
    end;

    if not v176 then
        local v178 = v175:GetShovelAggroTarget(Player);

        if v178 and (v178 and (v178:GetAttribute("InSafeZone") ~= true and (v178:GetAttribute("IsInOwnGarden") ~= true and v178:GetAttribute("InMinigame") ~= true))) then
            local UserId = v178.UserId;
            local v179 = u18[tostring(Player.UserId) .. ":" .. tostring(UserId)];
            local v180;

            if v179 == nil then
                v180 = false;
            else
                v180 = os.clock() < v179;
            end;

            if not v180 then
                return true;
            end;
        end;
    end;

    local v181 = v175:PickTargetFor(Player);
    local v182;

    if v181 == nil or v181.Player == nil then
        v182 = false;
    else
        local Player2 = v181.Player;
        v182 = Player2 and (Player2:GetAttribute("InSafeZone") ~= true and (Player2:GetAttribute("IsInOwnGarden") ~= true and Player2:GetAttribute("InMinigame") ~= true)) and true or false;

        if v182 then
            local UserId = v181.Player.UserId;
            local v183 = u18[tostring(Player.UserId) .. ":" .. tostring(UserId)];
            local v184;

            if v183 == nil then
                v184 = false;
            else
                v184 = os.clock() < v183;
            end;

            v182 = not v184;
        end;
    end;

    return v182;
end;

return u40;