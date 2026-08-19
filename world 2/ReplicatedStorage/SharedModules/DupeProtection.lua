-- Decompiled with Potassium's decompiler.

local u1 = {
    TransferBlockedMessage = "This item has been flagged by dupe protection and can\'t be transferred."
};

function u1.IsTransferBlockedMessage(p2) -- Line: 24
    -- upvalues: u1 (copy)
    local v3;

    if type(p2) == "string" then
        v3 = p2 == u1.TransferBlockedMessage;
    else
        v3 = false;
    end;

    return v3;
end;

return table.freeze(u1);