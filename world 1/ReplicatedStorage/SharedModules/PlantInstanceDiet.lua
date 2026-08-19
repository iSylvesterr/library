-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local v1 = {};
local u2 = { "MushroomCap", "MoonBloom", "BriarRose", "Honeysuckle" };
local u3 = {
    Cactus = true,
    ["Maple Cactus"] = true
};
local u4 = {
    Cactus = true,
    ["Maple Cactus"] = true
};

local function hasTouchMechanic(p5) -- Line: 52
    -- upvalues: u2 (copy), CollectionService (copy)
    if p5:FindFirstChildOfClass("TouchTransmitter") then
        return true;
    end;

    if p5:GetAttribute("NoCanCollide") ~= nil then
        return true;
    end;

    for _, v in u2 do
        if CollectionService:HasTag(p5, v) then
            return true;
        end;
    end;

    return false;
end;

local function maxExtent(p6) -- Line: 67
    local Size = p6.Size;

    return math.max(Size.X, Size.Y, Size.Z);
end;

function v1.Apply(p7, p8) -- Line: 74
    -- upvalues: u3 (copy), u4 (copy), hasTouchMechanic (copy)
    local v9;

    if p8 then
        v9 = u3[p8];
    else
        v9 = p8;
    end;

    local v10 = not v9;

    if p8 then
        p8 = u4[p8];
    end;

    local u11 = {};
    local v12 = not p8;
    local u13 = {};

    for _, descendant in p7:GetDescendants() do
        if descendant:IsA("BasePart") then
            local Size = descendant.Size;
            local v14 = math.max(Size.X, Size.Y, Size.Z) < 2;

            if v14 then
                descendant.CastShadow = false;
            end;

            if v10 and (descendant.CanTouch and not hasTouchMechanic(descendant)) then
                descendant.CanTouch = false;
            end;

            if v12 and (descendant.Transparency >= 1 and (not descendant.CanCollide and descendant.CanQuery)) then
                descendant.CanQuery = false;
                table.insert(u13, descendant);

                if not v14 and descendant.CastShadow then
                    descendant.CastShadow = false;
                    u11[descendant] = true;
                end;
            end;
        end;
    end;

    if #u13 == 0 then
        return;
    end;

    local u15 = nil;
    local u16 = false;

    local function sweep() -- Line: 118
        -- upvalues: u13 (copy), u11 (copy), u15 (ref)
        local v17 = #u13;
        local v18 = 1;

        while v18 <= v17 do
            local v19 = u13[v18];

            if v19.Parent then
                if v19.Transparency < 1 then
                    v19.CanQuery = true;

                    if u11[v19] then
                        v19.CastShadow = true;
                        u11[v19] = nil;
                    end;

                    u13[v18] = u13[v17];
                    u13[v17] = nil;
                    v17 = v17 - 1;
                else
                    v18 = v18 + 1;
                end;
            else
                u13[v18] = u13[v17];
                u13[v17] = nil;
                u11[v19] = nil;
                v17 = v17 - 1;
            end;
        end;

        if v17 == 0 and u15 then
            u15:Disconnect();
        end;
    end;

    local function queueSweep() -- Line: 146
        -- upvalues: u16 (ref), sweep (copy)
        if u16 then
            return;
        end;

        u16 = true;
        task.defer(function() -- Line: 149
            -- upvalues: u16 (ref), sweep (ref)
            u16 = false;
            sweep();
        end);
    end;

    u15 = p7:GetAttributeChangedSignal("Age"):Connect(queueSweep);
    p7.Destroying:Once(function() -- Line: 156
        -- upvalues: u15 (ref)
        if u15 then
            u15:Disconnect();
        end;
    end);
    sweep();
end;

return v1;