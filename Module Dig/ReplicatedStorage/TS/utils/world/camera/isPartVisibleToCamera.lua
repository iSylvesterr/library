-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace;
local CharacterUtils = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "world", "CharacterUtils").CharacterUtils;

return {
    isPartVisibleToCamera = function(p1) -- Line: 16
        -- upvalues: Workspace (copy), CharacterUtils (copy)
        local CurrentCamera = Workspace.CurrentCamera;

        if not CurrentCamera then
            return false;
        end;

        local v2 = CharacterUtils.waitForCharacter();
        local v3 = RaycastParams.new();
        v3.FilterType = Enum.RaycastFilterType.Exclude;
        v3.FilterDescendantsInstances = v2 and { CurrentCamera, v2 } or { CurrentCamera };
        local v4;

        if p1:IsA("Model") or p1:IsA("Tool") then
            local function _(p5) -- Line: 30
                return p5:IsA("BasePart");
            end;

            local v6 = 0;
            v4 = {};

            for i, descendant in p1:GetDescendants() do
                local _ = i - 1;

                if descendant:IsA("BasePart") == true then
                    v6 = v6 + 1;
                    v4[v6] = descendant;
                end;
            end;

            if #v4 == 0 then
                return false;
            end;
        else
            v4 = { p1 };
        end;

        local function v12(u7, u8) -- Line: 49
            local v9 = { Vector3.new(0, 0, 0), Vector3.new(1, 1, 1), Vector3.new(-1, 1, 1), Vector3.new(1, -1, 1), Vector3.new(1, 1, -1), Vector3.new(-1, -1, 1), Vector3.new(-1, 1, -1), Vector3.new(1, -1, -1), Vector3.new(-1, -1, -1) };
            local v10 = table.create(#v9);

            local function _(p11) -- Line: 53
                -- upvalues: u7 (copy), u8 (copy)
                return u7.Position + u7:VectorToWorldSpace(p11 * (u8 / 2));
            end;

            for i, v in v9 do
                local _ = i - 1;
                v10[i] = u7.Position + u7:VectorToWorldSpace(v * (u8 / 2));
            end;

            return v10;
        end;

        for _, v in v4 do
            for _, v5 in v12(v.CFrame, v.Size) do
                local _, v13 = CurrentCamera:WorldToViewportPoint(v5);

                if v13 then
                    local v14 = Workspace:Raycast(CurrentCamera.CFrame.Position, (v5 - CurrentCamera.CFrame.Position).Unit * 1000, v3);

                    if v14 and (v14.Instance == v or v:IsAncestorOf(v14.Instance)) then
                        return true;
                    end;
                end;
            end;
        end;

        return false;
    end
};