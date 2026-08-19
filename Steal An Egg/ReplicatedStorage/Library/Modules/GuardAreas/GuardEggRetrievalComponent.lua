-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Physics = require(ReplicatedStorage.Library.Modules.Physics);
local WaitFor = require(ReplicatedStorage.Library.Modules.Packages.WaitFor);
local Weld = require(ReplicatedStorage.Library.Functions.Weld);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local GuardDistance = require(script.Parent.GuardDistance);
require(script.Parent.Types.Interface);
local u1 = {};
u1.__index = u1;
u1.__class = "GuardEggRetrievalComponent";

function u1.new(p2, p3, p4) -- Line: 42
    -- upvalues: Asserts (copy), WaitFor (copy), Constants (copy), u1 (copy)
    Asserts.Model(p2);
    Asserts.BasePart(p3);
    Asserts.CFrame(p4);
    local v5, v6 = WaitFor.Descendant(p2, "EggPoint", Constants.STUDIO_YIELD_TIMEOUT):await();
    local v7 = `Failed to resolve EggPoint under {p2:GetFullName()}: {tostring(v6)}`;
    assert(v5, v7);
    local v8 = v6:IsA("BasePart");
    local v9 = `{p2:GetFullName()}.EggPoint must be a BasePart`;
    assert(v8, v9);
    local v10 = setmetatable({}, u1);
    v10._byUid = {};
    v10._current = nil;
    v10._eggPoint = v6;
    v10._homeCFrame = p4;
    v10._queue = {};
    v10._root = p3;
    v10._stage = nil;
    v10._weld = nil;

    return v10;
end;

function u1._enqueue(p11, p12) -- Line: 72
    for i, v in ipairs(p11._queue) do
        if p12.Priority > v.Priority then
            table.insert(p11._queue, i, p12);

            return;
        end;
    end;

    table.insert(p11._queue, p12);
end;

function u1._selectCurrent(p13) -- Line: 85
    if p13._current ~= nil then
        return p13._current;
    end;

    while #p13._queue > 0 do
        local v14 = table.remove(p13._queue, 1);
        assert(v14 ~= nil, "Non-empty guard retrieval queue must yield a target");
        local Model = v14.Model;

        if p13._byUid[v14.EggUid] == v14 and (Model == nil or Model.Parent ~= nil) then
            p13._current = v14;
            p13._stage = "Approaching";

            return v14;
        end;

        p13._byUid[v14.EggUid] = nil;
    end;

    return nil;
end;

function u1._destroyWeld(p15) -- Line: 105
    local _weld = p15._weld;

    if _weld ~= nil then
        p15._weld = nil;
        _weld:Destroy();
    end;
end;

function u1._removeCurrent(p16) -- Line: 113
    local _current = p16._current;
    assert(_current ~= nil, "Guard retrieval current target is required");
    p16:_destroyWeld();
    p16._byUid[_current.EggUid] = nil;
    p16._current = nil;
    p16._stage = nil;

    return _current;
end;

function u1.Register(p17, p18) -- Line: 127
    -- upvalues: Asserts (copy)
    Asserts.table(p18);
    Asserts.string(p18.EggUid);
    Asserts.optional.Model(p18.Model);
    Asserts.Vector3(p18.DroppedPosition);
    Asserts.CFrame(p18.NestBottomCFrame);
    Asserts.number(p18.Priority);

    if p17._byUid[p18.EggUid] ~= nil then
        return false;
    end;

    p17._byUid[p18.EggUid] = p18;
    p17:_enqueue(p18);
    local _current = p17._current;

    if _current ~= nil and (p17._stage == "Approaching" and p18.Priority > _current.Priority) then
        p17._current = nil;
        p17._stage = nil;
        p17:_enqueue(_current);
    end;

    return true;
end;

function u1.Clear(p19, p20) -- Line: 155
    -- upvalues: Asserts (copy)
    Asserts.string(p20);
    local v21 = p19._byUid[p20];

    if v21 == nil then
        return false;
    end;

    p19._byUid[p20] = nil;

    if p19._current == v21 then
        p19:_destroyWeld();
        p19._current = nil;
        p19._stage = nil;
    end;

    local v22 = table.find(p19._queue, v21);

    if v22 ~= nil then
        table.remove(p19._queue, v22);
    end;

    return true;
end;

function u1.HasPending(p23) -- Line: 176
    return next(p23._byUid) ~= nil;
end;

function u1.IsAttached(p24, p25) -- Line: 180
    -- upvalues: Asserts (copy)
    Asserts.string(p25);
    local v26;

    if p24._current == nil or p24._current.EggUid ~= p25 then
        v26 = false;
    else
        v26 = p24._stage == "Carrying";
    end;

    return v26;
end;

function u1.GetMoveTarget(p27) -- Line: 185
    local v28 = p27:_selectCurrent();

    if v28 == nil then
        return nil;
    end;

    if p27._stage == "Carrying" then
        return p27._homeCFrame.Position;
    end;

    return v28.DroppedPosition;
end;

function u1.TryTransition(p29, p30) -- Line: 196
    -- upvalues: Asserts (copy), GuardDistance (copy), Physics (copy), Weld (copy)
    Asserts.number(p30);
    local v31 = p29:_selectCurrent();

    if v31 == nil then
        return nil;
    end;

    local Model = v31.Model;

    if Model ~= nil and Model.Parent == nil then
        p29:Clear(v31.EggUid);

        return nil;
    end;

    if p29._stage == "Approaching" then
        if p30 < GuardDistance.XZ(p29._root.Position, v31.DroppedPosition) then
            return nil;
        end;

        if Model ~= nil then
            local PrimaryPart = Model.PrimaryPart;
            local v32 = `Rendered guard retrieval egg {v31.EggUid} must have a PrimaryPart`;
            assert(PrimaryPart ~= nil, v32);
            Physics.SetAnchored(Model, false);
            Model:PivotTo(p29._eggPoint.CFrame * CFrame.new(0, 0, -PrimaryPart.Size.Z * 0.5));
            p29._weld = Weld(p29._eggPoint, PrimaryPart);
        end;

        p29._stage = "Carrying";

        return "Attached";
    end;

    if GuardDistance.XZ(p29._root.Position, p29._homeCFrame.Position) > 20 then
        return nil;
    end;

    p29:_destroyWeld();

    if Model ~= nil then
        Physics.SetAnchored(Model, true);
        Model:PivotTo(v31.NestBottomCFrame);
    end;

    p29:_removeCurrent();

    return "Deposited";
end;

function u1.GetCurrentEggUid(p33) -- Line: 241
    local v34 = p33:_selectCurrent();

    if v34 == nil then
        return nil;
    end;

    return v34.EggUid;
end;

function u1.Destroy(p35) -- Line: 246
    p35:_destroyWeld();
    table.clear(p35._byUid);
    table.clear(p35._queue);
    p35._current = nil;
    p35._stage = nil;
end;

return u1;