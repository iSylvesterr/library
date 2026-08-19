-- Decompiled with Potassium's decompiler.

local v1 = {};
local Maid = require(game.ReplicatedStorage.Packages.Maid);
local LoadDeloadManager = require(game.ReplicatedStorage.Client.Modules.Utility.LoadDeloadManager);
local PlayerGui = game.Players.LocalPlayer.PlayerGui;
local Nametag = game.ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Bilboards"):WaitForChild("Nametag");

function v1.Deferred(p2) -- Line: 19
    -- upvalues: LoadDeloadManager (copy), Maid (copy), Nametag (copy), PlayerGui (copy)
    LoadDeloadManager:Listen("PlayerCharacter", nil, nil, function(p3) -- Line: 20
        -- upvalues: Maid (ref), Nametag (ref), PlayerGui (ref)
        local PrimaryPart = p3.PrimaryPart;

        if not PrimaryPart then
            return;
        end;

        local u4 = game.Players:GetPlayerFromCharacter(p3);

        if u4 then
            local v5 = Maid.new();
            local u6 = Nametag:Clone();
            u6.Parent = PlayerGui;
            u6.Adornee = PrimaryPart;
            u6.Enabled = true;

            local function updateName() -- Line: 36
                -- upvalues: u4 (copy), u6 (copy)
                local v7 = u4:GetAttribute("Level");

                while not v7 do
                    task.wait(0.5);
                    v7 = u4:GetAttribute("Level");
                end;

                u6.NameLabel.Text = "Lv." .. v7 .. " | " .. u4.DisplayName;
            end;

            updateName();
            v5:GiveTask(u4:GetAttributeChangedSignal("Level"):Connect(updateName));
            v5:GiveTask(function() -- Line: 52
                -- upvalues: u6 (copy)
                if u6 then
                    u6:Destroy();
                end;
            end);

            return v5;
        end;
    end);
end;

return v1;