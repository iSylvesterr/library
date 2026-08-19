-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 9
    local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
    local ReplicatedStorage = game:GetService("ReplicatedStorage");
    local VisibleMgr = UtilsSystem.VisibleMgr;
    local SoundModule = UtilsSystem.SoundModule;

    function u1.Settle_Skill_Effect(p2, p3) -- Line: 30
        -- upvalues: ReplicatedStorage (copy), VisibleMgr (copy), SoundModule (copy), u1 (copy)
        if not p2 then
            return;
        end;

        local ModelRes = ReplicatedStorage:FindFirstChild("ModelRes");

        if ModelRes then
            ModelRes = ModelRes:FindFirstChild("Effect");
        end;

        if ModelRes then
            ModelRes = ModelRes:FindFirstChild("受击效果");
        end;

        if not ModelRes then
            return;
        end;

        local u4 = ModelRes:Clone();
        u4.Parent = workspace;
        VisibleMgr.AnchoredAll(u4);
        VisibleMgr.UnTransparencyAll(u4);
        VisibleMgr.UnQueryAll(u4);
        VisibleMgr.UnCollideAll(u4);
        VisibleMgr.UnTouchAll(u4);
        local v5 = p3 or p2:GetPivot().Position;
        SoundModule:PlaySoundLocal({
            SoundName = "音效-命中敌人",
            Is2D = false,
            PlayPosition = v5
        });
        u4:PivotTo(CFrame.new(v5));
        u1.Emit_Particles_GetDescendants(u4, true);
        task.delay(2, function() -- Line: 64
            -- upvalues: u1 (ref), u4 (copy)
            u1.Debris(u4, 0);
        end);
    end;

    function u1.Settle_Skill_All_Effects(u6, p7, p8) -- Line: 75
        -- upvalues: u1 (copy)
        if not (u6 and p7) then
            return;
        end;

        local v9 = p8 or 0.1;

        for i = 1, p7 do
            task.delay(v9 * (i - 1), function() -- Line: 82
                -- upvalues: u1 (ref), u6 (copy)
                u1.Settle_Skill_Effect(u6);
            end);
        end;
    end;

    function u1.Hit_Effect(p10, p11, p12) -- Line: 94
        -- upvalues: u1 (copy), SoundModule (copy)
        u1.PlayEffect(p10, p11, 0.3, 3);
        SoundModule:PlaySoundLocal({
            Is2D = true,
            SoundName = p12 or "音效-命中敌人"
        });
    end;
end;