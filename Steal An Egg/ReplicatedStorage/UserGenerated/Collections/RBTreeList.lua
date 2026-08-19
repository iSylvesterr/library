-- Decompiled with Potassium's decompiler.

local function insertRight2(p1, p2) -- Line: 75
    local Right2 = p1.Right2;
    p2.Right2 = Right2;
    p2.Left2 = p1;
    p1.Right2 = p2;
    Right2.Left2 = p2;
end;

local function unlink2(p3) -- Line: 83
    p3.Left2.Right2 = p3.Right2;
    p3.Right2.Left2 = p3.Left2;
end;

local function unlink(p4) -- Line: 88
    p4.Left2.Right2 = p4.Right2;
    p4.Right2.Left2 = p4.Left2;
    p4.Left1 = nil;
    p4.Right1 = nil;
    p4.Left2 = nil;
    p4.Right2 = nil;
end;

local function isRed(p5) -- Line: 98
    if p5 then
        return p5.Color1;
    end;

    return false;
end;

local function rotateLeft(p6) -- Line: 106
    local Right1 = p6.Right1;
    p6.Right1 = Right1.Left1;
    Right1.Left1 = p6;
    Right1.Color1 = p6.Color1;
    p6.Color1 = true;

    return Right1;
end;

local function rotateRight(p7) -- Line: 116
    local Left1 = p7.Left1;
    p7.Left1 = Left1.Right1;
    Left1.Right1 = p7;
    Left1.Color1 = p7.Color1;
    p7.Color1 = true;

    return Left1;
end;

local function flipColors(p8) -- Line: 126
    p8.Color1 = not p8.Color1;
    local Left1 = p8.Left1;
    Left1.Color1 = not Left1.Color1;
    local Right1 = p8.Right1;
    Right1.Color1 = not Right1.Color1;
end;

local function moveRedLeft(p9) -- Line: 136
    p9.Color1 = not p9.Color1;
    local Left1 = p9.Left1;
    Left1.Color1 = not Left1.Color1;
    local Right1 = p9.Right1;
    Right1.Color1 = not Right1.Color1;
    local Left12 = p9.Right1.Left1;
    local v10;

    if Left12 then
        v10 = Left12.Color1;
    else
        v10 = false;
    end;

    local v11;

    if v10 then
        local Right12 = p9.Right1;
        local Left13 = Right12.Left1;
        Right12.Left1 = Left13.Right1;
        Left13.Right1 = Right12;
        Left13.Color1 = Right12.Color1;
        Right12.Color1 = true;
        p9.Right1 = Left13;
        v11 = p9.Right1;
        p9.Right1 = v11.Left1;
        v11.Left1 = p9;
        v11.Color1 = p9.Color1;
        p9.Color1 = true;
        v11.Color1 = not v11.Color1;
        local Left14 = v11.Left1;
        Left14.Color1 = not Left14.Color1;
        local Right13 = v11.Right1;
        Right13.Color1 = not Right13.Color1;
    else
        v11 = p9;
    end;

    return v11;
end;

local function moveRedRight(p12) -- Line: 148
    p12.Color1 = not p12.Color1;
    local Left1 = p12.Left1;
    Left1.Color1 = not Left1.Color1;
    local Right1 = p12.Right1;
    Right1.Color1 = not Right1.Color1;
    local Left12 = p12.Left1.Left1;
    local v13;

    if Left12 then
        v13 = Left12.Color1;
    else
        v13 = false;
    end;

    local v14;

    if v13 then
        v14 = p12.Left1;
        p12.Left1 = v14.Right1;
        v14.Right1 = p12;
        v14.Color1 = p12.Color1;
        p12.Color1 = true;
        v14.Color1 = not v14.Color1;
        local Left13 = v14.Left1;
        Left13.Color1 = not Left13.Color1;
        local Right12 = v14.Right1;
        Right12.Color1 = not Right12.Color1;
    else
        v14 = p12;
    end;

    return v14;
end;

local function balance(p15) -- Line: 158
    local Right1 = p15.Right1;
    local v16;

    if Right1 then
        v16 = Right1.Color1;
    else
        v16 = false;
    end;

    local v17;

    if v16 then
        v17 = p15.Right1;
        p15.Right1 = v17.Left1;
        v17.Left1 = p15;
        v17.Color1 = p15.Color1;
        p15.Color1 = true;
    else
        v17 = p15;
    end;

    local Left1 = v17.Left1;
    local v18;

    if Left1 then
        v18 = Left1.Color1;
    else
        v18 = false;
    end;

    local v19;

    if v18 then
        local Left12 = v17.Left1.Left1;
        local v20;

        if Left12 then
            v20 = Left12.Color1;
        else
            v20 = false;
        end;

        if v20 then
            v19 = v17.Left1;
            v17.Left1 = v19.Right1;
            v19.Right1 = v17;
            v19.Color1 = v17.Color1;
            v17.Color1 = true;
        else
            v19 = v17;
        end;
    else
        v19 = v17;
    end;

    local Left12 = v19.Left1;
    local v21;

    if Left12 then
        v21 = Left12.Color1;
    else
        v21 = false;
    end;

    if v21 then
        local Right12 = v19.Right1;
        local v22;

        if Right12 then
            v22 = Right12.Color1;
        else
            v22 = false;
        end;

        if v22 then
            v19.Color1 = not v19.Color1;
            local Left13 = v19.Left1;
            Left13.Color1 = not Left13.Color1;
            local Right13 = v19.Right1;
            Right13.Color1 = not Right13.Color1;
        end;
    end;

    return v19;
end;

local function removeMin(p23) -- Line: 171
    -- upvalues: removeMin (copy), balance (copy)
    if not p23.Left1 then
        return nil, p23;
    end;

    local Left1 = p23.Left1;
    local v24;

    if Left1 then
        v24 = Left1.Color1;
    else
        v24 = false;
    end;

    local v25;

    if v24 then
        v25 = p23;
    else
        local Left12 = p23.Left1.Left1;
        local v26;

        if Left12 then
            v26 = Left12.Color1;
        else
            v26 = false;
        end;

        if v26 then
            v25 = p23;
        else
            p23.Color1 = not p23.Color1;
            local Left13 = p23.Left1;
            Left13.Color1 = not Left13.Color1;
            local Right1 = p23.Right1;
            Right1.Color1 = not Right1.Color1;
            local Left14 = p23.Right1.Left1;
            local v27;

            if Left14 then
                v27 = Left14.Color1;
            else
                v27 = false;
            end;

            if v27 then
                local Right12 = p23.Right1;
                local Left15 = Right12.Left1;
                Right12.Left1 = Left15.Right1;
                Left15.Right1 = Right12;
                Left15.Color1 = Right12.Color1;
                Right12.Color1 = true;
                p23.Right1 = Left15;
                v25 = p23.Right1;
                p23.Right1 = v25.Left1;
                v25.Left1 = p23;
                v25.Color1 = p23.Color1;
                p23.Color1 = true;
                v25.Color1 = not v25.Color1;
                local Left16 = v25.Left1;
                Left16.Color1 = not Left16.Color1;
                local Right13 = v25.Right1;
                Right13.Color1 = not Right13.Color1;
            else
                v25 = p23;
            end;
        end;
    end;

    local v28, v29 = removeMin(v25.Left1);
    v25.Left1 = v28;

    return balance(v25), v29;
end;

local function removeMax(p30) -- Line: 183
    -- upvalues: removeMax (copy), balance (copy)
    local Left1 = p30.Left1;
    local v31;

    if Left1 then
        v31 = Left1.Color1;
    else
        v31 = false;
    end;

    local v32;

    if v31 then
        v32 = p30.Left1;
        p30.Left1 = v32.Right1;
        v32.Right1 = p30;
        v32.Color1 = p30.Color1;
        p30.Color1 = true;
    else
        v32 = p30;
    end;

    if not v32.Right1 then
        return nil, v32;
    end;

    local Right1 = v32.Right1;
    local v33;

    if Right1 then
        v33 = Right1.Color1;
    else
        v33 = false;
    end;

    local v34;

    if v33 then
        v34 = v32;
    else
        local Left12 = v32.Right1.Left1;
        local v35;

        if Left12 then
            v35 = Left12.Color1;
        else
            v35 = false;
        end;

        if v35 then
            v34 = v32;
        else
            v32.Color1 = not v32.Color1;
            local Left13 = v32.Left1;
            Left13.Color1 = not Left13.Color1;
            local Right12 = v32.Right1;
            Right12.Color1 = not Right12.Color1;
            local Left14 = v32.Left1.Left1;
            local v36;

            if Left14 then
                v36 = Left14.Color1;
            else
                v36 = false;
            end;

            if v36 then
                v34 = v32.Left1;
                v32.Left1 = v34.Right1;
                v34.Right1 = v32;
                v34.Color1 = v32.Color1;
                v32.Color1 = true;
                v34.Color1 = not v34.Color1;
                local Left15 = v34.Left1;
                Left15.Color1 = not Left15.Color1;
                local Right13 = v34.Right1;
                Right13.Color1 = not Right13.Color1;
            else
                v34 = v32;
            end;
        end;
    end;

    local v37, v38 = removeMax(v34.Right1);
    v34.Right1 = v37;

    return balance(v34), v38;
end;

local function height(p39) -- Line: 198
    -- upvalues: height (copy)
    if not p39 then
        return -1;
    end;

    local v40 = height(p39.Left1);

    return math.max(v40, height(p39.Right1)) + 1;
end;

local function isBST(p41, p42, p43, p44) -- Line: 205
    -- upvalues: isBST (copy)
    if not p42 then
        return true;
    end;

    if p43 ~= nil and p41(p42.Key, p43) <= 0 then
        return false;
    end;

    if p44 ~= nil and p41(p42.Key, p44) >= 0 then
        return false;
    end;

    local v45 = isBST(p41, p42.Left1, p43, p42.Key) and isBST(p41, p42.Right1, p42.Key, p44);

    return v45;
end;

local function remove(p46, p47, p48) -- Line: 219
    -- upvalues: remove (copy), removeMin (copy), balance (copy)
    local v49;

    if p47 then
        local v50;

        if p46(p47.Key, p48) > 0 then
            local Left1 = p47.Left1;
            local v51;

            if Left1 then
                v51 = Left1.Color1;
            else
                v51 = false;
            end;

            if v51 then
                v50 = p47;
            else
                local Left12 = p47.Left1.Left1;
                local v52;

                if Left12 then
                    v52 = Left12.Color1;
                else
                    v52 = false;
                end;

                if v52 then
                    v50 = p47;
                else
                    p47.Color1 = not p47.Color1;
                    local Left13 = p47.Left1;
                    Left13.Color1 = not Left13.Color1;
                    local Right1 = p47.Right1;
                    Right1.Color1 = not Right1.Color1;
                    local Left14 = p47.Right1.Left1;
                    local v53;

                    if Left14 then
                        v53 = Left14.Color1;
                    else
                        v53 = false;
                    end;

                    if v53 then
                        local Right12 = p47.Right1;
                        local Left15 = Right12.Left1;
                        Right12.Left1 = Left15.Right1;
                        Left15.Right1 = Right12;
                        Left15.Color1 = Right12.Color1;
                        Right12.Color1 = true;
                        p47.Right1 = Left15;
                        v50 = p47.Right1;
                        p47.Right1 = v50.Left1;
                        v50.Left1 = p47;
                        v50.Color1 = p47.Color1;
                        p47.Color1 = true;
                        v50.Color1 = not v50.Color1;
                        local Left16 = v50.Left1;
                        Left16.Color1 = not Left16.Color1;
                        local Right13 = v50.Right1;
                        Right13.Color1 = not Right13.Color1;
                    else
                        v50 = p47;
                    end;
                end;
            end;

            local v54;
            v54, v49 = remove(p46, v50.Left1, p48);
            v50.Left1 = v54;
        else
            local Left1 = p47.Left1;
            local v55;

            if Left1 then
                v55 = Left1.Color1;
            else
                v55 = false;
            end;

            local v56;

            if v55 then
                v56 = p47.Left1;
                p47.Left1 = v56.Right1;
                v56.Right1 = p47;
                v56.Color1 = p47.Color1;
                p47.Color1 = true;
            else
                v56 = p47;
            end;

            if p46(v56.Key, p48) == 0 and not v56.Right1 then
                v56.Left2.Right2 = v56.Right2;
                v56.Right2.Left2 = v56.Left2;
                v56.Left1 = nil;
                v56.Right1 = nil;
                v56.Left2 = nil;
                v56.Right2 = nil;

                return nil, v56;
            end;

            if v56.Right1 then
                local Right1 = v56.Right1;
                local v57;

                if Right1 then
                    v57 = Right1.Color1;
                else
                    v57 = false;
                end;

                if v57 then
                    v50 = v56;
                else
                    local Left12 = v56.Right1.Left1;
                    local v58;

                    if Left12 then
                        v58 = Left12.Color1;
                    else
                        v58 = false;
                    end;

                    if v58 then
                        v50 = v56;
                    else
                        v56.Color1 = not v56.Color1;
                        local Left13 = v56.Left1;
                        Left13.Color1 = not Left13.Color1;
                        local Right12 = v56.Right1;
                        Right12.Color1 = not Right12.Color1;
                        local Left14 = v56.Left1.Left1;
                        local v59;

                        if Left14 then
                            v59 = Left14.Color1;
                        else
                            v59 = false;
                        end;

                        if v59 then
                            v50 = v56.Left1;
                            v56.Left1 = v50.Right1;
                            v50.Right1 = v56;
                            v50.Color1 = v56.Color1;
                            v56.Color1 = true;
                            v50.Color1 = not v50.Color1;
                            local Left15 = v50.Left1;
                            Left15.Color1 = not Left15.Color1;
                            local Right13 = v50.Right1;
                            Right13.Color1 = not Right13.Color1;
                        else
                            v50 = v56;
                        end;
                    end;
                end;
            else
                v50 = v56;
            end;

            if p46(v50.Key, p48) == 0 then
                local Left12 = v50.Left1;
                local Right1 = v50.Right1;
                local Color1 = v50.Color1;
                v50.Left2.Right2 = v50.Right2;
                v50.Right2.Left2 = v50.Left2;
                v50.Left1 = nil;
                v50.Right1 = nil;
                v50.Left2 = nil;
                v50.Right2 = nil;

                if Left12 and Right1 then
                    local v60, v61 = removeMin(Right1);
                    v61.Right1 = v60;
                    v61.Left1 = Left12;
                    v61.Color1 = Color1;
                    v49 = v50;
                    v50 = v61;
                else
                    local v62 = Left12 or Right1;
                    v62.Color1 = Color1;
                    v49 = v50;
                    v50 = v62;
                end;
            else
                local v63;
                v63, v49 = remove(p46, v50.Right1, p48);
                v50.Right1 = v63;
            end;
        end;

        p47 = balance(v50);
    else
        v49 = nil;
    end;

    return p47, v49;
end;

local function insert(p64, p65, p66, p67, p68) -- Line: 262
    -- upvalues: insert (copy), balance (copy)
    if p65 then
        local v69 = false;
        local v70 = p64(p65.Key, p67);
        local v71;

        if v70 == 0 then
            p65.Value = p68;
            v71 = p65;
        else
            if v70 > 0 then
                local v72;
                v72, v71, v69 = insert(p64, p65.Left1, p65.Left2, p67, p68);
                p65.Left1 = v72;
            else
                local v73;
                v73, v71, v69 = insert(p64, p65.Right1, p65, p67, p68);
                p65.Right1 = v73;
            end;

            if v69 then
                p65 = balance(p65);
            end;
        end;

        return p65, v71, v69;
    end;

    local v74 = {
        Color1 = true,
        Left2 = nil,
        Right2 = nil,
        Key = p67,
        Value = p68
    };
    local Right2 = p66.Right2;
    v74.Right2 = Right2;
    v74.Left2 = p66;
    p66.Right2 = v74;
    Right2.Left2 = v74;

    return v74, v74, true;
end;

local function isBalanced(p75, p76) -- Line: 293
    -- upvalues: isBalanced (copy)
    if not p75 then
        return p76 == 0;
    end;

    local v77;

    if p75 then
        v77 = p75.Color1;
    else
        v77 = false;
    end;

    if not v77 then
        p76 = p76 - 1;
    end;

    local v78 = isBalanced(p75.Left1, p76) and isBalanced(p75.Right1, p76);

    return v78;
end;

local function size(p79) -- Line: 303
    -- upvalues: size (copy)
    local v80 = 0;

    if p79 then
        v80 = v80 + 1 + size(p79.Left1) + size(p79.Right1);
    end;

    return v80;
end;

local function selectRank(p81, p82) -- Line: 313
    -- upvalues: size (copy), selectRank (copy)
    if not p81 then
        return nil;
    end;

    local Left1 = p81.Left1;
    local v83 = 0;

    if Left1 then
        v83 = v83 + 1 + size(Left1.Left1) + size(Left1.Right1);
    end;

    if p82 < v83 then
        return selectRank(p81.Left1, p82);
    end;

    if v83 < p82 then
        return selectRank(p81.Right1, p82 - v83 - 1);
    end;

    return p81.Key;
end;

local function rank(p84, p85, p86) -- Line: 327
    -- upvalues: rank (copy), size (copy)
    if not p86 then
        return 0;
    end;

    local v87 = p84(p86.Key, p85);

    if v87 > 0 then
        return rank(p84, p85, p86.Left1);
    end;

    if v87 < 0 then
        local Left1 = p86.Left1;
        local v88 = 0;

        if Left1 then
            v88 = v88 + 1 + size(Left1.Left1) + size(Left1.Right1);
        end;

        return v88 + 1 + rank(p84, p85, p86.Right1);
    end;

    local Left1 = p86.Left1;
    local v89 = 0;

    if Left1 then
        v89 = v89 + 1 + size(Left1.Left1) + size(Left1.Right1);
    end;

    return v89;
end;

local function is23(p90, p91) -- Line: 341
    -- upvalues: is23 (copy)
    if not p91 then
        return true;
    end;

    local Right1 = p91.Right1;
    local v92;

    if Right1 then
        v92 = Right1.Color1;
    else
        v92 = false;
    end;

    if v92 then
        return false;
    end;

    if p91 ~= p90 then
        local v93;

        if p91 then
            v93 = p91.Color1;
        else
            v93 = false;
        end;

        if v93 then
            local Left1 = p91.Left1;
            local v94;

            if Left1 then
                v94 = Left1.Color1;
            else
                v94 = false;
            end;

            if v94 then
                return false;
            end;
        end;
    end;

    local v95 = is23(p90, p91.Left1) and is23(p91.Right1);

    return v95;
end;

local v96 = {};
local u97 = table.freeze({
    __index = v96
});

function v96.Insert(p98, p99, p100) -- Line: 360
    -- upvalues: insert (copy)
    local v101, v102, v103 = insert(p98.Comparator, p98.Root, p98.List, p99, p100);
    v101.Color1 = false;
    p98.Root = v101;

    if v103 then
        p98.Size = p98.Size + 1;
    end;

    return v102, v103;
end;

function v96.Remove(p104, p105) -- Line: 370
    -- upvalues: remove (copy)
    local Root = p104.Root;
    local v106;

    if Root then
        local Left1 = Root.Left1;
        local v107;

        if Left1 then
            v107 = Left1.Color1;
        else
            v107 = false;
        end;

        if not v107 then
            local Right1 = Root.Right1;
            local v108;

            if Right1 then
                v108 = Right1.Color1;
            else
                v108 = false;
            end;

            if not v108 then
                Root.Color1 = true;
            end;
        end;

        local v109;
        v109, v106 = remove(p104.Comparator, Root, p105);

        if v109 then
            v109.Color1 = false;
        end;

        p104.Root = v109;

        if v106 then
            p104.Size = p104.Size - 1;
        end;
    else
        v106 = nil;
    end;

    return v106;
end;

function v96.RemoveMin(p110) -- Line: 389
    -- upvalues: removeMin (copy)
    local Root = p110.Root;
    local v111;

    if Root then
        local Left1 = Root.Left1;
        local v112;

        if Left1 then
            v112 = Left1.Color1;
        else
            v112 = false;
        end;

        if not v112 then
            local Right1 = Root.Right1;
            local v113;

            if Right1 then
                v113 = Right1.Color1;
            else
                v113 = false;
            end;

            if not v113 then
                Root.Color1 = true;
            end;
        end;

        local v114;
        v114, v111 = removeMin(Root);

        if v114 then
            v114.Color1 = false;
        end;

        p110.Root = v114;

        if v111 then
            p110.Size = p110.Size - 1;
        end;
    else
        v111 = nil;
    end;

    return v111;
end;

function v96.RemoveMax(p115) -- Line: 408
    -- upvalues: removeMax (copy)
    local Root = p115.Root;
    local v116;

    if Root then
        local Left1 = Root.Left1;
        local v117;

        if Left1 then
            v117 = Left1.Color1;
        else
            v117 = false;
        end;

        if not v117 then
            local Right1 = Root.Right1;
            local v118;

            if Right1 then
                v118 = Right1.Color1;
            else
                v118 = false;
            end;

            if not v118 then
                Root.Color1 = true;
            end;
        end;

        local v119;
        v119, v116 = removeMax(Root);

        if v119 then
            v119.Color1 = false;
        end;

        p115.Root = v119;

        if v116 then
            p115.Size = p115.Size - 1;
        end;
    else
        v116 = nil;
    end;

    return v116;
end;

function v96.Min(p120) -- Line: 427
    local List = p120.List;
    local Left1 = List.Left1;

    if Left1 == List then
        return nil;
    end;

    return Left1;
end;

function v96.Max(p121) -- Line: 436
    local List = p121.List;
    local Right1 = List.Right1;

    if Right1 == List then
        return nil;
    end;

    return Right1;
end;

function v96.GetSize(p122) -- Line: 445
    return p122.Size;
end;

function v96.ForEach(p123, p124) -- Line: 449
    local v125 = type(p124) == "function";
    assert(v125);
    local List = p123.List;
    local v126 = List;

    while true do
        List = List.Right2;

        if List == v126 then
            break;
        end;

        p124(List.Key, List.Value);
    end;
end;

function v96.Next(p127, p128) -- Line: 462
    if p128 == nil then
        p128 = p127.List;
    end;

    local Right2 = p128.Right2;

    if Right2 == p127.List then
        return nil, nil;
    end;

    return Right2, Right2;
end;

function v96.Iterator(p129) -- Line: 472
    return p129.Next, p129;
end;

function v96.IsBST(p130) -- Line: 476
    -- upvalues: isBST (copy)
    local Comparator = p130.Comparator;
    local Root = p130.Root;
    local v131;

    if Root then
        v131 = isBST(Comparator, Root.Left1, nil, Root.Key);

        if v131 then
            return isBST(Comparator, Root.Right1, Root.Key, nil);
        end;
    else
        v131 = true;
    end;

    return v131;
end;

function v96.IsSizeConsistent(p132) -- Line: 480
    -- upvalues: size (copy)
    local Size = p132.Size;
    local Root = p132.Root;
    local v133 = 0;

    if Root then
        v133 = v133 + 1 + size(Root.Left1) + size(Root.Right1);
    end;

    if Size ~= v133 then
        return false;
    end;

    local List = p132.List;
    local v134 = List;
    local v135 = 0;

    while true do
        List = List.Right2;

        if List == v134 then
            break;
        end;

        v135 = v135 + 1;
    end;

    return Size == v135;
end;

function v96.IsRankConsistent(u136) -- Line: 502
    -- upvalues: size (copy), selectRank (copy), rank (copy)
    for i = 0, u136.Size - 1 do
        local Root = u136.Root;
        local v137;

        if Root then
            local Left1 = Root.Left1;
            local v138 = 0;

            if Left1 then
                v138 = v138 + 1 + size(Left1.Left1) + size(Left1.Right1);
            end;

            if i < v138 then
                v137 = selectRank(Root.Left1, i);
            elseif v138 < i then
                v137 = selectRank(Root.Right1, i - v138 - 1);
            else
                v137 = Root.Key;
            end;
        else
            v137 = nil;
        end;

        if i ~= rank(u136.Comparator, v137, u136.Root) then
            return false;
        end;
    end;

    u136:ForEach(function(p139, p140) -- Line: 512
        -- upvalues: rank (ref), u136 (copy), size (ref), selectRank (ref)
        local v141 = rank(u136.Comparator, p139, u136.Root);
        local Root = u136.Root;
        local v142;

        if Root then
            local Left1 = Root.Left1;
            local v143 = 0;

            if Left1 then
                v143 = v143 + 1 + size(Left1.Left1) + size(Left1.Right1);
            end;

            if v141 < v143 then
                v142 = selectRank(Root.Left1, v141);
            elseif v143 < v141 then
                v142 = selectRank(Root.Right1, v141 - v143 - 1);
            else
                v142 = Root.Key;
            end;
        else
            v142 = nil;
        end;

        if u136.Comparator(v142, p139) ~= 0 then
            return false;
        end;
    end);

    return true;
end;

function v96.Is23(p144) -- Line: 522
    -- upvalues: is23 (copy)
    return is23(p144.Root, p144.Root);
end;

function v96.IsBalanced(p145) -- Line: 526
    -- upvalues: isBalanced (copy)
    local Root = p145.Root;
    local v146 = Root;
    local v147 = 0;

    while Root do
        local v148;

        if Root then
            v148 = Root.Color1;
        else
            v148 = false;
        end;

        if not v148 then
            v147 = v147 + 1;
        end;

        Root = Root.Left1;
    end;

    local v149;

    if v146 then
        local v150;

        if v146 then
            v150 = v146.Color1;
        else
            v150 = false;
        end;

        if not v150 then
            v147 = v147 - 1;
        end;

        v149 = isBalanced(v146.Left1, v147);

        if v149 then
            return isBalanced(v146.Right1, v147);
        end;
    else
        v149 = v147 == 0;
    end;

    return v149;
end;

function v96.Check(p151) -- Line: 539
    if not p151:IsBST() then
        return false, "Not in symmetric order";
    end;

    if not p151:IsSizeConsistent() then
        return false, "Subtree counts not consistent";
    end;

    if not p151:IsRankConsistent() then
        return false, "Ranks not consistent";
    end;

    if not p151:Is23() then
        return false, "Not a 2-3 tree";
    end;

    if p151:IsBalanced() then
        return true;
    end;

    return false, "Not balanced";
end;

table.freeze(v96);

return table.freeze({
    Compare = function(p152, p153) -- Line: 563, Name: Compare
        return p152 < p153 and -1 or (p153 < p152 and 1 or 0);
    end,

    new = function(p154, p155, p156) -- Line: 573, Name: new
        -- upvalues: u97 (copy)
        local v157 = type(p154) == "function";
        assert(v157);
        local v158 = {
            Color1 = false,
            Key = nil,
            Value = nil
        };
        v158.Left2 = v158;
        v158.Right2 = v158;

        return setmetatable({
            Root = nil,
            Size = 0,
            Comparator = p154,
            List = v158
        }, u97);
    end
});