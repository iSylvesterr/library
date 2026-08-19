-- Decompiled with Potassium's decompiler.

return {
    getData = function(p1) -- Line: 7, Name: getData
        return script:FindFirstChild(p1) or nil;
    end,

    getIndexList = function() -- Line: 11, Name: getIndexList
        return { "Capybara", "Alpha Capybara", "Archer Capybara", "Magic Capybara", "Ghost Capybara", "Golem Capybara", "Robot Capybara", "Disco Capybara", "Angel Capybara" };
    end
};