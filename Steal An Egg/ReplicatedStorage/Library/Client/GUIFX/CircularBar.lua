-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 1
    local u2 = nil;
    local u3 = nil;
    local u4 = nil;
    local u5 = nil;

    if pcall(function() -- Line: 7, Name: setup
        -- upvalues: u2 (ref), u1 (copy), u3 (ref), u4 (ref), u5 (ref)
        u2 = u1:FindFirstChild("Left");
        u3 = u1:FindFirstChild("Right");
        local v6 = u2 and u2:IsA("GuiObject");
        assert(v6, "CircularBar is missing a Left GuiObject child");
        local v7 = u3 and u3:IsA("GuiObject");
        assert(v7, "CircularBar is missing a Right GuiObject child");
        u4 = u2:FindFirstChildOfClass("UIGradient");
        u5 = u3:FindFirstChildOfClass("UIGradient");
        local v8 = u4 and u4:IsA("UIGradient");
        assert(v8, "CircularBar is missing a Left UIGradient child");
        local v9 = u5 and u5:IsA("UIGradient");
        assert(v9, "CircularBar is missing a Right UIGradient child");
    end) and not u1:GetAttribute("Progress") then
        local function updateProgress(p10) -- Line: 21
            -- upvalues: u1 (copy), u4 (ref), u5 (ref), u2 (ref), u3 (ref)
            local v11 = math.clamp(p10, 0.0001, 1);

            if u1 and (u4 and u5) then
                local v12 = math.clamp(v11 * 2, 0, 1) * 180;
                local v13 = math.clamp((v11 - 0.5) * 2, 0, 1) * 180 + 180;
                u5.Rotation = v12;
                u4.Rotation = v13;
                u5.Enabled = v11 < 0.5;
                u4.Enabled = v11 < 1;
                u2.Visible = v11 > 0;
                u3.Visible = v11 > 0;
            end;
        end;

        u1:SetAttribute("Progress", 1);
        u1:GetAttributeChangedSignal("Progress"):Connect(function() -- Line: 40
            -- upvalues: u1 (copy), u4 (ref), u5 (ref), u2 (ref), u3 (ref)
            local v14 = u1:GetAttribute("Progress");

            if type(v14) == "number" then
                local v15 = math.clamp(v14, 0.0001, 1);

                if u1 and (u4 and u5) then
                    local v16 = math.clamp(v15 * 2, 0, 1) * 180;
                    local v17 = math.clamp((v15 - 0.5) * 2, 0, 1) * 180 + 180;
                    u5.Rotation = v16;
                    u4.Rotation = v17;
                    u5.Enabled = v15 < 0.5;
                    u4.Enabled = v15 < 1;
                    u2.Visible = v15 > 0;
                    u3.Visible = v15 > 0;
                end;
            end;
        end);
    else
        warn("Could not setup CircularBar for " .. u1.Name);
    end;
end;