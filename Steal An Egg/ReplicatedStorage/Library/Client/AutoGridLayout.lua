-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FFlags = require(ReplicatedStorage.Library.Client.FFlags);
local ScreenResolution = require(script.Parent.ScreenResolution);
local u1 = {};
local u2 = {};

local function registerUpdater(u3, p4, u5, u6) -- Line: 28
    -- upvalues: u2 (copy), ScreenResolution (copy), FFlags (copy)
    local u7 = u3:FindFirstChildOfClass("UIGridLayout");
    assert(u7 ~= nil, "UIGridLayout not found in the provided container");
    local u8 = u3:FindFirstAncestorOfClass("ScreenGui");
    local u9 = u3:FindFirstChildOfClass("UIPadding");
    local u10;

    if u3:IsA("ScrollingFrame") then
        u10 = u3;
    else
        u10 = u3:FindFirstAncestorOfClass("ScrollingFrame");
    end;

    local u11 = nil;

    if u5 == true then
        for _, child in ipairs(u3:GetChildren()) do
            local v12 = child:FindFirstChildOfClass("UIAspectRatioConstraint");

            if v12 ~= nil then
                u11 = v12.AspectRatio;
                break;
            end;
        end;
    end;

    if p4 == nil or #p4 == 0 then
        local function v13() -- Line: 55
        end;

        u2[u3] = v13;

        return v13;
    end;

    local u14 = table.clone(p4);
    table.sort(u14, function(p15, p16) -- Line: 61
        return p15.ResolutionThreshold < p16.ResolutionThreshold;
    end);

    local function updateLayout() -- Line: 65
        -- upvalues: ScreenResolution (ref), u14 (copy), u3 (copy), u10 (copy), u9 (copy), u8 (copy), u5 (copy), u11 (ref), u7 (copy), u6 (copy)
        local v17 = ScreenResolution.GetScale();
        local v18 = nil;

        for _, v in ipairs(u14) do
            if v17 < v.ResolutionThreshold then
                v18 = v;
                break;
            end;
        end;

        assert(v18 ~= nil, "No layout configuration matched the current resolution scale");
        local AbsoluteSize = u3.AbsoluteSize;
        local PerRow = v18.PerRow;
        local v19 = v18.Padding or UDim2.new();

        if v18.ScalePaddingOffset == true then
            assert(u10 ~= nil, "Window-scaled AutoGridLayout padding requires a ScrollingFrame");
            local AbsoluteWindowSize = u10.AbsoluteWindowSize;
            local v20;

            if AbsoluteWindowSize.X > 0 then
                v20 = AbsoluteWindowSize.Y > 0;
            else
                v20 = false;
            end;

            assert(v20, "AutoGridLayout scrolling window size must be greater than zero");
            v19 = UDim2.new(0, math.floor(v19.X.Scale * AbsoluteWindowSize.X + v19.X.Offset), 0, (math.floor(v19.Y.Scale * AbsoluteWindowSize.Y + v19.Y.Offset)));
        end;

        local v21 = (AbsoluteSize.X - (u10 == nil and 0 or u10.ScrollBarThickness) - (u9 == nil and 0 or u9.PaddingLeft.Offset + u9.PaddingLeft.Scale * AbsoluteSize.X) - (u9 == nil and 0 or u9.PaddingRight.Offset + u9.PaddingRight.Scale * AbsoluteSize.X)) / PerRow - (v19.X.Offset + v19.X.Scale * AbsoluteSize.X);

        if u8 ~= nil then
            local v22 = u8:FindFirstChildOfClass("Frame");

            if v22 ~= nil then
                local TabControllerUIScale = v22:FindFirstChild("TabControllerUIScale");

                if TabControllerUIScale ~= nil and TabControllerUIScale:IsA("UIScale") then
                    v21 = v21 / TabControllerUIScale.Scale;
                end;
            end;
        end;

        local v23;

        if u5 == true and u11 ~= nil then
            v23 = math.floor(v21 / u11);
        else
            v23 = v21;
        end;

        local v24 = math.floor(v21);
        u7.CellPadding = v19;
        u7.CellSize = UDim2.fromOffset(v24, v23);

        if u10 ~= nil then
            local v25 = 0;

            if u9 ~= nil then
                v25 = v25 + (u9.PaddingBottom.Offset + u9.PaddingTop.Offset + u9.PaddingBottom.Scale * AbsoluteSize.Y + u9.PaddingTop.Scale * AbsoluteSize.Y);
            end;

            u10.CanvasSize = UDim2.new(0, u7.AbsoluteContentSize.X, 0, u7.AbsoluteContentSize.Y + v25 + (u6 or 0));
        end;
    end;

    local function v26() -- Line: 146
        -- upvalues: updateLayout (copy), FFlags (ref)
        updateLayout();

        if FFlags.Get(FFlags.Keys.DoubleAutoResolution) then
            task.delay(0.1, updateLayout);
        end;
    end;

    u2[u3] = v26;

    return v26;
end;

function u1.Register(p27, p28, p29, p30) -- Line: 160
    -- upvalues: registerUpdater (copy)
    return registerUpdater(p27, p28, p29, p30);
end;

function u1.Update(p31) -- Line: 169
    -- upvalues: u2 (copy)
    local v32 = u2[p31];
    assert(v32 ~= nil, "AutoGridLayout updater was not registered for the provided container");
    v32();
end;

return setmetatable(u1, {
    __call = function(p33, p34, p35, p36, p37) -- Line: 176, Name: __call
        -- upvalues: u1 (copy)
        return u1.Register(p34, p35, p36, p37);
    end
});