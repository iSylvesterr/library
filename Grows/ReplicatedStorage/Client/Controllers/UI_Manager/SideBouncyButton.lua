-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local Knit = require(game.ReplicatedStorage.Packages.Knit);
local Maid = require(game.ReplicatedStorage.Packages.Maid);
local CustomEnum = require(game.ReplicatedStorage.Shared.Info.CustomEnum);
local LocalPlayer = game.Players.LocalPlayer;
local UI = game.SoundService:WaitForChild("SoundEffects"):WaitForChild("UI");
UI:WaitForChild("Off");
local On = UI:WaitForChild("On");
local Hover = UI:WaitForChild("Hover");
local u1 = {};

return function(p2) -- Line: 27
    -- upvalues: u1 (copy), TweenService (copy), Maid (copy), Knit (copy), CustomEnum (copy), Hover (copy), LocalPlayer (copy), On (copy)
    function p2.SideBounce(p3, p4) -- Line: 34
        -- upvalues: u1 (ref), TweenService (ref)
        if not u1[p4] then
            return;
        end;

        if u1[p4].lockedOut then
            return;
        end;

        if u1[p4].tween then
            u1[p4].tween:Cancel();
        end;

        u1[p4].currentSlide = "out";
        p4.Size = u1[p4].outSize1;
        u1[p4].tween = TweenService:Create(p4, TweenInfo.new(0.1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0, true), {
            Size = u1[p4].outSize2
        });
        u1[p4].tween:Play();
    end;

    function p2.AddSideBounceButton(u5, u6, p7, p8, u9) -- Line: 56
        -- upvalues: u1 (ref), Maid (ref), TweenService (ref), Knit (ref), CustomEnum (ref), Hover (ref), LocalPlayer (ref), On (ref)
        if not u6 then
            return;
        end;

        if not u1[u6] then
            u1[u6] = {};
            u1[u6].maid = Maid.new();
            u1[u6].tween = nil;
            u1[u6].currentSlide = "in";
            u1[u6].lockedOut = false;
            u1[u6].ogSize = u6.Size;
            u1[u6].outSize1 = UDim2.new(u1[u6].ogSize.X.Scale * p7, u1[u6].ogSize.X.Offset * p7, u1[u6].ogSize.Y.Scale, u1[u6].ogSize.Y.Offset);
            u1[u6].outSize2 = UDim2.new(u1[u6].ogSize.X.Scale * p8, u1[u6].ogSize.X.Offset * p8, u1[u6].ogSize.Y.Scale, u1[u6].ogSize.Y.Offset);
            u1[u6].maid:GiveTask(u6.MouseEnter:Connect(function() -- Line: 81
                -- upvalues: u1 (ref), u6 (copy), TweenService (ref), Knit (ref), CustomEnum (ref), Hover (ref), LocalPlayer (ref)
                if u1[u6].currentSlide == "out" then
                    return;
                end;

                if u1[u6].lockedOut then
                    return;
                end;

                if u1[u6].tween then
                    u1[u6].tween:Cancel();
                end;

                u1[u6].currentSlide = "out";
                u6.Size = u1[u6].ogSize;
                u1[u6].tween = TweenService:Create(u6, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = u1[u6].outSize1
                });
                u1[u6].tween:Play();

                if Knit.GetController("UserInputParser"):getInputType() ~= CustomEnum.INPUT_TYPES.MOBILE then
                    Knit.GetController("SoundController"):PlaySound(Hover, LocalPlayer, {
                        PlaybackSpeed = NumberRange.new(0.8, 1.2)
                    });
                end;
            end));
            u1[u6].maid:GiveTask(u6.MouseLeave:Connect(function() -- Line: 108
                -- upvalues: u1 (ref), u6 (copy), TweenService (ref)
                if u1[u6].currentSlide == "in" then
                    return;
                end;

                if u1[u6].lockedOut then
                    return;
                end;

                if u1[u6].tween then
                    u1[u6].tween:Cancel();
                end;

                u1[u6].currentSlide = "in";
                u6.Size = u1[u6].outSize1;
                u1[u6].tween = TweenService:Create(u6, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = u1[u6].ogSize
                });
                u1[u6].tween:Play();
            end));
            u1[u6].maid:GiveTask(u6.MouseButton1Down:Connect(function() -- Line: 129
                -- upvalues: u1 (ref), u6 (copy), u9 (copy), u5 (copy), Knit (ref), On (ref), LocalPlayer (ref)
                if u1[u6].lockedOut then
                    return;
                end;

                if u9 then
                    u5:SideBounce(u6);
                end;

                Knit.GetController("SoundController"):PlaySound(On, LocalPlayer);
            end));
            u1[u6].maid:GiveTask(function() -- Line: 139
                -- upvalues: u1 (ref), u6 (copy)
                if u1[u6].tween then
                    u1[u6].tween:Cancel();
                end;

                u6.Size = u1[u6].ogSize;
            end);

            return u1[u6];
        end;
    end;

    function p2.LockSideButtonOut(p10, p11) -- Line: 151
        -- upvalues: u1 (ref), TweenService (ref)
        if not u1[p11] then
            return;
        end;

        if u1[p11].lockedOut == true then
            return;
        end;

        u1[p11].lockedOut = true;

        if u1[p11].tween then
            u1[p11].tween:Cancel();
        end;

        u1[p11].currentSlide = "out";
        p11.Size = u1[p11].ogSize;
        u1[p11].tween = TweenService:Create(p11, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = u1[p11].outSize1
        });
        u1[p11].tween:Play();
    end;

    function p2.UnlockSideButtonOut(p12, p13) -- Line: 174
        -- upvalues: u1 (ref), TweenService (ref)
        if not u1[p13] then
            return;
        end;

        if u1[p13].lockedOut == false then
            return;
        end;

        u1[p13].lockedOut = false;

        if u1[p13].tween then
            u1[p13].tween:Cancel();
        end;

        u1[p13].currentSlide = "in";
        p13.Size = u1[p13].outSize1;
        u1[p13].tween = TweenService:Create(p13, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = u1[p13].ogSize
        });
        u1[p13].tween:Play();
    end;

    function p2.RemoveSideBounceButton(p14, p15) -- Line: 198
        -- upvalues: u1 (ref)
        if not p15 then
            return;
        end;

        if u1[p15] then
            u1[p15].maid:Destroy();
            u1[p15] = nil;
        end;
    end;
end;