-- Decompiled with Potassium's decompiler.

local v1 = {};
local BG = script.Parent:FindFirstChild("BG");

if BG and BG:IsA("Frame") then
    BG = BG:FindFirstChild("Tips");
end;

if not (BG and BG:IsA("TextLabel")) then
    BG = nil;
end;

local u2 = false;

function v1.updateUi(p3, p4) -- Line: 40
end;

function v1.openUi(p5) -- Line: 47
    -- upvalues: BG (ref), u2 (ref)
    if not BG or u2 then
        return;
    end;

    u2 = true;
    task.spawn(function() -- Line: 53
        -- upvalues: BG (ref), u2 (ref)
        for _ = 1, 50 do
            if not BG then
                break;
            end;

            BG.Text = "Waiting for update...";
            task.wait(0.5);
            BG.Text = "Waiting for update..";
            task.wait(0.5);
            BG.Text = "Waiting for update.";
            task.wait(0.5);
            BG.Text = "Waiting for update";
            task.wait(0.5);
        end;

        u2 = false;
    end);
end;

function v1.closeUi(p6) -- Line: 75
    -- upvalues: u2 (ref)
    u2 = false;
end;

return v1;