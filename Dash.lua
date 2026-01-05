local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Notification to show script loaded
StarterGui:SetCore("SendNotification", {
	Title = "Dash System",
	Text = "Double-tap W to Dash!",
	Duration = 3,
	Icon = "rbxassetid://6034509993" -- Optional: Fast icon
})

-- Settings
local DASH_FORCE = 160
local DASH_DURATION = 0.1
local DASH_COOLDOWN = 0.35
local DOUBLE_TAP_WINDOW = 0.25 

-- Variables
local lastTime = 0
local isDashing = false
local canDash = true

local function applyDash(directionVector)
	if not canDash or isDashing then return end
	
	canDash = false
	isDashing = true
	
	local attachment = Instance.new("Attachment", rootPart)
	local velocity = Instance.new("LinearVelocity", attachment)
	
	velocity.MaxForce = 1000000 
	velocity.VectorVelocity = directionVector * DASH_FORCE
	velocity.Attachment0 = attachment
	
	task.wait(DASH_DURATION)
	velocity:Destroy()
	attachment:Destroy()
	isDashing = false
	
	task.wait(DASH_COOLDOWN)
	canDash = true
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end 
	
	if input.KeyCode == Enum.KeyCode.W then
		local currentTime = tick()
		
		if (currentTime - lastTime) < DOUBLE_TAP_WINDOW then
			local lookVec = rootPart.CFrame.LookVector
			local moveDirection = Vector3.new(lookVec.X, 0, lookVec.Z).Unit
			
			applyDash(moveDirection)
		end
		
		lastTime = currentTime
	end
end)
