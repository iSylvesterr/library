-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Client = Library:WaitForChild("Client");
local Audio = require(Library.Audio);
local InfoOverlay = require(Client.InfoOverlay);
local Sparkles = require(Client.GUIFX.Sparkles);
local Sparkles2 = require(Client.GUIFX.Sparkles);
local Abstract = require(script.Abstract);
require(ReplicatedStorage.Library.Items.AbstractItem);
local Simple = require(ReplicatedStorage.Library.Modules.FormatNumber.Simple);

function defaultCreate(p2, p3)
    -- upvalues: Simple (copy), u1 (copy)
    local v4 = p3 or {};
    local ItemSlot = p2:GetRarity().ItemSlot;
    local v5 = v4.QuantityOverride or p2:GetAmount();
    local v6 = ItemSlot:Clone();
    v6.Icon.Image = p2:GetIcon();
    v6.Quantity.Text = `x{Simple.FormatCompact(v5)}`;
    v6.Strength.Visible = false;
    local Level = v6:FindFirstChild("Level");

    if Level then
        Level.Visible = false;
    end;

    if v4.HideQuantity then
        v6.Quantity.Visible = false;
    end;

    if v4.NoScribble then
        v6.scribble.Visible = false;
    end;

    if not v4.NoOverlay then
        u1.AddOverlay(v6, p2, v4);
    end;

    return v6;
end;

function defaultAddOverlay(u7, u8, p9)
    -- upvalues: Abstract (copy), InfoOverlay (copy), Audio (copy)
    local u10 = p9 or {};

    local function updateOverlay() -- Line: 48
        -- upvalues: u8 (copy), u10 (copy), Abstract (ref), InfoOverlay (ref), u7 (copy)
        u8:Directory();
        local v11 = u8.Class.Name == "Skin";
        local v12 = {};
        local v13 = { "Title", ` {u8:GetName()} `, "Rare" };
        table.insert(v12, v13);
        local v14 = { "Rarity", u8:GetRarity()._id };
        table.insert(v12, v14);
        local v15 = v11 and "" or u8:GetDesc();
        local v16;

        if u10.AdditionalDescription then
            v16 = u10.AdditionalDescription;

            if v15 ~= "" then
                v16 = v15 .. "\n\n" .. v16;
            end;
        else
            v16 = v15;
        end;

        if v16 ~= "" then
            table.insert(v12, { "Div" });
            table.insert(v12, { "Desc", v16 });
        end;

        Abstract.BottomOverlays(v12, u8, u10);
        InfoOverlay.Add(u7, unpack(v12));
    end;

    u7.MouseEnter:Connect(function() -- Line: 74
        -- upvalues: Audio (ref), updateOverlay (copy)
        Audio.Play("rbxassetid://89944486811970", script, 1, 0.2);
        updateOverlay();
    end);
    u7.SelectionGained:Connect(function() -- Line: 79
        -- upvalues: Audio (ref), updateOverlay (copy)
        Audio.Play("rbxassetid://89944486811970", script, 1, 0.2);
        updateOverlay();
    end);
end;

local u17 = {
    Brainrot = require(script.Brainrot)
};
require(ReplicatedStorage.ModuleLoader)(script, u17, {
    noPrint = true,
    warn = warn
});
local u18 = {
    Create = defaultCreate,
    AddOverlay = defaultAddOverlay
};

function getUIModule(p19)
    -- upvalues: u17 (copy), u18 (copy)
    return u17[p19] or u18;
end;

function u1.AddOverlay(p20, p21, p22) -- Line: 99
    -- upvalues: u18 (copy)
    return (getUIModule(p21.Class.Name).AddOverlay or u18.AddOverlay)(p20, p21, p22 or {});
end;

function u1.Create(p23, p24) -- Line: 107
    -- upvalues: u18 (copy), Sparkles2 (copy), Sparkles (copy)
    local v25 = p24 or {};
    local u26 = (getUIModule(p23.Class.Name).Create or u18.Create)(p23, v25);

    if not v25.NoButtonFX then
        Sparkles2(u26);
    end;

    local star = u26:FindFirstChild("star");

    if v25.HideStars and star then
        star.Visible = false;
    end;

    local v27 = v25.IconOverride and u26:FindFirstChild("Icon");

    if v27 then
        v27.Image = v25.IconOverride;
    end;

    if p23:GetRarity()._id == "Mythical" or (p23:GetRarity()._id == "Legendary" or (p23:GetRarity()._id == "Rainbow" or (p23:GetRarity()._id == "Exotic" or p23:GetRarity()._id == "Divine"))) then
        local u28 = false;
        u26.AncestryChanged:Connect(function(p29, p30) -- Line: 133
            -- upvalues: u28 (ref), Sparkles (ref), u26 (copy)
            if p30 ~= nil and not u28 then
                task.defer(function() -- Line: 135
                    -- upvalues: Sparkles (ref), u26 (ref)
                    Sparkles(u26);
                end);
                u28 = true;
            end;
        end);
    end;

    if p23.LockingEnabled and u26:FindFirstChild("Locked") then
        u26.Locked.Visible = p23:IsLocked();

        if star and p23:IsLocked() then
            star.Visible = false;
        end;
    end;

    return u26, nil;
end;

return u1;