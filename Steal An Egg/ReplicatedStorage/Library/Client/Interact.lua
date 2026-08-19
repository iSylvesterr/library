-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = ReplicatedStorage.Assets;
local Functions = require(ReplicatedStorage.Library.Functions);
local Event = require(ReplicatedStorage.Library.Modules.Event);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local Player = require(ReplicatedStorage.Library.Player);
local Variables = require(ReplicatedStorage.Library.Variables);
local Audio = require(ReplicatedStorage.Library.Audio);
local SpatialTable = require(ReplicatedStorage.Library.Modules.SpatialTable);
local ScaleUDim2 = require(ReplicatedStorage.Library.Functions.ScaleUDim2);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local InputIconsConfig = require(ReplicatedStorage.Library.InputIconsConfig);
local u1 = table.freeze({
    MobileButtonImage = "rbxassetid://5083554875",
    DesktopButtonImage = "rbxassetid://5083555193",
    PressDownSound = "rbxassetid://82144450256926",
    PressUpSound = "rbxassetid://99086493947576",
    StepTime = 0.15,
    InteractKeyCode = Enum.KeyCode.ButtonX
});
local u2 = SpatialTable.new(10);
local u3 = {};
local u4 = nil;
local u5 = 0;
local u7 = {
    GetInteractIcon = function() -- Line: 37, Name: GetInteractIcon
        -- upvalues: Variables (copy), Constants (copy), u1 (copy), InputIconsConfig (copy)
        if Variables.Console then
            return InputIconsConfig.Image(u1.InteractKeyCode) or u1.DesktopButtonImage;
        end;

        if Constants.IS_MOBILE then
            return u1.MobileButtonImage;
        end;

        return u1.DesktopButtonImage;
    end,

    Activate = function(p6) -- Line: 48, Name: Activate
        p6.event:FireAsync();
    end
};

function u7.Show(u8) -- Line: 52
    -- upvalues: Assets (copy), ScaleUDim2 (copy), u7 (copy), Functions (copy), Player (copy), Audio (copy), u1 (copy), UserInputService (copy), TabController (copy), Variables (copy), u3 (copy)
    if u8.billboard or u8.tweening then
        return;
    end;

    local u9 = Assets.Billboards.Interact:Clone();
    u9.Size = ScaleUDim2(u9.Size, u8.billboardScale);
    u9.Button.Back.Icon.Image = u7.GetInteractIcon();
    u9.Label.Text = u8.label;
    u9.Label.Visible = u8.label ~= "";
    u9.Button.Back.CustomIcon.Visible = u8.customIcon ~= "";
    u9.Button.Back.CustomIcon.Image = u8.customIcon;
    local Size = u9.Size;
    u9.Size = UDim2.new();
    Functions.Tween(u9, {
        Size = Size
    }, { 0.2, "Back", "Out" }).Completed:Connect(function() -- Line: 64
        -- upvalues: u8 (copy)
        u8.tweening = false;
    end);
    u8.tweening = true;
    u9.Adornee = u8.host;
    u9.Parent = Player.PlayerGui();
    u8.billboard = u9;
    local u10 = false;

    local function onButtonReleased() -- Line: 74
        -- upvalues: u10 (ref), Audio (ref), u1 (ref), u9 (copy), Functions (ref), u7 (ref), u8 (copy)
        if u10 then
            return;
        end;

        u10 = true;
        Audio.Play(u1.PressUpSound, script, 1.75, 1);

        if u9:FindFirstChild("Button") then
            u9.Button.Back.BackgroundColor3 = Color3.new(1, 1, 1);
            u9.Button.Back.Fill.Visible = false;
            Functions.Tween(u9.Button.Back, {
                Size = UDim2.new(1, 0, 1, 0)
            }, { 0.3, "Elastic", "Out" });
        end;

        u7.Activate(u8);
        u10 = false;
    end;

    local function onButtonPressed() -- Line: 90
        -- upvalues: u10 (ref), Audio (ref), u1 (ref), Functions (ref), u9 (copy)
        if u10 then
            return;
        end;

        u10 = true;
        Audio.Play(u1.PressDownSound, script, 1.75, 0.1);
        Functions.Tween(u9.Button.Back, {
            Size = UDim2.new(0.85, 0, 0.85, 0)
        }, { 0.3, "Elastic", "Out" });
        u9.Button.Back.Fill.Visible = false;
        u9.Button.Back.BackgroundColor3 = Color3.new(0.75, 0.75, 0.75);
        u10 = false;
    end;

    table.insert(u8.events, UserInputService.InputBegan:Connect(function(p11) -- Line: 109
        -- upvalues: TabController (ref), u8 (copy), Variables (ref), u3 (ref), onButtonPressed (copy)
        local v12;

        if TabController.Get() == nil then
            v12 = not u8.customEnableCheck and true or u8.customEnableCheck();
            local v13 = not (Variables.Typing or Variables.MessageOpen);

            if v13 then
                if u3[u8.uid] == nil then
                    v12 = false;
                end;
            else
                v12 = v13;
            end;
        else
            v12 = false;
        end;

        if not v12 then
            return;
        end;

        if p11.KeyCode == Enum.KeyCode.ButtonX or p11.KeyCode == Enum.KeyCode.E then
            onButtonPressed();
        end;
    end));
    table.insert(u8.events, UserInputService.InputEnded:Connect(function(p14) -- Line: 143
        -- upvalues: TabController (ref), u8 (copy), Variables (ref), u3 (ref), onButtonReleased (copy)
        local v15;

        if TabController.Get() == nil then
            v15 = not u8.customEnableCheck and true or u8.customEnableCheck();
            local v16 = not (Variables.Typing or Variables.MessageOpen);

            if v16 then
                if u3[u8.uid] == nil then
                    v15 = false;
                end;
            else
                v15 = v16;
            end;
        else
            v15 = false;
        end;

        if not v15 then
            return;
        end;

        if p14.KeyCode == Enum.KeyCode.ButtonX or p14.KeyCode == Enum.KeyCode.E then
            onButtonReleased();
        end;
    end));
    table.insert(u8.event, u9.Button.InputBegan:Connect(function(p17) -- Line: 177
        -- upvalues: TabController (ref), u8 (copy), Variables (ref), u3 (ref), onButtonPressed (copy)
        local v18;

        if TabController.Get() == nil then
            v18 = not u8.customEnableCheck and true or u8.customEnableCheck();
            local v19 = not (Variables.Typing or Variables.MessageOpen);

            if v19 then
                if u3[u8.uid] == nil then
                    v18 = false;
                end;
            else
                v18 = v19;
            end;
        else
            v18 = false;
        end;

        if not v18 then
            return;
        end;

        local UserInputType = p17.UserInputType;

        if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch and p17.UserInputState == Enum.UserInputState.Begin or p17.KeyCode == Enum.KeyCode.ButtonX then
            onButtonPressed();
        end;
    end));
    table.insert(u8.event, u9.Button.InputEnded:Connect(function(p20) -- Line: 219
        -- upvalues: TabController (ref), u8 (copy), Variables (ref), u3 (ref), onButtonReleased (copy)
        local v21;

        if TabController.Get() == nil then
            v21 = not u8.customEnableCheck and true or u8.customEnableCheck();
            local v22 = not (Variables.Typing or Variables.MessageOpen);

            if v22 then
                if u3[u8.uid] == nil then
                    v21 = false;
                end;
            else
                v21 = v22;
            end;
        else
            v21 = false;
        end;

        if not v21 then
            return;
        end;

        local UserInputType = p20.UserInputType;

        if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch and p20.UserInputState == Enum.UserInputState.End or p20.KeyCode == Enum.KeyCode.ButtonX then
            onButtonReleased();
        end;
    end));
    u9.Destroying:Connect(function() -- Line: 260
        -- upvalues: u8 (copy)
        for _, v in ipairs(u8.events) do
            v:Disconnect();
        end;

        u8.events = {};
    end);
end;

function u7.Hide(u23) -- Line: 272
    -- upvalues: Functions (copy)
    if not u23.billboard then
        return;
    end;

    Functions.Tween(u23.billboard, {
        Size = UDim2.new()
    }, { 0.15, "Back", "In" }).Completed:Connect(function() -- Line: 275
        -- upvalues: u23 (copy)
        u23.tweening = false;

        if u23.billboard then
            u23.billboard:Destroy();
            u23.billboard = nil;
        end;
    end);
    u23.tweening = true;
end;

function u7.Add(p24, p25) -- Line: 316
    -- upvalues: Functions (copy), Event (copy), u5 (ref), u3 (copy), u2 (copy), u4 (ref)
    local v26 = p25 or {};
    local v27 = v26.dist or 30;
    local u28 = false;
    local u29 = nil;

    if typeof(p24) == "Instance" then
        if p24:IsA("Model") then
            u29 = p24.PrimaryPart;
            assert(u29, "interact: model has no primary part");
        elseif p24:IsA("BasePart") then
            u29 = p24;
        else
            error("interact: unknown host type");
        end;
    else
        u29 = Functions.CreateParticleHost(p24);
        u28 = true;
    end;

    local v30 = Event.new();
    local u31 = u5;
    u5 = u5 + 1;
    local u32 = {
        tweening = false,
        deleted = false,
        resumeTimestamp = nil,
        billboard = nil,
        uid = u31,
        host = u29,
        position = u29.Position,
        dist = v27,
        event = v30,
        events = {},
        label = v26.label or "",
        customIcon = v26.icon or "",
        customEnableCheck = v26.customEnableCheck,
        customShowCheck = v26.customShowCheck,
        billboardScale = v26.billboardScale or 1
    };
    u3[u31] = u32;
    u2:Insert(u32.position, u32);

    local function onDestroy() -- Line: 364
        -- upvalues: u32 (copy), u28 (ref), u29 (ref), u3 (ref), u31 (copy), u2 (ref), u4 (ref)
        if u32.deleted then
            return;
        end;

        u32.deleted = true;

        if u28 then
            u29:Destroy();
        end;

        if u32.billboard then
            u32.billboard:Destroy();
        end;

        u3[u31] = nil;
        u2:Remove(u32.position, u32);

        if u4 == u32 then
            u4 = nil;
        end;
    end;

    u29.Destroying:Connect(onDestroy);

    return v30, onDestroy, function(p33) -- Line: 384, Name: setResumeTimestamp
        -- upvalues: u32 (copy)
        u32.resumeTimestamp = workspace:GetServerTimeNow() + p33;
    end;
end;

function u7.Step() -- Line: 392
    -- upvalues: Player (copy), u2 (copy), u4 (ref), u7 (copy)
    local v34 = Player.Optional.Position();

    if not v34 then
        return;
    end;

    local v35 = u2:Query(v34);
    local v36 = workspace:GetServerTimeNow();

    if u4 then
        local v37;

        if u4 == v35 and (u4.position - v34).Magnitude <= u4.dist then
            if u4.resumeTimestamp == nil then
                v37 = false;
            else
                v37 = v36 < u4.resumeTimestamp;
            end;
        else
            v37 = true;
        end;

        if not v37 and u4.customShowCheck then
            v37 = not u4.customShowCheck();
        end;

        if v37 then
            u7.Hide(u4);
            u4 = nil;
        end;
    end;

    if v35 and not v35.billboard then
        local v38;

        if (v35.position - v34).Magnitude < v35.dist then
            v38 = v35.resumeTimestamp == nil and true or v35.resumeTimestamp < v36;
        else
            v38 = false;
        end;

        if v38 and v35.customShowCheck then
            v38 = v35.customShowCheck();
        end;

        if v38 then
            u7.Show(v35);
        end;
    end;

    u4 = v35;
end;

task.spawn(function() -- Line: 444
    -- upvalues: u1 (copy), u7 (copy)
    while task.wait(u1.StepTime) do
        u7.Step();
    end;
end);

return u7;