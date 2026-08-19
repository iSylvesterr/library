-- Decompiled with Potassium's decompiler.

local ScaleNumberSequence = require(script.Parent.ScaleNumberSequence);

return function(u1, u2, u3) -- Line: 13
    -- upvalues: ScaleNumberSequence (copy)
    local u4 = {};
    local u5 = {};

    local function scaleObject(u6, p7, p8) -- Line: 21
        -- upvalues: u2 (copy), u3 (copy), u5 (copy), u4 (copy), u1 (copy), ScaleNumberSequence (ref), scaleObject (copy)
        if u2 and not u2(u6) then
            return;
        end;

        if not (u3 and u6:IsA("Model")) then
            if u6:IsA("BasePart") then
                local v9 = u6:FindFirstAncestorWhichIsA("Model");
                local v10;

                if v9 then
                    v10 = v9.PrimaryPart;
                else
                    v10 = nil;
                end;

                local v11 = v10 or (u6:FindFirstAncestorWhichIsA("BasePart") or v10 or u6.AssemblyRootPart) or u6;
                local Size = v11.Size;

                local function getInitialSize() -- Line: 54
                    -- upvalues: Size (copy)
                    return Size;
                end;

                local v12 = u4[v11];

                if not v12 then
                    v12 = {};
                    u4[v11] = v12;
                end;

                assert(v12, "Assertion failed: pivotCache should not be nil");
                local Size2 = v12.Size;

                if Size2 == nil then
                    v12.Size = Size;
                    Size2 = Size;
                end;

                assert(Size2 ~= nil, "Assertion failed: pivotInitialSize should have been initialized");
                local v13 = Size2 * p7;

                if p8 ~= nil then
                    local u14 = v11:GetPivot();
                    local v15 = u14 * CFrame.new(Size * p8) * CFrame.new(v13 * -p8);
                    local u16 = u6:GetPivot();
                    local v17;

                    if u1 then
                        v17 = u14:ToObjectSpace(u16);
                    else
                        local function getObjectPivot() -- Line: 83
                            -- upvalues: u14 (copy), u16 (copy)
                            return u14:ToObjectSpace(u16);
                        end;

                        local v18 = u4[u6];

                        if not v18 then
                            v18 = {};
                            u4[u6] = v18;
                        end;

                        assert(v18, "Assertion failed: objectCache should not be nil");
                        v17 = v18.ObjectCFrame;

                        if v17 == nil then
                            v17 = u14:ToObjectSpace(u16);
                            v18.ObjectCFrame = v17;
                        end;

                        assert(v17 ~= nil, "Assertion failed: cachedObjectPivot should have been set");
                    end;

                    u6:PivotTo(v15:ToWorldSpace(v17 - v17.Position + v17.Position * p7));
                end;

                local Size3 = u6.Size;

                local function getObjectInitialSize() -- Line: 111
                    -- upvalues: Size3 (copy)
                    return Size3;
                end;

                local v19 = u4[u6];

                if not v19 then
                    v19 = {};
                    u4[u6] = v19;
                end;

                assert(v19, "Assertion failed: objectCache for object should not be nil");
                local Size4 = v19.Size;

                if Size4 == nil then
                    v19.Size = Size3;
                else
                    Size3 = Size4;
                end;

                assert(Size3 ~= nil, "Assertion failed: cachedObjectSize should have been set");
                u6.Size = Size3 * p7;
            elseif u6:IsA("SpecialMesh") then
                local function getMeshScale() -- Line: 131
                    -- upvalues: u6 (copy)
                    return u6.Scale;
                end;

                local v20 = u4[u6];

                if not v20 then
                    v20 = {};
                    u4[u6] = v20;
                end;

                assert(v20, "Assertion failed: meshCache for SpecialMesh should not be nil");
                local Scale = v20.Scale;

                if Scale == nil then
                    Scale = u6.Scale;
                    v20.Scale = Scale;
                end;

                assert(Scale ~= nil, "Assertion failed: cachedMeshScale should have been set");
                u6.Scale = Scale * p7;

                local function getMeshOffset() -- Line: 148
                    -- upvalues: u6 (copy)
                    return u6.Offset;
                end;

                local v21 = u4[u6];

                if not v21 then
                    v21 = {};
                    u4[u6] = v21;
                end;

                assert(v21, "Assertion failed: meshCache2 for SpecialMesh should not be nil");
                local Offset = v21.Offset;

                if Offset == nil then
                    Offset = u6.Offset;
                    v21.Offset = Offset;
                end;

                assert(Offset ~= nil, "Assertion failed: cachedMeshOffset should have been set");
                u6.Offset = Offset * p7;
            elseif u6:IsA("ParticleEmitter") then
                local v22;

                if typeof(p7) == "Vector3" then
                    v22 = (p7.X + p7.Y + p7.Z) / 3 or p7;
                else
                    v22 = p7;
                end;

                local function getEmitterSize() -- Line: 169
                    -- upvalues: u6 (copy)
                    return u6.Size;
                end;

                local v23 = u4[u6];

                if not v23 then
                    v23 = {};
                    u4[u6] = v23;
                end;

                assert(v23, "Assertion failed: emitterCache for ParticleEmitter should not be nil");
                local Size = v23.Size;

                if Size == nil then
                    Size = u6.Size;
                    v23.Size = Size;
                end;

                assert(Size ~= nil, "Assertion failed: cachedEmitterSize should have been set");
                u6.Size = ScaleNumberSequence(Size, v22);

                local function getEmitterDrag() -- Line: 186
                    -- upvalues: u6 (copy)
                    return u6.Drag;
                end;

                local v24 = u4[u6];

                if not v24 then
                    v24 = {};
                    u4[u6] = v24;
                end;

                assert(v24, "Assertion failed: emitterCacheDrag for ParticleEmitter should not be nil");
                local Drag = v24.Drag;

                if Drag == nil then
                    Drag = u6.Drag;
                    v24.Drag = Drag;
                end;

                assert(Drag ~= nil, "Assertion failed: cachedEmitterDrag should have been set");
                u6.Drag = Drag * v22;

                local function getVelocityInheritance() -- Line: 203
                    -- upvalues: u6 (copy)
                    return u6.VelocityInheritance;
                end;

                local v25 = u4[u6];

                if not v25 then
                    v25 = {};
                    u4[u6] = v25;
                end;

                assert(v25, "Assertion failed: emitterCacheVelocity for ParticleEmitter should not be nil");
                local VelocityInheritance = v25.VelocityInheritance;

                if VelocityInheritance == nil then
                    VelocityInheritance = u6.VelocityInheritance;
                    v25.VelocityInheritance = VelocityInheritance;
                end;

                assert(VelocityInheritance ~= nil, "Assertion failed: cachedVelocityInheritance should have been set");
                u6.VelocityInheritance = VelocityInheritance * v22;

                local function getEmitterSpeed() -- Line: 226
                    -- upvalues: u6 (copy)
                    return u6.Speed;
                end;

                local v26 = u4[u6];

                if not v26 then
                    v26 = {};
                    u4[u6] = v26;
                end;

                assert(v26, "Assertion failed: emitterCacheSpeed for ParticleEmitter should not be nil");
                local Speed = v26.Speed;

                if Speed == nil then
                    Speed = u6.Speed;
                    v26.Speed = Speed;
                end;

                assert(Speed ~= nil, "Assertion failed: cachedEmitterSpeed should have been set");
                u6.Speed = NumberRange.new(Speed.Min * v22, Speed.Max * v22);

                local function getEmitterAcceleration() -- Line: 244
                    -- upvalues: u6 (copy)
                    return u6.Acceleration;
                end;

                local v27 = u4[u6];

                if not v27 then
                    v27 = {};
                    u4[u6] = v27;
                end;

                assert(v27, "Assertion failed: emitterCacheAcceleration for ParticleEmitter should not be nil");
                local Acceleration = v27.Acceleration;

                if Acceleration == nil then
                    Acceleration = u6.Acceleration;
                    v27.Acceleration = Acceleration;
                end;

                assert(Acceleration ~= nil, "Assertion failed: cachedEmitterAcceleration should have been set");
                u6.Acceleration = Acceleration * p7;

                local function getEmitterZOffset() -- Line: 267
                    -- upvalues: u6 (copy)
                    return u6.ZOffset;
                end;

                local v28 = u4[u6];

                if not v28 then
                    v28 = {};
                    u4[u6] = v28;
                end;

                assert(v28, "Assertion failed: emitterCacheZOffset for ParticleEmitter should not be nil");
                local ZOffset = v28.ZOffset;

                if ZOffset == nil then
                    ZOffset = u6.ZOffset;
                    v28.ZOffset = ZOffset;
                end;

                assert(ZOffset ~= nil, "Assertion failed: cachedEmitterZOffset should have been set");
                u6.ZOffset = ZOffset * v22;
            elseif u6:IsA("Attachment") then
                local function getAttachmentCFrame() -- Line: 287
                    -- upvalues: u6 (copy)
                    return u6.CFrame;
                end;

                local v29 = u4[u6];

                if not v29 then
                    v29 = {};
                    u4[u6] = v29;
                end;

                assert(v29, "Assertion failed: attachmentCache for Attachment should not be nil");
                local CFrame2 = v29.CFrame;

                if CFrame2 == nil then
                    CFrame2 = u6.CFrame;
                    v29.CFrame = CFrame2;
                end;

                assert(CFrame2 ~= nil, "Assertion failed: cachedAttachmentCFrame should have been set");
                u6.CFrame = CFrame2 - CFrame2.Position + CFrame2.Position * p7;
            end;

            for _, child in ipairs(u6:GetChildren()) do
                scaleObject(child, p7, p8);
            end;

            return;
        end;

        local v30 = math.max(0.001, p7);

        if u5[u6] then
            u6:ScaleTo(u5[u6] * v30);

            return;
        end;

        u5[u6] = v30;
        u6:ScaleTo(v30);
    end;

    return function(p31, p32, p33) -- Line: 313
        -- upvalues: scaleObject (copy)
        return scaleObject(p31, p32, p33);
    end;
end;