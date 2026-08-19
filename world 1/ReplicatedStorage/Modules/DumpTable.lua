-- Decompiled with Potassium's decompiler.

function dump(p1)
    local u2 = {
        ["\7"] = "\\a",
        ["\8"] = "\\b",
        ["\f"] = "\\f",
        ["\n"] = "\\n",
        ["\r"] = "\\r",
        ["\t"] = "\\t",
        ["\11"] = "\\v",
        ["\0"] = "\\0"
    };
    local u3 = {
        ["and"] = true,
        ["break"] = true,
        ["do"] = true,
        ["else"] = true,
        ["elseif"] = true,
        ["end"] = true,
        ["false"] = true,
        ["for"] = true,
        ["function"] = true,
        ["if"] = true,
        ["in"] = true,
        ["local"] = true,
        ["nil"] = true,
        ["not"] = true,
        ["or"] = true,
        ["repeat"] = true,
        ["return"] = true,
        ["then"] = true,
        ["true"] = true,
        ["until"] = true,
        ["while"] = true,
        continue = true
    };
    local u4 = {
        [DockWidgetPluginGuiInfo.new] = "DockWidgetPluginGuiInfo.new",
        [warn] = "warn",
        [CFrame.fromMatrix] = "CFrame.fromMatrix",
        [CFrame.fromAxisAngle] = "CFrame.fromAxisAngle",
        [CFrame.fromOrientation] = "CFrame.fromOrientation",
        [CFrame.fromEulerAnglesXYZ] = "CFrame.fromEulerAnglesXYZ",
        [CFrame.Angles] = "CFrame.Angles",
        [CFrame.fromEulerAnglesYXZ] = "CFrame.fromEulerAnglesYXZ",
        [CFrame.new] = "CFrame.new",
        [gcinfo] = "gcinfo",
        [os.clock] = "os.clock",
        [os.difftime] = "os.difftime",
        [os.time] = "os.time",
        [os.date] = "os.date",
        [tick] = "tick",
        [bit32.band] = "bit32.band",
        [bit32.extract] = "bit32.extract",
        [bit32.bor] = "bit32.bor",
        [bit32.bnot] = "bit32.bnot",
        [bit32.arshift] = "bit32.arshift",
        [bit32.rshift] = "bit32.rshift",
        [bit32.rrotate] = "bit32.rrotate",
        [bit32.replace] = "bit32.replace",
        [bit32.lshift] = "bit32.lshift",
        [bit32.lrotate] = "bit32.lrotate",
        [bit32.btest] = "bit32.btest",
        [bit32.bxor] = "bit32.bxor",
        [pairs] = "pairs",
        [NumberSequence.new] = "NumberSequence.new",
        [assert] = "assert",
        [tonumber] = "tonumber",
        [Color3.fromHSV] = "Color3.fromHSV",
        [Color3.toHSV] = "Color3.toHSV",
        [Color3.fromRGB] = "Color3.fromRGB",
        [Color3.new] = "Color3.new",
        [Delay] = "Delay",
        [Stats] = "Stats",
        [UserSettings] = "UserSettings",
        [coroutine.resume] = "coroutine.resume",
        [coroutine.yield] = "coroutine.yield",
        [coroutine.running] = "coroutine.running",
        [coroutine.status] = "coroutine.status",
        [coroutine.wrap] = "coroutine.wrap",
        [coroutine.create] = "coroutine.create",
        [coroutine.isyieldable] = "coroutine.isyieldable",
        [NumberRange.new] = "NumberRange.new",
        [PhysicalProperties.new] = "PhysicalProperties.new",
        [PluginManager] = "PluginManager",
        [Ray.new] = "Ray.new",
        [NumberSequenceKeypoint.new] = "NumberSequenceKeypoint.new",
        [Version] = "Version",
        [Vector2.new] = "Vector2.new",
        [Instance.new] = "Instance.new",
        [delay] = "delay",
        [spawn] = "spawn",
        [unpack] = "unpack",
        [string.split] = "string.split",
        [string.match] = "string.match",
        [string.gmatch] = "string.gmatch",
        [string.upper] = "string.upper",
        [string.gsub] = "string.gsub",
        [string.format] = "string.format",
        [string.lower] = "string.lower",
        [string.sub] = "string.sub",
        [string.pack] = "string.pack",
        [string.rep] = "string.rep",
        [string.char] = "string.char",
        [string.packsize] = "string.packsize",
        [string.reverse] = "string.reverse",
        [string.byte] = "string.byte",
        [string.unpack] = "string.unpack",
        [string.len] = "string.len",
        [string.find] = "string.find",
        [CellId.new] = "CellId.new",
        [ypcall] = "ypcall",
        [version] = "version",
        [print] = "print",
        [stats] = "stats",
        [printidentity] = "printidentity",
        [settings] = "settings",
        [UDim2.fromOffset] = "UDim2.fromOffset",
        [UDim2.fromScale] = "UDim2.fromScale",
        [UDim2.new] = "UDim2.new",
        [table.pack] = "table.pack",
        [table.move] = "table.move",
        [table.insert] = "table.insert",
        [table.getn] = "table.getn",
        [table.foreachi] = "table.foreachi",
        [table.maxn] = "table.maxn",
        [table.foreach] = "table.foreach",
        [table.concat] = "table.concat",
        [table.unpack] = "table.unpack",
        [table.find] = "table.find",
        [table.create] = "table.create",
        [table.sort] = "table.sort",
        [table.remove] = "table.remove",
        [TweenInfo.new] = "TweenInfo.new",
        [loadstring] = "loadstring",
        [require] = "require",
        [Vector3.FromNormalId] = "Vector3.FromNormalId",
        [Vector3.FromAxis] = "Vector3.FromAxis",
        [Vector3.fromAxis] = "Vector3.fromAxis",
        [Vector3.fromNormalId] = "Vector3.fromNormalId",
        [Vector3.new] = "Vector3.new",
        [Vector3int16.new] = "Vector3int16.new",
        [setmetatable] = "setmetatable",
        [next] = "next",
        [Wait] = "Wait",
        [wait] = "wait",
        [ipairs] = "ipairs",
        [elapsedTime] = "elapsedTime",
        [time] = "time",
        [rawequal] = "rawequal",
        [Vector2int16.new] = "Vector2int16.new",
        [collectgarbage] = "collectgarbage",
        [newproxy] = "newproxy",
        [Spawn] = "Spawn",
        [PluginDrag.new] = "PluginDrag.new",
        [Region3.new] = "Region3.new",
        [utf8.offset] = "utf8.offset",
        [utf8.codepoint] = "utf8.codepoint",
        [utf8.nfdnormalize] = "utf8.nfdnormalize",
        [utf8.char] = "utf8.char",
        [utf8.codes] = "utf8.codes",
        [utf8.len] = "utf8.len",
        [utf8.graphemes] = "utf8.graphemes",
        [utf8.nfcnormalize] = "utf8.nfcnormalize",
        [xpcall] = "xpcall",
        [tostring] = "tostring",
        [rawset] = "rawset",
        [PathWaypoint.new] = "PathWaypoint.new",
        [DateTime.fromUnixTimestamp] = "DateTime.fromUnixTimestamp",
        [DateTime.now] = "DateTime.now",
        [DateTime.fromIsoDate] = "DateTime.fromIsoDate",
        [DateTime.fromUnixTimestampMillis] = "DateTime.fromUnixTimestampMillis",
        [DateTime.fromLocalTime] = "DateTime.fromLocalTime",
        [DateTime.fromUniversalTime] = "DateTime.fromUniversalTime",
        [Random.new] = "Random.new",
        [typeof] = "typeof",
        [RaycastParams.new] = "RaycastParams.new",
        [math.log] = "math.log",
        [math.ldexp] = "math.ldexp",
        [math.rad] = "math.rad",
        [math.cosh] = "math.cosh",
        [math.random] = "math.random",
        [math.frexp] = "math.frexp",
        [math.tanh] = "math.tanh",
        [math.floor] = "math.floor",
        [math.max] = "math.max",
        [math.sqrt] = "math.sqrt",
        [math.modf] = "math.modf",
        [math.pow] = "math.pow",
        [math.atan] = "math.atan",
        [math.tan] = "math.tan",
        [math.cos] = "math.cos",
        [math.sign] = "math.sign",
        [math.clamp] = "math.clamp",
        [math.log10] = "math.log10",
        [math.noise] = "math.noise",
        [math.acos] = "math.acos",
        [math.abs] = "math.abs",
        [math.sinh] = "math.sinh",
        [math.asin] = "math.asin",
        [math.min] = "math.min",
        [math.deg] = "math.deg",
        [math.fmod] = "math.fmod",
        [math.randomseed] = "math.randomseed",
        [math.atan2] = "math.atan2",
        [math.ceil] = "math.ceil",
        [math.sin] = "math.sin",
        [math.exp] = "math.exp",
        [getfenv] = "getfenv",
        [pcall] = "pcall",
        [ColorSequenceKeypoint.new] = "ColorSequenceKeypoint.new",
        [ColorSequence.new] = "ColorSequence.new",
        [type] = "type",
        [Region3int16.new] = "Region3int16.new",
        [ElapsedTime] = "ElapsedTime",
        [select] = "select",
        [getmetatable] = "getmetatable",
        [rawget] = "rawget",
        [Faces.new] = "Faces.new",
        [Rect.new] = "Rect.new",
        [BrickColor.Blue] = "BrickColor.Blue",
        [BrickColor.White] = "BrickColor.White",
        [BrickColor.Yellow] = "BrickColor.Yellow",
        [BrickColor.Red] = "BrickColor.Red",
        [BrickColor.Gray] = "BrickColor.Gray",
        [BrickColor.palette] = "BrickColor.palette",
        [BrickColor.New] = "BrickColor.New",
        [BrickColor.Black] = "BrickColor.Black",
        [BrickColor.Green] = "BrickColor.Green",
        [BrickColor.Random] = "BrickColor.Random",
        [BrickColor.DarkGray] = "BrickColor.DarkGray",
        [BrickColor.random] = "BrickColor.random",
        [BrickColor.new] = "BrickColor.new",
        [setfenv] = "setfenv",
        [UDim.new] = "UDim.new",
        [Axes.new] = "Axes.new",
        [error] = "error",
        [debug.traceback] = "debug.traceback",
        [debug.profileend] = "debug.profileend",
        [debug.profilebegin] = "debug.profilebegin"
    };

    local function GetHierarchy(p5) -- Line: 6
        -- upvalues: u2 (copy), u3 (copy)
        local v6 = p5;
        local v7 = 1;
        local v8 = {};

        while p5 do
            p5 = p5.Parent;
            v7 = v7 + 1;
        end;

        local v9 = 0;

        while v6 do
            v9 = v9 + 1;
            local v10 = string.gsub(v6.Name, "[%c%z]", u2);
            local v11 = v6 == game and "game" or v10;

            if u3[v11] or not string.match(v11, "^[_%a][_%w]*$") then
                v11 = "[\"" .. v11 .. "\"]";
            elseif v9 ~= v7 - 1 then
                v11 = "." .. v11;
            end;

            v8[v7 - v9] = v11;
            v6 = v6.Parent;
        end;

        return table.concat(v8);
    end;

    local function SerializeType(p12, p13) -- Line: 37
        -- upvalues: u2 (copy), GetHierarchy (copy), u4 (copy)
        if p13 == "string" then
            return string.format("\"%s\"", string.gsub(p12, "[%c%z]", u2));
        end;

        if p13 == "Instance" then
            return GetHierarchy(p12);
        end;

        if type(p12) ~= p13 then
            return p13 .. ".new(" .. tostring(p12) .. ")";
        end;

        if p13 == "function" then
            return u4[p12] or "\'[Unknown " .. (pcall(setfenv, p12, getfenv(p12)) and "Lua" or "C") .. " " .. tostring(p12) .. "]\'";
        end;

        if p13 == "userdata" then
            local v14 = getmetatable(p12) and true or false;

            return "newproxy(" .. tostring(v14) .. ")";
        end;

        if p13 == "thread" then
            return "\'" .. tostring(p12) .. ", status: " .. coroutine.status(p12) .. "\'";
        end;

        return tostring(p12);
    end;

    local function TableToString(p15, p16, p17, p18) -- Line: 55
        -- upvalues: u2 (copy), u3 (copy), TableToString (copy), SerializeType (copy)
        local v19 = p16 or {};
        local v20 = v19[p15];

        if v20 then
            return (v20[1] == p17[1] - 1 and "\'[Cyclic Parent " or "\'[Cyclic ") .. tostring(p15) .. ", path: " .. v20[2] .. "]\'";
        end;

        local v21 = p18 or "ROOT";
        local v22 = p17 or { 0, v21 };
        local v23 = v22[1] + 1;
        v22[1] = v23;
        v22[2] = v21;
        v19[p15] = v22;
        local v24 = string.rep("    ", v23);
        local v25 = string.rep("    ", v23 - 1);
        local v26 = "\n" .. v24;
        local v27 = 1;
        local v28 = "{";
        local v29 = true;
        local v30 = true;

        for i, v in next, p15 do
            v30 = false;

            if v27 == i then
                v27 = v27 + 1;
            else
                v29 = false;
            end;

            local v31 = typeof(i);
            local v32 = typeof(v);
            local v33 = false;
            local v34;

            if v31 == "string" then
                v34 = string.gsub(i, "[%c%z]", u2);

                if u3[v34] or not string.match(v34, "^[_%a][_%w]*$") then
                    v34 = string.format("[\"%s\"]", v34);
                    v33 = true;
                end;
            else
                v34 = "[" .. (v31 == "table" and string.gsub(TableToString(i, v19, { v23, v21 }), "^%s*(.-)%s*$", "%1") or SerializeType(i, v31)) .. "]";
                v33 = true;
            end;

            local v35 = v32 == "table" and TableToString(v, v19, { v23, v21 }, v21 .. (v33 and "" or ".") .. v34) or SerializeType(v, v32);
            v28 = v28 .. v26 .. (v29 and v35 and v35 or v34 .. " = " .. v35) .. ",";
        end;

        return v30 and v28 .. "}" or string.sub(v28, 1, -2) .. "\n" .. v25 .. "}";
    end;

    return TableToString(p1);
end;

return dump;