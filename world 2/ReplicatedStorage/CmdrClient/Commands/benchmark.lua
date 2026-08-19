-- Decompiled with Potassium's decompiler.

return {
    Name = "benchmark",
    Description = "Brute-force performance harness: sets up a worst-case stress scenario, then the targeted client samples FPS / frame-time / draw-call / instance / memory stats over a window and prints a pass/fail report",
    Group = "DefaultAdmin",
    Aliases = { "bench", "perftest" },
    Args = { {
            Type = "string",
            Name = "Scenario",
            Description = "Which stress scenario to run (maxdensity, fruitsat, mutations, pets, weather, joinstorm, dropflood, offlinecutscene, fillall, all)"
        }, {
            Type = "players",
            Name = "Players",
            Description = "The player(s) to set up + sample on",
            Default = "me"
        }, {
            Type = "number",
            Name = "Seconds",
            Description = "How long to sample frame stats (default 20)",
            Optional = true
        }, {
            Type = "positiveInteger",
            Name = "Multiplier",
            Description = "Density / count multiplier for the scenario (default 4)",
            Optional = true
        }, {
            Type = "number",
            Name = "TargetFps",
            Description = "Pass/fail FPS target for the report (default 30)",
            Optional = true
        } }
};