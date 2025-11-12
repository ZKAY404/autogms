-- Auto Grandmaster Place GUI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoGrandmasterGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(0.5, -125, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
mainFrame.BorderColor3 = Color3.fromRGB(0, 180, 180)
mainFrame.BorderSizePixel = 2
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 35)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Auto Grandmaster Place"
titleLabel.Font = Enum.Font.Code
titleLabel.TextSize = 16
titleLabel.TextColor3 = Color3.fromRGB(0, 180, 180)
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Parent = mainFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 100, 0, 40)
toggleButton.Position = UDim2.new(0.5, -50, 0, 60)
toggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
toggleButton.BorderColor3 = Color3.fromRGB(0, 180, 180)
toggleButton.BorderSizePixel = 1
toggleButton.Text = "OFF"
toggleButton.Font = Enum.Font.Code
toggleButton.TextSize = 18
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.AutoButtonColor = false
toggleButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = toggleButton

-- Variables
local isEnabled = false
local autoLoop = nil
local playerFarm = nil
local canPlantCFrame = nil

-- Find player farm
local function findPlayerFarm()
	local workspaceFarm = workspace:FindFirstChild("Farm")
	if not workspaceFarm then
		warn("Farm not found in workspace")
		return nil
	end
	
	for _, farm in ipairs(workspaceFarm:GetChildren()) do
		if farm.Name == "Farm" then
			local important = farm:FindFirstChild("Important")
			if important then
				local data = important:FindFirstChild("Data")
				if data then
					local owner = data:FindFirstChild("Owner")
					if owner and owner:IsA("StringValue") and owner.Value == player.Name then
						return farm
					end
				end
			end
		end
	end
	
	warn("Player farm not found")
	return nil
end

-- Find Can_Plant CFrame
local function findCanPlantCFrame()
	if not playerFarm then
		playerFarm = findPlayerFarm()
	end
	
	if not playerFarm then
		warn("Cannot find player farm for Can_Plant")
		return nil
	end
	
	local important = playerFarm:FindFirstChild("Important")
	if not important then
		warn("Important not found in player farm")
		return nil
	end
	
	local plantLocations = important:FindFirstChild("Plant_Locations")
	if not plantLocations then
		warn("Plant_Locations not found in Important")
		return nil
	end
	
	-- Get first child which is a Can_Plant
	local firstCanPlant = plantLocations:GetChildren()[1]
	if not firstCanPlant then
		warn("No Can_Plant found in Plant_Locations")
		return nil
	end
	
	-- Try to get CFrame from the Can_Plant
	if firstCanPlant:IsA("BasePart") then
		return firstCanPlant.CFrame
	elseif firstCanPlant:IsA("Model") and firstCanPlant.PrimaryPart then
		return firstCanPlant.PrimaryPart.CFrame
	else
		warn("Cannot get CFrame from Can_Plant")
		return nil
	end
end

-- Initialize on script load
task.spawn(function()
	task.wait(0.1) -- Wait for game to load
	playerFarm = findPlayerFarm()
	canPlantCFrame = findCanPlantCFrame()
	
	if canPlantCFrame then
		print("Can_Plant CFrame found:", canPlantCFrame)
	else
		warn("Failed to find Can_Plant CFrame on load")
	end
end)

-- Find Grandmaster Sprinkler in backpack
local function findGMSInBackpack()
	local backpack = player:FindFirstChild("Backpack")
	if not backpack then return nil end
	
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:match("^Grandmaster Sprinkler") then
			return tool
		end
	end
	
	return nil
end

-- Move all tools from character to backpack
local function moveToolsToBackpack()
	local character = player.Character
	if not character then return end
	
	for _, item in ipairs(character:GetChildren()) do
		if item:IsA("Tool") then
			item.Parent = player.Backpack
		end
	end
end

-- Equip GMS from backpack
local function equipGMS(gms)
	if gms and gms.Parent == player.Backpack then
		local character = player.Character
		if character and character:FindFirstChild("Humanoid") then
			character.Humanoid:EquipTool(gms)
		end
	end
end

-- Main auto function
local function autoGrandmasterPlace()
	while isEnabled do
		task.wait(0.5) -- Check every 0.5 seconds
		
		-- Re-find farm and CFrame if not found
		if not playerFarm then
			playerFarm = findPlayerFarm()
		end
		
		if not canPlantCFrame then
			canPlantCFrame = findCanPlantCFrame()
		end
		
		if not canPlantCFrame then
			warn("Cannot find Can_Plant CFrame, retrying...")
			task.wait(5)
			continue
		end
		
		-- Find player farm
		if not playerFarm then
			warn("Cannot find player farm")
			task.wait(5)
			continue
		end
		
		local important = playerFarm:FindFirstChild("Important")
		if not important then continue end
		
		local objects = important:FindFirstChild("Objects_Physical")
		if not objects then continue end
		
		-- Find GMS in backpack
		local gms = findGMSInBackpack()
		if not gms then
			warn("Grandmaster Sprinkler not found in backpack")
			task.wait(5)
			continue
		end
		
		-- Find highest Lifetime value
		local highestLifetime = 0
		local foundGMS = false
		
		for _, child in ipairs(objects:GetChildren()) do
			if child.Name:match("^Grandmaster Sprinkler") then
				foundGMS = true
				local lifetime = child:GetAttribute("Lifetime")
				if lifetime and lifetime > highestLifetime then
					highestLifetime = lifetime
				end
			end
		end
		
		-- If no GMS in farm OR highest lifetime <= 2, place new one
		if not foundGMS or highestLifetime <= 2 then
			if not foundGMS then
				print("No Grandmaster Sprinkler in farm - Placing new one")
			else
				print("Lifetime is " .. highestLifetime .. " - Placing new Grandmaster Sprinkler")
			end
			
			-- Move all tools to backpack
			moveToolsToBackpack()
			
			-- Equip GMS
			equipGMS(gms)
			task.wait(0.5)
			
			-- Fire server remote
			local success, err = pcall(function()
				ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("SprinklerService"):FireServer(
					"Create", 
					canPlantCFrame
				)
			end)
			
			if success then
				print("Grandmaster Sprinkler placed successfully!")
			else
				warn("Failed to place Grandmaster Sprinkler:", err)
			end
			
			task.wait(0.5) -- Wait before checking again
		end
	end
end

-- Toggle button functionality
toggleButton.MouseButton1Click:Connect(function()
	isEnabled = not isEnabled
	
	if isEnabled then
		toggleButton.Text = "ON"
		toggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
		print("Auto Grandmaster Place: ENABLED")
		
		-- Start auto loop
		autoLoop = task.spawn(autoGrandmasterPlace)
	else
		toggleButton.Text = "OFF"
		toggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		print("Auto Grandmaster Place: DISABLED")
		
		-- Stop auto loop (it will stop on next iteration)
	end
end)

-- Hover effect
toggleButton.MouseEnter:Connect(function()
	if isEnabled then
		toggleButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
	else
		toggleButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	end
end)

toggleButton.MouseLeave:Connect(function()
	if isEnabled then
		toggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
	else
		toggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
	end
end)

-- Make GUI Draggable
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragInput, mousePos, framePos

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - mousePos
		mainFrame.Position = UDim2.new(
			framePos.X.Scale,
			framePos.X.Offset + delta.X,
			framePos.Y.Scale,
			framePos.Y.Offset + delta.Y
		)
	end
end)

print("Auto Grandmaster Place GUI Loaded!")
