-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Assets = require(ReplicatedStorage.Directory.Assets);
local AssetModels = require(ReplicatedStorage.Library.Modules.AssetModels);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
local Directory = Assets.Directory;
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);
local ItemDisplay = require(ReplicatedStorage.Library.Modules.ItemDisplay);
local Unit = (Vector3.new(-1, 0, -1)).Unit;
local u1 = Log.new();
local u2 = {};

local function setupCamera(p3, p4, p5, p6, p7, p8) -- Line: 30
    -- upvalues: BBFromModelVisibleOnly (copy), Unit (copy)
    local v9 = p6 or 0.8;
    local v10 = p7 or 0.5;
    local v11 = p8 or 0.5;
    assert(v9, "luau");
    assert(v10, "luau");
    assert(v11, "luau");
    local v12, v13 = BBFromModelVisibleOnly(p4);
    local v14 = math.max(v13.X, v13.Y, v13.Z);
    local v15 = math.rad(p5 * 0.5);
    local v16 = v14 * 0.5 / math.tan(v15) * v9;
    local v17 = v12.Position + Vector3.new(0, (v11 - 0.5) * v13.Y, 0);
    local Position = (v12 * CFrame.new(Unit * (v16 + v14 * v10))).Position;
    p3.CFrame = CFrame.new(Position, v17);
end;

local function attachModel(p18, p19, p20, p21) -- Line: 54
    -- upvalues: Trove (copy), u2 (copy), setupCamera (copy)
    local v22 = Trove.new();
    v22:Add(p19);

    if p21 then
        local WorldModel = Instance.new("WorldModel");
        WorldModel.Parent = p20;
        v22:Add(WorldModel);
        p19.Parent = WorldModel;
        local v23 = u2.PlayIdleAnimation(p18, p19);

        if v23 ~= nil then
            v22:Add(v23);
        end;
    else
        p19.Parent = p20;
    end;

    local Camera = Instance.new("Camera");
    Camera.FieldOfView = 50;
    Camera.Parent = p20;
    p20.CurrentCamera = Camera;
    v22:Add(Camera);
    setupCamera(Camera, p19, 60, 0.75, 0.7, 0.35);
    v22:AttachToInstance(p20);

    return v22, Camera, p19;
end;

function u2.Create(p24) -- Line: 91
    -- upvalues: Asserts (copy)
    Asserts.GuiObject(p24);
    local ViewportFrame = Instance.new("ViewportFrame");
    ViewportFrame.Name = "AssetViewport";
    ViewportFrame.AnchorPoint = Vector2.new(0.5, 0.5);
    ViewportFrame.BackgroundTransparency = 1;
    ViewportFrame.Position = UDim2.fromScale(0.5, 0.5);
    ViewportFrame.Size = UDim2.fromScale(1, 1);
    ViewportFrame.ZIndex = p24.ZIndex + 1;
    ViewportFrame.Parent = p24;
    ViewportFrame.LightColor = Color3.fromRGB(300, 300, 300);
    ViewportFrame.Ambient = Color3.fromRGB(300, 300, 300);

    return ViewportFrame;
end;

function u2.GetOrbitCFrame(p25, p26, p27, p28) -- Line: 107
    -- upvalues: Asserts (copy)
    Asserts.CFrame(p25);
    Asserts.Vector3(p26);
    Asserts.number(p27);
    Asserts.number(p28);
    local v29 = CFrame.new(p26):ToObjectSpace(p25);
    local v30 = CFrame.new(p26) * CFrame.Angles(p28, p27, 0) * v29;

    return CFrame.lookAt(v30.Position, p26);
end;

function u2.SetCameraOrbit(p31, p32, p33, p34, p35) -- Line: 118
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.Instance(p31);
    p31.CFrame = u2.GetOrbitCFrame(p32, p33, p34, p35);
end;

function u2.SetLocalCameraOrbit(p36, p37, p38, p39, p40, p41, p42) -- Line: 129
    -- upvalues: Asserts (copy)
    Asserts.Instance(p36);
    Asserts.CFrame(p37);
    Asserts.Vector3(p38);
    Asserts.number(p39);
    Asserts.number(p40);
    Asserts.number(p41);
    Asserts.number(p42);
    local v43 = CFrame.Angles(0, p41, 0):VectorToWorldSpace((Vector3.new(0, 0, -p39)));
    local v44 = p40 + math.tan(p42) * p39;
    local v45 = p37:VectorToWorldSpace(v43 + Vector3.new(0, v44, 0));
    p36.CFrame = CFrame.lookAt(p38 + v45, p38, p37.UpVector);
end;

function u2.PlayIdleAnimation(p46, p47) -- Line: 152
    -- upvalues: Asserts (copy), Directory (copy)
    Asserts.string(p46);
    Asserts.Model(p47);
    local Idle = Directory[p46].Animations.Idle;
    local v48 = p47:FindFirstChildWhichIsA("Animator", true);

    if Idle == nil or v48 == nil then
        return nil;
    end;

    local v49 = v48:LoadAnimation(Idle);
    v49.Looped = true;
    v49:Play(0);

    return v49;
end;

function u2.AttachOnViewport(p50, p51, p52) -- Line: 169
    -- upvalues: AssetModels (copy), u1 (copy), Trove (copy), attachModel (copy)
    local v53 = AssetModels.GetAssetModelIfReplicated(p50);

    if v53 then
        return attachModel(p50, v53:Clone(), p51, p52);
    end;

    u1:AtWarning():Log("Asset not found in model folder", {
        AssetId = p50
    });

    return Trove.new(), nil, nil;
end;

function u2.AttachItemDataOnViewport(p54, p55, p56, p57) -- Line: 184
    -- upvalues: AssetItem (copy), Asserts (copy), ItemDisplay (copy), attachModel (copy)
    assert(AssetItem.AssetItemData(p54));
    Asserts.Instance(p55);
    Asserts.number(p56);
    local v58 = table.clone(p54);
    v58.Scale = 1;
    local v59 = ItemDisplay.CreateActiveModel(nil, v58, true, true);
    local v60, v61, v62 = attachModel(p54.Category, v59, p55, p57);
    ItemDisplay.ApplyModelScale(v62, p54.Category, p56);

    return v60, v61, v62;
end;

return u2;