-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Network = require(ReplicatedStorage.Library.Client.Network);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local CmdrClient = require(ReplicatedStorage:WaitForChild("CmdrClient"));
local TopBarPlus = require(ReplicatedStorage.Library.Modules.Packages.TopBarPlus);
local u1 = false;

local function Initialize() -- Line: 23
    -- upvalues: u1 (ref), CmdrClient (copy), TopBarPlus (copy)
    u1 = true;
    CmdrClient:SetActivationKeys({ Enum.KeyCode.F2 });
    local v2 = TopBarPlus.new();
    v2:setName("Cmdr");
    v2:setImage(102459578526748);
    v2:setRight();
    v2.toggled:Connect(function() -- Line: 32
        -- upvalues: CmdrClient (ref)
        CmdrClient:Show();
    end);
end;

Network.Fired(Constants.NETWORK_MAP.AdminPanel.ADMIN_STATUS_RESPONSE):Connect(function(p3) -- Line: 39
    -- upvalues: u1 (ref), Initialize (copy)
    if p3 and not u1 then
        Initialize();
    end;
end);