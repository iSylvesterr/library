-- Decompiled with Potassium's decompiler.

local Functions = require(game:GetService("ReplicatedStorage").Library.Functions);

return ({
    UpdateTitle = function(p1, p2, p3, p4) -- Line: 5, Name: UpdateTitle
        -- upvalues: Functions (copy)
        local v5 = math.round(p3);

        if p4 > 1 then
            p1.title.Text = `⚖️ {Functions.NumberShorten(v5 * p4)} ({Functions.NumberShorten(v5)}/ea)`;

            return;
        end;

        p1.title.Text = `⚖️ {Functions.NumberShorten(v5)}`;
    end
}).UpdateTitle;