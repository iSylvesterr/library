-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;
local VIP_ATTRIBUTE = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "monetization", "Vip").VIP_ATTRIBUTE;
local VipTag = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "ui", "VipTag").VipTag;
local HeadShot = Enum.ThumbnailType.HeadShot;
local Size420x420 = Enum.ThumbnailSize.Size420x420;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 18, Name: __tostring
        return "PlotIndicatorController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 23
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3, p4) -- Line: 27
    p3.plot = p4;
end;

function u1.onStart(u5) -- Line: 30
    u5.plot:observePlots(function(p6, p7, p8) -- Line: 31
        -- upvalues: u5 (copy)
        return u5:bind(p6, p8);
    end);
end;

function u1.onTick(p9) -- Line: 35
    -- upvalues: Player (copy)
    local ownPlot = p9.ownPlot;

    if not ownPlot then
        return nil;
    end;

    local Character = Player.Character;

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not (Character and Character:IsA("BasePart")) then
        ownPlot.billboard.Enabled = false;

        return nil;
    end;

    local v10 = Character.Position - ownPlot.center;
    local Magnitude = Vector3.new(v10.X, 0, v10.Z).Magnitude;
    ownPlot.billboard.Enabled = ownPlot.radius < Magnitude;
end;

function u1.bind(u11, u12, p13) -- Line: 55
    local Indicator = u12:FindFirstChild("Indicator");

    if Indicator ~= nil then
        Indicator = Indicator:FindFirstChildWhichIsA("BillboardGui");
    end;

    local v14;

    if Indicator == nil then
        v14 = Indicator;
    else
        v14 = Indicator:FindFirstChild("HeadshotImage");
    end;

    local v15;

    if Indicator == nil then
        v15 = Indicator;
    else
        v15 = Indicator:FindFirstChild("Username");
    end;

    local v16 = not Indicator;

    if not v16 then
        local v17;

        if v14 == nil then
            v17 = v14;
        else
            v17 = v14:IsA("ImageLabel");
        end;

        v16 = not v17;

        if not v16 then
            local v18;

            if v15 == nil then
                v18 = v15;
            else
                v18 = v15:IsA("TextLabel");
            end;

            v16 = not v18;
        end;
    end;

    if v16 then
        return nil;
    end;

    local u19 = {
        billboard = Indicator,
        headshot = v14,
        username = v15,
        janitor = p13
    };
    p13:Add(u12:GetAttributeChangedSignal("OwnerUserId"):Connect(function() -- Line: 95
        -- upvalues: u11 (copy), u12 (copy), u19 (copy)
        return u11:refresh(u12, u19);
    end), "Disconnect");
    p13:Add(function() -- Line: 98
        -- upvalues: u11 (copy), u12 (copy)
        local ownPlot = u11.ownPlot;

        if ownPlot ~= nil then
            ownPlot = ownPlot.plot;
        end;

        if ownPlot == u12 then
            u11.ownPlot = nil;
        end;
    end);
    u11:refresh(u12, u19);
end;

function u1.refresh(u20, u21, u22) -- Line: 109
    -- upvalues: Player (copy)
    local u23 = u21:GetAttribute("OwnerUserId");
    local ownPlot = u20.ownPlot;

    if ownPlot ~= nil then
        ownPlot = ownPlot.plot;
    end;

    if ownPlot == u21 then
        u20.ownPlot = nil;
    end;

    u20:watchOwnerVip(u21, u22, u23);

    if type(u23) ~= "number" or u23 == 0 then
        u22.billboard.Enabled = false;

        return nil;
    end;

    if u23 == Player.UserId then
        u22.username.Visible = false;
        u22.headshot.Image = "rbxassetid://129942604263161";
        local v24, v25 = u21:GetBoundingBox();
        u20.ownPlot = {
            plot = u21,
            billboard = u22.billboard,
            center = v24.Position,
            radius = math.max(v25.X, v25.Z) / 2 + 10
        };

        return nil;
    end;

    u22.billboard.Enabled = true;
    u22.username.Visible = true;
    task.spawn(function() -- Line: 137
        -- upvalues: u20 (copy), u21 (copy), u22 (copy), u23 (copy)
        return u20:applyOwner(u21, u22, u23);
    end);
end;

function u1.watchOwnerVip(u26, u27, u28, u29) -- Line: 141
    -- upvalues: Player (copy), Players (copy), VIP_ATTRIBUTE (copy)
    local vipConnection = u28.vipConnection;

    if vipConnection ~= nil then
        vipConnection:Disconnect();
    end;

    u28.vipConnection = nil;

    if type(u29) ~= "number" or (u29 == 0 and true or u29 == Player.UserId) then
        return nil;
    end;

    local v30 = Players:GetPlayerByUserId(u29);

    if not v30 then
        return nil;
    end;

    local v31 = v30:GetAttributeChangedSignal(VIP_ATTRIBUTE):Connect(function() -- Line: 159
        -- upvalues: u26 (copy), u27 (copy), u28 (copy), u29 (copy)
        return u26:applyOwner(u27, u28, u29);
    end);
    u28.vipConnection = v31;
    u28.janitor:Add(v31, "Disconnect");
end;

function u1.applyOwner(p32, p33, p34, u35) -- Line: 165
    -- upvalues: Players (copy), HeadShot (copy), Size420x420 (copy), VIP_ATTRIBUTE (copy), VipTag (copy)
    local v36 = Players:GetPlayerByUserId(u35);
    local v37;

    if v36 == nil then
        v37 = v36;
    else
        v37 = v36.Name;
    end;

    local v38;

    if v37 == nil then
        local v39;
        v39, v38 = pcall(function() -- Line: 173
            -- upvalues: Players (ref), u35 (copy)
            return Players:GetNameFromUserIdAsync(u35);
        end);

        if not v39 then
            v38 = v37;
        end;
    else
        v38 = v37;
    end;

    local success, result = pcall(function() -- Line: 180
        -- upvalues: Players (ref), u35 (copy), HeadShot (ref), Size420x420 (ref)
        return Players:GetUserThumbnailAsync(u35, HeadShot, Size420x420);
    end);

    if p33:GetAttribute("OwnerUserId") ~= u35 then
        return nil;
    end;

    if v38 ~= nil then
        if v36 ~= nil then
            v36 = v36:GetAttribute(VIP_ATTRIBUTE);
        end;

        if v36 == true then
            VipTag.applyPrefix(p34.username, (`@{v38}`));
        else
            VipTag.clear(p34.username);
            p34.username.Text = `@{v38}`;
        end;
    end;

    if success then
        p34.headshot.Image = result;
    end;
end;

Reflect.defineMetadata(u1, "identifier", "client/controllers/plot/PlotIndicatorController@PlotIndicatorController");
Reflect.defineMetadata(u1, "flamework:parameters", { "client/controllers/plot/PlotController@PlotController" });
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    PlotIndicatorController = u1
};