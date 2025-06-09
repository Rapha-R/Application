--leaderstats script
game.Players.PlayerAdded:Connect(function(player)
	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"
	stats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "coins"
	coins.Value = 0
	coins.Parent = stats

	local speed = Instance.new("IntValue")
	speed.Name = "speed"
	speed.Value = 16
	speed.Parent = stats

	local activated = Instance.new("BoolValue")
	activated.Name = "activated"
	activated.Value = false
	activated.Parent = stats

	local clicks = Instance.new("IntValue")
	clicks.Name = "clicks"
	clicks.Value = 0
	clicks.Parent = stats

    local jumps = Instance.new("IntValue")
	jumps.Name = "jumps"
	jumps.Value = 5
	jumps.Parent = stats

	local username = player.Name
	print(username .. " has joined the game!")

	player.CharacterAdded:Connect(function(character)
		print(username .. "'s character has spawned!")
	end)

	print("Leaderstats initialized for " .. username)
end)
--script inside a tool
local tool = script.Parent
local handle = tool:WaitForChild("Handle")
local running = false
local player = nil
local clicks = nil
local activated = nil
local function onEquipped()
	local character = tool.Parent
	player = game.Players:GetPlayerFromCharacter(character)
	if player then
		local stats = player:FindFirstChild("leaderstats")
		if stats then
			activated = stats:FindFirstChild("activated")
			clicks = stats:FindFirstChild("clicks")
		end
	end
end
tool.Equipped:Connect(onEquipped)

tool.Activated:Connect(function()
	if activated and clicks and not running then
		running = true
		activated.Value = true
		clicks.Value += 1

		for i = 1, 10 do
			handle.Size += Vector3.new(0.05, 0.05, 0.05)
			task.wait(0.05)
		end

		while activated.Value do
			handle.Color = Color3.new(math.random(), math.random(), math.random())
			task.wait(1)
		end
	end
end)

tool.Deactivated:Connect(function()
	if activated then
		activated.Value = false
		handle.Size = Vector3.new(1, 1, 1)
		running = false
	end
end)
--script inside a coin
local coin = Instance.new("Part")
coin.Name = "Coin"
coin.Size = Vector3.new(0.422, 6.192, 4.589)
coin.Position = Vector3.new(-0.352, 5.235, -12.702)
coin.Orientation = Vector3.new(0, 90, 180)
coin.Anchored = true
coin.Parent = workspace
coin.Shape = "Cylinder"
coin.CanCollide = false
coin.BrickColor = BrickColor.new("New Yeller")

local canTouch = true

coin.Position = Vector3.new(math.random(-50, 50), 7.293, math.random(-50, 50))
task.spawn(function()
	while true do
		coin.Orientation += Vector3.new(0, 5, 0)
		task.wait(0.05)
	end
end)

coin.Touched:Connect(function(otherPart)
	local character = otherPart:FindFirstAncestorOfClass("Model")
	local player = character and game.Players:GetPlayerFromCharacter(character)
	local humanoid = character and character:FindFirstChild("Humanoid")

	if player and humanoid and canTouch then
		local leaderstats = player:FindFirstChild("leaderstats")
		local coinStat = leaderstats and leaderstats:FindFirstChild("coins")
		local speedStat = leaderstats and leaderstats:FindFirstChild("speed")

		if coinStat and speedStat then
			canTouch = false
			coinStat.Value += 1
			speedStat.Value += 1

			coin.Transparency = 1
			coin.CanCollide = false

			coin.Position = Vector3.new(math.random(-50, 50), 7.293, math.random(-50, 50))

			wait(2)

			coin.Transparency = 0
			coin.CanCollide = true
			wait(1)
			canTouch = true
		end
	end
end)
--script that changes walking speed with the speed leaderstat changing
local player = game.Players:GetPlayerFromCharacter(script.Parent)
if not player then return end

local leaderstats = player:WaitForChild("leaderstats")
local speedStat = leaderstats:WaitForChild("speed")
local humanoid = script.Parent:WaitForChild("Humanoid")

humanoid.WalkSpeed = speedStat.Value

speedStat.Changed:Connect(function()
	humanoid.WalkSpeed = speedStat.Value
end)
--teleport pad script
local pad = Instance.new("Part")
pad.Name = "TeleportPad"
pad.Size = Vector3.new(4, 1, 2)
pad.Position = Vector3.new(29.02, 0.5, -23.11)
pad.Anchored = true
pad.Parent = workspace

local destination = Instance.new("Part")
destination.Name = "TeleportDestination"
destination.Size = Vector3.new(4, 1, 2)
destination.Position = Vector3.new(26.072, 0.5, -57.315)
destination.Anchored = true
destination.Parent = workspace

local canTeleport = true

pad.Touched:Connect(function(hit)
	local humanoid = hit.Parent:FindFirstChild("Humanoid")

	if humanoid and canTeleport then
		canTeleport = false
		hit.Parent:MoveTo(destination.Position)

		local effect = Instance.new("ParticleEmitter")
		effect.Rate = 50
		effect.Lifetime = NumberRange.new(1)
		effect.Parent = pad
		game:GetService("Debris"):AddItem(effect, 1)

		task.wait(2)
		canTeleport = true
	end
end)
--Script has color changing part that prints players name when touched
local part = Instance.new("Part")
part.Size = Vector3.new(4, 1, 4)
part.Position = Vector3.new(-22.75, 0.5, -4.23)
part.Anchored = true
part.Parent = workspace
part.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:GetPlayerFromCharacter(character)
	if player then
		print(player.Name .. " touched the part!")
	end
end)

local red = Color3.new(1, 0, 0)
local green = Color3.new(0, 1, 0)
local blue = Color3.new(0, 0, 1)
part.Color = red

while true do
	wait(1)
	if part.Color == red then
		part.Color = green
	elseif part.Color == green then
		part.Color = blue
	else
		part.Color = red
	end
end
--Script for clickable volor changing part
local button = Instance.new("Part")
button.Size = Vector3.new(4, 1, 4)
button.Position = Vector3.new(10, 5, 0)
button.Anchored = true
button.BrickColor = BrickColor.new("Bright yellow")
button.Name = "Button"
button.Parent = workspace

local clickDetector = Instance.new("ClickDetector")
clickDetector.Parent = button

local function onClick(player)
	print(player.Name .. " clicked the button!")

	button.BrickColor = BrickColor.new("Bright green")
	wait(1)

	button.BrickColor = BrickColor.new("Bright yellow")
end

clickDetector.MouseClick:Connect(onClick)

while true do
	for i = 0, 1, 0.01 do
		button.Transparency = i
		wait(0.05)
	end
	for i = 1, 0, -0.01 do
		button.Transparency = i
		wait(0.05)
	end
end