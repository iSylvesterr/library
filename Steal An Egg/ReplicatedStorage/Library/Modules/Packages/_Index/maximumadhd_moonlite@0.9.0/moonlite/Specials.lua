-- Decompiled with Potassium's decompiler.

local Parent = script.Parent;
local RunService = game:GetService("RunService");
require(Parent.Types);
local u1 = {};

local function getValue(p2, p3, p4) -- Line: 70
    return p2:GetAttribute((`__moonlite_{p3}`)) or p4;
end;

local function setValue(p5, p6, p7, p8) -- Line: 74
    local v9 = `__moonlite_{p6}`;

    if p7 == p8 then
        p7 = nil;
    end;

    p5:SetAttribute(v9, p7);
end;

local function BoundProp(u10) -- Line: 78
    return function(u11, u12) -- Line: 79
        -- upvalues: u10 (copy)
        assert(u10.Get);

        return {
            Get = function() -- Line: 83, Name: Get
                -- upvalues: u10 (ref), u11 (copy), u12 (copy)
                return u10.Get(u11, u12);
            end,

            Set = function(p13) -- Line: 87, Name: Set
                -- upvalues: u10 (ref), u11 (copy), u12 (copy)
                u10.Set(p13, u11, u12);
            end
        };
    end;
end;

local function LazyAction(u14) -- Line: 94
    return function(u15) -- Line: 95
        -- upvalues: u14 (copy)
        return {
            Default = false,

            Set = function(p16) -- Line: 99, Name: Set
                -- upvalues: u14 (ref), u15 (copy)
                if p16 then
                    u14(u15);
                end;
            end
        };
    end;
end;

local function setCameraActive(u17, u18, p19) -- Line: 114
    -- upvalues: RunService (copy)
    if p19 and not u17._cameraRenderBound then
        RunService:BindToRenderStep("MoonliteRenderCamera", 1000, function() -- Line: 116, Name: updateCamera
            -- upvalues: u17 (copy), u18 (copy)
            local _cameraAttachToPart = u17._cameraAttachToPart;
            local _cameraLookAtPart = u17._cameraLookAtPart;

            if _cameraAttachToPart then
                local CFrame2 = _cameraAttachToPart.CFrame;

                if _cameraLookAtPart then
                    CFrame2 = CFrame.new(CFrame2.Position, _cameraLookAtPart.Position);
                end;

                u18.CFrame = CFrame2;
            end;
        end);
        u17._cameraRenderBound = true;
        local _cameraAttachToPart = u17._cameraAttachToPart;
        local _cameraLookAtPart = u17._cameraLookAtPart;

        if _cameraAttachToPart then
            local CFrame2 = _cameraAttachToPart.CFrame;

            if _cameraLookAtPart then
                CFrame2 = CFrame.new(CFrame2.Position, _cameraLookAtPart.Position);
            end;

            u18.CFrame = CFrame2;
        end;

        if not u17.KeepCameraType then
            u18.CameraType = Enum.CameraType.Scriptable;
        end;
    elseif not p19 and u17._cameraRenderBound then
        RunService:UnbindFromRenderStep("MoonliteRenderCamera");

        if not u17.KeepCameraType then
            u18.CameraType = Enum.CameraType.Custom;
        end;

        u17._cameraRenderBound = false;
    end;
end;

local v20 = {};
local u26 = {
    Get = function(p21, p22) -- Line: 151, Name: Get
        return p22._cameraAttachToPart;
    end,

    Set = function(p23, u24, u25) -- Line: 155, Name: Set
        -- upvalues: RunService (copy)
        if p23 then
            u25._activeCamera = u24;
            u25._cameraAttachToPart = p23;

            if not u25._cameraRenderBound then
                RunService:BindToRenderStep("MoonliteRenderCamera", 1000, function() -- Line: 116, Name: updateCamera
                    -- upvalues: u25 (copy), u24 (copy)
                    local _cameraAttachToPart = u25._cameraAttachToPart;
                    local _cameraLookAtPart = u25._cameraLookAtPart;

                    if _cameraAttachToPart then
                        local CFrame2 = _cameraAttachToPart.CFrame;

                        if _cameraLookAtPart then
                            CFrame2 = CFrame.new(CFrame2.Position, _cameraLookAtPart.Position);
                        end;

                        u24.CFrame = CFrame2;
                    end;
                end);
                u25._cameraRenderBound = true;
                local _cameraAttachToPart = u25._cameraAttachToPart;
                local _cameraLookAtPart = u25._cameraLookAtPart;

                if _cameraAttachToPart then
                    local CFrame2 = _cameraAttachToPart.CFrame;

                    if _cameraLookAtPart then
                        CFrame2 = CFrame.new(CFrame2.Position, _cameraLookAtPart.Position);
                    end;

                    u24.CFrame = CFrame2;
                end;

                if not u25.KeepCameraType then
                    u24.CameraType = Enum.CameraType.Scriptable;
                end;
            end;
        else
            u25._cameraAttachToPart = nil;
        end;
    end
};

function v20.AttachToPart(u27, u28) -- Line: 79
    -- upvalues: u26 (copy)
    assert(u26.Get);

    return {
        Get = function() -- Line: 83, Name: Get
            -- upvalues: u26 (ref), u27 (copy), u28 (copy)
            return u26.Get(u27, u28);
        end,

        Set = function(p29) -- Line: 87, Name: Set
            -- upvalues: u26 (ref), u27 (copy), u28 (copy)
            u26.Set(p29, u27, u28);
        end
    };
end;

local u35 = {
    Get = function(p30, p31) -- Line: 167, Name: Get
        return p31._cameraLookAtPart;
    end,

    Set = function(p32, u33, u34) -- Line: 171, Name: Set
        -- upvalues: RunService (copy)
        if p32 then
            u34._activeCamera = u33;
            u34._cameraLookAtPart = p32;

            if not u34._cameraRenderBound then
                RunService:BindToRenderStep("MoonliteRenderCamera", 1000, function() -- Line: 116, Name: updateCamera
                    -- upvalues: u34 (copy), u33 (copy)
                    local _cameraAttachToPart = u34._cameraAttachToPart;
                    local _cameraLookAtPart = u34._cameraLookAtPart;

                    if _cameraAttachToPart then
                        local CFrame2 = _cameraAttachToPart.CFrame;

                        if _cameraLookAtPart then
                            CFrame2 = CFrame.new(CFrame2.Position, _cameraLookAtPart.Position);
                        end;

                        u33.CFrame = CFrame2;
                    end;
                end);
                u34._cameraRenderBound = true;
                local _cameraAttachToPart = u34._cameraAttachToPart;
                local _cameraLookAtPart = u34._cameraLookAtPart;

                if _cameraAttachToPart then
                    local CFrame2 = _cameraAttachToPart.CFrame;

                    if _cameraLookAtPart then
                        CFrame2 = CFrame.new(CFrame2.Position, _cameraLookAtPart.Position);
                    end;

                    u33.CFrame = CFrame2;
                end;

                if not u34.KeepCameraType then
                    u33.CameraType = Enum.CameraType.Scriptable;
                end;
            end;

            if u34._updateCamera then
                u34._updateCamera();
            end;
        else
            u34._cameraLookAtPart = nil;

            if not u34._cameraAttachToPart and u34._cameraRenderBound then
                RunService:UnbindFromRenderStep("MoonliteRenderCamera");

                if not u34.KeepCameraType then
                    u33.CameraType = Enum.CameraType.Custom;
                end;

                u34._cameraRenderBound = false;
            end;
        end;
    end
};

function v20.LookAtPart(u36, u37) -- Line: 79
    -- upvalues: u35 (copy)
    assert(u35.Get);

    return {
        Get = function() -- Line: 83, Name: Get
            -- upvalues: u35 (ref), u36 (copy), u37 (copy)
            return u35.Get(u36, u37);
        end,

        Set = function(p38) -- Line: 87, Name: Set
            -- upvalues: u35 (ref), u36 (copy), u37 (copy)
            u35.Set(p38, u36, u37);
        end
    };
end;

u1.Camera = v20;
u1.Terrain = {};
local u39 = {
    Camera = {
        AttachToPart = true,
        LookAtPart = true
    },
    Humanoid = {
        AddAccessory = true,
        ChangeState = true,
        EquipTool = true,
        MoveTo = true,
        Move = true,
        PlayEmote = true,
        RemoveAccessories = true,
        TakeDamage = true,
        UnequipTools = true
    },
    ParticleEmitter = {
        Emit = true,
        Clear = true
    },
    Sound = {
        PlayOnce = true,
        SetTime = true,
        Play = true,
        Resume = true,
        Pause = true,
        Stop = true
    }
};

for _, v in Enum.Material:GetEnumItems() do
    if pcall(function() -- Line: 198
        -- upvalues: v (copy)
        workspace.Terrain:GetMaterialColor(v);
    end) then
        local u43 = {
            Get = function(p40) -- Line: 204, Name: Get
                -- upvalues: v (copy)
                return p40:GetMaterialColor(v);
            end,

            Set = function(p41, p42) -- Line: 208, Name: Set
                -- upvalues: v (copy)
                p42:SetMaterialColor(v, p41);
            end
        };

        u1.Terrain[`MC_{v.Name}`] = function(u44, u45) -- Line: 79
            -- upvalues: u43 (copy)
            assert(u43.Get);

            return {
                Get = function() -- Line: 83, Name: Get
                    -- upvalues: u43 (ref), u44 (copy), u45 (copy)
                    return u43.Get(u44, u45);
                end,

                Set = function(p46) -- Line: 87, Name: Set
                    -- upvalues: u43 (ref), u44 (copy), u45 (copy)
                    u43.Set(p46, u44, u45);
                end
            };
        end;
    end;
end;

local u47 = Color3.new(1, 1, 1);
local v48 = {};
local u52 = {
    Get = function(p49) -- Line: 223, Name: Get
        return p49:GetPivot();
    end,

    Set = function(p50, p51) -- Line: 227, Name: Set
        p51:PivotTo(p50);
    end
};

function v48.CFrame(u53, u54) -- Line: 79
    -- upvalues: u52 (copy)
    assert(u52.Get);

    return {
        Get = function() -- Line: 83, Name: Get
            -- upvalues: u52 (ref), u53 (copy), u54 (copy)
            return u52.Get(u53, u54);
        end,

        Set = function(p55) -- Line: 87, Name: Set
            -- upvalues: u52 (ref), u53 (copy), u54 (copy)
            u52.Set(p55, u53, u54);
        end
    };
end;

local u61 = {
    Get = function(p56) -- Line: 233, Name: Get
        -- upvalues: u47 (copy)
        return p56:GetAttribute("__moonlite_Color") or u47;
    end,

    Set = function(p57, p58) -- Line: 237, Name: Set
        -- upvalues: u47 (copy)
        for _, descendant in p58:GetDescendants() do
            if descendant:IsA("BasePart") then
                local Color = descendant.Color;
                local v59 = descendant:GetAttribute("__moonlite_Color") or Color;

                if v59 ~= p57 then
                    local v60;

                    if p57 == v59 then
                        v60 = nil;
                    else
                        v60 = p57;
                    end;

                    descendant:SetAttribute("__moonlite_Color", v60);
                    descendant.Color = p57;
                end;
            end;
        end;

        if p57 == u47 then
            p57 = nil;
        end;

        p58:SetAttribute("__moonlite_Color", p57);
    end
};

function v48.Color(u62, u63) -- Line: 79
    -- upvalues: u61 (copy)
    assert(u61.Get);

    return {
        Get = function() -- Line: 83, Name: Get
            -- upvalues: u61 (ref), u62 (copy), u63 (copy)
            return u61.Get(u62, u63);
        end,

        Set = function(p64) -- Line: 87, Name: Set
            -- upvalues: u61 (ref), u62 (copy), u63 (copy)
            u61.Set(p64, u62, u63);
        end
    };
end;

local u68 = {
    Get = function(p65) -- Line: 254, Name: Get
        return p65:GetScale();
    end,

    Set = function(p66, p67) -- Line: 258, Name: Set
        p67:ScaleTo(p66);
    end
};

function v48.Scale(u69, u70) -- Line: 79
    -- upvalues: u68 (copy)
    assert(u68.Get);

    return {
        Get = function() -- Line: 83, Name: Get
            -- upvalues: u68 (ref), u69 (copy), u70 (copy)
            return u68.Get(u69, u70);
        end,

        Set = function(p71) -- Line: 87, Name: Set
            -- upvalues: u68 (ref), u69 (copy), u70 (copy)
            u68.Set(p71, u69, u70);
        end
    };
end;

local u76 = {
    Get = function(p72) -- Line: 264, Name: Get
        return p72:GetAttribute("__moonlite_Reflectance") or 0;
    end,

    Set = function(p73, p74) -- Line: 268, Name: Set
        if (p74:GetAttribute("__moonlite_Reflectance") or 0) ~= p73 then
            for _, descendant in p74:GetDescendants() do
                if descendant:IsA("BasePart") then
                    local Reflectance = descendant.Reflectance;
                    local v75 = descendant:GetAttribute("__moonlite_BaseReflectance") or Reflectance;
                    descendant.Reflectance = v75 + (1 - v75) * p73;
                end;
            end;

            if p73 == 0 then
                p73 = nil;
            end;

            p74:SetAttribute("__moonlite_Reflectance", p73);
        end;
    end
};

function v48.Reflectance(u77, u78) -- Line: 79
    -- upvalues: u76 (copy)
    assert(u76.Get);

    return {
        Get = function() -- Line: 83, Name: Get
            -- upvalues: u76 (ref), u77 (copy), u78 (copy)
            return u76.Get(u77, u78);
        end,

        Set = function(p79) -- Line: 87, Name: Set
            -- upvalues: u76 (ref), u77 (copy), u78 (copy)
            u76.Set(p79, u77, u78);
        end
    };
end;

local u83 = {
    Get = function(p80) -- Line: 286, Name: Get
        return p80:GetAttribute("__moonlite_Transparency") or 0;
    end,

    Set = function(p81, p82) -- Line: 290, Name: Set
        if (p82:GetAttribute("__moonlite_Transparency") or 0) ~= p81 then
            for _, descendant in p82:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.LocalTransparencyModifier = p81;
                end;
            end;

            if p81 == 0 then
                p81 = nil;
            end;

            p82:SetAttribute("__moonlite_Transparency", p81);
        end;
    end
};

function v48.Transparency(u84, u85) -- Line: 79
    -- upvalues: u83 (copy)
    assert(u83.Get);

    return {
        Get = function() -- Line: 83, Name: Get
            -- upvalues: u83 (ref), u84 (copy), u85 (copy)
            return u83.Get(u84, u85);
        end,

        Set = function(p86) -- Line: 87, Name: Set
            -- upvalues: u83 (ref), u84 (copy), u85 (copy)
            u83.Set(p86, u84, u85);
        end
    };
end;

u1.Model = v48;
local v93 = {
    AddAccessory = function(u87) -- Line: 312, Name: AddAccessory
        return {
            Default = nil,

            Set = function(p88) -- Line: 318, Name: Set
                -- upvalues: u87 (copy)
                if p88 then
                    pcall(u87.AddAccessory, u87, p88);
                end;
            end
        };
    end,

    ChangeState = function(u89) -- Line: 326, Name: ChangeState
        return {
            Default = Enum.HumanoidStateType.None,

            Set = function(p90) -- Line: 330, Name: Set
                -- upvalues: u89 (copy)
                u89:ChangeState(p90);
            end
        };
    end,

    EquipTool = function(u91) -- Line: 336, Name: EquipTool
        return {
            Default = nil,

            Set = function(p92) -- Line: 342, Name: Set
                -- upvalues: u91 (copy)
                if p92 then
                    pcall(u91.EquipTool, u91, p92);
                end;
            end
        };
    end
};

local function u95(p94) -- Line: 350
    p94.Jump = true;
end;

function v93.Jump(u96) -- Line: 95
    -- upvalues: u95 (copy)
    return {
        Default = false,

        Set = function(p97) -- Line: 99, Name: Set
            -- upvalues: u95 (ref), u96 (copy)
            if p97 then
                u95(u96);
            end;
        end
    };
end;

function v93.MoveTo(u98) -- Line: 354
    local v99 = u98:GetAttribute("MoveToDefault");

    if typeof(v99) ~= "Vector3" then
        local RootPart = u98.RootPart;
        v99 = not RootPart and Vector3.new(0, 0, 0) or RootPart.Position;
        u98:SetAttribute("MoveToDefault", v99);
    end;

    return {
        Default = v99,

        Set = function(p100) -- Line: 372, Name: Set
            -- upvalues: u98 (copy)
            u98:MoveTo(p100);
        end
    };
end;

function v93.Move(u101) -- Line: 378
    local v102 = u101:GetAttribute("MoveDefault");

    if typeof(v102) ~= "Vector3" then
        local RootPart = u101.RootPart;
        v102 = not RootPart and Vector3.new(0, 0, 0) or RootPart.CFrame.LookVector;
        u101:SetAttribute("MoveDefault", v102);
    end;

    return {
        Default = v102,

        Set = function(p103) -- Line: 396, Name: Set
            -- upvalues: u101 (copy)
            u101:Move(p103);
        end
    };
end;

function v93.PlayEmote(u104) -- Line: 402
    return {
        Default = "",

        Set = function(p105) -- Line: 406, Name: Set
            -- upvalues: u104 (copy)
            u104:PlayEmote(p105);
        end
    };
end;

local function u107(p106) -- Line: 412
    p106:RemoveAccessories();
end;

function v93.RemoveAccessories(u108) -- Line: 95
    -- upvalues: u107 (copy)
    return {
        Default = false,

        Set = function(p109) -- Line: 99, Name: Set
            -- upvalues: u107 (ref), u108 (copy)
            if p109 then
                u107(u108);
            end;
        end
    };
end;

function v93.Sit(u110) -- Line: 416
    return {
        Set = function(p111) -- Line: 418, Name: Set
            -- upvalues: u110 (copy)
            u110.Sit = p111;
        end
    };
end;

function v93.TakeDamage(u112) -- Line: 424
    return {
        Set = function(p113) -- Line: 426, Name: Set
            -- upvalues: u112 (copy)
            u112:TakeDamage(p113);
        end
    };
end;

local function u115(p114) -- Line: 432
    p114:UnequipTools();
end;

function v93.UnequipTools(u116) -- Line: 95
    -- upvalues: u115 (copy)
    return {
        Default = false,

        Set = function(p117) -- Line: 99, Name: Set
            -- upvalues: u115 (ref), u116 (copy)
            if p117 then
                u115(u116);
            end;
        end
    };
end;

u1.Humanoid = v93;
local v118 = {};

local function u120(p119) -- Line: 442
    p119:Clear();
end;

function v118.Clear(u121) -- Line: 95
    -- upvalues: u120 (copy)
    return {
        Default = false,

        Set = function(p122) -- Line: 99, Name: Set
            -- upvalues: u120 (ref), u121 (copy)
            if p122 then
                u120(u121);
            end;
        end
    };
end;

function v118.Emit(u123) -- Line: 446
    local v124 = u123:GetAttribute("EmitCount");

    return {
        Default = type(v124) ~= "number" and 0 or v124,

        Set = function(p125) -- Line: 456, Name: Set
            -- upvalues: u123 (copy)
            if p125 > 0 then
                u123:Emit(p125);
            end;
        end
    };
end;

u1.ParticleEmitter = v118;
local v126 = {};

local function u129(p127) -- Line: 470
    local v128 = p127:Clone();
    v128.Parent = p127.Parent;
    v128.PlayOnRemove = true;
    v128:Destroy();
end;

function v126.PlayOnce(u130) -- Line: 95
    -- upvalues: u129 (copy)
    return {
        Default = false,

        Set = function(p131) -- Line: 99, Name: Set
            -- upvalues: u129 (ref), u130 (copy)
            if p131 then
                u129(u130);
            end;
        end
    };
end;

function v126.SetTime(u132) -- Line: 477
    return {
        Default = 0,

        Set = function(p133) -- Line: 481, Name: Set
            -- upvalues: u132 (copy)
            u132.TimePosition = p133;
        end
    };
end;

local function u135(p134) -- Line: 487
    p134:Play();
end;

function v126.Play(u136) -- Line: 95
    -- upvalues: u135 (copy)
    return {
        Default = false,

        Set = function(p137) -- Line: 99, Name: Set
            -- upvalues: u135 (ref), u136 (copy)
            if p137 then
                u135(u136);
            end;
        end
    };
end;

local function u139(p138) -- Line: 491
    p138:Resume();
end;

function v126.Resume(u140) -- Line: 95
    -- upvalues: u139 (copy)
    return {
        Default = false,

        Set = function(p141) -- Line: 99, Name: Set
            -- upvalues: u139 (ref), u140 (copy)
            if p141 then
                u139(u140);
            end;
        end
    };
end;

local function u143(p142) -- Line: 495
    p142:Pause();
end;

function v126.Pause(u144) -- Line: 95
    -- upvalues: u143 (copy)
    return {
        Default = false,

        Set = function(p145) -- Line: 99, Name: Set
            -- upvalues: u143 (ref), u144 (copy)
            if p145 then
                u143(u144);
            end;
        end
    };
end;

local function u147(p146) -- Line: 499
    p146:Stop();
end;

function v126.Stop(u148) -- Line: 95
    -- upvalues: u147 (copy)
    return {
        Default = false,

        Set = function(p149) -- Line: 99, Name: Set
            -- upvalues: u147 (ref), u148 (copy)
            if p149 then
                u147(u148);
            end;
        end
    };
end;

u1.Sound = v126;
local u150 = {};
local u151 = {};
local u152 = {};
local u158 = {
    __index = function(p153, p154) -- Line: 523, Name: __index
        -- upvalues: u151 (copy), u1 (copy)
        local _target = p153._target;
        local ClassName = _target.ClassName;
        local v155 = u151[ClassName];

        if v155 == nil then
            v155 = {};

            for i, v in u1 do
                if _target:IsA(i) then
                    for i2, v2 in v do
                        v155[i2] = v2;
                    end;
                end;
            end;

            u151[ClassName] = v155;
        end;

        local v156 = v155[p154];
        local v157;

        if v156 then
            v157 = v156(_target, p153._work);
            rawset(p153, p154, v157);
        else
            v157 = nil;
        end;

        return v157;
    end
};

return {
    Get = function(p159, u160, p161) -- Line: 561, Name: get
        -- upvalues: u152 (copy), u158 (copy)
        local u162 = u152[u160];

        if not u162 then
            u162 = setmetatable({
                _target = u160,
                _work = p159
            }, u158);
            u160.Destroying:Connect(function() -- Line: 571
                -- upvalues: u152 (ref), u160 (copy), u162 (ref)
                if u152[u160] == u162 then
                    u152[u160] = nil;
                end;
            end);
            u152[u160] = assert(u162);
        end;

        return u162[p161];
    end,

    Static = function(p163, p164) -- Line: 585, Name: static
        -- upvalues: u150 (copy), u39 (copy)
        local ClassName = p163.ClassName;

        if not u150[ClassName] then
            local v165 = {};

            for i, v in pairs(u39) do
                if p163:IsA(i) then
                    for i2, v2 in v do
                        v165[i2] = v2;
                    end;
                end;
            end;

            u150[ClassName] = v165;
        end;

        return u150[ClassName][p164] == true;
    end,

    Index = u1
};