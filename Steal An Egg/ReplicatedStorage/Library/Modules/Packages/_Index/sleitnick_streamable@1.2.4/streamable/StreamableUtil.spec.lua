-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local Streamable = require(script.Parent.Streamable);
    local StreamableUtil = require(script.Parent.StreamableUtil);
    local u1 = nil;

    local function CreateInstance(p2) -- Line: 7
        -- upvalues: u1 (ref)
        local Folder = Instance.new("Folder");
        Folder.Name = p2;
        Folder.Archivable = false;
        Folder.Parent = u1;

        return Folder;
    end;

    beforeAll(function() -- Line: 15
        -- upvalues: u1 (ref)
        u1 = Instance.new("Folder");
        u1.Name = "KnitTest";
        u1.Archivable = false;
        u1.Parent = workspace;
    end);
    afterEach(function() -- Line: 22
        -- upvalues: u1 (ref)
        u1:ClearAllChildren();
    end);
    afterAll(function() -- Line: 26
        -- upvalues: u1 (ref)
        u1:Destroy();
    end);
    describe("Compound", function() -- Line: 30
        -- upvalues: Streamable (copy), u1 (ref), StreamableUtil (copy)
        it("should capture multiple streams", function() -- Line: 31
            -- upvalues: Streamable (ref), u1 (ref), StreamableUtil (ref)
            local v3 = Streamable.new(u1, "ABC");
            local v4 = Streamable.new(u1, "XYZ");
            local u5 = 0;
            local u6 = 0;
            StreamableUtil.Compound({
                S1 = v3,
                S2 = v4
            }, function(p7, p8) -- Line: 36
                -- upvalues: u5 (ref), u6 (ref)
                u5 = u5 + 1;
                p8:Add(function() -- Line: 38
                    -- upvalues: u6 (ref)
                    u6 = u6 + 1;
                end);
            end);
            local Folder = Instance.new("Folder");
            Folder.Name = "ABC";
            Folder.Archivable = false;
            Folder.Parent = u1;
            local Folder2 = Instance.new("Folder");
            Folder2.Name = "XYZ";
            Folder2.Archivable = false;
            Folder2.Parent = u1;
            task.wait();
            Folder.Parent = nil;
            task.wait();
            Folder.Parent = u1;
            task.wait();
            Folder.Parent = nil;
            Folder2.Parent = nil;
            task.wait();
            Folder2.Parent = u1;
            task.wait();
            expect(u5).to.equal(2);
            expect(u6).to.equal(2);
            v3:Destroy();
            v4:Destroy();
        end);
    end);
end;