-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 9
    local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
    local TweenService = game:GetService("TweenService");
    local RunService = game:GetService("RunService");
    local InsMgr = UtilsSystem.InsMgr;

    function u1.BasePart_Size_Tween(u2, p3, u4, p5, p6, u7) -- Line: 30
        -- upvalues: TweenService (copy)
        local v8 = TweenInfo.new(p3, p5 or Enum.EasingStyle.Linear, p6 or Enum.EasingDirection.In);

        local function finish() -- Line: 42
            -- upvalues: u7 (copy)
            if type(u7) == "function" then
                u7();
            end;
        end;

        if typeof(u2) == "Instance" and u2:IsA("BasePart") then
            local u9 = TweenService:Create(u2, v8, {
                Size = u4
            });
            u9.Completed:Connect(function() -- Line: 50
                -- upvalues: u9 (copy), u7 (copy)
                u9:Destroy();

                if type(u7) == "function" then
                    u7();
                end;
            end);
            u9:Play();

            return;
        end;

        if type(u2) ~= "table" or u2.Size == nil then
            if type(u7) == "function" then
                u7();
            end;

            return;
        end;

        local Size = u2.Size;

        if typeof(Size) ~= "Vector3" then
            u2.Size = u4;

            if type(u7) == "function" then
                u7();
            end;

            return;
        end;

        local NumberValue = Instance.new("NumberValue");
        NumberValue.Value = 0;
        local u10 = NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 73
            -- upvalues: u2 (copy), Size (copy), u4 (copy), NumberValue (copy)
            u2.Size = Size:Lerp(u4, NumberValue.Value);
        end);
        local u11 = TweenService:Create(NumberValue, v8, {
            Value = 1
        });
        u11.Completed:Connect(function() -- Line: 77
            -- upvalues: u10 (copy), u2 (copy), u4 (copy), NumberValue (copy), u11 (copy), u7 (copy)
            u10:Disconnect();
            u2.Size = u4;
            NumberValue:Destroy();
            u11:Destroy();

            if type(u7) == "function" then
                u7();
            end;
        end);
        u11:Play();
    end;

    function u1.Scale_Model(p12, p13) -- Line: 93
        -- upvalues: InsMgr (copy)
        if not p13 then
            return p12;
        end;

        for _, descendant in pairs(p12:GetDescendants()) do
            if descendant:IsA("BasePart") then
                local OriSize = descendant:FindFirstChild("OriSize");

                if not OriSize then
                    OriSize = InsMgr.GetIns("OriSize", "Vector3Value", descendant);
                    OriSize.Value = descendant.Size;
                end;

                descendant.Size = OriSize.Value * p13;
            end;

            if descendant:IsA("SpecialMesh") and descendant.MeshType == Enum.MeshType.FileMesh then
                local OriSize = descendant:FindFirstChild("OriSize");

                if not OriSize then
                    OriSize = InsMgr.GetIns("OriSize", "Vector3Value", descendant);
                    OriSize.Value = descendant.Scale;
                end;

                descendant.Scale = OriSize.Value * p13;
            end;

            if descendant:IsA("Motor6D") then
                local OriC1 = descendant:FindFirstChild("OriC1");

                if not (OriC1 and OriC1:IsA("CFrameValue")) then
                    OriC1 = InsMgr.GetIns("OriC1", "CFrameValue", descendant);
                    OriC1.Value = descendant.C1;
                end;

                local OriC0 = descendant:FindFirstChild("OriC0");

                if not (OriC0 and OriC0:IsA("CFrameValue")) then
                    OriC0 = InsMgr.GetIns("OriC0", "CFrameValue", descendant);
                    OriC0.Value = descendant.C0;
                end;

                if OriC0 and (OriC0:IsA("CFrameValue") and (OriC1 and OriC1:IsA("CFrameValue"))) then
                    descendant.C0 = OriC0.Value.Rotation + OriC0.Value.Position * p13;
                    descendant.C1 = OriC1.Value.Rotation + OriC1.Value.Position * p13;
                end;
            end;

            if descendant:IsA("Weld") then
                local OriC1 = descendant:FindFirstChild("OriC1");

                if not (OriC1 and OriC1:IsA("CFrameValue")) then
                    OriC1 = InsMgr.GetIns("OriC1", "CFrameValue", descendant);
                    OriC1.Value = descendant.C1;
                end;

                local OriC0 = descendant:FindFirstChild("OriC0");

                if not (OriC0 and OriC0:IsA("CFrameValue")) then
                    OriC0 = InsMgr.GetIns("OriC0", "CFrameValue", descendant);
                    OriC0.Value = descendant.C0;
                end;

                if OriC0 and (OriC0:IsA("CFrameValue") and (OriC1 and OriC1:IsA("CFrameValue"))) then
                    descendant.C0 = OriC0.Value.Rotation + OriC0.Value.Position * p13;
                    descendant.C1 = OriC1.Value.Rotation + OriC1.Value.Position * p13;
                end;
            end;

            if descendant:IsA("Attachment") then
                local OriPos = descendant:FindFirstChild("OriPos");

                if not OriPos then
                    OriPos = InsMgr.GetIns("OriPos", "Vector3Value", descendant);
                    OriPos.Value = descendant.CFrame.Position;
                end;

                if OriPos then
                    descendant.Position = OriPos.Value * p13;
                end;
            end;
        end;

        p12:SetAttribute("Scale", p13);

        return p12;
    end;

    function u1.Scale_Model_Tween(u14, u15, u16, u17, u18, u19) -- Line: 195
        -- upvalues: RunService (copy), TweenService (copy), u1 (copy)
        task.spawn(function() -- Line: 196
            -- upvalues: u14 (copy), RunService (ref), u15 (copy), TweenService (ref), u17 (copy), u18 (copy), u1 (ref), u16 (copy), u19 (copy)
            local v20 = u14:GetPivot();

            if not u14:GetAttribute("Scale") then
                u14:SetAttribute("Scale", 1);
            end;

            local v21 = u14:GetAttribute("Scale");
            local v22 = 0;

            while v22 < 1 do
                local v23 = v22 + RunService.Heartbeat:Wait() / u15;
                v22 = math.min(v23, 1);
                local v24 = TweenService:GetValue(v22, u17, u18);
                u1.Scale_Model(u14, v24 * (u16 - v21) + v21);

                if not u19 then
                    u14:PivotTo(v20);
                end;
            end;
        end);
    end;

    function u1.Set_Scale_Model(p25, p26) -- Line: 227
        if p25:IsA("Model") then
            local v27 = p25:GetAttribute("ModelScale");

            if not v27 then
                p25:SetAttribute("ModelScale", p25:GetScale());
                v27 = p25:GetScale();
            end;

            p25:SetAttribute("Scale", p26);
            p25:ScaleTo(v27 * p26);
        end;
    end;

    function u1.Set_Scale_Model_Tween(u28, u29, u30, u31, u32, u33) -- Line: 251
        -- upvalues: RunService (copy), TweenService (copy), u1 (copy)
        task.spawn(function() -- Line: 252
            -- upvalues: u31 (ref), u32 (ref), u28 (copy), RunService (ref), u29 (copy), TweenService (ref), u1 (ref), u30 (copy), u33 (copy)
            u31 = u31 or Enum.EasingStyle.Linear;
            u32 = u32 or Enum.EasingDirection.In;
            local v34 = u28:GetPivot();

            if not u28:GetAttribute("ModelScale") then
                u28:SetAttribute("ModelScale", u28:GetScale());
                u28:GetScale();
            end;

            if not u28:GetAttribute("Scale") then
                u28:SetAttribute("Scale", 1);
            end;

            local v35 = u28:GetAttribute("Scale");
            local v36 = 0;

            while v36 < 1 do
                local v37 = v36 + RunService.Heartbeat:Wait() / u29;
                v36 = math.min(v37, 1);
                local v38 = TweenService:GetValue(v36, u31, u32);
                u1.Set_Scale_Model(u28, v35 + (u30 - v35) * v38);

                if not u33 then
                    u28:PivotTo(v34);
                end;
            end;
        end);
    end;

    function u1.Set_Scale_Basepart(p39, p40, p41) -- Line: 291
        if p39:IsA("BasePart") then
            local v42 = p39:GetAttribute("OriSize");

            if not v42 then
                p39:SetAttribute("OriSize", p39.Size);
                v42 = p39.Size;
            end;

            p39:SetAttribute("Scale", p40);
            p39.Size = v42 * p40;

            if p41 then
                for _, child in pairs(p39:GetChildren()) do
                    if child:IsA("Attachment") then
                        local v43 = child:GetAttribute("OriPos");

                        if not v43 then
                            child:SetAttribute("OriPos", child.CFrame.Position);
                            v43 = child.CFrame.Position;
                        end;

                        child.CFrame = child.CFrame.Rotation + v43 * p40;
                    end;
                end;
            end;
        end;
    end;

    function u1.Set_Scale_Basepart_Tween(u44, u45, u46, u47, u48, u49, u50) -- Line: 332
        -- upvalues: RunService (copy), TweenService (copy), u1 (copy)
        task.spawn(function() -- Line: 333
            -- upvalues: u44 (copy), RunService (ref), u45 (copy), TweenService (ref), u47 (copy), u48 (copy), u1 (ref), u46 (copy), u50 (copy), u49 (copy)
            local v51 = u44:GetPivot();

            if not u44:GetAttribute("OriSize") then
                u44:SetAttribute("OriSize", u44.Size);
            end;

            if not u44:GetAttribute("Scale") then
                u44:SetAttribute("Scale", 1);
            end;

            local v52 = u44:GetAttribute("Scale");
            local v53 = 0;

            while v53 < 1 do
                local v54 = v53 + RunService.Heartbeat:Wait() / u45;
                v53 = math.min(v54, 1);
                local v55 = TweenService:GetValue(v53, u47, u48);
                u1.Set_Scale_Basepart(u44, v55 * (u46 - v52) + v52, u50);

                if not u49 then
                    u44:PivotTo(v51);
                end;
            end;
        end);
    end;

    function u1.Get_Model_Volume(p56) -- Line: 371
        if not (p56 and p56:IsA("Model")) then
            return 0;
        end;

        local _, v57 = p56:GetBoundingBox();

        return not v57 and 0 or v57.X * v57.Y * v57.Z;
    end;

    function u1.Protect_Model_Volume(p58, p59) -- Line: 392
        -- upvalues: u1 (copy)
        if not (p58 and p58:IsA("Model")) then
            return false;
        end;

        if not p59 or p59 <= 0 then
            warn("FXUtil.Protect_Model_Volume: maxVolume 必须大于 0");

            return false;
        end;

        local v60 = u1.Get_Model_Volume(p58);

        if v60 <= 0 then
            return false;
        end;

        if v60 <= p59 then
            return false;
        end;

        local v61 = math.pow(p59 / v60, 0.3333333333333333);
        local v62 = p58:GetAttribute("ModelScale");

        if not v62 then
            p58:SetAttribute("ModelScale", p58:GetScale());
            v62 = p58:GetScale();
        end;

        p58:SetAttribute("Scale", v61);
        p58:ScaleTo(v62 * v61);

        return true;
    end;
end;