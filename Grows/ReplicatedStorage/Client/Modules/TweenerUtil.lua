-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Packages = ReplicatedStorage.Packages;
local Trove = require(Packages.Trove);
local Signal = require(Packages.Signal);
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3) -- Line: 12
    -- upvalues: u1 (copy)
    local v4 = setmetatable({}, u1);
    v4:Construct(p2, p3);

    return v4;
end;

u1.Result = {
    Completed = "Completed",
    Failed = "Failed"
};

function u1.Construct(p5, p6, p7) -- Line: 24
    -- upvalues: Trove (copy), Signal (copy)
    p5._trove = Trove.new();
    p5._info = p6;
    p5._callback = p7;
    p5.Completed = Signal.new();
end;

function u1.GetValue(p8, p9) -- Line: 32
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(p9, p8._info.EasingStyle, p8._info.EasingDirection);
end;

function u1.Play(u10) -- Line: 36
    -- upvalues: RunService (copy)
    u10._trove:Add(task.spawn(function() -- Line: 37
        -- upvalues: u10 (copy), RunService (ref)
        local u11 = tick();
        local success, result = pcall(function() -- Line: 40
            -- upvalues: u10 (ref), RunService (ref), u11 (copy)
            u10._callback(u10:GetValue(0));

            while true do
                RunService.RenderStepped:Wait();
                local v12 = (tick() - u11) / u10._info.Time;

                if v12 >= 1 then
                    break;
                end;

                u10._callback(u10:GetValue(v12));
            end;

            u10._callback(u10:GetValue(1));
            u10.Completed:Fire(u10.Result.Completed);
        end);

        if not success then
            u10.Completed:Fire(u10.Result.Failed, result);
            error(result);
        end;
    end));
end;

function u1.Cancel(p13) -- Line: 67
    p13._trove:Clean();
end;

function u1.Destroy(p14) -- Line: 71
    p14._trove:Destroy();
end;

return u1;