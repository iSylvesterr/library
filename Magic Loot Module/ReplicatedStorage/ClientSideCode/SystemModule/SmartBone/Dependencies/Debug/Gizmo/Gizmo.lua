-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Terrain = workspace:WaitForChild("Terrain");
local Terrain2 = workspace:WaitForChild("Terrain");
assert(Terrain, "No terrain object found under workspace");
assert(Terrain2, "No target parent found.");
local AOTGizmoAdornment = Terrain2:FindFirstChild("AOTGizmoAdornment");
local GizmoAdornment = Terrain2:FindFirstChild("GizmoAdornment");

if not AOTGizmoAdornment then
    AOTGizmoAdornment = Instance.new("WireframeHandleAdornment");
    AOTGizmoAdornment.Adornee = Terrain;
    AOTGizmoAdornment.ZIndex = 1;
    AOTGizmoAdornment.AlwaysOnTop = true;
    AOTGizmoAdornment.Name = "AOTGizmoAdornment";
    AOTGizmoAdornment.Parent = Terrain2;
end;

if not GizmoAdornment then
    GizmoAdornment = Instance.new("WireframeHandleAdornment");
    GizmoAdornment.Adornee = Terrain;
    GizmoAdornment.ZIndex = 1;
    GizmoAdornment.AlwaysOnTop = false;
    GizmoAdornment.Name = "GizmoAdornment";
    GizmoAdornment.Parent = Terrain2;
end;

local Gizmos = script.Parent:WaitForChild("Gizmos");
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {
    AlwaysOnTop = true,
    Transparency = 0,
    Color3 = Color3.fromRGB(13, 105, 172)
};
local u6 = {};
local u7 = false;

local function Register(p8) -- Line: 50
    -- upvalues: Terrain2 (copy), u1 (ref)
    p8.Parent = Terrain2;
    table.insert(u1, p8);
end;

local function Lerp(p9, p10, p11) -- Line: 80
    return p9 + (p10 - p9) * p11;
end;

local function deepCopy(p12) -- Line: 84
    -- upvalues: deepCopy (copy)
    local v13 = {};

    for i, v in pairs(p12) do
        if type(v) == "table" then
            local v = deepCopy(v);
        end;

        v13[i] = v;
    end;

    return v13;
end;

local u18 = {
    Enabled = true,
    ActiveRays = 0,
    ActiveInstances = 0,
    Styles = {
        Color = "Color3",
        Transparency = "Transparency",
        AlwaysOnTop = "AlwaysOnTop"
    },
    AOTWireframeHandle = AOTGizmoAdornment,
    WireframeHandle = GizmoAdornment,

    GetPoolSize = function() -- Line: 506, Name: GetPoolSize
        -- upvalues: u6 (copy)
        local v14 = 0;

        for _, v in u6 do
            v14 = v14 + #v;
        end;

        return v14;
    end,

    PushProperty = function(u15, u16) -- Line: 521, Name: PushProperty
        -- upvalues: u5 (copy), AOTGizmoAdornment (ref), GizmoAdornment (ref)
        u5[u15] = u16;

        if u15 == "AlwaysOnTop" then
            return;
        end;

        pcall(function() -- Line: 528
            -- upvalues: AOTGizmoAdornment (ref), u15 (copy), u16 (copy), GizmoAdornment (ref)
            AOTGizmoAdornment[u15] = u16;
            GizmoAdornment[u15] = u16;
        end);
    end,

    PopProperty = function(p17) -- Line: 539, Name: PopProperty
        -- upvalues: u5 (copy), AOTGizmoAdornment (ref)
        if u5[p17] then
            return u5[p17];
        end;

        return AOTGizmoAdornment[p17];
    end
};

function u18.SetStyle(p19, p20, p21) -- Line: 553
    -- upvalues: u18 (copy)
    if p19 ~= nil and typeof(p19) == "Color3" then
        u18.PushProperty("Color3", p19);
    end;

    if p20 ~= nil and typeof(p20) == "number" then
        u18.PushProperty("Transparency", p20);
    end;

    if p21 ~= nil and typeof(p21) == "boolean" then
        u18.PushProperty("AlwaysOnTop", p21);
    end;
end;

function u18.DoCleaning() -- Line: 569
    -- upvalues: AOTGizmoAdornment (ref), GizmoAdornment (ref), u1 (ref), u6 (copy), u18 (copy)
    AOTGizmoAdornment:Clear();
    GizmoAdornment:Clear();

    for _, v in u1 do
        local ClassName = v.ClassName;

        if not u6[ClassName] then
            u6[ClassName] = {};
        end;

        v:Remove();
        table.insert(u6[ClassName], v);
    end;

    u1 = {};
    u18.ActiveRays = 0;
    u18.ActiveInstances = 0;
end;

function u18.ScheduleCleaning() -- Line: 585
    -- upvalues: u7 (ref), u18 (copy)
    if u7 then
        return;
    end;

    u7 = true;
    task.delay(0, function() -- Line: 592
        -- upvalues: u18 (ref), u7 (ref)
        u18.DoCleaning();
        u7 = false;
    end);
end;

function u18.AddDebrisInSeconds(p22, p23) -- Line: 604
    -- upvalues: u3 (copy)
    local v24 = {
        "Seconds",
        p22,
        os.clock(),
        p23
    };
    table.insert(u3, v24);
end;

function u18.AddDebrisInFrames(p25, p26) -- Line: 613
    -- upvalues: u3 (copy)
    table.insert(u3, {
        "Frames",
        p25,
        0,
        p26
    });
end;

function u18.TweenProperties(p27, p28, p29) -- Line: 624
    -- upvalues: deepCopy (copy), u4 (copy)
    local u30 = {
        Time = 0,
        p_Properties = p27,
        Properties = deepCopy(p27),
        Goal = p28,
        TweenInfo = p29
    };
    u4[u30] = true;

    return function() -- Line: 638
        -- upvalues: u4 (ref), u30 (copy)
        u4[u30] = nil;
    end;
end;

function u18.Init() -- Line: 645
    -- upvalues: RunService (copy), u18 (copy), Terrain2 (copy), AOTGizmoAdornment (ref), Terrain (copy), GizmoAdornment (ref), u4 (copy), TweenService (copy), u3 (copy), u2 (copy)
    RunService.RenderStepped:Connect(function(p31) -- Line: 646
        -- upvalues: u18 (ref), Terrain2 (ref), AOTGizmoAdornment (ref), Terrain (ref), GizmoAdornment (ref), u4 (ref), TweenService (ref), u3 (ref), u2 (ref)
        if u18.Enabled then
            if not Terrain2:FindFirstChild("AOTGizmoAdornment") then
                AOTGizmoAdornment = Instance.new("WireframeHandleAdornment");
                AOTGizmoAdornment.Adornee = Terrain;
                AOTGizmoAdornment.ZIndex = 1;
                AOTGizmoAdornment.AlwaysOnTop = true;
                AOTGizmoAdornment.Name = "AOTGizmoAdornment";
                AOTGizmoAdornment.Parent = Terrain2;
                u18.AOTWireframeHandle = AOTGizmoAdornment;
            end;

            if not Terrain2:FindFirstChild("GizmoAdornment") then
                GizmoAdornment = Instance.new("WireframeHandleAdornment");
                GizmoAdornment.Adornee = Terrain;
                GizmoAdornment.ZIndex = 1;
                GizmoAdornment.AlwaysOnTop = false;
                GizmoAdornment.Name = "GizmoAdornment";
                GizmoAdornment.Parent = Terrain2;
                u18.WireframeHandle = GizmoAdornment;
            end;
        end;

        for i in u4 do
            i.Time = i.Time + p31;
            local v32 = i.Time / i.TweenInfo.Time;
            local v33 = v32 > 1 and 1 or v32;

            local function LerpProperty(p34, p35, p36) -- Line: 680
                if type(p34) == "number" then
                    return p34 + (p35 - p34) * p36;
                end;

                return p34:Lerp(p35, p36);
            end;

            for i2, v in i.Properties do
                if i.Goal[i2] then
                    local v37 = TweenService:GetValue(v33, i.TweenInfo.EasingStyle, i.TweenInfo.EasingDirection);
                    local v38 = i.Goal[i2];
                    local v39;

                    if type(v) == "number" then
                        v39 = v + (v38 - v) * v37;
                    else
                        v39 = v:Lerp(v38, v37);
                    end;

                    i.p_Properties[i2] = v39;
                end;
            end;

            if v33 == 1 then
                u4[i] = nil;
            end;
        end;

        for i = #u3, 1, -1 do
            local v40 = u3[i];
            local v41 = v40[2];
            local v42 = v40[3];
            local v43 = v40[4];

            if v40[1] == "Seconds" then
                if v41 < os.clock() - v42 then
                    table.remove(u3, i);
                else
                    v43();
                end;
            elseif v41 < v42 then
                table.remove(u3, i);
            else
                v40[2] = v40[2] + 1;
                v43();
            end;
        end;

        for i = #u2, 1, -1 do
            local v44 = u2[i];
            local v45 = v44[2];

            if v45.Enabled then
                if v45.Destroy then
                    table.remove(u2, i);
                end;

                v44[1]:Update(v45);
            end;
        end;
    end);
end;

function u18.SetEnabled(p46) -- Line: 752
    -- upvalues: u18 (copy)
    u18.Enabled = p46;

    if p46 == false then
        u18.DoCleaning();
    end;
end;

function u18.RemoveAdornments() -- Line: 763
    -- upvalues: Terrain2 (copy)
    if Terrain2:FindFirstChild("AOTGizmoAdornment") then
        Terrain2:FindFirstChild("AOTGizmoAdornment"):Destroy();
    end;

    if Terrain2:FindFirstChild("GizmoAdornment") then
        Terrain2:FindFirstChild("GizmoAdornment"):Destroy();
    end;
end;

local function Request(p47) -- Line: 66
    -- upvalues: u6 (copy)
    if u6[p47] then
        return table.remove(u6[p47]) or Instance.new(p47);
    end;

    return Instance.new(p47);
end;

local function Release(p48) -- Line: 55
    -- upvalues: u6 (copy)
    local ClassName = p48.ClassName;

    if not u6[ClassName] then
        u6[ClassName] = {};
    end;

    p48:Remove();
    table.insert(u6[ClassName], p48);
end;

local function Retain(p49, p50) -- Line: 46
    -- upvalues: u2 (copy)
    table.insert(u2, { p49, p50 });
end;

for _, child in Gizmos:GetChildren() do
    u18[child.Name] = require(child).Init(u18, u5, Request, Release, Retain, Register);
end;

return u18;