-- Decompiled with Potassium's decompiler.

local v1 = {};
local CollectionService = game:GetService("CollectionService");

function v1.Listen(p2, p3, u4, u5, u6) -- Line: 19
    -- upvalues: CollectionService (copy)
    local u7 = {};

    local function added(p8) -- Line: 22
        -- upvalues: u4 (copy), u5 (copy), u6 (copy), u7 (copy)
        if u4 and p8.Name ~= u4 then
            return;
        end;

        if u5 then
            local v9 = p8:GetAttribute("Loading_ID");

            if not v9 or v9 ~= u5 then
                return;
            end;
        end;

        u7[p8] = u6(p8);
    end;

    for _, v in CollectionService:GetTagged(p3) do
        if not u4 or v.Name == u4 then
            if u5 then
                local v10 = v:GetAttribute("Loading_ID");

                if v10 then
                    if v10 == u5 then
                        u7[v] = u6(v);
                    end;
                end;
            else
                u7[v] = u6(v);
            end;
        end;
    end;

    CollectionService:GetInstanceAddedSignal(p3):Connect(added);
    CollectionService:GetInstanceRemovedSignal(p3):Connect(function(p11) -- Line: 38
        -- upvalues: u4 (copy), u5 (copy), u7 (copy)
        if u4 and p11.Name ~= u4 then
            return;
        end;

        if u5 then
            local v12 = p11:GetAttribute("Loading_ID");

            if not v12 or v12 ~= u5 then
                return;
            end;
        end;

        if u7[p11] then
            u7[p11]:Destroy();
        end;
    end);
end;

return v1;