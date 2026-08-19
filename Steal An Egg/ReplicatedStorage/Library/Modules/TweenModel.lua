-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local u1 = {};

return function(u2, p3, u4) -- Line: 5
    -- upvalues: u1 (copy), TweenService (copy)
    local v5 = u1[u2];

    if v5 then
        v5:Cancel();
        v5:Destroy();
        task.cancel(v5.Thread);
        u1[u2] = nil;
        print("Cancel last Loop!", u2);
    end;

    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = u2:GetScale();
    local CFrameValue = Instance.new("CFrameValue");
    CFrameValue.Value = u2:GetPivot();
    local u6 = TweenService:Create(NumberValue, p3, {
        Value = u4.Scale
    });
    local u7 = TweenService:Create(CFrameValue, p3, {
        Value = u4.CFrame
    });
    local u8 = nil;
    u8 = {
        Instance = u2,

        Play = function() -- Line: 26, Name: Play
            -- upvalues: u6 (copy), u7 (copy), u8 (ref), u4 (copy), u2 (copy), NumberValue (copy), CFrameValue (copy)
            u6:Play();
            u7:Play();
            task.spawn(function() -- Line: 29
                -- upvalues: u8 (ref), u6 (ref), u4 (ref), u2 (ref), NumberValue (ref), CFrameValue (ref)
                while true do
                    task.wait(0.01);
                    u8.PlaybackState = u6.PlaybackState;

                    if u6.PlaybackState ~= Enum.PlaybackState.Playing then
                        break;
                    end;

                    if u4.Scale then
                        u2:ScaleTo((math.clamp(NumberValue.Value, 1e-9, (1 / 0))));
                    end;

                    if u4.CFrame then
                        u2:PivotTo(CFrameValue.Value);
                    end;
                end;
            end);
        end,

        Pause = function() -- Line: 46, Name: Pause
            -- upvalues: u6 (copy), u7 (copy)
            u6:Pause();
            u7:Pause();
        end,

        Destroy = function() -- Line: 50, Name: Destroy
            -- upvalues: u6 (copy), u7 (copy)
            u6:Destroy();
            u7:Destroy();
        end,

        Cancel = function() -- Line: 54, Name: Cancel
            -- upvalues: u6 (copy), u7 (copy)
            u6:Cancel();
            u7:Cancel();
        end,

        PlaybackState = Enum.PlaybackState.Begin,
        TweenInfo = p3,
        Completed = u6.Completed,
        Thread = task.delay(180, function() -- Line: 61
            -- upvalues: u1 (ref), u2 (copy)
            u1[u2] = nil;
        end)
    };
    u1[u2] = u8;

    return u8;
end;