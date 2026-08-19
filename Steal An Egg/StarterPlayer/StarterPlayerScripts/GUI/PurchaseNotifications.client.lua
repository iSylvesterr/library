-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Network = require(ReplicatedStorage.Library.Client.Network);
local Functions = require(ReplicatedStorage.Library.Functions);
local Confetti = require(ReplicatedStorage.Library.Client.GUIFX.Confetti);
local Audio = require(ReplicatedStorage.Library.Audio);
local Message = require(ReplicatedStorage.Library.Client.Message);
local Save = require(ReplicatedStorage.Library.Client.Save);
Network.Fired("Gamepass Bought"):Connect(function(p1) -- Line: 9
    -- upvalues: Save (copy), Audio (copy), Confetti (copy), Message (copy)
    if not Save.Get() then
        return;
    end;

    Audio.Play("rbxassetid://98002834893313", script, 1, 1);
    Confetti.Play();
    Message.New("Purchase successful! Thank you so much! 😄");
end);

function onProductBought(p2, p3, p4)
    -- upvalues: Save (copy), Functions (copy), Audio (copy), Confetti (copy), Message (copy)
    if not Save.Get() then
        return;
    end;

    local u5 = nil;
    local u6 = "Purchase successful! Thank you so much! 😄";

    if p4 then
        local v7 = Functions.UserIdToUsername(p4);

        if v7 then
            u5 = Functions.GetThumbnailFromUserIdAsync(p4, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150);
            u6 = `Gift sent to {v7}'s mailbox! Thank you so much! 😄`;
        end;
    end;

    task.delay(0.5, function() -- Line: 39
        -- upvalues: Audio (ref), Confetti (ref), Message (ref), u6 (ref), u5 (ref)
        Audio.Play("rbxassetid://98002834893313", script, 1, 1);
        Confetti.Play();
        Message.New(u6, {
            icon = u5
        });
    end);
end;

Network.Fired("Product Bought"):Connect(onProductBought);
Network.Fired("Products: Receipt Processed"):Connect(onProductBought);
Network.Fired("Product Failed"):Connect(function(p8) -- Line: 50
    -- upvalues: Message (copy)
    task.delay(120, function() -- Line: 51
        -- upvalues: Message (ref)
        Message.New("ERROR: Purchase failed! If this continues to happen let us know! Roblox should be refunding you automatically. Sorry 😊");
    end);
end);

return {};