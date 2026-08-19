-- Decompiled with Potassium's decompiler.

local BezierUtil = require(script.Parent.BezierUtil);
local BezierAnim = require(script.Parent.BezierAnim);
local v1 = {};

for i, v in BezierUtil do
    v1[i] = v;
end;

for i, v in BezierAnim do
    v1[i] = v;
end;

return v1;