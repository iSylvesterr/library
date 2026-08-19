-- Decompiled with Potassium's decompiler.

local Library = game:GetService("ReplicatedStorage").Library;
local t = require(Library.Modules.Packages.t);
local InstanceCheck = require(Library.Functions.InstanceCheck);
local CoreProfileManager = require(Library.Modules.CoreProfileManager);
local u1 = t.tuple(t.table, t.optional(t.table));

local function GetIndexMethod(p2, p3, p4, p5) -- Line: 29
    -- upvalues: CoreProfileManager (copy), InstanceCheck (copy)
    local _profileManager = p2._profileManager;

    if _profileManager and CoreProfileManager.is(_profileManager) then
        return _profileManager:Get(p4);
    end;

    if InstanceCheck(p4, "Player") then
        local UserId = p4.UserId;

        if p5.GetPlayerInstance and p4 then
            UserId = p4;
        elseif p5.StringUserId then
            UserId = tostring(UserId) or UserId;
        end;

        if UserId then
            UserId = p3[UserId];
        end;

        return UserId;
    end;

    if typeof(p4) == "number" or typeof(p4) == "string" then
        return p3[p4];
    end;
end;

return function(u6, u7) -- Line: 48
    -- upvalues: u1 (copy), GetIndexMethod (copy)
    if u1(u6, u7) then
        return function(p8, p9, ...) -- Line: 53
            -- upvalues: u7 (copy), GetIndexMethod (ref), u6 (copy)
            local v10 = u7.AutoDestroyIfNoIndex and not p9 and "Destroy" or p9;

            if typeof(v10) ~= "string" then
                return;
            end;

            local v11 = GetIndexMethod(u6, u7.ProfileContainer, p8, u7);

            if typeof(v11) == "table" then
                return v11[v10](v11, ...);
            end;
        end;
    end;
end;