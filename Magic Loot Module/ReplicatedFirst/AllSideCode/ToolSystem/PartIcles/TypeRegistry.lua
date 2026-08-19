-- Decompiled with Potassium's decompiler.

local u1 = {
    CONFIG_NAME = "PartIcleProperties",
    Types = require(script.TypeData).Types
};

function u1.getTypeFor(p2) -- Line: 26
    -- upvalues: u1 (copy)
    for i, v in pairs(u1.Types) do
        if v.classCheck(p2) then
            return v, i;
        end;
    end;

    return nil, nil;
end;

function u1.getTypeName(p3) -- Line: 35
    -- upvalues: u1 (copy)
    local _, v4 = u1.getTypeFor(p3);

    return v4;
end;

function u1.getConfig(p5) -- Line: 40
    -- upvalues: u1 (copy)
    return p5:FindFirstChild(u1.CONFIG_NAME);
end;

function u1.getAttrName(p6, p7) -- Line: 45
    local v8 = p6.properties[p7];

    if v8 and v8.attrName then
        return v8.attrName;
    end;

    return p7;
end;

function u1.read(u9, u10) -- Line: 54
    -- upvalues: u1 (copy)
    local v11 = u1.getTypeFor(u9);

    if not v11 then
        return nil;
    end;

    local u12 = v11.properties[u10];

    if not u12 then
        return nil;
    end;

    if v11.directAccess then
        if u12.attribute then
            local v13 = u9:GetAttribute(u12.attrName or u10);

            if v13 == nil then
                return u12.default;
            end;

            return v13;
        end;

        local success, result = pcall(function() -- Line: 68
            -- upvalues: u9 (copy), u10 (copy)
            return u9[u10];
        end);

        if success and result ~= nil then
            return result;
        end;

        return u12.default;
    end;

    local v14 = u1.getConfig(u9);

    if not v14 then
        return nil;
    end;

    local u15 = v14:GetAttribute((u1.getAttrName(v11, u10)));

    if u15 == nil then
        return u12.default;
    end;

    if u12.type ~= "enum" or type(u15) ~= "string" then
        return u15;
    end;

    local success, result = pcall(function() -- Line: 83
        -- upvalues: u12 (copy), u15 (copy)
        return Enum[u12.enumType][u15];
    end);

    return success and result and result or u12.default;
end;

local function _bumpPoolGen(p16) -- Line: 93
    local RenderTemplate = p16:FindFirstChild("RenderTemplate");

    if not RenderTemplate then
        return;
    end;

    local u17 = RenderTemplate:GetAttribute("_PoolGen") or 0;
    pcall(function() -- Line: 97
        -- upvalues: RenderTemplate (copy), u17 (copy)
        RenderTemplate:SetAttribute("_PoolGen", u17 + 1);
    end);
end;

function u1.bumpPoolGen(p18) -- Line: 102
    if not p18 then
        return;
    end;

    local RenderTemplate = p18:FindFirstChild("RenderTemplate");

    if not RenderTemplate then
        return;
    end;

    local u19 = RenderTemplate:GetAttribute("_PoolGen") or 0;
    pcall(function() -- Line: 97
        -- upvalues: RenderTemplate (copy), u19 (copy)
        RenderTemplate:SetAttribute("_PoolGen", u19 + 1);
    end);
end;

local function _clampNonNegativeSeq(p20) -- Line: 108
    if typeof(p20) ~= "NumberSequence" then
        return p20;
    end;

    local Keypoints = p20.Keypoints;
    local v21 = false;

    for _, v in ipairs(Keypoints) do
        if v.Value < 0 or v.Envelope > v.Value then
            v21 = true;
            break;
        end;
    end;

    if not v21 then
        return p20;
    end;

    local v22 = {};

    for _, v in ipairs(Keypoints) do
        local v23 = math.max(0, v.Value);
        local v24 = math.min(v.Envelope, v23);
        local v25 = math.max(0, v24);
        table.insert(v22, NumberSequenceKeypoint.new(v.Time, v23, v25));
    end;

    return NumberSequence.new(v22);
end;

local function _isInvalidNumber(p26) -- Line: 129
    local v27;

    if type(p26) == "number" then
        v27 = (p26 ~= p26 or p26 == (1 / 0)) and true or p26 == (-1 / 0);
    else
        v27 = false;
    end;

    return v27;
end;

local function _isInvalidValue(p28) -- Line: 132
    if type(p28) == "number" then
        local v29;

        if type(p28) == "number" then
            v29 = (p28 ~= p28 or p28 == (1 / 0)) and true or p28 == (-1 / 0);
        else
            v29 = false;
        end;

        return v29;
    end;

    if typeof(p28) == "NumberRange" then
        local Min = p28.Min;
        local v30;

        if type(Min) == "number" then
            v30 = (Min ~= Min or Min == (1 / 0)) and true or Min == (-1 / 0);
        else
            v30 = false;
        end;

        if not v30 then
            local Max = p28.Max;

            if type(Max) == "number" then
                v30 = (Max ~= Max or Max == (1 / 0)) and true or Max == (-1 / 0);
            else
                v30 = false;
            end;
        end;

        return v30;
    end;

    if typeof(p28) ~= "NumberSequence" then
        return false;
    end;

    for _, v in ipairs(p28.Keypoints) do
        local Time = v.Time;
        local v31;

        if type(Time) == "number" then
            v31 = (Time ~= Time or Time == (1 / 0)) and true or Time == (-1 / 0);
        else
            v31 = false;
        end;

        if v31 then
            return true;
        end;

        local Value = v.Value;
        local v32;

        if type(Value) == "number" then
            v32 = (Value ~= Value or Value == (1 / 0)) and true or Value == (-1 / 0);
        else
            v32 = false;
        end;

        if v32 then
            return true;
        end;

        local Envelope = v.Envelope;
        local v33;

        if type(Envelope) == "number" then
            v33 = (Envelope ~= Envelope or Envelope == (1 / 0)) and true or Envelope == (-1 / 0);
        else
            v33 = false;
        end;

        if v33 then
            return true;
        end;

        if v.Time < 0 or v.Time > 1 then
            return true;
        end;
    end;

    return false;
end;

function u1.write(u34, u35, u36) -- Line: 147
    -- upvalues: _isInvalidValue (copy), u1 (copy), _clampNonNegativeSeq (copy)
    if _isInvalidValue(u36) then
        warn("[Part-Icles] TypeRegistry.write rejected invalid value for " .. tostring(u35));

        return;
    end;

    local v37 = u1.getTypeFor(u34);

    if not v37 then
        return;
    end;

    local v38 = v37.properties[u35];

    if not v38 then
        return;
    end;

    if v37.directAccess then
        if v38.nonNegative then
            u36 = _clampNonNegativeSeq(u36);
        end;

        if v38.attribute then
            u34:SetAttribute(v38.attrName or u35, u36);
        else
            pcall(function() -- Line: 165
                -- upvalues: u34 (copy), u35 (copy), u36 (ref)
                u34[u35] = u36;
            end);
        end;

        local RenderTemplate = u34:FindFirstChild("RenderTemplate");

        if RenderTemplate then
            local u39 = RenderTemplate:GetAttribute("_PoolGen") or 0;
            pcall(function() -- Line: 97
                -- upvalues: RenderTemplate (copy), u39 (copy)
                RenderTemplate:SetAttribute("_PoolGen", u39 + 1);
            end);
        end;

        return;
    end;

    local v40 = u1.getConfig(u34);

    if not v40 then
        return;
    end;

    local v41 = u1.getAttrName(v37, u35);

    if v38.type == "enum" then
        if typeof(u36) == "EnumItem" then
            v40:SetAttribute(v41, u36.Name);
        else
            v40:SetAttribute(v41, (tostring(u36)));
        end;
    else
        if v38.nonNegative and typeof(u36) == "NumberSequence" then
            local Keypoints = u36.Keypoints;
            local v42 = false;

            for _, v in ipairs(Keypoints) do
                if v.Value < 0 or v.Envelope > v.Value then
                    v42 = true;
                    break;
                end;
            end;

            if v42 then
                local v43 = {};

                for _, v in ipairs(Keypoints) do
                    local v44 = math.max(0, v.Value);
                    local v45 = math.min(v.Envelope, v44);
                    local v46 = math.max(0, v45);
                    table.insert(v43, NumberSequenceKeypoint.new(v.Time, v44, v46));
                end;

                u36 = NumberSequence.new(v43);
            end;
        end;

        v40:SetAttribute(v41, u36);
    end;

    local RenderTemplate = u34:FindFirstChild("RenderTemplate");

    if RenderTemplate then
        local u47 = RenderTemplate:GetAttribute("_PoolGen") or 0;
        pcall(function() -- Line: 97
            -- upvalues: RenderTemplate (copy), u47 (copy)
            RenderTemplate:SetAttribute("_PoolGen", u47 + 1);
        end);
    end;
end;

function u1.readAll(p48) -- Line: 206
    -- upvalues: u1 (copy)
    local v49 = u1.getTypeFor(p48);

    if not v49 then
        return nil;
    end;

    local v50 = u1.getConfig(p48);

    if not v50 then
        return nil;
    end;

    local v51 = {};

    for i, v in pairs(v49.properties) do
        local v52 = v50:GetAttribute((u1.getAttrName(v49, i)));

        if v52 == nil then
            v51[i] = v.default;
        elseif v.type == "enum" and type(v52) == "string" then
            v51[i] = Enum[v.enumType][v52];
        else
            v51[i] = v52;
        end;
    end;

    return v51;
end;

function u1.writeDefaults(p53, p54) -- Line: 228
    for i, v in pairs(p54.properties) do
        local v55 = v.attrName or i;
        local default = v.default;

        if v.type == "enum" then
            p53:SetAttribute(v55, default.Name);
        else
            p53:SetAttribute(v55, default);
        end;
    end;
end;

function u1.createConfig(p56, p57) -- Line: 241
    -- upvalues: u1 (copy)
    local Configuration = Instance.new("Configuration");
    Configuration.Name = u1.CONFIG_NAME;
    u1.writeDefaults(Configuration, p57);
    Configuration.Parent = p56;

    return Configuration;
end;

function u1.isGraph(p58) -- Line: 249
    return p58.type == "NumberSequence" and true or p58.type == "ColorSequence";
end;

function u1.isNonNegative(p59) -- Line: 253
    return p59.nonNegative == true;
end;

function u1.getPropDef(p60, p61) -- Line: 257
    -- upvalues: u1 (copy)
    local v62 = u1.Types[p60];

    if v62 then
        return v62.properties[p61];
    end;

    return nil;
end;

function u1.getDefault(p63, p64) -- Line: 264
    -- upvalues: u1 (copy)
    local v65 = u1.Types[p63];

    if not v65 then
        return nil;
    end;

    local v66 = v65.properties[p64];

    if v66 then
        return v66.default;
    end;

    return nil;
end;

return u1;