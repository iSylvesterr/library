-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Knit = require(ReplicatedStorage.Packages.Knit);
local u1 = Color3.fromRGB(0, 170, 0);
local u2 = Color3.fromRGB(150, 150, 150);
local v3 = Knit.CreateController({
    Name = "GroupRewardController"
});

function v3.Open(u4) -- Line: 17
    u4.UI_Manager:OpenWindow(u4._window);
    task.spawn(function() -- Line: 20
        -- upvalues: u4 (copy)
        local v5, v6 = u4.GroupRewardService:IsInGroup():await();

        if v5 then
            v5 = v6 == true;
        end;

        u4._inGroup = v5;
        u4:_refreshButton();
    end);
end;

function v3._refreshButton(p7) -- Line: 27
    -- upvalues: u1 (copy), u2 (copy)
    local _claimButton = p7._claimButton;

    if not _claimButton then
        return;
    end;

    _claimButton.BackgroundColor3 = p7._inGroup and u1 or u2;
end;

function v3.KnitStart(u8) -- Line: 33
    -- upvalues: Players (copy)
    local GroupReward = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Windows"):WaitForChild("GroupReward");
    local Exit = GroupReward.Top.Exit;
    u8._window = GroupReward;
    u8._inGroup = false;
    GroupReward.Visible = false;
    local Icon = GroupReward.Content.LeftSide.Reward.Icon;

    for _, child in GroupReward.Content.LeftSide:GetChildren() do
        if child:IsA("TextLabel") and child.Text:find("Bow") then
            child.RichText = true;
            child.Text = "FREE <font color=\"rgb(0,170,0)\">Radioactive</font> Orange Seed!";
        end;
    end;

    local Button = GroupReward.ClaimButton.Button;
    u8._claimButton = Button;
    u8:_refreshButton();
    u8.UI_Manager:AddShineV3(Icon, 1.75, Color3.new(0, 1, 0));
    u8.UI_Manager:AddEmitterTemplate(Icon, UDim2.new(0.5, 0, 0.5, 0), u8.UI_Manager.PARTICLE_TEMPLATES.SPARKLE, {
        zIndex = 3,
        em_delay = 0.3
    });
    u8.UI_Manager:AddBounceButton(Exit, 1.1, true);
    Exit.Activated:Connect(function() -- Line: 70
        -- upvalues: u8 (copy), GroupReward (copy)
        u8.UI_Manager:CloseWindow(GroupReward);
    end);
    local u9 = false;
    Button.Activated:Connect(function() -- Line: 75
        -- upvalues: u8 (copy), u9 (ref), GroupReward (copy)
        if not u8._inGroup or u9 then
            return;
        end;

        u9 = true;
        local v10, v11 = u8.GroupRewardService:Claim():await();
        u9 = false;

        if v10 and v11 then
            u8.UI_Manager:CloseWindow(GroupReward);
        end;
    end);
end;

function v3.KnitInit(p12) -- Line: 86
    -- upvalues: Knit (copy)
    p12.UI_Manager = Knit.GetController("UI_Manager");
    p12.GroupRewardService = Knit.GetService("GroupRewardService");
end;

return v3;