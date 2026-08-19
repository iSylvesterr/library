-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CaptureService = game:GetService("CaptureService");
local Promise = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Promise"));

function v1.CaptureScreenshot(u2) -- Line: 18
    -- upvalues: Promise (copy), CaptureService (copy)
    return Promise.new(function(u3, p4) -- Line: 19
        -- upvalues: CaptureService (ref), u2 (copy)
        local success, result = pcall(function() -- Line: 20
            -- upvalues: CaptureService (ref), u2 (ref), u3 (copy)
            CaptureService:CaptureScreenshot(function(p5) -- Line: 21
                -- upvalues: u2 (ref), u3 (ref)
                if u2 then
                    u2(p5);
                end;

                u3(p5);
            end);
        end);

        if not success then
            p4(result);
        end;
    end);
end;

return v1;