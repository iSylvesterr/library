-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local FuncWrapper = require(ReplicatedStorage.Library.Modules.FuncWrapper);
local CallbackQueue = require(ReplicatedStorage.Library.Modules.CallbackQueue);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local u2 = {};
u2.__index = u2;
u2.__class = "WorkspaceRainbowParts";
local insert = table.insert;
local remove = table.remove;
local find = table.find;
local fromHSV = Color3.fromHSV;
local toHSV = Color3.toHSV;
local new = Vector3.new;
local u3 = typeof;
local min = math.min;
local clock = os.clock;

local function getTargetColor(p4) -- Line: 53
    if p4:IsA("BasePart") then
        return p4.Color;
    end;

    return p4.Color;
end;

local function setTargetColor(p5, p6) -- Line: 60
    if p5:IsA("BasePart") then
        p5.Color = p6;

        return;
    end;

    p5.Color = p6;
end;

function u2._build() -- Line: 72
    -- upvalues: u2 (copy), CallbackQueue (copy), FuncWrapper (copy), clock (copy)
    local v7 = setmetatable({}, u2);
    v7._activeParts = {};
    v7._currentHue = math.random();
    v7._streamCallbackQueue = CallbackQueue.new();
    v7._funcWrapper = FuncWrapper.CreateWrapper(v7);
    v7._startTime = clock();
    v7._progressTime = 0;
    v7._batchIndex = 1;
    v7:_init();

    return v7;
end;

function u2._preRender(p8, p9) -- Line: 91
    -- upvalues: min (copy), clock (copy), u3 (copy), toHSV (copy), new (copy), fromHSV (copy)
    local v10 = min(p9, 0.06666666666666667);
    p8._currentHue = (clock() - p8._startTime) * 0.5 % 1;
    p8._progressTime = min(p8._progressTime + v10, 0.25);

    if p8._progressTime < 0.05 then
        return;
    end;

    debug.profilebegin("WorkspaceRainbowParts :: PreRender");
    p8._progressTime = p8._progressTime - 0.05;
    local v11 = #p8._activeParts;

    if v11 > 0 then
        local _batchIndex = p8._batchIndex;
        local v12 = min(_batchIndex + 50 - 1, v11);

        for i = _batchIndex, v12 do
            local v13 = p8._activeParts[i];

            if v13 and v13.Parent then
                local v14 = v13:GetAttribute("OriginalColor");

                if u3(v14) ~= "Vector3" then
                    local v15;

                    if v13:IsA("BasePart") then
                        v15 = v13.Color;
                    else
                        v15 = v13.Color;
                    end;

                    local v16, v17, v18 = toHSV(v15);
                    v14 = new(v16, v17, v18);
                    v13:SetAttribute("OriginalColor", v14);
                end;

                assert(v14, "luau");
                local Y = v14.Y;
                local Z = v14.Z;

                if Y <= 0.05 then
                    Y = 1;

                    if Z >= 0.9725490196078431 then
                        Z = 1;
                    end;
                end;

                local v19 = fromHSV(p8._currentHue % 1, Y, Z);

                if v13:IsA("BasePart") then
                    v13.Color = v19;
                else
                    v13.Color = v19;
                end;
            end;
        end;

        p8._batchIndex = v12 + 1;

        if v11 < p8._batchIndex then
            p8._batchIndex = 1;
        end;
    end;

    debug.profileend();
end;

function u2.Remove(p20, p21) -- Line: 143
    -- upvalues: find (copy), u1 (copy), remove (copy), fromHSV (copy)
    local v22 = find(p20._activeParts, p21);

    if not v22 then
        u1:AtWarning():Log((`Rainbow target {p21:GetFullName()} not found in active targets.`));

        return;
    end;

    remove(p20._activeParts, v22);
    local v23 = p21:GetAttribute("OriginalColor");

    if v23 then
        local v24 = fromHSV(v23.X, v23.Y, v23.Z);

        if p21:IsA("BasePart") then
            p21.Color = v24;
        else
            p21.Color = v24;
        end;
    end;

    if p20._batchIndex > #p20._activeParts then
        p20._batchIndex = 1;
    end;
end;

function u2.Add(p25, p26) -- Line: 161
    -- upvalues: find (copy), u3 (copy), toHSV (copy), new (copy), insert (copy)
    if not find(p25._activeParts, p26) then
        if u3(p26:GetAttribute("OriginalColor")) ~= "Vector3" then
            local v27;

            if p26:IsA("BasePart") then
                v27 = p26.Color;
            else
                v27 = p26.Color;
            end;

            local v28, v29, v30 = toHSV(v27);
            p26:SetAttribute("OriginalColor", (new(v28, v29, v30)));
        end;

        insert(p25._activeParts, p26);
    end;
end;

function u2._init(u31) -- Line: 175
    -- upvalues: CollectionService (copy), ReplicatedStorage (copy), RunService (copy)
    local v32 = CollectionService;
    local u33 = ReplicatedStorage;
    v32:GetInstanceAddedSignal("RainbowPart"):Connect(function(u34) -- Line: 179
        -- upvalues: u33 (copy), u31 (copy)
        if u34:IsDescendantOf(u33) then
            return;
        end;

        local v35 = u34:IsA("BasePart") or u34:IsA("SurfaceAppearance");
        local v36 = `RainbowPart tag requires a BasePart or SurfaceAppearance, got {u34.ClassName}`;
        assert(v35, v36);
        u31._streamCallbackQueue:Add(function() -- Line: 189
            -- upvalues: u31 (ref), u34 (copy)
            u31:Add(u34);
        end);
    end);
    v32:GetInstanceRemovedSignal("RainbowPart"):Connect(function(u37) -- Line: 194
        -- upvalues: u31 (copy)
        local v38 = u37:IsA("BasePart") or u37:IsA("SurfaceAppearance");
        local v39 = `RainbowPart tag requires a BasePart or SurfaceAppearance, got {u37.ClassName}`;
        assert(v38, v39);
        u31._streamCallbackQueue:Add(function() -- Line: 200
            -- upvalues: u31 (ref), u37 (copy)
            u31:Remove(u37);
        end);
    end);

    for _, v in ipairs(v32:GetTagged("RainbowPart")) do
        if not v:IsDescendantOf(u33) then
            local v40 = v:IsA("BasePart") or v:IsA("SurfaceAppearance");
            local v41 = `RainbowPart tag requires a BasePart or SurfaceAppearance, got {v.ClassName}`;
            assert(v40, v41);
            u31:Add(v);
        end;
    end;

    RunService.PreRender:Connect(u31._funcWrapper(u31._preRender));
end;

u2._build();