-- Decompiled with Potassium's decompiler.

return function() -- Line: 1
    local Parent = require(script.Parent);
    local CollectionService = game:GetService("CollectionService");
    local RunService = game:GetService("RunService");
    local u1 = nil;

    local function CreateTaggedInstance() -- Line: 11
        -- upvalues: CollectionService (copy), u1 (ref)
        local Folder = Instance.new("Folder");
        CollectionService:AddTag(Folder, "__KnitTestComponent__");
        Folder.Name = "ComponentTest";
        Folder.Archivable = false;
        Folder.Parent = u1;

        return Folder;
    end;

    local u9 = Parent.new({
        Tag = "__KnitTestComponent__",
        Ancestors = { workspace, game:GetService("Lighting") },
        Extensions = {
            {
                ShouldConstruct = function(p2) -- Line: 21, Name: ShouldConstruct
                    return true;
                end,

                Constructing = function(p3) -- Line: 24, Name: Constructing
                    p3.Data = "a";
                    p3.DidHeartbeat = false;
                    p3.DidStepped = false;
                    p3.DidRenderStepped = false;
                end,

                Constructed = function(p4) -- Line: 30, Name: Constructed
                    p4.Data = p4.Data .. "c";
                end,

                Starting = function(p5) -- Line: 33, Name: Starting
                    p5.Data = p5.Data .. "d";
                end,

                Started = function(p6) -- Line: 36, Name: Started
                    p6.Data = p6.Data .. "f";
                end,

                Stopping = function(p7) -- Line: 39, Name: Stopping
                    p7.Data = p7.Data .. "g";
                end,

                Stopped = function(p8) -- Line: 42, Name: Stopped
                    p8.Data = p8.Data .. "i";
                end
            }
        }
    });
    local u10 = Parent.new({
        Tag = "__KnitTestComponent__"
    });

    function u10.GetData(p11) -- Line: 53
        return true;
    end;

    function u9.Construct(p12) -- Line: 57
        p12.Data = p12.Data .. "b";
    end;

    function u9.Start(p13) -- Line: 61
        -- upvalues: u10 (copy)
        p13.Another = p13:GetComponent(u10);
        p13.Data = p13.Data .. "e";
    end;

    function u9.Stop(p14) -- Line: 66
        p14.Data = p14.Data .. "h";
    end;

    function u9.HeartbeatUpdate(p15, p16) -- Line: 70
        p15.DidHeartbeat = true;
    end;

    function u9.SteppedUpdate(p17, p18) -- Line: 74
        p17.DidStepped = true;
    end;

    function u9.RenderSteppedUpdate(p19, p20) -- Line: 78
        p19.DidRenderStepped = true;
    end;

    beforeAll(function() -- Line: 82
        -- upvalues: u1 (ref)
        u1 = Instance.new("Folder");
        u1.Name = "KnitComponentTest";
        u1.Archivable = false;
        u1.Parent = workspace;
    end);
    afterEach(function() -- Line: 89
        -- upvalues: u1 (ref)
        u1:ClearAllChildren();
    end);
    afterAll(function() -- Line: 93
        -- upvalues: u1 (ref), u9 (copy)
        u1:Destroy();
        u9:Destroy();
    end);
    describe("Component", function() -- Line: 98
        -- upvalues: u9 (copy), CollectionService (copy), u1 (ref), RunService (copy), Parent (copy)
        it("should capture start and stop events", function() -- Line: 99
            -- upvalues: u9 (ref), CollectionService (ref), u1 (ref)
            local u21 = 0;
            local u22 = 0;
            local v23 = u9.Started:Connect(function() -- Line: 102
                -- upvalues: u21 (ref)
                u21 = u21 + 1;
            end);
            local v24 = u9.Stopped:Connect(function() -- Line: 105
                -- upvalues: u22 (ref)
                u22 = u22 + 1;
            end);
            local Folder = Instance.new("Folder");
            CollectionService:AddTag(Folder, "__KnitTestComponent__");
            Folder.Name = "ComponentTest";
            Folder.Archivable = false;
            Folder.Parent = u1;
            task.wait();
            Folder:Destroy();
            task.wait();
            v23:Disconnect();
            v24:Disconnect();
            expect(u21).to.equal(1);
            expect(u22).to.equal(1);
        end);
        it("should be able to get component from the instance", function() -- Line: 118
            -- upvalues: CollectionService (ref), u1 (ref), u9 (ref)
            local Folder = Instance.new("Folder");
            CollectionService:AddTag(Folder, "__KnitTestComponent__");
            Folder.Name = "ComponentTest";
            Folder.Archivable = false;
            Folder.Parent = u1;
            task.wait();
            local v25 = u9:FromInstance(Folder);
            expect(v25).to.be.ok();
        end);
        it("should be able to get all component instances existing", function() -- Line: 125
            -- upvalues: CollectionService (ref), u1 (ref), u9 (ref)
            local v26 = table.create(3);
            local Folder = Instance.new("Folder");
            CollectionService:AddTag(Folder, "__KnitTestComponent__");
            Folder.Name = "ComponentTest";
            Folder.Archivable = false;
            Folder.Parent = u1;
            v26[1] = Folder;
            local Folder2 = Instance.new("Folder");
            CollectionService:AddTag(Folder2, "__KnitTestComponent__");
            Folder2.Name = "ComponentTest";
            Folder2.Archivable = false;
            Folder2.Parent = u1;
            v26[2] = Folder2;
            local Folder3 = Instance.new("Folder");
            CollectionService:AddTag(Folder3, "__KnitTestComponent__");
            Folder3.Name = "ComponentTest";
            Folder3.Archivable = false;
            Folder3.Parent = u1;
            v26[3] = Folder3;
            task.wait();
            local v27 = u9:GetAll();
            expect(v27).to.be.a("table");
            expect(#v27).to.equal(3);

            for _, v in ipairs(v27) do
                expect(table.find(v26, v.Instance)).to.be.ok();
            end;
        end);
        it("should call lifecycle methods and extension functions", function() -- Line: 141
            -- upvalues: CollectionService (ref), u1 (ref), u9 (ref), RunService (ref)
            local Folder = Instance.new("Folder");
            CollectionService:AddTag(Folder, "__KnitTestComponent__");
            Folder.Name = "ComponentTest";
            Folder.Archivable = false;
            Folder.Parent = u1;
            task.wait(0.2);
            local v28 = u9:FromInstance(Folder);
            expect(v28).to.be.ok();
            expect(v28.Data).to.equal("abcdef");
            expect(v28.DidHeartbeat).to.equal(true);
            expect(v28.DidStepped).to.equal(RunService:IsRunning());
            expect(v28.DidRenderStepped).to.never.equal(true);
            Folder:Destroy();
            task.wait();
            expect(v28.Data).to.equal("abcdefghi");
        end);
        it("should get another component linked to the same instance", function() -- Line: 155
            -- upvalues: CollectionService (ref), u1 (ref), u9 (ref)
            local Folder = Instance.new("Folder");
            CollectionService:AddTag(Folder, "__KnitTestComponent__");
            Folder.Name = "ComponentTest";
            Folder.Archivable = false;
            Folder.Parent = u1;
            task.wait();
            local v29 = u9:FromInstance(Folder);
            expect(v29).to.be.ok();
            expect(v29.Another).to.be.ok();
            expect(v29.Another:GetData()).to.equal(true);
        end);
        it("should use extension to decide whether or not to construct", function() -- Line: 164
            -- upvalues: Parent (ref), CollectionService (ref), u1 (ref)
            local u30 = {
                c = true
            };

            function u30.ShouldConstruct(p31) -- Line: 166
                -- upvalues: u30 (copy)
                return u30.c;
            end;

            local u32 = {
                c = true
            };

            function u32.ShouldConstruct(p33) -- Line: 171
                -- upvalues: u32 (copy)
                return u32.c;
            end;

            local u34 = {
                c = true
            };

            function u34.ShouldConstruct(p35) -- Line: 176
                -- upvalues: u34 (copy)
                return u34.c;
            end;

            local u36 = Parent.new({
                Tag = "__KnitTestComponent__",
                Extensions = { u30 }
            });
            local u37 = Parent.new({
                Tag = "__KnitTestComponent__",
                Extensions = { u30, u32 }
            });
            local u38 = Parent.new({
                Tag = "__KnitTestComponent__",
                Extensions = { u30, u32, u34 }
            });

            local function SetE(p39, p40, p41) -- Line: 184
                -- upvalues: u30 (copy), u32 (copy), u34 (copy)
                u30.c = p39;
                u32.c = p40;
                u34.c = p41;
            end;

            local function Check(p42, p43, p44) -- Line: 190
                local v45 = p43:FromInstance(p42);

                if p44 then
                    expect(v45).to.be.ok();

                    return;
                end;

                expect(v45).to.never.be.ok();
            end;

            local function CreateAndCheckAll(p46, p47, p48) -- Line: 199
                -- upvalues: CollectionService (ref), u1 (ref), Check (copy), u36 (copy), u37 (copy), u38 (copy)
                local Folder = Instance.new("Folder");
                CollectionService:AddTag(Folder, "__KnitTestComponent__");
                Folder.Name = "ComponentTest";
                Folder.Archivable = false;
                Folder.Parent = u1;
                task.wait();
                Check(Folder, u36, p46);
                Check(Folder, u37, p47);
                Check(Folder, u38, p48);
            end;

            u30.c = true;
            u32.c = true;
            u34.c = true;
            local Folder = Instance.new("Folder");
            CollectionService:AddTag(Folder, "__KnitTestComponent__");
            Folder.Name = "ComponentTest";
            Folder.Archivable = false;
            Folder.Parent = u1;
            task.wait();
            local v49 = u36:FromInstance(Folder);
            expect(v49).to.be.ok();
            local v50 = u37:FromInstance(Folder);
            expect(v50).to.be.ok();
            local v51 = u38:FromInstance(Folder);
            expect(v51).to.be.ok();
            u30.c = false;
            u32.c = false;
            u34.c = false;
            local Folder2 = Instance.new("Folder");
            CollectionService:AddTag(Folder2, "__KnitTestComponent__");
            Folder2.Name = "ComponentTest";
            Folder2.Archivable = false;
            Folder2.Parent = u1;
            task.wait();
            local v52 = u36:FromInstance(Folder2);
            expect(v52).to.never.be.ok();
            local v53 = u37:FromInstance(Folder2);
            expect(v53).to.never.be.ok();
            local v54 = u38:FromInstance(Folder2);
            expect(v54).to.never.be.ok();
            u30.c = true;
            u32.c = false;
            u34.c = true;
            local Folder3 = Instance.new("Folder");
            CollectionService:AddTag(Folder3, "__KnitTestComponent__");
            Folder3.Name = "ComponentTest";
            Folder3.Archivable = false;
            Folder3.Parent = u1;
            task.wait();
            local v55 = u36:FromInstance(Folder3);
            expect(v55).to.be.ok();
            local v56 = u37:FromInstance(Folder3);
            expect(v56).to.never.be.ok();
            local v57 = u38:FromInstance(Folder3);
            expect(v57).to.never.be.ok();
            u30.c = false;
            u32.c = false;
            u34.c = true;
            local Folder4 = Instance.new("Folder");
            CollectionService:AddTag(Folder4, "__KnitTestComponent__");
            Folder4.Name = "ComponentTest";
            Folder4.Archivable = false;
            Folder4.Parent = u1;
            task.wait();
            local v58 = u36:FromInstance(Folder4);
            expect(v58).to.never.be.ok();
            local v59 = u37:FromInstance(Folder4);
            expect(v59).to.never.be.ok();
            local v60 = u38:FromInstance(Folder4);
            expect(v60).to.never.be.ok();
        end);
        it("should decide whether or not to use extend", function() -- Line: 224
            -- upvalues: Parent (ref), CollectionService (ref), u1 (ref)
            local u61 = {
                extend = true
            };

            function u61.ShouldExtend(p62) -- Line: 226
                -- upvalues: u61 (copy)
                return u61.extend;
            end;

            function u61.Constructing(p63) -- Line: 229
                p63.E1 = true;
            end;

            local u64 = {
                extend = true
            };

            function u64.ShouldExtend(p65) -- Line: 234
                -- upvalues: u64 (copy)
                return u64.extend;
            end;

            function u64.Constructing(p66) -- Line: 237
                p66.E2 = true;
            end;

            local u67 = Parent.new({
                Tag = "__KnitTestComponent__",
                Extensions = { u61, u64 }
            });

            local function SetAndCheck(p68, p69) -- Line: 243
                -- upvalues: u61 (copy), u64 (copy), CollectionService (ref), u1 (ref), u67 (copy)
                u61.extend = p68;
                u64.extend = p69;
                local Folder = Instance.new("Folder");
                CollectionService:AddTag(Folder, "__KnitTestComponent__");
                Folder.Name = "ComponentTest";
                Folder.Archivable = false;
                Folder.Parent = u1;
                task.wait();
                local v70 = u67:FromInstance(Folder);
                expect(v70).to.be.ok();

                if p68 then
                    expect(v70.E1).to.equal(true);
                else
                    expect(v70.E1).to.never.be.ok();
                end;

                if p69 then
                    expect(v70.E2).to.equal(true);

                    return;
                end;

                expect(v70.E2).to.never.be.ok();
            end;

            SetAndCheck(true, true);
            SetAndCheck(false, false);
            SetAndCheck(true, false);
            SetAndCheck(false, true);
        end);
        it("should allow yielding within construct", function() -- Line: 268
            -- upvalues: Parent (ref), CollectionService (ref)
            local v71 = Parent.new({
                Tag = "CustomTag"
            });
            local u72 = 0;

            function v71.Construct(p73) -- Line: 275
                -- upvalues: u72 (ref)
                u72 = u72 + 1;
                task.wait(0.5);
            end;

            local Part = Instance.new("Part");
            Part.Anchored = true;
            Part.Parent = game:GetService("ReplicatedStorage");
            CollectionService:AddTag(Part, "CustomTag");
            local v74 = Part:Clone();
            v74.Parent = workspace;
            task.wait(0.6);
            expect(u72).to.equal(1);
            Part:Destroy();
            v74:Destroy();
        end);
        it("should wait for instance", function() -- Line: 294
            -- upvalues: CollectionService (ref), u9 (ref)
            local Part = Instance.new("Part");
            Part.Anchored = true;
            Part.Parent = workspace;
            task.delay(0.1, function() -- Line: 298
                -- upvalues: CollectionService (ref), Part (copy)
                CollectionService:AddTag(Part, "__KnitTestComponent__");
            end);
            local v75, v76 = u9:WaitForInstance(Part):timeout(1):await();
            expect(v75).to.equal(true);
            expect(v76).to.be.a("table");
            expect(v76.Instance).to.equal(Part);
            Part:Destroy();
        end);
    end);
end;