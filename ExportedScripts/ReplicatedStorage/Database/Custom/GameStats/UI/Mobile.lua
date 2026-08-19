-- Decompiled with Potassium's decompiler.

local u1 = {
    REQUIRED_BUTTONS = table.freeze({ "Shoot", "Shop", "Scoreboard", "Reload", "Jump", "Walk", "Crouch", "Aim", "Drop", "Interact", "Inspect", "SwapTeam", "Configure", "Menu", "Ping" }),
    MIN_SIZE = 0.05,
    MAX_SIZE = 0.4,
    MIN_POSITION = -2,
    MAX_POSITION = 2
};
local u2 = {
    Inspect = {
        Position = {
            X = 0.71,
            Y = 0.275
        },
        Size = {
            X = 0.08,
            Y = 0.125
        }
    },
    Aim = {
        Position = {
            X = 0.796,
            Y = 0.328
        },
        Size = {
            X = 0.0877,
            Y = 0.132
        }
    },
    Crouch = {
        Position = {
            X = 0.07,
            Y = 0.382
        },
        Size = {
            X = 0.0826,
            Y = 0.1529
        }
    },
    Walk = {
        Position = {
            X = 0.13,
            Y = 0.382
        },
        Size = {
            X = 0.0826,
            Y = 0.1529
        }
    },
    Drop = {
        Position = {
            X = 0.915,
            Y = 0.315
        },
        Size = {
            X = 0.0638,
            Y = 0.106
        }
    },
    Interact = {
        Position = {
            X = 0.7572,
            Y = 0.7332
        },
        Size = {
            X = 0.1151,
            Y = 0.1779
        }
    },
    Jump = {
        Position = {
            X = 0.919,
            Y = 0.478
        },
        Size = {
            X = 0.0823,
            Y = 0.1551
        }
    },
    Menu = {
        Position = {
            X = 0.835,
            Y = 0.0645
        },
        Size = {
            X = 0.0649,
            Y = 0.0962
        }
    },
    Shoot = {
        Position = {
            X = 0.8195,
            Y = 0.5021
        },
        Size = {
            X = 0.1151,
            Y = 0.1779
        }
    },
    Reload = {
        Position = {
            X = 0.7098,
            Y = 0.4151
        },
        Size = {
            X = 0.066,
            Y = 0.1233
        }
    },
    Shop = {
        Position = {
            X = 0.04,
            Y = 0.525
        },
        Size = {
            X = 0.075,
            Y = 0.1334
        }
    },
    Scoreboard = {
        Position = {
            X = 0.12,
            Y = 0.525
        },
        Size = {
            X = 0.075,
            Y = 0.1334
        }
    },
    SwapTeam = {
        Position = {
            X = 0.9,
            Y = 0.0645
        },
        Size = {
            X = 0.0649,
            Y = 0.0962
        }
    },
    Configure = {
        Position = {
            X = 0.9,
            Y = 0.17
        },
        Size = {
            X = 0.0649,
            Y = 0.0962
        }
    },
    Ping = {
        Position = {
            X = 0.729,
            Y = 0.561
        },
        Size = {
            X = 0.066,
            Y = 0.1233
        }
    }
};

local function IsFiniteNumber(p3) -- Line: 105
    local v4;

    if typeof(p3) == "number" and (p3 == p3 and p3 ~= (1 / 0)) then
        v4 = p3 ~= (-1 / 0);
    else
        v4 = false;
    end;

    return v4;
end;

local function CopyButtonLayout(p5) -- Line: 109
    return {
        Position = {
            X = p5.Position.X,
            Y = p5.Position.Y
        },
        Size = {
            X = p5.Size.X,
            Y = p5.Size.Y
        }
    };
end;

local function HasValidButtonLayout(p6) -- Line: 122
    if typeof(p6) ~= "table" then
        return false;
    end;

    local Position = p6.Position;
    local Size = p6.Size;

    if typeof(Position) ~= "table" or typeof(Size) ~= "table" then
        return false;
    end;

    local X = Position.X;
    local v7;

    if typeof(X) == "number" and (X == X and X ~= (1 / 0)) then
        v7 = X ~= (-1 / 0);
    else
        v7 = false;
    end;

    if v7 then
        local Y = Position.Y;

        if typeof(Y) == "number" and (Y == Y and Y ~= (1 / 0)) then
            v7 = Y ~= (-1 / 0);
        else
            v7 = false;
        end;

        if v7 then
            local X2 = Size.X;

            if typeof(X2) == "number" and (X2 == X2 and X2 ~= (1 / 0)) then
                v7 = X2 ~= (-1 / 0);
            else
                v7 = false;
            end;

            if v7 then
                local Y2 = Size.Y;

                if typeof(Y2) == "number" and (Y2 == Y2 and Y2 ~= (1 / 0)) then
                    v7 = Y2 ~= (-1 / 0);
                else
                    v7 = false;
                end;
            end;
        end;
    end;

    return v7;
end;

function u1.GetButtonNames() -- Line: 139
    -- upvalues: u1 (copy)
    return table.clone(u1.REQUIRED_BUTTONS);
end;

function u1.GetDefaultLayout() -- Line: 143
    -- upvalues: u1 (copy), CopyButtonLayout (copy), u2 (copy)
    local v8 = {};

    for _, v in ipairs(u1.REQUIRED_BUTTONS) do
        v8[v] = CopyButtonLayout(u2[v]);
    end;

    return v8;
end;

function u1.GetDefaultButtonLayout(p9) -- Line: 151
    -- upvalues: u2 (copy), CopyButtonLayout (copy)
    local v10 = u2[p9];

    return not v10 and {
        Position = {
            X = 0.5,
            Y = 0.5
        },
        Size = {
            X = 0.1,
            Y = 0.1
        }
    } or CopyButtonLayout(v10);
end;

function u1.ClampButtonLayout(p11) -- Line: 163
    -- upvalues: u1 (copy)
    local v12 = math.clamp(p11.Size.X, u1.MIN_SIZE, u1.MAX_SIZE);
    local v13 = math.clamp(p11.Size.Y, u1.MIN_SIZE, u1.MAX_SIZE);

    return {
        Position = {
            X = math.clamp(p11.Position.X, u1.MIN_POSITION, u1.MAX_POSITION),
            Y = math.clamp(p11.Position.Y, u1.MIN_POSITION, u1.MAX_POSITION)
        },
        Size = {
            X = v12,
            Y = v13
        }
    };
end;

function u1.HasAllRequiredButtons(p14) -- Line: 179
    -- upvalues: u1 (copy), HasValidButtonLayout (copy)
    if typeof(p14) ~= "table" then
        return false;
    end;

    for _, v in ipairs(u1.REQUIRED_BUTTONS) do
        if not HasValidButtonLayout(p14[v]) then
            return false;
        end;
    end;

    return true;
end;

function u1.SanitizeLayout(p15) -- Line: 193
    -- upvalues: u1 (copy), HasValidButtonLayout (copy)
    local v16 = u1.GetDefaultLayout();

    if typeof(p15) ~= "table" then
        return v16;
    end;

    for _, v in ipairs(u1.REQUIRED_BUTTONS) do
        local v17 = p15[v];

        if HasValidButtonLayout(v17) then
            v16[v] = u1.ClampButtonLayout({
                Position = {
                    X = v17.Position.X,
                    Y = v17.Position.Y
                },
                Size = {
                    X = v17.Size.X,
                    Y = v17.Size.Y
                }
            });
        end;
    end;

    return v16;
end;

return u1;