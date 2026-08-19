-- Decompiled with Potassium's decompiler.

local FXUtil = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).FXUtil;

local function resolvePath(p1, p2) -- Line: 14
    if not (p1 and p2) then
        return nil;
    end;

    for _, v in ipairs(p2) do
        p1 = p1:FindFirstChild(v);

        if not p1 then
            return nil;
        end;
    end;

    return p1;
end;

return {
    create = function(p3) -- Line: 41, Name: create
        -- upvalues: resolvePath (copy), FXUtil (copy)
        local onProjectileSpawnVisual = p3.onProjectileSpawnVisual;

        if type(onProjectileSpawnVisual) == "function" then
            return {
                onSpawnVisual = onProjectileSpawnVisual
            };
        end;

        local resolveProjectileLight = p3.resolveProjectileLight;
        local resolveProjectileAttachments = p3.resolveProjectileAttachments;
        local u4 = p3.projectileLightPath or { "灯", "PointLight" };
        local u5 = p3.projectileAttachmentLeftPath or { "Enabled1_普攻1", "Enabled1_L_1" };
        local u6 = p3.projectileAttachmentRightPath or { "Enabled1_普攻1", "Enabled1_R_1" };
        local u7 = p3.attachmentTweenOffset or Vector3.new(0, 0, 1.89);
        local u8 = p3.attachmentTweenTime or 0.3;
        local u9 = p3.lightTweenBrightness or 0.3;
        local u10 = p3.lightTweenDuration or 0.2;
        local u11 = p3.emitDelay or 2;

        return {
            onSpawnVisual = function(p12, p13) -- Line: 59, Name: onSpawnVisual
                -- upvalues: resolveProjectileLight (copy), resolvePath (ref), u4 (copy), FXUtil (ref), u10 (copy), u9 (copy), resolveProjectileAttachments (copy), u5 (copy), u6 (copy), u8 (copy), u7 (copy), u11 (copy)
                if not p13 then
                    return;
                end;

                local v14;

                if type(resolveProjectileLight) == "function" then
                    v14 = resolveProjectileLight(p13);
                else
                    v14 = resolvePath(p13, u4);
                end;

                if v14 and v14:IsA("PointLight") then
                    v14.Brightness = 0;
                    FXUtil.Tween_Instance(v14, TweenInfo.new(u10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Brightness = u9
                    });
                end;

                local v15, v16;

                if type(resolveProjectileAttachments) == "function" then
                    v15, v16 = resolveProjectileAttachments(p13);
                else
                    v15 = resolvePath(p13, u5);
                    v16 = resolvePath(p13, u6);
                end;

                if v15 and (v16 and (v15:IsA("Attachment") and v16:IsA("Attachment"))) then
                    FXUtil.Tween_Attachment_CFrame(v15, v16, u8, u7);
                end;

                FXUtil.Start_All_Emit(p13, u11);

                for _, descendant in pairs(p13:GetDescendants()) do
                    if descendant:IsA("Trail") then
                        descendant.Enabled = true;
                    elseif descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = true;
                    end;
                end;
            end
        };
    end
};