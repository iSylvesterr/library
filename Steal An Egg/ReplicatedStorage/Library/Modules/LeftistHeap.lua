-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = nil;

local function merge(p3, p4, p5) -- Line: 5
    -- upvalues: u2 (ref)
    if not p4 then
        return p5;
    end;

    if not p5 then
        return p4;
    end;

    if p3(p4.element, p5.element) < 0 then
        return u2(p3, p4, p5);
    end;

    return u2(p3, p5, p4);
end;

u2 = function(p6, p7, p8) -- Line: 18, Name: mergeRoot
    -- upvalues: u2 (ref)
    if not p7.left then
        p7.left = p8;

        return p7;
    end;

    local right = p7.right;

    if right then
        if p8 then
            if p6(right.element, p8.element) < 0 then
                right = u2(p6, right, p8);
            else
                right = u2(p6, p8, right);
            end;
        end;
    else
        right = p8;
    end;

    p7.right = right;

    if p7.left.npl < p7.right.npl then
        local left = p7.left;
        p7.left = p7.right;
        p7.right = left;
    end;

    p7.npl = p7.right.npl + 1;

    return p7;
end;

function v1.new(u9) -- Line: 34
    -- upvalues: u2 (ref)
    local v10 = typeof(u9) == "function";
    assert(v10);
    local u11 = {
        root = nil
    };

    function u11.merge(p12) -- Line: 38
        -- upvalues: u11 (copy), u9 (copy), u2 (ref)
        if u11.root ~= p12.root then
            local v13 = u9;
            local root = u11.root;
            local root2 = p12.root;

            if root then
                if root2 then
                    if v13(root.element, root2.element) < 0 then
                        root = u2(v13, root, root2);
                    else
                        root = u2(v13, root2, root);
                    end;
                end;
            else
                root = root2;
            end;

            u11.root = root;
            p12.root = nil;
        end;
    end;

    local function pop() -- Line: 61
        -- upvalues: u11 (copy), u9 (copy), u2 (ref)
        assert(u11.root);
        local element = u11.root.element;
        local v14 = u9;
        local left = u11.root.left;
        local right = u11.root.right;

        if left then
            if right then
                if v14(left.element, right.element) < 0 then
                    left = u2(v14, left, right);
                else
                    left = u2(v14, right, left);
                end;
            end;
        else
            left = right;
        end;

        u11.root = left;

        return element;
    end;

    local function tryPop() -- Line: 68
        -- upvalues: u11 (copy), u9 (copy), u2 (ref)
        if not u11.root then
            return false, nil;
        end;

        local element = u11.root.element;
        local v15 = u9;
        local left = u11.root.left;
        local right = u11.root.right;

        if left then
            if right then
                if v15(left.element, right.element) < 0 then
                    left = u2(v15, left, right);
                else
                    left = u2(v15, right, left);
                end;
            end;
        else
            left = right;
        end;

        u11.root = left;

        return true, element;
    end;

    local function popFast() -- Line: 77
        -- upvalues: u11 (copy), u9 (copy), u2 (ref)
        local v16 = u9;
        local left = u11.root.left;
        local right = u11.root.right;

        if left then
            if right then
                if v16(left.element, right.element) < 0 then
                    left = u2(v16, left, right);
                else
                    left = u2(v16, right, left);
                end;
            end;
        else
            left = right;
        end;

        u11.root = left;
    end;

    function u11.insert(p17) -- Line: 45
        -- upvalues: u11 (copy), u9 (copy), u2 (ref)
        local v18 = u9;
        local v19 = {
            npl = 0,
            element = p17
        };
        local root = u11.root;

        if v19 then
            if root then
                if v18(v19.element, root.element) < 0 then
                    v19 = u2(v18, v19, root);
                else
                    v19 = u2(v18, root, v19);
                end;
            end;
        else
            v19 = root;
        end;

        u11.root = v19;
    end;

    function u11.min() -- Line: 49
        -- upvalues: u11 (copy)
        assert(u11.root);

        return u11.root.element;
    end;

    function u11.tryMin() -- Line: 54
        -- upvalues: u11 (copy)
        if u11.root then
            return true, u11.root.element;
        end;

        return false;
    end;

    u11.pop = pop;
    u11.tryPop = tryPop;
    u11.popFast = popFast;

    function u11.empty() -- Line: 81
        -- upvalues: u11 (copy)
        return u11.root == nil;
    end;

    function u11.clear() -- Line: 85
        -- upvalues: u11 (copy)
        u11.root = nil;
    end;

    return u11;
end;

return v1;