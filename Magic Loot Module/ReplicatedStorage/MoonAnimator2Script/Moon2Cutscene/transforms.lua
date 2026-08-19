-- Decompiled with Potassium's decompiler.

local function _(p1, p2, p3) -- Line: 7
    return p1 + p3 * (p2 - p1);
end;

require(game.ReplicatedFirst.AllSideCode.ToolBasic.VisibleMgr);
local v27 = {
    C1 = function(p4, p5, p6, p7) -- Line: 112
        local v8 = p4.Part0.CFrame * p4.C0;
        p4.C1 = (v8 * p6:Inverse()):Lerp(v8 * p5:Inverse(), p7):Inverse() * v8;
    end,

    CFrame = function(p9, p10, p11, p12) -- Line: 121
        if p11 then
            p10 = p11:Lerp(p10, p12) or p10;
        end;

        if not p9:IsA("Camera") then
            if p9:IsA("Model") then
                p9 = p9.PrimaryPart or p9;
            end;

            p9.CFrame = p10;

            return;
        end;

        p9.CameraType = Enum.CameraType.Scriptable;
        p9.CFrame = p10;
        p9.Focus = p10;
    end,

    Size = function(p13, p14, p15, p16) -- Line: 134
        if p15 then
            p14 = p15:Lerp(p14, p16) or p14;
        end;

        p13.Size = p14;
    end,

    Emit = function(p17, p18, p19, p20) -- Line: 139
        if p20 == 1 then
            p17:Emit(p18);
        end;
    end,

    Wrappers = {
        NumberSequence = function(p21, p22, p23) -- Line: 149
            return NumberSequence.new(p22 + p23 * (p21 - p22));
        end,

        ColorSequence = function(p24, p25, p26) -- Line: 154
            return ColorSequence.new(p25:Lerp(p24, p26));
        end
    }
};

for i, v in {
    [{ "Transparency", "Reflectance", "FieldOfView", "BackgroundTransparency", "ImageTransparency", "Brightness", "Contrast", "Saturation", "TextSize", "TextTransparency", "Volume", "PlaybackSpeed", "RollOffMaxDistance", "RollOffMinDistance" }] = function(u28, u29, p30, p31, p32) -- Line: 16
        if not pcall(function() -- Line: 20
            -- upvalues: u29 (copy), u28 (copy)
            return u29[u28];
        end) then
            return;
        end;

        if p31 then
            p30 = p31 + p32 * (p30 - p31) or p30;
        end;

        u29[u28] = p30;
    end,

    [{ "SetTime" }] = function(p33, p34, p35, p36, p37) -- Line: 33
        if p37 == 1 then
            p34[p33] = p35;
        end;
    end,

    [{ "AttachToPart" }] = function(p38, u39, u40, p41, p42, u43) -- Line: 41
        if p42 == 1 then
            if u43 and (u43.attachConnections and u43.attachConnections[u39]) then
                local v44 = u43.attachConnections[u39];

                if v44 and v44.Connected then
                    v44:Disconnect();
                end;
            end;

            local u45 = nil;
            u45 = game:GetService("RunService").Heartbeat:Connect(function() -- Line: 53
                -- upvalues: u40 (copy), u39 (copy), u45 (ref), u43 (copy)
                if u40 and u40.Parent then
                    u39.CFrame = u40.CFrame;

                    return;
                end;

                if u45 then
                    u45:Disconnect();

                    if u43 and u43.attachConnections then
                        u43.attachConnections[u39] = nil;
                    end;
                end;
            end);

            if u43 and u43.attachConnections then
                u43.attachConnections[u39] = u45;
            end;
        end;
    end,

    [{ "Material", "RollOffMode" }] = function(p46, p47, p48) -- Line: 75
        p47[p46] = Enum[p46][p48];
    end,

    [{ "Anchored", "CastShadow", "Enabled", "Text", "Looped", "Playing", "SoundId", "Font" }] = function(p49, p50, p51, p52, p53) -- Line: 80
        if p53 == 1 then
            p50[p49] = p51;

            return;
        end;

        p50[p49] = p52;
    end,

    [{ "Color", "BackgroundColor3", "TextColor3", "TintColor" }] = function(p54, p55, p56, p57, p58) -- Line: 90
        if p57 then
            p56 = p57:Lerp(p56, p58) or p56;
        end;

        p55[p54] = p56;
    end,

    [{ "PlayOnce", "Play" }] = function(p59, p60, p61, p62, p63) -- Line: 95
        if p63 == 1 then
            p60:Play();
        end;
    end,

    [{ "Stop", "Pause", "Resume" }] = function(p64, p65, p66, p67, p68) -- Line: 102
        if p68 == 1 then
            p65[p64](p65);
        end;
    end
} do
    for _, v2 in i do
        v27[v2] = function(...) -- Line: 162
            -- upvalues: v (copy), v2 (copy)
            v(v2, ...);
        end;
    end;
end;

return v27;