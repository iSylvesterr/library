-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local v1 = {};
local u2 = {};
local u3 = {};
local BindableEvent = Instance.new("BindableEvent");
v1.Changed = BindableEvent.Event;

local function assetUrl(p4) -- Line: 57
    if typeof(p4) == "number" and p4 > 0 then
        return string.format("rbxassetid://%d", p4);
    end;

    return nil;
end;

local function preloadChangelog(p5) -- Line: 71
    -- upvalues: u3 (copy), ContentProvider (copy)
    local u6 = {};

    local function queue(p7) -- Line: 73
        -- upvalues: u3 (ref), u6 (copy)
        local v8;

        if typeof(p7) == "number" and p7 > 0 then
            v8 = string.format("rbxassetid://%d", p7);
        else
            v8 = nil;
        end;

        if v8 and not u3[v8] then
            u3[v8] = true;
            table.insert(u6, v8);
        end;
    end;

    for _, v in p5 do
        local reveal_asset_id = v.reveal_asset_id;
        local v9;

        if typeof(reveal_asset_id) == "number" and reveal_asset_id > 0 then
            v9 = string.format("rbxassetid://%d", reveal_asset_id);
        else
            v9 = nil;
        end;

        if v9 and not u3[v9] then
            u3[v9] = true;
            table.insert(u6, v9);
        end;

        local silhouette_asset_id = v.silhouette_asset_id;
        local v10;

        if typeof(silhouette_asset_id) == "number" and silhouette_asset_id > 0 then
            v10 = string.format("rbxassetid://%d", silhouette_asset_id);
        else
            v10 = nil;
        end;

        if v10 and not u3[v10] then
            u3[v10] = true;
            table.insert(u6, v10);
        end;
    end;

    if #u6 == 0 then
        return;
    end;

    task.spawn(function() -- Line: 87
        -- upvalues: ContentProvider (ref), u6 (copy)
        pcall(function() -- Line: 88
            -- upvalues: ContentProvider (ref), u6 (ref)
            ContentProvider:PreloadAsync(u6);
        end);
    end);
end;

local function applyChangelog(p11) -- Line: 94
    -- upvalues: u2 (ref), preloadChangelog (copy), BindableEvent (copy)
    local v12 = {};

    if typeof(p11) == "table" then
        for _, v in p11 do
            if typeof(v) == "table" and (typeof(v.id) == "string" and v.id ~= "") then
                local v13 = typeof(v.release_unix) ~= "number" and 0 or v.release_unix;
                local v14;

                if typeof(v.reveal_asset_id) == "number" and v.reveal_asset_id > 0 then
                    v14 = v.reveal_asset_id;
                else
                    v14 = nil;
                end;

                local v15;

                if typeof(v.silhouette_asset_id) == "number" and v.silhouette_asset_id > 0 then
                    v15 = v.silhouette_asset_id;
                else
                    v15 = nil;
                end;

                local v16 = {
                    id = v.id,
                    name = typeof(v.name) ~= "string" and "" or v.name,
                    description = typeof(v.description) ~= "string" and "" or v.description,
                    release_unix = v13,
                    grace_end_unix = typeof(v.grace_end_unix) ~= "number" and 0 or v.grace_end_unix
                };

                if typeof(v.released_at_unix) == "number" then
                    v13 = v.released_at_unix;
                end;

                v16.released_at_unix = v13;
                v16.reveal_asset_id = v14;
                v16.silhouette_asset_id = v15;
                table.insert(v12, v16);
            end;
        end;
    end;

    u2 = v12;
    preloadChangelog(v12);
    BindableEvent:Fire(u2);
end;

function v1.GetChangelog(p17) -- Line: 124
    -- upvalues: u2 (ref)
    return table.clone(u2);
end;

function v1.Init(p18) -- Line: 130
    -- upvalues: Networking (copy), applyChangelog (copy)
    Networking.Release.Changelog.OnClientEvent:Connect(applyChangelog);
    local success, result = pcall(function() -- Line: 134
        -- upvalues: Networking (ref)
        return Networking.Release.ChangelogRequest:Fire();
    end);

    if success then
        applyChangelog(result);

        return;
    end;

    warn("[ReleaseChangelogController] initial Release.ChangelogRequest failed:", (tostring(result)));
end;

return v1;