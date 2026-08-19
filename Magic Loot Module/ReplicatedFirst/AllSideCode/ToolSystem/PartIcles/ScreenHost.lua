-- Decompiled with Potassium's decompiler.

local GuiHost = require(script.Parent.GuiHost);
local v1 = {};
local u2 = nil;

function v1.get() -- Line: 8
    -- upvalues: u2 (ref), GuiHost (copy)
    if u2 and u2.Parent then
        return u2;
    end;

    local v3 = GuiHost.resolveContainer();

    if not v3 then
        return nil;
    end;

    u2 = Instance.new("ScreenGui");
    u2.Name = "PartIclesScreenHost";
    u2.Archivable = false;
    u2.DisplayOrder = -10;
    u2.ResetOnSpawn = false;
    u2.IgnoreGuiInset = true;
    u2.Parent = v3;

    return u2;
end;

function v1.destroy() -- Line: 22
    -- upvalues: u2 (ref)
    if u2 then
        pcall(u2.Destroy, u2);
        u2 = nil;
    end;
end;

function v1.exists() -- Line: 26
    -- upvalues: u2 (ref)
    return u2 and u2.Parent ~= nil;
end;

return v1;