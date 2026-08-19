-- Decompiled with Potassium's decompiler.

local Presets = script.Presets;
local u1 = {
    Gradient = require(script.Gradient),
    Stroke = require(script.Stroke),
    Dropshadow = require(script.Dropshadow),
    Templates = require(script.GradientTemplates)
};
u1.__index = u1;
u1.CurrentEffects = {};
local u2 = {
    ScreenGui = "Enabled",
    BillboardGui = "Enabled",
    SurfaceGui = "Enabled"
};

local function ValidateIsPreset(p3) -- Line: 31
    -- upvalues: Presets (copy)
    return Presets:FindFirstChild(p3) ~= nil;
end;

function u1.new(u4, p5, p6, p7, p8, p9, p10, p11, p12) -- Line: 35
    -- upvalues: Presets (copy), u1 (copy), u2 (copy)
    assert(u4, "UIInstance not provided");
    assert(p5, "EffectType not provided");
    local v13 = u4:IsA("GuiObject") or u4:IsA("UIStroke");
    assert(v13, "UIInstance is not a GuiObject");
    local v14 = typeof(p5) == "string";
    assert(v14, "effectType is not a string");
    local v15 = Presets:FindFirstChild(p5) ~= nil;
    assert(v15, "effectType is not a valid preset");

    if p6 then
        local v16 = typeof(p6) == "number";
        assert(v16, "speed is not a number");
    end;

    if p7 then
        local v17 = typeof(p7) == "number";
        assert(v17, "size is not a number");
    end;

    if p9 then
        local v18 = typeof(p9) == "ColorSequence" and true or typeof(p9) == "Color3";
        assert(v18, "customColor is not a ColorSequence or Color3");
    end;

    if p10 then
        local v19 = typeof(p10) == "NumberSequence" and true or typeof(p10) == "number";
        assert(v19, "customTransparency is not a NumberSequence or number");
    end;

    local u20 = setmetatable({}, u1);
    u20.IsPaused = false;
    u20.Diagnostic = "DIAGNOSTIC VALUE";
    u20.UIInstance = u4;
    u20.ResumesOnShown = p11 == nil and true or p11;
    u20.EffectObjects = {};
    u20.SavedObjects = {};
    u20.Connections = {};
    u20.Speed = p6 or 0.007;
    u20.Size = p7 or 1;
    local v21 = require(Presets:FindFirstChild(p5))(u4, u20.Speed, u20.Size, p9, p10, p12);
    local v22 = typeof(v21) == "table";
    assert(v22, "EffectType did not return a table");

    if p8 then
        for _, child in u4:GetChildren() do
            if child:IsA("UIStroke") or child:IsA("UIGradient") then
                table.insert(u20.SavedObjects, child);
                child.Parent = nil;
            end;
        end;
    end;

    if v21.Connections then
        for _, v in v21.Connections do
            table.insert(u20.Connections, v);
        end;
    end;

    if v21.Effects then
        for _, v in v21.Effects do
            table.insert(u20.EffectObjects, v);
        end;
    end;

    u20.Connection = u4.AncestryChanged:Connect(function() -- Line: 109
        -- upvalues: u4 (copy), u20 (copy)
        if not u4:IsDescendantOf(game) then
            u20:Destroy();
        end;
    end);
    (function(p23) -- Line: 115, Name: TrackVisibility
        -- upvalues: u2 (ref), u20 (copy)
        if typeof(p23) == "Instance" and p23:IsA("GuiBase") then
            local u24 = {
                hiddenCount = 0,
                isPaused = false,
                connections = {}
            };

            local function getVisibilityProperty(p25) -- Line: 128
                -- upvalues: u2 (ref)
                return u2[p25.ClassName] or p25:IsA("GuiObject") and "Visible";
            end;

            local function updateVisibility(p26) -- Line: 133
                -- upvalues: u24 (copy), u20 (ref)
                local v27 = u24;
                v27.hiddenCount = v27.hiddenCount + p26;

                if u24.hiddenCount <= 0 or u24.isPaused then
                    if u24.hiddenCount == 0 and u24.isPaused then
                        u24.isPaused = false;

                        if u20.ResumesOnShown then
                            u20:Resume();
                        end;
                    end;

                    return;
                end;

                u24.isPaused = true;
                u20:Pause();
            end;

            (function(u28) -- Line: 148, Name: initializeTracking
                -- upvalues: u2 (ref), u24 (copy), u20 (ref)
                while u28 and u28:IsA("GuiBase") do
                    local u29 = u2[u28.ClassName] or u28:IsA("GuiObject") and "Visible";

                    if u29 then
                        if not u28[u29] then
                            local v30 = u24;
                            v30.hiddenCount = v30.hiddenCount + 1;

                            if u24.hiddenCount > 0 and not u24.isPaused then
                                u24.isPaused = true;
                                u20:Pause();
                            elseif u24.hiddenCount == 0 and u24.isPaused then
                                u24.isPaused = false;

                                if u20.ResumesOnShown then
                                    u20:Resume();
                                end;
                            end;
                        end;

                        local connections = u24.connections;
                        local v31 = u28:GetPropertyChangedSignal(u29);
                        table.insert(connections, v31:Connect(function() -- Line: 162
                            -- upvalues: u28 (copy), u29 (copy), u24 (ref), u20 (ref)
                            local v32 = u24;
                            v32.hiddenCount = v32.hiddenCount + (u28[u29] and -1 or 1);

                            if u24.hiddenCount <= 0 or u24.isPaused then
                                if u24.hiddenCount == 0 and u24.isPaused then
                                    u24.isPaused = false;

                                    if u20.ResumesOnShown then
                                        u20:Resume();
                                    end;
                                end;

                                return;
                            end;

                            u24.isPaused = true;
                            u20:Pause();
                        end));
                    end;

                    u28 = u28.Parent;
                end;
            end)(p23);

            function u24.Cleanup(p33) -- Line: 177
                for _, v in ipairs(p33.connections) do
                    v:Disconnect();
                end;

                p33.connections = {};
            end;

            function u24.Destroy(p34) -- Line: 184
                p34:Cleanup();
                table.clear(p34);
            end;

            table.insert(u20.Connections, u24);

            return u24;
        end;
    end)(u4);

    return u20;
end;

function u1.Pause(p35) -- Line: 198
    for _, v in p35.EffectObjects do
        if v.Pause then
            v:Pause();
        end;
    end;
end;

function u1.Resume(p36) -- Line: 207
    for _, v in p36.EffectObjects do
        if v.Resume then
            v:Resume();
        end;
    end;
end;

function u1.Destroy(p37) -- Line: 216
    for _, v in p37.SavedObjects do
        v.Parent = p37.UIInstance;
    end;

    for _, v in p37.Connections do
        if typeof(v) == "table" and typeof(v.Destroy) == "function" then
            v:Destroy();
        else
            v:Disconnect();
        end;
    end;

    table.clear(p37.SavedObjects);
    table.clear(p37.Connections);

    for _, v in p37.EffectObjects do
        if v.Destroy then
            v:Destroy();
        end;
    end;

    p37.Connection:Disconnect();
end;

return table.freeze(u1);