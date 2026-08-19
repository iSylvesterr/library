-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local BaseComponent = v1.BaseComponent;
local Component = v1.Component;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local Player = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").Player;
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "PlotSectionNetwork");
local PlotSectionEvents = v2.PlotSectionEvents;
local PlotSectionFunctions = v2.PlotSectionFunctions;
local PolisherFunctions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network", "PolisherNetwork").PolisherFunctions;
local Notification = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "Notification").Notification;
local tweenAndDestroy = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "tween", "playAndDestroy").tweenAndDestroy;
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "plot", "PlotSections");
local isPlotSectionId = v3.isPlotSectionId;
local PlotSections = v3.PlotSections;
local SECTION_UNLOCKED_ATTRIBUTE = v3.SECTION_UNLOCKED_ATTRIBUTE;
local v4 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "plot", "Polishing");
local POLISHER_SLOT_COUNT = v4.POLISHER_SLOT_COUNT;
local POLISHER_UNLOCKED_ATTRIBUTE = v4.POLISHER_UNLOCKED_ATTRIBUTE;
local polisherModelName = v4.polisherModelName;
local polisherSignName = v4.polisherSignName;
local polisherUnlockCostFor = v4.polisherUnlockCostFor;
local formatAbbrevMoney = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatAbbrevMoney").formatAbbrevMoney;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local playWorldSound = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "sound", "SoundUtil").playWorldSound;
local u5 = {
    kind = "section"
};
local u6 = TweenInfo.new(0.36, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local u7 = setmetatable({}, {
    __tostring = function() -- Line: 51, Name: __tostring
        return "PlotSectionComponent";
    end,

    __index = BaseComponent
});
u7.__index = u7;

function u7.new(...) -- Line: 57
    -- upvalues: u7 (ref)
    local v8 = setmetatable({}, u7);

    return v8:constructor(...) or v8;
end;

function u7.constructor(p9, p10) -- Line: 61
    -- upvalues: BaseComponent (copy), Janitor (copy)
    BaseComponent.constructor(p9);
    p9.surfaceButtons = p10;
    p9.janitor = Janitor.new();
    p9.partStates = {};
    p9.surfaceStates = {};
    p9.partSurfaces = {};
    p9.guiStates = {};
    p9.gateRoots = {};
    p9.extraPolishers = {};
    p9.polisherSigns = {};
    p9.buildToken = 0;
    p9.building = false;
    p9.animatePendingUnlock = false;
end;

function u7.onStart(u11) -- Line: 76
    -- upvalues: isPlotSectionId (copy), SECTION_UNLOCKED_ATTRIBUTE (copy), PlotSectionEvents (copy), POLISHER_UNLOCKED_ATTRIBUTE (copy)
    local SectionId = u11.attributes.SectionId;

    if not isPlotSectionId(SectionId) then
        return nil;
    end;

    u11.sectionId = SectionId;
    u11.plot = u11:findPlot();
    u11:resolveGateRoots();
    u11:snapshot();
    u11.janitor:Add(u11.instance:GetAttributeChangedSignal(SECTION_UNLOCKED_ATTRIBUTE):Connect(function() -- Line: 85
        -- upvalues: u11 (copy)
        return u11:applyState();
    end), "Disconnect");

    if u11.plot then
        u11.janitor:Add(u11.plot:GetAttributeChangedSignal("OwnerUserId"):Connect(function() -- Line: 89
            -- upvalues: u11 (copy)
            return u11:applyState();
        end), "Disconnect");
    end;

    u11.janitor:Add(PlotSectionEvents.sectionUnlocked:connect(function(p12) -- Line: 93
        -- upvalues: u11 (copy)
        if p12 ~= u11.sectionId or not u11:isOwner() then
            return nil;
        end;

        u11.animatePendingUnlock = true;

        if u11:isUnlocked() then
            u11:consumePendingUnlock();
        end;
    end), "Disconnect");

    for _, v in u11.extraPolishers do
        u11.janitor:Add(v:GetAttributeChangedSignal(POLISHER_UNLOCKED_ATTRIBUTE):Connect(function() -- Line: 103
            -- upvalues: u11 (copy)
            return u11:applyState();
        end), "Disconnect");
    end;

    u11:applyState();
    u11:bindPurchaseButtons();
end;

function u7.destroy(p13) -- Line: 110
    -- upvalues: BaseComponent (copy)
    p13.buildToken = p13.buildToken + 1;
    p13.janitor:Destroy();
    BaseComponent.destroy(p13);
end;

function u7.snapshot(p14) -- Line: 115
    for _, descendant in p14.instance:GetDescendants() do
        local v15 = p14:gateFor(descendant);
        local v16 = v15.kind == "polisher";

        if descendant:IsA("BasePart") then
            p14.partStates[descendant] = {
                cframe = descendant.CFrame,
                transparency = v16 and 0 or descendant.Transparency,
                canCollide = v16 or descendant.CanCollide,
                canQuery = v16 or descendant.CanQuery,
                canTouch = v16 or descendant.CanTouch,
                gate = v15
            };
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            p14.surfaceStates[descendant] = {
                transparency = v16 and 0 or descendant.Transparency,
                gate = v15
            };
            local Parent = descendant.Parent;
            local v17;

            if Parent == nil then
                v17 = Parent;
            else
                v17 = Parent:IsA("BasePart");
            end;

            if v17 then
                local v18 = p14.partSurfaces[Parent];

                if v18 then
                    table.insert(v18, descendant);
                else
                    p14.partSurfaces[Parent] = { descendant };
                end;
            end;
        elseif descendant:IsA("SurfaceGui") or descendant:IsA("BillboardGui") then
            p14.guiStates[descendant] = v15;
        end;
    end;
end;

function u7.resolveGateRoots(p19) -- Line: 157
    -- upvalues: POLISHER_SLOT_COUNT (copy), polisherModelName (copy), polisherSignName (copy)
    p19.expandModel = p19.instance:FindFirstChild("ExpandPlot", true);
    local v20, v21;

    if p19.expandModel then
        p19.gateRoots[p19.expandModel] = {
            kind = "expand"
        };
        v20 = false;
        v21 = 2;
    else
        v20 = false;
        v21 = 2;
    end;

    while true do
        if v20 then
            v21 = v21 + 1;
        else
            v20 = true;
        end;

        if v21 > POLISHER_SLOT_COUNT then
            return;
        end;

        local v22 = p19.instance:FindFirstChild(polisherModelName(v21), true);
        local v23 = p19.instance:FindFirstChild(polisherSignName(v21), true);
        local v24;

        if v22 == nil then
            v24 = v22;
        else
            v24 = v22:IsA("Model");
        end;

        if v24 and v23 then
            p19.gateRoots[v22] = {
                kind = "polisher",
                slot = v21
            };
            p19.gateRoots[v23] = {
                kind = "sign",
                slot = v21
            };
            p19.extraPolishers[v21] = v22;
            p19.polisherSigns[v21] = v23;
        end;
    end;
end;

function u7.findPlot(p25) -- Line: 212
    local Parent = p25.instance.Parent;

    while Parent do
        local v26 = Parent:IsA("Model") and string.match(Parent.Name, "^Plot_%d+$");

        if v26 ~= 0 and (v26 == v26 and (v26 ~= "" and v26)) then
            return Parent;
        end;

        Parent = Parent.Parent;
    end;

    return nil;
end;

function u7.isOwner(p27) -- Line: 223
    -- upvalues: Player (copy)
    local plot = p27.plot;

    if plot ~= nil then
        plot = plot:GetAttribute("OwnerUserId");
    end;

    return plot == Player.UserId;
end;

function u7.isUnlocked(p28) -- Line: 230
    -- upvalues: SECTION_UNLOCKED_ATTRIBUTE (copy)
    return p28.instance:GetAttribute(SECTION_UNLOCKED_ATTRIBUTE) == true;
end;

function u7.isPolisherUnlocked(p29, p30) -- Line: 233
    -- upvalues: POLISHER_UNLOCKED_ATTRIBUTE (copy)
    local v31 = p29.extraPolishers[p30];

    if v31 ~= nil then
        v31 = v31:GetAttribute(POLISHER_UNLOCKED_ATTRIBUTE);
    end;

    return v31 == true;
end;

function u7.gateFor(p32, p33) -- Line: 242
    -- upvalues: u5 (copy)
    while p33 ~= nil and p33 ~= p32.instance do
        local v34 = p32.gateRoots[p33];

        if v34 then
            return v34;
        end;

        p33 = p33.Parent;
    end;

    return u5;
end;

function u7.isGateVisible(p35, p36, p37, p38) -- Line: 255
    if p36.kind == "expand" then
        return not p37 and p38;
    end;

    if p36.kind == "sign" then
        if p37 then
            if p38 then
                p38 = not p35:isPolisherUnlocked(p36.slot);
            end;
        else
            p38 = p37;
        end;

        return p38;
    end;

    if p36.kind ~= "polisher" then
        return p37;
    end;

    if p37 then
        p37 = p35:isPolisherUnlocked(p36.slot);
    end;

    return p37;
end;

function u7.bindPurchaseButtons(u39) -- Line: 267
    -- upvalues: PlotSections (copy), polisherUnlockCostFor (copy)
    local sectionId = u39.sectionId;

    if sectionId ~= nil and u39.expandModel then
        u39:bindPurchaseButton(u39.expandModel, PlotSections[sectionId].unlockCost, function() -- Line: 270
            -- upvalues: u39 (copy)
            return u39:requestUnlock();
        end);
    end;

    for i, v in u39.polisherSigns do
        local v40 = polisherUnlockCostFor(i);

        if v40 ~= nil then
            u39:bindPurchaseButton(v, v40, function() -- Line: 279
                -- upvalues: u39 (copy), i (copy)
                return u39:requestPolisher(i);
            end);
        end;
    end;
end;

function u7.bindPurchaseButton(p41, p42, p43, p44) -- Line: 284
    -- upvalues: WFChain (copy), formatAbbrevMoney (copy)
    local v45 = WFChain(p42, "Info", "SurfaceGui", "Frame", "Unlock");

    local function _(p46) -- Line: 288
        return p46:IsA("TextLabel");
    end;

    local v47 = nil;

    for i, child in v45:GetChildren() do
        local _ = i - 1;

        if child:IsA("TextLabel") == true then
            v47 = child;
            break;
        end;
    end;

    if v47 then
        v47.Text = formatAbbrevMoney(p43);
    end;

    p41.janitor:Add(p41.surfaceButtons:connect(v45, p44));
end;

function u7.requestUnlock(p48) -- Line: 305
    -- upvalues: RuntimeLib (copy), PlotSectionFunctions (copy), Notification (copy)
    local sectionId = p48.sectionId;

    if sectionId == nil or (not p48:isOwner() or p48:isUnlocked()) then
        return nil;
    end;

    task.spawn(RuntimeLib.async(function() -- Line: 310
        -- upvalues: RuntimeLib (ref), PlotSectionFunctions (ref), sectionId (copy), Notification (ref)
        local v49 = RuntimeLib.await(PlotSectionFunctions.unlockSection:invoke(sectionId):catch(function() -- Line: 311
            return nil;
        end));

        if v49 == "ok" then
            Notification.new("Plot expanded!", 3, "Notification", "Light Green");

            return;
        end;

        if v49 == "poor" then
            Notification.new("You can\'t afford this yet!", 3, "Error", "Light Red");
        end;
    end));
end;

function u7.requestPolisher(u50, u51) -- Line: 321
    -- upvalues: RuntimeLib (copy), PolisherFunctions (copy), Notification (copy)
    if not u50:isOwner() or (not u50:isUnlocked() or u50:isPolisherUnlocked(u51)) then
        return nil;
    end;

    task.spawn(RuntimeLib.async(function() -- Line: 325
        -- upvalues: RuntimeLib (ref), PolisherFunctions (ref), u51 (copy), Notification (ref), u50 (copy)
        local v52 = RuntimeLib.await(PolisherFunctions.unlockPolisher:invoke(u51):catch(function() -- Line: 326
            return nil;
        end));

        if v52 ~= "ok" then
            if v52 == "poor" then
                Notification.new("You can\'t afford this yet!", 3, "Error", "Light Red");
            end;

            return nil;
        end;

        Notification.new("Polisher unlocked!", 3, "Notification", "Light Green");
        u50.pendingPolisherBuild = u51;
        u50:consumePendingPolisher();
    end));
end;

function u7.applyState(p53) -- Line: 340
    p53.buildToken = p53.buildToken + 1;
    local building = p53.building;
    p53.building = false;
    local v54 = p53:isUnlocked();
    local v55 = p53:isOwner();

    for i, v in p53.partStates do
        local v56 = p53:isGateVisible(v.gate, v54, v55);

        if building then
            i.CFrame = v.cframe;
        end;

        i.Transparency = not v56 and 1 or v.transparency;
        local v57;

        if v56 then
            v57 = v.canQuery;
        else
            v57 = v56;
        end;

        i.CanQuery = v57;
        local v58;

        if v56 then
            v58 = v.canTouch;
        else
            v58 = v56;
        end;

        i.CanTouch = v58;

        if v56 then
            v56 = v.canCollide;
        end;

        i.CanCollide = v56;
    end;

    for i, v in p53.surfaceStates do
        i.Transparency = not p53:isGateVisible(v.gate, v54, v55) and 1 or v.transparency;
    end;

    for i, v in p53.guiStates do
        i.Enabled = p53:isGateVisible(v, v54, v55);
    end;

    if not v54 then
        p53.animatePendingUnlock = false;
        p53.pendingPolisherBuild = nil;

        return nil;
    end;

    p53:consumePendingUnlock();
    p53:consumePendingPolisher();
end;

function u7.consumePendingUnlock(u59) -- Line: 370
    if not u59.animatePendingUnlock then
        return nil;
    end;

    u59.animatePendingUnlock = false;
    local u60 = u59:isOwner();
    u59:playBuild(function(p61) -- Line: 376
        -- upvalues: u59 (copy), u60 (copy)
        local v62;

        if p61.kind == "expand" then
            v62 = false;
        else
            v62 = u59:isGateVisible(p61, true, u60);
        end;

        return v62;
    end);
end;

function u7.consumePendingPolisher(p63) -- Line: 380
    local pendingPolisherBuild = p63.pendingPolisherBuild;

    if pendingPolisherBuild == nil or not p63:isPolisherUnlocked(pendingPolisherBuild) then
        return nil;
    end;

    p63.pendingPolisherBuild = nil;
    p63:playBuild(function(p64) -- Line: 386
        -- upvalues: pendingPolisherBuild (copy)
        local v65;

        if p64.kind == "polisher" then
            v65 = p64.slot == pendingPolisherBuild;
        else
            v65 = false;
        end;

        return v65;
    end);
end;

function u7.playBuild(p66, p67) -- Line: 390
    local v68 = {};

    for i, v in p66.partStates do
        if p67(v.gate) then
            table.insert(v68, i);
        end;
    end;

    local v69 = {};

    for i, v in p66.guiStates do
        if p67(v) then
            table.insert(v69, i);
        end;
    end;

    if #v68 > 0 then
        p66:playBuildAnimation(v68, v69);
    end;
end;

function u7.setPieceVisible(p70, p71, p72) -- Line: 407
    local v73 = p70.partStates[p71];

    if not v73 then
        return nil;
    end;

    p71.Transparency = not p72 and 1 or v73.transparency;
    local v74 = p70.partSurfaces[p71];

    if not v74 then
        return nil;
    end;

    for _, v in v74 do
        local v75;

        if p72 then
            local v76 = p70.surfaceStates[v];

            if v76 ~= nil then
                v76 = v76.transparency;
            end;

            v75 = v76 == nil and 0 or v76;
        else
            v75 = 1;
        end;

        v.Transparency = v75;
    end;
end;

function u7.parkedCFrame(p77, p78) -- Line: 439
    local v79 = (math.random() - 0.5) * 2.4;
    local v80 = (math.random() - 0.5) * 2.4;
    local v81 = Vector3.new(v79, 11, v80);
    local v82 = CFrame.Angles((math.random() - 0.5) * 0.5235987755982988, (math.random() - 0.5) * 0.5235987755982988, (math.random() - 0.5) * 0.5235987755982988);

    return (p78 + v81) * v82;
end;

function u7.playBuildAnimation(u83, u84, u85) -- Line: 445
    -- upvalues: tweenAndDestroy (copy), u6 (copy), playWorldSound (copy)
    table.sort(u84, function(p86, p87) -- Line: 446
        return p86.Position.Y < p87.Position.Y;
    end);
    local buildToken = u83.buildToken;
    u83.building = true;

    for _, v in u84 do
        u83:setPieceVisible(v, false);
    end;

    for _, v in u85 do
        v.Enabled = false;
    end;

    local v88 = math.min(#u84, 68);
    local u89 = math.ceil(#u84 / v88);
    local u90 = 2.4 / math.ceil(#u84 / u89);
    task.spawn(function() -- Line: 460
        -- upvalues: u89 (copy), u84 (copy), u83 (copy), buildToken (copy), tweenAndDestroy (ref), u6 (ref), playWorldSound (ref), u90 (copy), u85 (copy)
        local v91 = false;
        local v92 = 0;

        while true do
            local v93;

            if v91 then
                v93 = v92 + u89;
            else
                v93 = v92;
                v91 = true;
            end;

            if v93 >= #u84 then
                task.wait(0.36);

                if u83.buildToken ~= buildToken then
                    return nil;
                end;

                u83.building = false;

                for _, v in u85 do
                    v.Enabled = true;
                end;

                return;
            end;

            if u83.buildToken ~= buildToken then
                return nil;
            end;

            local v94 = math.min(v93 + u89, #u84);
            v92 = v93;
            local v95 = false;

            while true do
                if true then
                    if v95 then
                        v93 = v93 + 1;
                    else
                        v95 = true;
                    end;
                end;

                if v93 >= v94 then
                    break;
                end;

                local v96 = u84[v93 + 1];
                local v97 = u83.partStates[v96];

                if v97 then
                    v96.CFrame = u83:parkedCFrame(v97.cframe);
                    u83:setPieceVisible(v96, true);
                    tweenAndDestroy(v96, u6, {
                        CFrame = v97.cframe
                    });
                end;
            end;

            local u98 = u84[v92 + 1];
            task.delay(0.36, function() -- Line: 502
                -- upvalues: u83 (ref), buildToken (ref), playWorldSound (ref), u98 (copy)
                if u83.buildToken ~= buildToken then
                    return nil;
                end;

                playWorldSound("Tick", {
                    volume = 0.3,
                    parent = u98
                });
            end);
            task.wait(u90);
        end;
    end);
end;

Reflect.defineMetadata(u7, "identifier", "client/components/world/PlotSectionComponent@PlotSectionComponent");
Reflect.defineMetadata(u7, "flamework:parameters", { "client/controllers/ui/SurfaceButtonController@SurfaceButtonController" });
Reflect.defineMetadata(u7, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u7, "$c:components@Component", Component, {
    {
        tag = "PlotSection",
        attributes = {
            SectionId = t.string,
            Unlocked = t.boolean
        },
        instanceGuard = t.instanceIsA("Model")
    }
});

return {
    PlotSectionComponent = u7
};