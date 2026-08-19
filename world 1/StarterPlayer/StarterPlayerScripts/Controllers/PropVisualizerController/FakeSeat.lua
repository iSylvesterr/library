-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;

return function(u1) -- Line: 18
    -- upvalues: CollectionService (copy), LocalPlayer (copy), Networking (copy), Players (copy)
    local u2 = {};

    for _, descendant in u1:GetDescendants() do
        if descendant:IsA("BasePart") and CollectionService:HasTag(descendant, "FakeSeat") then
            table.insert(u2, descendant);
        end;
    end;

    if #u2 == 0 then
        return;
    end;

    local u3 = u1:GetAttribute("UserId");
    local u4 = u1:GetAttribute("PropId");
    local u5 = false;
    local u6 = {};
    local u7 = {};
    local u8 = nil;
    local u9 = {};

    local function ClearWeld(p10) -- Line: 40
        -- upvalues: u6 (copy)
        local v11 = u6[p10];

        if v11 then
            v11:Destroy();
            u6[p10] = nil;
        end;
    end;

    local function CreateWeld(p12, p13) -- Line: 48
        -- upvalues: u6 (copy), u2 (copy)
        local v14 = u6[p12];

        if v14 then
            v14:Destroy();
            u6[p12] = nil;
        end;

        local HumanoidRootPart = p13:FindFirstChild("HumanoidRootPart");

        if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
            return;
        end;

        local v15 = u2[p12];
        local v16 = v15:GetAttribute("SeatHeight") or 2;
        local Weld = Instance.new("Weld");
        Weld.Name = "SeatWeld";
        Weld.Part0 = v15;
        Weld.Part1 = HumanoidRootPart;
        Weld.C0 = CFrame.new(0, v16, 0);
        Weld.Parent = v15;
        u6[p12] = Weld;
    end;

    local function ConnectLocalUnsit() -- Line: 65
        -- upvalues: u8 (ref), LocalPlayer (ref), u2 (copy), u7 (copy), u6 (copy), u9 (copy), Networking (ref), u3 (copy), u4 (copy)
        if u8 then
            u8:Disconnect();
            u8 = nil;
        end;

        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        local v17 = Character:FindFirstChildWhichIsA("Humanoid");

        if not v17 then
            return;
        end;

        u8 = v17.StateChanged:Connect(function(p18, p19) -- Line: 76
            -- upvalues: u2 (ref), u7 (ref), LocalPlayer (ref), u6 (ref), u9 (ref), Networking (ref), u3 (ref), u4 (ref)
            if p19 ~= Enum.HumanoidStateType.Jumping and p19 ~= Enum.HumanoidStateType.GettingUp then
                return;
            end;

            for i = 1, #u2 do
                if u7[i] == LocalPlayer.UserId then
                    local v20 = u6[i];

                    if v20 then
                        v20:Destroy();
                        u6[i] = nil;
                    end;

                    u7[i] = nil;
                    u9[i] = os.clock();
                    Networking.FakeSeat.Unsit:Fire(u3, u4, i);

                    return;
                end;
            end;
        end);
    end;

    local u28 = Networking.FakeSeat.SeatChanged.OnClientEvent:Connect(function(p21, p22, p23, p24) -- Line: 93
        -- upvalues: u3 (copy), u4 (copy), u6 (copy), u7 (copy), LocalPlayer (ref), Networking (ref), Players (ref), CreateWeld (copy)
        if p21 ~= u3 or p22 ~= u4 then
            return;
        end;

        if p24 == 0 then
            local v25 = u6[p23];

            if v25 then
                v25:Destroy();
                u6[p23] = nil;
            end;

            u7[p23] = nil;

            return;
        end;

        if p24 == LocalPlayer.UserId then
            if u7[p23] ~= LocalPlayer.UserId then
                Networking.FakeSeat.Unsit:Fire(u3, u4, p23);
            end;

            return;
        end;

        u7[p23] = p24;
        local v26 = Players:GetPlayerByUserId(p24);

        if v26 and v26.Character then
            local v27 = v26.Character:FindFirstChildWhichIsA("Humanoid");

            if v27 then
                v27.Sit = true;
            end;

            CreateWeld(p23, v26.Character);
        end;
    end);

    for i = 1, #u2 do
        u2[i].Touched:Connect(function(p29) -- Line: 126
            -- upvalues: u5 (ref), u1 (copy), u7 (copy), i (copy), u9 (copy), LocalPlayer (ref), CreateWeld (copy), ConnectLocalUnsit (copy), Networking (ref), u3 (copy), u4 (copy)
            if u5 then
                return;
            end;

            if u1:GetAttribute("IsBeingMoved") then
                return;
            end;

            if u7[i] then
                return;
            end;

            local v30 = u9[i];

            if v30 and os.clock() - v30 < 0.5 then
                return;
            end;

            local v31 = p29:FindFirstAncestorWhichIsA("Model");

            if v31 ~= LocalPlayer.Character then
                return;
            end;

            local v32 = v31:FindFirstChildWhichIsA("Humanoid");

            if not v32 then
                return;
            end;

            if v32.Sit then
                return;
            end;

            v32.Sit = true;
            CreateWeld(i, v31);
            u7[i] = LocalPlayer.UserId;
            ConnectLocalUnsit();
            Networking.FakeSeat.Sit:Fire(u3, u4, i);
        end);
    end;

    ConnectLocalUnsit();
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 151
        -- upvalues: ConnectLocalUnsit (copy)
        task.wait();
        ConnectLocalUnsit();
    end);
    u1.Destroying:Connect(function() -- Line: 156
        -- upvalues: u5 (ref), u2 (copy), u7 (copy), LocalPlayer (ref), u6 (copy), u28 (copy), u8 (ref)
        u5 = true;

        for i = 1, #u2 do
            if u7[i] == LocalPlayer.UserId then
                local v33 = u6[i];

                if v33 then
                    v33:Destroy();
                    u6[i] = nil;
                end;

                u7[i] = nil;
                local Character = LocalPlayer.Character;

                if Character then
                    local v34 = Character:FindFirstChildWhichIsA("Humanoid");

                    if v34 then
                        v34.Sit = false;
                    end;
                end;
            elseif u6[i] then
                local v35 = u6[i];

                if v35 then
                    v35:Destroy();
                    u6[i] = nil;
                end;

                u7[i] = nil;
            end;
        end;

        u28:Disconnect();

        if u8 then
            u8:Disconnect();
        end;
    end);
    Networking.FakeSeat.RequestState:Fire(u3, u4);
end;