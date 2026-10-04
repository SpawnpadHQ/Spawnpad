local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Waypoint = require(ReplicatedStorage:WaitForChild("Spawnpad"):WaitForChild("Waypoint"))

local sessions = {}

local function onPlayerAdded(player)
	print("Player added: " .. player.Name)
	local waypoint = Waypoint.new(player.UserId)
	sessions[player.UserId] = waypoint
end

local function onPlayerRemoving(player)
	print("Player removed: " .. player.Name)
	sessions[player.UserId] = nil
end

-- just in case some players weren't fired in onPlayerAdded
for _, player in ipairs(Players:GetPlayers()) do
	if sessions[player.UserId] then
		return
	end
	onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
