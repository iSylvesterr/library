-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local GameplayToolGuard = require(ServerScriptService.Library.Tools.Internal.GameplayToolGuard);
local AntiCheatService = require(ServerScriptService.Controllers.AntiCheatService);
local Audio = require(ReplicatedStorage.Library.Audio);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Network = require(ServerScriptService.Library.Network);

return {
    Install = function(u1) -- Line: 39, Name: Install
        -- upvalues: Players (copy), Network (copy), Constants (copy), GameplayToolGuard (copy), AntiCheatService (copy), Audio (copy), ReplicatedStorage (copy)
        local u2 = u1:GetAttribute("Owner");
        local u3 = false;
        local u4 = {};
        local u5 = nil;
        local Hitbox = u1:WaitForChild("Hitbox");
        local v6 = Hitbox:IsA("BasePart");
        assert(v6, "Trap Hitbox must be a BasePart");
        u1.CanTouch = true;
        Hitbox.CanTouch = true;

        local function createTrapBillboard(p7) -- Line: 54
            local BillboardGui = Instance.new("BillboardGui");
            BillboardGui.Name = "TrapBillboard";
            BillboardGui.Size = UDim2.fromScale(6, 3);
            BillboardGui.StudsOffset = Vector3.new(0, 3, 0);
            BillboardGui.AlwaysOnTop = true;
            BillboardGui.MaxDistance = 50;
            local Frame = Instance.new("Frame");
            Frame.Size = UDim2.fromScale(1, 1);
            Frame.BackgroundTransparency = 1;
            Frame.Parent = BillboardGui;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Size = UDim2.fromScale(1, 0.4);
            TextLabel.Position = UDim2.new(0, 0, 0, 0);
            TextLabel.BackgroundTransparency = 1;
            TextLabel.Text = "TRAPPED";
            TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0);
            TextLabel.TextScaled = true;
            TextLabel.Font = Enum.Font.SourceSansBold;
            TextLabel.Parent = Frame;
            local UIStroke = Instance.new("UIStroke");
            UIStroke.Thickness = 2.5;
            UIStroke.Parent = TextLabel;
            local TextLabel2 = Instance.new("TextLabel");
            TextLabel2.Size = UDim2.fromScale(1, 0.5);
            TextLabel2.Position = UDim2.fromScale(0, 0.5);
            TextLabel2.BackgroundTransparency = 1;
            TextLabel2.Text = tostring(7) .. "s";
            TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255);
            TextLabel2.TextScaled = true;
            TextLabel2.Font = Enum.Font.SourceSansBold;
            TextLabel2.Parent = Frame;
            local UIStroke2 = Instance.new("UIStroke");
            UIStroke2.Thickness = 2.5;
            UIStroke2.Parent = TextLabel2;
            local Head = p7:FindFirstChild("Head");

            if Head then
                BillboardGui.Parent = Head;
            else
                if not p7.PrimaryPart then
                    BillboardGui:Destroy();

                    return nil;
                end;

                BillboardGui.Parent = p7.PrimaryPart;
            end;

            task.spawn(function() -- Line: 105
                -- upvalues: BillboardGui (copy), TextLabel2 (copy)
                for i = 7, 1, -1 do
                    if not (BillboardGui and BillboardGui.Parent) then
                        break;
                    end;

                    TextLabel2.Text = tostring(i) .. "s";
                    task.wait(1);
                end;

                if BillboardGui and BillboardGui.Parent then
                    BillboardGui:Destroy();
                end;
            end);

            return BillboardGui;
        end;

        local function getModelHeight(p8) -- Line: 122
            if p8:FindFirstChild("HumanoidRootPart") or p8.PrimaryPart then
                local _, v9 = p8:GetBoundingBox();

                return v9.Y / 2;
            end;

            error("HumanoidRootPart or PrimaryPart not found");

            return 2;
        end;

        local function getCharacterFromPart(p10) -- Line: 133
            while p10 and p10 ~= workspace do
                if p10:IsA("Model") and p10:FindFirstChildOfClass("Humanoid") then
                    return p10;
                end;

                p10 = p10.Parent;
            end;

            return nil;
        end;

        local function positionCloseModel(p11) -- Line: 148
            -- upvalues: u1 (copy)
            if p11:IsA("BasePart") then
                p11.CFrame = u1.CFrame * CFrame.Angles(-1.5707963267948966, 0, 0);
                p11.Anchored = true;

                return;
            end;

            if p11:IsA("PVInstance") then
                p11:PivotTo(u1.CFrame);
            end;

            for _, descendant in p11:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true;
                end;
            end;
        end;

        local function releaseTrappedCharacter(p12) -- Line: 166
            -- upvalues: u4 (copy)
            local v13 = u4[p12];

            if not v13 then
                return;
            end;

            u4[p12] = nil;
            local carrierConnection = v13.carrierConnection;

            if carrierConnection then
                carrierConnection:Disconnect();
            end;

            local trapStateConnection = v13.trapStateConnection;

            if trapStateConnection then
                trapStateConnection:Disconnect();
            end;

            local billboard = v13.billboard;

            if billboard and billboard.Parent then
                billboard:Destroy();
            end;

            local rootPart = v13.rootPart;

            if rootPart and rootPart.Parent then
                rootPart.Anchored = v13.originalRootAnchored;
            end;

            local humanoid = v13.humanoid;

            if humanoid then
                humanoid.JumpHeight = v13.originalJumpHeight;
                humanoid.AutoRotate = v13.originalAutoRotate;
                humanoid.PlatformStand = false;
            end;

            if p12 and p12.Parent then
                p12:SetAttribute("IsTrapped", nil);
            end;
        end;

        local function notifyTrapOwner(p14) -- Line: 208
            -- upvalues: u2 (copy), Players (ref), Network (ref), Constants (ref)
            if typeof(u2) ~= "string" then
                return;
            end;

            local v15 = Players:FindFirstChild(u2);

            if not (v15 and v15:IsA("Player")) then
                return;
            end;

            Network.Fire(Constants.NETWORK_MAP.Notifications.SHOW, v15, "Message", "Bottom", {
                Time = 2,
                Message = `You <font color="#00FF00">trapped</font> {p14.DisplayName}!`,
                Color = Color3.new(1, 1, 1)
            });
        end;

        local function freezeCharacter(u16, p17) -- Line: 225
            -- upvalues: u4 (copy), Players (ref), GameplayToolGuard (ref), AntiCheatService (ref), notifyTrapOwner (copy), createTrapBillboard (copy), Audio (ref), releaseTrappedCharacter (copy)
            if u4[u16] or u16:GetAttribute("IsTrapped") then
                return false;
            end;

            local v18 = u16:FindFirstChildOfClass("Humanoid");
            local v19 = u16:FindFirstChild("HumanoidRootPart") or u16.PrimaryPart;

            if not (v18 and (v19 and v19:IsA("BasePart"))) then
                return false;
            end;

            local v20;

            if u16:FindFirstChild("HumanoidRootPart") or u16.PrimaryPart then
                local _, v21 = u16:GetBoundingBox();
                v20 = v21.Y / 2;
            else
                error("HumanoidRootPart or PrimaryPart not found");
                v20 = 2;
            end;

            local v22 = p17 + Vector3.new(0, v20, 0);
            local v23 = Players:GetPlayerFromCharacter(u16);

            if not (v23 and GameplayToolGuard.DropHeldEggFromPlayerHit(v23)) then
                return false;
            end;

            local v24 = CFrame.new(v22);

            if not AntiCheatService.TeleportCharacter(v23, v24) then
                return false;
            end;

            local Anchored = v19.Anchored;
            local JumpHeight = v18.JumpHeight;
            local AutoRotate = v18.AutoRotate;
            v19.Anchored = true;
            v18:UnequipTools();
            v18.JumpHeight = 0;
            v18.AutoRotate = false;
            v18.PlatformStand = true;
            u16:SetAttribute("IsTrapped", true);
            notifyTrapOwner(v23);
            local u25 = {
                character = u16,
                humanoid = v18,
                rootPart = v19,
                originalRootAnchored = Anchored,
                originalJumpHeight = JumpHeight,
                originalAutoRotate = AutoRotate
            };
            u4[u16] = u25;
            u25.billboard = createTrapBillboard(u16);
            Audio.Play(9091607929, v19.CFrame, { 0.9, 1.1 }, 1.3, 70);
            u25.carrierConnection = u16:GetAttributeChangedSignal("CarrierUserId"):Connect(function() -- Line: 277
                -- upvalues: u16 (copy), releaseTrappedCharacter (ref)
                if u16:GetAttribute("CarrierUserId") ~= nil then
                    releaseTrappedCharacter(u16);
                end;
            end);
            u25.trapStateConnection = u16:GetAttributeChangedSignal("IsTrapped"):Connect(function() -- Line: 284
                -- upvalues: u16 (copy), releaseTrappedCharacter (ref)
                if u16:GetAttribute("IsTrapped") ~= true then
                    releaseTrappedCharacter(u16);
                end;
            end);
            task.delay(7, function() -- Line: 290
                -- upvalues: u4 (ref), u16 (copy), u25 (copy), releaseTrappedCharacter (ref)
                if u4[u16] ~= u25 then
                    return;
                end;

                releaseTrappedCharacter(u16);
            end);

            return true;
        end;

        local function activateTrap(p26) -- Line: 301
            -- upvalues: u3 (ref), u1 (copy), freezeCharacter (copy), Hitbox (copy), u5 (ref), ReplicatedStorage (ref), positionCloseModel (copy)
            if u3 or not u1.Parent then
                return;
            end;

            if not freezeCharacter(p26, Hitbox.Position - Vector3.new(0, 1, 0) * (Hitbox.Size.Y / 2)) then
                return;
            end;

            u3 = true;
            u1:SetAttribute("TrapActive", true);

            if u5 then
                u5:Disconnect();
                u5 = nil;
            end;

            local u27 = ReplicatedStorage.Assets.Extra.Close:Clone();
            positionCloseModel(u27);
            u27.Parent = u1;
            u1.Transparency = 1;
            u1.CanCollide = false;
            u1.CanTouch = false;
            task.delay(7.5, function() -- Line: 325
                -- upvalues: u27 (copy), u1 (ref)
                if u27 and u27.Parent then
                    u27:Destroy();
                end;

                if u1 and u1.Parent then
                    u1:Destroy();
                end;
            end);
        end;

        u5 = Hitbox.Touched:Connect(function(p28) -- Line: 336, Name: onTouched
            -- upvalues: u3 (ref), u1 (copy), getCharacterFromPart (copy), Players (ref), u2 (copy), GameplayToolGuard (ref), activateTrap (copy)
            if u3 or not u1.Parent then
                return;
            end;

            if not p28 or p28:IsDescendantOf(u1) then
                return;
            end;

            local v29 = getCharacterFromPart(p28);

            if not v29 then
                return;
            end;

            local v30 = Players:GetPlayerFromCharacter(v29);

            if v30 and v30.Name == u2 then
                return;
            end;

            if not (v30 and GameplayToolGuard.IsPlayerInGameplayArea(v30)) then
                return;
            end;

            if not GameplayToolGuard.IsHoldingEgg(v30) then
                return;
            end;

            local v31 = v29:FindFirstChildOfClass("Humanoid");

            if not v31 or v31.Health <= 0 then
                return;
            end;

            activateTrap(v29);
        end);
    end
};