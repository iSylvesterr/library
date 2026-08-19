-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TeleportService = game:GetService("TeleportService");
local Players = game:GetService("Players");
local Util = require(script.Parent.Util);
local Command = require(script.Parent.Command);
local u1 = false;
local u47 = {
    Cmdr = nil,
    Registry = nil,

    Evaluate = function(p2, p3, p4, p5, p6) -- Line: 21, Name: Evaluate
        -- upvalues: RunService (copy), Players (copy), Util (copy), Command (copy)
        if RunService:IsClient() == true and p4 ~= Players.LocalPlayer then
            error("Can\'t evaluate a command that isn\'t sent by the local player.");
        end;

        local v7 = Util.SplitString(p3);
        local v8 = table.remove(v7, 1);
        local v9 = p2.Registry:GetCommand(v8);

        if not v9 then
            return false, ("%q is not a valid command name. Use the help command to see all available commands."):format((tostring(v8)));
        end;

        local v10 = Util.MashExcessArguments(v7, #v9.Args);
        local v11 = Command.new({
            Dispatcher = p2,
            Text = p3,
            CommandObject = v9,
            Alias = v8,
            Executor = p4,
            Arguments = v10,
            Data = p6
        });
        local v12, v13 = v11:Parse(p5);

        if v12 then
            return v11;
        end;

        return false, v13;
    end,

    EvaluateAndRun = function(p14, p15, p16, p17) -- Line: 58, Name: EvaluateAndRun
        -- upvalues: Players (copy), RunService (copy)
        local v18 = p16 or Players.LocalPlayer;
        local v19 = p17 or {};

        if RunService:IsClient() and v19.IsHuman then
            p14:PushHistory(p15);
        end;

        local u20, v21 = p14:Evaluate(p15, v18, nil, v19.Data);

        if not u20 then
            return v21;
        end;

        local v25, v26 = xpcall(function() -- Line: 72
            -- upvalues: u20 (copy)
            local v22, v23 = u20:Validate(true);

            return v22 and (u20:Run() or "Command executed.") or v23;
        end, function(p24) -- Line: 80
            return debug.traceback((tostring(p24)));
        end);

        return v25 and v26 and v26 or "An error occurred while running this command. Check the console for more information.";
    end,

    Send = function(p27, p28, p29) -- Line: 91, Name: Send
        -- upvalues: RunService (copy)
        if RunService:IsClient() == false then
            error("Dispatcher:Send can only be called from the client.");
        end;

        return p27.Cmdr.RemoteFunction:InvokeServer(p28, {
            Data = p29
        });
    end,

    Run = function(p30, ...) -- Line: 103, Name: Run
        -- upvalues: Players (copy)
        if not Players.LocalPlayer then
            error("Dispatcher:Run can only be called from the client.");
        end;

        local v31 = { ... };
        local v32 = v31[1];

        for i = 2, #v31 do
            v32 = v32 .. " " .. tostring(v31[i]);
        end;

        local v33, v34 = p30:Evaluate(v32, Players.LocalPlayer);

        if not v33 then
            error(v34);
        end;

        local v35, v36 = v33:Validate(true);

        if not v35 then
            error(v36);
        end;

        return v33:Run();
    end,

    RunHooks = function(p37, p38, p39, ...) -- Line: 131, Name: RunHooks
        -- upvalues: RunService (copy), u1 (ref)
        if not p37.Registry.Hooks[p38] then
            error(("Invalid hook name: %q"):format(p38), 2);
        end;

        if p38 == "BeforeRun" and (#p37.Registry.Hooks[p38] == 0 and (p39.Group ~= "DefaultUtil" and (p39.Group ~= "UserAlias" and p39:HasImplementation()))) then
            if not RunService:IsStudio() then
                return "Command blocked for security as no BeforeRun hook is configured.";
            end;

            if u1 == false then
                p39:Reply((RunService:IsServer() and "<Server>" or "<Client>") .. " Commands will not run in-game if no BeforeRun hook is configured. Learn more: https://eryn.io/Cmdr/guide/Hooks.html", Color3.fromRGB(255, 228, 26));
                u1 = true;
            end;
        end;

        for _, v in ipairs(p37.Registry.Hooks[p38]) do
            local v40 = v.callback(p39, ...);

            if v40 ~= nil then
                return tostring(v40);
            end;
        end;
    end,

    PushHistory = function(p41, p42) -- Line: 163, Name: PushHistory
        -- upvalues: RunService (copy), Util (copy), TeleportService (copy)
        local v43 = RunService:IsClient();
        assert(v43, "PushHistory may only be used from the client.");
        local v44 = p41:GetHistory();

        if Util.TrimString(p42) == "" or p42 == v44[#v44] then
            return;
        end;

        v44[#v44 + 1] = p42;
        TeleportService:SetTeleportSetting("CmdrCommandHistory", v44);
    end,

    GetHistory = function(p45) -- Line: 178, Name: GetHistory
        -- upvalues: RunService (copy), TeleportService (copy)
        local v46 = RunService:IsClient();
        assert(v46, "GetHistory may only be used from the client.");

        return TeleportService:GetTeleportSetting("CmdrCommandHistory") or {};
    end
};

return function(p48) -- Line: 184
    -- upvalues: u47 (copy)
    u47.Cmdr = p48;
    u47.Registry = p48.Registry;

    return u47;
end;