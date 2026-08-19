local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Clean Up GUI Lama
if PlayerGui:FindFirstChild("RagdollMenuRGB") then
	PlayerGui.RagdollMenuRGB:Destroy()
end

-- ==========================================
-- 1. UTAMA (SCREEN GUI)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RagdollMenuRGB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Helper RGB Stroke
local function applyRGB(strokeObject)
	task.spawn(function()
		local hue = 0
		while strokeObject and strokeObject.Parent do
			hue = (hue + 0.005) % 1
			strokeObject.Color = Color3.fromHSV(hue, 1, 1)
			RunService.RenderStepped:Wait()
		end
	end)
end

-- ==========================================
-- 2. ANIMASI INTRO (pinpin -> Logo P)
-- ==========================================
local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "IntroFrame"
IntroFrame.Size = UDim2.new(0, 160, 0, 50)
IntroFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
IntroFrame.AnchorPoint = Vector2.new(0.5, 0.5)
IntroFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IntroFrame.ClipsDescendants = true
IntroFrame.Parent = ScreenGui

local introCorner = Instance.new("UICorner", IntroFrame)
introCorner.CornerRadius = UDim.new(0, 10)

local introStroke = Instance.new("UIStroke", IntroFrame)
introStroke.Thickness = 2.5
applyRGB(introStroke)

local IntroLabel = Instance.new("TextLabel")
IntroLabel.Size = UDim2.new(1, 0, 1, 0)
IntroLabel.BackgroundTransparency = 1
IntroLabel.Text = "pinpin"
IntroLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroLabel.TextSize = 20
IntroLabel.Font = Enum.Font.GothamBold
IntroLabel.Parent = IntroFrame

-- ==========================================
-- 3. UI KEY SYSTEM
-- ==========================================
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 0, 0, 0)
KeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyFrame.ClipsDescendants = true
KeyFrame.Visible = false
KeyFrame.Parent = ScreenGui

Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)
local keyStroke = Instance.new("UIStroke", KeyFrame)
keyStroke.Thickness = 2.5
applyRGB(keyStroke)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 35)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "🔑 ENTER KEY"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 14
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -30, 0, 35)
KeyInput.Position = UDim2.new(0, 15, 0, 45)
KeyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
KeyInput.PlaceholderText = "Masukkan Key..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 13
KeyInput.Font = Enum.Font.Gotham
KeyInput.Parent = KeyFrame
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(1, -30, 0, 35)
SubmitBtn.Position = UDim2.new(0, 15, 0, 90)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SubmitBtn.Text = "SUBMIT"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.TextSize = 13
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Parent = KeyFrame
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 6)

-- ==========================================
-- 4. MAIN FRAME & LOGO MINIMIZE
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 190)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, -95)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Thickness = 2.5
applyRGB(mainStroke)

local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, -30, 0, 30)
TitleBar.Position = UDim2.new(0, 10, 0, 0)
TitleBar.BackgroundTransparency = 1
TitleBar.Text = "NAPOLEON EXPLOIT"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.TextSize = 12
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.Parent = MainFrame

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -28, 0, 3)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = MainFrame

local OpenLogoBtn = Instance.new("TextButton")
OpenLogoBtn.Name = "OpenLogoBtn"
OpenLogoBtn.Size = UDim2.new(0, 45, 0, 45)
OpenLogoBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
OpenLogoBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenLogoBtn.Text = "P"
OpenLogoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenLogoBtn.TextSize = 22
OpenLogoBtn.Font = Enum.Font.GothamBold
OpenLogoBtn.Active = true
OpenLogoBtn.Draggable = true
OpenLogoBtn.Visible = false
OpenLogoBtn.Parent = ScreenGui

Instance.new("UICorner", OpenLogoBtn).CornerRadius = UDim.new(1, 0)
local logoStroke = Instance.new("UIStroke", OpenLogoBtn)
logoStroke.Thickness = 2.5
applyRGB(logoStroke)

-- ==========================================
-- 5. LOGIKA EVENT & ISI KODE ASLI
-- ==========================================

local function createButton(text, posY, color, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.Parent = MainFrame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(callback)
end

createButton("Back", 35, Color3.fromRGB(200, 50, 50), function()
	pcall(function() 
		local char = Players.LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local hrp = char.HumanoidRootPart
			local targetCF = CFrame.new(547.90, 70.43, -368.05) * CFrame.Angles(math.rad(-180.00), math.rad(-84.14), math.rad(-180.00))
			
			local RagdollEvent = game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Modules"):WaitForChild("Ragdoll"):WaitForChild("Ragdoll")
			
			firesignal(RagdollEvent.OnClientEvent, "Make", 2.5, Vector3.new(0, 0, 0))
			firesignal(RagdollEvent.OnClientEvent, "Destroy", 2.5)
			
			hrp.CFrame = targetCF
			hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end
	end)
end)

createButton("Front", 85, Color3.fromRGB(200, 100, 40), function()
	pcall(function() 
		local char = Players.LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local hrp = char.HumanoidRootPart
			local targetCF = CFrame.new(3394.73, 70.43, -328.51) * CFrame.Angles(math.rad(-180.00), math.rad(18.58), math.rad(-180.00))
			
			local RagdollEvent = game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Modules"):WaitForChild("Ragdoll"):WaitForChild("Ragdoll")
			
			-- 1. Make Ragdoll
			firesignal(RagdollEvent.OnClientEvent, "Make", 2.5, Vector3.new(0, 0, 0))
			
			-- 2. Langsung Destroy
			firesignal(RagdollEvent.OnClientEvent, "Destroy", 2.5)
			
			-- 3. Langsung TP
			hrp.CFrame = targetCF
			hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end
	end)
end)

createButton("Up", 135, Color3.fromRGB(50, 150, 50), function()
	pcall(function()
		local RagdollEvent = game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Modules"):WaitForChild("Ragdoll"):WaitForChild("Ragdoll")
		firesignal(RagdollEvent.OnClientEvent, "Destroy", 2.5) 
	end)
end)

local freezeGuardActive = false
createButton("Freeze Guard", 185, Color3.fromRGB(50, 150, 150), function()
	freezeGuardActive = not freezeGuardActive
	
	if freezeGuardActive then
		print("Guard Freeze & Banish ENABLED! 🥶")
		task.spawn(function()
			while freezeGuardActive do
				pcall(function()
					local guardAreas = workspace:FindFirstChild("__OBJECTS") 
						and workspace.__OBJECTS:FindFirstChild("Areas")
						and workspace.__OBJECTS.Areas:FindFirstChild("GuardAreas")
					
					if guardAreas then
						for _, areaModel in ipairs(guardAreas:GetChildren()) do
							local guard = areaModel:FindFirstChild("Guard") or areaModel:FindFirstChild("ForestGuardAuthored")
							if guard then
								local hrp = guard:FindFirstChild("HumanoidRootPart")
								local hum = guard:FindFirstChildOfClass("Humanoid")
								if hrp then
									-- 1. Kunci pergerakannya
									hrp.Anchored = true
									
									-- 2. Pindahkan hitbox/badannya jauh ke bawah tanah (-500) agar tidak bisa nyerang (jarak serangnya terbatas)
									hrp.CFrame = CFrame.new(hrp.Position.X, -500, hrp.Position.Z)
								end
								if hum then
									hum.WalkSpeed = 0
								end
							end
						end
					end
				end)
				task.wait(0.1) -- Loop cepat
			end
			
			-- Jika dimatikan, Unanchor semua guard dan biarkan game me-reset posisi mereka
			pcall(function()
				local guardAreas = workspace:FindFirstChild("__OBJECTS") and workspace.__OBJECTS.Areas:FindFirstChild("GuardAreas")
				if guardAreas then
					for _, areaModel in ipairs(guardAreas:GetChildren()) do
						local guard = areaModel:FindFirstChild("Guard") or areaModel:FindFirstChild("ForestGuardAuthored")
						if guard then
							local hrp = guard:FindFirstChild("HumanoidRootPart")
							if hrp then 
								hrp.Anchored = false 
								-- Naikkan lagi sedikit agar game bisa mendeteksi posisinya
								hrp.CFrame = CFrame.new(hrp.Position.X, 70, hrp.Position.Z)
							end
						end
					end
				end
			end)
		end)
	else
		print("Guard Freeze DISABLED! 🏃")
	end
end)

-- ==========================================
-- 6. SEQUENCE ANIMASI JALAN
-- ==========================================
task.spawn(function()
	-- 1. Tampilkan teks "pinpin"
	task.wait(1.2)
	
	-- 2. Ubah teks dari "pinpin" menjadi "P" & jadikan kotaknya bulat
	IntroLabel.Text = "P"
	IntroLabel.TextSize = 24
	
	local toCircle = TweenService:Create(IntroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 50, 0, 50)
	})
	local toCorner = TweenService:Create(introCorner, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		CornerRadius = UDim.new(1, 0)
	})
	
	toCircle:Play()
	toCorner:Play()
	
	task.wait(1)
	
	-- 3. Hilangkan Logo P animasi, buka UI Key
	local closeIntro = TweenService:Create(IntroFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0)
	})
	closeIntro:Play()
	
	closeIntro.Completed:Connect(function()
		IntroFrame:Destroy()
		
		KeyFrame.Visible = true
		TweenService:Create(KeyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 220, 0, 140)
		}):Play()
	end)
end)

-- Verifikasi Key
SubmitBtn.MouseButton1Click:Connect(function()
	if KeyInput.Text == "pin" then
		local closeKey = TweenService:Create(KeyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0)
		})
		closeKey:Play()
		
		closeKey.Completed:Connect(function()
			KeyFrame:Destroy()
			MainFrame.Visible = true
			MainFrame.Size = UDim2.new(0, 0, 0, 0)
			TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 200, 0, 190)
			}):Play()
		end)
	else
		KeyInput.Text = ""
		KeyInput.PlaceholderText = "Key Salah!"
	end
end)

-- Minimize System
MinimizeBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	OpenLogoBtn.Visible = true
end)

OpenLogoBtn.MouseButton1Click:Connect(function()
	OpenLogoBtn.Visible = false
	MainFrame.Visible = true
end)

-- ============================================================
-- [TEST] RAGDOLL TP: Fire "Make" → langsung TP (no wait)
-- ============================================================
local function ragdollThenTP(targetCF)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not (char and hrp and hum) then return end

    local RagdollEvent = game:GetService("ReplicatedStorage")
        :WaitForChild("Library"):WaitForChild("Modules")
        :WaitForChild("Ragdoll"):WaitForChild("Ragdoll")

    -- Fire ragdoll Make
    firesignal(RagdollEvent.OnClientEvent, "Make", 2.5, Vector3.new(0, 0, 0))

    -- Tunggu 1 frame saja (≈0.016 detik) agar engine commit Physics state
    task.wait()

    -- TP langsung
    hrp.CFrame = targetCF
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

    -- Destroy ragdoll setelah 2.5 detik (sesuai durasi Make)
    task.delay(2.5, function()
        firesignal(RagdollEvent.OnClientEvent, "Destroy", 2.5)
    end)
end

-- Test: tekan Z untuk TP 15 stud ke depan
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Z then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            task.spawn(ragdollThenTP, hrp.CFrame * CFrame.new(0, 0, -15))
        end
    end
end)
