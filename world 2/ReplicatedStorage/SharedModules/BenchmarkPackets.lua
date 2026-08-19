-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Packet = require(ReplicatedStorage.SharedModules.Packet);

return {
    Start = Packet("BenchmarkStart", Packet.String, Packet.NumberF64, Packet.NumberF64),
    Result = Packet("BenchmarkResult", Packet.String, Packet.Any)
};