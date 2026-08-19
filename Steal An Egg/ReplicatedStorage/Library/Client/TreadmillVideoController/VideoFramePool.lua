-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
require(script.Parent.Types.Interface);
local u1 = Log.new();
local v2 = {};

local function clearSlot(p3) -- Line: 47
    p3.Frame:Pause();
    p3.Frame.TimePosition = 0;
    p3.Frame.Volume = 0;
    p3.Frame.Visible = false;
    p3.Frame.Video = "";
    p3.MediaIndex = nil;
    p3.VideoUri = nil;
end;

local function assignSlot(p4, p5, p6) -- Line: 57
    if p4.MediaIndex == p5 and p4.VideoUri == p6.Video then
        return;
    end;

    p4.Frame:Pause();
    p4.Frame.TimePosition = 0;
    p4.Frame.Volume = 0;
    p4.Frame.Visible = false;
    p4.Frame.Video = "";
    p4.MediaIndex = nil;
    p4.VideoUri = nil;
    p4.MediaIndex = p5;
    p4.VideoUri = p6.Video;
    p4.Frame.Video = p6.Video;
end;

local function primeHiddenSlot(u7, p8, p9) -- Line: 68
    -- upvalues: u1 (copy)
    if u7.MediaIndex ~= p8 or u7.VideoUri ~= p9.Video then
        u7.Frame:Pause();
        u7.Frame.TimePosition = 0;
        u7.Frame.Volume = 0;
        u7.Frame.Visible = false;
        u7.Frame.Video = "";
        u7.MediaIndex = nil;
        u7.VideoUri = nil;
        u7.MediaIndex = p8;
        u7.VideoUri = p9.Video;
        u7.Frame.Video = p9.Video;
    end;

    u7.Frame.Visible = false;
    u7.Frame.Volume = 0;
    u7.Frame.TimePosition = 0;
    local success, result = pcall(function() -- Line: 74
        -- upvalues: u7 (copy)
        u7.Frame:Play();
        u7.Frame:Pause();
        u7.Frame.TimePosition = 0;
    end);

    if success then
        return true;
    end;

    u1:AtWarning():Log((`Failed to prime treadmill VideoFrame {p9.Video}: {result}`));

    return false;
end;

local function createCloneSlot(p10, p11) -- Line: 87
    local v12 = p10:Clone();
    v12.Name = `MainVideoPreload{p11}`;
    v12.Visible = false;
    v12.Video = "";
    v12.Volume = 0;
    v12.TimePosition = 0;
    v12.Parent = p10.Parent;

    return {
        MediaIndex = nil,
        VideoUri = nil,
        Frame = v12
    };
end;

function v2.new(u13) -- Line: 107
    -- upvalues: primeHiddenSlot (copy)
    local u14 = {
        {
            MediaIndex = nil,
            VideoUri = nil,
            Frame = u13
        }
    };
    local u15 = nil;
    local u16 = false;
    local v17 = u13:Clone();
    v17.Name = `MainVideoPreload{2}`;
    v17.Visible = false;
    v17.Video = "";
    v17.Volume = 0;
    v17.TimePosition = 0;
    v17.Parent = u13.Parent;
    table.insert(u14, {
        MediaIndex = nil,
        VideoUri = nil,
        Frame = v17
    });
    local v18 = u13:Clone();
    v18.Name = `MainVideoPreload{3}`;
    v18.Visible = false;
    v18.Video = "";
    v18.Volume = 0;
    v18.TimePosition = 0;
    v18.Parent = u13.Parent;
    table.insert(u14, {
        MediaIndex = nil,
        VideoUri = nil,
        Frame = v18
    });

    local function findSlotByMediaIndex(p19) -- Line: 122
        -- upvalues: u14 (copy)
        for _, v in u14 do
            if v.MediaIndex == p19 then
                return v;
            end;
        end;

        return nil;
    end;

    local function acquireInactiveSlot(p20) -- Line: 132
        -- upvalues: u14 (copy), u15 (ref)
        for _, v in u14 do
            if v.MediaIndex == p20 then
                break;
            end;
        end;

        if v ~= nil then
            return v;
        end;

        for _, v in u14 do
            if v ~= u15 and v.MediaIndex == nil then
                return v;
            end;
        end;

        for _, v in u14 do
            if v ~= u15 then
                v.Frame:Pause();
                v.Frame.TimePosition = 0;
                v.Frame.Volume = 0;
                v.Frame.Visible = false;
                v.Frame.Video = "";
                v.MediaIndex = nil;
                v.VideoUri = nil;

                return v;
            end;
        end;

        error("Treadmill VideoFrame pool has no inactive slot available");
    end;

    return {
        Activate = function(p21, p22) -- Line: 212, Name: activate
            -- upvalues: u16 (ref), u13 (copy), u14 (copy), acquireInactiveSlot (copy), u15 (ref)
            if u16 then
                return u13;
            end;

            for _, v in u14 do
                if v.MediaIndex == p21 then
                    break;
                end;
            end;

            local v23 = v or acquireInactiveSlot(p21);

            if v23.MediaIndex ~= p21 or v23.VideoUri ~= p22.Video then
                v23.Frame:Pause();
                v23.Frame.TimePosition = 0;
                v23.Frame.Volume = 0;
                v23.Frame.Visible = false;
                v23.Frame.Video = "";
                v23.MediaIndex = nil;
                v23.VideoUri = nil;
                v23.MediaIndex = p21;
                v23.VideoUri = p22.Video;
                v23.Frame.Video = p22.Video;
            end;

            for _, v in u14 do
                v.Frame.Visible = v == v23;

                if v ~= v23 then
                    v.Frame:Pause();
                    v.Frame.Volume = 0;
                    v.Frame.TimePosition = 0;
                end;
            end;

            u15 = v23;
            v23.Frame.Volume = p22.Volume or 1;
            v23.Frame.TimePosition = 0;

            return v23.Frame;
        end,

        ClearActive = function() -- Line: 163, Name: clearActive
            -- upvalues: u15 (ref)
            local v24 = u15;
            u15 = nil;

            if v24 == nil then
                return;
            end;

            v24.Frame:Pause();
            v24.Frame.TimePosition = 0;
            v24.Frame.Volume = 0;
            v24.Frame.Visible = false;
            v24.Frame.Video = "";
            v24.MediaIndex = nil;
            v24.VideoUri = nil;
        end,

        ClearAll = function() -- Line: 235, Name: clearAll
            -- upvalues: u15 (ref), u14 (copy)
            u15 = nil;

            for _, v in u14 do
                v.Frame:Pause();
                v.Frame.TimePosition = 0;
                v.Frame.Volume = 0;
                v.Frame.Visible = false;
                v.Frame.Video = "";
                v.MediaIndex = nil;
                v.VideoUri = nil;
            end;
        end,

        Destroy = function() -- Line: 242, Name: destroy
            -- upvalues: u16 (ref), u15 (ref), u14 (copy)
            u16 = true;
            u15 = nil;

            for _, v in u14 do
                v.Frame:Pause();
                v.Frame.TimePosition = 0;
                v.Frame.Volume = 0;
                v.Frame.Visible = false;
                v.Frame.Video = "";
                v.MediaIndex = nil;
                v.VideoUri = nil;
            end;

            for i = 2, #u14 do
                u14[i].Frame:Destroy();
            end;
        end,

        GetActiveFrame = function() -- Line: 154, Name: getActiveFrame
            -- upvalues: u15 (ref), u13 (copy)
            local v25 = u15;

            if v25 == nil then
                return u13;
            end;

            return v25.Frame;
        end,

        Preload = function(p26) -- Line: 173, Name: preload
            -- upvalues: u16 (ref), u15 (ref), u14 (copy), acquireInactiveSlot (copy), primeHiddenSlot (ref)
            if u16 then
                return;
            end;

            local v27 = u15 == nil and 3 or 2;
            local v28 = 0;
            local v29 = {};

            for _, v in ipairs(p26) do
                if v27 <= v28 then
                    break;
                end;

                v29[v.MediaIndex] = v.MediaEntry;
                v28 = v28 + 1;
            end;

            for _, v in u14 do
                if v ~= u15 and (v.MediaIndex ~= nil and v29[v.MediaIndex] == nil) then
                    v.Frame:Pause();
                    v.Frame.TimePosition = 0;
                    v.Frame.Volume = 0;
                    v.Frame.Visible = false;
                    v.Frame.Video = "";
                    v.MediaIndex = nil;
                    v.VideoUri = nil;
                end;
            end;

            for _, v in ipairs(p26) do
                if v29[v.MediaIndex] == nil then
                    break;
                end;

                task.spawn(function() -- Line: 201
                    -- upvalues: u16 (ref), acquireInactiveSlot (ref), v (copy), primeHiddenSlot (ref)
                    if u16 then
                        return;
                    end;

                    primeHiddenSlot(acquireInactiveSlot(v.MediaIndex), v.MediaIndex, v.MediaEntry);
                end);
            end;
        end
    };
end;

return v2;