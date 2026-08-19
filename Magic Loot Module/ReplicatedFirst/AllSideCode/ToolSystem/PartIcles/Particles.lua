-- Decompiled with Potassium's decompiler.

local Range = require(script.Parent.Range);
local u1 = {};

local function parseDuration(p2) -- Line: 9
    -- upvalues: Range (copy)
    if p2 == nil then
        return nil;
    end;

    if typeof(p2) == "number" then
        return p2;
    end;

    local v3 = {};

    for i in tostring(p2):gmatch("[^,]+") do
        local v4 = tonumber(i:match("^%s*(.-)%s*$"));

        if v4 then
            table.insert(v3, v4);
        end;
    end;

    if #v3 == 0 then
        return nil;
    end;

    if #v3 == 1 then
        return v3[1];
    end;

    local v5 = math.min(v3[1], v3[2]);
    local v6 = math.max(v3[1], v3[2]);

    return Range.RandomValueFromRange(NumberRange.new(v5, v6));
end;

u1.parseDuration = parseDuration;

local function _hasTransformedAncestor(p7, p8) -- Line: 23
    local Parent = p7.Parent;

    while Parent and Parent ~= p8 do
        if Parent:GetAttribute("Transformed") then
            return true;
        end;

        Parent = Parent.Parent;
    end;

    return false;
end;

local function _alive(p9) -- Line: 33
    return not p9 or p9();
end;

local function _bumpCancelGen(u10) -- Line: 47
    local u11 = (u10:GetAttribute("_PartIcleNativeEmitGen") or 0) + 1;
    pcall(function() -- Line: 49
        -- upvalues: u10 (copy), u11 (copy)
        u10:SetAttribute("_PartIcleNativeEmitGen", u11);
    end);

    return u11;
end;

local function _readDurationGen(p12) -- Line: 56
    return p12:GetAttribute("_PartIcleNativeDurationGen") or 0;
end;

local function _bumpDurationGen(u13) -- Line: 59
    local u14 = (u13:GetAttribute("_PartIcleNativeDurationGen") or 0) + 1;
    pcall(function() -- Line: 61
        -- upvalues: u13 (copy), u14 (copy)
        u13:SetAttribute("_PartIcleNativeDurationGen", u14);
    end);

    return u14;
end;

local function _durationGenStillCurrent(p15, p16) -- Line: 64
    local v17;

    if p15.Parent == nil then
        v17 = false;
    else
        v17 = (p15:GetAttribute("_PartIcleNativeDurationGen") or 0) == p16;
    end;

    return v17;
end;

function u1.SetEnabledForDuration(u18, p19) -- Line: 70
    local u20 = (u18:GetAttribute("_PartIcleNativeDurationGen") or 0) + 1;
    pcall(function() -- Line: 61
        -- upvalues: u18 (copy), u20 (copy)
        u18:SetAttribute("_PartIcleNativeDurationGen", u20);
    end);
    u18.Enabled = true;
    task.delay(p19, function() -- Line: 73
        -- upvalues: u18 (copy), u20 (copy)
        local v21 = u18;
        local v22 = u20;
        local v23;

        if v21.Parent == nil then
            v23 = false;
        else
            v23 = (v21:GetAttribute("_PartIcleNativeDurationGen") or 0) == v22;
        end;

        if v23 then
            u18.Enabled = false;
        end;
    end);
end;

function u1.ReadNativeGen(p24) -- Line: 44
    return p24:GetAttribute("_PartIcleNativeEmitGen") or 0;
end;

function u1.IsNativeGenCurrent(p25, p26) -- Line: 52
    local v27;

    if p25.Parent == nil then
        v27 = false;
    else
        v27 = (p25:GetAttribute("_PartIcleNativeEmitGen") or 0) == p26;
    end;

    return v27;
end;

function u1.CancelNative(u28) -- Line: 86
    local u29 = (u28:GetAttribute("_PartIcleNativeEmitGen") or 0) + 1;
    pcall(function() -- Line: 49
        -- upvalues: u28 (copy), u29 (copy)
        u28:SetAttribute("_PartIcleNativeEmitGen", u29);
    end);
    local u30 = (u28:GetAttribute("_PartIcleNativeDurationGen") or 0) + 1;
    pcall(function() -- Line: 61
        -- upvalues: u28 (copy), u30 (copy)
        u28:SetAttribute("_PartIcleNativeDurationGen", u30);
    end);
    pcall(function() -- Line: 89
        -- upvalues: u28 (copy)
        u28.Enabled = false;
    end);
end;

function u1.EnableEmit(p31, u32) -- Line: 94
    -- upvalues: _hasTransformedAncestor (copy), parseDuration (copy)
    for _, descendant in p31:GetDescendants() do
        if not _hasTransformedAncestor(descendant, p31) then
            local u33, u34, u35, v36, u37, v38;

            if descendant:IsA("ParticleEmitter") then
                local u39 = descendant:GetAttribute("EmitCount") or 1;
                local v40 = descendant:GetAttribute("EmitDelay") or 0;
                local u41 = descendant:GetAttribute("EmitDuration") or 0;

                if u39 > 0 or u41 > 0 then
                    local u42 = descendant:GetAttribute("_PartIcleNativeEmitGen") or 0;

                    local function doEmit() -- Line: 103
                        -- upvalues: u32 (copy), descendant (copy), u42 (copy), u39 (copy), u41 (copy)
                        local v43 = u32;

                        if not v43 or v43() then
                            local v44 = descendant;
                            local v45 = u42;
                            local v46;

                            if v44.Parent == nil then
                                v46 = false;
                            else
                                v46 = (v44:GetAttribute("_PartIcleNativeEmitGen") or 0) == v45;
                            end;

                            if v46 then
                                if u39 > 0 then
                                    descendant:Emit(u39);
                                end;

                                if u41 > 0 then
                                    local u47 = descendant;
                                    local u48 = (u47:GetAttribute("_PartIcleNativeDurationGen") or 0) + 1;
                                    pcall(function() -- Line: 61
                                        -- upvalues: u47 (copy), u48 (copy)
                                        u47:SetAttribute("_PartIcleNativeDurationGen", u48);
                                    end);
                                    descendant.Enabled = true;
                                    task.delay(u41, function() -- Line: 111
                                        -- upvalues: descendant (ref), u48 (copy)
                                        local v49 = descendant;
                                        local v50 = u48;
                                        local v51;

                                        if v49.Parent == nil then
                                            v51 = false;
                                        else
                                            v51 = (v49:GetAttribute("_PartIcleNativeDurationGen") or 0) == v50;
                                        end;

                                        if v51 then
                                            descendant.Enabled = false;
                                        end;
                                    end);
                                end;
                            end;
                        end;
                    end;

                    if v40 > 0 then
                        task.delay(v40, doEmit);
                    else
                        doEmit();
                    end;

                    if descendant:IsA("Trail") and not descendant:GetAttribute("Transformed") then
                        u33 = parseDuration(descendant:GetAttribute("EmitDuration"));

                        if u33 and u33 > 0 then
                            u34 = descendant:GetAttribute("_PartIcleNativeEmitGen") or 0;
                            task.delay(descendant:GetAttribute("EmitDelay") or 0.001, function() -- Line: 126
                                -- upvalues: u32 (copy), descendant (copy), u34 (copy), u33 (copy)
                                local v52 = u32;

                                if not v52 or v52() then
                                    local v53 = descendant;
                                    local v54 = u34;
                                    local v55;

                                    if v53.Parent == nil then
                                        v55 = false;
                                    else
                                        v55 = (v53:GetAttribute("_PartIcleNativeEmitGen") or 0) == v54;
                                    end;

                                    if v55 then
                                        local u56 = descendant;
                                        local u57 = (u56:GetAttribute("_PartIcleNativeDurationGen") or 0) + 1;
                                        pcall(function() -- Line: 61
                                            -- upvalues: u56 (copy), u57 (copy)
                                            u56:SetAttribute("_PartIcleNativeDurationGen", u57);
                                        end);
                                        descendant.Enabled = true;
                                        task.delay(u33, function() -- Line: 130
                                            -- upvalues: descendant (ref), u57 (copy)
                                            local v58 = descendant;
                                            local v59 = u57;
                                            local v60;

                                            if v58.Parent == nil then
                                                v60 = false;
                                            else
                                                v60 = (v58:GetAttribute("_PartIcleNativeDurationGen") or 0) == v59;
                                            end;

                                            if v60 then
                                                descendant.Enabled = false;
                                            end;
                                        end);
                                    end;
                                end;
                            end);
                        end;
                    end;

                    if descendant:IsA("Beam") and not descendant:GetAttribute("Transformed") then
                        u35 = tonumber(descendant:GetAttribute("EmitDuration")) or 0;
                        v36 = tonumber(descendant:GetAttribute("EmitDelay")) or 0;

                        if u35 > 0 then
                            u37 = descendant:GetAttribute("_PartIcleNativeEmitGen") or 0;

                            v38 = function() -- Line: 144, Name: doEmit
                                -- upvalues: u32 (copy), descendant (copy), u37 (copy), u35 (copy)
                                local v61 = u32;

                                if not v61 or v61() then
                                    local v62 = descendant;
                                    local v63 = u37;
                                    local v64;

                                    if v62.Parent == nil then
                                        v64 = false;
                                    else
                                        v64 = (v62:GetAttribute("_PartIcleNativeEmitGen") or 0) == v63;
                                    end;

                                    if v64 then
                                        local u65 = descendant;
                                        local u66 = (u65:GetAttribute("_PartIcleNativeDurationGen") or 0) + 1;
                                        pcall(function() -- Line: 61
                                            -- upvalues: u65 (copy), u66 (copy)
                                            u65:SetAttribute("_PartIcleNativeDurationGen", u66);
                                        end);
                                        descendant.Enabled = true;
                                        task.delay(u35, function() -- Line: 148
                                            -- upvalues: descendant (ref), u66 (copy)
                                            local v67 = descendant;
                                            local v68 = u66;
                                            local v69;

                                            if v67.Parent == nil then
                                                v69 = false;
                                            else
                                                v69 = (v67:GetAttribute("_PartIcleNativeDurationGen") or 0) == v68;
                                            end;

                                            if v69 then
                                                descendant.Enabled = false;
                                            end;
                                        end);
                                    end;
                                end;
                            end;

                            if v36 > 0 then
                                task.delay(v36, v38);
                            else
                                v38();
                            end;
                        end;
                    end;
                end;
            else
                if descendant:IsA("Trail") and not descendant:GetAttribute("Transformed") then
                    u33 = parseDuration(descendant:GetAttribute("EmitDuration"));

                    if u33 and u33 > 0 then
                        u34 = descendant:GetAttribute("_PartIcleNativeEmitGen") or 0;
                        task.delay(descendant:GetAttribute("EmitDelay") or 0.001, function() -- Line: 126
                            -- upvalues: u32 (copy), descendant (copy), u34 (copy), u33 (copy)
                            local v52 = u32;

                            if not v52 or v52() then
                                local v53 = descendant;
                                local v54 = u34;
                                local v55;

                                if v53.Parent == nil then
                                    v55 = false;
                                else
                                    v55 = (v53:GetAttribute("_PartIcleNativeEmitGen") or 0) == v54;
                                end;

                                if v55 then
                                    local u56 = descendant;
                                    local u57 = (u56:GetAttribute("_PartIcleNativeDurationGen") or 0) + 1;
                                    pcall(function() -- Line: 61
                                        -- upvalues: u56 (copy), u57 (copy)
                                        u56:SetAttribute("_PartIcleNativeDurationGen", u57);
                                    end);
                                    descendant.Enabled = true;
                                    task.delay(u33, function() -- Line: 130
                                        -- upvalues: descendant (ref), u57 (copy)
                                        local v58 = descendant;
                                        local v59 = u57;
                                        local v60;

                                        if v58.Parent == nil then
                                            v60 = false;
                                        else
                                            v60 = (v58:GetAttribute("_PartIcleNativeDurationGen") or 0) == v59;
                                        end;

                                        if v60 then
                                            descendant.Enabled = false;
                                        end;
                                    end);
                                end;
                            end;
                        end);
                    end;
                end;

                if descendant:IsA("Beam") and not descendant:GetAttribute("Transformed") then
                    u35 = tonumber(descendant:GetAttribute("EmitDuration")) or 0;
                    v36 = tonumber(descendant:GetAttribute("EmitDelay")) or 0;

                    if u35 > 0 then
                        u37 = descendant:GetAttribute("_PartIcleNativeEmitGen") or 0;

                        v38 = function() -- Line: 144, Name: doEmit
                            -- upvalues: u32 (copy), descendant (copy), u37 (copy), u35 (copy)
                            local v61 = u32;

                            if not v61 or v61() then
                                local v62 = descendant;
                                local v63 = u37;
                                local v64;

                                if v62.Parent == nil then
                                    v64 = false;
                                else
                                    v64 = (v62:GetAttribute("_PartIcleNativeEmitGen") or 0) == v63;
                                end;

                                if v64 then
                                    local u65 = descendant;
                                    local u66 = (u65:GetAttribute("_PartIcleNativeDurationGen") or 0) + 1;
                                    pcall(function() -- Line: 61
                                        -- upvalues: u65 (copy), u66 (copy)
                                        u65:SetAttribute("_PartIcleNativeDurationGen", u66);
                                    end);
                                    descendant.Enabled = true;
                                    task.delay(u35, function() -- Line: 148
                                        -- upvalues: descendant (ref), u66 (copy)
                                        local v67 = descendant;
                                        local v68 = u66;
                                        local v69;

                                        if v67.Parent == nil then
                                            v69 = false;
                                        else
                                            v69 = (v67:GetAttribute("_PartIcleNativeDurationGen") or 0) == v68;
                                        end;

                                        if v69 then
                                            descendant.Enabled = false;
                                        end;
                                    end);
                                end;
                            end;
                        end;

                        if v36 > 0 then
                            task.delay(v36, v38);
                        else
                            v38();
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function u1.EnableEmitSingle(u70, u71) -- Line: 158
    -- upvalues: parseDuration (copy)
    if u70:IsA("Trail") then
        local u72 = parseDuration(u70:GetAttribute("EmitDuration"));

        if u72 and u72 > 0 then
            local u73 = u70:GetAttribute("_PartIcleNativeEmitGen") or 0;
            local v74 = u70:GetAttribute("EmitDelay") or 0;

            local function doEnable() -- Line: 164
                -- upvalues: u71 (copy), u70 (copy), u73 (copy), u72 (copy)
                local v75 = u71;

                if not v75 or v75() then
                    local v76 = u70;
                    local v77 = u73;
                    local v78;

                    if v76.Parent == nil then
                        v78 = false;
                    else
                        v78 = (v76:GetAttribute("_PartIcleNativeEmitGen") or 0) == v77;
                    end;

                    if v78 then
                        local u79 = u70;
                        local u80 = (u79:GetAttribute("_PartIcleNativeDurationGen") or 0) + 1;
                        pcall(function() -- Line: 61
                            -- upvalues: u79 (copy), u80 (copy)
                            u79:SetAttribute("_PartIcleNativeDurationGen", u80);
                        end);
                        u70.Enabled = true;
                        task.delay(u72, function() -- Line: 168
                            -- upvalues: u70 (ref), u80 (copy)
                            local v81 = u70;
                            local v82 = u80;
                            local v83;

                            if v81.Parent == nil then
                                v83 = false;
                            else
                                v83 = (v81:GetAttribute("_PartIcleNativeDurationGen") or 0) == v82;
                            end;

                            if v83 then
                                u70.Enabled = false;
                            end;
                        end);
                    end;
                end;
            end;

            if v74 > 0 then
                task.delay(v74, doEnable);
            else
                doEnable();
            end;
        end;
    end;

    if u70:IsA("ParticleEmitter") then
        local u84 = u70:GetAttribute("EmitCount") or 1;
        local v85 = u70:GetAttribute("EmitDelay") or 0;
        local u86 = u70:GetAttribute("EmitDuration") or 0;

        if u84 <= 0 and u86 <= 0 then
            return;
        end;

        local u87 = u70:GetAttribute("_PartIcleNativeEmitGen") or 0;

        local function v97() -- Line: 186
            -- upvalues: u71 (copy), u70 (copy), u87 (copy), u84 (copy), u86 (copy)
            local v88 = u71;

            if not v88 or v88() then
                local v89 = u70;
                local v90 = u87;
                local v91;

                if v89.Parent == nil then
                    v91 = false;
                else
                    v91 = (v89:GetAttribute("_PartIcleNativeEmitGen") or 0) == v90;
                end;

                if v91 then
                    if u84 > 0 then
                        u70:Emit(u84);
                    end;

                    if u86 > 0 then
                        local u92 = u70;
                        local u93 = (u92:GetAttribute("_PartIcleNativeDurationGen") or 0) + 1;
                        pcall(function() -- Line: 61
                            -- upvalues: u92 (copy), u93 (copy)
                            u92:SetAttribute("_PartIcleNativeDurationGen", u93);
                        end);
                        u70.Enabled = true;
                        task.delay(u86, function() -- Line: 192
                            -- upvalues: u70 (ref), u93 (copy)
                            local v94 = u70;
                            local v95 = u93;
                            local v96;

                            if v94.Parent == nil then
                                v96 = false;
                            else
                                v96 = (v94:GetAttribute("_PartIcleNativeDurationGen") or 0) == v95;
                            end;

                            if v96 then
                                u70.Enabled = false;
                            end;
                        end);
                    end;
                end;
            end;
        end;

        if v85 > 0 then
            task.delay(v85, v97);

            return;
        end;

        v97();
    end;
end;

function u1.EnableEmitChildrenAndRepeatForAttachments(p98, p99) -- Line: 201
    -- upvalues: u1 (copy)
    for _, child in p98:GetChildren() do
        u1.EnableEmitSingle(child, p99);

        if child:IsA("Attachment") then
            u1.EnableEmitChildrenAndRepeatForAttachments(child, p99);
        end;
    end;
end;

return u1;