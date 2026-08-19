-- Decompiled with Potassium's decompiler.

local GroupService = game:GetService("GroupService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local Confetti = require(ReplicatedStorage.Library.Client.GUIFX.Confetti);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local GroupReward = require(ReplicatedStorage.Library.Types.GroupReward);
local Lock = require(ReplicatedStorage.Library.Functions.Lock);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Message = require(ReplicatedStorage.Library.Client.Message);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Save = require(ReplicatedStorage.Library.Client.Save);
local SpeedPower = require(ReplicatedStorage.Library.Client.RewardFeedback.SpeedPower);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local u1 = Color3.fromRGB(25, 151, 0);
local CLAIM_REWARD = Network.NET_MAP.GroupReward.CLAIM_REWARD;
local v2 = Log.new();
local LocalPlayer = Players.LocalPlayer;
local v3 = GUI.GroupReward();
local ClaimReward = v3.FrameReward.Main.ClaimReward;
local Title = ClaimReward.Title;
local MPS = v3.FrameReward.Main.ImageLabel.MPS;
local ProximityPrompt = Workspace.__OBJECTS.GroupReward.ProximityPrompt;
local BackgroundColor3 = ClaimReward.BackgroundColor3;
local Text = Title.Text;
local u4 = Lock();
local v5 = ProximityPrompt:IsA("ProximityPrompt");
assert(v5, "Expected GroupReward.ProximityPrompt to be a ProximityPrompt");

local function renderClaimState(p6) -- Line: 47
    -- upvalues: Asserts (copy), ClaimReward (copy), u1 (copy), BackgroundColor3 (copy), Title (copy), Text (copy)
    Asserts.boolean(p6);
    local v7;

    if p6 then
        v7 = u1;
    else
        v7 = BackgroundColor3;
    end;

    ClaimReward.BackgroundColor3 = v7;
    Title.Text = p6 and "CLAIMED" or Text;
end;

local function updateView() -- Line: 53
    -- upvalues: Save (copy), Asserts (copy), ClaimReward (copy), u1 (copy), BackgroundColor3 (copy), Title (copy), Text (copy)
    local v8 = Save.Get();

    if v8 == nil then
        return;
    end;

    local v9 = v8.ClaimedGroupReward == true;
    Asserts.boolean(v9);
    local v10;

    if v9 then
        v10 = u1;
    else
        v10 = BackgroundColor3;
    end;

    ClaimReward.BackgroundColor3 = v10;
    Title.Text = v9 and "CLAIMED" or Text;
end;

local function invokeClaim(p11) -- Line: 62
    -- upvalues: Asserts (copy), Network (copy), CLAIM_REWARD (copy), Message (copy), TabController (copy), ClaimReward (copy), u1 (copy), Title (copy), Confetti (copy), SpeedPower (copy)
    Asserts.boolean(p11);
    local v12, v13, v14 = Network.Invoke(CLAIM_REWARD, p11);

    if not v12 then
        Message.New(v13 or "Failed to claim reward!");

        return false;
    end;

    Asserts.number(v14);

    if TabController.IsOpen("GroupReward") then
        TabController.CloseTab();
    end;

    Asserts.boolean(true);
    ClaimReward.BackgroundColor3 = u1;
    Title.Text = "CLAIMED";
    Message.New("REWARD CLAIMED!");
    Confetti.Play();
    SpeedPower.Show(v14);

    return true;
end;

local function resolveClientMembership() -- Line: 83
    -- upvalues: LocalPlayer (copy), Constants (copy), Message (copy), GroupService (copy)
    local success, result = pcall(function() -- Line: 84
        -- upvalues: LocalPlayer (ref), Constants (ref)
        return LocalPlayer:IsInGroupAsync(Constants.GROUP_ID);
    end);

    if not success then
        Message.New("Failed to verify your group membership!");

        return false, false;
    end;

    if result then
        return true, true;
    end;

    local success2, result2 = pcall(function() -- Line: 96
        -- upvalues: GroupService (ref), Constants (ref)
        return GroupService:PromptJoinAsync(Constants.GROUP_ID);
    end);

    if not success2 then
        Message.New("Failed to open the group join prompt!");

        return false, false;
    end;

    if result2 == Enum.GroupMembershipStatus.Joined or result2 == Enum.GroupMembershipStatus.AlreadyMember then
        return true, true;
    end;

    if result2 == Enum.GroupMembershipStatus.JoinRequestPending then
        Message.New("Your request to join the group is pending approval.");
    else
        Message.New("You must join the group to claim this reward!");
    end;

    return false, false;
end;

local function onClaimActivated() -- Line: 120
    -- upvalues: Save (copy), Message (copy), resolveClientMembership (copy), invokeClaim (copy)
    local v15 = Save.Get();

    if v15 == nil then
        Message.StandardError();

        return;
    end;

    if v15.ClaimedGroupReward == true then
        Message.New("You already claimed this reward!");

        return;
    end;

    local v16, v17 = resolveClientMembership();

    if not v16 then
        return;
    end;

    invokeClaim(v17);
end;

MPS.Text = GroupReward.GetDisplayName();
ButtonFX(ClaimReward, nil, function() -- Line: 146
    -- upvalues: u4 (copy), onClaimActivated (copy)
    u4(onClaimActivated);
end);
ProximityPrompt.Triggered:Connect(function() -- Line: 150
    -- upvalues: TabController (copy)
    TabController.ToggleTab("GroupReward");
end);

if Save.IsLocalDataLoaded() then
    local v18 = Save.Get();

    if v18 ~= nil then
        local v19 = v18.ClaimedGroupReward == true;
        Asserts.boolean(v19);

        if not v19 then
            u1 = BackgroundColor3;
        end;

        ClaimReward.BackgroundColor3 = u1;
        Title.Text = v19 and "CLAIMED" or Text;
    end;
else
    Save.LoadedStats:Connect(updateView);
end;

Save.ConnectForDataChanged({ "ClaimedGroupReward" }, updateView);
v2:AtInfo():Log("Group rewards client initialized");