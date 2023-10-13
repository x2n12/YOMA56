local function callback(Text)
 if Text == "จริงพี่" then
  game.StarterGui:SetCore("SendNotification",  {
 Title = "ขอบคุณค้าบ";
 Text = "";
 Icon = "";
 Duration = 5;
 Callback = NotificationBindable;
})
elseif Text == ("โม้ไอสัส") then
  game.StarterGui:SetCore("SendNotification",  {
 Title = "เดี๋ยวมึงเจอ";
 Text = "";
 Icon = "";
 Duration = 5;
 Callback = NotificationBindable;
})
 end
end

local NotificationBindable = Instance.new("BindableFunction")
NotificationBindable.OnInvoke = callback
--
game.StarterGui:SetCore("SendNotification",  {
 Title = "YOMA56";
 Text = "เว็บพนันNO.1ในเขมร";
 Icon = "";
 Duration = 8888888;
 Button1 = "จริงพี่";
 Button2 = "โม้";
 Callback = NotificationBindable;
})

local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local vim = game:GetService("VirtualInputManager")

local ballFolder = workspace.Balls
local indicatorPart = Instance.new("Part")
indicatorPart.Size = Vector3.new(2.1, 2.1, 2.1)
indicatorPart.Anchored = true
indicatorPart.CanCollide = false
indicatorPart.Transparency = 0.7
indicatorPart.BrickColor = BrickColor.new("Bright red")
indicatorPart.Parent = workspace

local lastBallPressed = nil
local isKeyPressed = false

local function calculatePredictionTime(ball, player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        local relativePosition = ball.Position - rootPart.Position
        local velocity = ball.Velocity + rootPart.Velocity 
        local a = (ball.Size.magnitude / 0.24) 
        local b = relativePosition.magnitude
        local c = math.sqrt(a * a + b * b)
        local timeToCollision = (c - a) / velocity.magnitude
        return timeToCollision
    end
    return math.huge
end

local function updateIndicatorPosition(ball)
    indicatorPart.Position = ball.Position
end

local function checkProximityToPlayer(ball, player)
    local predictionTime = calculatePredictionTime(ball, player)
    local realBallAttribute = ball:GetAttribute("realBall")
    local target = ball:GetAttribute("target")
    
    local ballSpeedThreshold = math.max(0.2, 0.4 - ball.Velocity.magnitude * 0.01)

    if predictionTime <= ballSpeedThreshold and realBallAttribute == true and target == player.Name and not isKeyPressed then
        vim:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
        wait(0.001)
        vim:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
        lastBallPressed = ball
        isKeyPressed = true
    elseif lastBallPressed == ball and (predictionTime > ballSpeedThreshold or realBallAttribute ~= true or target ~= player.Name) then
        isKeyPressed = false
    end
end

local function checkBallsProximity()
    local player = players.LocalPlayer
    if player then
        for _, ball in pairs(ballFolder:GetChildren()) do
            checkProximityToPlayer(ball, player)
            updateIndicatorPosition(ball)
        end
    end
end

runService.Heartbeat:Connect(checkBallsProximity)

print("YOMA NO.1")
