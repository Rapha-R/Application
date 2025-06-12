----------------------------------------------------------------
-- Part 1: ServerScriptService - CoinScript
----------------------------------------------------------------

local collectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local coinsTag = collectionService:GetTagged("Coins")
local spinningCoins = {}

for i, coin in pairs(coinsTag) do
	local pressable = true
	coin.Position = Vector3.new(math.random(-50, 50), 5, math.random(-50, 50))

	coin.Touched:Connect(function(otherPart)
		local player = Players:GetPlayerFromCharacter(otherPart.Parent)
		if not player then return end

		local leaderstats = player:FindFirstChild("leaderstats")
		local coinsStat = leaderstats and leaderstats:FindFirstChild("Coins")
		local coinAddition = leaderstats and leaderstats:FindFirstChild("CoinAddition")
		local coinMeter = player.PlayerGui.Shop.CoinMeter

		if player and coin and pressable and coinsStat then
			pressable = false
			coin.Material = Enum.Material.Neon
			coinsStat.Value += coinAddition.Value
			coinMeter.Text = ("$".. coinsStat.Value)
			wait(1)
			coin.Position = Vector3.new(math.random(-50, 50), 5, math.random(-50, 50))
			coin.Material = Enum.Material.Plastic
			wait(0.5)
			pressable = true
		end
	end)

	spinningCoins[coin] = 0
end

local spinSpeed = 90

RunService.Heartbeat:Connect(function(deltaTime)
	for coin, rotation in pairs(spinningCoins) do
		if coin and coin.Parent then
			rotation += spinSpeed * deltaTime
			rotation %= 360
			coin.CFrame = CFrame.new(coin.Position) * CFrame.Angles(0, math.rad(rotation), 0)
			spinningCoins[coin] = rotation
		else
			spinningCoins[coin] = nil
		end
	end
end)


----------------------------------------------------------------
-- Part 2: ServerScriptService - leaderstatScript
----------------------------------------------------------------

game.Players.PlayerAdded:Connect(function(plr)
	local leaderstats = Instance.new("Folder", plr)
	leaderstats.Name = "leaderstats"

	local coins = Instance.new("IntValue", leaderstats)
	coins.Name = "Coins"
	coins.Value = 0

	local speed = Instance.new("IntValue", leaderstats)
	speed.Name = "Speed"
	speed.Value = 16

	local coinAddition = Instance.new("IntValue", leaderstats)
	coinAddition.Name = "CoinAddition"
	coinAddition.Value = 1

	local coinColor = Instance.new("Color3Value", leaderstats)
	coinColor.Name = "CoinColor"
	coinColor.Value = Color3.fromRGB(255, 255, 0)
end)


local shopFunction = game.ReplicatedStorage.ShopFunction

shopFunction.OnServerInvoke = function(plr, upgradeName, upgradePrice)
	local purchaseSuccesful = false

	local leaderstats = plr.leaderstats
	local coins = leaderstats.Coins
	local speed = leaderstats.Speed
	local coinAddition = leaderstats.CoinAddition
	local coinColor = leaderstats.CoinColor
	local coinMeter = plr.PlayerGui.Shop.CoinMeter

	if coins.Value >= upgradePrice then
		coins.Value -= upgradePrice
		coinMeter.Text = ("$".. coins.Value)
		purchaseSuccesful = true

		if upgradeName == "SpeedUpgrade" then
			speed.Value += 1
			plr.Character.Humanoid.WalkSpeed = speed.Value

		elseif upgradeName == "CoinUpgrade" then
			coinAddition.Value += 1

		elseif upgradeName == "ColorUpgrade" then
			coinColor.Value = Color3.fromRGB(
				math.random(0, 255),
				math.random(0, 255),
				math.random(0, 255)
			)
		end
	end

	return purchaseSuccesful
end


----------------------------------------------------------------
-- Part 3: StarterGui - Shop(ScreenGui) - ShopScript
----------------------------------------------------------------

local gui = script.Parent
local openShop = gui.OpenShop

local shopButtons = gui.ShopBackground
local speedUpgrade = shopButtons.SpeedUpgrade
local colorUpgrade = shopButtons.ChangeCoinColor
local coinUpgrade = shopButtons.CoinUpgrade
local purchaseMsg = shopButtons.Welcome

local shopButtonCollection = {shopButtons, speedUpgrade, colorUpgrade, coinUpgrade, purchaseMsg}
local shopIsOpen = true

local shopFunction = game.ReplicatedStorage.ShopFunction

openShop.MouseButton1Click:Connect(function()
	shopIsOpen = not shopIsOpen

	for _, element in ipairs(shopButtonCollection) do
		if shopIsOpen then
			element.Visible = false
		else
			element.Visible = true
		end
	end
end)

speedUpgrade.MouseButton1Click:Connect(function()
	local purchaseSuccesful = shopFunction:InvokeServer("SpeedUpgrade", 1)

	if purchaseSuccesful then
		purchaseMsg.Text = "Purchase Successful!"
		purchaseMsg.BackgroundColor3 = Color3.new(0.431373, 0.85098, 0.0862745)
		wait(3)
		purchaseMsg.BackgroundColor3 = Color3.fromRGB(0, 179, 255)
		purchaseMsg.Text = "Welcome to my shop!"
	else
		purchaseMsg.Text = "Purchase failed"
		purchaseMsg.BackgroundColor3 = Color3.new(0.686275, 0, 0.0117647)
		wait(3)
		purchaseMsg.Text = "Welcome to my shop!"
		purchaseMsg.BackgroundColor3 = Color3.fromRGB(0, 179, 255)
	end
end)

colorUpgrade.MouseButton1Click:Connect(function()
	local purchaseSuccesful = shopFunction:InvokeServer("ColorUpgrade", 10)

	if purchaseSuccesful then
		purchaseMsg.Text = "Purchase Successful!"
		purchaseMsg.BackgroundColor3 = Color3.new(0.431373, 0.85098, 0.0862745)
		wait(3)
		purchaseMsg.Text = "Welcome to my shop!"
		purchaseMsg.BackgroundColor3 = Color3.fromRGB(0, 179, 255)
	else
		purchaseMsg.Text = "Purchase failed"
		purchaseMsg.BackgroundColor3 = Color3.new(0.686275, 0, 0.0117647)
		wait(3)
		purchaseMsg.Text = "Welcome to my shop!"
		purchaseMsg.BackgroundColor3 = Color3.fromRGB(0, 179, 255)
	end
end)

coinUpgrade.MouseButton1Click:Connect(function()
	local purchaseSuccesful = shopFunction:InvokeServer("CoinUpgrade", 10)

	if purchaseSuccesful then
		purchaseMsg.Text = "Purchase Successful!"
		purchaseMsg.BackgroundColor3 = Color3.new(0.431373, 0.85098, 0.0862745)
		wait(3)
		purchaseMsg.Text = "Welcome to my shop!"
		purchaseMsg.BackgroundColor3 = Color3.fromRGB(0, 179, 255)
	else
		purchaseMsg.Text = "Purchase failed"
		purchaseMsg.BackgroundColor3 = Color3.new(0.686275, 0, 0.0117647)
		wait(3)
		purchaseMsg.Text = "Welcome to my shop!"
		purchaseMsg.BackgroundColor3 = Color3.fromRGB(0, 179, 255)
	end
end)


----------------------------------------------------------------
-- Part 4: StarterPlayer - StarterPlayerScripts - UpdateCoinColor
----------------------------------------------------------------

local collectionService = game:GetService("CollectionService")
local player = game.Players.LocalPlayer

local function updateCoinColors()
	local coinColor = player:WaitForChild("leaderstats"):WaitForChild("CoinColor").Value
	local coins = collectionService:GetTagged("Coins")
	for _, coin in ipairs(coins) do
		coin.Color = coinColor
	end
end

updateCoinColors()

local coinColorValue = player:WaitForChild("leaderstats"):WaitForChild("CoinColor")
coinColorValue:GetPropertyChangedSignal("Value"):Connect(function()
	updateCoinColors()
end)
