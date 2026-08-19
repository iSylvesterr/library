-- Decompiled with Potassium's decompiler.

local LocalPlayer = game:GetService("Players").LocalPlayer;

return function(u1) -- Line: 6
    -- upvalues: LocalPlayer (copy)
    local Util = u1.Util;
    local Window = require(script:WaitForChild("Window"));
    Window.Cmdr = u1;
    local u2 = require(script:WaitForChild("AutoComplete"))(u1);
    Window.AutoComplete = u2;

    function Window.ProcessEntry(p3) -- Line: 17
        -- upvalues: Util (copy), Window (copy), u1 (copy), LocalPlayer (ref)
        local v4 = Util.TrimString(p3);

        if #v4 == 0 then
            return;
        end;

        Window:AddLine(Window:GetLabel() .. " " .. v4, Color3.fromRGB(255, 223, 93));
        Window:AddLine(u1.Dispatcher:EvaluateAndRun(v4, LocalPlayer, {
            IsHuman = true
        }));
    end;

    function Window.OnTextChanged(p5) -- Line: 30
        -- upvalues: u1 (copy), LocalPlayer (ref), Util (copy), Window (copy), u2 (copy)
        local v6 = u1.Dispatcher:Evaluate(p5, LocalPlayer, true);
        local v7 = Util.SplitString(p5);
        local v8 = table.remove(v7, 1);
        local v9;

        if v6 then
            v7 = Util.MashExcessArguments(v7, #v6.Object.Args);

            if #v7 == #v6.Object.Args then
                v9 = true;
            else
                v9 = false;
            end;
        else
            v9 = false;
        end;

        local v10;

        if v8 then
            v10 = #v7 > 0;
        else
            v10 = v8;
        end;

        if p5:sub(#p5, #p5):match("%s") and not v9 then
            v7[#v7 + 1] = "";
            v10 = true;
        end;

        if v6 and v10 then
            local v11, v12 = v6:Validate();
            Window:SetIsValidInput(v11, ("Validation errors: %s"):format(v12 or ""));
            local v13 = {};
            local v14 = v6:GetArgument(#v7);

            if v14 then
                local TextSegmentInProgress = v14.TextSegmentInProgress;
                local v15 = false;

                if v14.RawSegmentsAreAutocomplete then
                    for i, v in ipairs(v14.RawSegments) do
                        v13[i] = { v, v };
                    end;
                else
                    local v16, v17 = v14:GetAutocomplete();
                    v15 = (v17 or {}).IsPartial or false;

                    for i, v in pairs(v16) do
                        v13[i] = { TextSegmentInProgress, v };
                    end;
                end;

                local v18;

                if #TextSegmentInProgress > 0 then
                    v18, v12 = v14:Validate();
                else
                    v18 = true;
                end;

                if not v9 and v18 then
                    Window:HideInvalidState();
                end;

                local v19 = {};

                if v9 then
                    v9 = #p5 - #TextSegmentInProgress + (p5:sub(#p5, #p5):match("%s") and -1 or 0);
                end;

                v19.at = v9;
                v19.prefix = #v14.RawSegments == 1 and (v14.Prefix or "") or "";
                local v20;

                if #v6.Arguments == #v6.ArgumentDefinitions then
                    v20 = #TextSegmentInProgress > 0;
                else
                    v20 = false;
                end;

                v19.isLast = v20;
                v19.numArgs = #v7;
                v19.command = v6;
                v19.arg = v14;
                v19.name = v14.Name .. (v14.Required and "" or "?");
                v19.type = v14.Type.DisplayName;
                v19.description = v18 == false and v12 and v12 or v14.Object.Description;
                v19.invalid = not v18;
                v19.isPartial = v15;

                return u2:Show(v13, v19);
            end;
        elseif v8 and #v7 == 0 then
            Window:SetIsValidInput(true);
            local v21 = u1.Registry:GetCommand(v8);
            local v22 = nil;

            if v21 then
                v22 = {
                    v21.Name,
                    v21.Name,
                    options = {
                        name = v21.Name,
                        description = v21.Description
                    }
                };
                local v23 = v21.Args and v21.Args[1];

                if type(v23) == "function" then
                    v23 = v23(v6);
                end;

                if v23 and (not v23.Optional and v23.Default == nil) then
                    Window:SetIsValidInput(false, "This command has required arguments.");
                    Window:HideInvalidState();
                end;
            else
                Window:SetIsValidInput(false, ("%q is not a valid command name. Use the help command to see all available commands."):format(v8));
            end;

            local v24 = { v22 };

            for _, v in pairs(u1.Registry:GetCommandNames()) do
                if v8:lower() == v:lower():sub(1, #v8) and (v22 == nil or v22[1] ~= v8) then
                    local v25 = u1.Registry:GetCommand(v);
                    v24[#v24 + 1] = {
                        v8,
                        v,
                        options = {
                            name = v25.Name,
                            description = v25.Description
                        }
                    };
                end;
            end;

            return u2:Show(v24);
        end;

        Window:SetIsValidInput(false, "Use the help command to see all available commands.");
        u2:Hide();
    end;

    Window:UpdateLabel();
    Window:UpdateWindowHeight();

    return {
        Window = Window,
        AutoComplete = u2
    };
end;