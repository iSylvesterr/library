-- Decompiled with Potassium's decompiler.

local u1 = 1;

local function Refresh() -- Line: 22
    -- upvalues: u1 (ref)
    local v2 = workspace:GetAttribute("PetSpeedMultiplier");
    u1 = (type(v2) ~= "number" or (v2 <= 0 or v2 ~= v2)) and 1 or v2;
end;

local v3 = workspace:GetAttribute("PetSpeedMultiplier");

if type(v3) == "number" and (v3 > 0 and v3 == v3) then
    u1 = v3;
else
    u1 = 1;
end;

workspace:GetAttributeChangedSignal("PetSpeedMultiplier"):Connect(Refresh);

return table.freeze({
    Get = function() -- Line: 33, Name: Get
        -- upvalues: u1 (ref)
        return u1;
    end,

    Set = function(p4) -- Line: 38, Name: Set
        if p4 == 1 then
            p4 = nil;
        end;

        workspace:SetAttribute("PetSpeedMultiplier", p4);
    end
});