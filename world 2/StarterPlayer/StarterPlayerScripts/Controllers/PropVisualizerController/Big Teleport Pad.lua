-- Decompiled with Potassium's decompiler.

local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Networking"));
local Players = game:GetService("Players");
game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Zone = require(game.ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("Zone"));
local u1 = {
    Color3.fromRGB(231, 71, 204),
    Color3.fromRGB(47, 121, 231),
    Color3.fromRGB(55, 231, 126),
    Color3.fromRGB(190, 231, 55),
    Color3.fromRGB(231, 129, 46),
    Color3.fromRGB(231, 55, 55),
    Color3.fromRGB(120, 55, 231),
    Color3.fromRGB(55, 210, 231),
    Color3.fromRGB(231, 55, 120),
    Color3.fromRGB(231, 210, 55)
};

local function clampVariantId(p2) -- Line: 20
    -- upvalues: u1 (copy)
    local v3 = #u1;

    if v3 <= 0 then
        return 1;
    end;

    local v4 = tonumber(p2) or 1;

    return (math.floor(v4) - 1) % v3 + 1;
end;

local function parseVariantId(p5) -- Line: 29
    -- upvalues: u1 (copy)
    if type(p5) == "number" then
        local v6 = #u1;

        if v6 <= 0 then
            return 1;
        end;

        local v7 = tonumber(p5) or 1;

        return (math.floor(v7) - 1) % v6 + 1;
    end;

    if type(p5) ~= "string" then
        return 1;
    end;

    local v8 = p5:match("(%d+)");
    local v9 = tonumber(v8) or 1;
    local v10 = #u1;

    if v10 <= 0 then
        return 1;
    end;

    local v11 = tonumber(v9) or 1;

    return (math.floor(v11) - 1) % v10 + 1;
end;

local function findRandomPartnerPad(p12) -- Line: 40
    -- upvalues: u1 (copy)
    local v13 = p12:GetAttribute("ExtraData");
    local v14;

    if type(v13) == "number" then
        local v15 = #u1;

        if v15 <= 0 then
            v14 = 1;
        else
            local v16 = tonumber(v13) or 1;
            v14 = (math.floor(v16) - 1) % v15 + 1;
        end;
    elseif type(v13) == "string" then
        local v17 = v13:match("(%d+)");
        local v18 = tonumber(v17) or 1;
        local v19 = #u1;

        if v19 <= 0 then
            v14 = 1;
        else
            local v20 = tonumber(v18) or 1;
            v14 = (math.floor(v20) - 1) % v19 + 1;
        end;
    else
        v14 = 1;
    end;

    local v21 = p12:GetAttribute("PropId");
    local v22 = 0;
    local v23 = 0;
    local v24 = 0;
    local v25 = 0;
    local v26 = {};

    for _, descendant in p12.Parent:GetDescendants() do
        if descendant:IsA("Model") then
            v22 = v22 + 1;
            local v27 = descendant:GetAttribute("PropName");

            if v27 and string.find(v27, "Teleport Pad") then
                v23 = v23 + 1;
                local v28 = descendant:GetAttribute("ExtraData");
                local v29;

                if type(v28) == "number" then
                    local v30 = #u1;

                    if v30 <= 0 then
                        v29 = 1;
                    else
                        local v31 = tonumber(v28) or 1;
                        v29 = (math.floor(v31) - 1) % v30 + 1;
                    end;
                elseif type(v28) == "string" then
                    local v32 = v28:match("(%d+)");
                    local v33 = tonumber(v32) or 1;
                    local v34 = #u1;

                    if v34 <= 0 then
                        v29 = 1;
                    else
                        local v35 = tonumber(v33) or 1;
                        v29 = (math.floor(v35) - 1) % v34 + 1;
                    end;
                else
                    v29 = 1;
                end;

                if descendant:GetAttribute("PropId") == v21 then
                    v25 = v25 + 1;
                elseif v29 == v14 then
                    table.insert(v26, descendant);
                else
                    v24 = v24 + 1;
                end;
            end;
        end;
    end;

    return #v26 > 0 and v26[math.random(1, #v26)] or nil;
end;

local Teleport = game.SoundService.SFX.Teleport;

return function(u36) -- Line: 78
    -- upvalues: Players (copy), u1 (copy), Networking (copy), Zone (copy), TweenService (copy), findRandomPartnerPad (copy), Teleport (copy)
    while true do
        local v37 = u36:GetAttribute("UserId");
        local u38;

        if typeof(v37) == "number" then
            u38 = game:GetService("Players"):GetPlayerByUserId(v37);
        else
            u38 = nil;
        end;

        local v39;

        if u38 == nil then
            v39 = false;
        else
            v39 = u36:IsDescendantOf(workspace);
        end;

        if not v39 then
            task.wait();
        end;

        if v39 then
            local TouchPart = u36:FindFirstChild("TouchPart");

            if u38 == Players.LocalPlayer then
                u36:WaitForChild("ProximityPromptPart"):WaitForChild("ProximityPrompt").Triggered:Connect(function() -- Line: 95
                    -- upvalues: u36 (copy), u1 (ref), Networking (ref)
                    local v40 = u36:GetAttribute("ExtraData");
                    local v41;

                    if type(v40) == "number" then
                        local v42 = #u1;

                        if v42 <= 0 then
                            v41 = 1;
                        else
                            local v43 = tonumber(v40) or 1;
                            v41 = (math.floor(v43) - 1) % v42 + 1;
                        end;
                    elseif type(v40) == "string" then
                        local v44 = v40:match("(%d+)");
                        local v45 = tonumber(v44) or 1;
                        local v46 = #u1;

                        if v46 <= 0 then
                            v41 = 1;
                        else
                            local v47 = tonumber(v45) or 1;
                            v41 = (math.floor(v47) - 1) % v46 + 1;
                        end;
                    else
                        v41 = 1;
                    end;

                    local v48 = v41 + 1;
                    local v49 = #u1;
                    local v50;

                    if v49 <= 0 then
                        v50 = 1;
                    else
                        local v51 = tonumber(v48) or 1;
                        v50 = (math.floor(v51) - 1) % v49 + 1;
                    end;

                    local v52 = u36:GetAttribute("PropId") or u36.Name;
                    Networking.Prop.SetPropExtraData:Fire(v52, (tostring(v50)));
                end);
            end;

            u36:FindFirstChild("Zone");
            local v53 = Zone.new({ u36:WaitForChild("Zone") });

            local function applyFromAttribute() -- Line: 106
                -- upvalues: u36 (copy), u1 (ref), TouchPart (copy)
                local v54 = u36:GetAttribute("ExtraData");
                local v55;

                if type(v54) == "number" then
                    local v56 = #u1;

                    if v56 <= 0 then
                        v55 = 1;
                    else
                        local v57 = tonumber(v54) or 1;
                        v55 = (math.floor(v57) - 1) % v56 + 1;
                    end;
                elseif type(v54) == "string" then
                    local v58 = v54:match("(%d+)");
                    local v59 = tonumber(v58) or 1;
                    local v60 = #u1;

                    if v60 <= 0 then
                        v55 = 1;
                    else
                        local v61 = tonumber(v59) or 1;
                        v55 = (math.floor(v61) - 1) % v60 + 1;
                    end;
                else
                    v55 = 1;
                end;

                TouchPart.Color = u1[v55];
            end;

            local u62 = u36.PrimaryPart or u36:FindFirstChildWhichIsA("BasePart");
            local u63 = u62.CFrame:ToObjectSpace(TouchPart.CFrame);
            local u64 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            local u65 = nil;
            v53.localPlayerEntered:Connect(function() -- Line: 117
                -- upvalues: u36 (copy), u62 (copy), u63 (copy), TweenService (ref), TouchPart (copy), u64 (copy), Players (ref), u65 (ref), findRandomPartnerPad (ref), Teleport (ref), Networking (ref), u38 (ref)
                if not u36:GetAttribute("IsBeingMoved") then
                    TweenService:Create(TouchPart, u64, {
                        CFrame = u62.CFrame * u63 * CFrame.new(0, -0.1, 0)
                    }):Play();
                end;

                local Character = Players.LocalPlayer.Character;
                local v66;

                if Character then
                    v66 = Character:GetAttribute("_TelepadArrival");
                else
                    v66 = Character;
                end;

                if v66 then
                    Character:SetAttribute("_TelepadArrival", nil);
                end;

                u65 = task.delay(v66 and 5 or 0.1, function() -- Line: 133
                    -- upvalues: findRandomPartnerPad (ref), u36 (ref), TouchPart (ref), Teleport (ref), u65 (ref), Character (copy), Networking (ref), u38 (ref), Players (ref)
                    local v67 = findRandomPartnerPad(u36);

                    if v67 then
                        local Break = TouchPart:FindFirstChild("Break");
                        Teleport.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
                        Teleport.TimePosition = 0;
                        Teleport.Playing = true;

                        if Break then
                            Break:Emit(5);
                        end;
                    end;

                    task.wait(0.2);
                    u65 = nil;

                    if v67 then
                        local v68 = Character and Character:FindFirstChild("HumanoidRootPart");

                        if Character and v68 then
                            Character:SetAttribute("_TelepadArrival", true);
                            Networking.Prop.UseTelepad:Fire(u36:GetAttribute("UserId"), u36:GetAttribute("PropId"));
                        end;
                    elseif u38 == Players.LocalPlayer then
                        game.ReplicatedStorage.Notify:Fire("This teleport pad has no destination!");
                    end;
                end);
            end);
            v53.localPlayerExited:Connect(function() -- Line: 168
                -- upvalues: u36 (copy), u62 (copy), u63 (copy), TweenService (ref), TouchPart (copy), u64 (copy), u65 (ref)
                if not u36:GetAttribute("IsBeingMoved") then
                    TweenService:Create(TouchPart, u64, {
                        CFrame = u62.CFrame * u63
                    }):Play();
                end;

                if u65 then
                    task.cancel(u65);
                    u65 = nil;
                end;
            end);
            local v69 = u36:GetAttribute("ExtraData");
            local v70;

            if type(v69) == "number" then
                local v71 = #u1;

                if v71 <= 0 then
                    v70 = 1;
                else
                    local v72 = tonumber(v69) or 1;
                    v70 = (math.floor(v72) - 1) % v71 + 1;
                end;
            elseif type(v69) == "string" then
                local v73 = v69:match("(%d+)");
                local v74 = tonumber(v73) or 1;
                local v75 = #u1;

                if v75 <= 0 then
                    v70 = 1;
                else
                    local v76 = tonumber(v74) or 1;
                    v70 = (math.floor(v76) - 1) % v75 + 1;
                end;
            else
                v70 = 1;
            end;

            TouchPart.Color = u1[v70];
            u36:GetAttributeChangedSignal("ExtraData"):Connect(applyFromAttribute);

            return;
        end;
    end;
end;