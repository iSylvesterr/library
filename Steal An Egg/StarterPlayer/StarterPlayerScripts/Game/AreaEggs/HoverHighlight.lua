-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Library.Modules.Packages.Trove);
local v1 = {};

local function showHighlight(p2) -- Line: 18
    local Highlight = Instance.new("Highlight");
    Highlight.Name = "AreaEggHover";
    Highlight.FillTransparency = 1;
    Highlight.OutlineTransparency = 1;
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255);
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    Highlight.Adornee = p2;
    Highlight.Parent = p2;

    return Highlight;
end;

function v1.Bind(u3, p4, p5) -- Line: 34
    -- upvalues: Asserts (copy), TweenService (copy)
    Asserts.Model(u3);
    Asserts.Instance(p4);
    local u6 = nil;
    p5:Connect(p4.PromptShown, function() -- Line: 39
        -- upvalues: u6 (ref), u3 (copy), TweenService (ref)
        if u6 ~= nil then
            u6:Destroy();
        end;

        local v7 = u3;
        local Highlight = Instance.new("Highlight");
        Highlight.Name = "AreaEggHover";
        Highlight.FillTransparency = 1;
        Highlight.OutlineTransparency = 1;
        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255);
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
        Highlight.Adornee = v7;
        Highlight.Parent = v7;
        u6 = Highlight;
        TweenService:Create(u6, TweenInfo.new(0.15), {
            OutlineTransparency = 0
        }):Play();
    end);
    p5:Connect(p4.PromptHidden, function() -- Line: 46
        -- upvalues: u6 (ref), TweenService (ref)
        local u8 = u6;
        u6 = nil;

        if u8 == nil then
            return;
        end;

        local v9 = TweenService:Create(u8, TweenInfo.new(0.12), {
            OutlineTransparency = 1
        });
        v9.Completed:Once(function() -- Line: 53
            -- upvalues: u8 (copy)
            u8:Destroy();
        end);
        v9:Play();
    end);
end;

return v1;