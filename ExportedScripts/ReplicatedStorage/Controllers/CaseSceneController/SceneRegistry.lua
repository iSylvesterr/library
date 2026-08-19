-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {
    Default = {
        AssetFolder = "CaseScene",
        InteractionType = "Click",
        Animations = {
            CaseFall = "rbxassetid://91366765923171",
            CloseIdle = "rbxassetid://96896409518629",
            CaseOpening = "rbxassetid://100000665946048",
            OpenIdle = "rbxassetid://127592440292292"
        },
        Sounds = {
            Drop = "Case Fall",
            Opening = "Case Opening"
        }
    },
    CharmCapsule = {
        AssetFolder = "CharmScene",
        InteractionType = "Drag",
        Animations = {
            PackOpening = "rbxassetid://97837283629886"
        },
        DragSettings = {
            Threshold = 0.5,
            EndKeyframe = "DragEndPoint"
        },
        Sounds = {
            DragStart = "Charm Drag Start",
            DragLoop = "Charm Drag Loop"
        }
    },
    Package = {
        AssetFolder = "PackageScene",
        InteractionType = "Click",
        Animations = {
            CaseFall = "rbxassetid://134599478765866",
            CloseIdle = "rbxassetid://119593507010060",
            CaseOpening = "rbxassetid://97681949800792"
        },
        AnimationKeyframeSounds = {
            CaseFall = {
                Drop = "Package Drop"
            },
            CaseOpening = {
                RightTape = "Package Right Tape",
                LeftTape = "Package Left Tape",
                FrontLid = "Package Front Lid",
                FinalOpen = "Package Final Open"
            }
        }
    }
};
local u3 = {
    Case = "Default",
    ["Sticker Capsule"] = "Default",
    ["Charm Capsule"] = "CharmCapsule",
    Package = "Package"
};

function v1.GetSceneForCaseType(p4) -- Line: 124
    -- upvalues: u3 (copy)
    return u3[p4] or "Default";
end;

function v1.GetConfig(p5) -- Line: 128
    -- upvalues: u2 (copy)
    return u2[p5];
end;

function v1.GetAllSceneNames() -- Line: 132
    -- upvalues: u2 (copy)
    local v6 = {};

    for i in u2 do
        table.insert(v6, i);
    end;

    return v6;
end;

function v1.RegisterScene(p7, p8) -- Line: 140
    -- upvalues: u2 (copy)
    u2[p7] = p8;
end;

function v1.RegisterCaseTypeMapping(p9, p10) -- Line: 144
    -- upvalues: u3 (copy)
    u3[p9] = p10;
end;

return v1;