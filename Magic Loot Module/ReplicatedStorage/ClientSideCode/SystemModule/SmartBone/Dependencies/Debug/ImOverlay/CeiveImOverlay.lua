-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local u1 = Font.new("rbxasset://fonts/families/PressStart2P.json");
local u2 = {};
u2.__index = u2;

function u2.new(p3, p4, p5) -- Line: 22
    -- upvalues: GuiService (copy), u2 (copy)
    local v6 = p5 == nil and true or p5;
    local v7 = UDim2.fromOffset(25, 5 + GuiService:GetGuiInset().Y);
    local v8 = UDim2.new(1, -25, 1, -5);
    local v9 = UDim2.fromOffset(0, 0);
    local v10 = UDim2.fromScale(1, 1);
    local v11 = setmetatable({}, u2);
    v11.DefaultY = p3 or 5;
    v11.TextSize = p4 or 11;
    v11.BackFrame = Instance.new("Frame");

    if v6 then
        v9 = v7 or v9;
    end;

    v11.BackFrame.Position = v9;

    if v6 then
        v10 = v8 or v10;
    end;

    v11.BackFrame.Size = v10;
    v11.BackFrame.Name = "BackFrame";
    v11.BackFrame.Transparency = 1;
    v11.ListLayout = Instance.new("UIListLayout");
    v11.ListLayout.Padding = UDim.new(0, 2);
    v11.ListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    v11.ListLayout.Parent = v11.BackFrame;
    v11.m_Indent = 0;
    v11.DidUpdate = false;
    v11.m_State = "";
    v11.m_PreviousState = "";
    v11.m_RenderGroup = {};
    v11.m_ItemPool = {};

    return v11;
end;

function u2.Begin(p12, p13, p14, p15) -- Line: 64
    if not p13 or type(p13) ~= "string" then
        warn("Expected text to ImOverlay::Begin", debug.traceback());

        return;
    end;

    if p14 and typeof(p14) ~= "Color3" then
        warn("BackgroundColor should be a Color3", debug.traceback());

        return;
    end;

    if p15 and typeof(p15) ~= "Color3" then
        warn("TextColor should be a Color3", debug.traceback());

        return;
    end;

    p12:Text(p13, p14, p15);
    p12.m_Indent = p12.m_Indent + 1;
end;

function u2.End(p16) -- Line: 84
    if p16.m_Indent - 1 < 0 then
        error("Too many callbacks to ImOverlay::End");

        return;
    end;

    p16.m_Indent = p16.m_Indent - 1;
end;

function u2.Text(p17, p18, p19, p20) -- Line: 93
    if not p18 or type(p18) ~= "string" then
        warn("Expected text to ImOverlay::Text", debug.traceback());

        return;
    end;

    if p19 and typeof(p19) ~= "Color3" then
        warn("BackgroundColor should be a Color3", debug.traceback());

        return;
    end;

    if p20 and typeof(p20) ~= "Color3" then
        warn("TextColor should be a Color3", debug.traceback());

        return;
    end;

    local v21 = p19 or Color3.new();
    local v22 = p20 or Color3.new(1, 1, 1);
    table.insert(p17.m_RenderGroup, {
        Text = p18,
        TextColor = v22,
        BackgroundColor = v21,
        Indent = p17.m_Indent
    });
    p17.m_State = p17.m_State .. `{p18}|{v22}|{v21}|{p17.m_Indent}`;
end;

function u2.m_Pool(p23) -- Line: 122
    for _, child in p23.BackFrame:GetChildren() do
        if not child:IsA("UIListLayout") and child.Visible then
            child.Visible = false;
            table.insert(p23.m_ItemPool, child);
        end;
    end;
end;

function u2.m_Cleanup(p24) -- Line: 137
    p24.m_State = "";
    p24.m_Indent = 0;
    p24.m_RenderGroup = {};
end;

function u2.m_CreateLabel(p25, p26, p27, p28, p29) -- Line: 145
    -- upvalues: u1 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Background";
    Frame.AutomaticSize = Enum.AutomaticSize.XY;
    Frame.BackgroundColor3 = p28;
    Frame.BackgroundTransparency = 0.4;
    Frame.BorderSizePixel = 0;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TaskText";
    TextLabel.FontFace = u1;
    TextLabel.Text = p26;
    TextLabel.TextColor3 = p27;
    TextLabel.TextSize = p25.TextSize;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Position = UDim2.fromOffset(p29 * 50, 0);
    TextLabel.Size = UDim2.fromOffset(0, p25.DefaultY);
    TextLabel.Parent = Frame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0, 2);
    UIPadding.Parent = TextLabel;
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "UIPadding";
    UIPadding2.PaddingRight = UDim.new(0, 5);
    UIPadding2.PaddingLeft = UDim.new(0, 5);
    UIPadding2.Parent = Frame;

    return Frame;
end;

function u2.Render(p30) -- Line: 182
    if p30.m_State == "" then
        p30:m_Pool();
        p30:m_Cleanup();
        p30.DidUpdate = false;

        return;
    end;

    p30.m_State = p30.m_State .. `{p30.DefaultY}|{p30.TextSize}`;

    if p30.m_State == p30.m_PreviousState then
        p30:m_Cleanup();
        p30.DidUpdate = false;

        return;
    end;

    p30:m_Pool();
    p30.m_PreviousState = p30.m_State;
    p30.DidUpdate = true;

    for i, v in p30.m_RenderGroup do
        if #p30.m_ItemPool == 0 then
            local v31 = p30:m_CreateLabel(v.Text, v.TextColor, v.BackgroundColor, v.Indent);
            v31.LayoutOrder = i;
            v31.Parent = p30.BackFrame;
        else
            local v32 = table.remove(p30.m_ItemPool, #p30.m_ItemPool);
            local TaskText = v32.TaskText;
            v32.LayoutOrder = i;
            v32.BackgroundColor3 = v.BackgroundColor;
            TaskText.Text = v.Text;
            TaskText.TextColor3 = v.TextColor;
            TaskText.Position = UDim2.fromOffset(50 * v.Indent, 0);
            v32.Visible = true;
            v32.Parent = p30.BackFrame;
        end;
    end;

    p30:m_Cleanup();
end;

function u2.Destroy(p33) -- Line: 239
    p33.BackFrame:Destroy();
    setmetatable(p33, nil);
end;

return u2;