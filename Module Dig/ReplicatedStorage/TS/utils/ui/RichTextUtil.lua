-- Decompiled with Potassium's decompiler.

return {
    RichTextUtil = {
        color = function(p1, p2) -- Line: 5, Name: color
            return `<font color='rgb({math.floor(p2.R * 255 + 0.5)},{math.floor(p2.G * 255 + 0.5)},{math.floor(p2.B * 255 + 0.5)})'>{p1}</font>`;
        end,

        strike = function(p3) -- Line: 12, Name: strike
            return `<s>{p3}</s>`;
        end,

        bold = function(p4) -- Line: 16, Name: bold
            return `<b>{p4}</b>`;
        end,

        escape = function(p5) -- Line: 25, Name: escape
            local v6 = string.gsub(p5, "&", "&amp;");
            local v7 = string.gsub(v6, "<", "&lt;");

            return string.gsub(v7, ">", "&gt;");
        end
    }
};