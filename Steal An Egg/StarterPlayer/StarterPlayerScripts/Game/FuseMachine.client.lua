-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Directory = require(ReplicatedStorage.Directory.Assets).Directory;
local Audio = require(ReplicatedStorage.Library.Audio);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local FuseMachineAnimation = require(ReplicatedStorage.Library.Client.FuseMachineAnimation);
local FuseMachine = require(ReplicatedStorage.Library.Types.FuseMachine);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Message = require(ReplicatedStorage.Library.Client.Message);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Message2 = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local Signal = require(ReplicatedStorage.Library.Signal);
local AssetSizeClassification = require(ReplicatedStorage.Library.Util.AssetSizeClassification);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local u1 = Log.new();
local Machines = Workspace:WaitForChild("__OBJECTS").Machines;
local v2 = Machines:IsA("Folder");
assert(v2, "Workspace.__OBJECTS.Machines must be a Folder");
local FuseMachine2 = Machines.FuseMachine;
local v3 = FuseMachine2:IsA("Model");
assert(v3, "Workspace FuseMachine must be a Model");
local Machine = FuseMachine2.Machine;
local v4 = Machine:IsA("BasePart");
assert(v4, "FuseMachine.Machine must be a BasePart");
local Attachment = Machine.Attachment;
local v5 = Attachment:IsA("Attachment");
assert(v5, "FuseMachine.Machine.Attachment must be an Attachment");
local ProximityPrompt = Attachment.ProximityPrompt;
local v6 = ProximityPrompt:IsA("ProximityPrompt");
assert(v6, "FuseMachine proximity prompt must be a ProximityPrompt");
local u7 = 0;

local function notifyError(p8) -- Line: 46
    -- upvalues: Message2 (copy)
    Message2.Bottom({
        Time = 3,
        Message = p8,
        Color = Color3.fromRGB(255, 0, 0)
    });
end;

local function playFuseAndGrant(p9) -- Line: 54
    -- upvalues: Directory (copy), u1 (copy), u7 (ref), ProximityPrompt (copy), FuseMachineAnimation (copy), FuseMachine2 (copy), Machine (copy), Audio (copy), AssetSizeClassification (copy), Message (copy), Network (copy), Constants (copy), Message2 (copy), TabController (copy)
    local AssetCategory = p9.AssetCategory;
    local v10 = Directory[AssetCategory];

    if v10 == nil then
        u1:AtError():Log("Fuse result category has no asset config", {
            Category = AssetCategory
        });

        return;
    end;

    local Egg = v10.Egg;
    u7 = u7 + 1;
    local u11 = u7;
    ProximityPrompt.Enabled = false;

    if not FuseMachineAnimation.Play(FuseMachine2, Machine, function() -- Line: 66
        -- upvalues: u7 (ref), u11 (copy)
        return u7 == u11;
    end) then
        ProximityPrompt.Enabled = true;

        return;
    end;

    Audio.Play(103131639134026, script, 1, 1);
    local v12 = AssetSizeClassification.Resolve(p9.AssetScale);
    local v13 = not v12 and "" or `{v12.RichText} `;
    Message.New(`You fused {v13}<font color="#{v10.Rarity.Color:ToHex()}">{Egg.DisplayName}</font>`, {
        dontRestore = true,
        icon = Egg.Icon
    });
    local v14, v15 = Network.Invoke(Constants.NETWORK_MAP.FuseMachine.COMPLETE_REVEAL);

    if not v14 then
        local v16 = typeof(v15) ~= "string" and "Failed to grant fused egg" or v15;
        Message2.Bottom({
            Time = 3,
            Message = v16,
            Color = Color3.fromRGB(255, 0, 0)
        });
    end;

    ProximityPrompt.Enabled = true;
    TabController.CloseTab(true);
end;

ProximityPrompt.ActionText = "Fuse Pets";
ProximityPrompt.Triggered:Connect(function() -- Line: 95
    -- upvalues: TabController (copy)
    TabController.OpenTab("FuseMachine");
end);
Signal.Fired(Constants.SIGNALS_MAP.Client.FuseMachine.FUSE_STARTED):Connect(function(p17) -- Line: 99
    -- upvalues: FuseMachine (copy), playFuseAndGrant (copy)
    local v18 = FuseMachine.FuseResult(p17);
    assert(v18, "Fuse started signal requires a valid serialized reward egg");
    task.spawn(playFuseAndGrant, p17);
end);