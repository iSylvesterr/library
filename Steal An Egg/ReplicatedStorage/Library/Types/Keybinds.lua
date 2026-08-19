-- Decompiled with Potassium's decompiler.

local u1 = {
    MAXIMUM_CONTROL_KEYS = 2,
    MAXIMUM_STANDARD_KEYS = 1
};
u1.MAXIMUM_TOTAL_KEYS = u1.MAXIMUM_CONTROL_KEYS + u1.MAXIMUM_STANDARD_KEYS;
u1.MAXIMUM_KEYBINDS = 25;
u1.KEYBIND_NONE = -1;
u1.ControlKeys = {
    [Enum.KeyCode.LeftShift] = true,
    [Enum.KeyCode.RightShift] = true,
    [Enum.KeyCode.LeftControl] = true,
    [Enum.KeyCode.RightControl] = true,
    [Enum.KeyCode.LeftAlt] = true,
    [Enum.KeyCode.RightAlt] = true
};
u1.StandardKeys = {
    [Enum.KeyCode.Zero] = true,
    [Enum.KeyCode.One] = true,
    [Enum.KeyCode.Two] = true,
    [Enum.KeyCode.Three] = true,
    [Enum.KeyCode.Four] = true,
    [Enum.KeyCode.Five] = true,
    [Enum.KeyCode.Six] = true,
    [Enum.KeyCode.Seven] = true,
    [Enum.KeyCode.Eight] = true,
    [Enum.KeyCode.Nine] = true,
    [Enum.KeyCode.B] = true,
    [Enum.KeyCode.C] = true,
    [Enum.KeyCode.G] = true,
    [Enum.KeyCode.H] = true,
    [Enum.KeyCode.J] = true,
    [Enum.KeyCode.K] = true,
    [Enum.KeyCode.L] = true,
    [Enum.KeyCode.M] = true,
    [Enum.KeyCode.N] = true,
    [Enum.KeyCode.P] = true,
    [Enum.KeyCode.R] = true,
    [Enum.KeyCode.T] = true,
    [Enum.KeyCode.U] = true,
    [Enum.KeyCode.V] = true,
    [Enum.KeyCode.X] = true,
    [Enum.KeyCode.Y] = true,
    [Enum.KeyCode.Z] = true
};
u1.AllKeys = {};

for i, v in pairs(u1.ControlKeys) do
    u1.AllKeys[i] = v;
end;

for i, v in pairs(u1.StandardKeys) do
    u1.AllKeys[i] = v;
end;

u1.NameOverrides = {
    [Enum.KeyCode.LeftShift] = "Shift",
    [Enum.KeyCode.RightShift] = "Shift",
    [Enum.KeyCode.LeftControl] = "Ctrl",
    [Enum.KeyCode.RightControl] = "Ctrl",
    [Enum.KeyCode.LeftAlt] = "Alt",
    [Enum.KeyCode.RightAlt] = "Alt",
    [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7",
    [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9"
};
u1.SupportedItems = {};
u1.SupportedItemsMap = {};

for _, v in ipairs(u1.SupportedItems) do
    local Item = v.Item;
    local Name = Item.Class.Name;

    if not u1.SupportedItemsMap[Name] then
        u1.SupportedItemsMap[Name] = {};
    end;

    u1.SupportedItemsMap[Name][Item:StackKey()] = true;
end;

function u1.GetKeysAsEnum(p2) -- Line: 86
    local v3 = {};

    for _, v in ipairs(p2.Keys) do
        table.insert(v3, Enum.KeyCode[v]);
    end;

    return v3;
end;

function u1.IsItemSupported(p4) -- Line: 94
    -- upvalues: u1 (copy)
    local Name = p4.Class.Name;

    if u1.SupportedItemsMap[Name] then
        return u1.SupportedItemsMap[Name][p4:StackKey()] == true;
    end;

    return false;
end;

function u1.IsKeySupported(p5) -- Line: 103
    -- upvalues: u1 (copy)
    return u1.AllKeys[p5] ~= nil;
end;

function u1.MakeNameFromKeys(p6) -- Line: 107
    -- upvalues: u1 (copy)
    local v7 = table.clone(p6);
    table.sort(v7, function(p8, p9) -- Line: 109
        -- upvalues: u1 (ref)
        local v10 = u1.ControlKeys[p8] and 1 or 0;
        local v11 = u1.ControlKeys[p9] and 1 or 0;

        if v10 == v11 then
            return p8.Name < p9.Name;
        end;

        return v11 < v10;
    end);
    local v12 = "";
    local v13 = #v7;

    if v13 == 0 then
        return "<UNBOUND>";
    end;

    for i = 1, v13 do
        local v14 = v7[i];
        v12 = v12 .. (u1.NameOverrides[v14] or v14.Name);

        if i < v13 then
            v12 = v12 .. "+";
        end;
    end;

    return v12;
end;

return u1;