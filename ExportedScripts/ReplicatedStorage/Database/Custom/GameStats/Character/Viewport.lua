-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local function DecompileAnimations(p1) -- Line: 10
    local v2 = {};

    for _, child in p1:GetChildren() do
        if child:IsA("Animation") then
            v2[child.Name] = child;
        end;
    end;

    return v2;
end;

return table.freeze({
    VIEWPORT_CHARACTER_OFFSET = CFrame.new(0, 0.025, 0.4),
    VIEWPORT_CHARACTER_CONFIG = {
        CT = {
            IdleAnimation = "rbxassetid://137360078752983",
            Character = "IDF",
            CameraOffset = CFrame.new(0, 0.2, -8) * CFrame.Angles(0, -3.141592653589793, 0),
            CharacterOffset = CFrame.new(0, 0.025, 0.4)
        },
        T = {
            IdleAnimation = "rbxassetid://99540873384647",
            Character = "Anarchist",
            CameraOffset = CFrame.new(0, 0.2, -8) * CFrame.Angles(0, -3.141592653589793, 0),
            CharacterOffset = CFrame.new(0, 0.025, 0.4)
        }
    },
    ANIMATION_MAPPING = {
        Grenade = DecompileAnimations(ReplicatedStorage.Assets.UI.Loadout.Animations.Grenade),
        Sniper = DecompileAnimations(ReplicatedStorage.Assets.UI.Loadout.Animations.Sniper),
        Pistol = DecompileAnimations(ReplicatedStorage.Assets.UI.Loadout.Animations.Pistol),
        Heavy = DecompileAnimations(ReplicatedStorage.Assets.UI.Loadout.Animations.Heavy),
        Rifle = DecompileAnimations(ReplicatedStorage.Assets.UI.Loadout.Animations.Rifle),
        Melee = DecompileAnimations(ReplicatedStorage.Assets.UI.Loadout.Animations.Melee),
        LMG = DecompileAnimations(ReplicatedStorage.Assets.UI.Loadout.Animations.LMG),
        SMG = DecompileAnimations(ReplicatedStorage.Assets.UI.Loadout.Animations.SMG)
    }
});