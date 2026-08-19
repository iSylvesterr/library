-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);
local EggRenderer = require(script.Parent.EggRenderer);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
require(script.Parent.Types);
local Weld = require(ReplicatedStorage.Library.Functions.Weld);
local u1 = Log.new();
local u2 = {};
u2.__index = u2;
u2.__class = "EggToolDisplay";

function u2.new(p3, p4) -- Line: 40
    -- upvalues: Asserts (copy), u2 (copy), Trove (copy), EggRenderer (copy), u1 (copy)
    Asserts.Tool(p3);
    local v5 = setmetatable({}, u2);
    v5._trove = Trove.new();
    v5._tool = p3;
    v5._renderResult = EggRenderer.RenderVisual(p4, p3);
    v5:_init();
    u1:AtDebug():Log((`Attached egg tool display for {p4.UID}`));

    return v5;
end;

local function getStringAttribute(p6, p7) -- Line: 57
    local v8 = p6:GetAttribute(p7);

    if typeof(v8) == "string" and v8 ~= "" then
        return v8;
    end;

    return nil;
end;

local function positionModel(p9, p10) -- Line: 62
    -- upvalues: BBFromModelVisibleOnly (copy)
    local Handle = p9:WaitForChild("Handle");
    local v11 = Handle:IsA("BasePart");
    local v12 = `Missing egg tool handle for {p9:GetFullName()}`;
    assert(v11, v12);
    local Model = p10.Model;
    local v13 = Model:GetPivot();
    local v14, v15 = BBFromModelVisibleOnly(Model);
    local v16 = (v14 * CFrame.new(0, v15.Y * -0.5, v15.Z * 0.1)):ToObjectSpace(v13);
    Model:PivotTo(Handle.CFrame * v16);

    return Handle;
end;

function u2.IsEggTool(p17) -- Line: 81
    -- upvalues: Asserts (copy)
    Asserts.Tool(p17);

    return p17:GetAttribute("ItemType") == "AssetEgg";
end;

function u2.GetToolUid(p18) -- Line: 86
    -- upvalues: Asserts (copy)
    Asserts.Tool(p18);
    local v19 = p18:GetAttribute("UID");

    if typeof(v19) == "string" and v19 ~= "" then
        return v19;
    end;

    return nil;
end;

function u2.Destroy(p20) -- Line: 91
    p20._trove:Destroy();
end;

function u2._init(p21) -- Line: 99
    -- upvalues: positionModel (copy), Weld (copy)
    p21._trove:Add(p21._renderResult.Model);
    local v22 = positionModel(p21._tool, p21._renderResult);
    p21._trove:Add(Weld(p21._renderResult.VisibleParts[1], v22));
end;

return u2;