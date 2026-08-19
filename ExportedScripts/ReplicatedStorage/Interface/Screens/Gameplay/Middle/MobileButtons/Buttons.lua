-- Decompiled with Potassium's decompiler.

return {
    GAMEPLAY_MOBILE_BUTTONS = { "Shoot", "Shop", "Scoreboard", "Reload", "Jump", "Walk", "Crouch", "Aim", "Drop", "Interact", "Inspect", "SwapTeam", "Menu", "Ping" },
    SPECTATE_MOBILE_BUTTONS = { "SwapTeam", "Menu", "Scoreboard" },
    BUTTONS_WITH_EXPLICIT_INPUT_ENDED = {
        SwapTeam = true,
        Inspect = true,
        Crouch = true,
        Walk = true,
        Reload = true,
        Shop = true,
        Scoreboard = true,
        Menu = true,
        Drop = true,
        Ping = true
    },
    BUTTONS_EXCLUDED_FROM_CLEARING = {
        SwapTeam = true,
        Interact = true,
        Inspect = true,
        Crouch = true,
        Walk = true,
        Reload = true,
        Menu = true,
        Shop = true,
        Scoreboard = true,
        Ping = true
    },
    BUTTONS_WITH_EXPLICIT_HANDLERS = {
        SwapTeam = true,
        Inspect = true,
        Crouch = true,
        Walk = true,
        Reload = true,
        Jump = true,
        Shop = true,
        Scoreboard = true,
        Menu = true,
        Ping = true
    }
};