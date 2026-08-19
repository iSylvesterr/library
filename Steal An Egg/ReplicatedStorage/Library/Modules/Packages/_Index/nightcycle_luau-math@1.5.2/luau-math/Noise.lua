-- Decompiled with Potassium's decompiler.

require(script.Parent.Algebra.Vector);
require(script.Parent.Algebra.Matrix);
require(script.Solver);
local v1 = {};
v1.__index = v1;
v1.Random = require(script:WaitForChild("Solver"));
v1.Simplex = require(script:WaitForChild("Simplex"));
v1.Cellular = require(script:WaitForChild("Cellular"));
v1.Voronoi = require(script:WaitForChild("Voronoi"));

return v1;