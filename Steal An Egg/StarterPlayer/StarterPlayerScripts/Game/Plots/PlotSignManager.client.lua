-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Player = require(ReplicatedStorage.Library.Player);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);
require(ReplicatedStorage.Library.Types.Plots);
local Streamable = require(ReplicatedStorage.Library.Modules.Packages.Streamable).Streamable;
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local PlotSignHomeButtonFade = require(script.Parent.Parent.Parent.GUI.PlotSignHomeButtonFade);
local LocalPlayer = Players.LocalPlayer;
local u1 = Trove.new();
local u2 = {};
local u3 = {};

local function clearRemotePlotSignBinding(p4) -- Line: 36
    -- upvalues: u3 (copy)
    local v5 = u3[p4];

    if v5 == nil then
        return;
    end;

    v5:Destroy();
end;

local function bindRemotePlotSign(u6, p7) -- Line: 45
    -- upvalues: u3 (copy), LocalPlayer (copy), Players (copy), PlotCmds (copy), Trove (copy), Streamable (copy), u2 (copy)
    local v8 = u3[u6];

    if v8 ~= nil then
        v8:Destroy();
    end;

    if p7 == nil or p7 == LocalPlayer.UserId then
        return;
    end;

    local v9 = Players:GetPlayerByUserId(p7);

    if v9 == nil then
        return;
    end;

    local u10 = PlotCmds.GetPlotData(v9);

    if u10 == nil then
        return;
    end;

    local u11 = Trove.new();
    u3[u6] = u11;
    u11:Add(function() -- Line: 64
        -- upvalues: u3 (ref), u6 (copy), u11 (copy)
        if u3[u6] == u11 then
            u3[u6] = nil;
        end;
    end);
    local u12 = Streamable.new(u10.PlotFolder, "PlotSign");
    u11:Add(function() -- Line: 71
        -- upvalues: u12 (copy)
        u12:Destroy();
    end);
    u11:Add(u12:Observe(function(p13, p14) -- Line: 74
        -- upvalues: Streamable (ref), u10 (copy), u2 (ref), u6 (copy)
        local u15 = Streamable.new(p13, "PlayerPlotSign");
        p14:Add(function() -- Line: 76
            -- upvalues: u15 (copy)
            u15:Destroy();
        end);
        p14:Add(u15:Observe(function(u16) -- Line: 79
            -- upvalues: u10 (ref), u2 (ref), u6 (ref)
            local v17 = u16:IsA("BillboardGui");
            assert(v17, "PlayerPlotSign must be a BillboardGui");
            local u18 = {
                PetArea = u10.PetArea,
                PlayerPlotSign = u16
            };
            u2[u6] = u18;

            return function() -- Line: 88
                -- upvalues: u2 (ref), u6 (ref), u18 (copy), u16 (copy)
                if u2[u6] == u18 then
                    u2[u6] = nil;
                end;

                if u16.Parent ~= nil then
                    u16.AlwaysOnTop = false;
                end;
            end;
        end));
    end));
end;

local function rebindAllRemotePlotSigns() -- Line: 100
    -- upvalues: u3 (copy), PlotCmds (copy), bindRemotePlotSign (copy)
    local v19 = {};

    for i in pairs(u3) do
        v19[#v19 + 1] = i;
    end;

    for _, v in ipairs(v19) do
        local v20 = u3[v];

        if v20 ~= nil then
            v20:Destroy();
        end;
    end;

    for i, v in pairs(PlotCmds.GetState()) do
        bindRemotePlotSign(i, v);
    end;
end;

local function updateYourBaseTracker(p21) -- Line: 136
    -- upvalues: u1 (copy), Streamable (copy), PlotSignHomeButtonFade (copy), LocalPlayer (copy), RunService (copy)
    u1:Clean();

    if not p21 then
        return;
    end;

    local CenterPoint = p21.CenterPoint;
    local u22 = Streamable.new(p21.PlotFolder, "PlotSign");
    u1:Add(function() -- Line: 144
        -- upvalues: u22 (copy)
        u22:Destroy();
    end);
    u1:Add(u22:Observe(function(p23, p24) -- Line: 147
        -- upvalues: Streamable (ref), PlotSignHomeButtonFade (ref), LocalPlayer (ref), CenterPoint (copy), RunService (ref)
        local u25 = Streamable.new(p23, "SignUI");
        p24:Add(function() -- Line: 149
            -- upvalues: u25 (copy)
            u25:Destroy();
        end);
        p24:Add(u25:Observe(function(u26) -- Line: 152
            local v27 = u26:IsA("BillboardGui");
            assert(v27, "SignUI must be a BillboardGui");
            local Enabled = u26.Enabled;
            u26.Enabled = false;

            return function() -- Line: 158
                -- upvalues: u26 (copy), Enabled (copy)
                if u26.Parent ~= nil then
                    u26.Enabled = Enabled;
                end;
            end;
        end));
        local u28 = Streamable.new(p23, "Attachment");
        p24:Add(function() -- Line: 166
            -- upvalues: u28 (copy)
            u28:Destroy();
        end);
        p24:Add(u28:Observe(function(p29, u30) -- Line: 169
            -- upvalues: Streamable (ref), PlotSignHomeButtonFade (ref), LocalPlayer (ref), CenterPoint (ref), RunService (ref)
            local u31 = Streamable.new(p29, "YourBase");
            u30:Add(function() -- Line: 171
                -- upvalues: u31 (copy)
                u31:Destroy();
            end);
            u30:Add(u31:Observe(function(u32) -- Line: 174
                -- upvalues: PlotSignHomeButtonFade (ref), u30 (copy), LocalPlayer (ref), CenterPoint (ref), RunService (ref)
                local v33 = u32:IsA("BillboardGui");
                assert(v33, "YourBase must be a BillboardGui");
                local u34 = PlotSignHomeButtonFade.new(u32);
                u30:Add(function() -- Line: 177
                    -- upvalues: u34 (copy)
                    u34:Destroy();
                end);

                local function updateDistance() -- Line: 181
                    -- upvalues: LocalPlayer (ref), u34 (copy), u32 (copy), CenterPoint (ref)
                    local Character = LocalPlayer.Character;

                    if Character then
                        Character = Character:FindFirstChild("HumanoidRootPart");
                    end;

                    if not (Character and Character:IsA("BasePart")) then
                        u34:SetVisible(false);

                        return;
                    end;

                    u32.MaxDistance = 300;
                    u34:SetVisible((Character.Position - CenterPoint.Position).Magnitude > 50);
                end;

                updateDistance();

                return RunService.Heartbeat:Connect(updateDistance);
            end));
        end));
    end));
end;

updateYourBaseTracker(PlotCmds.GetPlotData());
PlotCmds.OnLocalPlotUpdated:Connect(function() -- Line: 203
    -- upvalues: updateYourBaseTracker (copy), PlotCmds (copy)
    updateYourBaseTracker(PlotCmds.GetPlotData());
end);
rebindAllRemotePlotSigns();
PlotCmds.OnAnyPlotUpdated:Connect(bindRemotePlotSign);
PlotCmds.OnPlotsFolderUpdated:Connect(rebindAllRemotePlotSigns);
Players.PlayerAdded:Connect(rebindAllRemotePlotSigns);
Players.PlayerRemoving:Connect(function(p35) -- Line: 211
    -- upvalues: PlotCmds (copy), u3 (copy)
    for i, v in pairs(PlotCmds.GetState()) do
        if v == p35.UserId then
            local v36 = u3[i];

            if v36 ~= nil then
                v36:Destroy();
            end;
        end;
    end;
end);
RunService.Heartbeat:Connect(function() -- Line: 114, Name: updateRemotePlotSigns
    -- upvalues: Player (copy), LocalPlayer (copy), u2 (copy)
    local v37 = Player.Optional.HumanoidRootPart(LocalPlayer);
    local v38;

    if v37 == nil then
        v38 = nil;
    else
        v38 = v37.Position;
    end;

    for _, v in pairs(u2) do
        local PlayerPlotSign = v.PlayerPlotSign;

        if PlayerPlotSign.Parent ~= nil then
            local PetArea = v.PetArea;
            local v39;

            if v38 == nil or PetArea.Parent == nil then
                v39 = false;
            else
                local v40 = PetArea.CFrame:PointToObjectSpace(v38);
                local v41 = PetArea.Size * 0.5;

                if math.abs(v40.X) <= v41.X then
                    v39 = math.abs(v40.Z) <= v41.Z;
                else
                    v39 = false;
                end;
            end;

            if PlayerPlotSign.AlwaysOnTop ~= v39 then
                PlayerPlotSign.AlwaysOnTop = v39;
            end;
        end;
    end;
end);