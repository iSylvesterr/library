-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local UserInputService = UtilsSystem.UserInputService;
local GuiService = game:GetService("GuiService");
local AddListen = UtilsSystem.AddListen;
local v1 = {};
local u2 = nil;
local u3 = nil;

local function runActiveCleanup() -- Line: 22
    -- upvalues: u2 (ref), u3 (ref)
    local v4 = u2;
    u2 = nil;
    u3 = nil;

    if v4 then
        v4();
    end;
end;

function v1.CancelActive() -- Line: 31
    -- upvalues: u2 (ref), u3 (ref)
    local v5 = u2;
    u2 = nil;
    u3 = nil;

    if v5 then
        v5();
    end;
end;

local function readAttrNum(p6, p7, p8) -- Line: 35
    local v9 = p6:GetAttribute(p7);

    if type(v9) == "number" then
        return v9;
    end;

    return p8;
end;

local function snapToStep(p10, p11, p12, p13) -- Line: 43
    local v14 = math.clamp(p10, p11, p12);

    if p13 <= 0 then
        return v14;
    end;

    local v15 = p11 + math.floor((v14 - p11) / p13 + 0.5) * p13;

    return math.clamp(v15, p11, p12);
end;

function v1.Bind(u16, u17, p18, u19, u20) -- Line: 53
    -- upvalues: AddListen (copy), GuiService (copy), UserInputService (copy), u2 (ref), u3 (ref)
    local Bar = u16:FindFirstChild("Bar");
    local u21 = u16:FindFirstChild("箭头");
    local NowValue = u17:FindFirstChild("NowValue");

    if not u21 then
        return;
    end;

    local function getRange() -- Line: 68
        -- upvalues: u16 (copy)
        local v22 = u16:GetAttribute("SliderMin");
        local v23 = type(v22) ~= "number" and 0 or v22;
        local v24 = u16:GetAttribute("SliderMax");
        local v25 = type(v24) ~= "number" and 100 or v24;

        if v25 >= v23 then
            local v26 = v23;
            v23 = v25;
            v25 = v26;
        end;

        local v27 = u16:GetAttribute("SliderStep");

        if type(v27) == "number" then
            return v25, v23, v27;
        end;

        return v25, v23, 1;
    end;

    local function valueToAlpha(p28, p29, p30) -- Line: 78
        local v31 = p30 - p29;

        return v31 <= 1e-9 and 0 or math.clamp((p28 - p29) / v31, 0, 1);
    end;

    local function alphaToValue(p32) -- Line: 86
        -- upvalues: u16 (copy)
        local v33 = u16:GetAttribute("SliderMin");
        local v34 = type(v33) ~= "number" and 0 or v33;
        local v35 = u16:GetAttribute("SliderMax");
        local v36 = type(v35) ~= "number" and 100 or v35;

        if v36 >= v34 then
            local v37 = v34;
            v34 = v36;
            v36 = v37;
        end;

        local v38 = u16:GetAttribute("SliderStep");
        local v39 = type(v38) ~= "number" and 1 or v38;
        local v40 = math.clamp(v36 + p32 * (v34 - v36), v36, v34);

        if v39 <= 0 then
            return v40;
        end;

        local v41 = v36 + math.floor((v40 - v36) / v39 + 0.5) * v39;

        return math.clamp(v41, v36, v34);
    end;

    local function formatLabel(p42) -- Line: 92
        -- upvalues: u16 (copy), u17 (copy)
        local v43 = u16:GetAttribute("SliderLabelMode");

        if u17:GetAttribute("SliderIsPercent") == true then
            local v44 = math.floor(p42 + 0.5);

            return tostring(v44) .. "%";
        end;

        if v43 == "audio01" then
            local v45 = math.floor(p42 + 0.5);

            return tostring(v45);
        end;

        local v46 = math.floor(p42 + 0.5);

        return tostring(v46);
    end;

    local function applyVisual(p47) -- Line: 104
        -- upvalues: u16 (copy), Bar (copy), u21 (copy), NowValue (copy), formatLabel (copy)
        local v48 = u16:GetAttribute("SliderMin");
        local v49 = type(v48) ~= "number" and 0 or v48;
        local v50 = u16:GetAttribute("SliderMax");
        local v51 = type(v50) ~= "number" and 100 or v50;

        if v51 >= v49 then
            local v52 = v49;
            v49 = v51;
            v51 = v52;
        end;

        local v53 = u16:GetAttribute("SliderStep");
        local _ = type(v53) ~= "number" and 1 or v53;
        local v54 = v49 - v51;
        local v55 = v54 <= 1e-9 and 0 or math.clamp((p47 - v51) / v54, 0, 1);

        if Bar then
            local Y = Bar.Size.Y;
            Bar.Size = UDim2.new(v55, 0, Y.Scale, Y.Offset);
        end;

        local Position = u21.Position;
        u21.Position = UDim2.new(v55, Position.X.Offset, Position.Y.Scale, Position.Y.Offset);

        if NowValue then
            NowValue.Text = formatLabel(p47);
        end;
    end;

    local function alphaFromScreenX(p56) -- Line: 118
        -- upvalues: u16 (copy)
        local AbsoluteSize = u16.AbsoluteSize;

        return AbsoluteSize.X <= 0.001 and 0 or math.clamp((p56 - u16.AbsolutePosition.X) / AbsoluteSize.X, 0, 1);
    end;

    local u57 = false;
    AddListen.NumValueAdd(p18, function(p58) -- Line: 129, Name: syncFromNv
        -- upvalues: u57 (ref), applyVisual (copy)
        if u57 then
            return;
        end;

        applyVisual(p58);
    end);

    local function pushToServer(p59) -- Line: 138
        -- upvalues: u19 (copy), u20 (copy)
        u19(u20, p59);
    end;

    local function guiScreenXFromInputObject(p60) -- Line: 143
        -- upvalues: GuiService (ref), UserInputService (ref)
        local v61 = GuiService:GetGuiInset();

        if p60.UserInputType == Enum.UserInputType.Touch then
            return p60.Position.X - v61.X;
        end;

        return (UserInputService:GetMouseLocation() - v61).X;
    end;

    local function finalizeFromInput(p62) -- Line: 151
        -- upvalues: GuiService (ref), UserInputService (ref), u16 (copy), applyVisual (copy)
        local v63;

        if p62 then
            local v64 = GuiService:GetGuiInset();

            if p62.UserInputType == Enum.UserInputType.Touch then
                v63 = p62.Position.X - v64.X;
            else
                v63 = (UserInputService:GetMouseLocation() - v64).X;
            end;
        else
            v63 = (UserInputService:GetMouseLocation() - GuiService:GetGuiInset()).X;
        end;

        local AbsoluteSize = u16.AbsoluteSize;
        local v65 = AbsoluteSize.X <= 0.001 and 0 or math.clamp((v63 - u16.AbsolutePosition.X) / AbsoluteSize.X, 0, 1);
        local v66 = u16:GetAttribute("SliderMin");
        local v67 = type(v66) ~= "number" and 0 or v66;
        local v68 = u16:GetAttribute("SliderMax");
        local v69 = type(v68) ~= "number" and 100 or v68;

        if v69 >= v67 then
            local v70 = v67;
            v67 = v69;
            v69 = v70;
        end;

        local v71 = u16:GetAttribute("SliderStep");
        local v72 = type(v71) ~= "number" and 1 or v71;
        local v73 = math.clamp(v69 + v65 * (v67 - v69), v69, v67);

        if v72 > 0 then
            local v74 = v69 + math.floor((v73 - v69) / v72 + 0.5) * v72;
            v73 = math.clamp(v74, v69, v67);
        end;

        applyVisual(v73);

        return v73;
    end;

    local function beginDragSession(u75) -- Line: 163
        -- upvalues: u2 (ref), u3 (ref), u57 (ref), u16 (copy), UserInputService (ref), GuiService (ref), applyVisual (copy), u19 (copy), u20 (copy)
        local v76 = u2;
        u2 = nil;
        u3 = nil;

        if v76 then
            v76();
        end;

        u57 = true;
        u3 = u16;
        local u77 = nil;
        local u78 = nil;
        local u79 = false;
        local u80 = u16:FindFirstAncestorWhichIsA("ScrollingFrame");
        local u81;

        if u80 and u80.ScrollingEnabled then
            u80.ScrollingEnabled = false;
            u81 = true;
        else
            u81 = nil;
        end;

        local function restoreScrollIfNeeded() -- Line: 181
            -- upvalues: u80 (copy), u81 (ref)
            if u80 and u81 then
                u80.ScrollingEnabled = true;
                u81 = nil;
            end;
        end;

        local function pickScreenXForDrag(p82) -- Line: 188
            -- upvalues: UserInputService (ref), GuiService (ref)
            if not p82 then
                return (UserInputService:GetMouseLocation() - GuiService:GetGuiInset()).X;
            end;

            local v83 = GuiService:GetGuiInset();

            if p82.UserInputType == Enum.UserInputType.Touch then
                return p82.Position.X - v83.X;
            end;

            return (UserInputService:GetMouseLocation() - v83).X;
        end;

        local function shouldHandleMove(p84) -- Line: 195
            -- upvalues: u75 (copy)
            if not u75 then
                return p84.UserInputType == Enum.UserInputType.MouseMovement and true or p84.UserInputType == Enum.UserInputType.Touch;
            end;

            if u75.UserInputType == Enum.UserInputType.Touch then
                local v85;

                if p84.UserInputType == Enum.UserInputType.Touch then
                    v85 = p84 == u75;
                else
                    v85 = false;
                end;

                return v85;
            end;

            if u75.UserInputType == Enum.UserInputType.MouseButton1 then
                return p84.UserInputType == Enum.UserInputType.MouseMovement and true or p84.UserInputType == Enum.UserInputType.Gamepad1;
            end;

            return false;
        end;

        if u75 then
            local v86;

            if u75 then
                local v87 = GuiService:GetGuiInset();

                if u75.UserInputType == Enum.UserInputType.Touch then
                    v86 = u75.Position.X - v87.X;
                else
                    v86 = (UserInputService:GetMouseLocation() - v87).X;
                end;
            else
                v86 = (UserInputService:GetMouseLocation() - GuiService:GetGuiInset()).X;
            end;

            local AbsoluteSize = u16.AbsoluteSize;
            local v88 = AbsoluteSize.X <= 0.001 and 0 or math.clamp((v86 - u16.AbsolutePosition.X) / AbsoluteSize.X, 0, 1);
            local v89 = u16:GetAttribute("SliderMin");
            local v90 = type(v89) ~= "number" and 0 or v89;
            local v91 = u16:GetAttribute("SliderMax");
            local v92 = type(v91) ~= "number" and 100 or v91;

            if v92 >= v90 then
                local v93 = v90;
                v90 = v92;
                v92 = v93;
            end;

            local v94 = u16:GetAttribute("SliderStep");
            local v95 = type(v94) ~= "number" and 1 or v94;
            local v96 = math.clamp(v92 + v88 * (v90 - v92), v92, v90);

            if v95 > 0 then
                local v97 = v92 + math.floor((v96 - v92) / v95 + 0.5) * v95;
                v96 = math.clamp(v97, v92, v90);
            end;

            applyVisual(v96);
        end;

        local function disconnectOnly() -- Line: 215
            -- upvalues: u79 (ref), u57 (ref), u80 (copy), u81 (ref), u77 (ref), u78 (ref), u2 (ref), u3 (ref)
            if u79 then
                return;
            end;

            u79 = true;
            u57 = false;

            if u80 and u81 then
                u80.ScrollingEnabled = true;
                u81 = nil;
            end;

            if u77 and u77.Connected then
                u77:Disconnect();
            end;

            if u78 and u78.Connected then
                u78:Disconnect();
            end;

            u2 = nil;
            u3 = nil;
        end;

        u77 = UserInputService.InputChanged:Connect(function(p98, p99) -- Line: 232
            -- upvalues: shouldHandleMove (copy), UserInputService (ref), GuiService (ref), u16 (ref), applyVisual (ref)
            if not shouldHandleMove(p98) then
                return;
            end;

            local v100;

            if p98 then
                local v101 = GuiService:GetGuiInset();

                if p98.UserInputType == Enum.UserInputType.Touch then
                    v100 = p98.Position.X - v101.X;
                else
                    v100 = (UserInputService:GetMouseLocation() - v101).X;
                end;
            else
                v100 = (UserInputService:GetMouseLocation() - GuiService:GetGuiInset()).X;
            end;

            local AbsoluteSize = u16.AbsoluteSize;
            local v102 = AbsoluteSize.X <= 0.001 and 0 or math.clamp((v100 - u16.AbsolutePosition.X) / AbsoluteSize.X, 0, 1);
            local v103 = u16:GetAttribute("SliderMin");
            local v104 = type(v103) ~= "number" and 0 or v103;
            local v105 = u16:GetAttribute("SliderMax");
            local v106 = type(v105) ~= "number" and 100 or v105;

            if v106 >= v104 then
                local v107 = v104;
                v104 = v106;
                v106 = v107;
            end;

            local v108 = u16:GetAttribute("SliderStep");
            local v109 = type(v108) ~= "number" and 1 or v108;
            local v110 = math.clamp(v106 + v102 * (v104 - v106), v106, v104);

            if v109 > 0 then
                local v111 = v106 + math.floor((v110 - v106) / v109 + 0.5) * v109;
                v110 = math.clamp(v111, v106, v104);
            end;

            applyVisual(v110);
        end);
        u78 = UserInputService.InputEnded:Connect(function(p112, p113) -- Line: 243
            -- upvalues: u79 (ref), u75 (copy), GuiService (ref), UserInputService (ref), u16 (ref), applyVisual (ref), u57 (ref), u80 (copy), u81 (ref), u77 (ref), u78 (ref), u2 (ref), u3 (ref), u19 (ref), u20 (ref)
            if u79 then
                return;
            end;

            if p112.UserInputType == Enum.UserInputType.Gamepad1 then
                if p112.KeyCode ~= Enum.KeyCode.ButtonA then
                    return;
                end;
            else
                if p112.UserInputType ~= Enum.UserInputType.MouseButton1 and p112.UserInputType ~= Enum.UserInputType.Touch then
                    return;
                end;

                if u75 and (p112.UserInputType == Enum.UserInputType.Touch and p112 ~= u75) then
                    return;
                end;
            end;

            local v114;

            if p112 then
                local v115 = GuiService:GetGuiInset();

                if p112.UserInputType == Enum.UserInputType.Touch then
                    v114 = p112.Position.X - v115.X;
                else
                    v114 = (UserInputService:GetMouseLocation() - v115).X;
                end;
            else
                v114 = (UserInputService:GetMouseLocation() - GuiService:GetGuiInset()).X;
            end;

            local AbsoluteSize = u16.AbsoluteSize;
            local v116 = AbsoluteSize.X <= 0.001 and 0 or math.clamp((v114 - u16.AbsolutePosition.X) / AbsoluteSize.X, 0, 1);
            local v117 = u16:GetAttribute("SliderMin");
            local v118 = type(v117) ~= "number" and 0 or v117;
            local v119 = u16:GetAttribute("SliderMax");
            local v120 = type(v119) ~= "number" and 100 or v119;

            if v120 >= v118 then
                local v121 = v118;
                v118 = v120;
                v120 = v121;
            end;

            local v122 = u16:GetAttribute("SliderStep");
            local v123 = type(v122) ~= "number" and 1 or v122;
            local v124 = math.clamp(v120 + v116 * (v118 - v120), v120, v118);

            if v123 > 0 then
                local v125 = v120 + math.floor((v124 - v120) / v123 + 0.5) * v123;
                v124 = math.clamp(v125, v120, v118);
            end;

            applyVisual(v124);

            if not u79 then
                u79 = true;
                u57 = false;

                if u80 and u81 then
                    u80.ScrollingEnabled = true;
                    u81 = nil;
                end;

                if u77 and u77.Connected then
                    u77:Disconnect();
                end;

                if u78 and u78.Connected then
                    u78:Disconnect();
                end;

                u2 = nil;
                u3 = nil;
            end;

            u19(u20, v124);
        end);

        u2 = function() -- Line: 273
            -- upvalues: u79 (ref), u57 (ref), u80 (copy), u81 (ref), u77 (ref), u78 (ref), u2 (ref), u3 (ref)
            if u79 then
                return;
            end;

            u79 = true;
            u57 = false;

            if u80 and u81 then
                u80.ScrollingEnabled = true;
                u81 = nil;
            end;

            if u77 and u77.Connected then
                u77:Disconnect();
            end;

            if u78 and u78.Connected then
                u78:Disconnect();
            end;

            u2 = nil;
            u3 = nil;
        end;
    end;

    u21.InputBegan:Connect(function(p126) -- Line: 278
        -- upvalues: beginDragSession (copy)
        if p126.UserInputType == Enum.UserInputType.MouseButton1 or p126.UserInputType == Enum.UserInputType.Touch then
            beginDragSession(p126);
        end;
    end);

    if Bar and Bar:IsA("GuiObject") then
        Bar.InputBegan:Connect(function(p127) -- Line: 286
            -- upvalues: beginDragSession (copy)
            if p127.UserInputType == Enum.UserInputType.MouseButton1 or p127.UserInputType == Enum.UserInputType.Touch then
                beginDragSession(p127);
            end;
        end);
    end;

    u16.Destroying:Connect(function() -- Line: 293
        -- upvalues: u3 (ref), u16 (copy), u2 (ref)
        if u3 == u16 then
            local v128 = u2;
            u2 = nil;
            u3 = nil;

            if v128 then
                v128();
            end;
        end;
    end);
end;

return v1;