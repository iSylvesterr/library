-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u2 = {
    Optional = {},

    Player = function(p1) -- Line: 11, Name: Player
        -- upvalues: Players (copy)
        return p1 or Players.LocalPlayer;
    end
};

function u2.Get(p3) -- Line: 16
    -- upvalues: u2 (copy)
    return u2.Player(p3);
end;

function u2.Optional.Character(p4) -- Line: 21
    -- upvalues: u2 (copy)
    return u2.Player(p4).Character;
end;

function u2.Character(p5) -- Line: 26
    -- upvalues: u2 (copy)
    local v6 = u2.Player(p5);

    return v6.Character or v6.CharacterAdded:Wait();
end;

function u2.Optional.Position(p7) -- Line: 32
    -- upvalues: u2 (copy)
    local v8 = u2.Optional.Character(p7);

    return v8 and v8:GetPivot().Position or nil;
end;

function u2.Position(p9) -- Line: 38
    -- upvalues: u2 (copy)
    return u2.Character(p9):GetPivot().Position;
end;

function u2.Optional.CFrame(p10) -- Line: 43
    -- upvalues: u2 (copy)
    local v11 = u2.Optional.Character(p10);

    return v11 and v11:GetPivot() or nil;
end;

function u2.CFrame(p12) -- Line: 49
    -- upvalues: u2 (copy)
    return u2.Character(p12):GetPivot();
end;

function u2.Optional.GetDistanceFrom(p13, p14) -- Line: 53
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.Vector3(p14);
    local v15 = u2.Optional.Position(p13);

    if v15 then
        return (p14 - v15).Magnitude;
    end;
end;

function u2.GetDistanceFrom(p16, p17) -- Line: 64
    -- upvalues: u2 (copy)
    local v18 = u2.Optional.GetDistanceFrom(p16, p17);

    return assert(v18, "Invalid distance");
end;

function u2.Optional.IsWithinRange(p19, p20, p21) -- Line: 69
    -- upvalues: u2 (copy), Asserts (copy)
    local v22 = u2.Optional.GetDistanceFrom(p19, p20);

    if v22 then
        Asserts.Vector3(p20);
        Asserts.number(p21);

        return v22 <= p21;
    end;
end;

function u2.IsWithinRange(p23, p24, p25) -- Line: 81
    -- upvalues: u2 (copy)
    local v26 = u2.Optional.IsWithinRange(p23, p24, p25);
    assert(v26 ~= nil, "Invalid result for is within range");

    return v26;
end;

function u2.Optional.PrimaryPart(p27) -- Line: 88
    -- upvalues: u2 (copy)
    local v28 = u2.Optional.Character(p27);

    if v28 then
        v28 = v28.PrimaryPart;
    end;

    return v28;
end;

function u2.PrimaryPart(p29) -- Line: 94
    -- upvalues: u2 (copy)
    local v30 = u2.Character(p29);
    local PrimaryPart = v30.PrimaryPart;

    if not PrimaryPart then
        v30:WaitForChild("HumanoidRootPart", (1 / 0));
        PrimaryPart = v30.PrimaryPart;
        assert(PrimaryPart, "PrimaryPart not found");
    end;

    return PrimaryPart;
end;

function u2.Optional.PrimaryPartPosition(p31) -- Line: 107
    -- upvalues: u2 (copy)
    local v32 = u2.Optional.PrimaryPart(p31);

    return v32 and v32.Position or nil;
end;

function u2.PrimaryPartPosition(p33) -- Line: 113
    -- upvalues: u2 (copy)
    return u2.PrimaryPart(p33).Position;
end;

function u2.Optional.PrimaryPartCFrame(p34) -- Line: 117
    -- upvalues: u2 (copy)
    local v35 = u2.Optional.PrimaryPart(p34);

    return v35 and v35.CFrame or nil;
end;

function u2.PrimaryPartCFrame(p36) -- Line: 123
    -- upvalues: u2 (copy)
    return u2.PrimaryPart(p36).CFrame;
end;

function u2.Optional.Humanoid(p37) -- Line: 128
    -- upvalues: u2 (copy)
    local v38 = u2.Optional.Character(p37);

    if v38 then
        v38 = v38:FindFirstChildOfClass("Humanoid");
    end;

    return v38;
end;

function u2.Humanoid(p39) -- Line: 134
    -- upvalues: u2 (copy)
    local v40 = u2.Character(p39);
    local v41 = v40:FindFirstChildOfClass("Humanoid");

    if not v41 then
        v40:WaitForChild("Humanoid", (1 / 0));
        v41 = v40:FindFirstChildOfClass("Humanoid");
        assert(v41, "Humanoid not found");
    end;

    return v41;
end;

function u2.Optional.Part(p42, p43) -- Line: 148
    -- upvalues: u2 (copy)
    return u2.Character(p42):FindFirstChild(p43);
end;

function u2.Part(p44, p45) -- Line: 153
    -- upvalues: u2 (copy)
    return u2.Character(p44):WaitForChild(p45, (1 / 0));
end;

function u2.Optional.EmbeddedMotor6D(p46, p47, p48) -- Line: 158
    -- upvalues: u2 (copy)
    local v49 = u2.Optional.Part(p46, p47);

    if v49 then
        v49 = v49:FindFirstChild(p48);
    end;

    return v49;
end;

function u2.EmbeddedMotor6D(p50, p51, p52) -- Line: 164
    -- upvalues: u2 (copy)
    return u2.Part(p50, p51):WaitForChild(p52, (1 / 0));
end;

function u2.Optional.Head(p53) -- Line: 169
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p53, "Head");
end;

function u2.Head(p54) -- Line: 174
    -- upvalues: u2 (copy)
    return u2.Part(p54, "Head");
end;

function u2.Optional.UpperTorso(p55) -- Line: 179
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p55, "UpperTorso");
end;

function u2.UpperTorso(p56) -- Line: 184
    -- upvalues: u2 (copy)
    return u2.Part(p56, "UpperTorso");
end;

function u2.Optional.Torso(p57) -- Line: 189
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p57, "Torso");
end;

function u2.Torso(p58) -- Line: 194
    -- upvalues: u2 (copy)
    return u2.Part(p58, "Torso");
end;

function u2.Optional.LowerTorso(p59) -- Line: 199
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p59, "LowerTorso");
end;

function u2.LowerTorso(p60) -- Line: 204
    -- upvalues: u2 (copy)
    return u2.Part(p60, "LowerTorso");
end;

function u2.Optional.LeftFoot(p61) -- Line: 209
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p61, "LeftFoot");
end;

function u2.LeftFoot(p62) -- Line: 214
    -- upvalues: u2 (copy)
    return u2.Part(p62, "LeftFoot");
end;

function u2.Optional.LeftHand(p63) -- Line: 219
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p63, "LeftHand");
end;

function u2.LeftHand(p64) -- Line: 224
    -- upvalues: u2 (copy)
    return u2.Part(p64, "LeftHand");
end;

function u2.Optional.LeftLowerArm(p65) -- Line: 229
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p65, "LeftLowerArm");
end;

function u2.LeftLowerArm(p66) -- Line: 234
    -- upvalues: u2 (copy)
    return u2.Part(p66, "LeftLowerArm");
end;

function u2.Optional.LeftLowerLeg(p67) -- Line: 239
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p67, "LeftLowerLeg");
end;

function u2.LeftLowerLeg(p68) -- Line: 244
    -- upvalues: u2 (copy)
    return u2.Part(p68, "LeftLowerLeg");
end;

function u2.Optional.LeftUpperArm(p69) -- Line: 249
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p69, "LeftUpperArm");
end;

function u2.LeftUpperArm(p70) -- Line: 254
    -- upvalues: u2 (copy)
    return u2.Part(p70, "LeftUpperArm");
end;

function u2.Optional.LeftUpperLeg(p71) -- Line: 259
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p71, "LeftUpperLeg");
end;

function u2.LeftUpperLeg(p72) -- Line: 264
    -- upvalues: u2 (copy)
    return u2.Part(p72, "LeftUpperLeg");
end;

function u2.Optional.RightFoot(p73) -- Line: 269
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p73, "RightFoot");
end;

function u2.RightFoot(p74) -- Line: 274
    -- upvalues: u2 (copy)
    return u2.Part(p74, "RightFoot");
end;

function u2.Optional.RightHand(p75) -- Line: 279
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p75, "RightHand");
end;

function u2.RightHand(p76) -- Line: 284
    -- upvalues: u2 (copy)
    return u2.Part(p76, "RightHand");
end;

function u2.Optional.RightLowerArm(p77) -- Line: 289
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p77, "RightLowerArm");
end;

function u2.RightLowerArm(p78) -- Line: 294
    -- upvalues: u2 (copy)
    return u2.Part(p78, "RightLowerArm");
end;

function u2.Optional.RightLowerLeg(p79) -- Line: 299
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p79, "RightLowerLeg");
end;

function u2.RightLowerLeg(p80) -- Line: 304
    -- upvalues: u2 (copy)
    return u2.Part(p80, "RightLowerLeg");
end;

function u2.Optional.RightUpperArm(p81) -- Line: 309
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p81, "RightUpperArm");
end;

function u2.RightUpperArm(p82) -- Line: 314
    -- upvalues: u2 (copy)
    return u2.Part(p82, "RightUpperArm");
end;

function u2.Optional.RightUpperLeg(p83) -- Line: 319
    -- upvalues: u2 (copy)
    return u2.Optional.Part(p83, "RightUpperLeg");
end;

function u2.RightUpperLeg(p84) -- Line: 324
    -- upvalues: u2 (copy)
    return u2.Part(p84, "RightUpperLeg");
end;

function u2.Optional.Root(p85) -- Line: 329
    -- upvalues: u2 (copy)
    return u2.Optional.EmbeddedMotor6D(p85, "LowerTorso", "Root");
end;

function u2.Root(p86) -- Line: 334
    -- upvalues: u2 (copy)
    return u2.EmbeddedMotor6D(p86, "LowerTorso", "Root");
end;

function u2.Optional.Waist(p87) -- Line: 339
    -- upvalues: u2 (copy)
    return u2.Optional.EmbeddedMotor6D(p87, "UpperTorso", "Waist");
end;

function u2.Waist(p88) -- Line: 344
    -- upvalues: u2 (copy)
    return u2.EmbeddedMotor6D(p88, "UpperTorso", "Waist");
end;

function u2.Optional.Neck(p89) -- Line: 349
    -- upvalues: u2 (copy)
    return u2.Optional.EmbeddedMotor6D(p89, "Head", "Neck");
end;

function u2.Neck(p90) -- Line: 354
    -- upvalues: u2 (copy)
    return u2.EmbeddedMotor6D(p90, "Head", "Neck");
end;

function u2.Optional.LeftAnkle(p91) -- Line: 359
    -- upvalues: u2 (copy)
    return u2.Optional.EmbeddedMotor6D(p91, "LeftFoot", "LeftAnkle");
end;

function u2.LeftAnkle(p92) -- Line: 364
    -- upvalues: u2 (copy)
    return u2.EmbeddedMotor6D(p92, "LeftFoot", "LeftAnkle");
end;

function u2.Optional.LeftWrist(p93) -- Line: 369
    -- upvalues: u2 (copy)
    return u2.Optional.EmbeddedMotor6D(p93, "LeftHand", "LeftWrist");
end;

function u2.LeftWrist(p94) -- Line: 374
    -- upvalues: u2 (copy)
    return u2.EmbeddedMotor6D(p94, "LeftHand", "LeftWrist");
end;

function u2.Optional.LeftElbow(p95) -- Line: 379
    -- upvalues: u2 (copy)
    return u2.Optional.EmbeddedMotor6D(p95, "LeftLowerArm", "LeftElbow");
end;

function u2.LeftElbow(p96) -- Line: 384
    -- upvalues: u2 (copy)
    return u2.EmbeddedMotor6D(p96, "LeftLowerArm", "LeftElbow");
end;

function u2.Optional.LeftKnee(p97) -- Line: 389
    -- upvalues: u2 (copy)
    return u2.Optional.EmbeddedMotor6D(p97, "LeftLowerLeg", "LeftKnee");
end;

function u2.LeftKnee(p98) -- Line: 394
    -- upvalues: u2 (copy)
    return u2.EmbeddedMotor6D(p98, "LeftLowerLeg", "LeftKnee");
end;

function u2.Optional.LeftShoulder(p99) -- Line: 399
    -- upvalues: u2 (copy)
    return u2.Optional.EmbeddedMotor6D(p99, "LeftUpperArm", "LeftShoulder");
end;

function u2.LeftShoulder(p100) -- Line: 404
    -- upvalues: u2 (copy)
    return u2.EmbeddedMotor6D(p100, "LeftUpperArm", "LeftShoulder");
end;

function u2.Optional.LeftHip(p101) -- Line: 409
    -- upvalues: u2 (copy)
    return u2.Optional.EmbeddedMotor6D(p101, "LeftUpperLeg", "LeftHip");
end;

function u2.LeftHip(p102) -- Line: 414
    -- upvalues: u2 (copy)
    return u2.EmbeddedMotor6D(p102, "LeftUpperLeg", "LeftHip");
end;

function u2.Optional.RightAnkle(p103) -- Line: 419
    -- upvalues: u2 (copy)
    return u2.Optional.EmbeddedMotor6D(p103, "RightFoot", "RightAnkle");
end;

function u2.RightAnkle(p104) -- Line: 424
    -- upvalues: u2 (copy)
    return u2.EmbeddedMotor6D(p104, "RightFoot", "RightAnkle");
end;

function u2.Optional.RightWrist(p105) -- Line: 429
    -- upvalues: u2 (copy)
    return u2.Optional.EmbeddedMotor6D(p105, "RightHand", "RightWrist");
end;

function u2.RightWrist(p106) -- Line: 434
    -- upvalues: u2 (copy)
    return u2.EmbeddedMotor6D(p106, "RightHand", "RightWrist");
end;

function u2.Optional.RightElbow(p107) -- Line: 439
    -- upvalues: u2 (copy)
    return u2.Optional.EmbeddedMotor6D(p107, "RightLowerArm", "RightElbow");
end;

function u2.RightElbow(p108) -- Line: 444
    -- upvalues: u2 (copy)
    return u2.EmbeddedMotor6D(p108, "RightLowerArm", "RightElbow");
end;

function u2.Optional.RightKnee(p109) -- Line: 449
    -- upvalues: u2 (copy)
    return u2.Optional.EmbeddedMotor6D(p109, "RightLowerLeg", "RightKnee");
end;

function u2.RightKnee(p110) -- Line: 454
    -- upvalues: u2 (copy)
    return u2.EmbeddedMotor6D(p110, "RightLowerLeg", "RightKnee");
end;

function u2.Optional.RightShoulder(p111) -- Line: 459
    -- upvalues: u2 (copy)
    return u2.Optional.EmbeddedMotor6D(p111, "RightUpperArm", "RightShoulder");
end;

function u2.RightShoulder(p112) -- Line: 464
    -- upvalues: u2 (copy)
    return u2.EmbeddedMotor6D(p112, "RightUpperArm", "RightShoulder");
end;

function u2.Optional.RightHip(p113) -- Line: 469
    -- upvalues: u2 (copy)
    return u2.Optional.EmbeddedMotor6D(p113, "RightUpperLeg", "RightHip");
end;

function u2.RightHip(p114) -- Line: 474
    -- upvalues: u2 (copy)
    return u2.EmbeddedMotor6D(p114, "RightUpperLeg", "RightHip");
end;

function u2.Optional.PlayerGui(p115) -- Line: 478
    -- upvalues: u2 (copy)
    return u2.Player(p115):FindFirstChild("PlayerGui");
end;

function u2.PlayerGui(p116) -- Line: 483
    -- upvalues: u2 (copy)
    return u2.Player(p116):WaitForChild("PlayerGui", (1 / 0));
end;

function u2.Mouse(p117) -- Line: 488
    -- upvalues: u2 (copy)
    return u2.Player(p117):GetMouse();
end;

function u2.Camera() -- Line: 493
    return workspace.CurrentCamera;
end;

function u2.Name(p118) -- Line: 498
    -- upvalues: u2 (copy)
    return u2.Player(p118).Name;
end;

function u2.DisplayName(p119) -- Line: 503
    -- upvalues: u2 (copy)
    return u2.Player(p119).DisplayName;
end;

function u2.Optional.GetAppliedDescription(p120) -- Line: 508
    -- upvalues: u2 (copy)
    local v121 = u2.Optional.Humanoid(p120);

    if v121 then
        v121 = v121:GetAppliedDescription();
    end;

    return v121;
end;

function u2.GetAppliedDescription(p122) -- Line: 514
    -- upvalues: u2 (copy)
    return u2.Humanoid(p122):GetAppliedDescription();
end;

function u2.Optional.Animator(p123) -- Line: 519
    -- upvalues: u2 (copy)
    local v124 = u2.Optional.Humanoid(p123);

    if v124 then
        return v124:FindFirstChildOfClass("Animator") or (v124:FindFirstChildOfClass("AnimationController") or v124);
    end;

    return nil;
end;

function u2.Animator(p125) -- Line: 539
    -- upvalues: u2 (copy)
    local v126 = u2.Humanoid(p125);

    return v126:FindFirstChildOfClass("Animator") or (v126:FindFirstChildOfClass("AnimationController") or v126);
end;

function u2.Optional.Part(p127, p128) -- Line: 555
    -- upvalues: u2 (copy)
    return u2.Character(p127):FindFirstChild(p128);
end;

function u2.Part(p129, p130) -- Line: 560
    -- upvalues: u2 (copy)
    return u2.Character(p129):WaitForChild(p130, (1 / 0));
end;

function u2.Optional.EmbeddedMotor6D(p131, p132, p133) -- Line: 565
    -- upvalues: u2 (copy)
    local v134 = u2.Optional.Part(p131, p132);

    if v134 then
        v134 = v134:FindFirstChild(p133);
    end;

    return v134;
end;

function u2.EmbeddedMotor6D(p135, p136, p137) -- Line: 571
    -- upvalues: u2 (copy)
    return u2.Part(p135, p136):WaitForChild(p137, (1 / 0));
end;

function u2.Optional.PrimaryPart(p138) -- Line: 576
    -- upvalues: u2 (copy)
    local v139 = u2.Optional.Character(p138);

    if v139 then
        v139 = v139.PrimaryPart;
    end;

    return v139;
end;

function u2.PrimaryPart(p140) -- Line: 582
    -- upvalues: u2 (copy)
    local v141 = u2.Character(p140);
    local PrimaryPart = v141.PrimaryPart;

    if not PrimaryPart then
        v141:WaitForChild("HumanoidRootPart", (1 / 0));
        PrimaryPart = v141.PrimaryPart;
        assert(PrimaryPart);
    end;

    return PrimaryPart;
end;

function u2.Optional.HumanoidRootPart(p142) -- Line: 593
    -- upvalues: u2 (copy)
    local v143 = u2.Optional.Character(p142);

    if v143 then
        v143 = v143:FindFirstChild("HumanoidRootPart");
    end;

    return v143;
end;

function u2.HumanoidRootPart(p144) -- Line: 598
    -- upvalues: u2 (copy)
    return u2.Character(p144):WaitForChild("HumanoidRootPart");
end;

function u2.Optional.FeetCFrame(p145) -- Line: 605
    -- upvalues: u2 (copy)
    local v146 = u2.Optional.Character(p145);

    if not v146 then
        return nil;
    end;

    local PrimaryPart = v146.PrimaryPart;
    local v147 = v146:FindFirstChildOfClass("Humanoid");

    if PrimaryPart and v147 then
        return PrimaryPart.CFrame - PrimaryPart.CFrame.UpVector * (v147.HipHeight + PrimaryPart.Size.Y * 0.5);
    end;

    return nil;
end;

function u2.FeetCFrame(p148) -- Line: 623
    -- upvalues: u2 (copy)
    local v149 = u2.Optional.FeetCFrame(p148);

    if v149 then
        return v149;
    end;

    local v150 = u2.PrimaryPart(p148);
    local v151 = u2.Humanoid(p148).HipHeight + v150.Size.Y * 0.5;

    return v150.CFrame - v150.CFrame.UpVector * v151;
end;

return u2;