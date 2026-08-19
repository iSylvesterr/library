-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ActiveAssetsController = require(script.Parent.Parent.ActiveAssetsController);
local AssetCmds = require(ReplicatedStorage.Library.Client.AssetCmds);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local CurrencyItem = require(ReplicatedStorage.Library.Items.CurrencyItem);
local Currency = require(ReplicatedStorage.Library.Types.Currency);
local Lock = require(ReplicatedStorage.Library.Functions.Lock);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Item = require(ReplicatedStorage.Library.Client.NotificationCmds.Item);
local OfflineAssets = require(ReplicatedStorage.Library.Types.OfflineAssets);
local ClaimVisual = require(script.ClaimVisual);
local Player = require(ReplicatedStorage.Library.Player);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local OfflineAssets2 = Network.NET_MAP.OfflineAssets;
local MIN_CLAIM_MONEY = Constants.OFFLINE_ASSETS.MIN_CLAIM_MONEY;
local Money = Currency.AllCurrencyTypes.Money;
local LocalPlayer = Players.LocalPlayer;
local u1 = nil;
local u2 = 0;
local u3 = nil;
local u4 = {};

local function readSummary(p5) -- Line: 54
    -- upvalues: OfflineAssets (copy)
    if OfflineAssets.OfflineClaimSummary(p5) then
        return p5;
    end;

    return nil;
end;

local function readRedeemResult(p6) -- Line: 62
    -- upvalues: OfflineAssets (copy)
    if OfflineAssets.OfflineRedeemResult(p6) then
        return p6;
    end;

    return nil;
end;

local function hasReadiness() -- Line: 70
    -- upvalues: Save (copy)
    return Save.IsLocalDataLoaded();
end;

local function currentClaimAmount() -- Line: 74
    -- upvalues: u1 (ref), MIN_CLAIM_MONEY (copy)
    local v7 = u1;
    local v8 = not v7 and 0 or math.max(v7.TotalAmount, 0);

    return MIN_CLAIM_MONEY > v8 and 0 or v8;
end;

local function clearSession(p9) -- Line: 80
    -- upvalues: u3 (ref)
    local v10 = u3;

    if p9 ~= nil and v10 ~= p9 then
        return;
    end;

    u3 = nil;

    if v10 then
        v10.trove:Destroy();
    end;
end;

local function feetInsideSession(p11) -- Line: 93
    -- upvalues: Player (copy), LocalPlayer (copy)
    local v12 = Player.Optional.FeetCFrame(LocalPlayer);
    local v13;

    if v12 == nil then
        v13 = false;
    else
        v13 = p11.visual:ContainsWorldPosition(v12.Position);
    end;

    return v13;
end;

local function requestSummary() -- Line: 98
    -- upvalues: u2 (ref), Network (copy), OfflineAssets2 (copy), OfflineAssets (copy), u1 (ref), u4 (copy)
    u2 = u2 + 1;
    local u14 = u2;
    task.spawn(function() -- Line: 102
        -- upvalues: Network (ref), OfflineAssets2 (ref), OfflineAssets (ref), u14 (copy), u2 (ref), u1 (ref), u4 (ref)
        local v15 = Network.Invoke(OfflineAssets2.GET_SUMMARY);

        if not OfflineAssets.OfflineClaimSummary(v15) then
            v15 = nil;
        end;

        if u14 ~= u2 then
            return;
        end;

        if v15 then
            u1 = v15;
        end;

        u4.Sync();
    end);
end;

local function showOfflineMoneyNotification(p16) -- Line: 114
    -- upvalues: CurrencyItem (copy), Money (copy), Item (copy)
    if p16 <= 0 then
        return;
    end;

    local v17 = CurrencyItem(Money):SetAmount((math.round(p16)));
    Item.Bottom({
        Item = v17
    });
end;

local function claim(u18) -- Line: 125
    -- upvalues: u1 (ref), Network (copy), OfflineAssets2 (copy), OfflineAssets (copy), CurrencyItem (copy), Money (copy), Item (copy), u3 (ref), u2 (ref), u4 (copy)
    if u18.amount <= 0 then
        return;
    end;

    u18.claimLock(function() -- Line: 130
        -- upvalues: u1 (ref), u18 (copy), Network (ref), OfflineAssets2 (ref), OfflineAssets (ref), CurrencyItem (ref), Money (ref), Item (ref), u3 (ref), u2 (ref), u4 (ref)
        u1 = {
            ClaimableAmount = 0,
            ReservedAmount = 0,
            TotalAmount = 0,
            IsMultiplierPurchasePending = false
        };
        u18.visual:PlayClaim();
        local v19, _, v20 = Network.Invoke(OfflineAssets2.REQUEST_REDEEM, {
            Kind = "Claim"
        });

        if not OfflineAssets.OfflineRedeemResult(v20) then
            v20 = nil;
        end;

        if v19 ~= true or v20 == nil then
            u2 = u2 + 1;
            local u21 = u2;
            task.spawn(function() -- Line: 102
                -- upvalues: Network (ref), OfflineAssets2 (ref), OfflineAssets (ref), u21 (copy), u2 (ref), u1 (ref), u4 (ref)
                local v22 = Network.Invoke(OfflineAssets2.GET_SUMMARY);

                if not OfflineAssets.OfflineClaimSummary(v22) then
                    v22 = nil;
                end;

                if u21 ~= u2 then
                    return;
                end;

                if v22 then
                    u1 = v22;
                end;

                u4.Sync();
            end);

            return;
        end;

        local AwardedAmount = v20.AwardedAmount;

        if AwardedAmount > 0 then
            local v23 = CurrencyItem(Money):SetAmount((math.round(AwardedAmount)));
            Item.Bottom({
                Item = v23
            });
        end;

        local v24 = u18;
        local v25 = u3;

        if v24 ~= nil and v25 ~= v24 then
            return;
        end;

        u3 = nil;

        if v25 then
            v25.trove:Destroy();
        end;
    end);
end;

local function updateClaimEntry(u26) -- Line: 154
    -- upvalues: Player (copy), LocalPlayer (copy), u1 (ref), Network (copy), OfflineAssets2 (copy), OfflineAssets (copy), CurrencyItem (copy), Money (copy), Item (copy), u3 (ref), u2 (ref), u4 (copy)
    local v27 = Player.Optional.FeetCFrame(LocalPlayer);
    local v28;

    if v27 == nil then
        v28 = false;
    else
        v28 = u26.visual:ContainsWorldPosition(v27.Position);
    end;

    local feetInside = u26.feetInside;
    u26.feetInside = v28;
    u26.visual:SetBillboardEnabled(not v28);

    if v28 and not feetInside then
        if u26.amount <= 0 then
            return;
        end;

        u26.claimLock(function() -- Line: 130
            -- upvalues: u1 (ref), u26 (copy), Network (ref), OfflineAssets2 (ref), OfflineAssets (ref), CurrencyItem (ref), Money (ref), Item (ref), u3 (ref), u2 (ref), u4 (ref)
            u1 = {
                ClaimableAmount = 0,
                ReservedAmount = 0,
                TotalAmount = 0,
                IsMultiplierPurchasePending = false
            };
            u26.visual:PlayClaim();
            local v29, _, v30 = Network.Invoke(OfflineAssets2.REQUEST_REDEEM, {
                Kind = "Claim"
            });

            if not OfflineAssets.OfflineRedeemResult(v30) then
                v30 = nil;
            end;

            if v29 ~= true or v30 == nil then
                u2 = u2 + 1;
                local u31 = u2;
                task.spawn(function() -- Line: 102
                    -- upvalues: Network (ref), OfflineAssets2 (ref), OfflineAssets (ref), u31 (copy), u2 (ref), u1 (ref), u4 (ref)
                    local v32 = Network.Invoke(OfflineAssets2.GET_SUMMARY);

                    if not OfflineAssets.OfflineClaimSummary(v32) then
                        v32 = nil;
                    end;

                    if u31 ~= u2 then
                        return;
                    end;

                    if v32 then
                        u1 = v32;
                    end;

                    u4.Sync();
                end);

                return;
            end;

            local AwardedAmount = v30.AwardedAmount;

            if AwardedAmount > 0 then
                local v33 = CurrencyItem(Money):SetAmount((math.round(AwardedAmount)));
                Item.Bottom({
                    Item = v33
                });
            end;

            local v34 = u26;
            local v35 = u3;

            if v34 ~= nil and v35 ~= v34 then
                return;
            end;

            u3 = nil;

            if v35 then
                v35.trove:Destroy();
            end;
        end);
    end;
end;

local function sessionFor(p36, p37, p38) -- Line: 165
    -- upvalues: Trove (copy), ClaimVisual (copy), Lock (copy), RunService (copy), Player (copy), LocalPlayer (copy), u1 (ref), Network (copy), OfflineAssets2 (copy), OfflineAssets (copy), CurrencyItem (copy), Money (copy), Item (copy), u3 (ref), u2 (ref), u4 (copy)
    local v39 = Trove.new();
    local u40 = ClaimVisual.new(p36, p37, p38);
    local u41 = {
        feetInside = false,
        trove = v39,
        amount = p36,
        visual = u40,
        claimLock = Lock()
    };
    v39:Add(function() -- Line: 176
        -- upvalues: u40 (copy)
        u40:Destroy();
    end);
    v39:Add(RunService.Heartbeat:Connect(function() -- Line: 179
        -- upvalues: u41 (copy), Player (ref), LocalPlayer (ref), u1 (ref), Network (ref), OfflineAssets2 (ref), OfflineAssets (ref), CurrencyItem (ref), Money (ref), Item (ref), u3 (ref), u2 (ref), u4 (ref)
        local u42 = u41;
        local v43 = Player.Optional.FeetCFrame(LocalPlayer);
        local v44;

        if v43 == nil then
            v44 = false;
        else
            v44 = u42.visual:ContainsWorldPosition(v43.Position);
        end;

        local feetInside = u42.feetInside;
        u42.feetInside = v44;
        u42.visual:SetBillboardEnabled(not v44);

        if v44 and not feetInside then
            if u42.amount <= 0 then
                return;
            end;

            u42.claimLock(function() -- Line: 130
                -- upvalues: u1 (ref), u42 (copy), Network (ref), OfflineAssets2 (ref), OfflineAssets (ref), CurrencyItem (ref), Money (ref), Item (ref), u3 (ref), u2 (ref), u4 (ref)
                u1 = {
                    ClaimableAmount = 0,
                    ReservedAmount = 0,
                    TotalAmount = 0,
                    IsMultiplierPurchasePending = false
                };
                u42.visual:PlayClaim();
                local v45, _, v46 = Network.Invoke(OfflineAssets2.REQUEST_REDEEM, {
                    Kind = "Claim"
                });

                if not OfflineAssets.OfflineRedeemResult(v46) then
                    v46 = nil;
                end;

                if v45 ~= true or v46 == nil then
                    u2 = u2 + 1;
                    local u47 = u2;
                    task.spawn(function() -- Line: 102
                        -- upvalues: Network (ref), OfflineAssets2 (ref), OfflineAssets (ref), u47 (copy), u2 (ref), u1 (ref), u4 (ref)
                        local v48 = Network.Invoke(OfflineAssets2.GET_SUMMARY);

                        if not OfflineAssets.OfflineClaimSummary(v48) then
                            v48 = nil;
                        end;

                        if u47 ~= u2 then
                            return;
                        end;

                        if v48 then
                            u1 = v48;
                        end;

                        u4.Sync();
                    end);

                    return;
                end;

                local AwardedAmount = v46.AwardedAmount;

                if AwardedAmount > 0 then
                    local v49 = CurrencyItem(Money):SetAmount((math.round(AwardedAmount)));
                    Item.Bottom({
                        Item = v49
                    });
                end;

                local v50 = u42;
                local v51 = u3;

                if v50 ~= nil and v51 ~= v50 then
                    return;
                end;

                u3 = nil;

                if v51 then
                    v51.trove:Destroy();
                end;
            end);
        end;
    end));

    return u41;
end;

local function tryInitialize() -- Line: 186
    -- upvalues: Save (copy), u2 (ref), Network (copy), OfflineAssets2 (copy), OfflineAssets (copy), u1 (ref), u4 (copy)
    if not Save.IsLocalDataLoaded() then
        return;
    end;

    u2 = u2 + 1;
    local u52 = u2;
    task.spawn(function() -- Line: 102
        -- upvalues: Network (ref), OfflineAssets2 (ref), OfflineAssets (ref), u52 (copy), u2 (ref), u1 (ref), u4 (ref)
        local v53 = Network.Invoke(OfflineAssets2.GET_SUMMARY);

        if not OfflineAssets.OfflineClaimSummary(v53) then
            v53 = nil;
        end;

        if u52 ~= u2 then
            return;
        end;

        if v53 then
            u1 = v53;
        end;

        u4.Sync();
    end);
    u4.Sync();
end;

function u4.Sync() -- Line: 199
    -- upvalues: Save (copy), u1 (ref), MIN_CLAIM_MONEY (copy), u3 (ref), AssetCmds (copy), LocalPlayer (copy), PlotCmds (copy), sessionFor (copy), Player (copy), Network (copy), OfflineAssets2 (copy), OfflineAssets (copy), CurrencyItem (copy), Money (copy), Item (copy), u2 (ref), u4 (copy)
    if not Save.IsLocalDataLoaded() then
        return;
    end;

    local v54 = u1;
    local v55 = not v54 and 0 or math.max(v54.TotalAmount, 0);
    local v56 = MIN_CLAIM_MONEY > v55 and 0 or v55;

    if v56 <= 0 then
        local v57 = u3;
        u3 = nil;

        if v57 then
            v57.trove:Destroy();
        end;

        return;
    end;

    local v58 = AssetCmds.ResolveAssetArea(LocalPlayer);

    if v58 == nil then
        local v59 = u3;
        u3 = nil;

        if v59 then
            v59.trove:Destroy();
        end;

        return;
    end;

    local v60 = PlotCmds.GetPlotData();
    local v61;

    if v60 then
        v61 = v60.PlotFolder;
    else
        v61 = workspace;
    end;

    local u62 = u3;

    if u62 == nil then
        local u63 = sessionFor(v56, v58, v61);
        u3 = u63;
        local v64 = Player.Optional.FeetCFrame(LocalPlayer);
        local v65;

        if v64 == nil then
            v65 = false;
        else
            v65 = u63.visual:ContainsWorldPosition(v64.Position);
        end;

        local feetInside = u63.feetInside;
        u63.feetInside = v65;
        u63.visual:SetBillboardEnabled(not v65);

        if v65 and not feetInside then
            if u63.amount <= 0 then
                return;
            end;

            u63.claimLock(function() -- Line: 130
                -- upvalues: u1 (ref), u63 (copy), Network (ref), OfflineAssets2 (ref), OfflineAssets (ref), CurrencyItem (ref), Money (ref), Item (ref), u3 (ref), u2 (ref), u4 (ref)
                u1 = {
                    ClaimableAmount = 0,
                    ReservedAmount = 0,
                    TotalAmount = 0,
                    IsMultiplierPurchasePending = false
                };
                u63.visual:PlayClaim();
                local v66, _, v67 = Network.Invoke(OfflineAssets2.REQUEST_REDEEM, {
                    Kind = "Claim"
                });

                if not OfflineAssets.OfflineRedeemResult(v67) then
                    v67 = nil;
                end;

                if v66 ~= true or v67 == nil then
                    u2 = u2 + 1;
                    local u68 = u2;
                    task.spawn(function() -- Line: 102
                        -- upvalues: Network (ref), OfflineAssets2 (ref), OfflineAssets (ref), u68 (copy), u2 (ref), u1 (ref), u4 (ref)
                        local v69 = Network.Invoke(OfflineAssets2.GET_SUMMARY);

                        if not OfflineAssets.OfflineClaimSummary(v69) then
                            v69 = nil;
                        end;

                        if u68 ~= u2 then
                            return;
                        end;

                        if v69 then
                            u1 = v69;
                        end;

                        u4.Sync();
                    end);

                    return;
                end;

                local AwardedAmount = v67.AwardedAmount;

                if AwardedAmount > 0 then
                    local v70 = CurrencyItem(Money):SetAmount((math.round(AwardedAmount)));
                    Item.Bottom({
                        Item = v70
                    });
                end;

                local v71 = u63;
                local v72 = u3;

                if v71 ~= nil and v72 ~= v71 then
                    return;
                end;

                u3 = nil;

                if v72 then
                    v72.trove:Destroy();
                end;
            end);
        end;

        return;
    end;

    u62.amount = v56;
    u62.visual:Update(v56, v58);
    local v73 = Player.Optional.FeetCFrame(LocalPlayer);
    local v74;

    if v73 == nil then
        v74 = false;
    else
        v74 = u62.visual:ContainsWorldPosition(v73.Position);
    end;

    local feetInside = u62.feetInside;
    u62.feetInside = v74;
    u62.visual:SetBillboardEnabled(not v74);

    if v74 and not feetInside then
        if u62.amount <= 0 then
            return;
        end;

        u62.claimLock(function() -- Line: 130
            -- upvalues: u1 (ref), u62 (copy), Network (ref), OfflineAssets2 (ref), OfflineAssets (ref), CurrencyItem (ref), Money (ref), Item (ref), u3 (ref), u2 (ref), u4 (ref)
            u1 = {
                ClaimableAmount = 0,
                ReservedAmount = 0,
                TotalAmount = 0,
                IsMultiplierPurchasePending = false
            };
            u62.visual:PlayClaim();
            local v75, _, v76 = Network.Invoke(OfflineAssets2.REQUEST_REDEEM, {
                Kind = "Claim"
            });

            if not OfflineAssets.OfflineRedeemResult(v76) then
                v76 = nil;
            end;

            if v75 ~= true or v76 == nil then
                u2 = u2 + 1;
                local u77 = u2;
                task.spawn(function() -- Line: 102
                    -- upvalues: Network (ref), OfflineAssets2 (ref), OfflineAssets (ref), u77 (copy), u2 (ref), u1 (ref), u4 (ref)
                    local v78 = Network.Invoke(OfflineAssets2.GET_SUMMARY);

                    if not OfflineAssets.OfflineClaimSummary(v78) then
                        v78 = nil;
                    end;

                    if u77 ~= u2 then
                        return;
                    end;

                    if v78 then
                        u1 = v78;
                    end;

                    u4.Sync();
                end);

                return;
            end;

            local AwardedAmount = v76.AwardedAmount;

            if AwardedAmount > 0 then
                local v79 = CurrencyItem(Money):SetAmount((math.round(AwardedAmount)));
                Item.Bottom({
                    Item = v79
                });
            end;

            local v80 = u62;
            local v81 = u3;

            if v80 ~= nil and v81 ~= v80 then
                return;
            end;

            u3 = nil;

            if v81 then
                v81.trove:Destroy();
            end;
        end);
    end;
end;

Network.Fired(OfflineAssets2.SUMMARY_UPDATED):Connect(function(p82) -- Line: 235
    -- upvalues: OfflineAssets (copy), u1 (ref), u4 (copy)
    if not OfflineAssets.OfflineClaimSummary(p82) then
        p82 = nil;
    end;

    if p82 then
        u1 = p82;
        u4.Sync();
    end;
end);
Network.Fired(OfflineAssets2.CLAIMED_EVENT):Connect(function(p83) -- Line: 243
    -- upvalues: OfflineAssets (copy), u3 (ref), u2 (ref), Network (copy), OfflineAssets2 (copy), u1 (ref), u4 (copy)
    if not OfflineAssets.OfflineRedeemResult(p83) then
        p83 = nil;
    end;

    if p83 then
        local v84 = u3;
        u3 = nil;

        if v84 then
            v84.trove:Destroy();
        end;

        u2 = u2 + 1;
        local u85 = u2;
        task.spawn(function() -- Line: 102
            -- upvalues: Network (ref), OfflineAssets2 (ref), OfflineAssets (ref), u85 (copy), u2 (ref), u1 (ref), u4 (ref)
            local v86 = Network.Invoke(OfflineAssets2.GET_SUMMARY);

            if not OfflineAssets.OfflineClaimSummary(v86) then
                v86 = nil;
            end;

            if u85 ~= u2 then
                return;
            end;

            if v86 then
                u1 = v86;
            end;

            u4.Sync();
        end);
    end;
end);
AssetCmds.AssetAreaAvailabilityChanged:Connect(function(p87) -- Line: 250
    -- upvalues: LocalPlayer (copy), u4 (copy)
    if p87 == LocalPlayer then
        u4.Sync();
    end;
end);
PlotCmds.OnLocalPlotUpdated:Connect(u4.Sync);
ActiveAssetsController.ItemAdded:Connect(requestSummary);
ActiveAssetsController.ItemRemoved:Connect(requestSummary);
ActiveAssetsController.CashCollected:Connect(requestSummary);
ActiveAssetsController.InitialLoadCompleted:Connect(tryInitialize);
Save.LoadedStats:Connect(tryInitialize);
task.defer(tryInitialize);