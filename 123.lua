local npc = script.Parent
local humanoid = npc:FindFirstChildOfClass("Humanoid")
local head = npc:FindFirstChild("Head")  -- Make sure NPC has a Head
local prompt = head:FindFirstChild("ProximityPrompt") -- The toggle button
local shootInterval = 1  -- Time between shots
local range = 100  -- Detection and shooting range
local aimbotEnabled = false  -- Starts off

-- Function to get the closest player
local function getClosestPlayer()
    local players = game.Players:GetPlayers()
    local closestPlayer = nil
    local closestDistance = range

    for _, player in ipairs(players) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local char = player.Character
            local distance = (char.HumanoidRootPart.Position - head.Position).magnitude

            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = char
            end
        end
    end

    return closestPlayer
end

-- Function to make NPC aim and shoot
local function aimAndShoot()
    while true do
        if aimbotEnabled then
            local target = getClosestPlayer()
            if target then
                local targetPos = target.HumanoidRootPart.Position
                head.CFrame = CFrame.lookAt(head.Position, targetPos)  -- NPC aims at the player

                -- Simulate shooting
                local bullet = Instance.new("Part")
                bullet.Size = Vector3.new(0.3, 0.3, 0.3)
                bullet.Shape = Enum.PartType.Ball
                bullet.Material = Enum.Material.Neon
                bullet.BrickColor = BrickColor.new("Bright red")
                bullet.Position = head.Position
                bullet.Velocity = (targetPos - head.Position).unit * 50
                bullet.Parent = game.Workspace

                -- Bullet disappears after 3 seconds
                game:GetService("Debris"):AddItem(bullet, 3)
            end
        end
        wait(shootInterval)
    end
end

-- Function to toggle the aimbot
local function toggleAimbot(player)
    aimbotEnabled = not aimbotEnabled  -- Switch state
    if aimbotEnabled then
        print("Aimbot ENABLED by " .. player.Name)
    else
        print("Aimbot DISABLED by " .. player.Name)
    end
end

-- Connect the ProximityPrompt to toggle function
if prompt then
    prompt.Triggered:Connect(toggleAimbot)
else
    warn("No ProximityPrompt found! Make sure you added it to the NPC's head.")
end

-- Start the NPC aimbot loop
task.spawn(aimAndShoot)
