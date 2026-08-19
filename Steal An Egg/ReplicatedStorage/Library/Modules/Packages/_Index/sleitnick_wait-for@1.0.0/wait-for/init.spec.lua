-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local Parent = require(script.Parent);
    local Promise = require(script.Parent.Parent.Promise);
    local u1 = {};

    local function Create(p2, p3) -- Line: 7
        -- upvalues: u1 (copy)
        local Folder = Instance.new("Folder");
        Folder.Name = p2;
        Folder.Parent = p3;
        table.insert(u1, Folder);

        return Folder;
    end;

    afterEach(function() -- Line: 15
        -- upvalues: u1 (copy)
        for _, v in ipairs(u1) do
            task.delay(0, function() -- Line: 17
                -- upvalues: v (copy)
                v:Destroy();
            end);
        end;

        table.clear(u1);
    end);
    describe("WaitFor", function() -- Line: 24
        -- upvalues: Create (copy), Parent (copy), u1 (copy), Promise (copy)
        it("should wait for child", function() -- Line: 25
            -- upvalues: Create (ref), Parent (ref)
            local v4 = workspace;
            task.delay(0.1, Create, "TestChild", v4);
            local v5, v6 = Parent.Child(v4, "TestChild"):await();
            expect(v5).to.equal(true);
            expect((typeof(v6))).to.equal("Instance");
            expect(v6.Name).to.equal("TestChild");
            expect(v6.Parent).to.equal(v4);
        end);
        it("should stop waiting for child if parent is unparented", function() -- Line: 38
            -- upvalues: u1 (ref), Parent (ref)
            local v7 = workspace;
            local Folder = Instance.new("Folder");
            Folder.Name = "SomeParent";
            Folder.Parent = v7;
            table.insert(u1, Folder);
            task.delay(0.1, function() -- Line: 42
                -- upvalues: Folder (copy)
                Folder:Destroy();
            end);
            local v8, v9 = Parent.Child(Folder, "TestChild"):await();
            expect(v8).to.equal(false);
            expect(v9).to.equal(Parent.Error.Unparented);
        end);
        it("should stop waiting for child if timeout is reached", function() -- Line: 51
            -- upvalues: Parent (ref), Promise (ref)
            local v10, v11 = Parent.Child(workspace, "InstanceThatDoesNotExist", 0.1):await();
            expect(v10).to.equal(false);
            expect(Promise.Error.isKind(v11, Promise.Error.Kind.TimedOut)).to.equal(true);
        end);
        it("should wait for children", function() -- Line: 57
            -- upvalues: Create (ref), Parent (ref)
            local v12 = workspace;
            local v13 = { "TestChild01", "TestChild02", "TestChild03" };
            task.delay(0.1, Create, v13[1], v12);
            task.delay(0.2, Create, v13[2], v12);
            task.delay(0.05, Create, v13[3], v12);
            local v14, v15 = Parent.Children(v12, v13):await();
            expect(v14).to.equal(true);

            for i, v in ipairs(v15) do
                expect((typeof(v))).to.equal("Instance");
                expect(v.Name).to.equal(v13[i]);
                expect(v.Parent).to.equal(v12);
            end;
        end);
        it("should fail if any children are no longer parented in parent", function() -- Line: 74
            -- upvalues: Create (ref), u1 (ref), Parent (ref)
            local u16 = workspace;
            local u17 = { "TestChild04", "TestChild05", "TestChild06" };
            local u18 = nil;
            task.delay(0.1, Create, u17[1], u16);
            task.delay(0.2, Create, u17[2], u16);
            task.delay(0.05, function() -- Line: 82
                -- upvalues: u18 (ref), u17 (copy), u16 (copy), u1 (ref)
                local v19 = u17[3];
                local Folder = Instance.new("Folder");
                Folder.Name = v19;
                Folder.Parent = u16;
                table.insert(u1, Folder);
                u18 = Folder;
            end);
            task.delay(0.1, function() -- Line: 85
                -- upvalues: u18 (ref)
                u18:Destroy();
            end);
            local v20, v21 = Parent.Children(u16, u17):await();
            expect(v20).to.equal(false);
            expect(v21).to.equal(Parent.Error.ParentChanged);
        end);
        it("should wait for descendant", function() -- Line: 94
            -- upvalues: Create (ref), u1 (ref), Parent (ref)
            local v22 = workspace;
            local delay = task.delay;
            local Folder = Instance.new("Folder");
            Folder.Name = "TestFolder";
            Folder.Parent = v22;
            table.insert(u1, Folder);
            delay(0.1, Create, "TestDescendant", Folder);
            local v23, v24 = Parent.Descendant(v22, "TestDescendant"):await();
            expect(v23).to.equal(true);
            expect((typeof(v24))).to.equal("Instance");
            expect(v24.Name).to.equal("TestDescendant");
            expect(v24:IsDescendantOf(v22)).to.equal(true);
        end);
        it("should wait for many descendants", function() -- Line: 107
            -- upvalues: Create (ref), u1 (ref), Parent (ref)
            local v25 = workspace;
            local v26 = { "TestDescendant01", "TestDescendant02", "TestDescendant03" };
            local delay = task.delay;
            local v27 = v26[1];
            local Folder = Instance.new("Folder");
            Folder.Name = "TestFolder1";
            Folder.Parent = v25;
            table.insert(u1, Folder);
            delay(0.1, Create, v27, Folder);
            local delay2 = task.delay;
            local v28 = v26[2];
            local Folder2 = Instance.new("Folder");
            Folder2.Name = "TestFolder2";
            Folder2.Parent = v25;
            table.insert(u1, Folder2);
            delay2(0.05, Create, v28, Folder2);
            local delay3 = task.delay;
            local v29 = v26[3];
            local Folder3 = Instance.new("Folder");
            Folder3.Name = "TestFolder3";
            Folder3.Parent = v25;
            table.insert(u1, Folder3);
            local Folder4 = Instance.new("Folder");
            Folder4.Name = "TestFolder4";
            Folder4.Parent = Folder3;
            table.insert(u1, Folder4);
            delay3(0.2, Create, v29, Folder4);
            local v30, v31 = Parent.Descendants(v25, v26):await();
            expect(v30).to.equal(true);

            for i, v in ipairs(v31) do
                expect((typeof(v))).to.equal("Instance");
                expect(v.Name == v26[i]).to.equal(true);
                expect(v:IsDescendantOf(v25)).to.equal(true);
            end;
        end);
        it("should wait for primarypart", function() -- Line: 124
            -- upvalues: Parent (ref)
            local Model = Instance.new("Model");
            local Part = Instance.new("Part");
            Part.Anchored = true;
            Part.Parent = Model;
            Model.Parent = workspace;
            task.delay(0.1, function() -- Line: 132
                -- upvalues: Model (copy), Part (copy)
                Model.PrimaryPart = Part;
            end);
            local v32, v33 = Parent.PrimaryPart(Model):await();
            expect(v32).to.equal(true);
            expect((typeof(v33))).to.equal("Instance");
            expect(v33).to.equal(Part);
            expect(Model.PrimaryPart).to.equal(v33);
            Model:Destroy();
        end);
        it("should wait for objectvalue", function() -- Line: 145
            -- upvalues: u1 (ref), Parent (ref)
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Parent = workspace;
            local v34 = workspace;
            local Folder = Instance.new("Folder");
            Folder.Name = "SomeInstance";
            Folder.Parent = v34;
            table.insert(u1, Folder);
            task.delay(0.1, function() -- Line: 151
                -- upvalues: ObjectValue (copy), Folder (copy)
                ObjectValue.Value = Folder;
            end);
            local v35, v36 = Parent.ObjectValue(ObjectValue):await();
            expect(v35).to.equal(true);
            expect((typeof(v36))).to.equal("Instance");
            expect(v36).to.equal(Folder);
            expect(ObjectValue.Value == v36);
            ObjectValue:Destroy();
        end);
        it("should wait for custom predicate", function() -- Line: 164
            -- upvalues: u1 (ref), Parent (ref)
            local u37 = nil;
            task.delay(0.1, function() -- Line: 166
                -- upvalues: u37 (ref), u1 (ref)
                local v38 = workspace;
                local Folder = Instance.new("Folder");
                Folder.Name = "CustomInstance";
                Folder.Parent = v38;
                table.insert(u1, Folder);
                u37 = Folder;
            end);
            local v39, v40 = Parent.Custom(function() -- Line: 170
                -- upvalues: u37 (ref)
                return u37;
            end):await();
            expect(v39).to.equal(true);
            expect((typeof(v40))).to.equal("Instance");
            expect(v40).to.equal(u37);
        end);
    end);
end;