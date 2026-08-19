-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BBFromArrayVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromArrayVisibleOnly);
local FastTween = require(ReplicatedStorage.Library.Functions.FastTween);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local Cash = ReplicatedStorage.Assets.Extra.Cash;
local v1 = Cash:IsA("BillboardGui");
assert(v1, "Assets.Extra.Cash must be a BillboardGui");
local v2 = {};

local function scaleBillboardSize(p3, p4) -- Line: 37
    return UDim2.new(p3.X.Scale * p4, p3.X.Offset * p4, p3.Y.Scale * p4, p3.Y.Offset * p4);
end;

local function getBillboardScale(p5) -- Line: 41
    local v6 = math.min(p5.X / 2, p5.Y / 5.72646427154541, p5.Z / 5.299603462219238);

    return v6 <= 0 and 0.9 or math.clamp(v6, 0.9, 5);
end;

local function fadeTextLabel(u7, p8, p9, u10) -- Line: 54
    -- upvalues: FastTween (copy)
    u7.Text = p8;
    u7.TextTransparency = 1;
    FastTween(u7, p9, {
        TextTransparency = 0
    });
    task.delay(0.8499999999999999, function() -- Line: 60
        -- upvalues: u7 (copy), FastTween (ref), u10 (copy)
        if u7.Parent then
            FastTween(u7, u10, {
                TextTransparency = 1
            });
        end;
    end);
end;

local function fadeTextButton(u11, p12, p13, u14) -- Line: 69
    -- upvalues: FastTween (copy)
    u11.Text = p12;
    u11.TextTransparency = 1;
    FastTween(u11, p13, {
        TextTransparency = 0
    });
    task.delay(0.8499999999999999, function() -- Line: 75
        -- upvalues: u11 (copy), FastTween (ref), u14 (copy)
        if u11.Parent then
            FastTween(u11, u14, {
                TextTransparency = 1
            });
        end;
    end);
end;

local function fadeTextBox(u15, p16, p17, u18) -- Line: 84
    -- upvalues: FastTween (copy)
    u15.Text = p16;
    u15.TextTransparency = 1;
    FastTween(u15, p17, {
        TextTransparency = 0
    });
    task.delay(0.8499999999999999, function() -- Line: 90
        -- upvalues: u15 (copy), FastTween (ref), u18 (copy)
        if u15.Parent then
            FastTween(u15, u18, {
                TextTransparency = 1
            });
        end;
    end);
end;

local function fadeImageObject(u19, p20, u21) -- Line: 99
    -- upvalues: FastTween (copy)
    u19.ImageTransparency = 1;
    FastTween(u19, p20, {
        ImageTransparency = 0
    });
    task.delay(0.8499999999999999, function() -- Line: 105
        -- upvalues: u19 (copy), FastTween (ref), u21 (copy)
        if u19.Parent then
            FastTween(u19, u21, {
                ImageTransparency = 1
            });
        end;
    end);
end;

local function fadePopupDescendants(p22, p23, p24, u25) -- Line: 114
    -- upvalues: fadeTextLabel (copy), fadeTextButton (copy), fadeTextBox (copy), FastTween (copy), fadeImageObject (copy)
    for _, descendant in ipairs(p22:GetDescendants()) do
        if descendant:IsA("TextLabel") then
            fadeTextLabel(descendant, p23, p24, u25);
        elseif descendant:IsA("TextButton") then
            fadeTextButton(descendant, p23, p24, u25);
        elseif descendant:IsA("TextBox") then
            fadeTextBox(descendant, p23, p24, u25);
        elseif descendant:IsA("UIStroke") then
            descendant.Transparency = 1;
            FastTween(descendant, p24, {
                Transparency = 0
            });
            task.delay(0.8499999999999999, function() -- Line: 132
                -- upvalues: descendant (copy), FastTween (ref), u25 (copy)
                if descendant.Parent then
                    FastTween(descendant, u25, {
                        Transparency = 1
                    });
                end;
            end);
        elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            fadeImageObject(descendant, p24, u25);
        end;
    end;
end;

local function showAtCFrame(p26, p27, p28, p29, p30) -- Line: 145
    -- upvalues: Cash (copy), fadePopupDescendants (copy), Simple (copy), FastTween (copy), Debris (copy)
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "SyncedIncomeCashAttachment";
    Attachment.WorldCFrame = p26;
    Attachment.Parent = workspace.Terrain;
    local v31 = Cash:Clone();
    v31.Name = "SyncedIncomeCash";
    v31.Adornee = Attachment;
    v31.Parent = Attachment;
    v31.AlwaysOnTop = (not p28 or p28.alwaysOnTop == nil) and true or p28.alwaysOnTop;
    local Size = v31.Size;
    v31.Size = UDim2.new(Size.X.Scale * p30, Size.X.Offset * p30, Size.Y.Scale * p30, Size.Y.Offset * p30);
    fadePopupDescendants(v31, `+${Simple.FormatCompact((math.round(p27)))}`, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out));
    FastTween(Attachment, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        WorldPosition = p26.Position + Vector3.new(0, p29, 0)
    });
    Debris:AddItem(v31, 1.4);
    Debris:AddItem(Attachment, 1.4);
end;

function v2.Show(p32, p33, p34) -- Line: 183
    -- upvalues: BBFromArrayVisibleOnly (copy), Cash (copy), showAtCFrame (copy)
    local v35, v36 = BBFromArrayVisibleOnly(p32);
    local v37 = v35 - Vector3.new(0, v36.Y / 1.5, 0);
    local v38 = assert(workspace.CurrentCamera, "Active asset income popup requires Workspace.CurrentCamera");
    local MaxDistance = Cash.MaxDistance;

    if MaxDistance > 0 and MaxDistance < (v38.CFrame.Position - v37.Position).Magnitude then
        return;
    end;

    local v39 = v36.Y - v36.Y * 0.25;
    local v40 = math.min(v36.X / 2, v36.Y / 5.72646427154541, v36.Z / 5.299603462219238);
    showAtCFrame(v37, p33, p34, v39, v40 <= 0 and 0.9 or math.clamp(v40, 0.9, 5));
end;

return v2;