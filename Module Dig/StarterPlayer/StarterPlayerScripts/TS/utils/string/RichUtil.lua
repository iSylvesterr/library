-- Decompiled with Potassium's decompiler.

return {
    RichTextApply = function(p1, p2) -- Line: 2
        if p2.Color then
            p1 = `<font color="#{p2.Color:ToHex()}">{p1}</font>`;
        end;

        if p2.Size ~= nil then
            p1 = `<font size="{p2.Size}">{p1}</font>`;
        end;

        if p2.FontFace ~= nil then
            p1 = `<font face="{p2.FontFace}">{p1}</font>`;
        end;

        if p2.FontFamily ~= nil then
            p1 = `<font face="{p2.FontFamily}">{p1}</font>`;
        end;

        if p2.FontWeight ~= nil then
            p1 = `<font weight="{p2.FontWeight}">{p1}</font>`;
        end;

        if p2.Stroke then
            p1 = `<font stroke="#{p2.Stroke.Color:ToHex()}" join="{p2.Stroke.Joins}" thickness="{p2.Stroke.Thickness}" transparency="{p2.Stroke.Transparency}">{p1}</font>`;
        end;

        if p2.Transparency ~= nil then
            p1 = `<font transparency="{p2.Transparency}">{p1}</font>`;
        end;

        if p2.Bold then
            p1 = `<b>{p1}</b>`;
        end;

        if p2.Italic then
            p1 = `<i>{p1}</i>`;
        end;

        if p2.Underline then
            p1 = `<u>{p1}</u>`;
        end;

        if p2.Strikethrough then
            p1 = `<s>{p1}</s>`;
        end;

        if p2.LineBreak then
            p1 = `{p1}<br/>`;
        end;

        if p2.UpperCase then
            p1 = `<uc>{p1}</uc>`;
        end;

        if p2.SmallCaps then
            p1 = `<sc>{p1}</sc>`;
        end;

        return p1;
    end,

    RGBToHex = function(p3) -- Line: 47
        local v4 = math.floor(p3.R * 255);
        local v5 = math.floor(p3.G * 255);
        local v6 = math.floor(p3.B * 255);

        return string.format("#%02X%02X%02X", v4, v5, v6);
    end
};