-- Decompiled with Potassium's decompiler.

local ServerScriptService = game:GetService("ServerScriptService");
require(ServerScriptService.TestRunner.Test);

local function AwaitCondition(p1, p2) -- Line: 5
    local v3 = os.clock();
    local v4 = p2 or 10;

    while not p1() do
        if v4 < os.clock() - v3 then
            return false;
        end;

        task.wait();
    end;

    return true;
end;

return function(u5) -- Line: 19
    -- upvalues: AwaitCondition (copy)
    local Parent = require(script.Parent);
    local u6 = nil;

    local function NumConns(p7) -- Line: 24
        -- upvalues: u6 (ref)
        return #(p7 or u6):GetConnections();
    end;

    u5:BeforeEach(function() -- Line: 29
        -- upvalues: u6 (ref), Parent (copy)
        u6 = Parent.new();
    end);
    u5:AfterEach(function() -- Line: 33
        -- upvalues: u6 (ref)
        u6:Destroy();
    end);
    u5:Describe("Constructor", function() -- Line: 37
        -- upvalues: u5 (copy), Parent (copy), u6 (ref), AwaitCondition (ref)
        u5:Test("should create a new signal and fire it", function() -- Line: 38
            -- upvalues: u5 (ref), Parent (ref), u6 (ref)
            u5:Expect(Parent.Is(u6)):ToBe(true);
            task.defer(function() -- Line: 40
                -- upvalues: u6 (ref)
                u6:Fire(10, 20);
            end);
            local v8, v9 = u6:Wait();
            u5:Expect(v8):ToBe(10);
            u5:Expect(v9):ToBe(20);
        end);
        u5:Test("should create a proxy signal and connect to it", function() -- Line: 48
            -- upvalues: Parent (ref), u5 (ref), AwaitCondition (ref)
            local v10 = Parent.Wrap(game:GetService("RunService").Heartbeat);
            u5:Expect(Parent.Is(v10)):ToBe(true);
            local u11 = false;
            v10:Connect(function() -- Line: 52
                -- upvalues: u11 (ref)
                u11 = true;
            end);
            u5:Expect(AwaitCondition(function() -- Line: 55
                -- upvalues: u11 (ref)
                return u11;
            end, 2)):ToBe(true);
            v10:Destroy();
        end);
    end);
    u5:Describe("FireDeferred", function() -- Line: 62
        -- upvalues: u5 (copy), u6 (ref), AwaitCondition (ref)
        u5:Test("should be able to fire primitive argument", function() -- Line: 63
            -- upvalues: u6 (ref), u5 (ref), AwaitCondition (ref)
            local u12 = nil;
            u6:Connect(function(p13) -- Line: 66
                -- upvalues: u12 (ref)
                u12 = p13;
            end);
            u6:FireDeferred(10);
            u5:Expect(AwaitCondition(function() -- Line: 70
                -- upvalues: u12 (ref)
                return u12 == 10;
            end, 1)):ToBe(true);
        end);
        u5:Test("should be able to fire a reference based argument", function() -- Line: 75
            -- upvalues: u6 (ref), u5 (ref), AwaitCondition (ref)
            local u14 = { 10, 20 };
            local u15 = nil;
            u6:Connect(function(p16) -- Line: 78
                -- upvalues: u15 (ref)
                u15 = p16;
            end);
            u6:FireDeferred(u14);
            u5:Expect(AwaitCondition(function() -- Line: 82
                -- upvalues: u14 (copy), u15 (ref)
                return u14 == u15;
            end, 1)):ToBe(true);
        end);
    end);
    u5:Describe("Fire", function() -- Line: 88
        -- upvalues: u5 (copy), u6 (ref)
        u5:Test("should be able to fire primitive argument", function() -- Line: 89
            -- upvalues: u6 (ref), u5 (ref)
            local u17 = nil;
            u6:Connect(function(p18) -- Line: 92
                -- upvalues: u17 (ref)
                u17 = p18;
            end);
            u6:Fire(10);
            u5:Expect(u17):ToBe(10);
        end);
        u5:Test("should be able to fire a reference based argument", function() -- Line: 99
            -- upvalues: u6 (ref), u5 (ref)
            local v19 = { 10, 20 };
            local u20 = nil;
            u6:Connect(function(p21) -- Line: 102
                -- upvalues: u20 (ref)
                u20 = p21;
            end);
            u6:Fire(v19);
            u5:Expect(u20):ToBe(v19);
        end);
    end);
    u5:Describe("ConnectOnce", function() -- Line: 110
        -- upvalues: u5 (copy), u6 (ref)
        u5:Test("should only capture first fire", function() -- Line: 111
            -- upvalues: u6 (ref), u5 (ref)
            local u22 = nil;
            local v24 = u6:ConnectOnce(function(p23) -- Line: 113
                -- upvalues: u22 (ref)
                u22 = p23;
            end);
            u5:Expect(v24.Connected):ToBe(true);
            u6:Fire(10);
            u5:Expect(v24.Connected):ToBe(false);
            u6:Fire(20);
            u5:Expect(u22):ToBe(10);
        end);
    end);
    u5:Describe("Wait", function() -- Line: 124
        -- upvalues: u5 (copy), u6 (ref)
        u5:Test("should be able to wait for a signal to fire", function() -- Line: 125
            -- upvalues: u6 (ref), u5 (ref)
            task.defer(function() -- Line: 126
                -- upvalues: u6 (ref)
                u6:Fire(10, 20, 30);
            end);
            local v25, v26, v27 = u6:Wait();
            u5:Expect(v25):ToBe(10);
            u5:Expect(v26):ToBe(20);
            u5:Expect(v27):ToBe(30);
        end);
    end);
    u5:Describe("DisconnectAll", function() -- Line: 136
        -- upvalues: u5 (copy), u6 (ref)
        u5:Test("should disconnect all connections", function() -- Line: 137
            -- upvalues: u6 (ref), u5 (ref)
            u6:Connect(function() -- Line: 138
            end);
            u6:Connect(function() -- Line: 139
            end);
            u5:Expect(#(nil or u6):GetConnections()):ToBe(2);
            u6:DisconnectAll();
            u5:Expect(#(nil or u6):GetConnections()):ToBe(0);
        end);
    end);
    u5:Describe("Disconnect", function() -- Line: 146
        -- upvalues: u5 (copy), u6 (ref), AwaitCondition (ref)
        u5:Test("should disconnect connection", function() -- Line: 147
            -- upvalues: u6 (ref), u5 (ref)
            local v28 = u6:Connect(function() -- Line: 148
            end);
            u5:Expect(#(nil or u6):GetConnections()):ToBe(1);
            v28:Disconnect();
            u5:Expect(#(nil or u6):GetConnections()):ToBe(0);
        end);
        u5:Test("should still work if connections disconnected while firing", function() -- Line: 154
            -- upvalues: u6 (ref), u5 (ref)
            local u29 = 0;
            local u30 = nil;
            u6:Connect(function() -- Line: 157
                -- upvalues: u29 (ref)
                u29 = u29 + 1;
            end);
            u30 = u6:Connect(function() -- Line: 160
                -- upvalues: u30 (ref), u29 (ref)
                u30:Disconnect();
                u29 = u29 + 1;
            end);
            u6:Connect(function() -- Line: 164
                -- upvalues: u29 (ref)
                u29 = u29 + 1;
            end);
            u6:Fire();
            u5:Expect(u29):ToBe(3);
        end);
        u5:Test("should still work if connections disconnected while firing deferred", function() -- Line: 171
            -- upvalues: u6 (ref), u5 (ref), AwaitCondition (ref)
            local u31 = 0;
            local u32 = nil;
            u6:Connect(function() -- Line: 174
                -- upvalues: u31 (ref)
                u31 = u31 + 1;
            end);
            u32 = u6:Connect(function() -- Line: 177
                -- upvalues: u32 (ref), u31 (ref)
                u32:Disconnect();
                u31 = u31 + 1;
            end);
            u6:Connect(function() -- Line: 181
                -- upvalues: u31 (ref)
                u31 = u31 + 1;
            end);
            u6:FireDeferred();
            u5:Expect(AwaitCondition(function() -- Line: 185
                -- upvalues: u31 (ref)
                return u31 == 3;
            end)):ToBe(true);
        end);
    end);
end;