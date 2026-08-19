-- Decompiled with Potassium's decompiler.

local BezierAnimBasic = require(script.Parent.BezierAnimBasic);
local BezierAnimLookAt = require(script.Parent.BezierAnimLookAt);
local BezierAnimMulti = require(script.Parent.BezierAnimMulti);
local v1 = {};

for i, v in BezierAnimBasic do
    v1[i] = v;
end;

for i, v in BezierAnimLookAt do
    v1[i] = v;
end;

for i, v in BezierAnimMulti do
    v1[i] = v;
end;

return v1;