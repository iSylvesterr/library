-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Packages = ReplicatedStorage.Packages;
local Knit = require(Packages.Knit);
local Signal = require(Packages.Signal);
require(ReplicatedStorage.Shared.Info.CustomEnum);
local u1 = Knit.CreateController({
    Name = "DataClient"
});
u1.currentData = nil;
u1.EV_FIRST_UPDATE = Signal.new();
u1.EV_UPDATE = Signal.new();

local function recursiveDataUpdate(p2, p3, p4) -- Line: 22
    for i, v in p3 do
        local v5 = p2[v];

        if v5 == nil then
            v5 = p2[tostring(v)];
        end;

        if i < #p3 then
            if not p4[v] then
                p4[v] = {};
            end;

            p2 = p2[v];
            p4 = p4[v];
        else
            p4[v] = v5;
        end;
    end;
end;

function u1.KnitStart(u6) -- Line: 41
    -- upvalues: recursiveDataUpdate (copy), RunService (copy)
    local u7 = true;
    u6.DataService.DataUpdate:Connect(function(p8, p9) -- Line: 44
        -- upvalues: u6 (copy), recursiveDataUpdate (ref), u7 (ref)
        if p9 == nil then
            u6.currentData = p8;
        else
            recursiveDataUpdate(p8, p9, u6.currentData);
        end;

        if u7 then
            print("FIRST DATA UPDATE!!");
            u6.EV_FIRST_UPDATE:Fire();
            u7 = false;
        end;

        u6.EV_UPDATE:Fire();
    end);

    if not RunService:IsStudio() then
        u6.AdminHandler.errorLog:Connect(function(p10, p11, p12) -- Line: 66
            warn("{SERVER ERROR}: ", p10);
            warn("stack trace ", p11);
        end);
    end;
end;

function u1.KnitInit(p13) -- Line: 73
    -- upvalues: Knit (copy)
    p13.DataService = Knit.GetService("DataService");
    p13.AdminHandler = Knit.GetService("AdminHandler");
end;

function u1.GetLoaded(p14) -- Line: 78
    -- upvalues: u1 (copy)
    return u1.currentData ~= nil;
end;

return u1;