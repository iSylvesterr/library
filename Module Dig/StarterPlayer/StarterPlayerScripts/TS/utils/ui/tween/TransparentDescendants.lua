-- Decompiled with Potassium's decompiler.

local tweenAndDestroy = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, script.Parent, "playAndDestroy").tweenAndDestroy;

return {
    TransparentDescendents = function(p1, p2, p3) -- Line: 4
        -- upvalues: tweenAndDestroy (copy)
        local v4 = p2 == nil and true or p2;
        local v5 = p3 or TweenInfo.new(0.1, Enum.EasingStyle.Linear);

        for _, descendant in p1:GetDescendants() do
            local v6 = descendant:GetAttribute("Visible");
            local v7 = (not v4 or type(v6) ~= "number") and (v4 and 0 or 1) or v6;

            if descendant:IsA("Frame") then
                tweenAndDestroy(descendant, v5, {
                    Transparency = v7
                });
            elseif descendant:IsA("TextLabel") then
                tweenAndDestroy(descendant, v5, {
                    TextTransparency = v7
                });
            elseif descendant:IsA("TextButton") then
                tweenAndDestroy(descendant, v5, {
                    TextTransparency = v7
                });
            elseif descendant:IsA("ImageButton") then
                tweenAndDestroy(descendant, v5, {
                    ImageTransparency = v7
                });
            elseif descendant:IsA("ImageLabel") then
                tweenAndDestroy(descendant, v5, {
                    ImageTransparency = v7
                });
            elseif descendant:IsA("UIStroke") then
                tweenAndDestroy(descendant, v5, {
                    Transparency = v7
                });
            end;
        end;
    end
};