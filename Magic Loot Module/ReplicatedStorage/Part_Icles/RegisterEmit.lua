-- Decompiled with Potassium's decompiler.

local Events = require(script.Parent.Events);

return function(p1) -- Line: 15
    -- upvalues: Events (copy)
    function p1._registerEmit(p2, p3, p4) -- Line: 18
        -- upvalues: Events (ref)
        if (p2.MAX_ACTIVE_PARTICLES or 1000) <= #p2.ActiveEmits + (p2._lingerVisualCount or 0) then
            local v5 = p3.IsAnimate and ((p3.Type == "Part" or (p3.Type == "Attachment" or p3.Type == "Beam")) and true or p3.Type == "Model");

            if p3.IsAnimate and p3._sourceItem then
                p2.ActiveAnimates[p3._sourceItem] = nil;
            end;

            if not v5 and (p3.VisualPart and p3.VisualPart.Parent) then
                p2:_releaseOrDestroy(p3, p3.VisualPart);
            end;

            return;
        end;

        p3.EventChainCtx = p4 and p4.ChainCtx or (p3.EventChainCtx or Events.newChainCtx());
        local v6;

        if p4 then
            v6 = p4._playToken;
        else
            v6 = p4;
        end;

        if v6 then
            p3._playToken = v6;

            if v6.TsOverride ~= nil and (v6.TsUntil and os.clock() < v6.TsUntil) then
                p3._tsOverride = v6.TsOverride;
                p3._tsOverrideUntil = v6.TsUntil;
            end;
        end;

        table.insert(p2.ActiveEmits, p3);

        if p3.Events and p3.Events.OnHit then
            p3.LastHitCheckPos = Events.getWorldPosition(p3);
            p3.HitParams = Events.makeHitParams(p3);
            p3._hitFired = false;
        end;

        if p3.Events and p3.Events.OnEmit then
            local v7 = Events.makePayload(p2, p3, "OnEmit", p4);
            Events.fire(p2, p3, "OnEmit", p3.EventChainCtx, v7);
        end;
    end;
end;