-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local OddsBillboard = require(ReplicatedStorage.Library.Client.UI.OddsBillboard);
local u1 = {};
u1.__index = u1;

local function isStateUsable(p2) -- Line: 53
    if not p2 then
        return false;
    end;

    local parent = p2.parent;

    if not (parent and parent.Parent) then
        return false;
    end;

    local dropTable = p2.dropTable;

    return dropTable and #dropTable ~= 0 and true or false;
end;

function u1.new(p3) -- Line: 71
    -- upvalues: u1 (copy)
    local v4 = {
        _state = nil,
        _handle = nil,
        _visible = false,
        _destroyed = false,
        _defaultThreshold = (not p3 or typeof(p3.defaultThreshold) ~= "number") and 30 or p3.defaultThreshold,
        _defaultMaxDistance = (not p3 or typeof(p3.defaultMaxDistance) ~= "number") and 75 or p3.defaultMaxDistance,
        _defaultStudsOffset = (not p3 or typeof(p3.defaultStudsOffset) ~= "Vector3") and Vector3.new(0, 0, 0) or p3.defaultStudsOffset
    };

    return setmetatable(v4, u1);
end;

function u1.GetBillboard(p5) -- Line: 89
    local _handle = p5._handle;

    if _handle then
        return _handle:GetBillboard();
    end;

    return nil;
end;

function u1.SetVisible(p6, p7) -- Line: 98
    if p6._destroyed then
        return;
    end;

    if p6._visible == p7 then
        return;
    end;

    p6._visible = p7;
    local _handle = p6._handle;

    if _handle then
        if p7 then
            local _state = p6._state;

            if _state then
                local parent = _state.parent;

                if parent and parent.Parent then
                    local dropTable = _state.dropTable;
                    p7 = dropTable and #dropTable ~= 0 and true or false;
                else
                    p7 = false;
                end;
            else
                p7 = false;
            end;
        end;

        _handle:SetVisible(p7);
    end;
end;

function u1.Update(p8, p9) -- Line: 115
    -- upvalues: OddsBillboard (copy)
    if p8._destroyed then
        return;
    end;

    p8._state = p9;
    local _handle = p8._handle;
    local v10;

    if p9 then
        local parent = p9.parent;

        if parent and parent.Parent then
            local dropTable = p9.dropTable;
            v10 = dropTable and #dropTable ~= 0 and true or false;
        else
            v10 = false;
        end;
    else
        v10 = false;
    end;

    if not v10 then
        if _handle then
            _handle:Update(nil);
            _handle:SetVisible(false);
        end;

        p8._visible = false;

        return;
    end;

    if not _handle then
        _handle = OddsBillboard.new();
        p8._handle = _handle;
    end;

    assert(_handle, "luau");
    local v11 = {
        parent = p9.parent,
        dropTable = p9.dropTable,
        title = p9.title,
        scale = p9.scale,
        studsOffsetWorldSpace = p9.studsOffsetWorldSpace or p8._defaultStudsOffset,
        maxDistance = p9.maxDistance or p8._defaultMaxDistance,
        adornee = p9.adornee,
        animate = p9.animate or true,
        normalizedOdds = p9.normalizedOdds
    };

    if not v11.adornee and p9.parent then
        v11.adornee = p9.parent;
    end;

    _handle:Update(v11);
    _handle:SetVisible(p8._visible);
end;

function u1.IsBillboardVisible(p12) -- Line: 159
    if p12._destroyed then
        return false;
    end;

    local _handle = p12._handle;

    if not _handle then
        return false;
    end;

    local v13 = _handle:GetBillboard();

    if v13 then
        return v13.Enabled;
    end;

    return false;
end;

function u1.UpdateVisibility(p14, p15, p16) -- Line: 177
    if p14._destroyed then
        return;
    end;

    if p16 then
        p14:SetVisible(false);

        return;
    end;

    local _state = p14._state;

    if _state then
        local v17;

        if _state then
            local parent = _state.parent;

            if parent and parent.Parent then
                local dropTable = _state.dropTable;
                v17 = dropTable and #dropTable ~= 0 and true or false;
            else
                v17 = false;
            end;
        else
            v17 = false;
        end;

        if v17 then
            local _handle = p14._handle;

            if not _handle then
                return;
            end;

            local v18 = _handle:GetBillboard();

            if not (v18 and v18.Parent) then
                p14:SetVisible(false);

                return;
            end;

            local rangePart = _state.rangePart;
            local v19;

            if rangePart and rangePart.Parent then
                v19 = rangePart.Position;
            else
                v19 = nil;
            end;

            if not v19 then
                local rangeCFrame = _state.rangeCFrame;

                if rangeCFrame then
                    v19 = rangeCFrame.Position;
                end;
            end;

            if not v19 then
                local parent = _state.parent;

                if parent and (parent:IsA("BasePart") and parent.Parent) then
                    v19 = parent.Position;
                end;
            end;

            if v19 and (p15 and p15.Parent) then
                p14:SetVisible((_state.threshold or p14._defaultThreshold) >= (v19 - p15.Position).Magnitude);

                return;
            end;

            p14:SetVisible(false);

            return;
        end;
    end;

    p14:SetVisible(false);
end;

function u1.Destroy(p20) -- Line: 239
    if p20._destroyed then
        return;
    end;

    p20._destroyed = true;
    p20._state = nil;
    local _handle = p20._handle;

    if _handle then
        p20._handle = nil;
        _handle:Destroy();
    end;
end;

return u1;