-- Decompiled with Potassium's decompiler.

return {
    create = function(u1) -- Line: 35, Name: create
        local character = u1.character;
        local cameraModule = u1.cameraModule;
        local runService = u1.runService;
        local tweenService = u1.tweenService;
        local v2 = u1.setting.Fov or {};
        local u3 = v2.sprintEnterSpeed or 16;
        local u4 = v2.sprintExitSpeed or 0.01;
        local u5 = v2.sprintMinHold or 0.35;
        local u6 = v2.sprintResumeDelay or 0;
        local u7 = v2.maxChangeFov or 8;
        local u8 = v2.changeSpeed or 30;
        local u9 = v2.resumeSpeed or 15;
        local u10 = 0;
        local u11 = nil;
        local u12 = "Min";
        local u13 = nil;
        local u14 = nil;

        local function _setSpeedFov() -- Line: 59
            -- upvalues: u11 (ref), u10 (ref), u7 (copy), u8 (copy), runService (copy), tweenService (copy)
            if u11 then
                u11:Disconnect();
                u11 = nil;
            end;

            local u15 = u10;
            local u16 = (u7 - u15) / u8;
            local u17 = 0;
            u11 = runService.Heartbeat:Connect(function(p18) -- Line: 67
                -- upvalues: u17 (ref), tweenService (ref), u16 (copy), u10 (ref), u15 (copy), u7 (ref), u11 (ref)
                u17 = u17 + p18;
                local v19 = tweenService:GetValue(math.clamp(u17 / u16, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                u10 = u15 + v19 * (u7 - u15);

                if v19 >= 1 and u11 then
                    u11:Disconnect();
                    u11 = nil;
                end;
            end);
        end;

        local function _resumeSpeedFov() -- Line: 87
            -- upvalues: u11 (ref), u10 (ref), u9 (copy), runService (copy), tweenService (copy)
            if u11 then
                u11:Disconnect();
                u11 = nil;
            end;

            local u20 = u10;
            local u21 = u20 / u9;
            local u22 = 0;
            u11 = runService.Heartbeat:Connect(function(p23) -- Line: 95
                -- upvalues: u22 (ref), tweenService (ref), u21 (copy), u10 (ref), u20 (copy), u11 (ref)
                u22 = u22 + p23;
                local v24 = tweenService:GetValue(math.clamp(u22 / u21, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                u10 = u20 - v24 * u20;

                if v24 >= 1 and u11 then
                    u11:Disconnect();
                    u11 = nil;
                end;
            end);
        end;

        cameraModule.DisableCameraEvent_Helper("移速影响相机FOV");
        local v39, v40 = cameraModule.EnableCameraEvent_Helper("移速影响相机FOV", function(p25, p26) -- Line: 113
            -- upvalues: character (copy), u1 (copy), u12 (ref), u4 (copy), u14 (ref), u13 (ref), u5 (copy), u6 (copy), u11 (ref), u10 (ref), u9 (copy), runService (copy), tweenService (copy), u3 (copy), u7 (copy), u8 (copy)
            if character:GetAttribute("JetPacking") then
                return CFrame.new(), 0;
            end;

            local v27 = time();
            local v28 = u1.getPlayerRunSpeed();

            if u12 == "Max" then
                if u4 <= v28 then
                    u14 = nil;
                elseif u5 <= v27 - (u13 or v27) and u14 == nil then
                    u14 = v27 + u6;
                end;

                if u14 ~= nil and u14 <= v27 then
                    u12 = "Min";

                    if u11 then
                        u11:Disconnect();
                        u11 = nil;
                    end;

                    local u29 = u10;
                    local u30 = u29 / u9;
                    local u31 = 0;
                    u11 = runService.Heartbeat:Connect(function(p32) -- Line: 95
                        -- upvalues: u31 (ref), tweenService (ref), u30 (copy), u10 (ref), u29 (copy), u11 (ref)
                        u31 = u31 + p32;
                        local v33 = tweenService:GetValue(math.clamp(u31 / u30, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                        u10 = u29 - v33 * u29;

                        if v33 >= 1 and u11 then
                            u11:Disconnect();
                            u11 = nil;
                        end;
                    end);
                    u13 = nil;
                    u14 = nil;
                end;
            elseif u12 == "Min" then
                u14 = nil;

                if u3 < v28 then
                    u12 = "Max";

                    if u11 then
                        u11:Disconnect();
                        u11 = nil;
                    end;

                    local u34 = u10;
                    local u35 = (u7 - u34) / u8;
                    local u36 = 0;
                    u11 = runService.Heartbeat:Connect(function(p37) -- Line: 67
                        -- upvalues: u36 (ref), tweenService (ref), u35 (copy), u10 (ref), u34 (copy), u7 (ref), u11 (ref)
                        u36 = u36 + p37;
                        local v38 = tweenService:GetValue(math.clamp(u36 / u35, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
                        u10 = u34 + v38 * (u7 - u34);

                        if v38 >= 1 and u11 then
                            u11:Disconnect();
                            u11 = nil;
                        end;
                    end);
                    u13 = v27;
                end;
            end;

            return CFrame.new(), u10;
        end);

        if not v39 then
            warn("AnimateFov: 注册移速影响相机FOV 失败", v40);
        end;

        return {
            destroy = function() -- Line: 153, Name: destroy
                -- upvalues: u11 (ref), cameraModule (copy)
                if u11 then
                    u11:Disconnect();
                    u11 = nil;
                end;

                cameraModule.DisableCameraEvent_Helper("移速影响相机FOV");
            end
        };
    end
};