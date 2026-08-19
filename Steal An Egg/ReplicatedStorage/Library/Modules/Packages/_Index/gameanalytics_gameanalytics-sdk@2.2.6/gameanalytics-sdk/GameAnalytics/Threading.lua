-- Decompiled with Potassium's decompiler.

local u1 = {
    _canSafelyClose = true,
    _endThread = false,
    _isRunning = false,
    _scheduledBlock = nil,
    _hasScheduledBlockRun = true,
    _blocks = {}
};
local Logger = require(script.Parent.Logger);
local RunService = game:GetService("RunService");

local function getScheduledBlock() -- Line: 13
    -- upvalues: u1 (copy)
    local v2 = tick();

    if u1._hasScheduledBlockRun or (u1._scheduledBlock == nil or u1._scheduledBlock.deadline > v2) then
        return nil;
    end;

    u1._hasScheduledBlockRun = true;

    return u1._scheduledBlock;
end;

local function run() -- Line: 28
    -- upvalues: Logger (copy), u1 (copy), RunService (copy)
    task.spawn(function() -- Line: 29
        -- upvalues: Logger (ref), u1 (ref)
        Logger:d("Starting GA thread");

        while not u1._endThread do
            u1._canSafelyClose = false;

            if #u1._blocks ~= 0 then
                for _, v in pairs(u1._blocks) do
                    local success, result = pcall(v.block);

                    if not success then
                        Logger:e(result);
                    end;
                end;

                u1._blocks = {};
            end;

            local v3 = tick();
            local v4;

            if u1._hasScheduledBlockRun or (u1._scheduledBlock == nil or u1._scheduledBlock.deadline > v3) then
                v4 = nil;
            else
                u1._hasScheduledBlockRun = true;
                v4 = u1._scheduledBlock;
            end;

            if v4 ~= nil then
                local success, result = pcall(v4.block);

                if not success then
                    Logger:e(result);
                end;
            end;

            u1._canSafelyClose = true;
            task.wait(1);
        end;

        Logger:d("GA thread stopped");
    end);
    game:BindToClose(function() -- Line: 62
        -- upvalues: RunService (ref), u1 (ref)
        if RunService:IsStudio() then
            return;
        end;

        task.wait(1);

        if not u1._canSafelyClose then
            repeat
                task.wait();
            until u1._canSafelyClose;
        end;

        task.wait(3);
    end);
end;

function u1.scheduleTimer(p5, p6, p7) -- Line: 82
    -- upvalues: run (copy)
    if p5._endThread then
        return;
    end;

    if not p5._isRunning then
        p5._isRunning = true;
        run();
    end;

    local v8 = {
        block = p7,
        deadline = tick() + p6
    };

    if p5._hasScheduledBlockRun then
        p5._scheduledBlock = v8;
        p5._hasScheduledBlockRun = false;
    end;
end;

function u1.performTaskOnGAThread(p9, p10) -- Line: 103
    -- upvalues: run (copy)
    if p9._endThread then
        return;
    end;

    if not p9._isRunning then
        p9._isRunning = true;
        run();
    end;

    p9._blocks[#p9._blocks + 1] = {
        block = p10
    };
end;

function u1.stopThread(p11) -- Line: 120
    p11._endThread = true;
end;

return u1;