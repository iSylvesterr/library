-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local CollectionService = game:GetService("CollectionService");
local Name = script.Name;
local u1 = {};
local u2 = {};
local v3 = {};

for _, v in CollectionService:GetTagged(Name) do
    if v:IsA("BasePart") then
        table.insert(u1, v);
    end;
end;

CollectionService:GetInstanceAddedSignal(Name):Connect(function(p4) -- Line: 17
    -- upvalues: u1 (copy)
    if p4:IsA("BasePart") then
        table.insert(u1, p4);
    end;
end);

function v3.Start(p5) -- Line: 30
    -- upvalues: u1 (copy), u2 (copy), TweenService (copy)
    task.spawn(function() -- Line: 32
        -- upvalues: u1 (ref), u2 (ref), TweenService (ref)
        while true do
            local v6 = (1 / 0);

            for _, v in u1 do
                if v.Position.Y < v6 then
                    v6 = v.Position.Y;
                end;
            end;

            for _, v in u1 do
                if v.Parent then
                    if not u2[v] then
                        u2[v] = v.Color;
                    end;

                    local u7 = u2[v];
                    local v8, v9, v10 = u7:ToHSV();
                    local u11 = Color3.fromHSV(v8, v9, (math.clamp(v10 * 1.5, 0, 1)));
                    task.delay((v.Position.Y - v6) * 0.5, function() -- Line: 59
                        -- upvalues: TweenService (ref), v (copy), u11 (copy), u7 (copy)
                        local v12 = TweenService:Create(v, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                            Color = u11
                        });
                        local v13 = TweenService:Create(v, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                            Color = u7
                        });
                        v12:Play();
                        v12.Completed:Wait();
                        v13:Play();
                    end);
                end;
            end;

            task.wait(2);
        end;
    end);
end;

return v3;