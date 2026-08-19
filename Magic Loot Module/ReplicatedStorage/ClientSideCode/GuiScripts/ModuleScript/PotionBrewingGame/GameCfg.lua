-- Decompiled with Potassium's decompiler.

return {
    ANIMATION_TIMINGS = {
        TweenDefault = 0.6,
        ModelPivotEasingStyle = Enum.EasingStyle.Cubic,
        ModelPivotEasingDirection = Enum.EasingDirection.InOut
    },
    CAMERA_CONFIG = {
        FieldOfViewUI = 60,
        Stage1MoveSec = 0.85,
        Stage2MoveSec = 0.85,
        Stage3MoveSec = 1.8,
        RestoreMoveSec = 0.7
    },
    BREW_WAND_TIP_DISTANCE = 2.5,
    GAME1_ANIM_ANCHOR_TIMES = { 0, 0.75, 1.8, 2.75, 3.07, 6.37, 8.27, 13 },
    CRUSH_KNOCK_TIMES = { 0.75, 1.8, 2.75, 3.07, 6.37, 8.27 },
    MATERIAL_FRAGMENT_TEMPLATES = {
        ["研磨块"] = "模板研磨块",
        ["研磨球"] = "模板研磨球"
    },
    BOWL_MATERIAL_FRAGMENT_KIND = "研磨块",
    BOWL_MATERIAL_SCALE = 0.6666666666666666,
    CRUSH_BLOCK_SCALE = 1,
    POUR_TO_POT_MOON_ANIMS = { "甩锅入杠4", "甩锅入杠" },
    POUR_DROP = {
        PourTipMarkerName = "倾倒点位",
        StaggerSec = 0.025,
        SimGravity = 70,
        DropDownStuds = 10,
        PotHeightOffset = 0.6,
        MortarReturnSec = 0.85,
        PourTiltZDeg = -10,
        PourTiltSec = 0.25,
        DropMarkerNames = { "材料进锅位置", "水面", "药水锅", "锅", "大锅", "炼药锅" }
    },
    SCENE_SNAPSHOT = {
        CollisionBodyName = "碰撞体",
        PoseNames = { "石臼", "药水锅", "锅搅拌棒", "水面" },
        FxFolderNames = { "FX_搅拌", "FX_泡泡", "研磨特效", "捶打特效" }
    },
    STIR_PRESENTATION = {
        OrbitCount = 1,
        OrbitSpeedDeg = 180,
        RodModelName = "锅搅拌棒",
        FxFolderName = "FX_搅拌",
        FxPartName = "搅拌",
        ColorBlendSec = nil,
        CameraMarkerName = "摄像机_3阶段",
        CameraMoveSec = nil,
        EndHoldSec = 0.5,
        EnableEmitterNames = { "Enabled搅拌1", "Enabled搅拌1.1", "Enabled搅拌3" }
    }
};