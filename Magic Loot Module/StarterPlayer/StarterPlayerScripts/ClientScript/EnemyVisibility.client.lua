-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local EnemyVisibilityUtil = UtilsSystem.EnemyVisibilityUtil;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Monster = workspace:WaitForChild("Monster", (1 / 0));
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};

local function _applyPartHidden(p5, p6) -- Line: 35
    -- upvalues: u2 (copy)
    if not p6 then
        p5.LocalTransparencyModifier = 0;
        local v7 = u2[p5];

        if v7 then
            p5.CanCollide = v7.canCollide;
            p5.CanQuery = v7.canQuery;
            u2[p5] = nil;
        end;

        return;
    end;

    if not u2[p5] then
        u2[p5] = {
            canCollide = p5.CanCollide,
            canQuery = p5.CanQuery
        };
    end;

    p5.LocalTransparencyModifier = 1;
    p5.CanCollide = false;
    p5.CanQuery = false;
end;

local function _applyDecalHidden(p8, p9) -- Line: 65
    -- upvalues: u3 (copy)
    if p9 then
        if u3[p8] == nil then
            u3[p8] = p8.Transparency;
        end;

        p8.Transparency = 1;

        return;
    end;

    local v10 = u3[p8];

    if v10 == nil then
        p8.Transparency = 0;

        return;
    end;

    p8.Transparency = v10;
    u3[p8] = nil;
end;

local function _clearModelRestoreState(p11) -- Line: 89
    -- upvalues: u2 (copy), u3 (copy)
    for _, descendant in p11:GetDescendants() do
        if descendant:IsA("BasePart") then
            u2[descendant] = nil;
        elseif descendant:IsA("Decal") then
            u3[descendant] = nil;
        end;
    end;
end;

local function _applyModelVisibility(p12, p13) -- Line: 106
    -- upvalues: _applyPartHidden (copy), u3 (copy)
    for _, descendant in p12:GetDescendants() do
        if descendant:IsA("BasePart") then
            _applyPartHidden(descendant, p13);
        elseif descendant:IsA("Decal") then
            if p13 then
                if u3[descendant] == nil then
                    u3[descendant] = descendant.Transparency;
                end;

                descendant.Transparency = 1;
            else
                local v14 = u3[descendant];

                if v14 == nil then
                    descendant.Transparency = 0;
                else
                    descendant.Transparency = v14;
                    u3[descendant] = nil;
                end;
            end;
        end;
    end;
end;

local function _refreshModel(p15) -- Line: 122
    -- upvalues: EnemyVisibilityUtil (copy), LocalPlayer (copy), u1 (copy), _applyModelVisibility (copy)
    if not p15.Parent then
        return;
    end;

    local v16 = not EnemyVisibilityUtil.canPlayerSee(p15, LocalPlayer.UserId);

    if u1[p15] == v16 then
        return;
    end;

    u1[p15] = v16;
    _applyModelVisibility(p15, v16);
end;

local function _bindModel(u17) -- Line: 142
    -- upvalues: u4 (copy), EnemyVisibilityUtil (copy), LocalPlayer (copy), u1 (copy), _applyModelVisibility (copy), u2 (copy), u3 (copy), _clearModelRestoreState (copy)
    if u4[u17] then
        if not u17.Parent then
            return;
        end;

        local v18 = not EnemyVisibilityUtil.canPlayerSee(u17, LocalPlayer.UserId);

        if u1[u17] == v18 then
            return;
        end;

        u1[u17] = v18;
        _applyModelVisibility(u17, v18);

        return;
    end;

    local v20 = {
        [#v20 + 1] = u17.DescendantAdded:Connect(function(p19) -- Line: 149
            -- upvalues: u1 (ref), u17 (copy), u2 (ref), u3 (ref)
            if not u1[u17] then
                return;
            end;

            if not p19:IsA("BasePart") then
                if p19:IsA("Decal") then
                    if u3[p19] == nil then
                        u3[p19] = p19.Transparency;
                    end;

                    p19.Transparency = 1;
                end;

                return;
            end;

            if not u2[p19] then
                u2[p19] = {
                    canCollide = p19.CanCollide,
                    canQuery = p19.CanQuery
                };
            end;

            p19.LocalTransparencyModifier = 1;
            p19.CanCollide = false;
            p19.CanQuery = false;
        end),
        [#v20 + 1] = u17.Destroying:Connect(function() -- Line: 159
            -- upvalues: _clearModelRestoreState (ref), u17 (copy), u1 (ref), u4 (ref)
            _clearModelRestoreState(u17);
            u1[u17] = nil;
            u4[u17] = nil;
        end)
    };
    u4[u17] = v20;

    if not u17.Parent then
        return;
    end;

    local v21 = not EnemyVisibilityUtil.canPlayerSee(u17, LocalPlayer.UserId);

    if u1[u17] == v21 then
        return;
    end;

    u1[u17] = v21;
    _applyModelVisibility(u17, v21);
end;

local function _onMonsterChildAdded(p22) -- Line: 175
    -- upvalues: _bindModel (copy)
    if p22:IsA("Model") then
        _bindModel(p22);
    end;
end;

local function _onMonsterChildRemoved(p23) -- Line: 187
    -- upvalues: u1 (copy), _clearModelRestoreState (copy), u4 (copy)
    if not p23:IsA("Model") then
        return;
    end;

    u1[p23] = nil;
    _clearModelRestoreState(p23);
    local v24 = u4[p23];

    if v24 then
        for _, v in ipairs(v24) do
            v:Disconnect();
        end;

        u4[p23] = nil;
    end;
end;

for _, child in Monster:GetChildren() do
    if child:IsA("Model") then
        _bindModel(child);
    end;
end;

Monster.ChildAdded:Connect(_onMonsterChildAdded);
Monster.ChildRemoved:Connect(_onMonsterChildRemoved);

return nil;