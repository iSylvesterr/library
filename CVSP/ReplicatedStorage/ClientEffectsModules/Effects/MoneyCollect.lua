-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local UISoundController = require(ReplicatedStorage.Sounds.UISoundController);
local MoneyReleased = ReplicatedStorage:WaitForChild("ClientEffectsModules"):WaitForChild("EffectAssets"):WaitForChild("MoneyReleased");
local World = workspace:WaitForChild("World");
local Client = World:WaitForChild("Map"):WaitForChild("PottedPlants"):WaitForChild("Client");
local Visuals = World:WaitForChild("Visuals");
local v1 = {};

local function createGreenHighlight(p2) -- Line: 20
    -- upvalues: Visuals (copy), TweenService (copy), Debris (copy)
    local Highlight = Instance.new("Highlight");
    Highlight.FillTransparency = 1;
    Highlight.OutlineColor = Color3.new(0.235294, 1, 0);
    Highlight.OutlineTransparency = 1;
    Highlight.Parent = Visuals;
    Highlight.Adornee = p2;
    local u3 = TweenInfo.new(0.25, Enum.EasingStyle.Linear);
    TweenService:Create(Highlight, u3, {
        OutlineTransparency = 0
    }):Play();
    task.delay(0.5, function() -- Line: 37
        -- upvalues: Highlight (copy), TweenService (ref), u3 (copy)
        if Highlight.Parent then
            TweenService:Create(Highlight, u3, {
                OutlineTransparency = 1
            }):Play();
        end;
    end);
    Debris:AddItem(Highlight, 1);
end;

function v1.Play(p4) -- Line: 49
    -- upvalues: UISoundController (copy), Client (copy), MoneyReleased (copy), Visuals (copy), Debris (copy), createGreenHighlight (copy)
    local playerCharacter = p4.playerCharacter;
    local pottedPlantID = p4.pottedPlantID;
    local potModel = p4.potModel;

    if not playerCharacter then
        return;
    end;

    if not p4.noSound or p4.noSound ~= true then
        UISoundController.Play("Money");
    end;

    local v5 = nil;

    if pottedPlantID then
        local v6 = Client:FindFirstChild(pottedPlantID);

        if v6 and v6.PrimaryPart then
            v5 = v6.PrimaryPart.Position;
        end;
    end;

    if not v5 then
        local HumanoidRootPart = playerCharacter:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart then
            v5 = HumanoidRootPart.Position;
        end;
    end;

    if v5 then
        local v7 = MoneyReleased:Clone();
        v7.Position = v5;
        v7.Parent = Visuals;
        local Attachment = v7:FindFirstChild("Attachment");

        if Attachment then
            local Money1 = Attachment:FindFirstChild("Money1");
            local Money2 = Attachment:FindFirstChild("Money2");

            if Money1 then
                Money1:Emit(6);
            end;

            if Money2 then
                Money2:Emit(6);
            end;
        end;

        Debris:AddItem(v7, 1.75);
    end;

    createGreenHighlight(playerCharacter);

    if potModel then
        createGreenHighlight(potModel);
    end;
end;

return v1;