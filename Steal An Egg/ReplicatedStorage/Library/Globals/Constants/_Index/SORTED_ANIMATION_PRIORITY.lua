-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local EnumList = require(ReplicatedStorage.Library.Modules.Packages.EnumList);
local AnimationPriority = Enum.AnimationPriority;

return EnumList.new("SortedAnimationTrack", {
    AnimationPriority.Core,
    AnimationPriority.Idle,
    AnimationPriority.Movement,
    AnimationPriority.Action,
    AnimationPriority.Action2,
    AnimationPriority.Action3,
    AnimationPriority.Action4
});