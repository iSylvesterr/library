-- Decompiled with Potassium's decompiler.

local Client = game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Client");
local FFlags = require(Client.FFlags);

return {
    BottomOverlays = function(p1, p2, p3) -- Line: 11, Name: BottomOverlays
        -- upvalues: FFlags (copy)
        local v4 = p3 or {};
        local v5 = false;

        if v4.Hot then
            if not v5 then
                table.insert(p1, { "Div" });
                v5 = true;
            end;

            table.insert(p1, { "Hot" });
        end;

        if not v4.HideExists then
            local v6 = v4.ForceExists == true and true or p2.Class.Name == "Skin";
            local v7 = v4.ShowExists == true and true or v6;

            if not v6 then
                if not FFlags.Get(FFlags.Keys.ExistCount) then
                    v7 = false;
                end;

                if not FFlags.Get(FFlags.Keys.ExistCountOverlay) then
                    v7 = false;
                end;
            end;

            if v7 then
                local v8 = p2:GetExistCount();

                if v8 > 0 then
                    if not v5 then
                        table.insert(p1, { "Div" });
                        v5 = true;
                    end;

                    table.insert(p1, { "Exists", v8 });
                end;
            end;
        end;

        if not v4.HideRAP then
            local v9 = p2:IsRAPVisible();

            if not FFlags.Get(FFlags.Keys.RAP) then
                v9 = false;
            end;

            if not FFlags.Get(FFlags.Keys.RAPOverlay) then
                v9 = false;
            end;
        end;

        if v4.ShowDeal then
            if not v5 then
                table.insert(p1, { "Div" });
                v5 = true;
            end;

            table.insert(p1, { "Deal", v4.ShowDeal });
        end;

        local Mailbox = v4.Mailbox;

        if Mailbox then
            local v10, v11, v12 = unpack(Mailbox);
            table.insert(p1, { "Div" });
            table.insert(p1, { "MessageDark", v10 });
            table.insert(p1, { "Message", v11 });
            table.insert(p1, { "Nickname", v12 });
        end;

        return v5;
    end
};