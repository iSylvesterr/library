-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Util);
require(script.Parent.Types);
local Promise = require(script.Parent.Parent.Promise);
local ClientRemoteSignal = require(script.ClientRemoteSignal);
local ClientRemoteProperty = require(script.ClientRemoteProperty);

return {
    GetFunction = function(p1, p2, p3, u4, u5) -- Line: 9, Name: GetFunction
        -- upvalues: Util (copy), Promise (copy)
        assert(not Util.IsServer, "GetFunction must be called from the client");
        local u6 = Util.GetCommSubFolder(p1, "RF"):Expect("Failed to get Comm RF folder"):WaitForChild(p2, Util.WaitForChildTimeout);
        assert(u6 ~= nil, "Failed to find RemoteFunction: " .. p2);
        local v7;

        if type(u4) == "table" then
            v7 = #u4 > 0;
        else
            v7 = false;
        end;

        local u8;

        if type(u5) == "table" then
            u8 = #u5 > 0;
        else
            u8 = false;
        end;

        local function ProcessOutbound(p9) -- Line: 22
            -- upvalues: u5 (copy)
            for _, v in ipairs(u5) do
                local v10 = table.pack(v(p9));

                if not v10[1] then
                    return table.unpack(v10, 2, v10.n);
                end;

                p9.n = #p9;
            end;

            return table.unpack(p9, 1, p9.n);
        end;

        return v7 and (p3 and function(...) -- Line: 34
            -- upvalues: Promise (ref), u8 (copy), u6 (copy), ProcessOutbound (copy), u4 (copy)
            local u11 = table.pack(...);

            return Promise.new(function(p12, p13) -- Line: 36
                -- upvalues: u8 (ref), u6 (ref), ProcessOutbound (ref), u11 (copy), u4 (ref)
                local success, result = pcall(function() -- Line: 37
                    -- upvalues: u8 (ref), u6 (ref), ProcessOutbound (ref), u11 (ref)
                    if u8 then
                        return table.pack(u6:InvokeServer(ProcessOutbound(u11)));
                    end;

                    return table.pack(u6:InvokeServer(table.unpack(u11, 1, u11.n)));
                end);

                if not success then
                    p13(result);

                    return;
                end;

                for _, v in ipairs(u4) do
                    local v14 = table.pack(v(result));

                    if not v14[1] then
                        return table.unpack(v14, 2, v14.n);
                    end;

                    result.n = #result;
                end;

                p12(table.unpack(result, 1, result.n));
            end);
        end or function(...) -- Line: 59
            -- upvalues: u8 (copy), u6 (copy), ProcessOutbound (copy), u4 (copy)
            local v15;

            if u8 then
                v15 = table.pack(u6:InvokeServer(ProcessOutbound(table.pack(...))));
            else
                v15 = table.pack(u6:InvokeServer(...));
            end;

            for _, v in ipairs(u4) do
                local v16 = table.pack(v(v15));

                if not v16[1] then
                    return table.unpack(v16, 2, v16.n);
                end;

                v15.n = #v15;
            end;

            return table.unpack(v15, 1, v15.n);
        end) or (p3 and function(...) -- Line: 78
            -- upvalues: Promise (ref), u8 (copy), u6 (copy), ProcessOutbound (copy)
            local u17 = table.pack(...);

            return Promise.new(function(p18, p19) -- Line: 80
                -- upvalues: u8 (ref), u6 (ref), ProcessOutbound (ref), u17 (copy)
                local success, result = pcall(function() -- Line: 81
                    -- upvalues: u8 (ref), u6 (ref), ProcessOutbound (ref), u17 (ref)
                    if u8 then
                        return table.pack(u6:InvokeServer(ProcessOutbound(u17)));
                    end;

                    return table.pack(u6:InvokeServer(table.unpack(u17, 1, u17.n)));
                end);

                if success then
                    p18(table.unpack(result, 1, result.n));

                    return;
                end;

                p19(result);
            end);
        end or (u8 and function(...) -- Line: 97
            -- upvalues: u6 (copy), ProcessOutbound (copy)
            return u6:InvokeServer(ProcessOutbound(table.pack(...)));
        end or function(...) -- Line: 101
            -- upvalues: u6 (copy)
            return u6:InvokeServer(...);
        end));
    end,

    GetSignal = function(p20, p21, p22, p23) -- Line: 109, Name: GetSignal
        -- upvalues: Util (copy), ClientRemoteSignal (copy)
        assert(not Util.IsServer, "GetSignal must be called from the client");
        local v24 = Util.GetCommSubFolder(p20, "RE"):Expect("Failed to get Comm RE folder"):WaitForChild(p21, Util.WaitForChildTimeout);
        assert(v24 ~= nil, "Failed to find RemoteEvent: " .. p21);

        return ClientRemoteSignal.new(v24, p22, p23);
    end,

    GetProperty = function(p25, p26, p27, p28) -- Line: 122, Name: GetProperty
        -- upvalues: Util (copy), ClientRemoteProperty (copy)
        assert(not Util.IsServer, "GetProperty must be called from the client");
        local v29 = Util.GetCommSubFolder(p25, "RP"):Expect("Failed to get Comm RP folder"):WaitForChild(p26, Util.WaitForChildTimeout);
        assert(v29 ~= nil, "Failed to find RemoteEvent for RemoteProperty: " .. p26);

        return ClientRemoteProperty.new(v29, p27, p28);
    end
};