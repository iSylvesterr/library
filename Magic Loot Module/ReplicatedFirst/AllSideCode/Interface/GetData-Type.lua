-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {};
local v3 = {};
local v4 = {};
local v5 = {};
local v6 = {};
local v7 = {};
local v8 = {};
local v9 = {};
local v10 = {};
local v11 = {};
local v12 = {};
local v13 = {
    Bag = v1,
    Entry = v2,
    Mirror = v3,
    PlayerAttr = v4,
    EquipAttr = v5,
    CombatDamage = v6,
    Sell = v7,
    Backpack = {},
    Alchemy = v8,
    Train = v9,
    Shop = v10,
    OfflineReward = v11,
    Login = v12
};

function v1.GetItemCountByIDOnClient(p14) -- Line: 35
end;

function v1.GetItemCountByID(p15, p16) -- Line: 44
end;

function v1.WaitBagNumberValue(p17, p18) -- Line: 53
end;

function v13.GetBackpackToolbarSlotCount() -- Line: 62
end;

function v13.GetBackpackToolbarItemSlotMin() -- Line: 65
end;

function v13.GetBackpackToolbarItemSlotMax() -- Line: 68
end;

function v13.GetBackpackToolbarItemSlotCount() -- Line: 71
end;

function v13.GetBackpackWarehouseMaxSize() -- Line: 74
end;

function v13.IsBackpackToolbarItemEquipSlot(p19) -- Line: 77
end;

function v13.GetBackpackWarehouseCurrentSize(p20) -- Line: 80
end;

function v13.IsBagFullForItem(p21, p22, p23) -- Line: 90
end;

function v13.GetBackpackToolbarEquipByUiSlot(p24) -- Line: 93
end;

function v13.GetBackpackToolbarItemAtUiSlot(p25, p26, p27) -- Line: 96
end;

function v13.GetHeldToolbarOnlyId(p28) -- Line: 104
end;

function v13.IsToolbarSlotHeld(p29, p30, p31) -- Line: 114
end;

function v13.QueryBackpackWarehouseItems(p32, p33, p34) -- Line: 117
end;

function v13.GetFirstFreeBackpackToolbarItemSlot(p35) -- Line: 124
end;

function v13.ShouldRefreshToolbarOnPlayerDataSync(p36, p37, p38, p39) -- Line: 135
end;

function v13.ShouldRefreshWarehouseOnPlayerDataSync(p40, p41, p42, p43, p44) -- Line: 152
end;

function v2.GetDataAndCfg(p45, p46) -- Line: 168
end;

function v3.GetSetting(p47, p48) -- Line: 177
end;

function v3.IsHasPass(p49, p50) -- Line: 186
end;

function v3.IsInDungeonChallenge(p51) -- Line: 195
end;

function v3.GetPlayerByID(p52) -- Line: 203
end;

function v3.FindNearestPlayer(p53, p54) -- Line: 212
end;

function v3.parseGuideName(p55) -- Line: 221
end;

function v3.GetGuideStageCfg(p56, p57) -- Line: 231
end;

function v3.IsGuideStageEnemy(p58, p59, p60) -- Line: 234
end;

function v3.IsGuideStageBestDrop(p61, p62) -- Line: 237
end;

function v3.FindGuideEnemyPart(p63, p64) -- Line: 240
end;

function v3.FindBestClientDropPart() -- Line: 243
end;

function v4.GetPlrAttr(p65, p66) -- Line: 254
end;

function v4.GetRebirthExpAddMul(p67) -- Line: 263
end;

function v4.GetEffectiveTrainAtk(p68) -- Line: 271
end;

function v4.GetTotalMagicValue(p69) -- Line: 279
end;

function v4.GetCombatAttackPower(p70) -- Line: 287
end;

function v5.GetEquipAttrs(p71) -- Line: 295
end;

function v6.GetDmg(p72, p73, p74) -- Line: 306
end;

function v6.GetSkillDotTickOutgoingDmg(p75, p76, p77) -- Line: 320
end;

function v6.GetSkillDotTickDamage(p78, p79, p80, p81) -- Line: 331
end;

function v6.GetEnvHazardDotTickDamage(p82, p83, p84, p85) -- Line: 347
end;

function v6.GetReflectThornsDamage(p86, p87, p88, p89) -- Line: 364
end;

function v13.GetItemCountByIDOnClient(p90) -- Line: 373
end;

function v13.GetItemCountByID(p91, p92) -- Line: 376
end;

function v13.WaitBagNumberValue(p93, p94) -- Line: 379
end;

function v13.WaitRedPointValue(p95, p96) -- Line: 388
end;

function v13.GetRedPointValue(p97, p98) -- Line: 397
end;

function v13.IsRedPointActive(p99, p100) -- Line: 406
end;

function v13.GetDataAndCfg(p101, p102) -- Line: 409
end;

function v13.GetSetting(p103, p104) -- Line: 412
end;

function v13.IsHasPass(p105, p106) -- Line: 415
end;

function v13.IsInDungeonChallenge(p107) -- Line: 424
end;

function v13.GetPlayerByID(p108) -- Line: 427
end;

function v13.FindNearestPlayer(p109, p110) -- Line: 430
end;

function v13.parseGuideName(p111) -- Line: 439
end;

function v13.GetGuideStageCfg(p112, p113) -- Line: 442
end;

function v13.IsGuideStageEnemy(p114, p115, p116) -- Line: 445
end;

function v13.IsGuideStageBestDrop(p117, p118) -- Line: 448
end;

function v13.FindGuideEnemyPart(p119, p120) -- Line: 451
end;

function v13.FindBestClientDropPart() -- Line: 454
end;

function v13.IsPlrInPotionFlow(p121) -- Line: 460
end;

function v13.GetPlrAttr(p122, p123) -- Line: 463
end;

function v13.GetEffectiveTrainAtk(p124) -- Line: 466
end;

function v13.GetTotalMagicValue(p125) -- Line: 469
end;

function v13.GetCombatAttackPower(p126) -- Line: 472
end;

function v13.GetExpByLv(p127) -- Line: 475
end;

function v13.GetEquipAttrs(p128) -- Line: 478
end;

function v13.GetDmg(p129, p130, p131) -- Line: 481
end;

function v13.GetSkillDotTickOutgoingDmg(p132, p133, p134) -- Line: 488
end;

function v13.GetSkillDotTickDamage(p135, p136, p137, p138) -- Line: 491
end;

function v13.GetEnvHazardDotTickDamage(p139, p140, p141, p142) -- Line: 499
end;

function v13.GetReflectThornsDamage(p143, p144, p145, p146) -- Line: 507
end;

function v13.GetGoldAdd(p147) -- Line: 521
end;

function v13.GetSellPrice(p148, p149) -- Line: 531
end;

function v13.GetBuyLimitNum(p150) -- Line: 547
end;

function v13.FindGoodsIdByOnlyTag(p151) -- Line: 556
end;

function v13.GetShopBuyCount(p152, p153) -- Line: 566
end;

function v13.CanBuyShopItem(p154, p155) -- Line: 576
end;

function v13.IsRobuxMaterialPack(p156) -- Line: 585
end;

function v13.GetRobuxMaterialPackOnlyTags() -- Line: 593
end;

function v13.GetRobuxMaterialOfferXyd(p157) -- Line: 602
end;

function v13.RollRobuxMaterialId(p158) -- Line: 611
end;

function v13.GetRobuxMaterialOfferId(p159, p160) -- Line: 621
end;

function v13.HasBoughtShopItem(p161, p162) -- Line: 631
end;

function v13.GetShopBuyBlockReason(p163, p164) -- Line: 641
end;

function v13.GetCachedRobuxPrice(p165) -- Line: 650
end;

function v13.FetchRobuxPrice(p166, p167) -- Line: 659
end;

function v10.GetBuyLimitNum(p168) -- Line: 670
end;

function v10.FindGoodsIdByOnlyTag(p169) -- Line: 679
end;

function v10.GetShopBuyCount(p170, p171) -- Line: 689
end;

function v10.CanBuyShopItem(p172, p173) -- Line: 699
end;

function v10.IsRobuxMaterialPack(p174) -- Line: 708
end;

function v10.GetRobuxMaterialPackOnlyTags() -- Line: 716
end;

function v10.GetRobuxMaterialOfferXyd(p175) -- Line: 725
end;

function v10.RollRobuxMaterialId(p176) -- Line: 734
end;

function v10.GetRobuxMaterialOfferId(p177, p178) -- Line: 744
end;

function v10.HasBoughtShopItem(p179, p180) -- Line: 754
end;

function v10.GetShopBuyBlockReason(p181, p182) -- Line: 764
end;

function v10.GetCachedRobuxPrice(p183) -- Line: 773
end;

function v10.FetchRobuxPrice(p184, p185) -- Line: 782
end;

function v7.GetGoldAdd(p186) -- Line: 792
end;

function v7.GetSellPrice(p187, p188) -- Line: 802
end;

function v13.SkillConfSizeExtents(p189) -- Line: 811
end;

function v13.ScaleBandFromOpts(p190) -- Line: 820
end;

function v13.ScaleDualFromOpts(p191) -- Line: 829
end;

function v8.GetRecipeList() -- Line: 843
end;

function v8.GetMaterialOwnedCount(p192, p193) -- Line: 853
end;

function v8.CanCraftRecipe(p194, p195) -- Line: 856
end;

function v8.CanUseAlchemy(p196) -- Line: 865
end;

function v8.GetAlchemyNeedRebirth() -- Line: 873
end;

function v8.GetRecipeNeedRebirth(p197) -- Line: 882
end;

function v8.CanMeetRecipeRebirth(p198, p199) -- Line: 892
end;

function v8.GetMarkFolderName() -- Line: 900
end;

function v8.GetMarkRecipeIdValueName() -- Line: 908
end;

function v8.GetMarkedRecipeId(p200) -- Line: 917
end;

function v8.GetMarkMaterialRemain(p201, p202) -- Line: 927
end;

function v8.IsMarkedRecipeMaterial(p203, p204) -- Line: 937
end;

function v8.CalcMarkMaterialRemain(p205, p206, p207) -- Line: 948
end;

function v8.FormatNeedCount(p208, p209) -- Line: 951
end;

function v8.GetNeedCountColor(p210, p211) -- Line: 954
end;

function v8.GetPotionBrewRecordKey(p212) -- Line: 957
end;

function v8.IsPotionBrewed(p213, p214) -- Line: 960
end;

function v8.GetSkillIdFromPotion(p215) -- Line: 963
end;

function v8.GetBuffIdFromPotion(p216) -- Line: 970
end;

function v8.ShouldGrantEventPotionAsPay(p217) -- Line: 978
end;

function v8.GetRecipeCraftTimeSeconds(p218) -- Line: 981
end;

function v8.GetBrewPotionIdValueName() -- Line: 984
end;

function v8.GetBrewFinishUnixValueName() -- Line: 987
end;

function v8.ResolveFinishSpawnCFrame(p219) -- Line: 990
end;

function v8.IsPlayerMaterialBrewing(p220) -- Line: 993
end;

function v8.IsBrewInProgress(p221, p222) -- Line: 996
end;

function v8.IsBrewReadyForPickup(p223, p224) -- Line: 999
end;

function v8.GetBrewRemainingSeconds(p225, p226) -- Line: 1002
end;

function v8.GetFinishModelName(p227) -- Line: 1005
end;

function v8.GetAlchemyRootTagName() -- Line: 1008
end;

function v8.FindAlchemyRoot() -- Line: 1011
end;

function v8.FindAlchemyHeadTagGui() -- Line: 1019
end;

function v8.FindBrewTimeTextLabel() -- Line: 1027
end;

function v9.GetTrainPayMul(p228) -- Line: 1044
end;

function v9.CalcPaidPowerGrant(p229, p230) -- Line: 1054
end;

function v9.CalcTrainGain(p231, p232) -- Line: 1064
end;

function v9.FormatGain(p233) -- Line: 1067
end;

function v9.FormatAddMul(p234) -- Line: 1070
end;

function v9.CanEnterTrainGround(p235, p236) -- Line: 1073
end;

function v9.GetTrainIdFromInstance(p237) -- Line: 1082
end;

function v9.ResolveZonePart(p238) -- Line: 1091
end;

function v9.ResolveTrainFromTouch(p239) -- Line: 1101
end;

function v9.FindZonePartByTrainId(p240) -- Line: 1110
end;

function v9.IsWorldPointInZonePart(p241, p242, p243) -- Line: 1121
end;

function v9.IsPlayerInTrainZone(p244, p245, p246) -- Line: 1132
end;

function v9.GetTrainValue(p247) -- Line: 1141
end;

function v9.GetTrainAnimSpeedMul(p248) -- Line: 1150
end;

function v9.GetCrystalRotateTierCapDeg(p249) -- Line: 1159
end;

function v9.GetCrystalRotateFloorDeg(p250) -- Line: 1168
end;

function v9.GetCrystalHitImpulseDeg(p251) -- Line: 1177
end;

function v9.GetCrystalRotateHalfLifeSec() -- Line: 1185
end;

function v9.GetCrystalSoftCapSec() -- Line: 1193
end;

function v9.GetCrystalAimOffsetStud() -- Line: 1201
end;

function v9.GetManualChainBufferSec() -- Line: 1209
end;

function v11.GetOfflineConfigValue(p252) -- Line: 1225
end;

function v11.GetLobbySingleTrainGain(p253) -- Line: 1234
end;

function v11.GetCareerStageUnitSellPrice(p254, p255) -- Line: 1244
end;

function v11.CalcOfflineRewards(p256, p257, p258) -- Line: 1255
end;

function v11.CalcOfflineTrainPower(p259, p260) -- Line: 1269
end;

function v12.CanMeetLoginAdvancePrerequisite(p261) -- Line: 1278
end;

function v12.GetLoginAdvanceNeedRebirth() -- Line: 1286
end;

function v13.CanMeetLoginAdvancePrerequisite(p262) -- Line: 1289
end;

function v13.GetLoginAdvanceNeedRebirth() -- Line: 1292
end;

return v13;