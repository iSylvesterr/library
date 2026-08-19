-- Decompiled with Potassium's decompiler.

local SocialService = game:GetService("SocialService");

local function resolveEventId(p1) -- Line: 7
    return (typeof(p1) ~= "string" or #p1 <= 0) and "393620987196867154" or p1;
end;

return {
    eventId = "393620987196867154",
    currentEvent = 1,

    PromptEvent = function(p2) -- Line: 14, Name: PromptEvent
        -- upvalues: SocialService (copy)
        local u3 = (typeof(p2) ~= "string" or #p2 <= 0) and "393620987196867154" or p2;
        local success, result = pcall(function() -- Line: 16
            -- upvalues: SocialService (ref), u3 (copy)
            return SocialService:PromptRsvpToEventAsync(u3);
        end);

        return success, result;
    end,

    IsSubscribed = function(p4) -- Line: 22, Name: IsSubscribed
        -- upvalues: SocialService (copy)
        local u5 = (typeof(p4) ~= "string" or #p4 <= 0) and "393620987196867154" or p4;
        local success, result = pcall(function() -- Line: 24
            -- upvalues: SocialService (ref), u5 (copy)
            return SocialService:GetEventRsvpStatusAsync(u5);
        end);

        if success then
            return result == Enum.RsvpStatus.Going;
        end;

        return false;
    end
};