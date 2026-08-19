-- Decompiled with Potassium's decompiler.

local v1 = {};
local Players = game:GetService("Players");
local ContentProvider = game:GetService("ContentProvider");
local LocalPlayer = Players.LocalPlayer;
local u2 = {};

local function preloadTool(u3) -- Line: 22
    -- upvalues: u2 (copy), ContentProvider (copy)
    if u2[u3] then
        return;
    end;

    u2[u3] = true;
    u3.AncestryChanged:Connect(function() -- Line: 26
        -- upvalues: u3 (copy), u2 (ref)
        if not u3:IsDescendantOf(game) then
            u2[u3] = nil;
        end;
    end);
    task.spawn(function() -- Line: 34
        -- upvalues: u3 (copy), ContentProvider (ref)
        task.wait();
        local u4 = u3:GetDescendants();

        if #u4 == 0 then
            return;
        end;

        local _, _ = pcall(function() -- Line: 45
            -- upvalues: ContentProvider (ref), u4 (copy)
            ContentProvider:PreloadAsync(u4);
        end);
    end);
end;

local function tryPreload(p5) -- Line: 53
    -- upvalues: preloadTool (copy)
    if p5:IsA("Tool") then
        preloadTool(p5);
    end;
end;

local function watchContainer(p6) -- Line: 59
    -- upvalues: preloadTool (copy), tryPreload (copy)
    for _, child in p6:GetChildren() do
        if child:IsA("Tool") then
            preloadTool(child);
        end;
    end;

    p6.ChildAdded:Connect(tryPreload);
end;

function v1.Init(p7) -- Line: 66
end;

function v1.Start(p8) -- Line: 68
    -- upvalues: LocalPlayer (copy), preloadTool (copy), tryPreload (copy)
    local Backpack = LocalPlayer:WaitForChild("Backpack");

    for _, child in Backpack:GetChildren() do
        if child:IsA("Tool") then
            preloadTool(child);
        end;
    end;

    Backpack.ChildAdded:Connect(tryPreload);

    local function onCharacter(p9) -- Line: 72
        -- upvalues: preloadTool (ref), tryPreload (ref)
        for _, child in p9:GetChildren() do
            if child:IsA("Tool") then
                preloadTool(child);
            end;
        end;

        p9.ChildAdded:Connect(tryPreload);
    end;

    if LocalPlayer.Character then
        local Character = LocalPlayer.Character;

        for _, child in Character:GetChildren() do
            if child:IsA("Tool") then
                preloadTool(child);
            end;
        end;

        Character.ChildAdded:Connect(tryPreload);
    end;

    LocalPlayer.CharacterAdded:Connect(onCharacter);
end;

return v1;