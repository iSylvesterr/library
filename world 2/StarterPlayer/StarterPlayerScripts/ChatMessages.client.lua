-- Decompiled with Potassium's decompiler.

local TextChatService = game:GetService("TextChatService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local u1 = {
    "<font color=\"#00aaff\"><b>[TIP]</b></font> Your garden literally grows <font color=\"#55ff7f\"><b>offline</b></font>!",
    "<font color=\"#00aaff\"><b>[TIP]</b></font> Fruits <font color=\"#ff5555\"><b>decay</b></font> if you go away too long!",
    "<font color=\"#00aaff\"><b>[TIP]</b></font> Pets have a chance to be <font color=\"#55aaff\"><b>big</b></font>... or even <font color=\"#aa55ff\"><b>mega</b></font>!",
    "<font color=\"#00aaff\"><b>[TIP]</b></font> Invite your <font color=\"#55ff7f\"><b>friends</b></font> for <font color=\"#ffd700\"><b>sheckles bonuses</b></font> and more fun!",
    "<font color=\"#00aaff\"><b>[TIP]</b></font> <font color=\"#55aaff\"><b>Watering cans</b></font> make plants grow faster, and may make <font color=\"#ffd700\"><b>seed packs luckier</b></font>!",
    "<font color=\"#00aaff\"><b>[TIP]</b></font> <font color=\"#55aaff\"><b>Sprinklers</b></font> give your plants more <font color=\"#ffd700\"><b>luck</b></font>!",
    "<font color=\"#00aaff\"><b>[TIP]</b></font> Some <font color=\"#ff8855\"><b>props</b></font> can be used for <font color=\"#ff8855\"><b>defense</b></font>!"
};
local RBXGeneral = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral");
Networking.ChatAnnouncement.OnClientEvent:Connect(function(p2) -- Line: 22
    -- upvalues: RBXGeneral (copy)
    if type(p2) ~= "string" then
        return;
    end;

    RBXGeneral:DisplaySystemMessage(p2);
end);
task.spawn(function() -- Line: 27
    -- upvalues: u1 (copy), RBXGeneral (copy)
    local v3 = nil;
    local v4 = nil;

    while true do
        task.wait(300);
        local v5;

        repeat
            v5 = math.random(1, #u1);
        until v5 ~= v3 and v5 ~= v4;

        RBXGeneral:DisplaySystemMessage(u1[v5]);
        v4 = v3;
        v3 = v5;
    end;
end);