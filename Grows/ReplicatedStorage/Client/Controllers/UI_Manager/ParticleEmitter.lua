-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local u1 = Random.new();
local Maid = require(game.ReplicatedStorage.Packages.Maid);
local Images = require(game.ReplicatedStorage.Shared.Info.Images);
local CustomEnum = require(game.ReplicatedStorage.Shared.Info.CustomEnum);
local u2 = {};
local u3 = {};
local u4 = 1;
local u5 = 1;
local u6 = { Images.TWINKLE1, Images.TWINKLE2, Images.TWINKLE3 };
local DUST = CustomEnum.PARTICLE_TYPES.DUST;
local u7 = { Color3.new(1, 1, 1) };
local u8 = { Color3.new(1, 1, 1) };
local u9 = NumberRange.new(0.1, 1.5);
local u10 = NumberRange.new(50, 100);
local u11 = NumberRange.new(1, 360);
local u12 = NumberRange.new(-300, 300);
local u13 = Vector2.new(0, 0);
local u14 = Vector2.new(0, 0);
local u15 = NumberRange.new(3, 5);
local u16 = NumberRange.new(1, 360);

local function randomNumberInRange(p17) -- Line: 37
    -- upvalues: u1 (copy)
    if typeof(p17) == "number" then
        return p17;
    end;

    return p17.Min + u1:NextNumber() * (p17.Max - p17.Min);
end;

local function normalizeBool(p18, p19) -- Line: 44
    if p18 == nil then
        return p19;
    end;

    return p18;
end;

return function(p20) -- Line: 49
    -- upvalues: u4 (ref), u2 (copy), Maid (copy), u1 (copy), u6 (copy), DUST (copy), u7 (copy), u8 (copy), u9 (copy), u11 (copy), u10 (copy), u12 (copy), u13 (copy), u14 (copy), u15 (copy), u16 (copy), u5 (ref), u3 (copy), CustomEnum (copy), TweenService (copy), RunService (copy), Images (copy)
    function p20.AddEmitter(p21, p22, p23, p24) -- Line: 55
        -- upvalues: u4 (ref), u2 (ref), Maid (ref), u1 (ref), u6 (ref), DUST (ref), u7 (ref), u8 (ref), u9 (ref), u11 (ref), u10 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u16 (ref), u5 (ref), u3 (ref), CustomEnum (ref), TweenService (ref), RunService (ref)
        local u25 = u4;
        u4 = u4 + 1;
        u2[u25] = {};
        u2[u25].maid = Maid.new();
        local Frame = Instance.new("Frame");
        Frame.Name = "ParticlesContainer";
        Frame.Size = UDim2.new(1, 0, 1, 0);
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.Position = p23;
        Frame.BackgroundTransparency = 1;
        Frame.ZIndex = 0;
        Frame.Parent = p22;
        local u26 = p24.em_delay or 0.2;
        local u27 = p24.amt or nil;

        if u27 then
            u27 = u27;

            if typeof(u27) ~= "number" then
                u27 = u27.Min + u1:NextNumber() * (u27.Max - u27.Min);
            end;
        end;

        local u28 = p24.images or u6;
        local u29 = p24.partType or DUST;
        local u30 = p24.startColors or u7;
        local u31 = p24.endColors or u8;
        local u32 = p24.lifeTime or u9;
        local u33 = p24.imgDirections or u11;
        local u34 = p24.size or u10;
        local u35 = p24.imgSpin or u12;
        local u36 = p24.vel or u13;
        local u37 = p24.xVelRange or nil;
        local u38 = p24.yVelRange or nil;
        local u39 = p24.accel or u14;
        local u40 = p24.angVel or u15;
        local u41 = p24.angle or u16;
        local u42 = p24.zIndex or 999999;
        local u43 = p24.angDrag or 0.98;
        local u44 = p24.partPerEmit or 1;
        local center = p24.center;
        local u45 = center == nil and true or center;
        local shrink = p24.shrink;
        local u46 = shrink == nil and true or shrink;
        local fade = p24.fade;
        local u47 = fade == nil and true or fade;

        local function emit() -- Line: 103
            -- upvalues: u45 (copy), u1 (ref), u28 (copy), u30 (copy), u33 (copy), Frame (copy), u42 (copy), u5 (ref), u3 (ref), u32 (copy), u29 (copy), u35 (copy), u37 (copy), u36 (ref), u38 (copy), u39 (copy), u40 (copy), u41 (copy), u43 (copy), u46 (copy), u47 (copy), u34 (copy), CustomEnum (ref), TweenService (ref), u31 (copy)
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
            ImageLabel.BackgroundTransparency = 1;

            if u45 then
                ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0);
            else
                ImageLabel.Position = UDim2.new(u1:NextNumber(0, 1), 0, u1:NextNumber(0, 1), 0);
            end;

            ImageLabel.Image = u28[math.random(1, #u28)];
            ImageLabel.ImageColor3 = u30[math.random(1, #u30)];
            local v48 = u33;

            if typeof(v48) ~= "number" then
                v48 = v48.Min + u1:NextNumber() * (v48.Max - v48.Min);
            end;

            ImageLabel.Rotation = v48;
            ImageLabel.Parent = Frame;
            ImageLabel.ZIndex = u42;
            local v49 = u5;
            u5 = u5 + 1;
            u3[v49] = {};
            u3[v49].object = ImageLabel;
            local v50 = u3[v49];
            local v51 = u32;

            if typeof(v51) ~= "number" then
                v51 = v51.Min + u1:NextNumber() * (v51.Max - v51.Min);
            end;

            v50.ogLife = v51;
            u3[v49].life = u3[v49].ogLife;
            u3[v49].partType = u29;
            local v52 = u3[v49];
            local v53 = u35;

            if typeof(v53) ~= "number" then
                v53 = v53.Min + u1:NextNumber() * (v53.Max - v53.Min);
            end;

            v52.imgSpin = v53;

            if u37 then
                local new = Vector2.new;
                local v54 = u37;

                if typeof(v54) ~= "number" then
                    v54 = v54.Min + u1:NextNumber() * (v54.Max - v54.Min);
                end;

                u36 = new(v54, u36.Y);
            end;

            if u38 then
                local new = Vector2.new;
                local X = u36.X;
                local v55 = u38;

                if typeof(v55) ~= "number" then
                    v55 = v55.Min + u1:NextNumber() * (v55.Max - v55.Min);
                end;

                u36 = new(X, v55);
            end;

            u3[v49].vel = u36;
            u3[v49].accel = u39;
            local v56 = u3[v49];
            local v57 = u40;

            if typeof(v57) ~= "number" then
                v57 = v57.Min + u1:NextNumber() * (v57.Max - v57.Min);
            end;

            v56.angVel = v57;
            local v58 = u3[v49];
            local v59 = u41;

            if typeof(v59) ~= "number" then
                v59 = v59.Min + u1:NextNumber() * (v59.Max - v59.Min);
            end;

            v58.angle = v59;
            u3[v49].angDrag = u43;
            u3[v49].shrink = u46;
            u3[v49].fade = u47;
            local v60 = u3[v49];
            local v61 = u34;

            if typeof(v61) ~= "number" then
                v61 = v61.Min + u1:NextNumber() * (v61.Max - v61.Min);
            end;

            v60.ogSize = v61;

            if u29 == CustomEnum.PARTICLE_TYPES.DUST then
                ImageLabel.Size = UDim2.new(0, u3[v49].ogSize, 0, u3[v49].ogSize);
            elseif u29 == CustomEnum.PARTICLE_TYPES.SHINE then
                ImageLabel.Size = UDim2.new(0, 0, 0, 0);
            end;

            u3[v49].colorTween = TweenService:Create(ImageLabel, TweenInfo.new(u3[v49].life), {
                ImageColor3 = u31[math.random(1, #u31)]
            });
            u3[v49].colorTween:Play();
        end;

        local u62 = true;
        local u63 = false;
        local u64 = 0;
        u2[u25].timeCon = RunService.RenderStepped:Connect(function(p65) -- Line: 172
            -- upvalues: u63 (ref), u62 (ref), u64 (ref), u26 (copy), u44 (copy), emit (copy), u27 (ref), u32 (copy), u2 (ref), u25 (copy)
            if u63 then
                return;
            end;

            if not u62 then
                return;
            end;

            u64 = u64 + p65;

            if u64 < u26 then
                return;
            end;

            u64 = 0;
            u63 = true;

            for _ = 1, u44 do
                emit();
            end;

            if u27 then
                u27 = u27 - u44;

                if u27 < 1 then
                    u62 = false;
                    task.wait(u32.Max);

                    if u2[u25] and u2[u25].maid then
                        u2[u25].maid:Destroy();
                    end;
                end;
            end;

            u63 = false;
        end);
        u2[u25].maid:GiveTask(function() -- Line: 201
            -- upvalues: Frame (copy), u2 (ref), u25 (copy)
            if Frame then
                Frame:Destroy();
            end;

            if u2[u25].timeCon then
                u2[u25].timeCon:Disconnect();
            end;
        end);

        return u25;
    end;

    local function destroyParticle(p66) -- Line: 211
        -- upvalues: u3 (ref)
        if not u3[p66] then
            return;
        end;

        if u3[p66].object then
            u3[p66].object:Destroy();
        end;

        u3[p66] = nil;
    end;

    local u67 = 0;
    RunService.RenderStepped:Connect(function(p68) -- Line: 218
        -- upvalues: u67 (ref), u3 (ref), CustomEnum (ref)
        u67 = u67 + 1;

        for i, _ in u3 do
            local v69 = u3[i].life / u3[i].ogLife;

            if u3[i].object then
                local v70 = u3[i];
                v70.life = v70.life - p68;

                if u3[i].life <= 0 then
                    if u3[i] then
                        if u3[i].object then
                            u3[i].object:Destroy();
                        end;

                        u3[i] = nil;
                    end;
                elseif u3[i].partType == CustomEnum.PARTICLE_TYPES.DUST then
                    local object = u3[i].object;
                    object.Rotation = object.Rotation + u3[i].imgSpin * p68;
                    local object2 = u3[i].object;
                    object2.Position = object2.Position + UDim2.new(0, u3[i].vel.X * p68, 0, u3[i].vel.Y * p68);
                    local v71 = u3[i];
                    v71.vel = v71.vel + u3[i].accel * p68;

                    if u3[i].angVel ~= 0 then
                        local object3 = u3[i].object;
                        local Position = object3.Position;
                        local new = UDim2.new;
                        local angVel = u3[i].angVel;
                        local v72 = math.rad(u3[i].angle) * p68;
                        local v73 = angVel * math.cos(v72);
                        local angVel2 = u3[i].angVel;
                        local v74 = math.rad(u3[i].angle) * p68;
                        object3.Position = Position + new(0, v73, 0, angVel2 * math.sin(v74));
                        local v75 = u3[i];
                        v75.angVel = v75.angVel * (u3[i].angDrag * p68);
                    end;

                    if u3[i].shrink then
                        u3[i].object.Size = UDim2.new(0, u3[i].ogSize * v69, 0, u3[i].ogSize * v69);
                    end;

                    if u3[i].fade then
                        u3[i].object.ImageTransparency = 1 - v69;
                    end;
                elseif u3[i].partType == CustomEnum.PARTICLE_TYPES.SHINE then
                    local v76;

                    if v69 < 0.5 then
                        v76 = 2 * v69;
                    else
                        v76 = 2 * (1 - v69);
                    end;

                    u3[i].object.Size = UDim2.new(0, u3[i].ogSize * v76, 0, u3[i].ogSize * v76);
                    u3[i].object.ImageTransparency = 0.2;
                end;
            elseif u3[i] then
                if u3[i].object then
                    u3[i].object:Destroy();
                end;

                u3[i] = nil;
            end;
        end;
    end);

    function p20.RemoveEmitter(p77, p78) -- Line: 290
        -- upvalues: u2 (ref)
        if u2[p78] then
            u2[p78].maid:Destroy();
            u2[p78] = nil;
        end;
    end;

    p20.PARTICLE_TEMPLATES = {
        SCRAP_BURST = "SCRAP_BURST",
        SPARKLE = "SPARKLE"
    };

    function p20.AddEmitterTemplate(p79, p80, p81, p82, p83) -- Line: 302
        -- upvalues: Images (ref), CustomEnum (ref)
        local v84;

        if p82 == p79.PARTICLE_TEMPLATES.SCRAP_BURST then
            v84 = {
                zIndex = 35,
                center = true,
                em_delay = 0,
                amt = 10,
                fade = false,
                shrink = false,
                angVel = NumberRange.new(0, 0),
                xVelRange = NumberRange.new(-600, 600),
                yVelRange = NumberRange.new(-450, -200),
                accel = Vector2.new(0, 2000),
                images = { Images.BOLT, Images.SCREW },
                partType = CustomEnum.PARTICLE_TYPES.DUST,
                imgDirections = NumberRange.new(0, 0),
                lifeTime = NumberRange.new(1.5, 1.5),
                size = NumberRange.new(30, 40)
            };
        else
            if p82 ~= p79.PARTICLE_TEMPLATES.SPARKLE then
                warn("invalid emitter template");

                return;
            end;

            v84 = {
                zIndex = 15,
                center = false,
                em_delay = 0.9,
                angVel = NumberRange.new(0, 0),
                images = { Images.TWINKLE_THIN },
                partType = CustomEnum.PARTICLE_TYPES.SHINE,
                imgDirections = NumberRange.new(0, 0),
                lifeTime = NumberRange.new(0.3, 0.4),
                size = NumberRange.new(30, 40)
            };
        end;

        for i, v in p83 do
            v84[i] = v;
        end;

        return p79:AddEmitter(p80, p81, v84);
    end;
end;