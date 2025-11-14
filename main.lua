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
mainFrame.Size = UDim2.new(0, 250, 0, 300)
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
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Auto Grandmaster Place"
titleLabel.Font = Enum.Font.Code
titleLabel.TextSize = 14
titleLabel.TextColor3 = Color3.fromRGB(0, 180, 180)
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Parent = mainFrame

-- Toggle Button (Grandmaster)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 100, 0, 35)
toggleButton.Position = UDim2.new(0.5, -50, 0, 40)
toggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
toggleButton.BorderColor3 = Color3.fromRGB(0, 180, 180)
toggleButton.BorderSizePixel = 1
toggleButton.Text = "OFF"
toggleButton.Font = Enum.Font.Code
toggleButton.TextSize = 16
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.AutoButtonColor = false
toggleButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = toggleButton

-- Separator
local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, -20, 0, 2)
separator.Position = UDim2.new(0, 10, 0, 90)
separator.BackgroundColor3 = Color3.fromRGB(0, 180, 180)
separator.BorderSizePixel = 0
separator.Parent = mainFrame

-- Auto Dilo Boost Section
local diloTitle = Instance.new("TextLabel")
diloTitle.Size = UDim2.new(1, -20, 0, 30)
diloTitle.Position = UDim2.new(0, 10, 0, 100)
diloTitle.BackgroundTransparency = 1
diloTitle.Text = "Auto Dilo Boost"
diloTitle.Font = Enum.Font.Code
diloTitle.TextSize = 14
diloTitle.TextColor3 = Color3.fromRGB(0, 180, 180)
diloTitle.TextXAlignment = Enum.TextXAlignment.Center
diloTitle.Parent = mainFrame

-- Pet IDs TextBox
local petIdsBox = Instance.new("TextBox")
petIdsBox.Size = UDim2.new(1, -20, 0, 60)
petIdsBox.Position = UDim2.new(0, 10, 0, 135)
petIdsBox.BackgroundColor3 = Color3.fromRGB(12, 15, 18)
petIdsBox.BorderColor3 = Color3.fromRGB(0, 150, 150)
petIdsBox.BorderSizePixel = 1
petIdsBox.Text = '{bcd648fe-55d8-408c-b05b-4dbde4f47517},{763d8ffd-101d-4907-95bc-a353a3a763bf}'
petIdsBox.PlaceholderText = "Enter Pet IDs separated by commas"
petIdsBox.Font = Enum.Font.Code
petIdsBox.TextSize = 11
petIdsBox.TextColor3 = Color3.fromRGB(220, 220, 220)
petIdsBox.TextXAlignment = Enum.TextXAlignment.Left
petIdsBox.TextYAlignment = Enum.TextYAlignment.Top
petIdsBox.MultiLine = true
petIdsBox.ClearTextOnFocus = false
petIdsBox.TextWrapped = true
petIdsBox.Parent = mainFrame

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 4)
textBoxCorner.Parent = petIdsBox

local textBoxPadding = Instance.new("UIPadding")
textBoxPadding.PaddingLeft = UDim.new(0, 5)
textBoxPadding.PaddingRight = UDim.new(0, 5)
textBoxPadding.PaddingTop = UDim.new(0, 5)
textBoxPadding.PaddingBottom = UDim.new(0, 5)
textBoxPadding.Parent = petIdsBox

-- Toggle Button (Dilo Boost)
local diloToggleButton = Instance.new("TextButton")
diloToggleButton.Name = "DiloToggleButton"
diloToggleButton.Size = UDim2.new(0, 100, 0, 35)
diloToggleButton.Position = UDim2.new(0.5, -50, 0, 205)
diloToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
diloToggleButton.BorderColor3 = Color3.fromRGB(0, 180, 180)
diloToggleButton.BorderSizePixel = 1
diloToggleButton.Text = "OFF"
diloToggleButton.Font = Enum.Font.Code
diloToggleButton.TextSize = 16
diloToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
diloToggleButton.AutoButtonColor = false
diloToggleButton.Parent = mainFrame

local diloButtonCorner = Instance.new("UICorner")
diloButtonCorner.CornerRadius = UDim.new(0, 6)
diloButtonCorner.Parent = diloToggleButton

-- Variables
local isEnabled = false
local autoLoop = nil
local playerFarm = nil
local canPlantCFrame = nil

local isDiloEnabled = false
local diloAutoLoop = nil
local diloBoostPaused = false -- Pause flag for Dilo Boost

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

-- Find tool in backpack with flexible name matching
local function findToolInBackpack(toolNamePattern)
	local backpack = player:FindFirstChild("Backpack")
	if not backpack then return nil end
	
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") then
			-- Check if tool name contains the pattern (for names like "Small Toy Boost x5[Passive]")
			if tool.Name:find(toolNamePattern) then
				return tool
			end
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

-- Equip tool from backpack
local function equipTool(tool)
	if tool and tool.Parent == player.Backpack then
		local character = player.Character
		if character and character:FindFirstChild("Humanoid") then
			character.Humanoid:EquipTool(tool)
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
		local gms = findToolInBackpack("Grandmaster Sprinkler")
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
        	diloBoostPaused = true
        	print("Pausing Dilo Boost - GMS needs placement")
			
			-- Move all tools to backpack
			moveToolsToBackpack()
			
			-- Equip GMS
			equipTool(gms)
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
		else
        	diloBoostPaused = false
        	print("Resuming Dilo Boost - GMS is good")
		end
	end
end

-- Parse Pet IDs from text
local function parsePetIds(text)
	local ids = {}
	-- Match patterns like {id} without quotes, script will add them
	for id in text:gmatch('({[^}]+})') do
		table.insert(ids, id)
	end
	return ids
end

-- Auto Dilo Boost Function
local function autoDiloBoost()
	while isDiloEnabled do
		-- Wait if paused by GMS placement
		while diloBoostPaused do
			task.wait(0.5)
		end
		
		if not isDiloEnabled then break end
		
		-- Parse pet IDs
		local petIds = parsePetIds(petIdsBox.Text)
		if #petIds == 0 then
			warn("No valid pet IDs found")
			task.wait(5)
			continue
		end
		
		-- Move all tools to backpack first
		moveToolsToBackpack()
		task.wait(0.2)
		
		-- Find Small Pet Toy
		local smallBoost = findToolInBackpack("Small Pet Toy")
		if smallBoost then
			print("Using Small Pet Toy")
			equipTool(smallBoost)
			task.wait(0.3)
			
			-- Fire for each pet ID
			for _, petId in ipairs(petIds) do
				local success, err = pcall(function()
					ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetBoostService"):FireServer("ApplyBoost", petId)
				end)
				if success then
					print("Applied Small Boost to", petId)
				else
					warn("Failed to apply Small Boost:", err)
				end
				task.wait(0.1)
			end
			
			-- Move back to backpack
			moveToolsToBackpack()
			task.wait(0.2)
		else
			warn("Small Pet Toy not found in backpack")
		end
		
		-- Find Medium Pet Toy
		local mediumBoost = findToolInBackpack("Medium Pet Toy")
		if mediumBoost then
			print("Using Medium Pet Toy")
			equipTool(mediumBoost)
			task.wait(0.3)
			
			-- Fire for each pet ID
			for _, petId in ipairs(petIds) do
				local success, err = pcall(function()
					ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetBoostService"):FireServer("ApplyBoost", petId)
				end)
				if success then
					print("Applied Medium Boost to", petId)
				else
					warn("Failed to apply Medium Boost:", err)
				end
				task.wait(0.1)
			end
			
			-- Move back to backpack
			moveToolsToBackpack()
			task.wait(0.2)
		else
			warn("Medium Pet Toy not found in backpack")
		end
	end
end

-- Toggle button functionality (Grandmaster)
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
		
		-- Unpause Dilo Boost when Auto GMS is disabled
		diloBoostPaused = false
	end
end)

-- Hover effect (Grandmaster)
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

-- Toggle button functionality (Dilo Boost)
diloToggleButton.MouseButton1Click:Connect(function()
	isDiloEnabled = not isDiloEnabled
	
	if isDiloEnabled then
		diloToggleButton.Text = "ON"
		diloToggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
		print("Auto Dilo Boost: ENABLED")
		
		-- Start auto loop
		diloAutoLoop = task.spawn(autoDiloBoost)
	else
		diloToggleButton.Text = "OFF"
		diloToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		print("Auto Dilo Boost: DISABLED")
	end
end)

-- Hover effect (Dilo Boost)
diloToggleButton.MouseEnter:Connect(function()
	if isDiloEnabled then
		diloToggleButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
	else
		diloToggleButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	end
end)

diloToggleButton.MouseLeave:Connect(function()
	if isDiloEnabled then
		diloToggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
	else
		diloToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
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
