-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = 0;
local u3 = 0;
local u4 = 0;
local u5 = 0;
local u6 = 0;
local u7 = 0;
local identity = CFrame.identity;
local u8 = false;
local u9 = nil;

function v1.accumulate(p10, p11, p12, p13, p14, p15) -- Line: 27
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref)
    u2 = u2 + p10;
    u3 = u3 + p11;
    u4 = u4 + p12;
    u5 = u5 + p13;
    u6 = u6 + p14;
    u7 = u7 + p15;
end;

local function clearState() -- Line: 32
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), identity (ref), u8 (ref), u9 (ref)
    u2 = 0;
    u3 = 0;
    u4 = 0;
    u5 = 0;
    u6 = 0;
    u7 = 0;
    identity = CFrame.identity;
    u8 = false;
    u9 = nil;
end;

function v1.applyFrame() -- Line: 39
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), identity (ref), u9 (ref)
    local v16 = (u2 ~= 0 or (u3 ~= 0 or (u4 ~= 0 or (u5 ~= 0 or u6 ~= 0)))) and true or u7 ~= 0;

    if not (u8 or v16) then
        return;
    end;

    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        u2 = 0;
        u3 = 0;
        u4 = 0;
        u5 = 0;
        u6 = 0;
        u7 = 0;
        identity = CFrame.identity;
        u8 = false;
        u9 = nil;

        return;
    end;

    if u9 and u9 ~= CurrentCamera then
        if u8 and u9.Parent then
            pcall(function() -- Line: 51
                -- upvalues: u9 (ref), identity (ref)
                u9.CFrame = u9.CFrame * identity:Inverse();
            end);
        end;

        identity = CFrame.identity;
        u8 = false;
    end;

    local v17 = CFrame.new(u2, u3, u4) * CFrame.fromOrientation(u5, u6, u7);
    CurrentCamera.CFrame = CurrentCamera.CFrame * identity:Inverse() * v17;
    identity = v17;
    u8 = v16;
    u9 = CurrentCamera;
    u2 = 0;
    u3 = 0;
    u4 = 0;
    u5 = 0;
    u6 = 0;
    u7 = 0;
end;

function v1.reset() -- Line: 66
    -- upvalues: u8 (ref), u9 (ref), identity (ref), u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref)
    if u8 and (u9 and u9.Parent) then
        pcall(function() -- Line: 68
            -- upvalues: u9 (ref), identity (ref)
            u9.CFrame = u9.CFrame * identity:Inverse();
        end);
    end;

    u2 = 0;
    u3 = 0;
    u4 = 0;
    u5 = 0;
    u6 = 0;
    u7 = 0;
    identity = CFrame.identity;
    u8 = false;
    u9 = nil;
end;

return v1;