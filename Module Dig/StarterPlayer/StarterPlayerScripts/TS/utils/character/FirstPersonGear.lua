-- Decompiled with Potassium's decompiler.

return {
    FirstPersonGear = {
        attach = function(p1, p2) -- Line: 5, Name: attach
            local Folder = Instance.new("Folder");
            Folder.Name = p1.Name;
            local Tool = Instance.new("Tool");
            Tool.Name = p1.Name;
            Tool.Parent = Folder;
            p1.Parent = Tool;
            Folder.Parent = p2;

            return Folder;
        end
    }
};