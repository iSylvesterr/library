-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local TreadmillVideoController = require(ReplicatedStorage.Library.Client.TreadmillVideoController);
require(ReplicatedStorage.Library.Client.TreadmillVideoController.Types.Interface);
local u1 = GUI.StaticTreadmillImageSurfaceGui();
local v2 = u1:IsA("SurfaceGui");
assert(v2, "Static treadmill image GUI must be a SurfaceGui");
local u10 = {
    Create = function(p3, p4) -- Line: 23, Name: Create
        -- upvalues: u1 (copy)
        local v5 = u1:Clone();
        v5.Name = p3;
        v5.Adornee = p4;
        v5.Enabled = true;
        v5.Parent = u1.Parent;

        return v5;
    end,

    SetEnabled = function(p6, p7) -- Line: 32, Name: SetEnabled
        p6.Enabled = p7;
    end,

    ApplyMedia = function(p8, p9) -- Line: 36, Name: ApplyMedia
        -- upvalues: TreadmillVideoController (copy)
        p8.VideoFrame.Image.Image = TreadmillVideoController.ResolveCoverImage(p9);
        p8.VideoFrame.StopPlay.Image = TreadmillVideoController.GetStoppedIconImage();
        p8.VideoFrame.StopPlay.Visible = true;
    end
};

function u10.ApplyFeed(p11, p12) -- Line: 45
    -- upvalues: u10 (copy), TreadmillVideoController (copy)
    u10.ApplyMedia(p11, TreadmillVideoController.GetCurrentMediaEntry(p12));
end;

return u10;