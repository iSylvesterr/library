-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 4
    -- upvalues: u1 (copy)
    local v3 = setmetatable({}, u1);
    v3.ScrollingFrame = p2.ScrollingFrame;
    v3.UIGridFrame = p2.UIGridFrame;
    v3.HiddenParent = p2.HiddenParent;
    v3.Slots = p2.Slots;
    v3.GetNumberOfHotbarSlots = p2.GetNumberOfHotbarSlots;
    v3.GetCurrentFilter = p2.GetCurrentFilter;
    v3.ToolMatchesFilter = p2.ToolMatchesFilter;
    v3.CellSize = p2.CellSize;
    v3.CellPadding = p2.CellPadding;
    v3.BufferRows = p2.BufferRows or 2;
    v3.IsFrozen = p2.IsFrozen;
    v3.OnShowSlot = p2.OnShowSlot;
    v3._dirtyList = true;
    v3._dirtyLayout = true;
    v3._scheduled = false;
    v3._visibleSlots = {};
    v3._rendered = {};
    v3._columns = 1;
    v3._rowHeight = v3.CellSize + v3.CellPadding;

    return v3;
end;

function u1.MarkListDirty(p4) -- Line: 30
    p4._dirtyList = true;
    p4:RequestRender();
end;

function u1.MarkLayoutDirty(p5) -- Line: 35
    p5._dirtyLayout = true;
    p5:RequestRender();
end;

function u1.SetSearchQuery(p6, p7) -- Line: 40
    local v8 = {};

    if type(p7) == "string" then
        for i in p7:gmatch("%S+") do
            v8[i:lower()] = true;
        end;
    end;

    p6._searchTerms = next(v8) and v8 and v8 or nil;
    p6._dirtyList = true;
    p6:RequestRender();
end;

local function getSearchText(p9) -- Line: 52
    local v10 = {};
    table.insert(v10, p9.Name or "");
    local ToolTip = p9.ToolTip;

    if type(ToolTip) == "string" then
        table.insert(v10, ToolTip);
    end;

    local v11 = p9:GetAttributes();

    for _, v in pairs(v11) do
        if type(v) == "string" or type(v) == "number" then
            local v12 = tostring(v);
            table.insert(v10, v12);
        end;
    end;

    return table.concat(v10, " "):lower();
end;

local function countHits(p13, p14) -- Line: 68
    local v15 = 0;

    for i in pairs(p14) do
        local _, v16 = p13:gsub(i, "");
        v15 = v15 + v16;
    end;

    return v15;
end;

local function getFruitSortKey(p17) -- Line: 77
    if p17:GetAttribute("Fruit") ~= nil then
        return p17:GetAttribute("Mutation") ~= nil and 0 or 1, p17:GetAttribute("SizeMultiplier") or 1;
    end;

    return 2, 0;
end;

function u1.RebuildVisibleSlots(p18) -- Line: 87
    -- upvalues: getSearchText (copy), countHits (copy)
    local _searchTerms = p18._searchTerms;
    local v19 = p18.GetNumberOfHotbarSlots() + 1;
    local v20 = p18.GetCurrentFilter();
    local v21 = {};

    for i = v19, #p18.Slots do
        local v22 = p18.Slots[i];

        if v22 and (v22.Tool and p18.ToolMatchesFilter(v22.Tool, v20)) then
            if _searchTerms then
                local v23 = countHits(getSearchText(v22.Tool), _searchTerms);

                if v23 > 0 then
                    table.insert(v21, {
                        slot = v22,
                        hits = v23,
                        order = i
                    });
                end;
            else
                local Tool = v22.Tool;
                local v24, v25;

                if Tool:GetAttribute("Fruit") ~= nil then
                    local v26 = Tool:GetAttribute("Mutation") ~= nil;
                    v24 = Tool:GetAttribute("SizeMultiplier") or 1;
                    v25 = v26 and 0 or 1;
                else
                    v25 = 2;
                    v24 = 0;
                end;

                table.insert(v21, {
                    slot = v22,
                    group = v25,
                    size = v24,
                    order = i
                });
            end;
        end;
    end;

    if _searchTerms then
        table.sort(v21, function(p27, p28) -- Line: 110
            if p27.hits == p28.hits then
                return p27.order < p28.order;
            end;

            return p27.hits > p28.hits;
        end);
    else
        table.sort(v21, function(p29, p30) -- Line: 117
            if p29.group ~= p30.group then
                return p29.group < p30.group;
            end;

            if p29.size == p30.size then
                return p29.order < p30.order;
            end;

            return p29.size > p30.size;
        end);
    end;

    local v31 = {};

    for _, v in v21 do
        table.insert(v31, v.slot);
    end;

    p18._visibleSlots = v31;
end;

function u1._updateLayout(p32) -- Line: 135
    local v33 = math.floor(p32.ScrollingFrame.AbsoluteSize.X / (p32.CellSize + p32.CellPadding));
    p32._columns = v33 < 1 and 1 or v33;
    p32._rowHeight = p32.CellSize + p32.CellPadding;
end;

function u1._updateCanvas(p34) -- Line: 144
    local v35 = math.ceil(#p34._visibleSlots / p34._columns) * p34._rowHeight + p34.CellPadding;
    p34.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, v35);
end;

function u1._desiredRange(p36) -- Line: 151
    local v37 = #p36._visibleSlots;

    if v37 <= 0 then
        return 1, 0;
    end;

    local Y = p36.ScrollingFrame.CanvasPosition.Y;
    local Y2 = p36.ScrollingFrame.AbsoluteWindowSize.Y;
    local v38 = math.floor(Y / p36._rowHeight);
    local v39 = math.floor((Y + Y2) / p36._rowHeight);
    local v40 = math.max(0, v38 - p36.BufferRows) * p36._columns + 1;
    local v41 = (v39 + p36.BufferRows + 1) * p36._columns;

    if v37 < v41 then
        v41 = v37;
    end;

    return v40 < 1 and 1 or v40, v41;
end;

function u1._hideSlot(p42, p43) -- Line: 174
    if p43 then
        p43 = p43.Frame;
    end;

    if p43 then
        p43.Visible = false;
    end;
end;

function u1._showSlot(p44, p45, p46) -- Line: 181
    if p45 then
        p45 = p45.Frame;
    end;

    if not p45 then
        return;
    end;

    local v47 = p46 - 1;
    local v48 = v47 % p44._columns;
    local v49 = math.floor(v47 / p44._columns);
    p45.Visible = true;
    p45.Position = UDim2.new(0, v48 * p44._rowHeight, 0, v49 * p44._rowHeight);
    p45.Size = UDim2.new(0, p44.CellSize, 0, p44.CellSize);
    p45.LayoutOrder = p46;
end;

function u1.RenderNow(p50) -- Line: 197
    if p50.IsFrozen and p50.IsFrozen() then
        p50._scheduled = false;

        return;
    end;

    if p50._dirtyList then
        p50._dirtyList = false;
        p50:RebuildVisibleSlots();
    end;

    if p50._dirtyLayout then
        p50._dirtyLayout = false;
        p50:_updateLayout();
    end;

    p50:_updateCanvas();
    local v51, v52 = p50:_desiredRange();
    local v53 = {};

    for i = v51, v52 do
        local v54 = p50._visibleSlots[i];

        if v54 then
            v53[v54] = i;
        end;
    end;

    for i in p50._rendered do
        if not v53[i] then
            p50:_hideSlot(i);
            p50._rendered[i] = nil;
        end;
    end;

    for i, v in v53 do
        local v55 = p50._rendered[i];
        p50:_showSlot(i, v);
        p50._rendered[i] = true;

        if not v55 and p50.OnShowSlot then
            p50.OnShowSlot(i);
        end;
    end;

    p50._scheduled = false;
end;

function u1.RequestRender(u56) -- Line: 242
    if u56._scheduled then
        return;
    end;

    u56._scheduled = true;
    task.defer(function() -- Line: 247
        -- upvalues: u56 (copy)
        u56:RenderNow();
    end);
end;

function u1.ClearAll(p57) -- Line: 252
    for i in p57._rendered do
        p57:_hideSlot(i);
        p57._rendered[i] = nil;
    end;
end;

return u1;