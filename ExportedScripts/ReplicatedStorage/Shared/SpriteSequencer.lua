-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local u1 = 60;
local u2 = {};
local u3 = tick();
local u4 = 0;

local function updateSequences() -- Line: 34
    -- upvalues: u4 (ref), u3 (ref), u1 (ref), u2 (copy)
    u4 = u4 + 1;
    local v5 = tick();
    local v6 = v5 - u3;

    if v6 >= 1 then
        u1 = math.floor(u4 / v6);
        u3 = v5;
        u4 = 0;
    end;

    for i, v in u2 do
        if i and i.Parent then
            v._nextFrame(v5);
        else
            v.stop();
        end;
    end;
end;

if RunService:IsClient() then
    RunServiceController.BindToRenderStep("Shared.SpriteSequencer.Update", updateSequences);
else
    RunServiceController.BindToHeartbeat("Shared.SpriteSequencer.Update", updateSequences);
end;

local u17 = {
    new = function(u7, u8) -- Line: 67, Name: new
        -- upvalues: u1 (ref), u2 (copy)
        local u9 = {
            looping = false,
            cells = u8,
            framerate = u1
        };

        function u9.play(p10, p11) -- Line: 74
            -- upvalues: u1 (ref), u9 (copy), u2 (ref), u7 (copy)
            u9.looping = p11 or false;
            u9.framerate = p10 or u1;
            local v12 = u2[u7.instance];

            if v12 then
                if v12 == u9 then
                    return;
                end;

                v12.stop();
            end;

            u2[u7.instance] = u9;
        end;

        function u9.isPlaying() -- Line: 91
            -- upvalues: u2 (ref), u7 (copy), u9 (copy)
            return u2[u7.instance] == u9;
        end;

        local u13 = 0;
        local u14 = tick();

        function u9._nextFrame(p15) -- Line: 97
            -- upvalues: u14 (ref), u9 (copy), u13 (ref), u7 (copy), u8 (copy)
            if p15 - u14 < 1 / u9.framerate then
                return;
            end;

            u14 = p15;
            u13 = u13 + 1;
            u7.display(u8[u13]);

            if u13 >= #u8 then
                if u9.looping then
                    u13 = 0;

                    return;
                end;

                u9.stop();
            end;
        end;

        function u9.stop() -- Line: 113
            -- upvalues: u13 (ref), u2 (ref), u7 (copy), u9 (copy)
            u13 = 0;
            local v16 = u2[u7.instance];

            if not v16 then
                return;
            end;

            if v16 ~= u9 then
                return;
            end;

            u2[u7.instance] = nil;
        end;

        return u9;
    end
};

function u17.fromRange(p18, p19, p20) -- Line: 126
    -- upvalues: u17 (copy)
    assert(p20 - p19 > 0, ".fromRange only accepts positive ranges");
    local v21 = {};

    for i = p19, p20 do
        v21[#v21 + 1] = i;
    end;

    return u17.new(p18, v21);
end;

return u17;