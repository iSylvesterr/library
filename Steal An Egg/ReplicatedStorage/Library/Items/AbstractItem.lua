-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {};
local u3 = {};
local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Types = Library:WaitForChild("Types");
local Modules = Library:WaitForChild("Modules");
local Functions = Library:WaitForChild("Functions");
local Asserts = require(Library.Asserts);
local Items = require(Types.Items);
local Event = require(Modules.Event);
local DeepCopyUnsafe = require(Functions.DeepCopyUnsafe);
local DeepFreezeUnsafe = require(Functions.DeepFreezeUnsafe);
local SHA256 = require(Functions.SHA256);
local BinaryToInt = require(Functions.BinaryToInt);
local JSON = require(Functions.JSON);
local FastJSON = require(Functions.FastJSON);
local CRC32 = require(Functions.CRC32);
local BinaryToUUIDv4 = require(Functions.BinaryToUUIDv4);
local DeepEqualsUnsafe = require(Functions.DeepEqualsUnsafe);
local Order = require(script.Parent.Order);
require(ReplicatedStorage.Library.Util.ItemUtil.Types.Interface);
u1.TrackingEnabled = true;
u1.AmountLimit = 1000000000000000;
u1.StackLimit = 1000000000000000;
u1.TypeStackLimit = 1000000000000000;
u1.LockingEnabled = true;
u1.TradingEnabled = true;
u1.CreationTimeEnabled = true;
u1.CreationUserEnabled = true;
u1.OwnerCountEnabled = true;
u1.OwnerLogEnabled = true;
u1.OwnerLogLimit = 6;
u1.NicknameEnabled = true;
u1.NicknameLimit = 16;
u1.SignedByEnabled = true;

local function AbstractPatch(p4) -- Line: 127
    error("unimplemented");
end;

u1.Patch = AbstractPatch;
u3.Class = {
    Abstract = true,
    Name = "",
    Script = script,
    Module = u3
};
u3.Globals = u2;
u3.Prototype = u1;
setmetatable(u3, {
    __index = u2,

    __call = function(...) -- Line: 162, Name: __call
        error("NOP");
    end
});

function u3.Define(p5, p6, p7) -- Line: 170
    -- upvalues: u2 (copy), Event (copy)
    local v8 = type(p7) == "table";
    assert(v8, "Module must be a table");
    local v9 = {
        Abstract = false,
        Name = p5,
        Script = p6,
        Module = p7
    };

    for i, v in pairs(u2) do
        if Event.IsA(v) then
            p7[i] = Event.new();
        end;
    end;

    return v9, u2;
end;

function u1.Clone(p10) -- Line: 190
    -- upvalues: DeepCopyUnsafe (copy)
    local v11 = {
        _uid = p10._uid,
        _data = DeepCopyUnsafe(p10._data),
        _tracked = p10._tracked,
        _silent = p10._silent,
        _spawned = p10._spawned,
        _tag = p10._tag,
        _traceback = p10._traceback,
        _exchangeBlacklisted = p10._exchangeBlacklisted,
        _deleted = p10._deleted
    };
    local v12 = getmetatable(p10);

    return setmetatable(v11, v12);
end;

function u1.IsA(p13, p14) -- Line: 207
    return p13.Class.Name == p14;
end;

function u1.IsFrozen(p15) -- Line: 211
    return table.isfrozen(p15);
end;

function u1.Freeze(p16) -- Line: 215
    -- upvalues: DeepFreezeUnsafe (copy)
    if not table.isfrozen(p16) then
        if p16._stackKey == nil then
            p16._stackKey = p16:StackKey();
        end;

        if p16._exactStackKey == nil then
            p16._exactStackKey = p16:ExactStackKey();
        end;

        if p16._maxAmount == nil then
            p16._maxAmount = p16:GetMaxAmount();
        end;

        p16:AbstractFreeze();
        DeepFreezeUnsafe(p16);
    end;

    return p16;
end;

function u1.AbstractFreeze(p17) -- Line: 232
end;

function u1.IsTracked(p18) -- Line: 234
    return p18._tracked;
end;

function u1.SetTracked(p19, p20) -- Line: 238
    -- upvalues: Asserts (copy)
    Asserts.optional.boolean(p20);
    p19._tracked = p20;

    return p19;
end;

function u1.IsSilent(p21) -- Line: 244
    return p21._silent;
end;

function u1.SetSilent(p22, p23) -- Line: 248
    -- upvalues: Asserts (copy)
    Asserts.optional.boolean(p23);
    p22._silent = p23;

    return p22;
end;

function u1.IsSpawned(p24) -- Line: 254
    return p24._spawned == true;
end;

function u1.SetSpawned(p25, p26) -- Line: 258
    -- upvalues: Asserts (copy)
    Asserts.optional.boolean(p26);

    if p26 == true then
        p25._spawned = true;

        return p25;
    end;

    p25._spawned = nil;

    return p25;
end;

function u1.Tag(p27, p28) -- Line: 269
    -- upvalues: Asserts (copy)
    Asserts.optional.string(p28);
    p27._tag = p28;

    return p27;
end;

function u1.GetTag(p29) -- Line: 275
    return p29._tag;
end;

function u1.SetTraceback(p30, p31) -- Line: 279
    -- upvalues: Asserts (copy)
    Asserts.optional.string(p31);
    p30._traceback = p31;

    return p30;
end;

function u1.GetTraceback(p32) -- Line: 285
    return p32._traceback;
end;

function u1.IsExchangeBlacklisted(p33) -- Line: 289
    return p33._exchangeBlacklisted == true;
end;

function u1.SetExchangeBlacklisted(p34, p35) -- Line: 293
    -- upvalues: Asserts (copy)
    Asserts.optional.boolean(p35);

    if p35 == true then
        p34._exchangeBlacklisted = true;

        return p34;
    end;

    p34._exchangeBlacklisted = nil;

    return p34;
end;

function u1.SetDeleted(p36, p37) -- Line: 304
    -- upvalues: Asserts (copy)
    Asserts.boolean(p37);

    if p37 == true then
        p36._deleted = true;

        return p36;
    end;

    p36._deleted = nil;

    return p36;
end;

function u1.MarkDeleted(p38) -- Line: 315
    p38._deleted = true;

    return p38;
end;

function u1.IsDeleted(p39) -- Line: 320
    return p39._deleted == true;
end;

function u1.GetUID(p40) -- Line: 324
    local _uid = p40._uid;
    assert(_uid, "UID is not set for this item");

    return _uid;
end;

function u1.GetOptionalUID(p41) -- Line: 330
    return p41._uid;
end;

function u1.SetUID(p42, p43) -- Line: 334
    -- upvalues: u3 (copy)
    u3.AssertOptionalUIDFast(p43);
    p42._uid = p43;

    return p42;
end;

function u1.StripUID(p44) -- Line: 340
    p44._uid = nil;

    return p44;
end;

function u1.PopulateUID(p45) -- Line: 345
    -- upvalues: u3 (copy)
    if p45._uid then
        return false;
    end;

    p45._uid = u3.GenerateUID();

    return true;
end;

function u1.CreateSeed(p46, p47) -- Line: 354
    -- upvalues: CRC32 (copy)
    local v48;

    if type(p47) == "string" then
        v48 = #p47 > 0;
    else
        v48 = false;
    end;

    assert(v48, "Invalid seed provided to CreateSeed");

    return CRC32(`Seed/{p46:GetUID()}/{p47}`);
end;

function u1.CreateRandom(p49, p50) -- Line: 363
    return Random.new(p49:CreateSeed(p50));
end;

function u1.CreateSecureSeed(p51, p52) -- Line: 367
    -- upvalues: BinaryToInt (copy), SHA256 (copy), u3 (copy)
    local v53;

    if type(p52) == "string" then
        v53 = #p52 > 0;
    else
        v53 = false;
    end;

    assert(v53, "Invalid seed provided to CreateSecureSeed");

    return BinaryToInt(SHA256(`{u3.HashedSalt()}{SHA256(`Seed/{p51:GetUID()}/{p52}`)}`):sub(1, 4));
end;

function u1.CreateSecureRandom(p54, p55) -- Line: 378
    -- upvalues: u1 (copy)
    return Random.new(u1.CreateSecureSeed(p54, p55));
end;

function u1.GenerateSecureUID(p56, p57) -- Line: 382
    -- upvalues: BinaryToUUIDv4 (copy), SHA256 (copy), u3 (copy)
    local v58;

    if type(p57) == "string" then
        v58 = #p57 > 0;
    else
        v58 = false;
    end;

    assert(v58, "Invalid seed provided to GenerateSecureUID");

    return BinaryToUUIDv4(SHA256(`{u3.HashedSalt()}{SHA256(`UID/{p56:GetUID()}/{p57}`)}`));
end;

function u1.GetData(p59) -- Line: 393
    return p59._data;
end;

function u1.SetData(p60, p61) -- Line: 397
    -- upvalues: Asserts (copy)
    Asserts.table(p61);
    p60._data = p61;

    return p60;
end;

function u1.ToString(p62) -- Line: 403
    -- upvalues: JSON (copy)
    return JSON.stringify({
        class = p62.Class.Name,
        uid = p62:GetOptionalUID(),
        data = p62:GetData()
    });
end;

function u1.CompareTo(p63, p64) -- Line: 411
    -- upvalues: Asserts (copy), u1 (copy), Order (copy)
    if p63 == p64 then
        return 0;
    end;

    Asserts.table(p64);
    assert(p64.GetData == u1.GetData, "Other item does not implement GetData correctly");
    local Class = p63.Class;
    local Class2 = p64.Class;

    if Class ~= Class2 then
        local v65 = p63:IsTradableRaw();

        if v65 ~= p64:IsTradableRaw() then
            return v65 and -1 or 1;
        end;

        local v66 = p63:GetRarity();
        local v67 = p64:GetRarity();

        if v66 == v67 then
            return (Order.Order[Class.Name] or (1 / 0)) - (Order.Order[Class2.Name] or (1 / 0));
        end;

        return v67.RarityNumber - v66.RarityNumber;
    end;

    local v68 = p63:AbstractCompareTo(p64);

    if v68 ~= 0 then
        return v68;
    end;

    local v69 = p63:IsTradableRaw();

    if v69 ~= p64:IsTradableRaw() then
        return v69 and -1 or 1;
    end;

    local v70 = p63:GetRarity();
    local v71 = p64:GetRarity();

    if v70 ~= v71 then
        return v71.RarityNumber - v70.RarityNumber;
    end;

    local v72 = p64:GetTier() - p63:GetTier();

    if v72 ~= 0 then
        return v72;
    end;

    local v73 = p63:GetId();
    local v74 = p64:GetId();

    if v73 ~= v74 then
        local v75 = p63:GetName();
        local v76 = p64:GetName();

        return v75 == v76 and (v73 < v74 and -1 or 1) or (v75 < v76 and -1 or 1);
    end;

    local v77 = p63:IsLocked();

    if v77 ~= p64:IsLocked() then
        return v77 and -1 or 1;
    end;

    local v78 = p63:IsUnique();

    if v78 ~= p64:IsUnique() then
        return v78 and -1 or 1;
    end;

    local v79 = p64:GetAmount() - p63:GetAmount();

    if v79 ~= 0 then
        return v79;
    end;

    local v80 = p63:GetSignedBy();
    local v81 = p64:GetSignedBy();

    if v80 ~= v81 then
        return not (v80 and v81) and (v80 and -1 or 1) or v80 - v81;
    end;

    local v82 = p63:GetNickname();
    local v83 = p64:GetNickname();

    if v82 and v83 then
        if v82 < v83 then
            return -1;
        end;

        if v83 < v82 then
            return 1;
        end;
    else
        if v82 then
            return -1;
        end;

        if v83 then
            return 1;
        end;
    end;

    local v84 = p63:GetCreationTime();
    local v85 = p64:GetCreationTime();

    if v84 ~= v85 then
        return not (v84 and v85) and (v84 and -1 or 1) or v85 - v84;
    end;

    local v86 = p63:GetOwnerCount();
    local v87 = p64:GetOwnerCount();

    if v86 ~= v87 then
        return not (v86 and v87) and (v86 and -1 or 1) or v86 - v87;
    end;

    local v88 = p63:GetOptionalUID();
    local v89 = p64:GetOptionalUID();

    if v88 and v89 then
        if v88 < v89 then
            return -1;
        end;

        if v89 < v88 then
            return 1;
        end;
    else
        if v88 then
            return -1;
        end;

        if v89 then
            return 1;
        end;
    end;

    return 0;
end;

function u1.AbstractCompareTo(p90, p91) -- Line: 551
    return 0;
end;

function u1.GetNetworkPacket(p92) -- Line: 556
    return {
        class = p92.Class.Name,
        uid = p92:GetOptionalUID(),
        data = p92:GetData()
    };
end;

function u1.ModifyUnique(p93, p94) -- Line: 564
    local v95 = p93._data._uq or {};
    p94(v95);

    if not next(v95) then
        p93._data._uq = nil;

        return;
    end;

    local v96 = p93:GetAmount() == 1;
    assert(v96, "Item amount must be 1 when unique data is present");
    p93._data._uq = v95;
end;

function u1.IsForcedUnique(p97) -- Line: 577
    local _uq = p97._data._uq;

    return _uq and _uq._fu or false;
end;

function u1.SetForcedUnique(p98, u99) -- Line: 582
    p98:ModifyUnique(function(p100) -- Line: 583
        -- upvalues: u99 (copy)
        p100._fu = u99;
    end);

    return p98;
end;

function u1.IsUnique(p101) -- Line: 589
    return p101._data._uq ~= nil;
end;

function u1.GetMaxAmount(p102) -- Line: 593
    return p102._maxAmount or (p102._data._uq and 1 or (p102:AbstractGetMaxAmount() or p102.AmountLimit));
end;

function u1.AbstractGetMaxAmount(p103) -- Line: 609
    return p103.AmountLimit;
end;

function u1.IsStackable(p104) -- Line: 613
    return p104:GetMaxAmount() > 1;
end;

function u1.CanClearUnique(p105) -- Line: 617
    -- upvalues: Items (copy)
    if p105:IsForcedUnique() then
        return false;
    end;

    if (p105:AbstractGetMaxAmount() or p105.AmountLimit) <= 1 then
        return false;
    end;

    local v106 = p105:AbstractCanClearUnique();

    if v106 ~= nil then
        return v106;
    end;

    local v107 = false;
    local _uq = p105._data._uq;

    if _uq then
        for i, _ in pairs(_uq) do
            if not Items.PointlessUniques[i] then
                v107 = true;
                break;
            end;
        end;

        if v107 then
            return false;
        end;
    end;

    return true;
end;

function u1.AbstractCanClearUnique(p108) -- Line: 645
    return nil;
end;

function u1.ClearUnique(p109) -- Line: 649
    if not p109._data._uq then
        return false;
    end;

    if not p109:CanClearUnique() then
        return false;
    end;

    p109._data._uq = nil;

    return true;
end;

function u1.GetAmount(p110) -- Line: 660
    return p110._data._am or 1;
end;

function u1.SetAmount(p111, p112) -- Line: 664
    -- upvalues: Asserts (copy)
    Asserts.positiveInteger(p112);
    local v113 = p112 <= p111:GetMaxAmount();
    assert(v113, "Amount exceeds maximum allowed");

    if p112 == 1 or not p112 then
        p112 = nil;
    end;

    p111._data._am = p112;

    return p111;
end;

function u1.Populate(p114, p115, p116, p117) -- Line: 671
    p114:AbstractPopulate(p115);

    if not p114:IsStackable() then
        local v118 = nil;

        if p116 or p117 then
            if p115 and (not p114:GetCreationUser() and p114.CreationUserEnabled) then
                p114:SetCreationUser(p115.UserId);
            end;

            if not p114:GetCreationTime() and p114.CreationTimeEnabled then
                if not v118 then
                    local v119 = workspace:GetServerTimeNow();
                    v118 = math.floor(v119);
                end;

                p114:SetCreationTime(v118);
            end;
        end;

        if p115 and p114.OwnerLogEnabled then
            p114:AddOwnerLog(p115.UserId, v118);
        end;
    end;

    p114:ClearUnique();

    return p114;
end;

function u1.AbstractPopulate(p120, p121) -- Line: 694
end;

function u1.IsLocked(p122) -- Line: 698
    return p122._data._lk == true;
end;

function u1.SetLocked(p123, p124) -- Line: 702
    local v125 = type(p124) == "boolean";
    assert(v125, "Locked must be a boolean");
    assert(not p124 or p123.LockingEnabled, "Locking is disabled for this item");
    p123._data._lk = p124 and true or nil;

    return p123;
end;

function u1.GetTradableOverride(p126) -- Line: 709
    return p126._data._to;
end;

function u1.SetTradableOverride(p127, p128) -- Line: 713
    p127._data._to = p128;

    return p127;
end;

function u1.AbstractIsRAPVisible(p129) -- Line: 718
    return nil;
end;

function u1.IsRAPVisible(p130) -- Line: 722
    local v131 = p130:AbstractIsRAPVisible();

    if v131 == nil then
        return p130:IsTradableRaw() and true or false;
    end;

    return v131;
end;

function u1.AbstractIsTradable(p132) -- Line: 733
    return nil;
end;

function u1.IsTradable(p133) -- Line: 737
    if p133:IsLocked() then
        return false;
    end;

    return p133:IsTradableRaw();
end;

function u1.IsTradableRaw(p134) -- Line: 745
    local v135 = p134:GetTradableOverride();

    if v135 ~= nil then
        return v135;
    end;

    local v136 = p134:AbstractIsTradable();

    if v136 == nil then
        return p134.TradingEnabled;
    end;

    return v136;
end;

function u1.GetCreationTime(p137) -- Line: 759
    local _uq = p137._data._uq;

    if _uq then
        _uq = _uq._ct;
    end;

    return _uq;
end;

function u1.SetCreationTime(p138, u139) -- Line: 764
    -- upvalues: Asserts (copy)
    Asserts.optional.integer(u139);
    assert(not u139 or p138.CreationTimeEnabled, "CreationTime is not enabled for this item");
    p138:ModifyUnique(function(p140) -- Line: 767
        -- upvalues: u139 (copy)
        p140._ct = u139;
    end);

    return p138;
end;

function u1.GetCreationUser(p141) -- Line: 773
    local _uq = p141._data._uq;

    if _uq then
        _uq = _uq._cu;
    end;

    return _uq;
end;

function u1.SetCreationUser(p142, u143) -- Line: 778
    -- upvalues: Asserts (copy)
    Asserts.optional.integer(u143);
    assert(not u143 or p142.CreationUserEnabled, "CreationUser is not enabled for this item");
    p142:ModifyUnique(function(p144) -- Line: 781
        -- upvalues: u143 (copy)
        p144._cu = u143;
    end);

    return p142;
end;

function u1.GetOwnerCount(p145) -- Line: 787
    local _uq = p145._data._uq;

    if _uq then
        _uq = _uq._oc;
    end;

    return _uq;
end;

function u1.SetOwnerCount(p146, u147) -- Line: 792
    -- upvalues: Asserts (copy)
    Asserts.optional.nonNegativeInteger(u147);
    assert(u147 == nil and true or p146.OwnerCountEnabled, "OwnerCount is not enabled for this item");
    p146:ModifyUnique(function(p148) -- Line: 799
        -- upvalues: u147 (copy)
        p148._oc = u147;
    end);

    return p146;
end;

function u1.GetOwnerLog(p149) -- Line: 805
    local _uq = p149._data._uq;

    return _uq and _uq._ol or {};
end;

function u1.SetOwnerLog(p150, u151) -- Line: 810
    -- upvalues: Asserts (copy)
    if u151 ~= nil then
        local v152 = 0;
        local v153 = {};

        for i, v in ipairs(u151) do
            v152 = v152 + 1;
            assert(i == v152, "OwnerLog index mismatch at entry " .. i);
            local v154 = type(v) == "table";
            assert(v154, "OwnerLog entry at index " .. i .. " is not a table");
            assert(#v == 2, "OwnerLog entry at index " .. i .. " must have exactly 2 elements");
            local v155 = v[1];
            local v156 = v[2];
            Asserts.integer(v155);
            Asserts.integer(v156);
            table.insert(v153, { v155, v156 });
        end;

        u151 = #v153 > 0 and v153 and v153 or nil;
    end;

    assert(not u151 or p150.OwnerLogEnabled, "OwnerLog is not enabled for this item");
    p150:ModifyUnique(function(p157) -- Line: 830
        -- upvalues: u151 (ref)
        p157._ol = u151;
    end);

    return p150;
end;

function u1.AddOwnerLog(u158, u159, u160) -- Line: 836
    -- upvalues: Asserts (copy)
    Asserts.integer(u159);
    Asserts.optional.integer(u160);
    assert(u158.OwnerLogEnabled, "OwnerLog is not enabled for this item");
    u158:ModifyUnique(function(p161) -- Line: 840
        -- upvalues: u159 (copy), u160 (copy), u158 (copy)
        local _ol = p161._ol;

        if not _ol then
            _ol = {};
            p161._ol = _ol;
        end;

        assert(_ol, "Expected ownerLog to be non-nil");

        if #_ol <= 0 or _ol[1][1] ~= u159 then
            p161._oc = (p161._oc or 0) + 1;
            local v162 = {};
            local v163 = u160;

            if not v163 then
                local v164 = workspace:GetServerTimeNow();
                v163 = math.floor(v164);
            end;

            v162[1], v162[2] = u159, v163;
            table.insert(_ol, 1, v162);
        end;

        while u158.OwnerLogLimit < #_ol do
            table.remove(_ol, #_ol);
        end;
    end);

    return u158;
end;

function u1.GetNickname(p165) -- Line: 862
    local _uq = p165._data._uq;

    if _uq then
        _uq = _uq._nk;
    end;

    return _uq;
end;

function u1.SetNickname(p166, u167) -- Line: 867
    -- upvalues: Asserts (copy)
    if u167 ~= nil then
        assert(#u167 > 0, "Nickname must not be empty");
        assert(#u167 <= p166.NicknameLimit, "Nickname exceeds maximum length");
        Asserts.ascii(u167);
    end;

    assert(not u167 or p166.NicknameEnabled, "Nickname is not enabled for this item");
    p166:ModifyUnique(function(p168) -- Line: 874
        -- upvalues: u167 (copy)
        p168._nk = u167;
    end);

    return p166;
end;

function u1.GetSignedBy(p169) -- Line: 880
    local _uq = p169._data._uq;

    if _uq then
        _uq = _uq._sb;
    end;

    return _uq;
end;

function u1.SetSignedBy(p170, u171) -- Line: 885
    -- upvalues: Asserts (copy)
    Asserts.optional.integer(u171);
    assert(not u171 or p170.SignedByEnabled, "SignedBy is not enabled for this item");
    p170:ModifyUnique(function(p172) -- Line: 888
        -- upvalues: u171 (copy)
        p172._sb = u171;
    end);

    return p170;
end;

function u1.GetPurchaseData(p173) -- Line: 894
    local _uq = p173._data._uq;

    if _uq then
        _uq = _uq._pd;
    end;

    return _uq;
end;

function u1.SetPurchaseData(p174, p175) -- Line: 899
    -- upvalues: Asserts (copy), DeepEqualsUnsafe (copy)
    local u176;

    if p175 == nil then
        u176 = p175;
    else
        local v177 = type(p175) == "table";
        assert(v177, "Purchase data must be a table");
        local v178 = type(p175.pu) == "string";
        assert(v178, "Purchase id must be a string");
        assert(#p175.pu == 32, "Purchase id must be 32 characters long");
        local v179 = p175.pu:find("^[0-9a-f]+$");
        assert(v179, "Purchase id must be in hexadecimal format");
        Asserts.integer(p175.us);
        Asserts.integer(p175.pr);
        Asserts.integer(p175.pi);
        Asserts.integer(p175.cs);
        Asserts.integer(p175.ts);
        u176 = {
            pu = p175.pu,
            us = p175.us,
            pr = p175.pr,
            pi = p175.pi,
            cs = p175.cs,
            ts = p175.ts
        };
        local v180 = DeepEqualsUnsafe(u176, p175);
        assert(v180, "Purchase data does not match expected structure");
        table.freeze(u176);
    end;

    p174:ModifyUnique(function(p181) -- Line: 924
        -- upvalues: u176 (ref)
        p181._pd = u176;
    end);

    return p174;
end;

function u1.GetMerchData(p182) -- Line: 930
    local _uq = p182._data._uq;

    if _uq then
        _uq = _uq._md;
    end;

    return _uq;
end;

function u1.SetMerchData(p183, p184) -- Line: 935
    -- upvalues: Asserts (copy), DeepEqualsUnsafe (copy)
    local u185;

    if p184 == nil then
        u185 = p184;
    else
        Asserts.table(p184);
        Asserts.ascii(p184.cd);
        assert(#p184.cd <= 100, "Merch data code must not exceed the limit.");
        Asserts.optional.integer(p184.us);
        Asserts.optional.nonNegativeInteger(p184.sr);

        if p184.sk ~= nil then
            Asserts.ascii(p184.sk);
            assert(#p184.sk <= 100, "Merch data sk field must not exceed 100 characters");
        end;

        Asserts.optional.boolean(p184.pi);
        u185 = {
            cd = p184.cd,
            us = p184.us,
            sr = p184.sr,
            sk = p184.sk,
            pi = p184.pi
        };
        local v186 = DeepEqualsUnsafe(u185, p184);
        assert(v186, "Merch data does not match expected structure");
        table.freeze(u185);
    end;

    p183:ModifyUnique(function(p187) -- Line: 961
        -- upvalues: u185 (ref)
        p187._md = u185;
    end);

    return p183;
end;

function u1.GetSerialData(p188) -- Line: 967
    local _uq = p188._data._uq;

    if _uq then
        _uq = _uq._sd;
    end;

    return _uq;
end;

function u1.SetSerialData(p189, p190) -- Line: 972
    -- upvalues: Asserts (copy), DeepEqualsUnsafe (copy)
    local u191;

    if p190 == nil then
        u191 = p190;
    else
        local v192 = type(p190) == "table";
        assert(v192, "Serial data must be a table");
        Asserts.integer(p190.us);
        Asserts.nonNegativeInteger(p190.sr);
        u191 = {
            us = p190.us,
            sr = p190.sr
        };
        local v193 = DeepEqualsUnsafe(u191, p190);
        assert(v193, "Serial data does not match expected structure");
        table.freeze(u191);
    end;

    p189:ModifyUnique(function(p194) -- Line: 985
        -- upvalues: u191 (ref)
        p194._sd = u191;
    end);

    return p189;
end;

function u1.GetTransferData(p195) -- Line: 991
    local _uq = p195._data._uq;

    if _uq then
        _uq = _uq._tr;
    end;

    return _uq;
end;

function u1.SetTransferData(p196, p197) -- Line: 996
    -- upvalues: Asserts (copy), DeepEqualsUnsafe (copy)
    local u198;

    if p197 == nil then
        u198 = p197;
    else
        local v199 = type(p197) == "table";
        assert(v199, "Transfer data must be a table");
        Asserts.integer(p197.us);
        Asserts.finite(p197.ts);
        u198 = {
            us = p197.us,
            ts = math.round(p197.ts)
        };
        local v200 = DeepEqualsUnsafe(u198, p197);
        assert(v200, "Transfer data does not match expected structure");
        table.freeze(u198);
    end;

    p196:ModifyUnique(function(p201) -- Line: 1009
        -- upvalues: u198 (ref)
        p201._tr = u198;
    end);

    return p196;
end;

function IsLikeGeneric(p202, p203, p204)
    -- upvalues: u1 (copy), DeepEqualsUnsafe (copy)
    assert(p203.GetData == u1.GetData, "Other item does not implement GetData correctly");

    if p202 == p203 then
        return true;
    end;

    if p202.Class ~= p203.Class then
        return false;
    end;

    local _data = p202._data;
    local _data2 = p203._data;

    for i, v in pairs(_data) do
        if not p204[i] then
            local v205 = _data2[i];

            if v205 == nil or not DeepEqualsUnsafe(v, v205) then
                return false;
            end;
        end;
    end;

    for i in pairs(_data2) do
        if not p204[i] and _data[i] == nil then
            return false;
        end;
    end;

    return true;
end;

function u1.IsLikeExact(p206, p207) -- Line: 1042
    -- upvalues: Items (copy)
    return IsLikeGeneric(p206, p207, Items.ExactStackKeyIgnoredFields);
end;

function u1.IsLikeAny(p208, p209) -- Line: 1046
    -- upvalues: Items (copy)
    return IsLikeGeneric(p208, p209, Items.StackKeyIgnoredFields);
end;

function u1.StackKeyData(p210) -- Line: 1050
    -- upvalues: DeepCopyUnsafe (copy)
    local v211 = DeepCopyUnsafe(p210._data);
    v211._am = nil;
    v211._lk = nil;
    v211._to = nil;
    v211._uq = nil;

    return v211;
end;

function u1.StackKey(p212) -- Line: 1059
    -- upvalues: FastJSON (copy)
    local _stackKey = p212._stackKey;

    if _stackKey then
        return _stackKey;
    end;

    local _data = p212._data;

    if table.isfrozen(_data) then
        _data = table.clone(_data);
    end;

    local _am = _data._am;
    local _lk = _data._lk;
    local _to = _data._to;
    local _uq = _data._uq;
    _data._am = nil;
    _data._lk = nil;
    _data._to = nil;
    _data._uq = nil;
    local success, result = pcall(function() -- Line: 1079
        -- upvalues: FastJSON (ref), _data (ref)
        return FastJSON.Encode(_data);
    end);
    _data._am = _am;
    _data._lk = _lk;
    _data._to = _to;
    _data._uq = _uq;

    if not success then
        error("Error encoding stack key data: " .. tostring(result));
    end;

    return result;
end;

function u1.ExactStackKeyData(p213) -- Line: 1095
    -- upvalues: DeepCopyUnsafe (copy)
    local v214 = DeepCopyUnsafe(p213._data);
    v214._am = nil;
    v214._lk = nil;

    return v214;
end;

function u1.ExactStackKey(p215) -- Line: 1102
    -- upvalues: FastJSON (copy)
    local _exactStackKey = p215._exactStackKey;

    if _exactStackKey then
        return _exactStackKey;
    end;

    local _data = p215._data;

    if table.isfrozen(_data) then
        _data = table.clone(_data);
    end;

    local _am = _data._am;
    local _lk = _data._lk;
    _data._am = nil;
    _data._lk = nil;
    local success, result = pcall(function() -- Line: 1115
        -- upvalues: FastJSON (ref), _data (ref)
        return FastJSON.Encode(_data);
    end);
    _data._am = _am;
    _data._lk = _lk;

    if not success then
        error("Error encoding exact stack key data: " .. tostring(result));
    end;

    return result;
end;

function u1.GetId(p216) -- Line: 1127
    error("Unimplemented");
end;

function u1.SetId(p217, p218) -- Line: 1131
    error("Unimplemented");
end;

function u1.GetTier(p219) -- Line: 1135
    return 0;
end;

function u1.Directory(p220) -- Line: 1139
    error("Unimplemented");
end;

function u1.SetDirectory(p221, p222) -- Line: 1143
    error("Unimplemented");
end;

function u1.GetRarity(p223) -- Line: 1147
    -- upvalues: ReplicatedStorage (copy)
    return require(ReplicatedStorage.Directory.Rarity).Rarities.Basic;
end;

function u1.GetIcon(p224) -- Line: 1151
    return "";
end;

function u1.GetOrbIcon(p225) -- Line: 1155
    return p225:GetIcon();
end;

function u1.GetName(p226) -- Line: 1159
    return "";
end;

function u1.GetDesc(p227) -- Line: 1163
    return "";
end;

function u1.GiveStrict(p228, p229) -- Line: 1167
    error("Unimplemented");
end;

function u1.GiveRelaxed(p230, p231) -- Line: 1171
    error("Unimplemented");
end;

function u1.CollectAny(p232, p233) -- Line: 1175
    error("Unimplemented");
end;

function u1.CollectExact(p234, p235) -- Line: 1179
    error("Unimplemented");
end;

function u1.HasExact(p236, p237) -- Line: 1183
    error("Unimplemented");
end;

function u1.HasAny(p238, p239) -- Line: 1187
    error("Unimplemented");
end;

function u1.CountExact(p240, p241) -- Line: 1191
    error("Unimplemented");
end;

function u1.CountAny(p242, p243) -- Line: 1195
    error("Unimplemented");
end;

function u1.FindExact(p244, p245) -- Line: 1199
    error("Unimplemented");
end;

function u1.FindAny(p246, p247) -- Line: 1203
    error("Unimplemented");
end;

function u1.GetRAP(p248) -- Line: 1207
    error("Unimplemented");
end;

function u1.GetDevRAP(p249) -- Line: 1211
    error("Unimplemented");
end;

function u1.GetExistCount(p250) -- Line: 1215
    error("Unimplemented");
end;

function u1.ToRewardFormat(p251, p252) -- Line: 1219
    error("Unimplemented");
end;

function u1.ToItemUtilFormat(p253) -- Line: 1223
    error("Unimplemented");
end;

u2.Added = Event.new();
u2.Removed = Event.new();
u2.Tracked = Event.new();

function u2.IsA(p254, p255) -- Line: 1232
    -- upvalues: u1 (copy), u3 (copy)
    local v256;

    if type(p255) == "table" and p255.GetData == u1.GetData then
        v256 = p255.Class == p254.Class and true or p254 == u3;
    else
        v256 = false;
    end;

    return v256;
end;

function u2.IsAWithErrMsg(p257, p258) -- Line: 1246
    -- upvalues: u2 (copy)
    if u2.IsA(p257, p258) then
        return true;
    end;

    return false, `Item is not of type {p257.Class.Name}. Expected item to have GetData method matching AbstractPrototype.GetData, got: {p258}`;
end;

function u2.WrapForTCheck(u259) -- Line: 1256
    return function(p260) -- Line: 1257
        -- upvalues: u259 (copy)
        return u259:IsAWithErrMsg(p260);
    end;
end;

function u2.TryCast(p261, p262) -- Line: 1262
    -- upvalues: u2 (copy)
    return u2.IsA(p261, p262) and p262 and p262 or nil;
end;

function u2.Assert(p263, p264) -- Line: 1266
    -- upvalues: u1 (copy), u3 (copy)
    assert(p264.GetData == u1.GetData, "Item does not implement GetData");

    if p263 ~= u3 then
        assert(p264.Class == p263.Class, "Item class mismatch");
    end;

    return p264;
end;

function u2.Cast(p265, p266) -- Line: 1274
    -- upvalues: u2 (copy)
    u2.Assert(p265, p266);

    return p266;
end;

function u2.From(p267, p268) -- Line: 1279
    -- upvalues: AbstractPatch (copy)
    local v269 = type(p268) == "table";
    assert(v269, "Data must be a table");
    local v270 = setmetatable({
        _data = p268
    }, {
        __index = p267.Prototype,
        __tostring = p267.Prototype.ToString
    });
    local Patch = v270.Patch;

    if Patch and (Patch ~= AbstractPatch and not table.isfrozen(p268)) then
        pcall(Patch, v270);
    end;

    return v270;
end;

function u2.Find(p271, p272) -- Line: 1298
    error("Unimplemented");
end;

function u2.Get(p273, p274, p275) -- Line: 1302
    error("Unimplemented");
end;

function u2.All(p276, p277) -- Line: 1306
    error("Unimplemented");
end;

function u2.Each(p278, p279, p280, ...) -- Line: 1310
    error("Unimplemented");
end;

function u3.IsAnyItem(p281) -- Line: 1315
    -- upvalues: u1 (copy)
    local v282;

    if type(p281) == "table" then
        v282 = p281.GetData == u1.GetData;
    else
        v282 = false;
    end;

    return v282;
end;

function u3.AssertAnyItem(p283) -- Line: 1323
    -- upvalues: u1 (copy)
    local v284;

    if type(p283) == "table" then
        v284 = p283.GetData == u1.GetData;
    else
        v284 = false;
    end;

    assert(v284, "Item is not a valid abstract item");

    return p283;
end;

function u3.AssertModule(p285) -- Line: 1332
    -- upvalues: u2 (copy)
    assert(p285.IsA == u2.IsA, "Module does not have the correct IsA function");
end;

function u3.AssertUID(p286) -- Line: 1336
    -- upvalues: Asserts (copy)
    Asserts.UUIDv4StrippedLower(p286);

    return p286;
end;

function u3.AssertOptionalUID(p287) -- Line: 1341
    -- upvalues: Asserts (copy)
    Asserts.optional.UUIDv4StrippedLower(p287);

    return p287;
end;

function u3.AssertUIDFast(p288) -- Line: 1346
    -- upvalues: Asserts (copy)
    Asserts.UUIDv4StrippedLowerFast(p288);

    return p288;
end;

function u3.AssertOptionalUIDFast(p289) -- Line: 1351
    -- upvalues: Asserts (copy)
    Asserts.optional.UUIDv4StrippedLowerFast(p289);
end;

function u3.AssertUniqueUIDs(p290) -- Line: 1355
    -- upvalues: Asserts (copy)
    Asserts.array.uniqueUUIDv4StrippedLower(p290);

    return p290;
end;

function u3.AssertUniqueUIDsFast(p291) -- Line: 1360
    -- upvalues: Asserts (copy)
    Asserts.array.uniqueUUIDv4StrippedLowerFast(p291);

    return p291;
end;

function u3.GenerateUID() -- Line: 1365
    -- upvalues: HttpService (copy)
    return HttpService:GenerateGUID(false):gsub("%-", ""):lower();
end;

function u3.AssertOrGenerateUID(p292) -- Line: 1369
    -- upvalues: u3 (copy)
    if p292 == nil then
        return u3.GenerateUID();
    end;

    u3.AssertUID(p292);

    return p292;
end;

function u3.AssertUniqueItems(p293) -- Line: 1378
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.array.custom(p293, function(p294, p295) -- Line: 1379
        -- upvalues: Asserts (ref), u1 (ref)
        Asserts.cassert(type(p294) == "table", p295);
        Asserts.cassert(p294.GetData == u1.GetData, p295);
    end);
    local v296 = {};

    for _, v in ipairs(p293) do
        local v297 = v:GetUID();
        assert(not v296[v297], "Duplicate UID found: " .. v297);
        v296[v297] = true;
    end;

    return p293;
end;

u3.Nil = nil;

function u3.HashedSalt() -- Line: 1393
    return "";
end;

local u298 = SHA256(`AbstractItem/{game.GameId}`);

function u3.HashedSalt() -- Line: 1399
    -- upvalues: u298 (copy)
    return u298;
end;

return u3;