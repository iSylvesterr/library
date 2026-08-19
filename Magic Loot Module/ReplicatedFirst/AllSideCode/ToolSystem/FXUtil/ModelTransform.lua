-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 9
    local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
    local TweenService = game:GetService("TweenService");
    local RunService = game:GetService("RunService");
    local Debris = game:GetService("Debris");
    local _ = UtilsSystem.VisibleMgr;

    function p1.Instance_Transparency_Tween(p2, p3, p4, p5, p6) -- Line: 25
        -- upvalues: TweenService (copy)
        if not p2 then
            return;
        end;

        local v7 = p3 or 0.1;
        local v8 = p5 or Enum.EasingStyle.Linear;
        local v9 = p6 or Enum.EasingDirection.In;

        if p2:IsA("BasePart") then
            TweenService:Create(p2, TweenInfo.new(v7, v8, v9), {
                Transparency = p4
            }):Play();
        end;

        for _, descendant in p2:GetDescendants() do
            if descendant:IsA("BasePart") then
                TweenService:Create(descendant, TweenInfo.new(v7, v8, v9), {
                    Transparency = p4
                }):Play();
            end;
        end;
    end;

    function p1.Instance_Color_Tween(p10, p11, p12, p13, p14) -- Line: 48
        -- upvalues: TweenService (copy)
        if not p10 or typeof(p12) ~= "Color3" then
            return;
        end;

        local v15 = TweenInfo.new(p11 or 0.1, p13 or Enum.EasingStyle.Linear, p14 or Enum.EasingDirection.In);

        if p10:IsA("BasePart") then
            TweenService:Create(p10, v15, {
                Color = p12
            }):Play();
        end;

        for _, descendant in p10:GetDescendants() do
            if descendant:IsA("BasePart") then
                TweenService:Create(descendant, v15, {
                    Color = p12
                }):Play();
            end;
        end;
    end;

    function p1.Pivot_Instance_CF_Lerp_Heartbeat(u16, p17, u18, p19, p20, u21) -- Line: 80
        -- upvalues: RunService (copy), TweenService (copy)
        local u22 = p19 or Enum.EasingStyle.Linear;
        local u23 = p20 or Enum.EasingDirection.In;
        local u24;

        if u16:IsA("Model") then
            u24 = u16:GetPivot();
        else
            u24 = u16.CFrame;
        end;

        local u25 = math.max(p17, 0.0001);
        local u26 = 0;
        local u27 = nil;
        u27 = RunService.Heartbeat:Connect(function(p28) -- Line: 95
            -- upvalues: u21 (copy), u27 (ref), u16 (copy), u26 (ref), u25 (copy), TweenService (ref), u22 (ref), u23 (ref), u24 (copy), u18 (copy)
            if u21 and not u21() then
                if u27 then
                    u27:Disconnect();
                end;

                return;
            end;

            if not u16.Parent then
                if u27 then
                    u27:Disconnect();
                end;

                return;
            end;

            u26 = u26 + p28;
            local v29 = math.clamp(u26 / u25, 0, 1);
            local v30 = u24:Lerp(u18, (TweenService:GetValue(v29, u22, u23)));

            if u16:IsA("Model") then
                u16:PivotTo(v30);
            else
                u16.CFrame = v30;
            end;

            if v29 >= 1 and u27 then
                u27:Disconnect();
            end;
        end);

        return u27;
    end;

    function p1.Set_CFrame_Model_Tween(u31, u32, u33, u34, u35, u36) -- Line: 138
        -- upvalues: RunService (copy), TweenService (copy)
        task.spawn(function() -- Line: 139
            -- upvalues: u31 (copy), RunService (ref), u32 (copy), TweenService (ref), u34 (copy), u35 (copy), u33 (copy), u36 (copy)
            local v37 = u31:GetPivot();
            local v38 = 0;

            while v38 < 1 do
                local v39 = v38 + RunService.Heartbeat:Wait() / u32;
                v38 = math.min(v39, 1);
                TweenService:GetValue(v38, u34, u35);
                u31:PivotTo(v37:Lerp(u33, v38));

                if not u36 then
                    u31:PivotTo(v37);
                end;
            end;
        end);
    end;

    function p1.Weld(p40, p41) -- Line: 167
        if not (p40 and p41) then
            return;
        end;

        local WeldConstraint = Instance.new("WeldConstraint", p41);
        WeldConstraint.Part0 = p41;
        WeldConstraint.Part1 = p40;
    end;

    function p1.Unweld(p42) -- Line: 182
        -- upvalues: Debris (copy)
        if not p42 then
            return;
        end;

        local v43 = p42:FindFirstChildOfClass("WeldConstraint");

        if v43 then
            v43.Enabled = false;
            Debris:AddItem(v43, 0);
        end;
    end;

    function p1.Control_Model_CFrame(u44, u45) -- Line: 205
        -- upvalues: RunService (copy)
        if not u44 then
            return;
        end;

        if not u45 then
            return;
        end;

        local ModelControl = u44:FindFirstChild("ModelControl");

        if not ModelControl then
            ModelControl = Instance.new("BoolValue", u44);
            ModelControl.Name = "ModelControl";
            ModelControl.Value = false;
        end;

        if ModelControl.Value then
            return;
        end;

        ModelControl.Value = true;
        local u46 = nil;
        local u47 = 0;
        u46 = RunService.Heartbeat:Connect(function(p48) -- Line: 230
            -- upvalues: u45 (copy), u47 (ref), u44 (copy), u46 (ref)
            local v49 = u45(u47);
            local ModelControl2 = u44:FindFirstChild("ModelControl");

            if u44 and (v49 and (ModelControl2 and ModelControl2.Value)) then
                u44:PivotTo(v49);
                u47 = u47 + p48;

                return;
            end;

            if u46 then
                u46:Disconnect();
            end;

            u46 = nil;

            if ModelControl2 then
                ModelControl2.Value = false;
            end;
        end);
    end;

    function p1.Uncontrol_Model_CFrame(p50) -- Line: 255
        if not p50 then
            return;
        end;

        local ModelControl = p50:FindFirstChild("ModelControl");

        if ModelControl then
            ModelControl.Value = false;
        end;
    end;

    function p1.Control_Model_CFrame_Standby(u51, u52) -- Line: 272
        -- upvalues: RunService (copy)
        if not u51 then
            return;
        end;

        if not u52 then
            return;
        end;

        local ModelControl_Standby = u51:FindFirstChild("ModelControl_Standby");

        if not ModelControl_Standby then
            ModelControl_Standby = Instance.new("BoolValue", u51);
            ModelControl_Standby.Name = "ModelControl_Standby";
            ModelControl_Standby.Value = false;
        end;

        if ModelControl_Standby.Value then
            return;
        end;

        ModelControl_Standby.Value = true;
        local u53 = nil;
        local u54 = 0;
        local u55 = nil;
        u55 = RunService.Heartbeat:Connect(function(p56) -- Line: 298
            -- upvalues: u52 (copy), u54 (ref), u51 (copy), u55 (ref), u53 (ref)
            local v57 = u52(u54);
            local ModelControl_Standby2 = u51:FindFirstChild("ModelControl_Standby");

            if u51 and (v57 and (ModelControl_Standby2 and ModelControl_Standby2.Value)) then
                u51:PivotTo(v57);
                u54 = u54 + p56;

                return;
            end;

            if u55 then
                u55:Disconnect();
            end;

            u53 = nil;

            if ModelControl_Standby2 then
                ModelControl_Standby2.Value = false;
            end;
        end);
        u53 = u55;
    end;

    function p1.Uncontrol_Model_CFrame_Standby(p58) -- Line: 324
        if not p58 then
            return;
        end;

        local ModelControl_Standby = p58:FindFirstChild("ModelControl_Standby");

        if ModelControl_Standby then
            ModelControl_Standby.Value = false;
        end;
    end;

    function p1.Control_Attachment_CFrame(u59, u60) -- Line: 341
        -- upvalues: RunService (copy)
        if not u59 then
            return;
        end;

        if not u60 then
            return;
        end;

        local ModelControl = u59:FindFirstChild("ModelControl");

        if not ModelControl then
            ModelControl = Instance.new("BoolValue", u59);
            ModelControl.Name = "ModelControl";
            ModelControl.Value = false;
        end;

        if ModelControl.Value then
            return;
        end;

        ModelControl.Value = true;
        local u61 = nil;
        local u62 = 0;
        local u63 = nil;
        u63 = RunService.RenderStepped:Connect(function(p64) -- Line: 367
            -- upvalues: u60 (copy), u62 (ref), u59 (copy), u63 (ref), u61 (ref)
            local v65 = u60(u62);
            local ModelControl2 = u59:FindFirstChild("ModelControl");

            if u59 and (v65 and (ModelControl2 and ModelControl2.Value)) then
                u59.WorldCFrame = v65;
                u62 = u62 + p64;

                return;
            end;

            if u63 then
                u63:Disconnect();
            end;

            u61 = nil;

            if ModelControl2 then
                ModelControl2.Value = false;
            end;
        end);
        u61 = u63;
    end;

    function p1.Uncontrol_Attachment_CFrame(p66) -- Line: 393
        if not p66 then
            return;
        end;

        local ModelControl = p66:FindFirstChild("ModelControl");

        if ModelControl then
            ModelControl.Value = false;
        end;
    end;
end;