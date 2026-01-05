local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Settings
local activationKey = Enum.KeyCode.Q
local windUpTime = 1.2
local pullBackDistance = 2.5 -- How far back you lean before dashing
local maxBoostSpeed = 130
local normalSpeed = 16
local isDashing = false

-- Notification
StarterGui:SetCore("SendNotification", {
	Title = "Cartoon Dash Loaded",
	Text = "Rev up with [Q]!",
	Duration = 5,
})

local function getRunAnimation()
	local animateScript = character:FindFirstChild("Animate")
	if animateScript and animateScript:FindFirstChild("run") then
		return animateScript.run:FindFirstChildOfClass("Animation")
	end
	return nil
end

UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == activationKey and not isDashing then
		isDashing = true
		
		-- 1. Start Run Animation (Revving)
		local runAnim = getRunAnimation()
		local track = nil
		if runAnim then
			track = humanoid:LoadAnimation(runAnim)
			track.Priority = Enum.AnimationPriority.Action
			track:Play()
			track:AdjustSpeed(2) -- Super fast legs
		end
		
		-- 2. Wind Up (Vibrate in place)
		rootPart.Anchored = true
		local startTime = tick()
		while tick() - startTime < windUpTime do
			-- Tiny vibration shake
			rootPart.CFrame = rootPart.CFrame * CFrame.new(math.random(-8, 8)/100, 0, 0)
			task.wait()
		end
		
		-- 3. The "Pull Back" (Anticipation)
		-- Move slightly backward relative to where the character is facing
		local pullBackCFrame = rootPart.CFrame * CFrame.new(0, 0, pullBackDistance)
		
		-- Smoothly tween/slide back for a split second
		for i = 1, 5 do
			rootPart.CFrame = rootPart.CFrame:Lerp(pullBackCFrame, 0.3)
			task.wait(0.02)
		end
		
		-- 4. THE DASH
		rootPart.Anchored = false
		if track then track:Stop() end
		
		-- Quick acceleration ramp
		for i = 1, 8 do
			humanoid.WalkSpeed = (maxBoostSpeed / 8) * i
			task.wait(0.01)
		end
		
		task.wait(0.6) -- Duration of the zoom
		
		-- 5. Reset
		humanoid.WalkSpeed = normalSpeed
		isDashing = false
	end
end)
