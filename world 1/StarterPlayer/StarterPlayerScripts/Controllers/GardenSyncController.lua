-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 1
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = {};
local u12 = {};
local u13 = {};
local u14 = {};
local u15 = {};
local u16 = {};
local u17 = {};
local u18 = {};
local u19 = {};
local u20 = {};
local u21 = {};
local u22 = {};
local u23 = {};
local u24 = {};

local function SafeInvokeCallback(p25, ...) -- Line: 36
    local success, result = pcall(p25, ...);

    if not success then
        warn((`[GardenSyncController] Garden sync callback errored: {result}`));
    end;
end;

local function normalizeUserId(p26) -- Line: 43
    return tonumber(p26) or p26;
end;

function v1.Init(p27) -- Line: 47
end;

function v1.Start(u28) -- Line: 50
    -- upvalues: Networking (copy), Players (copy)
    Networking.Garden.SyncAllGardens.OnClientEvent:Connect(function(p29) -- Line: 51
        -- upvalues: u28 (copy)
        u28:HandleGardensSync(p29);
    end);
    task.spawn(function() -- Line: 60
        -- upvalues: Networking (ref)
        Networking.Garden.RequestGardens:Fire();
    end);
    Networking.Garden.PlantAdded.OnClientEvent:Connect(function(p30, p31, p32) -- Line: 64
        -- upvalues: u28 (copy)
        u28:HandlePlantAdded(tonumber(p30) or p30, p31, p32);
    end);
    Networking.Garden.PlantRemoved.OnClientEvent:Connect(function(p33, p34) -- Line: 68
        -- upvalues: u28 (copy)
        u28:HandlePlantRemoved(tonumber(p33) or p33, p34);
    end);
    Networking.Garden.PlantMoved.OnClientEvent:Connect(function(p35, p36, p37, p38) -- Line: 72
        -- upvalues: u28 (copy)
        u28:HandlePlantMoved(tonumber(p35) or p35, p36, p37, p38);
    end);
    Networking.Garden.PlantGrowthUpdated.OnClientEvent:Connect(function(p39, p40, p41, p42, p43, p44, p45) -- Line: 76
        -- upvalues: u28 (copy)
        u28:HandlePlantGrowthUpdated(tonumber(p39) or p39, p40, p41, p42, p43, p44, p45);
    end);
    Networking.Garden.PlantAgeSync.OnClientEvent:Connect(function(p46, p47) -- Line: 80
        -- upvalues: u28 (copy)
        u28:HandlePlantAgeSync(tonumber(p46) or p46, p47);
    end);
    Networking.Garden.SprinklerAdded.OnClientEvent:Connect(function(p48, p49, p50) -- Line: 84
        -- upvalues: u28 (copy)
        u28:HandleSprinklerAdded(tonumber(p48) or p48, p49, p50);
    end);
    Networking.Garden.SprinklerRemoved.OnClientEvent:Connect(function(p51, p52) -- Line: 88
        -- upvalues: u28 (copy)
        u28:HandleSprinklerRemoved(tonumber(p51) or p51, p52);
    end);
    Networking.Garden.RakeAdded.OnClientEvent:Connect(function(p53, p54, p55) -- Line: 92
        -- upvalues: u28 (copy)
        u28:HandleRakeAdded(tonumber(p53) or p53, p54, p55);
    end);
    Networking.Garden.RakeRemoved.OnClientEvent:Connect(function(p56, p57) -- Line: 96
        -- upvalues: u28 (copy)
        u28:HandleRakeRemoved(tonumber(p56) or p56, p57);
    end);
    Networking.Garden.FruitAdded.OnClientEvent:Connect(function(p58, p59, p60, p61) -- Line: 100
        -- upvalues: u28 (copy)
        u28:HandleFruitAdded(tonumber(p58) or p58, p59, p60, p61);
    end);
    Networking.Garden.FruitRemoved.OnClientEvent:Connect(function(p62, p63, p64) -- Line: 104
        -- upvalues: u28 (copy)
        u28:HandleFruitRemoved(tonumber(p62) or p62, p63, p64);
    end);
    Networking.Garden.FruitGrowthUpdated.OnClientEvent:Connect(function(p65, p66, p67, p68, p69, p70) -- Line: 108
        -- upvalues: u28 (copy)
        u28:HandleFruitGrowthUpdated(tonumber(p65) or p65, p66, p67, p68, p69, p70);
    end);
    Networking.Garden.FruitAgeSync.OnClientEvent:Connect(function(p71, p72, p73) -- Line: 112
        -- upvalues: u28 (copy)
        u28:HandleFruitAgeSync(tonumber(p71) or p71, p72, p73);
    end);
    Networking.Garden.FruitOvertimeGrowthUpdated.OnClientEvent:Connect(function(p74, p75, p76, p77) -- Line: 116
        -- upvalues: u28 (copy)
        u28:HandleFruitOvertimeGrowthUpdated(tonumber(p74) or p74, p75, p76, p77);
    end);
    Networking.Prop.PropPlaced.OnClientEvent:Connect(function(p78, p79, p80) -- Line: 120
        -- upvalues: u28 (copy)
        u28:HandlePropAdded(tonumber(p78) or p78, p79, p80);
    end);
    Networking.Prop.PropRemoved.OnClientEvent:Connect(function(p81, p82) -- Line: 124
        -- upvalues: u28 (copy)
        u28:HandlePropRemoved(tonumber(p81) or p81, p82);
    end);
    Networking.Prop.PropExtraDataUpdated.OnClientEvent:Connect(function(p83, p84, p85) -- Line: 128
        -- upvalues: u28 (copy)
        u28:HandlePropExtraDataUpdated(tonumber(p83) or p83, p84, p85);
    end);
    Players.PlayerRemoving:Connect(function(p86) -- Line: 132
        -- upvalues: u28 (copy)
        u28:CleanupPlayerGarden(p86.UserId);
    end);
end;

function v1.OnPlantMutationUpdated(p87, p88) -- Line: 137
    -- upvalues: Networking (copy)
    Networking.Garden.PlantMutationUpdated.OnClientEvent:Connect(p88);
end;

function v1.OnFruitMutationUpdated(p89, p90) -- Line: 141
    -- upvalues: Networking (copy)
    Networking.Garden.FruitMutationUpdated.OnClientEvent:Connect(p90);
end;

local u91 = {};
local u92 = false;
local u93 = 0;
local u94 = 0;
local u95 = 0;

function v1.EnqueueSpawnEntries(p96, p97, p98) -- Line: 157
    -- upvalues: u92 (ref), LocalPlayer (copy), u91 (copy), u93 (ref)
    if p98 == 0 then
        return;
    end;

    if p98 <= 5 and not u92 then
        for _, v in p97 do
            v.fn();
        end;

        return;
    end;

    local UserId = LocalPlayer.UserId;

    for _, v in p97 do
        if v.userId == UserId then
            table.insert(u91, v);
        end;
    end;

    for _, v in p97 do
        if v.userId ~= UserId then
            table.insert(u91, v);
        end;
    end;

    u93 = u93 + p98;

    if u92 then
        LocalPlayer:SetAttribute("GardenLoadingTotal", u93);

        return;
    end;

    p96:StartQueueProcessing();
end;

function v1.StartQueueProcessing(p99) -- Line: 190
    -- upvalues: u92 (ref), LocalPlayer (copy), u93 (ref), u95 (ref), u91 (copy), u94 (ref)
    u92 = true;
    task.spawn(function() -- Line: 193
        -- upvalues: LocalPlayer (ref), u93 (ref), u95 (ref), u91 (ref), u94 (ref), u92 (ref)
        LocalPlayer:SetAttribute("GardenLoadingTotal", u93);
        LocalPlayer:SetAttribute("GardenLoadingProgress", 0);
        u95 = 0;
        local v100 = os.clock();

        while u95 < #u91 do
            u95 = u95 + 1;
            local v101 = u91[u95];
            v101.fn();
            u94 = u94 + v101.entityCount;
            local v102 = LocalPlayer:GetAttribute("LoadingScreenActive") == true and 0.04 or 0.004;

            if u95 < #u91 and v102 <= os.clock() - v100 then
                LocalPlayer:SetAttribute("GardenLoadingProgress", u94);
                LocalPlayer:SetAttribute("GardenLoadingTotal", u93);
                task.wait();
                v100 = os.clock();
            end;
        end;

        LocalPlayer:SetAttribute("GardenLoadingTotal", nil);
        LocalPlayer:SetAttribute("GardenLoadingProgress", nil);
        table.clear(u91);
        u92 = false;
        u93 = 0;
        u94 = 0;
        u95 = 0;
    end);
end;

function v1.IsLocalGardenLoaded(p103) -- Line: 227
    -- upvalues: LocalPlayer (copy), u2 (copy), u92 (ref), u95 (ref), u91 (copy)
    local UserId = LocalPlayer.UserId;

    if not u2[UserId] then
        return false;
    end;

    if not u92 then
        return true;
    end;

    for i = u95 + 1, #u91 do
        if u91[i].userId == UserId then
            return false;
        end;
    end;

    return true;
end;

function v1.WaitForLocalGardenLoaded(p104) -- Line: 243
    while not p104:IsLocalGardenLoaded() do
        task.wait();
    end;
end;

function v1.HandleGardensSync(p105, p106) -- Line: 249
    -- upvalues: u2 (copy), u3 (copy), u4 (copy), u5 (copy), u6 (copy), SafeInvokeCallback (copy), u15 (copy), u20 (copy), u19 (copy), u11 (copy), u13 (copy), u22 (copy)
    local v107 = {};
    local v108 = 0;

    for i, v in p106 do
        local u109 = tonumber(i) or i;

        if not u2[u109] then
            u2[u109] = {};
        end;

        if not u3[u109] then
            u3[u109] = {};
        end;

        if not u4[u109] then
            u4[u109] = {};
        end;

        if not u5[u109] then
            u5[u109] = {};
        end;

        if v.Plants then
            for i2, v2 in v.Plants do
                local v110 = u2[u109][i2];
                local v111 = v110 and (v110.Fruits or {}) or {};
                u2[u109][i2] = v2;

                if v110 then
                    for _, v3 in u20 do
                        task.spawn(SafeInvokeCallback, v3, u109, i2, v2);
                    end;

                    if v2.Fruits then
                        for i3, v3 in v2.Fruits do
                            if v111[i3] then
                                local u112 = v3.OvertimeGrowth or 1;

                                if math.floor((v111[i3].OvertimeGrowth or 1) * 100) ~= math.floor(u112 * 100) then
                                    u2[u109][i2].Fruits[i3] = v3;
                                    table.insert(v107, {
                                        entityCount = 0,
                                        userId = u109,

                                        fn = function() -- Line: 325, Name: fn
                                            -- upvalues: u19 (ref), SafeInvokeCallback (ref), u109 (copy), i2 (copy), i3 (copy), u112 (copy)
                                            for _, v4 in u19 do
                                                task.spawn(SafeInvokeCallback, v4, u109, i2, i3, u112);
                                            end;
                                        end
                                    });
                                end;
                            else
                                v108 = v108 + 1;
                                table.insert(v107, {
                                    entityCount = 1,
                                    userId = u109,

                                    fn = function() -- Line: 309, Name: fn
                                        -- upvalues: u15 (ref), SafeInvokeCallback (ref), u109 (copy), i2 (copy), i3 (copy), v3 (copy)
                                        for _, v4 in u15 do
                                            task.spawn(SafeInvokeCallback, v4, u109, i2, i3, v3);
                                        end;
                                    end
                                });
                            end;
                        end;
                    end;
                else
                    local u113 = {};

                    if v2.Fruits then
                        for i3, v3 in v2.Fruits do
                            table.insert(u113, {
                                fruitId = i3,
                                fruitData = v3
                            });
                        end;
                    end;

                    local v114 = #u113 + 1;
                    v108 = v108 + v114;
                    table.insert(v107, {
                        userId = u109,
                        entityCount = v114,

                        fn = function() -- Line: 287, Name: fn
                            -- upvalues: u6 (ref), SafeInvokeCallback (ref), u109 (copy), i2 (copy), v2 (copy), u113 (copy), u15 (ref)
                            for _, v3 in u6 do
                                task.spawn(SafeInvokeCallback, v3, u109, i2, v2);
                            end;

                            for _, v3 in u113 do
                                for _, v4 in u15 do
                                    task.spawn(SafeInvokeCallback, v4, u109, i2, v3.fruitId, v3.fruitData);
                                end;
                            end;
                        end
                    });
                end;
            end;
        end;

        if v.Sprinklers then
            for i2, v2 in v.Sprinklers do
                if u3[u109][i2] then
                    u3[u109][i2] = v2;
                else
                    u3[u109][i2] = v2;
                    v108 = v108 + 1;
                    table.insert(v107, {
                        entityCount = 1,
                        userId = u109,

                        fn = function() -- Line: 347, Name: fn
                            -- upvalues: u11 (ref), SafeInvokeCallback (ref), u109 (copy), i2 (copy), v2 (copy)
                            for _, v3 in u11 do
                                task.spawn(SafeInvokeCallback, v3, u109, i2, v2);
                            end;
                        end
                    });
                end;
            end;
        end;

        if v.Rakes then
            for i2, v2 in v.Rakes do
                if u4[u109][i2] then
                    u4[u109][i2] = v2;
                else
                    u4[u109][i2] = v2;
                    v108 = v108 + 1;
                    table.insert(v107, {
                        entityCount = 1,
                        userId = u109,

                        fn = function() -- Line: 367, Name: fn
                            -- upvalues: u13 (ref), SafeInvokeCallback (ref), u109 (copy), i2 (copy), v2 (copy)
                            for _, v3 in u13 do
                                task.spawn(SafeInvokeCallback, v3, u109, i2, v2);
                            end;
                        end
                    });
                end;
            end;
        end;

        if v.Props then
            for i2, v2 in v.Props do
                if u5[u109][i2] then
                    u5[u109][i2] = v2;
                else
                    u5[u109][i2] = v2;
                    v108 = v108 + 1;
                    table.insert(v107, {
                        entityCount = 1,
                        userId = u109,

                        fn = function() -- Line: 387, Name: fn
                            -- upvalues: u22 (ref), SafeInvokeCallback (ref), u109 (copy), i2 (copy), v2 (copy)
                            for _, v3 in u22 do
                                task.spawn(SafeInvokeCallback, v3, u109, i2, v2);
                            end;
                        end
                    });
                end;
            end;
        end;
    end;

    p105:EnqueueSpawnEntries(v107, v108);
end;

function v1.HandlePlantAdded(p115, p116, p117, p118) -- Line: 406
    -- upvalues: u2 (copy), u6 (copy), SafeInvokeCallback (copy), u15 (copy)
    if not u2[p116] then
        u2[p116] = {};
    end;

    u2[p116][p117] = p118;

    for _, v in u6 do
        task.spawn(SafeInvokeCallback, v, p116, p117, p118);
    end;

    if p118.Fruits then
        for i, v in p118.Fruits do
            for _, v2 in u15 do
                task.spawn(SafeInvokeCallback, v2, p116, p117, i, v);
            end;
        end;
    end;
end;

function v1.HandlePlantRemoved(p119, p120, p121) -- Line: 424
    -- upvalues: u2 (copy), u7 (copy), SafeInvokeCallback (copy)
    if u2[p120] then
        u2[p120][p121] = nil;
    end;

    for _, v in u7 do
        task.spawn(SafeInvokeCallback, v, p120, p121);
    end;
end;

function v1.HandlePlantMoved(p122, p123, p124, p125, p126) -- Line: 433
    -- upvalues: u2 (copy), u8 (copy), SafeInvokeCallback (copy)
    if u2[p123] and u2[p123][p124] then
        u2[p123][p124].Positions = {
            PosX = p125.X,
            PosY = p125.Y,
            PosZ = p125.Z,
            Rotation = p126
        };
    end;

    for _, v in u8 do
        task.spawn(SafeInvokeCallback, v, p123, p124, p125, p126);
    end;
end;

function v1.HandlePlantGrowthUpdated(p127, p128, p129, p130, p131, p132, p133, p134) -- Line: 447
    -- upvalues: u2 (copy), u9 (copy), SafeInvokeCallback (copy)
    if u2[p128] and u2[p128][p129] then
        u2[p128][p129].Age = p130;
    end;

    for _, v in u9 do
        task.spawn(SafeInvokeCallback, v, p128, p129, p130, p131, p132, p133, p134);
    end;
end;

function v1.HandlePlantAgeSync(p135, p136, p137) -- Line: 457
    -- upvalues: u2 (copy), u10 (copy), SafeInvokeCallback (copy)
    if not u2[p136] then
        u2[p136] = {};
    end;

    for i, v in p137 do
        if u2[p136][i] then
            u2[p136][i].Age = v;
        end;
    end;

    for _, v in u10 do
        task.spawn(SafeInvokeCallback, v, p136, p137);
    end;
end;

function v1.HandleSprinklerAdded(p138, p139, p140, p141) -- Line: 476
    -- upvalues: u3 (copy), u11 (copy), SafeInvokeCallback (copy)
    if not u3[p139] then
        u3[p139] = {};
    end;

    u3[p139][p140] = p141;

    for _, v in u11 do
        task.spawn(SafeInvokeCallback, v, p139, p140, p141);
    end;
end;

function v1.HandleSprinklerRemoved(p142, p143, p144) -- Line: 486
    -- upvalues: u3 (copy), u12 (copy), SafeInvokeCallback (copy)
    if u3[p143] then
        u3[p143][p144] = nil;
    end;

    for _, v in u12 do
        task.spawn(SafeInvokeCallback, v, p143, p144);
    end;
end;

function v1.HandleRakeAdded(p145, p146, p147, p148) -- Line: 498
    -- upvalues: u4 (copy), u13 (copy), SafeInvokeCallback (copy)
    if not u4[p146] then
        u4[p146] = {};
    end;

    u4[p146][p147] = p148;

    for _, v in u13 do
        task.spawn(SafeInvokeCallback, v, p146, p147, p148);
    end;
end;

function v1.HandleRakeRemoved(p149, p150, p151) -- Line: 508
    -- upvalues: u4 (copy), u14 (copy), SafeInvokeCallback (copy)
    if u4[p150] then
        u4[p150][p151] = nil;
    end;

    for _, v in u14 do
        task.spawn(SafeInvokeCallback, v, p150, p151);
    end;
end;

function v1.HandlePropAdded(p152, p153, p154, p155) -- Line: 520
    -- upvalues: u5 (copy), u22 (copy), SafeInvokeCallback (copy)
    if not u5[p153] then
        u5[p153] = {};
    end;

    u5[p153][p154] = p155;

    for _, v in u22 do
        task.spawn(SafeInvokeCallback, v, p153, p154, p155);
    end;
end;

function v1.HandlePropRemoved(p156, p157, p158) -- Line: 530
    -- upvalues: u5 (copy), u23 (copy), SafeInvokeCallback (copy)
    if u5[p157] then
        u5[p157][p158] = nil;
    end;

    for _, v in u23 do
        task.spawn(SafeInvokeCallback, v, p157, p158);
    end;
end;

function v1.HandlePropExtraDataUpdated(p159, p160, p161, p162) -- Line: 539
    -- upvalues: u5 (copy), u24 (copy), SafeInvokeCallback (copy)
    if u5[p160] and u5[p160][p161] then
        u5[p160][p161].ExtraData = p162;
    end;

    for _, v in u24 do
        task.spawn(SafeInvokeCallback, v, p160, p161, p162);
    end;
end;

function v1.HandleFruitAdded(p163, p164, p165, p166, p167) -- Line: 551
    -- upvalues: u2 (copy), u15 (copy), SafeInvokeCallback (copy)
    if not u2[p164] then
        u2[p164] = {};
    end;

    if not u2[p164][p165] then
        u2[p164][p165] = {};
    end;

    if not u2[p164][p165].Fruits then
        u2[p164][p165].Fruits = {};
    end;

    u2[p164][p165].Fruits[p166] = p167;

    for _, v in u15 do
        task.spawn(SafeInvokeCallback, v, p164, p165, p166, p167);
    end;
end;

function v1.HandleFruitRemoved(p168, p169, p170, p171) -- Line: 568
    -- upvalues: u2 (copy), u16 (copy), SafeInvokeCallback (copy)
    if u2[p169] and (u2[p169][p170] and u2[p169][p170].Fruits) then
        u2[p169][p170].Fruits[p171] = nil;
    end;

    for _, v in u16 do
        task.spawn(SafeInvokeCallback, v, p169, p170, p171);
    end;
end;

function v1.HandleFruitGrowthUpdated(p172, p173, p174, p175, p176, p177, p178) -- Line: 578
    -- upvalues: u2 (copy), u17 (copy), SafeInvokeCallback (copy)
    if u2[p173] and (u2[p173][p174] and (u2[p173][p174].Fruits and u2[p173][p174].Fruits[p175])) then
        u2[p173][p174].Fruits[p175].Age = p176;
        u2[p173][p174].Fruits[p175].GrowRate = p177;
        u2[p173][p174].Fruits[p175].BoostSources = p178 or 0;
    end;

    for _, v in u17 do
        task.spawn(SafeInvokeCallback, v, p173, p174, p175, p176, p177, p178 or 0);
    end;
end;

function v1.HandleFruitAgeSync(p179, p180, p181, p182) -- Line: 590
    -- upvalues: u2 (copy), u18 (copy), SafeInvokeCallback (copy)
    if not (u2[p180] and (u2[p180][p181] and u2[p180][p181].Fruits)) then
        return;
    end;

    for i, v in p182 do
        if u2[p180][p181].Fruits[i] then
            u2[p180][p181].Fruits[i].Age = v;
        end;
    end;

    for _, v in u18 do
        task.spawn(SafeInvokeCallback, v, p180, p181, p182);
    end;
end;

function v1.HandleFruitOvertimeGrowthUpdated(p183, p184, p185, p186, p187) -- Line: 604
    -- upvalues: u2 (copy), u19 (copy), SafeInvokeCallback (copy)
    if u2[p184] and (u2[p184][p185] and (u2[p184][p185].Fruits and u2[p184][p185].Fruits[p186])) then
        u2[p184][p185].Fruits[p186].OvertimeGrowth = p187;
    end;

    for _, v in u19 do
        task.spawn(SafeInvokeCallback, v, p184, p185, p186, p187);
    end;
end;

function v1.GetGarden(p188, p189) -- Line: 617
    -- upvalues: u2 (copy)
    return u2[tonumber(p189) or p189] or {};
end;

function v1.GetPlant(p190, p191, p192) -- Line: 621
    -- upvalues: u2 (copy)
    local v193 = tonumber(p191) or p191;

    if u2[v193] then
        return u2[v193][p192];
    end;

    return nil;
end;

function v1.GetAllGardens(p194) -- Line: 627
    -- upvalues: u2 (copy)
    return u2;
end;

function v1.GetSprinklers(p195, p196) -- Line: 631
    -- upvalues: u3 (copy)
    return u3[tonumber(p196) or p196] or {};
end;

function v1.GetSprinkler(p197, p198, p199) -- Line: 635
    -- upvalues: u3 (copy)
    local v200 = tonumber(p198) or p198;

    if u3[v200] then
        return u3[v200][p199];
    end;

    return nil;
end;

function v1.GetAllSprinklers(p201) -- Line: 641
    -- upvalues: u3 (copy)
    return u3;
end;

function v1.GetRakes(p202, p203) -- Line: 645
    -- upvalues: u4 (copy)
    return u4[tonumber(p203) or p203] or {};
end;

function v1.GetRake(p204, p205, p206) -- Line: 649
    -- upvalues: u4 (copy)
    local v207 = tonumber(p205) or p205;

    if u4[v207] then
        return u4[v207][p206];
    end;

    return nil;
end;

function v1.GetAllRakes(p208) -- Line: 655
    -- upvalues: u4 (copy)
    return u4;
end;

function v1.GetProps(p209, p210) -- Line: 659
    -- upvalues: u5 (copy)
    return u5[tonumber(p210) or p210] or {};
end;

function v1.GetProp(p211, p212, p213) -- Line: 663
    -- upvalues: u5 (copy)
    local v214 = tonumber(p212) or p212;

    if u5[v214] then
        return u5[v214][p213];
    end;

    return nil;
end;

function v1.GetAllProps(p215) -- Line: 669
    -- upvalues: u5 (copy)
    return u5;
end;

function v1.OnPlantAdded(p216, u217) -- Line: 676
    -- upvalues: u6 (copy)
    table.insert(u6, u217);

    return function() -- Line: 678
        -- upvalues: u6 (ref), u217 (copy)
        local v218 = table.find(u6, u217);

        if v218 then
            table.remove(u6, v218);
        end;
    end;
end;

function v1.OnPlantVisualCheck(p219, u220) -- Line: 686
    -- upvalues: u20 (copy)
    table.insert(u20, u220);

    return function() -- Line: 688
        -- upvalues: u20 (ref), u220 (copy)
        local v221 = table.find(u20, u220);

        if v221 then
            table.remove(u20, v221);
        end;
    end;
end;

function v1.OnFruitVisualCheck(p222, u223) -- Line: 699
    -- upvalues: u21 (copy)
    table.insert(u21, u223);

    return function() -- Line: 701
        -- upvalues: u21 (ref), u223 (copy)
        local v224 = table.find(u21, u223);

        if v224 then
            table.remove(u21, v224);
        end;
    end;
end;

function v1.ReconcileLocalGarden(p225) -- Line: 714
    -- upvalues: LocalPlayer (copy), u2 (copy), u20 (copy), SafeInvokeCallback (copy), u21 (copy)
    local UserId = LocalPlayer.UserId;
    local v226 = u2[UserId];

    if not v226 then
        return 0;
    end;

    local v227 = 0;

    for i, v in v226 do
        v227 = v227 + 1;

        for _, v2 in u20 do
            task.spawn(SafeInvokeCallback, v2, UserId, i, v);
        end;

        if v.Fruits then
            for i2, v2 in v.Fruits do
                for _, v3 in u21 do
                    task.spawn(SafeInvokeCallback, v3, UserId, i, i2, v2);
                end;
            end;
        end;
    end;

    return v227;
end;

function v1.OnPlantRemoved(p228, u229) -- Line: 736
    -- upvalues: u7 (copy)
    table.insert(u7, u229);

    return function() -- Line: 738
        -- upvalues: u7 (ref), u229 (copy)
        local v230 = table.find(u7, u229);

        if v230 then
            table.remove(u7, v230);
        end;
    end;
end;

function v1.OnPlantMoved(p231, u232) -- Line: 746
    -- upvalues: u8 (copy)
    table.insert(u8, u232);

    return function() -- Line: 748
        -- upvalues: u8 (ref), u232 (copy)
        local v233 = table.find(u8, u232);

        if v233 then
            table.remove(u8, v233);
        end;
    end;
end;

function v1.OnPlantGrowthUpdated(p234, u235) -- Line: 756
    -- upvalues: u9 (copy)
    table.insert(u9, u235);

    return function() -- Line: 758
        -- upvalues: u9 (ref), u235 (copy)
        local v236 = table.find(u9, u235);

        if v236 then
            table.remove(u9, v236);
        end;
    end;
end;

function v1.OnPlantAgeSync(p237, u238) -- Line: 766
    -- upvalues: u10 (copy)
    table.insert(u10, u238);

    return function() -- Line: 768
        -- upvalues: u10 (ref), u238 (copy)
        local v239 = table.find(u10, u238);

        if v239 then
            table.remove(u10, v239);
        end;
    end;
end;

function v1.OnSprinklerAdded(p240, u241) -- Line: 776
    -- upvalues: u11 (copy)
    table.insert(u11, u241);

    return function() -- Line: 778
        -- upvalues: u11 (ref), u241 (copy)
        local v242 = table.find(u11, u241);

        if v242 then
            table.remove(u11, v242);
        end;
    end;
end;

function v1.OnSprinklerRemoved(p243, u244) -- Line: 786
    -- upvalues: u12 (copy)
    table.insert(u12, u244);

    return function() -- Line: 788
        -- upvalues: u12 (ref), u244 (copy)
        local v245 = table.find(u12, u244);

        if v245 then
            table.remove(u12, v245);
        end;
    end;
end;

function v1.OnRakeAdded(p246, u247) -- Line: 796
    -- upvalues: u13 (copy)
    table.insert(u13, u247);

    return function() -- Line: 798
        -- upvalues: u13 (ref), u247 (copy)
        local v248 = table.find(u13, u247);

        if v248 then
            table.remove(u13, v248);
        end;
    end;
end;

function v1.OnRakeRemoved(p249, u250) -- Line: 806
    -- upvalues: u14 (copy)
    table.insert(u14, u250);

    return function() -- Line: 808
        -- upvalues: u14 (ref), u250 (copy)
        local v251 = table.find(u14, u250);

        if v251 then
            table.remove(u14, v251);
        end;
    end;
end;

function v1.OnPropAdded(p252, u253) -- Line: 816
    -- upvalues: u22 (copy)
    table.insert(u22, u253);

    return function() -- Line: 818
        -- upvalues: u22 (ref), u253 (copy)
        local v254 = table.find(u22, u253);

        if v254 then
            table.remove(u22, v254);
        end;
    end;
end;

function v1.OnPropRemoved(p255, u256) -- Line: 826
    -- upvalues: u23 (copy)
    table.insert(u23, u256);

    return function() -- Line: 828
        -- upvalues: u23 (ref), u256 (copy)
        local v257 = table.find(u23, u256);

        if v257 then
            table.remove(u23, v257);
        end;
    end;
end;

function v1.OnPropExtraDataUpdated(p258, u259) -- Line: 836
    -- upvalues: u24 (copy)
    table.insert(u24, u259);

    return function() -- Line: 838
        -- upvalues: u24 (ref), u259 (copy)
        local v260 = table.find(u24, u259);

        if v260 then
            table.remove(u24, v260);
        end;
    end;
end;

function v1.OnFruitAdded(p261, u262) -- Line: 846
    -- upvalues: u15 (copy)
    table.insert(u15, u262);

    return function() -- Line: 848
        -- upvalues: u15 (ref), u262 (copy)
        local v263 = table.find(u15, u262);

        if v263 then
            table.remove(u15, v263);
        end;
    end;
end;

function v1.OnFruitRemoved(p264, u265) -- Line: 856
    -- upvalues: u16 (copy)
    table.insert(u16, u265);

    return function() -- Line: 858
        -- upvalues: u16 (ref), u265 (copy)
        local v266 = table.find(u16, u265);

        if v266 then
            table.remove(u16, v266);
        end;
    end;
end;

function v1.OnFruitGrowthUpdated(p267, u268) -- Line: 866
    -- upvalues: u17 (copy)
    table.insert(u17, u268);

    return function() -- Line: 868
        -- upvalues: u17 (ref), u268 (copy)
        local v269 = table.find(u17, u268);

        if v269 then
            table.remove(u17, v269);
        end;
    end;
end;

function v1.OnFruitAgeSync(p270, u271) -- Line: 876
    -- upvalues: u18 (copy)
    table.insert(u18, u271);

    return function() -- Line: 878
        -- upvalues: u18 (ref), u271 (copy)
        local v272 = table.find(u18, u271);

        if v272 then
            table.remove(u18, v272);
        end;
    end;
end;

function v1.OnFruitOvertimeGrowthUpdated(p273, u274) -- Line: 886
    -- upvalues: u19 (copy)
    table.insert(u19, u274);

    return function() -- Line: 888
        -- upvalues: u19 (ref), u274 (copy)
        local v275 = table.find(u19, u274);

        if v275 then
            table.remove(u19, v275);
        end;
    end;
end;

function v1.CleanupPlayerGarden(p276, p277) -- Line: 899
    -- upvalues: u2 (copy), u3 (copy), u4 (copy), u5 (copy)
    local v278 = tonumber(p277) or p277;

    if u2[v278] then
        for i in u2[v278] do
            p276:HandlePlantRemoved(v278, i);
        end;

        u2[v278] = nil;
    end;

    if u3[v278] then
        for i in u3[v278] do
            p276:HandleSprinklerRemoved(v278, i);
        end;

        u3[v278] = nil;
    end;

    if u4[v278] then
        for i in u4[v278] do
            p276:HandleRakeRemoved(v278, i);
        end;

        u4[v278] = nil;
    end;

    if u5[v278] then
        for i in u5[v278] do
            p276:HandlePropRemoved(v278, i);
        end;

        u5[v278] = nil;
    end;
end;

return v1;