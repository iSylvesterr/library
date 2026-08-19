-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local ContentProvider = game:GetService("ContentProvider");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = {
    Changed = require(ReplicatedStorage.Library.Modules.Packages.Signal).new()
};
local u2 = {};
local u3 = {};
u1.Gamepad = {
    Xbox = {
        ButtonA = "rbxassetid://113824701684322",
        ButtonB = "rbxassetid://107100143818564",
        ButtonX = "rbxassetid://121994310218398",
        ButtonY = "rbxassetid://118121490246715",
        ButtonL1 = "rbxassetid://128016621986260",
        ButtonR1 = "rbxassetid://86739128961101",
        ButtonL2 = "rbxassetid://121095629027146",
        ButtonR2 = "rbxassetid://121138812911138",
        ButtonL3 = "rbxassetid://98426369439432",
        ButtonR3 = "rbxassetid://108823668376359",
        ButtonStart = "rbxassetid://121407964275535",
        ButtonSelect = "rbxassetid://73640706748399",
        Thumbstick1 = "rbxassetid://86234104961357",
        Thumbstick2 = "rbxassetid://92731666763608",
        DPadUp = "rbxassetid://110656716055777",
        DPadDown = "rbxassetid://134006970980101",
        DPadLeft = "rbxassetid://113523064631322",
        DPadRight = "rbxassetid://125621109562134"
    },
    PlayStation = {
        ButtonA = "rbxassetid://140688515494419",
        ButtonB = "rbxassetid://89979188218128",
        ButtonX = "rbxassetid://105740811198422",
        ButtonY = "rbxassetid://102844478766253",
        ButtonL1 = "rbxassetid://101741164721625",
        ButtonR1 = "rbxassetid://108359563054786",
        ButtonL2 = "rbxassetid://92051888341203",
        ButtonR2 = "rbxassetid://95486021989419",
        ButtonL3 = "rbxassetid://71736763291675",
        ButtonR3 = "rbxassetid://100766112822921",
        ButtonStart = "rbxassetid://115132567456286",
        ButtonSelect = "rbxassetid://74732078206933",
        Thumbstick1 = "rbxassetid://87994926804700",
        Thumbstick2 = "rbxassetid://123691072001381",
        DPadUp = "rbxassetid://77095582918408",
        DPadDown = "rbxassetid://101700700938948",
        DPadLeft = "rbxassetid://114773739810891",
        DPadRight = "rbxassetid://110011411664004"
    }
};
u1.Keyboard = {
    R = "",
    E = "",
    F = "",
    Space = "",
    LeftShift = ""
};
u1.Touch = {
    Attack = "",
    Special = ""
};
u1.Extra = {
    Xbox = {
        ShareCapture = "rbxassetid://93353054638688",
        DPadAll = "rbxassetid://121885467582670",
        DPadHorizontal = "rbxassetid://74718884209760",
        DPadVertical = "rbxassetid://100956788609636",
        LeftStick = "rbxassetid://92436717469939",
        RightStick = "rbxassetid://120679814305839",
        LeftStickUp = "rbxassetid://115866175692253",
        LeftStickDown = "rbxassetid://114312042334165",
        LeftStickLeft = "rbxassetid://88238512227687",
        LeftStickRight = "rbxassetid://79565855012457",
        LeftStickHorizontal = "rbxassetid://120062829910976",
        LeftStickVertical = "rbxassetid://128586254040326",
        RightStickUp = "rbxassetid://92580245385375",
        RightStickDown = "rbxassetid://100340039572871",
        RightStickLeft = "rbxassetid://73201142408320",
        RightStickRight = "rbxassetid://76538571758830",
        RightStickHorizontal = "rbxassetid://70730344732854",
        RightStickVertical = "rbxassetid://139548567338803"
    },
    PlayStation = {
        ShareCapture = "rbxassetid://126511668975757",
        DPadAll = "rbxassetid://131761777665181",
        DPadHorizontal = "rbxassetid://75094198411801",
        DPadVertical = "rbxassetid://94473192875427",
        LeftStick = "rbxassetid://116246546194282",
        RightStick = "rbxassetid://70569620453644",
        LeftStickUp = "rbxassetid://87066517609482",
        LeftStickDown = "rbxassetid://128457369956591",
        LeftStickLeft = "rbxassetid://131230488855381",
        LeftStickRight = "rbxassetid://88334041552020",
        LeftStickHorizontal = "rbxassetid://136876246579576",
        LeftStickVertical = "rbxassetid://93442095934997",
        RightStickUp = "rbxassetid://80620047965601",
        RightStickDown = "rbxassetid://115962328168799",
        RightStickLeft = "rbxassetid://120519735511599",
        RightStickRight = "rbxassetid://88816754369166",
        RightStickHorizontal = "rbxassetid://100110612304921",
        RightStickVertical = "rbxassetid://122029280577413",
        L3Directional = "rbxassetid://77400763955225",
        L3Up = "rbxassetid://121986343347935",
        L3Down = "rbxassetid://112092763559423",
        L3Left = "rbxassetid://75242882378394",
        L3Right = "rbxassetid://135742152142851",
        L3Horizontal = "rbxassetid://91288525216357",
        L3Vertical = "rbxassetid://79791315021008",
        R3Directional = "rbxassetid://77919097759838",
        R3Up = "rbxassetid://81089894541272",
        R3Down = "rbxassetid://98549847518053",
        R3Left = "rbxassetid://137203790357029",
        R3Right = "rbxassetid://136893045838418",
        R3Horizontal = "rbxassetid://95468073136065",
        R3Vertical = "rbxassetid://125541650204283",
        LeftStickClickAlt = "rbxassetid://115573208857062",
        RightStickClickAlt = "rbxassetid://88937633520054",
        RightStickClickAlt2 = "rbxassetid://104236276927248"
    }
};

function u1.KeyName(u4) -- Line: 189
    -- upvalues: UserInputService (copy)
    local success, result = pcall(function() -- Line: 190
        -- upvalues: UserInputService (ref), u4 (copy)
        return UserInputService:GetStringForKeyCode(u4);
    end);

    if success and (result and result ~= "") then
        return result;
    end;

    return nil;
end;

function u1.Platform() -- Line: 201
    -- upvalues: u1 (copy)
    return u1.KeyName(Enum.KeyCode.ButtonA) == "ButtonCross" and "PlayStation" or "Xbox";
end;

local u5 = {
    ButtonL1 = "LB",
    ButtonR1 = "RB",
    ButtonL2 = "LT",
    ButtonR2 = "RT",
    ButtonL3 = "LS",
    ButtonR3 = "RS"
};

function u1.Label(p6) -- Line: 223
    -- upvalues: u1 (copy), u5 (copy)
    local v7 = u1.KeyName(p6) or p6.Name;

    if u1.Platform() == "Xbox" and u5[v7] then
        return u5[v7];
    end;

    return v7:gsub("^Button", "");
end;

local function normalise(p8) -- Line: 231
    if not p8 or p8 == "" then
        return nil;
    end;

    if tonumber(p8) then
        return `rbxassetid://{p8}`;
    end;

    return p8;
end;

local function ensureVerified(u9) -- Line: 239
    -- upvalues: u2 (copy), u3 (copy), ContentProvider (copy), u1 (copy)
    if u2[u9] ~= nil or u3[u9] then
        return;
    end;

    u3[u9] = true;
    task.spawn(function() -- Line: 245
        -- upvalues: u9 (copy), ContentProvider (ref), u3 (ref), u2 (ref), u1 (ref)
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Image = u9;
        local u10 = false;
        local success = pcall(function() -- Line: 250
            -- upvalues: ContentProvider (ref), ImageLabel (copy), u10 (ref)
            ContentProvider:PreloadAsync({ ImageLabel }, function(p11, p12) -- Line: 251
                -- upvalues: u10 (ref)
                u10 = p12 == Enum.AssetFetchStatus.Success;
            end);
        end);
        ImageLabel:Destroy();
        u3[u9] = nil;
        u2[u9] = success and u10;

        if not u2[u9] then
            warn((`[InputIconsConfig] {u9} is not accessible to this experience; using the built-in glyph instead`));
            u1.Changed:Fire();
        end;
    end);
end;

local function accessible(u13) -- Line: 267
    -- upvalues: u2 (copy), u3 (copy), ContentProvider (copy), u1 (copy)
    if u13 == nil then
        return nil;
    end;

    if u2[u13] == nil and not u3[u13] then
        u3[u13] = true;
        task.spawn(function() -- Line: 245
            -- upvalues: u13 (copy), ContentProvider (ref), u3 (ref), u2 (ref), u1 (ref)
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Image = u13;
            local u14 = false;
            local success = pcall(function() -- Line: 250
                -- upvalues: ContentProvider (ref), ImageLabel (copy), u14 (ref)
                ContentProvider:PreloadAsync({ ImageLabel }, function(p15, p16) -- Line: 251
                    -- upvalues: u14 (ref)
                    u14 = p16 == Enum.AssetFetchStatus.Success;
                end);
            end);
            ImageLabel:Destroy();
            u3[u13] = nil;
            u2[u13] = success and u14;

            if not u2[u13] then
                warn((`[InputIconsConfig] {u13} is not accessible to this experience; using the built-in glyph instead`));
                u1.Changed:Fire();
            end;
        end);
    end;

    if u2[u13] == false then
        return nil;
    end;

    return u13;
end;

function u1.CustomImage(p17) -- Line: 281
    -- upvalues: u1 (copy), u2 (copy), u3 (copy), ContentProvider (copy)
    local u18 = u1.Gamepad[u1.Platform()];

    if u18 then
        u18 = u18[p17.Name];
    end;

    if u18 and u18 ~= "" then
        if u18 and u18 ~= "" then
            if tonumber(u18) then
                u18 = `rbxassetid://{u18}`;
            end;
        else
            u18 = nil;
        end;

        if u18 == nil then
            return nil;
        end;

        if u2[u18] == nil and not u3[u18] then
            u3[u18] = true;
            task.spawn(function() -- Line: 245
                -- upvalues: u18 (copy), ContentProvider (ref), u3 (ref), u2 (ref), u1 (ref)
                local ImageLabel = Instance.new("ImageLabel");
                ImageLabel.Image = u18;
                local u19 = false;
                local success = pcall(function() -- Line: 250
                    -- upvalues: ContentProvider (ref), ImageLabel (copy), u19 (ref)
                    ContentProvider:PreloadAsync({ ImageLabel }, function(p20, p21) -- Line: 251
                        -- upvalues: u19 (ref)
                        u19 = p21 == Enum.AssetFetchStatus.Success;
                    end);
                end);
                ImageLabel:Destroy();
                u3[u18] = nil;
                u2[u18] = success and u19;

                if not u2[u18] then
                    warn((`[InputIconsConfig] {u18} is not accessible to this experience; using the built-in glyph instead`));
                    u1.Changed:Fire();
                end;
            end);
        end;

        if u2[u18] == false then
            return nil;
        end;

        return u18;
    end;

    local v22 = u1.KeyName(p17);
    local u23 = v22 and u1.Keyboard[v22] or u1.Keyboard[p17.Name];

    if u23 and u23 ~= "" then
        if tonumber(u23) then
            u23 = `rbxassetid://{u23}`;
        end;
    else
        u23 = nil;
    end;

    if u23 == nil then
        return nil;
    end;

    if u2[u23] == nil and not u3[u23] then
        u3[u23] = true;
        task.spawn(function() -- Line: 245
            -- upvalues: u23 (copy), ContentProvider (ref), u3 (ref), u2 (ref), u1 (ref)
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Image = u23;
            local u24 = false;
            local success = pcall(function() -- Line: 250
                -- upvalues: ContentProvider (ref), ImageLabel (copy), u24 (ref)
                ContentProvider:PreloadAsync({ ImageLabel }, function(p25, p26) -- Line: 251
                    -- upvalues: u24 (ref)
                    u24 = p26 == Enum.AssetFetchStatus.Success;
                end);
            end);
            ImageLabel:Destroy();
            u3[u23] = nil;
            u2[u23] = success and u24;

            if not u2[u23] then
                warn((`[InputIconsConfig] {u23} is not accessible to this experience; using the built-in glyph instead`));
                u1.Changed:Fire();
            end;
        end);
    end;

    if u2[u23] == false then
        return nil;
    end;

    return u23;
end;

function u1.Image(u27) -- Line: 299
    -- upvalues: u1 (copy), UserInputService (copy)
    local v28 = u1.CustomImage(u27);

    if v28 then
        return v28;
    end;

    local success, result = pcall(function() -- Line: 305
        -- upvalues: UserInputService (ref), u27 (copy)
        return UserInputService:GetImageForKeyCode(u27);
    end);

    if success and (result and result ~= "") then
        return result;
    end;

    return nil;
end;

function u1.TouchImage(p29) -- Line: 312
    -- upvalues: u1 (copy), u2 (copy), u3 (copy), ContentProvider (copy)
    local u30 = u1.Touch[p29];

    if u30 and u30 ~= "" then
        if tonumber(u30) then
            u30 = `rbxassetid://{u30}`;
        end;
    else
        u30 = nil;
    end;

    if u30 == nil then
        return nil;
    end;

    if u2[u30] == nil and not u3[u30] then
        u3[u30] = true;
        task.spawn(function() -- Line: 245
            -- upvalues: u30 (copy), ContentProvider (ref), u3 (ref), u2 (ref), u1 (ref)
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Image = u30;
            local u31 = false;
            local success = pcall(function() -- Line: 250
                -- upvalues: ContentProvider (ref), ImageLabel (copy), u31 (ref)
                ContentProvider:PreloadAsync({ ImageLabel }, function(p32, p33) -- Line: 251
                    -- upvalues: u31 (ref)
                    u31 = p33 == Enum.AssetFetchStatus.Success;
                end);
            end);
            ImageLabel:Destroy();
            u3[u30] = nil;
            u2[u30] = success and u31;

            if not u2[u30] then
                warn((`[InputIconsConfig] {u30} is not accessible to this experience; using the built-in glyph instead`));
                u1.Changed:Fire();
            end;
        end);
    end;

    if u2[u30] == false then
        return nil;
    end;

    return u30;
end;

function u1.ExtraImage(p34) -- Line: 317
    -- upvalues: u1 (copy), u2 (copy), u3 (copy), ContentProvider (copy)
    local u35 = u1.Extra[u1.Platform()];

    if u35 then
        u35 = u35[p34];
    end;

    if u35 and u35 ~= "" then
        if tonumber(u35) then
            u35 = `rbxassetid://{u35}`;
        end;
    else
        u35 = nil;
    end;

    if u35 == nil then
        return nil;
    end;

    if u2[u35] == nil and not u3[u35] then
        u3[u35] = true;
        task.spawn(function() -- Line: 245
            -- upvalues: u35 (copy), ContentProvider (ref), u3 (ref), u2 (ref), u1 (ref)
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Image = u35;
            local u36 = false;
            local success = pcall(function() -- Line: 250
                -- upvalues: ContentProvider (ref), ImageLabel (copy), u36 (ref)
                ContentProvider:PreloadAsync({ ImageLabel }, function(p37, p38) -- Line: 251
                    -- upvalues: u36 (ref)
                    u36 = p38 == Enum.AssetFetchStatus.Success;
                end);
            end);
            ImageLabel:Destroy();
            u3[u35] = nil;
            u2[u35] = success and u36;

            if not u2[u35] then
                warn((`[InputIconsConfig] {u35} is not accessible to this experience; using the built-in glyph instead`));
                u1.Changed:Fire();
            end;
        end);
    end;

    if u2[u35] == false then
        return nil;
    end;

    return u35;
end;

return u1;