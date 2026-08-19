-- Decompiled with Potassium's decompiler.

local v1 = {};
local SettingDropdown = require(script.Parent.SettingDropdown);

function v1.create(p2) -- Line: 53
    -- upvalues: SettingDropdown (copy)
    local dropdownState = p2.dropdownState;
    local UIMgr = p2.UIMgr;
    local AddListen = p2.AddListen;
    local CfgFind = p2.CfgFind;
    local TranslationHelper = p2.TranslationHelper;
    local TipsModule = p2.TipsModule;
    local NetWork = p2.NetWork;
    local NetMsg = p2.NetMsg;
    local LocalPlayer = p2.LocalPlayer;
    local PlayerData = p2.PlayerData;
    local SlideBar = p2.SlideBar;
    local pushSettingChange = p2.pushSettingChange;
    local settingConf = p2.settingConf;
    local Title = p2.EnumMgr.ItemType.Title;
    local u3 = nil;
    local u4 = false;
    local u5 = {};

    local function _getSettingNumberValue(p6) -- Line: 74
        -- upvalues: LocalPlayer (copy)
        local Setting = LocalPlayer:FindFirstChild("Setting");

        if not Setting then
            return nil;
        end;

        local v7 = Setting:FindFirstChild(p6);

        if v7 and v7:IsA("NumberValue") then
            return v7;
        end;

        return nil;
    end;

    local function _bindNumberValue(p8, p9) -- Line: 86
        -- upvalues: LocalPlayer (copy), u5 (copy)
        local Setting = LocalPlayer:FindFirstChild("Setting");
        local v10;

        if Setting then
            v10 = Setting:FindFirstChild(p8);

            if not (v10 and v10:IsA("NumberValue")) then
                v10 = nil;
            end;
        else
            v10 = nil;
        end;

        if v10 then
            p9(v10);

            return;
        end;

        table.insert(u5, {
            showName = p8,
            bindFn = p9
        });
    end;

    local function _collectOwnedTitleOptions() -- Line: 113
        -- upvalues: PlayerData (copy), LocalPlayer (copy), Title (copy), CfgFind (copy)
        local v11 = {};
        local v12 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

        if type(v12) == "table" then
            local v13 = {};

            for _, v in pairs(v12) do
                if type(v) == "table" and v.tp == Title then
                    local v14 = tonumber(v.id);

                    if v14 and not v13[v14] then
                        v13[v14] = true;
                        local v15 = CfgFind.FindCfgByID(v14, Title);
                        local v16 = v15 and (v15.ZhName and v15.ZhName) or "#" .. tostring(v14);
                        table.insert(v11, {
                            id = v14,
                            name = v16
                        });
                    end;
                end;
            end;
        end;

        table.sort(v11, function(p17, p18) -- Line: 130
            return p17.id < p18.id;
        end);
        local v19 = { "无" };
        local v20 = { 0 };

        for _, v in ipairs(v11) do
            table.insert(v19, v.name);
            table.insert(v20, v.id);
        end;

        return v19, v20;
    end;

    local function _syncEquipTitleDisplay(p21, p22, p23, p24) -- Line: 142
        -- upvalues: TranslationHelper (copy), UIMgr (copy), CfgFind (copy), Title (copy)
        if not p22 then
            return;
        end;

        for i, v in ipairs(p24) do
            if v == p21 then
                TranslationHelper.SetText(p22, p23[i]);
                UIMgr.ApplyTitleTextByTitleId(p22, p21);

                return;
            end;
        end;

        if p21 == 0 then
            TranslationHelper.SetText(p22, p23[1]);
            UIMgr.ApplyTitleTextByTitleId(p22, 0);

            return;
        end;

        local v25 = CfgFind.FindCfgByID(p21, Title);

        if v25 and v25.ZhName then
            TranslationHelper.SetText(p22, v25.ZhName);
        else
            TranslationHelper.SetText(p22, p23[1]);
        end;

        UIMgr.ApplyTitleTextByTitleId(p22, p21);
    end;

    local function _bindInputRow(p26, p27) -- Line: 167
        -- upvalues: TranslationHelper (copy)
        local Input = p27:FindFirstChild("Input");

        if Input then
            Input = Input:FindFirstChildOfClass("TextBox");
        end;

        local ZhDes = p26.ZhDes;
        local v28 = (type(ZhDes) ~= "table" or (not ZhDes[1] or (type(ZhDes[1]) ~= "string" or ZhDes[1] == ""))) and "在此输入" or ZhDes[1];

        if Input then
            TranslationHelper.SetText(Input, v28);
        end;
    end;

    local function _setupEquipTitleRow(u29, p30, u31, u32) -- Line: 345
        -- upvalues: dropdownState (copy), SettingDropdown (ref), _collectOwnedTitleOptions (copy), TranslationHelper (copy), UIMgr (copy), AddListen (copy), pushSettingChange (copy), _syncEquipTitleDisplay (copy), u3 (ref)
        local SortFrame = p30:FindFirstChild("SortFrame");

        if not SortFrame then
            return;
        end;

        local ScrollSort = SortFrame:FindFirstChild("ScrollSort");
        local SortTitle = SortFrame:FindFirstChild("SortTitle");

        if not (ScrollSort and SortTitle) then
            return;
        end;

        local Btn = SortTitle:FindFirstChild("Btn");
        local SortName = SortTitle:FindFirstChild("SortName");
        local SortTemp = ScrollSort:FindFirstChild("SortTemp");

        if not (SortTemp and Btn) then
            return;
        end;

        local u33 = {};
        local u34 = {};

        local function rebuild() -- Line: 365
            -- upvalues: dropdownState (ref), ScrollSort (copy), SettingDropdown (ref), SortTemp (copy), _collectOwnedTitleOptions (ref), u33 (ref), u34 (ref), TranslationHelper (ref), UIMgr (ref), AddListen (ref), SortName (copy), pushSettingChange (ref), u31 (copy), SortFrame (copy), _syncEquipTitleDisplay (ref), u29 (copy)
            if dropdownState.openDropdownScroll == ScrollSort then
                dropdownState.openDropdownScroll = nil;
            end;

            SettingDropdown.clearDynamicChildren(ScrollSort, SortTemp);
            local v35, v36 = _collectOwnedTitleOptions();
            u33 = v35;
            u34 = v36;
            SortTemp.Visible = false;

            for i, v in ipairs(v35) do
                local v37 = SortTemp:Clone();
                v37.Visible = true;
                v37.Parent = ScrollSort;
                v37.Name = "Opt_" .. tostring(i);
                local Btn2 = v37:FindFirstChild("Btn");
                local SortName2 = v37:FindFirstChild("SortName");
                local u38 = v36[i];

                if SortName2 then
                    TranslationHelper.SetText(SortName2, v);
                    UIMgr.ApplyTitleTextByTitleId(SortName2, u38);
                end;

                if Btn2 then
                    AddListen.AddMouseCLick(Btn2, function() -- Line: 387
                        -- upvalues: SortName (ref), TranslationHelper (ref), v (copy), UIMgr (ref), u38 (copy), pushSettingChange (ref), u31 (ref), SettingDropdown (ref), dropdownState (ref)
                        if SortName then
                            TranslationHelper.SetText(SortName, v);
                            UIMgr.ApplyTitleTextByTitleId(SortName, u38);
                        end;

                        pushSettingChange(u31, u38);
                        SettingDropdown.closeAny(dropdownState);
                    end, v37);
                end;
            end;

            SettingDropdown.layoutScrollSort(UIMgr, SortFrame, ScrollSort);
            ScrollSort.Visible = false;
            local Size = ScrollSort.Size;
            ScrollSort.Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, 0);
            SettingDropdown.syncCatZIndex(dropdownState, nil);
            _syncEquipTitleDisplay(u29.Value, SortName, v35, v36);
        end;

        rebuild();
        u3 = rebuild;
        AddListen.NumValueAdd(u29, function(p39) -- Line: 408
            -- upvalues: _syncEquipTitleDisplay (ref), SortName (copy), u33 (ref), u34 (ref), ScrollSort (copy), SettingDropdown (ref), UIMgr (ref), SortFrame (copy)
            _syncEquipTitleDisplay(p39, SortName, u33, u34);

            if ScrollSort.Visible then
                SettingDropdown.layoutScrollSort(UIMgr, SortFrame, ScrollSort);
            end;
        end);
        AddListen.AddMouseCLick(Btn, function() -- Line: 415
            -- upvalues: ScrollSort (copy), SettingDropdown (ref), dropdownState (ref), rebuild (copy), UIMgr (ref), SortFrame (copy), u32 (copy)
            if ScrollSort.Visible then
                SettingDropdown.closeAny(dropdownState);

                return;
            end;

            rebuild();
            SettingDropdown.closeAny(dropdownState);
            ScrollSort.Visible = true;
            SettingDropdown.layoutScrollSort(UIMgr, SortFrame, ScrollSort);
            SettingDropdown.syncCatZIndex(dropdownState, u32);
            dropdownState.openDropdownScroll = ScrollSort;
        end, SortTitle);
    end;

    return {
        bindToggleRow = function(p40, p41, u42) -- Line: 180, Name: bindToggleRow
            -- upvalues: TranslationHelper (copy), NetWork (copy), NetMsg (copy), AddListen (copy), pushSettingChange (copy), LocalPlayer (copy), u5 (copy)
            local State = p41:FindFirstChild("State");

            if not State then
                return;
            end;

            local OFF = State:FindFirstChild("OFF");
            local ON = State:FindFirstChild("ON");
            local v43;

            if OFF then
                v43 = OFF:FindFirstChild("Button");
            else
                v43 = OFF;
            end;

            local v44;

            if ON then
                v44 = ON:FindFirstChild("Button");
            else
                v44 = ON;
            end;

            local v45;

            if OFF then
                v45 = OFF:FindFirstChild("ShowText");
            else
                v45 = OFF;
            end;

            local v46;

            if ON then
                v46 = ON:FindFirstChild("ShowText");
            else
                v46 = ON;
            end;

            local ZhDes = p40.ZhDes;
            local v47, v48;

            if type(ZhDes) == "table" and (ZhDes[1] and ZhDes[2]) then
                v47 = ZhDes[1];
                v48 = ZhDes[2];
            else
                v47 = "关";
                v48 = "开";
            end;

            if v45 and (v45:IsA("TextLabel") or v45:IsA("TextButton")) then
                TranslationHelper.SetText(v45, v47);
            end;

            if v46 and (v46:IsA("TextLabel") or v46:IsA("TextButton")) then
                TranslationHelper.SetText(v46, v48);
            end;

            local function onHideUiClose() -- Line: 209
                -- upvalues: u42 (copy), NetWork (ref), NetMsg (ref)
                if u42 == "HideUI" then
                    NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Setting", nil, false, true);
                end;
            end;

            if v43 then
                AddListen.AddMouseCLick(v43, function() -- Line: 218
                    -- upvalues: u42 (copy), NetWork (ref), NetMsg (ref), pushSettingChange (ref)
                    if u42 == "HideUI" then
                        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Setting", nil, false, true);
                    end;

                    pushSettingChange(u42, 1);
                end, OFF);
            end;

            if v44 then
                AddListen.AddMouseCLick(v44, function() -- Line: 224
                    -- upvalues: u42 (copy), NetWork (ref), NetMsg (ref), pushSettingChange (ref)
                    if u42 == "HideUI" then
                        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Setting", nil, false, true);
                    end;

                    pushSettingChange(u42, 0);
                end, ON);
            end;

            local function v51(p49) -- Line: 230
                -- upvalues: AddListen (ref), OFF (copy), ON (copy)
                AddListen.NumValueAdd(p49, function(p50) -- Line: 231
                    -- upvalues: OFF (ref), ON (ref)
                    if OFF then
                        OFF.Visible = p50 == 0;
                    end;

                    if ON then
                        ON.Visible = p50 == 1;
                    end;
                end);
            end;

            local Setting = LocalPlayer:FindFirstChild("Setting");
            local v52;

            if Setting then
                v52 = Setting:FindFirstChild(u42);

                if not (v52 and v52:IsA("NumberValue")) then
                    v52 = nil;
                end;
            else
                v52 = nil;
            end;

            if v52 then
                AddListen.NumValueAdd(v52, function(p53) -- Line: 231
                    -- upvalues: OFF (copy), ON (copy)
                    if OFF then
                        OFF.Visible = p53 == 0;
                    end;

                    if ON then
                        ON.Visible = p53 == 1;
                    end;
                end);

                return;
            end;

            table.insert(u5, {
                showName = u42,
                bindFn = v51
            });
        end,

        bindSliderRow = function(p54, u55, u56) -- Line: 242, Name: bindSliderRow
            -- upvalues: SlideBar (copy), pushSettingChange (copy), LocalPlayer (copy), u5 (copy)
            local u57 = u55:FindFirstChild("滑动条");

            if not u57 then
                return;
            end;

            local range = p54.range;

            if type(range) == "table" and (range[1] ~= nil and range[2] ~= nil) then
                u57:SetAttribute("SliderMin", range[1]);
                u57:SetAttribute("SliderMax", range[2]);
            end;

            if u56 == "BGM" or u56 == "EFFECT" then
                u57:SetAttribute("SliderStep", 1);
                u57:SetAttribute("SliderLabelMode", "audio01");
            else
                u57:SetAttribute("SliderStep", 1);
            end;

            if p54.isPecent == 1 then
                u55:SetAttribute("SliderIsPercent", true);
            end;

            local function v59(p58) -- Line: 261
                -- upvalues: SlideBar (ref), u57 (copy), u55 (copy), pushSettingChange (ref), u56 (copy)
                SlideBar.Bind(u57, u55, p58, pushSettingChange, u56);
            end;

            local Setting = LocalPlayer:FindFirstChild("Setting");
            local v60;

            if Setting then
                v60 = Setting:FindFirstChild(u56);

                if not (v60 and v60:IsA("NumberValue")) then
                    v60 = nil;
                end;
            else
                v60 = nil;
            end;

            if v60 then
                SlideBar.Bind(u57, u55, v60, pushSettingChange, u56);

                return;
            end;

            table.insert(u5, {
                showName = u56,
                bindFn = v59
            });
        end,

        bindChooseRow = function(p61, p62, u63, u64) -- Line: 266, Name: bindChooseRow
            -- upvalues: TranslationHelper (copy), AddListen (copy), pushSettingChange (copy), SettingDropdown (ref), dropdownState (copy), UIMgr (copy), LocalPlayer (copy), u5 (copy)
            local SortFrame = p62:FindFirstChild("SortFrame");

            if not SortFrame then
                return;
            end;

            local ScrollSort = SortFrame:FindFirstChild("ScrollSort");
            local SortTitle = SortFrame:FindFirstChild("SortTitle");

            if not (ScrollSort and SortTitle) then
                return;
            end;

            local Btn = SortTitle:FindFirstChild("Btn");
            local SortName = SortTitle:FindFirstChild("SortName");
            local SortTemp = ScrollSort:FindFirstChild("SortTemp");

            if not (SortTemp and Btn) then
                return;
            end;

            local ZhDes = p61.ZhDes;
            local u65 = {};

            if type(ZhDes) == "table" then
                for _, v in ipairs(ZhDes) do
                    if type(v) == "string" then
                        table.insert(u65, v);
                    end;
                end;
            end;

            if #u65 == 0 then
                return;
            end;

            SortTemp.Visible = false;

            for i, v in ipairs(u65) do
                local u66 = i - 1;
                local v67 = SortTemp:Clone();
                v67.Visible = true;
                v67.Parent = ScrollSort;
                v67.Name = "Opt_" .. tostring(u66);
                local Btn2 = v67:FindFirstChild("Btn");
                local SortName2 = v67:FindFirstChild("SortName");

                if SortName2 then
                    TranslationHelper.SetText(SortName2, v);
                end;

                if Btn2 then
                    AddListen.AddMouseCLick(Btn2, function() -- Line: 309
                        -- upvalues: SortName (copy), TranslationHelper (ref), v (copy), pushSettingChange (ref), u63 (copy), u66 (copy), SettingDropdown (ref), dropdownState (ref)
                        if SortName then
                            TranslationHelper.SetText(SortName, v);
                        end;

                        pushSettingChange(u63, u66);
                        SettingDropdown.closeAny(dropdownState);
                    end, v67);
                end;
            end;

            SettingDropdown.layoutScrollSort(UIMgr, SortFrame, ScrollSort);
            local Size = ScrollSort.Size;
            ScrollSort.Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, 0);
            ScrollSort.Visible = false;
            AddListen.AddMouseCLick(Btn, function() -- Line: 322
                -- upvalues: ScrollSort (copy), SettingDropdown (ref), dropdownState (ref), UIMgr (ref), SortFrame (copy), u64 (copy)
                if ScrollSort.Visible then
                    SettingDropdown.closeAny(dropdownState);

                    return;
                end;

                SettingDropdown.closeAny(dropdownState);
                ScrollSort.Visible = true;
                SettingDropdown.layoutScrollSort(UIMgr, SortFrame, ScrollSort);
                SettingDropdown.syncCatZIndex(dropdownState, u64);
                dropdownState.openDropdownScroll = ScrollSort;
            end, SortTitle);

            local function v71(p68) -- Line: 334
                -- upvalues: AddListen (ref), u65 (copy), SortName (copy), TranslationHelper (ref), SettingDropdown (ref), UIMgr (ref), SortFrame (copy), ScrollSort (copy)
                AddListen.NumValueAdd(p68, function(p69) -- Line: 335
                    -- upvalues: u65 (ref), SortName (ref), TranslationHelper (ref), SettingDropdown (ref), UIMgr (ref), SortFrame (ref), ScrollSort (ref)
                    local v70 = u65[p69 + 1];

                    if v70 and SortName then
                        TranslationHelper.SetText(SortName, v70);
                    end;

                    SettingDropdown.layoutScrollSort(UIMgr, SortFrame, ScrollSort);
                end);
            end;

            local Setting = LocalPlayer:FindFirstChild("Setting");
            local v72;

            if Setting then
                v72 = Setting:FindFirstChild(u63);

                if not (v72 and v72:IsA("NumberValue")) then
                    v72 = nil;
                end;
            else
                v72 = nil;
            end;

            if v72 then
                AddListen.NumValueAdd(v72, function(p73) -- Line: 335
                    -- upvalues: u65 (copy), SortName (copy), TranslationHelper (ref), SettingDropdown (ref), UIMgr (ref), SortFrame (copy), ScrollSort (copy)
                    local v74 = u65[p73 + 1];

                    if v74 and SortName then
                        TranslationHelper.SetText(SortName, v74);
                    end;

                    SettingDropdown.layoutScrollSort(UIMgr, SortFrame, ScrollSort);
                end);

                return;
            end;

            table.insert(u5, {
                showName = u63,
                bindFn = v71
            });
        end,

        bindEquipTitleRow = function(u75, u76, u77) -- Line: 429, Name: bindEquipTitleRow
            -- upvalues: LocalPlayer (copy), _setupEquipTitleRow (copy), u5 (copy)
            local Setting = LocalPlayer:FindFirstChild("Setting");
            local v78;

            if Setting then
                v78 = Setting:FindFirstChild(u76);

                if not (v78 and v78:IsA("NumberValue")) then
                    v78 = nil;
                end;
            else
                v78 = nil;
            end;

            if v78 then
                _setupEquipTitleRow(v78, u75, u76, u77);

                return;
            end;

            local function v80(p79) -- Line: 434
                -- upvalues: _setupEquipTitleRow (ref), u75 (copy), u76 (copy), u77 (copy)
                _setupEquipTitleRow(p79, u75, u76, u77);
            end;

            local Setting2 = LocalPlayer:FindFirstChild("Setting");
            local v81;

            if Setting2 then
                v81 = Setting2:FindFirstChild(u76);

                if not (v81 and v81:IsA("NumberValue")) then
                    v81 = nil;
                end;
            else
                v81 = nil;
            end;

            if v81 then
                _setupEquipTitleRow(v81, u75, u76, u77);

                return;
            end;

            table.insert(u5, {
                showName = u76,
                bindFn = v80
            });
        end,

        bindCodeRow = function(p82, p83, p84) -- Line: 440, Name: bindCodeRow
            -- upvalues: _bindInputRow (copy), TranslationHelper (copy), AddListen (copy), NetWork (copy), NetMsg (copy), TipsModule (copy), LocalPlayer (copy)
            if p84 ~= "Code" then
                _bindInputRow(p82, p83);

                return;
            end;

            local Input = p83:FindFirstChild("Input");

            if Input then
                Input = Input:FindFirstChildOfClass("TextBox");
            end;

            local BtnFrame = p83:FindFirstChild("BtnFrame");
            local v85;

            if BtnFrame then
                v85 = BtnFrame:FindFirstChild("Btn") or BtnFrame:FindFirstChild("Button");
            else
                v85 = BtnFrame;
            end;

            local ZhDes = p82.ZhDes;
            local v86 = (type(ZhDes) ~= "table" or (not ZhDes[1] or (type(ZhDes[1]) ~= "string" or ZhDes[1] == ""))) and "在此输入" or ZhDes[1];

            if Input then
                Input.Text = "";
                TranslationHelper.SetText(Input, v86);
            end;

            if v85 then
                AddListen.AddMouseCLick(v85, function() -- Line: 459
                    -- upvalues: Input (copy), NetWork (ref), NetMsg (ref), TipsModule (ref), LocalPlayer (ref)
                    local u87 = Input and Input.Text or "";

                    if string.len(u87) > 0 and string.len(u87) <= 50 then
                        local success, result = pcall(function() -- Line: 462
                            -- upvalues: NetWork (ref), NetMsg (ref), u87 (copy)
                            return NetWork.InvokeServer(NetMsg.REDEEM_CODE, string.upper(u87));
                        end);

                        if success and result then
                            if Input then
                                Input.Text = "";
                            end;
                        elseif not success then
                            TipsModule.ErrorTips(LocalPlayer, "兑换失败请稍后重试", nil);
                        end;
                    else
                        TipsModule.ErrorTips(LocalPlayer, "兑换码不能为空", nil);
                    end;
                end, BtnFrame);
            end;
        end,

        flushDeferredNvBinds = function() -- Line: 480, Name: flushDeferredNvBinds
            -- upvalues: LocalPlayer (copy), u5 (copy)
            local Setting = LocalPlayer:FindFirstChild("Setting");

            if not Setting then
                return;
            end;

            local v88 = 1;

            while v88 <= #u5 do
                local v89 = u5[v88];
                local v90 = Setting:FindFirstChild(v89.showName);

                if v90 and v90:IsA("NumberValue") then
                    v89.bindFn(v90);
                    table.remove(u5, v88);
                else
                    v88 = v88 + 1;
                end;
            end;
        end,

        getEquipTitleRebuild = function() -- Line: 519, Name: getEquipTitleRebuild
            -- upvalues: u3 (ref)
            return u3;
        end,

        registerBagSync = function() -- Line: 498, Name: registerBagSync
            -- upvalues: u4 (ref), PlayerData (copy), u3 (ref)
            if u4 then
                return;
            end;

            u4 = true;
            PlayerData.ListenClientSync(function(p91, p92) -- Line: 503
                -- upvalues: u3 (ref)
                if (p91 == nil or (p91 == "Bag" or type(p91) == "table" and p91[1] == "Bag")) and u3 then
                    u3();
                end;
            end);
        end,

        collectVisibleRows = function() -- Line: 95, Name: _collectVisibleRows
            -- upvalues: settingConf (copy)
            local v93 = {};

            for i, v in pairs(settingConf) do
                if v.isShow == 1 then
                    table.insert(v93, {
                        id = i,
                        v = v
                    });
                end;
            end;

            table.sort(v93, function(p94, p95) -- Line: 102
                local v96 = p94.v.SetType or 0;
                local v97 = p95.v.SetType or 0;

                if v96 == v97 then
                    return p94.id < p95.id;
                end;

                return v96 < v97;
            end);

            return v93;
        end
    };
end;

return v1;