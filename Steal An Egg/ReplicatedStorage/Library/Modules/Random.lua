-- Decompiled with Potassium's decompiler.

local u1 = {};

function u1.new(p2) -- Line: 5
    -- upvalues: u1 (copy)
    local u3 = nil;

    if p2 == nil then
        u3 = Random.new();
    elseif type(p2) == "number" then
        u3 = Random.new(p2);
    elseif typeof(p2) == "Random" then
        u3 = p2;
    else
        error("Unknown alternative seed type: " .. typeof(p2));
    end;

    return {
        new = u1.new,

        handle = function() -- Line: 18, Name: handle
            -- upvalues: u3 (ref)
            return u3;
        end,

        clone = function() -- Line: 21, Name: clone
            -- upvalues: u1 (ref), u3 (ref)
            return u1.new(u3:Clone());
        end,

        seed = function(p4) -- Line: 24, Name: seed
            -- upvalues: u3 (ref)
            u3 = Random.new(p4);
        end,

        number = function(p5, p6) -- Line: 27, Name: number
            -- upvalues: u3 (ref)
            return p5 and u3:NextNumber(p5, p6) or u3:NextNumber();
        end,

        boolean = function(p7) -- Line: 30, Name: boolean
            -- upvalues: u3 (ref)
            return u3:NextNumber() < (p7 or 0.5);
        end,

        integer = function(p8, p9) -- Line: 33, Name: integer
            -- upvalues: u3 (ref)
            return u3:NextInteger(p8, p9);
        end,

        normal = function(p10, p11) -- Line: 36, Name: normal
            -- upvalues: u3 (ref)
            local v12 = math.max(2.2250738585072014e-308, u3:NextNumber());
            local v13 = math.log(v12) * -2;
            local v14 = math.sqrt(v13) * (p11 or 1);
            local v15 = u3:NextNumber() * 6.283185307179586;
            local v16 = p10 or 0;

            return v14 * math.cos(v15) + v16, v14 * math.sin(v15) + v16;
        end,

        Vector3 = function(p17) -- Line: 45, Name: Vector3
            -- upvalues: u3 (ref)
            return u3:NextUnitVector() * (p17 or 1);
        end,

        Vector2 = function(p18) -- Line: 48, Name: Vector2
            -- upvalues: u3 (ref)
            local v19 = 6.283185307179586 * u3:NextNumber();

            return Vector2.new(math.cos(v19), (math.sin(v19))) * (p18 or 1);
        end,

        flatVector3 = function(p20) -- Line: 52, Name: flatVector3
            -- upvalues: u3 (ref)
            local v21 = 6.283185307179586 * u3:NextNumber();
            local v22 = p20 or 1;
            local v23 = math.cos(v21) * v22;
            local v24 = math.sin(v21) * v22;

            return Vector3.new(v23, 0, v24);
        end
    };
end;

u1.R = u1.new();

return u1;