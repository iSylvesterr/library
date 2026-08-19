-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local u1 = {};
u1.__index = u1;
local u2 = Log.new();
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = nil;

function u1.new(p10, p11) -- Line: 51
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.BasePart(p10);
    Asserts.optional.finiteCFrame(p11);
    local v12 = setmetatable({}, u1);
    v12._part = p10;
    v12._baseCFrame = nil;
    v12._cframeOffset = CFrame.identity;
    v12._nextCFrame = nil;
    v12._tweenStartCFrame = nil;
    v12._tweenGoalCFrame = nil;
    v12._tweenInfo = nil;
    v12._tweenElapsed = 0;
    v12._baseSize = nil;
    v12._sizeScale = Vector3.new(1, 1, 1);
    v12._destroyed = false;

    if p11 then
        v12:SetCFrame(p11);
    end;

    return v12;
end;

local function isLivePart(p13) -- Line: 79
    local v14;

    if p13 == nil then
        v14 = false;
    else
        v14 = p13.Parent ~= nil;
    end;

    return v14;
end;

local function clearTween(p15) -- Line: 83
    -- upvalues: u5 (copy)
    u5[p15] = nil;
    p15._tweenStartCFrame = nil;
    p15._tweenGoalCFrame = nil;
    p15._tweenInfo = nil;
    p15._tweenElapsed = 0;
end;

local function multiplyVector(p16, p17) -- Line: 91
    return Vector3.new(p16.X * p17.X, p16.Y * p17.Y, p16.Z * p17.Z);
end;

local function getComposedCFrame(p18, p19) -- Line: 95
    return p19 * p18._cframeOffset;
end;

local function applyComposedSize(p20) -- Line: 99
    -- upvalues: u9 (ref)
    local _part = p20._part;
    local v21;

    if _part == nil then
        v21 = false;
    else
        v21 = _part.Parent ~= nil;
    end;

    if not v21 then
        u9(p20);

        return;
    end;

    local v22 = p20._baseSize or _part.Size;
    local _sizeScale = p20._sizeScale;
    _part.Size = Vector3.new(v22.X * _sizeScale.X, v22.Y * _sizeScale.Y, v22.Z * _sizeScale.Z);
end;

u9 = function(p23) -- Line: 114
    -- upvalues: u3 (copy), u4 (copy), u5 (copy)
    local _part = p23._part;

    if _part then
        u3[_part] = nil;
    end;

    u4[p23] = nil;
    u5[p23] = nil;
    p23._tweenStartCFrame = nil;
    p23._tweenGoalCFrame = nil;
    p23._tweenInfo = nil;
    p23._tweenElapsed = 0;
    p23._part = nil;
    p23._baseCFrame = nil;
    p23._nextCFrame = nil;
    p23._baseSize = nil;
    p23._destroyed = true;
end;

local function pruneDeadComponents() -- Line: 130
    -- upvalues: u3 (copy), u9 (ref)
    for i, v in pairs(u3) do
        local v24;

        if i == nil then
            v24 = false;
        else
            v24 = i.Parent ~= nil;
        end;

        if not v24 then
            u9(v);
        end;
    end;
end;

local function updateTweenComponents(p25) -- Line: 138
    -- upvalues: u5 (copy), u9 (ref), TweenService (copy), u4 (copy)
    for i in pairs(u5) do
        local _part = i._part;
        local _tweenStartCFrame = i._tweenStartCFrame;
        local _tweenGoalCFrame = i._tweenGoalCFrame;
        local _tweenInfo = i._tweenInfo;
        local v26;

        if _part == nil then
            v26 = false;
        else
            v26 = _part.Parent ~= nil;
        end;

        if v26 then
            if _tweenStartCFrame and (_tweenGoalCFrame and _tweenInfo) then
                i._tweenElapsed = i._tweenElapsed + p25;
                local v27 = _tweenInfo.Time <= 0 and 1 or math.clamp(i._tweenElapsed / _tweenInfo.Time, 0, 1);
                i._baseCFrame = _tweenStartCFrame:Lerp(_tweenGoalCFrame, (TweenService:GetValue(v27, _tweenInfo.EasingStyle, _tweenInfo.EasingDirection)));
                i._nextCFrame = i._baseCFrame * i._cframeOffset;
                u4[i] = true;

                if v27 >= 1 then
                    u5[i] = nil;
                    i._tweenStartCFrame = nil;
                    i._tweenGoalCFrame = nil;
                    i._tweenInfo = nil;
                    i._tweenElapsed = 0;
                end;
            else
                u5[i] = nil;
                i._tweenStartCFrame = nil;
                i._tweenGoalCFrame = nil;
                i._tweenInfo = nil;
                i._tweenElapsed = 0;
            end;
        else
            u9(i);
        end;
    end;
end;

function u1.SetCFrame(p28, p29) -- Line: 176
    -- upvalues: Asserts (copy), u9 (ref), u5 (copy), u4 (copy)
    Asserts.finiteCFrame(p29);

    if p28._destroyed then
        return;
    end;

    local _part = p28._part;
    local v30;

    if _part == nil then
        v30 = false;
    else
        v30 = _part.Parent ~= nil;
    end;

    if not v30 then
        u9(p28);

        return;
    end;

    u5[p28] = nil;
    p28._tweenStartCFrame = nil;
    p28._tweenGoalCFrame = nil;
    p28._tweenInfo = nil;
    p28._tweenElapsed = 0;
    p28._baseCFrame = p29;
    p28._nextCFrame = p29 * p28._cframeOffset;
    u4[p28] = true;
end;

function u1.SetCFrameNow(p31, p32) -- Line: 197
    -- upvalues: Asserts (copy), u9 (ref), u5 (copy), u4 (copy)
    Asserts.finiteCFrame(p32);

    if p31._destroyed then
        return;
    end;

    local _part = p31._part;
    local v33;

    if _part == nil then
        v33 = false;
    else
        v33 = _part.Parent ~= nil;
    end;

    if not v33 then
        u9(p31);

        return;
    end;

    u5[p31] = nil;
    p31._tweenStartCFrame = nil;
    p31._tweenGoalCFrame = nil;
    p31._tweenInfo = nil;
    p31._tweenElapsed = 0;
    u4[p31] = nil;
    p31._baseCFrame = p32;
    p31._nextCFrame = p32 * p31._cframeOffset;
    _part.CFrame = p31._nextCFrame;
end;

function u1.TweenCFrame(p34, p35, p36) -- Line: 221
    -- upvalues: Asserts (copy), u9 (ref), u5 (copy), u4 (copy)
    Asserts.TweenInfo(p35);
    Asserts.finiteCFrame(p36);

    if p34._destroyed then
        return;
    end;

    local _part = p34._part;
    local v37;

    if _part == nil then
        v37 = false;
    else
        v37 = _part.Parent ~= nil;
    end;

    if not v37 then
        u9(p34);

        return;
    end;

    p34._tweenStartCFrame = p34._baseCFrame or _part.CFrame;
    p34._tweenGoalCFrame = p36;
    p34._tweenInfo = p35;
    p34._tweenElapsed = 0;
    u5[p34] = true;
    u4[p34] = true;
end;

function u1.CancelTween(p38) -- Line: 245
    -- upvalues: u5 (copy)
    u5[p38] = nil;
    p38._tweenStartCFrame = nil;
    p38._tweenGoalCFrame = nil;
    p38._tweenInfo = nil;
    p38._tweenElapsed = 0;
end;

function u1.SetCFrameOffset(p39, p40) -- Line: 249
    -- upvalues: Asserts (copy), u9 (ref), u4 (copy)
    Asserts.finiteCFrame(p40);

    if p39._destroyed then
        return;
    end;

    local _part = p39._part;
    local v41;

    if _part == nil then
        v41 = false;
    else
        v41 = _part.Parent ~= nil;
    end;

    if not v41 then
        u9(p39);

        return;
    end;

    p39._cframeOffset = p40;
    local v42 = p39._baseCFrame or _part.CFrame;
    p39._baseCFrame = v42;
    p39._nextCFrame = v42 * p39._cframeOffset;
    u4[p39] = true;
end;

function u1.SetBaseSize(p43, p44) -- Line: 272
    -- upvalues: Asserts (copy), u9 (ref)
    Asserts.finiteVector3(p44);

    if p43._destroyed then
        return;
    end;

    p43._baseSize = p44;
    local _part = p43._part;
    local v45;

    if _part == nil then
        v45 = false;
    else
        v45 = _part.Parent ~= nil;
    end;

    if not v45 then
        u9(p43);

        return;
    end;

    local v46 = p43._baseSize or _part.Size;
    local _sizeScale = p43._sizeScale;
    _part.Size = Vector3.new(v46.X * _sizeScale.X, v46.Y * _sizeScale.Y, v46.Z * _sizeScale.Z);
end;

function u1.SetSizeScale(p47, p48) -- Line: 283
    -- upvalues: Asserts (copy), u9 (ref)
    Asserts.finiteVector3(p48);

    if p47._destroyed then
        return;
    end;

    p47._sizeScale = p48;
    local _part = p47._part;
    local v49;

    if _part == nil then
        v49 = false;
    else
        v49 = _part.Parent ~= nil;
    end;

    if not v49 then
        u9(p47);

        return;
    end;

    local v50 = p47._baseSize or _part.Size;
    local _sizeScale = p47._sizeScale;
    _part.Size = Vector3.new(v50.X * _sizeScale.X, v50.Y * _sizeScale.Y, v50.Z * _sizeScale.Z);
end;

function u1.Destroy(p51) -- Line: 294
    -- upvalues: u9 (ref)
    if p51._destroyed then
        return;
    end;

    u9(p51);
end;

function u1.GetPart(p52) -- Line: 302
    if p52._destroyed then
        return nil;
    end;

    return p52._part;
end;

function u8.Register(p53, p54) -- Line: 310
    -- upvalues: Asserts (copy), u3 (copy), u1 (copy)
    Asserts.BasePart(p53);
    Asserts.optional.finiteCFrame(p54);
    local v55 = u3[p53];

    if v55 and not v55._destroyed then
        if p54 then
            v55:SetCFrame(p54);
        end;

        return v55;
    end;

    local v56 = u1.new(p53, p54);
    u3[p53] = v56;

    return v56;
end;

function u8.SetCFrame(p57, p58) -- Line: 331
    -- upvalues: Asserts (copy), u8 (copy)
    Asserts.BasePart(p57);
    Asserts.finiteCFrame(p58);
    local v59 = u8.Register(p57);
    v59:SetCFrame(p58);

    return v59;
end;

function u8.SetCFrameOffset(p60, p61) -- Line: 342
    -- upvalues: Asserts (copy), u8 (copy)
    Asserts.BasePart(p60);
    Asserts.finiteCFrame(p61);
    local v62 = u8.Register(p60);
    v62:SetCFrameOffset(p61);

    return v62;
end;

function u8.SetCFrameNow(p63, p64) -- Line: 353
    -- upvalues: Asserts (copy), u8 (copy)
    Asserts.BasePart(p63);
    Asserts.finiteCFrame(p64);
    local v65 = u8.Register(p63);
    v65:SetCFrameNow(p64);

    return v65;
end;

function u8.TweenCFrame(p66, p67, p68) -- Line: 364
    -- upvalues: Asserts (copy), u8 (copy)
    Asserts.BasePart(p66);
    Asserts.TweenInfo(p67);
    Asserts.finiteCFrame(p68);
    local v69 = u8.Register(p66);
    v69:TweenCFrame(p67, p68);

    return v69;
end;

function u8.SetSize(p70, p71) -- Line: 376
    -- upvalues: Asserts (copy), u8 (copy)
    Asserts.BasePart(p70);
    Asserts.finiteVector3(p71);
    local v72 = u8.Register(p70);
    v72:SetBaseSize(p71);

    return v72;
end;

function u8.SetSizeScale(p73, p74) -- Line: 387
    -- upvalues: Asserts (copy), u8 (copy)
    Asserts.BasePart(p73);
    Asserts.finiteVector3(p74);
    local v75 = u8.Register(p73);
    v75:SetSizeScale(p74);

    return v75;
end;

function u8.Remove(p76) -- Line: 398
    -- upvalues: Asserts (copy), u3 (copy), u9 (ref)
    Asserts.BasePart(p76);
    local v77 = u3[p76];

    if v77 then
        u9(v77);
    end;
end;

function u8.Flush(p78) -- Line: 408
    -- upvalues: updateTweenComponents (copy), u6 (copy), u7 (copy), u4 (copy), u9 (ref), wcall (copy), Workspace (copy), pruneDeadComponents (copy), u2 (copy)
    updateTweenComponents(p78 or 0);
    table.clear(u6);
    table.clear(u7);
    local v79 = 0;

    for i in pairs(u4) do
        u4[i] = nil;
        local _part = i._part;
        local _nextCFrame = i._nextCFrame;
        i._nextCFrame = nil;
        local v80;

        if _part == nil then
            v80 = false;
        else
            v80 = _part.Parent ~= nil;
        end;

        if v80 then
            if _nextCFrame then
                v79 = v79 + 1;
                u6[v79] = _part;
                u7[v79] = _nextCFrame;
            end;
        else
            u9(i);
        end;
    end;

    if v79 <= 0 then
        return;
    end;

    if not wcall(function() -- Line: 443
        -- upvalues: Workspace (ref), u6 (ref), u7 (ref)
        Workspace:BulkMoveTo(u6, u7, Enum.BulkMoveMode.FireCFrameChanged);
    end) then
        pruneDeadComponents();
        u2:AtWarning():Log("[BulkMoveController] bulk move failed; pruned dead components");
    end;
end;

RunService.PreSimulation:Connect(u8.Flush);

return u8;