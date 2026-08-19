-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AnimationModule = UtilsSystem.AnimationModule;
local CollectionService = UtilsSystem.CollectionService;

local function _onAniNpcAdded(p1) -- Line: 46
    -- upvalues: AnimationModule (copy)
    if not p1.Parent then
        return;
    end;

    local Parent = p1.Parent.Parent;

    if not (Parent and Parent:IsA("Model")) then
        return;
    end;

    local v2 = string.match(Parent.Name, "(.-)_") or Parent.Name;
    local v3 = p1:GetAttribute("AniName");

    if type(v3) == "string" and v3 ~= "" then
        AnimationModule.PlayAnim(p1, v3);

        return;
    end;

    AnimationModule.PlayAnim(p1, v2 .. "_待机");
end;

local function _onAniNpcRemoved(p4) -- Line: 36
    -- upvalues: AnimationModule (copy)
    AnimationModule.StopAll(p4);
end;

for _, v in CollectionService:GetTagged("AniNPC") do
    _onAniNpcAdded(v);
end;

CollectionService:GetInstanceAddedSignal("AniNPC"):Connect(_onAniNpcAdded);
CollectionService:GetInstanceRemovedSignal("AniNPC"):Connect(_onAniNpcRemoved);