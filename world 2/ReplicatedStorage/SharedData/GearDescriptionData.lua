-- Decompiled with Potassium's decompiler.

local u1 = {
    Data = {
        ["Legendary Pet Teleporter"] = "Teleport to a server with a Legendary pet!",
        ["Mythic Pet Teleporter"] = "Teleport to a server with a Mythic pet",
        ["Super Pet Teleporter"] = "Teleport to a server with a SUPER pet"
    }
};

function u1.Get(p2) -- Line: 9
    -- upvalues: u1 (copy)
    return u1.Data[p2];
end;

return u1;