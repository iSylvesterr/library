-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastCastRedux = require(ReplicatedStorage.Library.Functions.FastCastRedux);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local Bezier = require(ReplicatedStorage.Library.Functions.Bezier);
local u2 = {
    Types = {
        Default = "Default",
        Bezier = "Bezier"
    }
};

local function createDefaultTrajectory(p3, p4) -- Line: 32
    return p4:Fire(p3.origin, p3.direction, p3.projectileSpeed, p3.castBehavior);
end;

local function createBezierTrajectory(p5, p6, p7) -- Line: 42
    -- upvalues: Bezier (copy), FastCastRedux (copy)
    local origin = p5.origin;
    local direction = p5.direction;
    local projectileSpeed = p5.projectileSpeed;
    local castBehavior = p5.castBehavior;
    local v8 = p7 and (p7.curveHeight or 10) or 10;
    local u9 = p7 and p7.samples or 50;
    local v10 = origin + direction * (projectileSpeed * 2);
    local v11 = { origin, origin:Lerp(v10, 0.5) + Vector3.new(0, v8, 0), v10 };
    local u12, u13 = Bezier(table.unpack(v11));
    local v14 = FastCastRedux.newBehavior();
    v14.RaycastParams = castBehavior.RaycastParams;
    v14.MaxDistance = castBehavior.MaxDistance;
    v14.CosmeticBulletTemplate = castBehavior.CosmeticBulletTemplate;
    v14.CosmeticBulletContainer = castBehavior.CosmeticBulletContainer;
    v14.AutoIgnoreContainer = castBehavior.AutoIgnoreContainer;
    v14.Acceleration = Vector3.new(0, 0, 0);
    local u15 = p6:Fire(origin, direction, projectileSpeed, v14);
    task.spawn(function() -- Line: 73
        -- upvalues: u13 (copy), projectileSpeed (copy), u9 (copy), u15 (copy), u12 (copy)
        local v16 = os.clock();
        local v17 = u13 / projectileSpeed;
        local v18 = 0;

        while v18 < u9 and (u15 and not u15.Paused) do
            task.wait();
            local v19 = (os.clock() - v16) / v17;
            local v20 = math.min(v19, 1);

            if v20 >= 1 then
                break;
            end;

            u12(v20);
            v18 = v18 + 1;
        end;
    end);

    return u15;
end;

function u2.Fire(p21, p22, p23) -- Line: 97
    -- upvalues: u1 (copy), u2 (copy), createBezierTrajectory (copy)
    if not p22 then
        u1:AtError():Log("[CustomProjectilePath] Missing params");

        return nil;
    end;

    if not (p23 and p23.caster) then
        u1:AtError():Log("[CustomProjectilePath] Missing caster in overrides");

        return nil;
    end;

    local caster = p23.caster;

    if (p21 or u2.Types.Default) == u2.Types.Bezier then
        return createBezierTrajectory(p22, caster, p23);
    end;

    return caster:Fire(p22.origin, p22.direction, p22.projectileSpeed, p22.castBehavior);
end;

return u2;