-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local AssetItemSerialization = require(ReplicatedStorage.Library.Util.AssetItemSerialization);
require(ReplicatedStorage.Library.Types.AssetItem);
local Directory = require(ReplicatedStorage.Directory.Assets).Directory;
local Audio = require(ReplicatedStorage.Library.Audio);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local DictionaryLength = require(ReplicatedStorage.Library.Functions.DictionaryLength);
local Eggs = require(ReplicatedStorage.Library.Types.Eggs);
local FuseKernelUtil = require(ReplicatedStorage.Library.Util.FuseKernelUtil);
local FuseMachineBackpackSelection = require(script.FuseMachineBackpackSelection);
local FuseMachineProgressPresentation = require(script.FuseMachineProgressPresentation);
local FuseMachineSelectedSlot = require(script.FuseMachineSelectedSlot);
local FuseMachine = require(ReplicatedStorage.Library.Types.FuseMachine);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Lock = require(ReplicatedStorage.Library.Functions.Lock);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Signal = require(ReplicatedStorage.Library.Signal);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local u1 = Color3.fromRGB(255, 0, 0);
local u2 = Log.new();
local u3 = Lock();
local u4 = Lock();
local u5 = Lock();
local FuseMachine2 = GUI.FuseMachine().Main.FuseMachine;
local v6 = FuseMachine2:IsA("Frame");
assert(v6, "FuseMachine.FuseMachine must be a Frame");
local Content = FuseMachine2.Content;
local v7 = Content:IsA("Frame");
assert(v7, "FuseMachine.Content must be a Frame");
local Template = Content.Template;
local v8 = Template:IsA("Frame");
assert(v8, "FuseMachine.Content.Template must be a Frame");
local Buy = FuseMachine2.Buy;
local v9 = Buy:IsA("ImageButton");
assert(v9, "FuseMachine.Buy must be an ImageButton");
local Price = Buy.Price;
local v10 = Price:IsA("TextLabel");
assert(v10, "FuseMachine.Buy.Price must be a TextLabel");
local BackgroundColor3 = Buy.BackgroundColor3;
local u11 = BackgroundColor3:Lerp(Color3.new(0, 0, 0), 0.35);
local BackpackScrollingFrameContainer = FuseMachine2.BackpackScrollingFrameContainer;
local v12 = BackpackScrollingFrameContainer:IsA("GuiObject");
assert(v12, "FuseMachine BackpackScrollingFrameContainer must be a GuiObject");
local Container = BackpackScrollingFrameContainer.Container;
local v13 = Container:IsA("GuiObject");
assert(v13, "FuseMachine backpack Container must be a GuiObject");
local ScrollingFrame = Container.ScrollingFrame;
local v14 = ScrollingFrame:IsA("ScrollingFrame");
assert(v14, "FuseMachine Container.ScrollingFrame must be a ScrollingFrame");
local v15 = ScrollingFrame.UIGridLayout:IsA("UIGridLayout");
assert(v15, "FuseMachine Container.ScrollingFrame.UIGridLayout must be a UIGridLayout");
local Connectors = FuseMachine2.Connectors;
local v16 = Connectors:IsA("Folder");
assert(v16, "FuseMachine.Connectors must be a Folder");
local Output = FuseMachine2.Output;
local v17 = Output:IsA("Frame");
assert(v17, "FuseMachine.Output must be a Frame");
local Info = FuseMachine2.Info;
local v18 = Info:IsA("Frame");
assert(v18, "FuseMachine.Info must be a Frame");
local Ok = Info.Ok;
local v19 = Ok:IsA("GuiButton");
assert(v19, "FuseMachine.Info.Ok must be a GuiButton");
local Machines = Workspace:WaitForChild("__OBJECTS").Machines;
local v20 = Machines:IsA("Folder");
assert(v20, "Workspace.__OBJECTS.Machines must be a Folder");
local FuseMachine3 = Machines.FuseMachine;
local v21 = FuseMachine3:IsA("Model");
assert(v21, "Workspace FuseMachine must be a Model");
local Overhead = FuseMachine3.Overhead;
local v22 = Overhead:IsA("BasePart");
assert(v22, "FuseMachine.Overhead must be a BasePart");
local BillboardGui = Overhead.BillboardGui;
local v23 = BillboardGui:IsA("BillboardGui");
assert(v23, "FuseMachine.Overhead.BillboardGui must be a BillboardGui");
local Countdown = BillboardGui.Countdown;
local v24 = Countdown:IsA("TextLabel");
assert(v24, "FuseMachine overhead Countdown must be a TextLabel");
local u25 = FuseMachineBackpackSelection.new(ScrollingFrame);
local u26 = FuseMachineProgressPresentation.new(Connectors, Output);
local u27 = {};
local u28 = false;

local function notifyError(p29) -- Line: 99
    -- upvalues: Message (copy), u1 (copy)
    Message.Bottom({
        Time = 3,
        Message = p29,
        Color = u1
    });
end;

local function getSelectedCategory(p30) -- Line: 107
    local v31 = p30.FusionSlots[1];

    if v31 == nil then
        return nil;
    end;

    local v32 = p30.Inventory[v31];

    if v32 then
        return v32.Category;
    end;

    return nil;
end;

local function getNoMatchMessage(p33) -- Line: 116
    -- upvalues: Directory (copy)
    local v34 = Directory[p33];
    local v35 = `Missing asset config {p33}`;
    assert(v34 ~= nil, v35);

    return `You have no other <font color="#{v34.Rarity.Color:ToHex()}">{v34.DisplayName}</font> to add!`;
end;

local function updateOverheadInputCount(p36) -- Line: 122
    -- upvalues: Countdown (copy)
    local v37 = 0;

    if p36 ~= nil then
        local v38 = p36.FusionSlots[1];

        if v38 ~= nil and p36.Inventory[v38] ~= nil then
            v37 = v37 + 1;
        end;

        local v39 = p36.FusionSlots[2];

        if v39 ~= nil and p36.Inventory[v39] ~= nil then
            v37 = v37 + 1;
        end;

        local v40 = p36.FusionSlots[3];

        if v40 ~= nil and p36.Inventory[v40] ~= nil then
            v37 = v37 + 1;
        end;
    end;

    Countdown.Text = `{v37}/{3}`;
end;

local function destroySlot(p41) -- Line: 135
    -- upvalues: u27 (copy)
    local v42 = u27[p41];

    if v42 then
        v42:Destroy();
        u27[p41] = nil;
    end;
end;

local function requestReturn(u43) -- Line: 143
    -- upvalues: u4 (copy), Network (copy), Constants (copy), Message (copy), u1 (copy)
    u4(function() -- Line: 144
        -- upvalues: Network (ref), Constants (ref), u43 (copy), Message (ref), u1 (ref)
        local v44, v45 = Network.Invoke(Constants.NETWORK_MAP.FuseMachine.REMOVE_MOB, u43);

        if not v44 then
            local v46 = typeof(v45) ~= "string" and "Failed to return pet" or v45;
            Message.Bottom({
                Time = 3,
                Message = v46,
                Color = u1
            });
        end;
    end);
end;

local function render() -- Line: 152
    -- upvalues: Save (copy), Info (copy), updateOverheadInputCount (copy), Buy (copy), u11 (copy), Price (copy), u26 (copy), Content (copy), u27 (copy), FuseMachineSelectedSlot (copy), Template (copy), requestReturn (copy), AssetItemSerialization (copy), Directory (copy), BackgroundColor3 (copy), Simple (copy), FuseKernelUtil (copy)
    local v47 = Save.Get();
    local v48;

    if v47 == nil then
        v48 = false;
    else
        v48 = not v47.FusionInfoAcknowledged;
    end;

    Info.Visible = v48;
    updateOverheadInputCount(v47);

    if v47 == nil then
        Buy.Visible = true;
        Buy.Active = false;
        Buy.BackgroundColor3 = u11;
        Price.Text = `{3} Pet Left`;
        u26:Update(0, nil);

        return;
    end;

    local v49 = {};
    local v50 = nil;

    for i = 1, 3 do
        local v51 = v47.FusionSlots[i];
        local v52;

        if v51 then
            v52 = v47.Inventory[v51];
        else
            v52 = nil;
        end;

        local v53 = Content[`Empty.{i}`];
        local v54 = v53:IsA("Frame");
        local v55 = `FuseMachine.Content.Empty.{i} must be a Frame`;
        assert(v54, v55);

        if v51 == nil or v52 == nil then
            local v56 = u27[i];

            if v56 then
                v56:Destroy();
                u27[i] = nil;
            end;

            v53.Visible = true;
        else
            v50 = v50 or v52.Category;
            local v57 = u27[i];

            if v57 == nil or v57:GetUid() ~= v51 then
                local v58 = u27[i];

                if v58 then
                    v58:Destroy();
                    u27[i] = nil;
                end;

                u27[i] = FuseMachineSelectedSlot.new(Template, Content, i, v51, v52, requestReturn);
            end;

            v53.Visible = false;
            table.insert(v49, AssetItemSerialization.Deserialize(v52));
        end;
    end;

    local v59;

    if #v49 == 3 then
        v59 = not v47.FusionLocked and v47.FusionEggReward == false;
    else
        v59 = false;
    end;

    local v60;

    if v50 == nil then
        v60 = nil;
    else
        local v61 = Directory[v50];
        local v62 = `Missing asset config {v50}`;
        assert(v61 ~= nil, v62);
        v60 = v61.Egg.Icon;
    end;

    u26:Update(#v49, v60);

    if v59 then
        for _, v in ipairs(v49) do
            if v.Category ~= v50 then
                v59 = false;
                break;
            end;
        end;
    end;

    Buy.Visible = true;
    Buy.Active = v59;

    if v59 then
        Buy.BackgroundColor3 = BackgroundColor3;
        Price.Text = "$ " .. Simple.FormatCompact(FuseKernelUtil.CalculateFusePrice(v49));

        return;
    end;

    Buy.BackgroundColor3 = u11;
    Price.Text = `{3 - #v49} Pet Left`;
end;

local function scheduleRender() -- Line: 217
    -- upvalues: u28 (ref), render (copy)
    if u28 then
        return;
    end;

    u28 = true;
    task.defer(function() -- Line: 222
        -- upvalues: u28 (ref), render (ref)
        u28 = false;
        render();
    end);
end;

local function requestAcknowledgeInfo() -- Line: 228
    -- upvalues: u5 (copy), Info (copy), Network (copy), Constants (copy), Message (copy), u1 (copy), u28 (ref), render (copy)
    u5(function() -- Line: 229
        -- upvalues: Info (ref), Network (ref), Constants (ref), Message (ref), u1 (ref), u28 (ref), render (ref)
        if not Info.Visible then
            return;
        end;

        if Network.Invoke(Constants.NETWORK_MAP.FuseMachine.ACKNOWLEDGE_INFO) == true then
            Info.Visible = false;

            return;
        end;

        Message.Bottom({
            Message = "Failed to save Fuse Machine info acknowledgement",
            Time = 3,
            Color = u1
        });

        if u28 then
            return;
        end;

        u28 = true;
        task.defer(function() -- Line: 222
            -- upvalues: u28 (ref), render (ref)
            u28 = false;
            render();
        end);
    end);
end;

local function requestInsert(u63) -- Line: 245
    -- upvalues: u4 (copy), Network (copy), Constants (copy), Message (copy), u1 (copy), u25 (copy), BackpackScrollingFrameContainer (copy), u28 (ref), render (copy)
    u4(function() -- Line: 246
        -- upvalues: Network (ref), Constants (ref), u63 (copy), Message (ref), u1 (ref), u25 (ref), BackpackScrollingFrameContainer (ref), u28 (ref), render (ref)
        local v64, v65 = Network.Invoke(Constants.NETWORK_MAP.FuseMachine.INSERT_MOB, u63);

        if not v64 then
            local v66 = typeof(v65) ~= "string" and "Failed to insert pet" or v65;
            Message.Bottom({
                Time = 3,
                Message = v66,
                Color = u1
            });

            return;
        end;

        u25:Close();
        BackpackScrollingFrameContainer.Visible = false;

        if u28 then
            return;
        end;

        u28 = true;
        task.defer(function() -- Line: 222
            -- upvalues: u28 (ref), render (ref)
            u28 = false;
            render();
        end);
    end);
end;

local function requestFuse() -- Line: 282
    -- upvalues: u3 (copy), Save (copy), DictionaryLength (copy), Eggs (copy), Message (copy), u1 (copy), Network (copy), Constants (copy), FuseMachine (copy), u2 (copy), Audio (copy), Signal (copy), u28 (ref), render (copy)
    u3(function() -- Line: 283
        -- upvalues: Save (ref), DictionaryLength (ref), Eggs (ref), Message (ref), u1 (ref), Network (ref), Constants (ref), FuseMachine (ref), u2 (ref), Audio (ref), Signal (ref), u28 (ref), render (ref)
        local v67 = Save.Get();

        if v67 == nil then
            return;
        end;

        if DictionaryLength(v67.EggInventory) >= Eggs.MAX_INVENTORY then
            Message.Bottom({
                Message = "Your egg inventory is full!",
                Time = 3,
                Color = u1
            });

            return;
        end;

        local v68, v69, v70 = Network.Invoke(Constants.NETWORK_MAP.FuseMachine.START_FUSE);

        if not v68 then
            local v71 = typeof(v69) ~= "string" and "Failed to start fuse" or v69;
            Message.Bottom({
                Time = 3,
                Message = v71,
                Color = u1
            });

            return;
        end;

        if not FuseMachine.FuseResult(v70) then
            u2:AtError():Log("Fuse server returned an invalid reward");

            return;
        end;

        Audio.Play(83520877125467, script, 1, 1.5);
        Signal.FireAsync(Constants.SIGNALS_MAP.Client.FuseMachine.FUSE_STARTED, v70);

        if u28 then
            return;
        end;

        u28 = true;
        task.defer(function() -- Line: 222
            -- upvalues: u28 (ref), render (ref)
            u28 = false;
            render();
        end);
    end);
end;

(function() -- Line: 309, Name: hideObsoletePresentation
    -- upvalues: FuseMachine2 (copy), Output (copy)
    local Time = FuseMachine2.Time;
    local LuckyIcon = FuseMachine2.LuckyIcon;
    local LuckBlur = FuseMachine2.LuckBlur;
    local Arrow = FuseMachine2.Arrow;
    local v72 = Time:IsA("GuiObject");
    assert(v72, "FuseMachine.Time must be a GuiObject");
    local v73 = LuckyIcon:IsA("GuiObject");
    assert(v73, "FuseMachine.LuckyIcon must be a GuiObject");
    local v74 = LuckBlur:IsA("GuiObject");
    assert(v74, "FuseMachine.LuckBlur must be a GuiObject");
    local v75 = Arrow:IsA("GuiObject");
    assert(v75, "FuseMachine.Arrow must be a GuiObject");
    Output.Visible = true;
    Time.Visible = false;
    LuckyIcon.Visible = false;
    LuckBlur.Visible = false;
    Arrow.Visible = false;
end)();
BackpackScrollingFrameContainer.Visible = false;
Info.Visible = false;
Template.Visible = false;

local function startSelection() -- Line: 258
    -- upvalues: u25 (copy), Save (copy), requestInsert (copy), BackpackScrollingFrameContainer (copy), Directory (copy), Message (copy), u1 (copy)
    if u25:IsOpen() then
        return;
    end;

    local v76 = Save.Get();

    if v76 == nil then
        return;
    end;

    local v77 = v76.FusionSlots[1];
    local v78;

    if v77 == nil then
        v78 = nil;
    else
        local v79 = v76.Inventory[v77];

        if v79 then
            v78 = v79.Category;
        else
            v78 = nil;
        end;
    end;

    if u25:Open(v76, v78, requestInsert) > 0 then
        BackpackScrollingFrameContainer.Visible = true;
        u25:RefreshGridLayout();

        return;
    end;

    if not v78 then
        Message.Bottom({
            Message = "You do not have any pets to add!",
            Time = 3,
            Color = u1
        });

        return;
    end;

    local v80 = Directory[v78];
    local v81 = `Missing asset config {v78}`;
    assert(v80 ~= nil, v81);
    local v82 = `You have no other <font color="#{v80.Rarity.Color:ToHex()}">{v80.DisplayName}</font> to add!`;
    Message.Bottom({
        Time = 3,
        Message = v82,
        Color = u1
    });
end;

for i = 1, 3 do
    local v83 = Content[`Empty.{i}`];
    local v84 = v83:IsA("Frame");
    local v85 = `FuseMachine.Content.Empty.{i} must be a Frame`;
    assert(v84, v85);
    local Insert = v83.Insert;
    local v86 = Insert:IsA("ImageButton");
    local v87 = `FuseMachine.Content.Empty.{i}.Insert must be an ImageButton`;
    assert(v86, v87);
    Insert.Activated:Connect(startSelection);
    ButtonFX(Insert);
end;

Buy.Activated:Connect(requestFuse);
ButtonFX(Buy);
Ok.Activated:Connect(requestAcknowledgeInfo);
ButtonFX(Ok);
Save.ConnectForDataChanged({ "FusionSlots", "FusionLocked", "FusionEggReward", "FusionInfoAcknowledged", "Inventory", "EggInventory" }, function() -- Line: 348
    -- upvalues: TabController (copy), u28 (ref), render (copy)
    if TabController.IsOpen("FuseMachine") then
        if u28 then
            return;
        end;

        u28 = true;
        task.defer(function() -- Line: 222
            -- upvalues: u28 (ref), render (ref)
            u28 = false;
            render();
        end);
    end;
end);
TabController.Opened:Connect(function(p88) -- Line: 354
    -- upvalues: u28 (ref), render (copy)
    if p88 == "FuseMachine" then
        if u28 then
            return;
        end;

        u28 = true;
        task.defer(function() -- Line: 222
            -- upvalues: u28 (ref), render (ref)
            u28 = false;
            render();
        end);
    end;
end);
TabController.Closed:Connect(function(p89) -- Line: 359
    -- upvalues: u25 (copy), BackpackScrollingFrameContainer (copy)
    if p89 == "FuseMachine" then
        u25:Close();
        BackpackScrollingFrameContainer.Visible = false;
    end;
end);
render();