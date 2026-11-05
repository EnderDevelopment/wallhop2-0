local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer

local WALL_CHECK_DISTANCE = 3.5
local WALL_JUMP_COOLDOWN = 0.18
local WALL_JUMP_HORIZONTAL_SPEED = 42
local WALL_JUMP_VERTICAL_SPEED = 48
local WALL_JUMP_DURATION = 0.16
local WALL_NORMAL_Y_LIMIT = 0.75

local character
local humanoid
local rootPart
local lastWallJump = 0
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local function setCharacter(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    raycastParams.FilterDescendantsInstances = { character }
end

local function findWallNormal()
    if not rootPart or not humanoid or humanoid.Health <= 0 then
        return nil
    end

    local origin = rootPart.Position
    local directions = {
        rootPart.CFrame.LookVector,
        -rootPart.CFrame.LookVector,
        rootPart.CFrame.RightVector,
        -rootPart.CFrame.RightVector,
    }

    local closestResult
    for _, direction in ipairs(directions) do
        local result = workspace:Raycast(origin, direction * WALL_CHECK_DISTANCE, raycastParams)
        if result and math.abs(result.Normal.Y) < WALL_NORMAL_Y_LIMIT then
            if not closestResult or result.Distance < closestResult.Distance then
                closestResult = result
            end
        end
    end

    return closestResult and closestResult.Normal or nil
end

local function performWallHop()
    if not humanoid or humanoid.Health <= 0 then
        return
    end

    local currentTime = os.clock()
    if currentTime - lastWallJump < WALL_JUMP_COOLDOWN then
        return
    end

    local state = humanoid:GetState()
    if state ~= Enum.HumanoidStateType.Freefall and state ~= Enum.HumanoidStateType.Jumping then
        return
    end

    local wallNormal = findWallNormal()
    if not wallNormal then
        return
    end

    lastWallJump = currentTime
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

    local awayFromWall = Vector3.new(wallNormal.X, 0, wallNormal.Z).Unit
    local jumpVelocity = awayFromWall * WALL_JUMP_HORIZONTAL_SPEED + Vector3.new(0, WALL_JUMP_VERTICAL_SPEED, 0)
    rootPart.AssemblyLinearVelocity = Vector3.new(jumpVelocity.X, jumpVelocity.Y, jumpVelocity.Z)

    local attachment = rootPart:FindFirstChild("WallHopAttachment") or Instance.new("Attachment")
    attachment.Name = "WallHopAttachment"
    attachment.Parent = rootPart

    local force = Instance.new("VectorForce")
    force.Name = "WallHopImpulse"
    force.Attachment0 = attachment
    force.RelativeTo = Enum.ActuatorRelativeTo.World
    force.ApplyAtCenterOfMass = true
    force.Force = jumpVelocity * rootPart.AssemblyMass / WALL_JUMP_DURATION
    force.Parent = rootPart
    Debris:AddItem(force, WALL_JUMP_DURATION)
end

if player.Character then
    setCharacter(player.Character)
end
player.CharacterAdded:Connect(setCharacter)
UserInputService.JumpRequest:Connect(performWallHop)
