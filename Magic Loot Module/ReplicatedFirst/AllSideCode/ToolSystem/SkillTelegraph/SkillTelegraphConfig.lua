-- Decompiled with Potassium's decompiler.

return {
    RESOURCE_FOLDER = "ModelRes/DangerWarning",
    PART_NAME = {
        CircleOuter = "圆形预警区外圈",
        CircleInner = "圆形预警区内圈",
        RectOuter = "矩形预警区外圈",
        RectInner = "矩形预警区内圈"
    },
    INNER_START_SIZE = Vector3.new(0.1, 0.3, 0.1),
    GROUND_THICKNESS = 0.3,
    INNER_Y_OFFSET = 0.1,
    INNER_SIZE_OFFSET = Vector3.new(-0.5, -0.2, -0.5),
    STACK_Y_JITTER = 0.01,
    ACTIVE_COLOR = Color3.fromRGB(255, 72, 72),
    ENABLED_CHARACTER_TYPES = {
        NPC = true
    }
};