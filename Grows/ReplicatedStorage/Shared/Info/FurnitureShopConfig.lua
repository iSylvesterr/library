-- Decompiled with Potassium's decompiler.

local u1 = {
    Categories = {
        {
            name = "Bushes",
            type = "Bushes",
            items = { {
                    id = "Wood Flower Bed",
                    price = 5
                }, {
                    id = "Wood Bush Bed",
                    price = 5
                }, {
                    id = "Wood Flower Bush Bed",
                    price = 10
                }, {
                    id = "Stone Flower Bed",
                    price = 5
                }, {
                    id = "Stone Bush Bed",
                    price = 5
                }, {
                    id = "Stone Flower Bush Bed",
                    price = 10
                }, {
                    id = "Brick Flower Bed",
                    price = 5
                }, {
                    id = "Brick Bush Bed",
                    price = 5
                }, {
                    id = "Brick Flower Bush Bed",
                    price = 10
                } }
        },
        {
            name = "Lighting",
            type = "Lighting",
            items = { {
                    id = "Campfire",
                    price = 25
                }, {
                    id = "Bonfire",
                    price = 35
                }, {
                    id = "Lamp Post",
                    price = 15
                }, {
                    id = "Small String Lights",
                    price = 10
                }, {
                    id = "Medium String Lights",
                    price = 15
                }, {
                    id = "Large String Lights",
                    price = 20
                } }
        },
        {
            name = "Planters",
            type = "Planters",
            items = {
                {
                    id = "Small Dirt Planter",
                    price = 3
                },
                {
                    id = "Medium Dirt Planter",
                    price = 5
                },
                {
                    id = "Large Dirt Planter",
                    price = 8
                },
                {
                    id = "Huge Dirt Planter",
                    price = 10
                },
                {
                    id = "Small Wood Planter",
                    price = 3
                },
                {
                    id = "Medium Wood Planter",
                    price = 5
                },
                {
                    id = "Large Wood Planter",
                    price = 8
                },
                {
                    id = "Huge Wood Planter",
                    price = 10
                },
                {
                    id = "Small Stone Planter",
                    price = 3
                },
                {
                    id = "Medium Stone Planter",
                    price = 5
                },
                {
                    id = "Large Stone Planter",
                    price = 8
                },
                {
                    id = "Huge Stone Planter",
                    price = 10
                },
                {
                    id = "Small White Planter",
                    price = 3
                },
                {
                    id = "Medium White Planter",
                    price = 5
                },
                {
                    id = "Large White Planter",
                    price = 8
                },
                {
                    id = "Huge White Planter",
                    price = 10
                },
                {
                    id = "Small Leafy White Planter",
                    price = 3
                },
                {
                    id = "Medium Leafy White Planter",
                    price = 5
                },
                {
                    id = "Large Leafy White Planter",
                    price = 8
                },
                {
                    id = "Huge Leafy White Planter",
                    price = 10
                },
                {
                    id = "Small Gold Planter",
                    price = 15
                },
                {
                    id = "Medium Gold Planter",
                    price = 25
                },
                {
                    id = "Large Gold Planter",
                    price = 35
                },
                {
                    id = "Huge Gold Planter",
                    price = 50
                }
            }
        },
        {
            name = "Paths",
            type = "Paths",
            items = { {
                    id = "Dirt Path",
                    price = 1
                }, {
                    id = "Grass Path",
                    price = 1
                }, {
                    id = "Wood Path",
                    price = 1
                }, {
                    id = "Stone Path",
                    price = 1
                }, {
                    id = "Brick Path",
                    price = 1
                } }
        },
        {
            name = "Fences",
            type = "Fences",
            items = { {
                    id = "Wood Fence",
                    price = 3
                }, {
                    id = "White Farm Fence",
                    price = 3
                } }
        },
        {
            name = "Seating",
            type = "Seating",
            items = { {
                    id = "Small Wood Bench 1",
                    price = 3
                }, {
                    id = "Small Wood Bench 2",
                    price = 3
                }, {
                    id = "Large Wood Bench 1",
                    price = 5
                }, {
                    id = "Large Wood Bench 2",
                    price = 5
                }, {
                    id = "Small Stump",
                    price = 3
                }, {
                    id = "Large Stump",
                    price = 5
                } }
        },
        {
            name = "Tables",
            type = "Tables",
            items = { {
                    id = "Small Wood Table",
                    price = 3
                }, {
                    id = "Large Wood Table",
                    price = 5
                } }
        },
        {
            name = "Fruit Stands",
            type = "FruitStands",
            items = { {
                    id = "Small Wood Fruit Stand",
                    price = 25
                }, {
                    id = "Medium Wood Fruit Stand",
                    price = 35
                }, {
                    id = "Large Wood Fruit Stand",
                    price = 50
                }, {
                    id = "Small Shaded Wood Fruit Stand",
                    price = 25
                }, {
                    id = "Medium Shaded Wood Fruit Stand",
                    price = 35
                }, {
                    id = "Large Shaded Wood Fruit Stand",
                    price = 50
                } }
        }
    },
    Limited = {
        refreshInterval = 604800,
        anchor = 1784158546,
        items = { {
                id = "Fish Pond",
                price = 1000
            }, {
                id = "Fountain",
                price = 1000
            }, {
                id = "Butterfly Habitat",
                price = 1000
            } }
    }
};

function u1.GetLimitedOffer(p2) -- Line: 124
    -- upvalues: u1 (copy)
    local Limited = u1.Limited;
    local v3 = math.floor((p2 - Limited.anchor) / Limited.refreshInterval);

    return Limited.items[v3 % #Limited.items + 1], Limited.anchor + (v3 + 1) * Limited.refreshInterval;
end;

function u1.GetPrice(p4, p5) -- Line: 132
    -- upvalues: u1 (copy)
    for _, v in u1.Categories do
        if v.type == p4 then
            for _, v2 in v.items do
                if v2.id == p5 then
                    return v2.price;
                end;
            end;
        end;
    end;

    return nil;
end;

function u1.ApplyPriceOverrides(p6) -- Line: 145
    -- upvalues: u1 (copy)
    if type(p6) ~= "table" then
        return;
    end;

    for _, v in u1.Categories do
        for _, v2 in v.items do
            local v7 = tonumber(p6[v2.id]);

            if v7 and v7 > 0 then
                v2.price = v7;
            end;
        end;
    end;
end;

return u1;