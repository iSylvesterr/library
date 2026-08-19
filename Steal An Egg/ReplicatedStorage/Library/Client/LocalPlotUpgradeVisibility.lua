-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);

return {
    Refresh = function(p1, p2) -- Line: 17, Name: Refresh
        -- upvalues: Asserts (copy), PlotCmds (copy)
        Asserts.string(p1);
        Asserts.optional.boolean(p2);
        local v3 = PlotCmds.GetPlotsFolder();
        local v4 = PlotCmds.GetMySlot();

        if v3 == nil then
            return;
        end;

        for _, descendant in ipairs(v3:GetDescendants()) do
            if descendant.Name == p1 and descendant.Parent ~= nil then
                local v5;

                if v4 == nil or descendant.Parent.Name ~= tostring(v4) then
                    v5 = false;
                else
                    v5 = p2 ~= false;
                end;

                for _, descendant2 in ipairs(descendant:GetDescendants()) do
                    if descendant2:IsA("BasePart") then
                        descendant2.LocalTransparencyModifier = v5 and 0 or 1;
                    elseif descendant2:IsA("SurfaceGui") then
                        descendant2.Enabled = v5;
                    elseif descendant2:IsA("BillboardGui") then
                        if v5 then
                            if descendant2.Name ~= "CanUpgrade" then
                                descendant2.Enabled = true;
                            end;
                        else
                            descendant2.Enabled = false;
                        end;
                    end;
                end;
            end;
        end;
    end
};