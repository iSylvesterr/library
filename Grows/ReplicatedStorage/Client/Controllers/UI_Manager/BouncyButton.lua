-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local Knit = require(game.ReplicatedStorage.Packages.Knit);
local Maid = require(game.ReplicatedStorage.Packages.Maid);
local CustomEnum = require(game.ReplicatedStorage.Shared.Info.CustomEnum);
local LocalPlayer = game.Players.LocalPlayer;
local UI = game.SoundService:WaitForChild("SoundEffects"):WaitForChild("UI");
local Off = UI:WaitForChild("Off");
local On = UI:WaitForChild("On");
local Hover = UI:WaitForChild("Hover");
local u1 = {};

return function(p2) -- Line: 27
    -- upvalues: u1 (copy), TweenService (copy), Maid (copy), Knit (copy), CustomEnum (copy), Hover (copy), LocalPlayer (copy), Off (copy), On (copy)
    function p2.Bounce(p3, p4) -- Line: 34
        -- upvalues: u1 (ref), TweenService (ref)
        if not u1[p4] then
            return;
        end;

        if u1[p4].currentSize == "small" then
            if u1[p4].tween then
                u1[p4].tween:Cancel();
            end;

            u1[p4].currentSize = "small";
            p4.Size = u1[p4].ogSize;
            u1[p4].tween = TweenService:Create(p4, TweenInfo.new(0.1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0, true), {
                Size = u1[p4].smallerSize
            });
            u1[p4].tween:Play();

            return;
        end;

        if u1[p4].tween then
            u1[p4].tween:Cancel();
        end;

        u1[p4].currentSize = "big";
        p4.Size = u1[p4].bigSize;
        u1[p4].tween = TweenService:Create(p4, TweenInfo.new(0.1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0, true), {
            Size = u1[p4].ogSize
        });
        u1[p4].tween:Play();
    end;

    function p2.AddBounceButton(u5, u6, p7, u8) -- Line: 74
        -- upvalues: u1 (ref), Maid (ref), TweenService (ref), Knit (ref), CustomEnum (ref), Hover (ref), LocalPlayer (ref), Off (ref), On (ref)
        if not u6 then
            return;
        end;

        if not u1[u6] then
            u1[u6] = {};
            u1[u6].maid = Maid.new();
            u1[u6].tween = nil;
            u1[u6].currentSize = "small";
            u1[u6].ogSize = u6.Size;
            u1[u6].bigSize = UDim2.new(u1[u6].ogSize.X.Scale * p7, u1[u6].ogSize.X.Offset * p7, u1[u6].ogSize.Y.Scale * p7, u1[u6].ogSize.Y.Offset * p7);
            u1[u6].smallerSize = UDim2.new(u1[u6].ogSize.X.Scale / p7, u1[u6].ogSize.X.Offset / p7, u1[u6].ogSize.Y.Scale / p7, u1[u6].ogSize.Y.Offset / p7);
            u1[u6].maid:GiveTask(u6.MouseEnter:Connect(function() -- Line: 88
                -- upvalues: u1 (ref), u6 (copy), TweenService (ref), Knit (ref), CustomEnum (ref), Hover (ref), LocalPlayer (ref)
                if u1[u6].currentSize == "big" then
                    return;
                end;

                if u1[u6].tween then
                    u1[u6].tween:Cancel();
                end;

                u1[u6].currentSize = "big";
                u6.Size = u1[u6].ogSize;
                u1[u6].tween = TweenService:Create(u6, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = u1[u6].bigSize
                });
                u1[u6].tween:Play();

                if Knit.GetController("UserInputParser"):getInputType() ~= CustomEnum.INPUT_TYPES.MOBILE then
                    Knit.GetController("SoundController"):PlaySound(Hover, LocalPlayer, {
                        PlaybackSpeed = NumberRange.new(0.8, 1.2)
                    });
                end;
            end));
            u1[u6].maid:GiveTask(u6.MouseLeave:Connect(function() -- Line: 114
                -- upvalues: u1 (ref), u6 (copy), TweenService (ref)
                if u1[u6].currentSize == "small" then
                    return;
                end;

                if u1[u6].tween then
                    u1[u6].tween:Cancel();
                end;

                u1[u6].currentSize = "small";
                u6.Size = u1[u6].bigSize;
                u1[u6].tween = TweenService:Create(u6, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = u1[u6].ogSize
                });
                u1[u6].tween:Play();
            end));
            u1[u6].maid:GiveTask(u6.MouseButton1Down:Connect(function() -- Line: 134
                -- upvalues: u5 (copy), u6 (copy), u8 (copy), Knit (ref), Off (ref), LocalPlayer (ref), On (ref)
                u5:Bounce(u6);

                if u8 then
                    Knit.GetController("SoundController"):PlaySound(Off, LocalPlayer);

                    return;
                end;

                Knit.GetController("SoundController"):PlaySound(On, LocalPlayer);
            end));
            u1[u6].maid:GiveTask(function() -- Line: 144
                -- upvalues: u1 (ref), u6 (copy)
                if u1[u6].tween then
                    u1[u6].tween:Cancel();
                end;

                u6.Size = u1[u6].ogSize;
            end);

            return u1[u6];
        end;
    end;

    function p2.RemoveBounceButton(p9, p10) -- Line: 157
        -- upvalues: u1 (ref)
        if not p10 then
            return;
        end;

        if u1[p10] then
            u1[p10].maid:Destroy();
            u1[p10] = nil;
        end;
    end;
end;