-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 2
    return p1:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1");
end;