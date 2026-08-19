-- Decompiled with Potassium's decompiler.

local function adjustThickness(p1, u2) -- Line: 1
    return string.gsub(p1, "(<stroke.-thickness=\"(%d+)\".->)", function(p3) -- Line: 2
        -- upvalues: u2 (copy)
        return string.gsub(p3, "thickness=\"(%d+)\"", function(p4) -- Line: 3
            -- upvalues: u2 (ref)
            local v5 = tonumber(p4);

            if v5 then
                local v6 = u2(v5);
                p4 = tostring(v6);
            end;

            return `thickness="{p4}"`;
        end);
    end);
end;

local u7 = { "rbxassetid://14001321443" };

return function(p8, u9) -- Line: 17
    -- upvalues: u7 (copy)
    local u10 = p8 or {};

    local function getOldAttribute(p11, p12, p13) -- Line: 19
        local v14 = p11:GetAttribute("oldp_" .. p12);

        if not v14 then
            v14 = p13(p11);
            p11:SetAttribute("oldp_" .. p12, v14);
        end;

        assert(v14 ~= nil);

        return v14;
    end;

    local u15 = {};

    local function processElement(p16, u17, p18) -- Line: 30
        -- upvalues: u9 (copy), u10 (copy), u7 (ref), u15 (copy), processElement (copy)
        if u9 and not u9(p16) then
            return false;
        end;

        if p18 then
            for i, _ in pairs(p16:GetAttributes()) do
                if i:sub(0, 5) == "oldp_" then
                    p16:SetAttribute(i, nil);
                end;
            end;
        end;

        local v19 = false;

        if p16:IsA("UIStroke") then
            if u10.Stroke and p16.StrokeSizingMode ~= Enum.StrokeSizingMode.ScaledSize then
                local function getStrokeThickness(p20) -- Line: 223
                    return p20.Thickness;
                end;

                local v21 = p16:GetAttribute("oldp_Thickness");

                if not v21 then
                    v21 = p16.Thickness;
                    p16:SetAttribute("oldp_Thickness", v21);
                end;

                assert(v21 ~= nil);
                p16.Thickness = v21 * u17;
                v19 = true;
            end;
        elseif p16:IsA("TextLabel") then
            if p16.RichText and u10.RichText then
                local Text = p16.Text;
                local v22 = u15[p16];
                local v23 = false;
                local v24;

                if v22 then
                    if v22.text2 == Text then
                        if v22.scale == u17 then
                            v24 = Text;
                        else
                            v24 = v22.text1;
                            v23 = true;
                        end;
                    else
                        v24 = Text;
                        v23 = true;
                    end;
                else
                    v22 = {};
                    u15[p16] = v22;
                    v24 = Text;
                    v23 = true;
                end;

                if v23 then
                    local function u26(p25) -- Line: 210
                        -- upvalues: u17 (copy)
                        return p25 * u17;
                    end;

                    local v31 = string.gsub(v24, "(<stroke.-thickness=\"(%d+)\".->)", function(p27) -- Line: 2
                        -- upvalues: u26 (copy)
                        return string.gsub(p27, "thickness=\"(%d+)\"", function(p28) -- Line: 3
                            -- upvalues: u26 (ref)
                            local v29 = tonumber(p28);

                            if v29 then
                                local v30 = u26(v29);
                                p28 = tostring(v30);
                            end;

                            return `thickness="{p28}"`;
                        end);
                    end);
                    v22.scale = u17;
                    v22.text1 = v24;
                    v22.text2 = v31;

                    if Text == v31 then
                        v19 = true;
                    else
                        p16.Text = v31;
                        v19 = true;
                    end;
                else
                    v19 = true;
                end;
            end;
        elseif p16:IsA("ImageLabel") then
            if p16.ScaleType == Enum.ScaleType.Slice and (not table.find(u7, p16.Image) and u10.NineSlice) then
                local function getSliceScaleImage(p32) -- Line: 180
                    return p32.SliceScale;
                end;

                local v33 = p16:GetAttribute("oldp_SliceScale");

                if not v33 then
                    v33 = p16.SliceScale;
                    p16:SetAttribute("oldp_SliceScale", v33);
                end;

                assert(v33 ~= nil);
                p16.SliceScale = v33 * u17;
                v19 = true;
            end;
        elseif p16:IsA("ImageButton") then
            if p16.ScaleType == Enum.ScaleType.Slice and u10.NineSlice then
                local function getSliceScale(p34) -- Line: 160
                    return p34.SliceScale;
                end;

                local v35 = p16:GetAttribute("oldp_SliceScale");

                if not v35 then
                    v35 = p16.SliceScale;
                    p16:SetAttribute("oldp_SliceScale", v35);
                end;

                assert(v35 ~= nil);
                p16.SliceScale = v35 * u17;
                v19 = true;
            end;
        elseif p16:IsA("UIPadding") then
            if u10.Padding then
                local function getPaddingTop(p36) -- Line: 105
                    return p36.PaddingTop;
                end;

                local v37 = p16:GetAttribute("oldp_PaddingTop");

                if not v37 then
                    v37 = getPaddingTop(p16);
                    p16:SetAttribute("oldp_PaddingTop", v37);
                end;

                assert(v37 ~= nil);

                local function v39(p38) -- Line: 115
                    return p38.PaddingBottom;
                end;

                local v40 = p16:GetAttribute("oldp_PaddingBottom");

                if not v40 then
                    v40 = v39(p16);
                    p16:SetAttribute("oldp_PaddingBottom", v40);
                end;

                assert(v40 ~= nil);

                local function v42(p41) -- Line: 125
                    return p41.PaddingLeft;
                end;

                local v43 = p16:GetAttribute("oldp_PaddingLeft");

                if not v43 then
                    v43 = v42(p16);
                    p16:SetAttribute("oldp_PaddingLeft", v43);
                end;

                assert(v43 ~= nil);

                local function v45(p44) -- Line: 135
                    return p44.PaddingRight;
                end;

                local v46 = p16:GetAttribute("oldp_PaddingRight");

                if not v46 then
                    v46 = v45(p16);
                    p16:SetAttribute("oldp_PaddingRight", v46);
                end;

                assert(v46 ~= nil);
                p16.PaddingTop = UDim.new(v37.Scale, v37.Offset * u17);
                p16.PaddingBottom = UDim.new(v40.Scale, v40.Offset * u17);
                p16.PaddingLeft = UDim.new(v43.Scale, v43.Offset * u17);
                p16.PaddingRight = UDim.new(v46.Scale, v46.Offset * u17);
                v19 = true;
            end;
        elseif p16:IsA("UIListLayout") then
            if u10.List then
                local function getPadding(p47) -- Line: 90
                    return p47.Padding;
                end;

                local v48 = p16:GetAttribute("oldp_Padding");

                if not v48 then
                    v48 = p16.Padding;
                    p16:SetAttribute("oldp_Padding", v48);
                end;

                assert(v48 ~= nil);
                p16.Padding = UDim.new(v48.Scale, v48.Offset * u17);
                v19 = true;
            end;
        elseif p16:IsA("UIGridLayout") then
            if u10.Grid then
                local function getCellPadding(p49) -- Line: 71
                    return p49.CellPadding;
                end;

                local v50 = p16:GetAttribute("oldp_CellPadding");

                if not v50 then
                    v50 = p16.CellPadding;
                    p16:SetAttribute("oldp_CellPadding", v50);
                end;

                assert(v50 ~= nil);
                p16.CellPadding = UDim2.new(v50.X.Scale, v50.X.Scale * u17, v50.Y.Scale, v50.Y.Offset * u17);
                v19 = true;
            end;
        elseif p16:IsA("ScrollingFrame") and u10.ScrollBar then
            local function getScrollBarThickness(p51) -- Line: 54
                return p51.ScrollBarThickness;
            end;

            local v52 = p16:GetAttribute("oldp_ScrollBarThickness");

            if not v52 then
                v52 = p16.ScrollBarThickness;
                p16:SetAttribute("oldp_ScrollBarThickness", v52);
            end;

            assert(v52 ~= nil);
            p16.ScrollBarThickness = v52 * u17;
            v19 = true;
        end;

        for _, child in ipairs(p16:GetChildren()) do
            if processElement(child, u17, p18) then
                v19 = true;
            end;
        end;

        return v19;
    end;

    return function(p53, p54, p55) -- Line: 246
        -- upvalues: processElement (copy)
        return processElement(p53, p54, p55);
    end;
end;