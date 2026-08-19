-- Decompiled with Potassium's decompiler.

return {
    AFK_TELEPORT_FLAG = "afk",

    afkTeleportData = function() -- Line: 3, Name: afkTeleportData
        return {
            afk = true
        };
    end,

    wasAfkTeleport = function(p1) -- Line: 8, Name: wasAfkTeleport
        local TeleportData = p1:GetJoinData().TeleportData;

        if type(TeleportData) == "table" then
            return TeleportData.afk == true;
        end;

        return false;
    end
};