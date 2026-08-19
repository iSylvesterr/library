-- Decompiled with Potassium's decompiler.

local u3 = {
    LOCAL_MONSTER_FOLDER_NAME = "LocalMonster",
    SERVER_HOST_FOLDER_NAME = "LogicalEnemyHosts",
    ATTR_IS_LOGICAL = "IsLogicalEnemy",

    isLogicalRef = function(p1) -- Line: 71, Name: isLogicalRef
        local v2;

        if type(p1) == "table" and p1.isLogical == true then
            v2 = typeof(p1.id) == "number";
        else
            v2 = false;
        end;

        return v2;
    end
};

function u3.getEnemyRefId(p4) -- Line: 81
    -- upvalues: u3 (copy)
    if u3.isLogicalRef(p4) then
        return p4.id;
    end;

    if typeof(p4) == "Instance" and p4:IsA("Model") then
        return tonumber(p4.Name);
    end;

    return nil;
end;

function u3.makeLogicalHandle(p5, p6) -- Line: 98
    return {
        isLogical = true,
        id = p5,
        cfgId = p6
    };
end;

function u3.packCFrame(p7) -- Line: 112
    local LookVector = p7.LookVector;

    return p7.X, p7.Y, p7.Z, LookVector.X, LookVector.Y, LookVector.Z;
end;

function u3.unpackCFrame(p8, p9, p10, p11, p12, p13) -- Line: 128
    local v14 = Vector3.new(p8, p9, p10);
    local v15 = Vector3.new(p11, p12, p13);

    return CFrame.lookAt(v14, v14 + (v15.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v15.Unit));
end;

return u3;