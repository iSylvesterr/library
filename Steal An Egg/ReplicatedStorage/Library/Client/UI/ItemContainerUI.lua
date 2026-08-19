-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local GuiService = game:GetService("GuiService");
local Library = ReplicatedStorage:WaitForChild("Library");
local Client = Library:WaitForChild("Client");
local Asserts = require(Library.Asserts);
local Functions = require(Library.Functions);
local ButtonFX = require(Client.GUIFX.ButtonFX);
local CircularSelection = require(Client.GUIFX.CircularSelection);
local AutoGridLayout = require(ReplicatedStorage.Library.Client.AutoGridLayout);
local ScreenResolution = require(Client.ScreenResolution);
require(Library.Items.AbstractItem);
local u1 = {};
u1.__index = u1;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};

local function getPerContainerResolutionSettings(p6) -- Line: 196
    return p6[1].ResolutionThreshold ~= nil and { p6 } or p6;
end;

u2.SelectionMode = {
    DISABLED = 0,
    SINGULAR = 1,
    UNLIMITED = 2,
    CUSTOM = 3
};
local u7 = Functions.Values(u2.SelectionMode);
u2.QuantityMode = {
    NORMAL = 1,
    BINARY = 2
};
local u8 = Functions.Values(u2.QuantityMode);
u2.EventMode = {
    INSTANT = 1,
    ON_RELEASE = 2
};
local u9 = Functions.Values(u2.EventMode);
u2.Comparators = {
    Default = function(p10, p11) -- Line: 241, Name: Default
        return p10:CompareTo(p11) < 0;
    end,

    RaritySorted = function(p12, p13) -- Line: 244, Name: RaritySorted
        local v14 = p12:GetRarity();
        local v15 = p13:GetRarity();

        if v14 == v15 then
            return p12:CompareTo(p13) < 0;
        end;

        return v15.RarityNumber < v14.RarityNumber;
    end,

    IdNameSorted = function(p16, p17) -- Line: 252, Name: IdNameSorted
        local v18, v19 = p16:GetId():match("(%D*)(%d*)");
        local v20 = tonumber(v19);
        local v21, v22 = p17:GetId():match("(%D*)(%d*)");
        local v23 = tonumber(v22);

        if v20 and v23 then
            if v20 == v23 then
                return v18 < v21;
            end;

            return v23 < v20;
        end;

        if v20 then
            return true;
        end;

        if v23 then
            return false;
        end;

        return p16:GetId() < p17:GetId();
    end
};

local function defaultSearchFilter(p24, p25) -- Line: 273
    -- upvalues: Functions (copy)
    if #p24 == 0 then
        return true;
    end;

    local v26 = Functions.RegexEscape(p24:lower());

    if p25:GetName():lower():find(v26) then
        return true;
    end;

    if p25:GetRarity().DisplayName:lower():find(v26) then
        return true;
    end;

    local v27 = p25:GetNickname();

    return v27 and v27:lower():find(v26) and true or false;
end;

u2.DefaultSearchFilter = defaultSearchFilter;
local u35 = {
    SelectionIncrement = 1,
    RetainSearchOnClose = false,
    Navigator = nil,
    PageSize = 100,

    Comparator = function(p28, p29) -- Line: 298, Name: Comparator
        return p28:GetUID() < p29:GetUID();
    end,

    Permitted = function(p30) -- Line: 301, Name: Permitted
        return true;
    end,

    SelectionPermitted = function(p31) -- Line: 304, Name: SelectionPermitted
        return true;
    end,

    ModifiedCount = function(p32) -- Line: 307, Name: ModifiedCount
        return p32:GetAmount();
    end,

    ContainerSelect = function(p33) -- Line: 310, Name: ContainerSelect
        return 1;
    end,

    Creator = function(p34) -- Line: 313, Name: Creator
        error("Unimplemented");

        return nil;
    end,

    ResolutionSettings = {
        {
            ResolutionThreshold = 0.65,
            PerRow = 3,
            Padding = UDim2.fromOffset(11, 11)
        },
        {
            ResolutionThreshold = 1.2,
            PerRow = 4,
            Padding = UDim2.fromOffset(14, 14)
        },
        {
            ResolutionThreshold = (1 / 0),
            PerRow = 4,
            Padding = UDim2.fromOffset(20, 20)
        }
    },
    SelectionMode = u2.SelectionMode.UNLIMITED,
    QuantityMode = u2.QuantityMode.NORMAL,
    EventMode = u2.EventMode.INSTANT,
    SearchFilter = defaultSearchFilter
};

function u1.SetMaximumSelectedStacks(p36, p37) -- Line: 344
    p36.setting.MaxSelectedStacks = p37;
end;

function u1.initCircularSelection(u38, p39, p40, p41, u42, p43, p44, u45) -- Line: 348
    -- upvalues: CircularSelection (copy), u2 (copy)
    local v49, v50, v51, v52, u53 = CircularSelection.Add(p39, p40, math.min(p40, p41), function(u46) -- Line: 362
        -- upvalues: u38 (copy), u2 (ref), u42 (copy)
        if u46.selected then
            if u38.setting.SelectionMode == u2.SelectionMode.UNLIMITED then
                if u38.setting.MaxSelectedStacks then
                    local v47 = 0;

                    for _, v in pairs(u38.selectionState) do
                        if v > 0 then
                            v47 = v47 + 1;
                        end;
                    end;

                    if u38.setting.MaxSelectedStacks <= v47 then
                        u38.circularSelections[u42].stop();

                        return;
                    end;
                end;
            elseif u38.setting.SelectionMode == u2.SelectionMode.SINGULAR then
                for i, v in pairs(u38.circularSelections) do
                    if i ~= u42 then
                        v.stop();
                    end;
                end;

                u38.selectionState = {};
            end;
        else
            for i, v in pairs(u38.circularSelections) do
                if i ~= u42 then
                    v.enable(true);
                end;
            end;
        end;

        local u48 = u38.selectionState[u42] or 0;
        u38.selectionState[u42] = u46.quantity;

        for _, v in ipairs(u38.selectionListeners) do
            task.spawn(function() -- Line: 397
                -- upvalues: v (copy), u38 (ref)
                v(u38.selectionState, u38);
            end);
        end;

        for _, v in ipairs(u38.itemListeners) do
            task.spawn(function() -- Line: 403
                -- upvalues: v (copy), u42 (ref), u46 (copy), u48 (copy)
                v(u42, u46.quantity, u48);
            end);
        end;
    end, p43, p44);
    u38.circularSelections[u42] = {
        kill = v49,
        stop = v50,
        enable = v51,
        lock = v52,
        force = u53
    };

    if u45 then
        task.spawn(function() -- Line: 421
            -- upvalues: u53 (copy), u45 (copy)
            u53(u45, true);
        end);
    end;
end;

function u1.getRenderContainer(p54, p55) -- Line: 427
    -- upvalues: Asserts (copy)
    local ContainerSelect = p54.setting.ContainerSelect;
    assert(ContainerSelect, "ContainerSelect is not provided in settings");
    local v56 = ContainerSelect(p55);
    Asserts.positiveInteger(v56);
    assert(v56 <= #p54.containers, "ContainerSelect returned an index out of bounds");
    local v57 = p54.containers[v56];
    assert(v57, "Render container does not exist");

    return v57;
end;

function u1.getScrollingFrame(p58) -- Line: 440
    local v59 = p58.containers[1];
    assert(v59, "No container found to retrieve ScrollingFrame");

    if v59:IsA("ScrollingFrame") then
        return v59;
    end;

    return v59:FindFirstAncestorOfClass("ScrollingFrame");
end;

function u1.getScreenGui(p60) -- Line: 449
    local v61 = p60.containers[1];
    assert(v61, "No container found to retrieve ScreenGui");

    return v61:FindFirstAncestorOfClass("ScreenGui");
end;

function u1.upsertRender(p62, p63, p64, p65) -- Line: 455
    -- upvalues: u2 (copy), GuiService (copy), RunService (copy)
    local SelectionIncrement = p62.setting.SelectionIncrement;
    assert(SelectionIncrement, "SelectionIncrement is not provided in settings");
    local ModifiedCount = p62.setting.ModifiedCount;
    assert(ModifiedCount, "ModifiedCount is not provided in settings");
    local SelectionPermitted = p62.setting.SelectionPermitted;
    assert(SelectionPermitted, "SelectionPermitted is not provided in settings");
    local v66 = p63:GetUID();

    if p62.renders[v66] then
        return false;
    end;

    local v67 = ModifiedCount(p63);

    if v67 <= 0 then
        return false;
    end;

    p62.items[v66] = p63;
    local v68 = p62.setting.Creator(p63);
    local Quantity = v68:FindFirstChild("Quantity");

    if Quantity and Quantity:IsA("TextLabel") then
        Quantity.Text = `x{v67}`;
        local HideQuantity = p62.setting.HideQuantity;

        if type(HideQuantity) == "boolean" then
            Quantity.Visible = not HideQuantity;
        elseif type(HideQuantity) == "function" then
            Quantity.Visible = not HideQuantity(p63, v67);
        end;
    end;

    if p64 then
        v68.LayoutOrder = p64;
    end;

    if p62.setting.SearchBar and p62.setting.SearchFilter then
        if p65 == nil then
            p65 = p62.setting.SearchFilter(p62.setting.SearchBar.Text, p63);
        end;
    else
        p65 = true;
    end;

    v68.Visible = p65;
    v68.Parent = p62:getRenderContainer(p63);
    p62.renders[v66] = {
        render = v68,
        quantity = v67
    };
    local v69;

    if p63:IsA("Pet") then
        v69 = p63:IsTitanic() or p63:IsHuge();
    else
        v69 = false;
    end;

    local v70;

    if p62.setting.QuantityMode == u2.QuantityMode.BINARY then
        v70 = 1;
    elseif p62.setting.ModifiedCount == nil then
        v70 = p63:GetAmount();
    else
        v70 = p62.setting.ModifiedCount(p63);
    end;

    local v71 = p62.setting.EventMode == u2.EventMode.INSTANT;

    if p62.setting.SelectionMode ~= u2.SelectionMode.DISABLED then
        if typeof(SelectionIncrement) == "function" then
            SelectionIncrement = SelectionIncrement(p63);
        end;

        if SelectionIncrement <= v70 and SelectionPermitted(p63) then
            local v72;

            if p62.selectionState[v66] and p62.selectionState[v66] > 0 then
                v72 = p62.selectionState[v66];
            else
                v72 = nil;
            end;

            p62:initCircularSelection(v68, v70, SelectionIncrement, v66, v71, v69, v72);
        end;
    end;

    if p62.lastDeletedConsoleUID and p62.lastDeletedConsoleTimestamp then
        local v73;

        if p62.lastDeletedConsoleUID == v66 then
            v73 = tick() - p62.lastDeletedConsoleTimestamp < 0.1;
        else
            v73 = false;
        end;

        if v73 then
            GuiService.SelectedObject = v68;

            if p62.lastDeletedConsoleCanvasPosition and p62:getScrollingFrame() then
                task.spawn(function() -- Line: 555
                    -- upvalues: RunService (ref)
                    RunService.RenderStepped:Wait();
                    RunService.RenderStepped:Wait();
                    RunService.RenderStepped:Wait();
                    RunService.RenderStepped:Wait();
                    RunService.RenderStepped:Wait();
                end);
            end;
        end;
    end;

    return true;
end;

function u1.resort(u74, p75) -- Line: 569
    local Comparator = u74.setting.Comparator;
    assert(Comparator, "Comparator is not provided in settings");

    if p75 == nil then
        p75 = false;
    end;

    local v76 = {};

    for i, v in pairs(u74.renders) do
        table.insert(v76, {
            uid = i,
            activeRender = v
        });
    end;

    if p75 then
        table.sort(v76, function(p77, p78) -- Line: 586
            -- upvalues: u74 (copy), Comparator (copy)
            local v79 = (u74.selectionState[p77.uid] or 0) > 0;

            if v79 == ((u74.selectionState[p78.uid] or 0) > 0) then
                return Comparator(u74.items[p77.uid], u74.items[p78.uid]);
            end;

            return v79;
        end);
    else
        table.sort(v76, function(p80, p81) -- Line: 595
            -- upvalues: Comparator (copy), u74 (copy)
            return Comparator(u74.items[p80.uid], u74.items[p81.uid]);
        end);
    end;

    for i, v in ipairs(v76) do
        local v82 = v76[i - 1];
        local v83 = v76[i + 1];
        local activeRender = v.activeRender;

        if activeRender.render.LayoutOrder ~= i then
            activeRender.render.LayoutOrder = i;
        end;

        activeRender.nextUID = v83 and v83.uid or nil;
        activeRender.prevUID = v82 and v82.uid or nil;
    end;
end;

function u1.deleteRender(p84, p85) -- Line: 612
    -- upvalues: GuiService (copy)
    local v86 = p84.renders[p85];

    if not v86 then
        return;
    end;

    if p84.circularSelections[p85] then
        p84.circularSelections[p85].kill();
        p84.circularSelections[p85] = nil;
    end;

    if GuiService.SelectedObject and (GuiService.SelectedObject == v86.render or GuiService.SelectedObject:IsDescendantOf(v86.render)) then
        p84.lastDeletedConsoleUID = p85;
        p84.lastDeletedConsoleTimestamp = tick();
        local v87 = p84:getScrollingFrame();

        if v87 then
            p84.lastDeletedConsoleCanvasPosition = v87.CanvasPosition;
        else
            p84.lastDeletedConsoleCanvasPosition = nil;
        end;

        local v88;

        if v86.nextUID then
            v88 = p84.renders[v86.nextUID] or nil;
        else
            v88 = nil;
        end;

        local v89;

        if v86.prevUID then
            v89 = p84.renders[v86.prevUID] or nil;
        else
            v89 = nil;
        end;

        if v88 then
            GuiService.SelectedObject = v88.render;
        elseif v89 then
            GuiService.SelectedObject = v89.render;
        end;
    end;

    local v90;

    if v86.prevUID then
        v90 = p84.renders[v86.prevUID] or nil;
    else
        v90 = nil;
    end;

    local v91;

    if v86.nextUID then
        v91 = p84.renders[v86.nextUID] or nil;
    else
        v91 = nil;
    end;

    if v90 and v91 then
        v90.nextUID = v86.nextUID;
        v91.prevUID = v86.prevUID;
    elseif v90 and not v91 then
        v90.nextUID = nil;
    elseif v91 and not v90 then
        v91.prevUID = nil;
    end;

    v86.render:Destroy();
    p84.renders[p85] = nil;
    p84.items[p85] = nil;
end;

function u1.hideRender(p92, p93) -- Line: 665
    local v94 = p92.renders[p93];

    if not v94 then
        return;
    end;

    if p92.circularSelections[p93] then
        p92.circularSelections[p93].stop();
        p92.circularSelections[p93].enable(false);
    end;

    v94.render.Visible = false;
end;

function u1.showRender(p95, p96) -- Line: 679
    local v97 = p95.renders[p96];

    if not v97 then
        return;
    end;

    if p95.circularSelections[p96] then
        p95.circularSelections[p96].enable(true);
    end;

    v97.render.Visible = true;
end;

function u1.SetSelectionAmount(p98, p99, p100) -- Line: 692
    local v101 = p98.circularSelections[p99];

    if v101 then
        v101.force(p100);
    end;
end;

function u1.SetSelectionEnabled(p102, p103) -- Line: 699
    for _, v in pairs(p102.circularSelections) do
        v.lock(not p103);
    end;
end;

function u1.ClearSelection(p104) -- Line: 705
    for _, v in pairs(p104.circularSelections) do
        v.stop();
    end;

    p104.selectionState = {};
end;

function u1.ClearUID(p105, p106) -- Line: 712
    local v107 = p105.circularSelections[p106];

    if v107 then
        v107.stop();
    end;

    p105.selectionState[p106] = nil;
end;

function u1.ReapplyResolution(p108) -- Line: 720
    if p108.autoResolution then
        p108.autoResolution();
    end;
end;

function u1.ChangeResolutionSettings(u109, p110) -- Line: 726
    -- upvalues: AutoGridLayout (copy)
    local v111 = p110[1].ResolutionThreshold ~= nil and { p110 } or p110;
    local u112 = {};

    for i, v in ipairs(u109.containers) do
        local v113 = v111[i];
        assert(v113, "Resolution setting missing for container " .. i);
        table.insert(u112, AutoGridLayout(v, v113));
    end;

    function u109.autoResolution() -- Line: 736
        -- upvalues: u109 (copy), u112 (copy)
        for i, _ in ipairs(u109.containers) do
            local v114 = u112[i];
            assert(v114, "Auto resolution function missing for container " .. i);
            v114();
        end;
    end;

    u109.autoResolution();
end;

function u1.Destroy(p115) -- Line: 747
    -- upvalues: u3 (copy)
    p115:Clear();

    for _, v in p115.searchBarEvents do
        v:Disconnect();
    end;

    p115.searchBarEvents = {};

    for _, v in ipairs(p115.paginationEvents) do
        v:Disconnect();
    end;

    p115.paginationEvents = {};
    u3[p115.uid] = nil;
end;

function u1.Clear(p116) -- Line: 760
    p116.renderThreadUID = p116.renderThreadUID + 1;

    for i in p116.renders do
        p116:deleteRender(i);
    end;

    p116.cachedPopulation = {};
end;

function u1.Refresh(p117, p118) -- Line: 768
    local v119 = false;

    for i, v in pairs(p118 or p117.dirty) do
        local v120 = v:Clone():SetUID(i);

        if not p117.renders[i] then
            return;
        end;

        p117:deleteRender(i);
        p117:upsertRender(v120);
        v119 = true;
    end;

    if v119 then
        p117:resort();
        p117.autoResolution();
    end;

    p117.dirty = {};
end;

function u1.GetFront(p121) -- Line: 786
    local v122 = nil;
    local v123 = (1 / 0);

    for _, v in pairs(p121.renders) do
        if not v122 or v.render.LayoutOrder < v123 then
            v122 = v.render;
            v123 = v.render.LayoutOrder;
        end;
    end;

    return v122;
end;

function u1.GetBack(p124) -- Line: 798
    local v125 = nil;
    local v126 = (-1 / 0);

    for _, v in pairs(p124.renders) do
        if not v125 or v126 < v.render.LayoutOrder then
            v125 = v.render;
            v126 = v.render.LayoutOrder;
        end;
    end;

    return v125;
end;

function u1.GetContainers(p127) -- Line: 810
    return p127.containers;
end;

function u1.IsEmpty(p128) -- Line: 814
    return next(p128.renders) == nil;
end;

function u1.Populate(u129, p130) -- Line: 818
    -- upvalues: u4 (copy), RunService (copy)
    local Permitted = u129.setting.Permitted;
    assert(Permitted, "Permitted is not provided in settings");
    local ModifiedCount = u129.setting.ModifiedCount;
    assert(ModifiedCount, "ModifiedCount is not provided in settings");
    local Comparator = u129.setting.Comparator;
    assert(Comparator, "Comparator is not provided in settings");
    u129.renderThreadUID = u129.renderThreadUID + 1;
    local renderThreadUID = u129.renderThreadUID;
    local u131 = {};
    local u132 = false;

    for i, v in u129.renders do
        local v133 = p130[i];

        if v133 and not u129.dirty[i] then
            if ModifiedCount(v133) <= 0 or not Permitted(v133) then
                u129:deleteRender(i);
            else
                local v134 = u4[v133.Class.Name];
                local v135;

                if v134 then
                    local v136 = v133:GetOptionalUID();

                    if v136 then
                        v135 = v134[v136] == true;
                    else
                        v135 = false;
                    end;
                else
                    v135 = false;
                end;

                if v135 or v.quantity ~= ModifiedCount(v133) then
                    u129:deleteRender(i);
                else
                    u131[i] = true;
                end;
            end;
        else
            u129:deleteRender(i);
        end;
    end;

    u129.cachedPopulation = p130;
    local u137 = {};

    for i, v in p130 do
        if Permitted(v) and (not u129.setting.SearchBar or (not u129.setting.SearchFilter or u129.setting.SearchFilter(u129.setting.SearchBar.Text, v))) then
            local v138 = u4[v.Class.Name];
            local v139;

            if v138 then
                local v140 = v:GetOptionalUID();

                if v140 then
                    v139 = v138[v140] == true;
                else
                    v139 = false;
                end;
            else
                v139 = false;
            end;

            if not v139 then
                table.insert(u137, {
                    item = v,
                    uid = i
                });
            end;
        end;
    end;

    if u129.setting.LoadSpeed then
        table.sort(u137, function(p141, p142) -- Line: 869
            -- upvalues: Comparator (copy)
            return Comparator(p141.item, p142.item);
        end);
    end;

    u129.renderCount = #u137;
    local u143, u144;

    if u129.hasPages then
        local pageNumber = u129.pageNumber;
        assert(pageNumber, "Page number is not defined for pagination");
        local PageSize = u129.setting.PageSize;
        assert(PageSize, "PageSize is not defined in settings");
        local v145 = pageNumber;
        u143 = PageSize * (v145 - 1);
        u144 = PageSize * v145 - 1;
        local Navigator = u129.setting.Navigator;
        assert(Navigator, "Navigator is required for pagination");
        local v146 = math.ceil(u129.renderCount / PageSize);
        local v147 = math.max(1, v146);

        if v147 < v145 then
            u129.pageNumber = v147;
            u143 = PageSize * (v147 - 1);
            u144 = PageSize * v147 - 1;
            v145 = v147;
        end;

        Navigator.Left.ImageLabel.ImageTransparency = v145 > 1 and 0 or 0.65;
        Navigator.Right.ImageLabel.ImageTransparency = v145 < v147 and 0 or 0.65;
        Navigator.Visible = v147 > 1;
        Navigator.PageNumber.Text = tostring(v145);
    else
        u143 = nil;
        u144 = nil;
    end;

    local u148 = 0;
    local u149 = false;
    task.spawn(function() -- Line: 910
        -- upvalues: u137 (copy), Permitted (copy), ModifiedCount (copy), u4 (ref), renderThreadUID (copy), u129 (copy), u148 (ref), u143 (ref), u144 (ref), u131 (copy), u132 (ref), u149 (ref), RunService (ref)
        for i, v in ipairs(u137) do
            local item = v.item;
            local uid = v.uid;

            if Permitted(item) and ModifiedCount(item) > 0 then
                local v150 = u4[item.Class.Name];
                local v151;

                if v150 then
                    local v152 = item:GetOptionalUID();

                    if v152 then
                        v151 = v150[v152] == true;
                    else
                        v151 = false;
                    end;
                else
                    v151 = false;
                end;

                if not v151 then
                    if renderThreadUID ~= u129.renderThreadUID then
                        return;
                    end;

                    u148 = u148 + 1;

                    if u143 and u144 then
                        local v153 = u148 - 1;

                        if u143 <= v153 and v153 <= u144 then
                            u131[uid] = nil;
                            local v154 = u129:upsertRender(item, i, true);

                            if v154 then
                                u132 = true;
                            end;

                            if not u149 then
                                u149 = true;

                                if not u129.hasPages then
                                    u129.autoResolution();
                                end;
                            end;

                            if v154 and (u129.setting.LoadSpeed and (u148 % u129.setting.LoadSpeed == 0 and not u129.hasPages)) then
                                RunService.RenderStepped:Wait();
                            end;
                        elseif u144 < v153 then
                            break;
                        end;
                    else
                        u131[uid] = nil;
                        local v155 = u129:upsertRender(item, i, true);

                        if v155 then
                            u132 = true;
                        end;

                        if not u149 then
                            u149 = true;

                            if not u129.hasPages then
                                u129.autoResolution();
                            end;
                        end;

                        if v155 and (u129.setting.LoadSpeed and (u148 % u129.setting.LoadSpeed == 0 and not u129.hasPages)) then
                            RunService.RenderStepped:Wait();
                        end;
                    end;
                end;
            end;
        end;

        if renderThreadUID == u129.renderThreadUID then
            for i in pairs(u131) do
                u129:deleteRender(i);
            end;

            if u132 then
                u129:resort();
            end;

            if u132 then
                if u129.dirtyScreenResolution then
                    task.delay(0.1, function() -- Line: 978
                        -- upvalues: u129 (ref)
                        u129.autoResolution();
                    end);
                else
                    u129.autoResolution();
                end;

                u129.dirtyScreenResolution = false;
            end;

            u129.dirty = {};
        end;
    end);
end;

function u1.GetStackCount(p156) -- Line: 991
    local v157 = 0;

    for _, v in p156.selectionState do
        if v > 0 then
            v157 = v157 + 1;
        end;
    end;

    return v157;
end;

function u1.GetSelection(p158) -- Line: 1001
    return p158.selectionState;
end;

function u1.GetSelectionCount(p159) -- Line: 1005
    local v160 = 0;

    for _, v in p159.selectionState do
        v160 = v160 + v;
    end;

    return v160;
end;

function u1.HasSelection(p161) -- Line: 1013
    for _, v in p161.selectionState do
        if v > 0 then
            return true;
        end;
    end;

    return false;
end;

function u1.Filter(p162, p163) -- Line: 1022
    local v165 = p163 or function(p164) -- Line: 1027
        return true;
    end;

    for i, _ in pairs(p162.renders) do
        local v166 = (p162.selectionState[i] or 0) > 0;
        local v167 = p162.items[i];
        local v168 = "Item not found for uid: " .. tostring(i);
        assert(v167, v168);

        if v165(v167) or v166 then
            p162:showRender(i);
        else
            p162:hideRender(i);
        end;
    end;
end;

function u1.AddSelectionListener(p169, p170) -- Line: 1044
    table.insert(p169.selectionListeners, p170);
end;

function u1.AddItemListener(p171, p172) -- Line: 1051
    table.insert(p171.itemListeners, p172);
end;

function u1.initSearchBar(u173) -- Line: 1058
    local SearchBar = u173.setting.SearchBar;
    assert(SearchBar, "SearchBar is not provided in settings");
    assert(u173.setting.SearchFilter, "SearchFilter is not provided in settings");
    local u174 = u173:getScrollingFrame();
    table.insert(u173.searchBarEvents, SearchBar.Changed:Connect(function(p175) -- Line: 1066
        -- upvalues: SearchBar (copy), u173 (copy), u174 (copy)
        if p175 == "Text" then
            local Text = SearchBar.Text;

            if u173.hasPages and u173.cachedPopulation then
                local cachedPopulation = u173.cachedPopulation;
                u173:Clear();
                u173:Populate(cachedPopulation);
            elseif Text == "" then
                u173:Filter(function(p176) -- Line: 1074
                    return true;
                end);
                u173:resort();
            else
                u173:Filter(function(p177) -- Line: 1079
                    -- upvalues: u173 (ref), Text (copy)
                    return u173.setting.SearchFilter(Text, p177);
                end);
                u173:resort(true);
            end;

            task.delay(0.1, function() -- Line: 1084
                -- upvalues: u174 (ref), u173 (ref)
                if u174 then
                    u173.autoResolution();
                    u174.CanvasPosition = Vector2.new();
                end;
            end);
        end;
    end));
    local u178 = u173:getScreenGui();

    if u178 and not u173.setting.RetainSearchOnClose then
        table.insert(u173.searchBarEvents, u178.Changed:Connect(function(p179) -- Line: 1098
            -- upvalues: u178 (copy), SearchBar (copy), u174 (copy), u173 (copy)
            if p179 == "Enabled" and (u178.Enabled and SearchBar.Text ~= "") then
                SearchBar.Text = "";
                task.delay(0.1, function() -- Line: 1101
                    -- upvalues: u174 (ref), u173 (ref)
                    if u174 then
                        u173.autoResolution();
                        u174.CanvasPosition = Vector2.new();
                    end;
                end);
            end;
        end));
    end;
end;

function u1.requestPageTurn(p180, p181) -- Line: 1113
    assert(p180.hasPages and (p180.pageNumber and p180.setting.PageSize) and p180.setting.Navigator, "Pagination requires a valid Navigator, pageNumber, and PageSize");
    local Navigator = p180.setting.Navigator;
    local PageSize = p180.setting.PageSize;
    local v182 = p180.pageNumber + math.sign(p181);
    local v183 = math.ceil(p180.renderCount / PageSize);

    if v182 < 1 or v183 < v182 then
        return;
    end;

    if p180.cachedPopulation and next(p180.cachedPopulation) then
        Navigator.PageNumber.Text = tostring(v182);
        local u184 = p180:getScrollingFrame();
        local u185, u186;

        if u184 then
            u185 = u184.CanvasPosition;
            local AbsoluteCanvasSize = u184.AbsoluteCanvasSize;
            u186 = u185.Y >= AbsoluteCanvasSize.Y - u184.AbsoluteSize.Y - 10 and true or AbsoluteCanvasSize.Y <= 0;
        else
            u186 = false;
            u185 = nil;
        end;

        p180.pageNumber = v182;
        local cachedPopulation = p180.cachedPopulation;
        p180:Clear();
        p180:Populate(cachedPopulation);

        if u184 then
            task.spawn(function() -- Line: 1146
                -- upvalues: u186 (ref), u184 (copy), u185 (ref)
                if u186 then
                    u184.CanvasPosition = Vector2.new(0, 10000);

                    return;
                end;

                u184.CanvasPosition = u185 or Vector2.new();
            end);
        end;
    end;
end;

function u1.initPagination(u187) -- Line: 1157
    -- upvalues: u5 (copy), ButtonFX (copy)
    local Navigator = u187.setting.Navigator;
    assert(Navigator, "Navigator is not provided in settings for pagination");
    table.insert(u187.paginationEvents, Navigator.Left.Activated:Connect(function() -- Line: 1163
        -- upvalues: u187 (copy)
        u187:requestPageTurn(-1);
    end));
    table.insert(u187.paginationEvents, Navigator.Right.Activated:Connect(function() -- Line: 1169
        -- upvalues: u187 (copy)
        u187:requestPageTurn(1);
    end));

    if not u5[Navigator] then
        u5[Navigator] = true;
        ButtonFX(Navigator.Left);
        ButtonFX(Navigator.Right);
    end;
end;

function u2.new(p188, p189) -- Line: 1181
    -- upvalues: Functions (copy), u35 (copy), u7 (copy), u8 (copy), u9 (copy), AutoGridLayout (copy), u1 (copy), u3 (copy)
    local v190 = Functions.DeepCopy(u35);

    if p189 then
        for i, v in pairs(p189) do
            v190[i] = v;
        end;
    end;

    local v191 = type(v190.RetainSearchOnClose) == "boolean";
    assert(v191, "RetainSearchOnClose must be a boolean");
    assert(v190.Comparator, "Comparator is not provided in settings");
    assert(v190.Permitted, "Permitted is not provided in settings");
    assert(v190.Creator, "Creator is not provided in settings");
    assert(v190.SelectionMode, "SelectionMode is not provided in settings");
    assert(v190.ResolutionSettings, "ResolutionSettings is not provided in settings");
    assert(v190.SearchFilter, "SearchFilter is not provided in settings");
    local v192 = table.find(u7, v190.SelectionMode) ~= nil;
    assert(v192, "Invalid SelectionMode");
    local v193 = table.find(u8, v190.QuantityMode) ~= nil;
    assert(v193, "Invalid QuantityMode");
    local v194 = table.find(u9, v190.EventMode) ~= nil;
    assert(v194, "Invalid EventMode");
    local v195 = v190.Navigator ~= nil;
    local u196 = type(p188) ~= "table" and { p188 } or p188;
    local ResolutionSettings = v190.ResolutionSettings;
    local v197 = ResolutionSettings[1].ResolutionThreshold ~= nil and { ResolutionSettings } or ResolutionSettings;
    local u198 = {};

    for i, v in ipairs(u196) do
        local v199 = v197[i];
        assert(v199, "Resolution setting missing for container " .. i);
        table.insert(u198, AutoGridLayout(v, v199));
    end;

    local function autoResolution() -- Line: 1219
        -- upvalues: u196 (ref), u198 (copy)
        for i, _ in ipairs(u196) do
            local v200 = u198[i];
            assert(v200, "Auto resolution function missing for container " .. i);
            v200();
        end;
    end;

    local v201 = {
        renderThreadUID = 0,
        dirtyScreenResolution = false,
        renderCount = 0,
        containers = u196,
        setting = v190,
        renders = {},
        items = {},
        dirty = {},
        uid = Functions.GenerateUID(),
        autoResolution = autoResolution,
        selectionListeners = {},
        selectionState = {},
        circularSelections = {},
        itemListeners = {},
        searchBarEvents = {},
        paginationEvents = {},
        hasPages = v195,
        pageNumber = v195 and 1 or nil,
        cachedPopulation = {}
    };
    local v202 = setmetatable(v201, u1);
    u3[v202.uid] = v202;

    if v202.setting.SearchBar then
        v202:initSearchBar();
    end;

    if v202.setting.Navigator then
        v202:initPagination();
    end;

    task.defer(v202.autoResolution);

    return v202;
end;

function u2.IsGloballyHidden(p203) -- Line: 203
    -- upvalues: u4 (copy)
    local v204 = u4[p203.Class.Name];

    if not v204 then
        return false;
    end;

    local v205 = p203:GetOptionalUID();

    if v205 then
        return v204[v205] == true;
    end;

    return false;
end;

function u2.SetGloballyHidden(p206, p207) -- Line: 1267
    -- upvalues: u4 (copy)
    local v208 = u4[p206.Class.Name];

    if not v208 then
        v208 = {};
        u4[p206.Class.Name] = v208;
    end;

    local v209 = p206:GetUID();
    local v210 = p207 and true or nil;

    if v208[v209] ~= v210 then
        v208[v209] = v210;
    end;
end;

local u211 = nil;
ScreenResolution.Changed:Connect(function() -- Line: 1283
    -- upvalues: u3 (copy), u211 (ref)
    for _, v in u3 do
        v.dirtyScreenResolution = true;
    end;

    if u211 then
        task.cancel(u211);
    end;

    u211 = task.delay(0.15, function() -- Line: 1292
        -- upvalues: u211 (ref), u3 (ref)
        u211 = nil;

        for _, v in u3 do
            v.autoResolution();
        end;
    end);
end);

return u2;