-- Decompiled with Potassium's decompiler.

local v1 = {};
local RunService = game:GetService("RunService");
local u2 = {};

local function loudnessToMultiplier(p3) -- Line: 44
    return math.clamp(p3 / 300, 0, 1) ^ 2 * 0.3999999999999999 + 1;
end;

local function isBoomboxSound(p4) -- Line: 49
    local v5 = p4:IsA("Sound") and p4.Name == "BoomboxSound";

    return v5;
end;

local function resolveModel(p6) -- Line: 56
    local Parent = p6.Parent;

    if not Parent then
        return nil;
    end;

    local v7 = string.gsub(Parent.Name, "^Boombox_", "");

    if v7 == "" then
        return nil;
    end;

    local Parent2 = Parent.Parent;

    if not Parent2 or Parent2.Name ~= "BoomboxEmitters" then
        return nil;
    end;

    local Parent3 = Parent2.Parent;

    if not Parent3 then
        return nil;
    end;

    local Props = Parent3:FindFirstChild("Props");

    if not Props then
        return nil;
    end;

    local v8 = Props:FindFirstChild(v7);

    if v8 and v8:IsA("Model") then
        return v8;
    end;

    return nil;
end;

local function getBaseScale(p9) -- Line: 82
    local v10 = p9:GetAttribute("BoomboxBaseScale");

    if type(v10) == "number" and v10 > 0 then
        return v10;
    end;

    local v11 = p9:GetScale();
    local v12 = v11 <= 0 and 1 or v11;
    p9:SetAttribute("BoomboxBaseScale", v12);

    return v12;
end;

local function setBottomPivot(p13) -- Line: 99
    local v14, v15 = p13:GetBoundingBox();
    p13.WorldPivot = v14 * CFrame.new(0, -v15.Y / 2, 0);
end;

local function register(p16) -- Line: 104
    -- upvalues: u2 (copy)
    if u2[p16] then
        return;
    end;

    u2[p16] = {
        Model = nil,
        BaseScale = 1,
        Scale = 1,
        PivotSet = false
    };
end;

local function unregister(p17) -- Line: 109
    -- upvalues: u2 (copy)
    local v18 = u2[p17];

    if not v18 then
        return;
    end;

    local Model = v18.Model;

    if Model and Model.Parent then
        Model:ScaleTo(v18.BaseScale);
    end;

    u2[p17] = nil;
end;

local function onDescendantAdded(p19) -- Line: 119
    -- upvalues: u2 (copy)
    local v20 = p19:IsA("Sound") and p19.Name == "BoomboxSound";

    if v20 then
        if u2[p19] then
            return;
        end;

        u2[p19] = {
            Model = nil,
            BaseScale = 1,
            Scale = 1,
            PivotSet = false
        };
    end;
end;

local function update(p21) -- Line: 125
    -- upvalues: u2 (copy), resolveModel (copy)
    for i, v in u2 do
        if i.Parent and i:IsDescendantOf(workspace) then
            local Model = v.Model;

            if not (Model and Model.Parent) then
                Model = resolveModel(i);
                v.Model = Model;
                v.PivotSet = false;
            end;

            if Model then
                if not v.PivotSet then
                    local v22 = Model:GetAttribute("BoomboxBaseScale");

                    if type(v22) ~= "number" or v22 <= 0 then
                        local v23 = Model:GetScale();
                        v22 = v23 <= 0 and 1 or v23;
                        Model:SetAttribute("BoomboxBaseScale", v22);
                    end;

                    v.BaseScale = v22;
                    Model:ScaleTo(v.BaseScale);
                    local v24, v25 = Model:GetBoundingBox();
                    Model.WorldPivot = v24 * CFrame.new(0, -v25.Y / 2, 0);
                    v.Scale = 1;
                    v.PivotSet = true;
                end;

                local v26 = math.clamp((i.PlaybackLoudness or 0) / 300, 0, 1) ^ 2 * 0.3999999999999999 + 1;
                local v27 = 1 - math.exp(p21 * -12);
                v.Scale = v.Scale + (v26 - v.Scale) * v27;
                Model:ScaleTo(v.BaseScale * v.Scale);
            end;
        else
            local v28 = u2[i];

            if v28 then
                local Model = v28.Model;

                if Model and Model.Parent then
                    Model:ScaleTo(v28.BaseScale);
                end;

                u2[i] = nil;
            end;
        end;
    end;
end;

function v1.Init(p29) -- Line: 163
end;

function v1.Start(p30) -- Line: 166
    -- upvalues: u2 (copy), onDescendantAdded (copy), RunService (copy), update (copy)
    for _, descendant in workspace:GetDescendants() do
        local v31 = descendant:IsA("Sound") and descendant.Name == "BoomboxSound";

        if v31 then
            if not u2[descendant] then
                u2[descendant] = {
                    Model = nil,
                    BaseScale = 1,
                    Scale = 1,
                    PivotSet = false
                };
            end;
        end;
    end;

    workspace.DescendantAdded:Connect(onDescendantAdded);
    RunService.RenderStepped:Connect(update);
end;

return v1;