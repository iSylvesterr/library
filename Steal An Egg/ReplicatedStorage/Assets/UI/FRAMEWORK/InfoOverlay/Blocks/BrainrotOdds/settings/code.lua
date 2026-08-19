-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ItemUI = require(ReplicatedStorage.Library.Client.UI.ItemUI);
local BrainrotItem = require(ReplicatedStorage.Library.Items.BrainrotItem);
local Rainbow = require(ReplicatedStorage.Library.Client.GUIFX.Rainbow);
local FormatFigures = require(ReplicatedStorage.Library.Functions.FormatFigures);
require(ReplicatedStorage.Library.Items.BrainrotEggItem);
local BrainrotEggChanceUtil = require(ReplicatedStorage.Library.Util.BrainrotEggChanceUtil);
local BrainrotEggIconScaleUtil = require(ReplicatedStorage.Library.Util.BrainrotEggIconScaleUtil);
local Assets = ReplicatedStorage:WaitForChild("Assets");

return function(p1, p2, p3) -- Line: 15
    -- upvalues: BrainrotEggChanceUtil (copy), BrainrotItem (copy), Assets (copy), ItemUI (copy), BrainrotEggIconScaleUtil (copy), Rainbow (copy), FormatFigures (copy)
    local v4 = p3:Directory();
    local DropTable = v4.DropTable;
    local v5 = v4.RarityData and (v4.RarityData.TotalOdds or 0) or 0;
    local v6 = p3:GetData();
    local v7;

    if v6 then
        v7 = v6.Mutations;
    else
        v7 = nil;
    end;

    local v8 = BrainrotEggChanceUtil.GetBaseRewardChance(v4);
    local v9 = BrainrotEggChanceUtil.ComputeRewardChance(v8, v7);

    for _, v in ipairs(DropTable) do
        local v10 = v9 * (v5 <= 0 and 0 or v[2] / v5) * 100;
        local v11 = BrainrotItem(v[1]);
        local v12 = Assets.UI.Eggs.Brainrot:Clone();
        local v13 = ItemUI.Create(v11, {
            NoActionMenu = true,
            NoOverlay = true,
            NoButtonFX = true,
            HideQuantity = true,
            HideStrength = true
        });
        local Icon = v13:FindFirstChild("Icon");

        if Icon and Icon:IsA("ImageLabel") then
            local v14;

            if v6 then
                v14 = v6.Scale;
            else
                v14 = v6;
            end;

            BrainrotEggIconScaleUtil.ApplyIconScaleToImageLabel(Icon, v14);
        end;

        v12.LayoutOrder = 9999 - v10 * 20;

        if v10 < 0.1 then
            v12.Chance.Text = "??";
            Rainbow(v12.Chance, "TextColor3");
        else
            local v15 = math.pow(0.9315, v10) * 94.2467 / 100;
            local v16 = math.clamp(v15, 0, 1);
            local v17, v18, v19 = Color3.fromRGB(49, 255, 39):Lerp(Color3.fromRGB(255, 75, 39), v16):ToHSV();
            v12.Chance.TextColor3 = Color3.fromHSV(v17, v18, v19 * 2);
            v12.Chance.Text = `{FormatFigures(v10, 3, 5)}%`;
        end;

        v13.Parent = v12;
        v12.Parent = p1;
    end;
end;