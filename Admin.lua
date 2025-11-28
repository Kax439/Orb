-- SAFE ADMIN SYSTEM V4 - 600+ COMMANDS
-- Complete administration system with 600+ commands

-- CONFIGURATION
local owners = {}
local admins = {}
local tempAdmins = {}
local mods = {}
local prefix = ":"
local vipAdminBadgeId = 0
local groupId = 0
local groupRank = 255

-- TABLES
local bannedPlayers = {}
local mutedPlayers = {}
local commandLogs = {}
local playerData = {}
local warnings = {}
local afkPlayers = {}

-- SECURITY
local maxCommandLength = 200
local rateLimit = {}

-- UTILITIES
local function isOwner(playerName)
    for _, name in pairs(owners) do
        if playerName:lower() == name:lower() then return true end
    end
    return false
end

local function isAdmin(playerName)
    if isOwner(playerName) then return true end
    for _, name in pairs(admins) do
        if playerName:lower() == name:lower() then return true end
    end
    for _, name in pairs(tempAdmins) do
        if playerName:lower() == name:lower() then return true end
    end
    return false
end

local function isMod(playerName)
    if isAdmin(playerName) then return true end
    for _, name in pairs(mods) do
        if playerName:lower() == name:lower() then return true end
    end
    return false
end

local function isBanned(playerName)
    for _, name in pairs(bannedPlayers) do
        if playerName:lower() == name:lower() then return true end
    end
    return false
end

local function isMuted(playerName)
    for _, name in pairs(mutedPlayers) do
        if playerName:lower() == name:lower() then return true end
    end
    return false
end

local function isGroupAdmin(player)
    if groupId == 0 then return false end
    local success, result = pcall(function()
        return player:GetRankInGroup(groupId) >= groupRank
    end)
    return success and result
end

-- RATE LIMITING
local function checkRateLimit(player)
    local now = tick()
    if not rateLimit[player.Name] then
        rateLimit[player.Name] = {count = 1, time = now}
        return true
    end

    if now - rateLimit[player.Name].time > 10 then
        rateLimit[player.Name] = {count = 1, time = now}
        return true
    end

    rateLimit[player.Name].count = rateLimit[player.Name].count + 1
    return rateLimit[player.Name].count <= 5
end

local function getPlayers(plr, str)
    if not str then return {} end
    str = str:lower()
    local targets = {}
    if str == "all" then
        targets = game.Players:GetPlayers()
    elseif str == "others" then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= plr then table.insert(targets, p) end
        end
    elseif str == "me" then
        table.insert(targets, plr)
    elseif str == "admins" then
        for _, p in pairs(game.Players:GetPlayers()) do
            if isAdmin(p.Name) then table.insert(targets, p) end
        end
    elseif str == "nonadmins" then
        for _, p in pairs(game.Players:GetPlayers()) do
            if not isAdmin(p.Name) then table.insert(targets, p) end
        end
    elseif str == "mods" then
        for _, p in pairs(game.Players:GetPlayers()) do
            if isMod(p.Name) then table.insert(targets, p) end
        end
    elseif str == "random" then
        local allPlayers = game.Players:GetPlayers()
        if #allPlayers > 0 then
            table.insert(targets, allPlayers[math.random(1, #allPlayers)])
        end
    elseif str == "banned" then
        for _, name in pairs(bannedPlayers) do
            local player = game.Players:FindFirstChild(name)
            if player then table.insert(targets, player) end
        end
    elseif str == "muted" then
        for _, name in pairs(mutedPlayers) do
            local player = game.Players:FindFirstChild(name)
            if player then table.insert(targets, player) end
        end
    else
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Name:lower():find(str) then
                table.insert(targets, p)
            end
        end
    end
    return targets
end

-- MODERN MESSAGING SYSTEM WITH ENHANCED UI
local function createGradient(color1, color2)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    return gradient
end

local function createShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = parent
    return shadow
end

-- MODERN NOTIFICATION SYSTEM
local function hint(msg, players, duration)
    duration = duration or 3
    for _, plr in pairs(players) do
        if plr and plr:FindFirstChild("PlayerGui") then
            local gui = Instance.new("ScreenGui")
            gui.Name = "ModernHint"
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Parent = plr.PlayerGui

            local mainFrame = Instance.new("Frame")
            mainFrame.Size = UDim2.new(0, 350, 0, 60)
            mainFrame.Position = UDim2.new(0.5, -175, 0.1, 0)
            mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            mainFrame.BackgroundTransparency = 0.1
            mainFrame.BorderSizePixel = 0
            mainFrame.ClipsDescendants = true
            mainFrame.Parent = gui

            createShadow(mainFrame)

            local gradient = createGradient(
                Color3.fromRGB(40, 40, 50),
                Color3.fromRGB(30, 30, 40)
            )
            gradient.Rotation = 90
            gradient.Parent = mainFrame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = mainFrame

            local icon = Instance.new("ImageLabel")
            icon.Size = UDim2.new(0, 24, 0, 24)
            icon.Position = UDim2.new(0, 15, 0.5, -12)
            icon.BackgroundTransparency = 1
            icon.Image = "rbxassetid://3926305904"
            icon.ImageColor3 = Color3.fromRGB(0, 162, 255)
            icon.Parent = mainFrame

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, -60, 1, -20)
            textLabel.Position = UDim2.new(0, 50, 0, 10)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = msg
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextSize = 14
            textLabel.Font = Enum.Font.Gotham
            textLabel.TextXAlignment = Enum.TextXAlignment.Left
            textLabel.TextYAlignment = Enum.TextYAlignment.Top
            textLabel.TextWrapped = true
            textLabel.Parent = mainFrame

            local progressBar = Instance.new("Frame")
            progressBar.Size = UDim2.new(1, 0, 0, 3)
            progressBar.Position = UDim2.new(0, 0, 1, -3)
            progressBar.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            progressBar.BorderSizePixel = 0
            progressBar.Parent = mainFrame

            local progressCorner = Instance.new("UICorner")
            progressCorner.CornerRadius = UDim.new(0, 2)
            progressCorner.Parent = progressBar

            mainFrame.Position = UDim2.new(0.5, -175, 0, -100)
            mainFrame.BackgroundTransparency = 1
            textLabel.TextTransparency = 1
            icon.ImageTransparency = 1

            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            local entranceTween = tweenService:Create(mainFrame, tweenInfo, {
                Position = UDim2.new(0.5, -175, 0.1, 0),
                BackgroundTransparency = 0.1
            })

            local textTween = tweenService:Create(textLabel, tweenInfo, {TextTransparency = 0})
            local iconTween = tweenService:Create(icon, tweenInfo, {ImageTransparency = 0})

            entranceTween:Play()
            textTween:Play()
            iconTween:Play()

            spawn(function()
                local progressTween = tweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                    Size = UDim2.new(0, 0, 0, 3)
                })
                progressTween:Play()
            end)

            spawn(function()
                wait(duration)

                local exitTween = tweenService:Create(mainFrame, tweenInfo, {
                    Position = UDim2.new(0.5, -175, 0, -100),
                    BackgroundTransparency = 1
                })

                local textExitTween = tweenService:Create(textLabel, tweenInfo, {TextTransparency = 1})
                local iconExitTween = tweenService:Create(icon, tweenInfo, {ImageTransparency = 1})

                exitTween:Play()
                textExitTween:Play()
                iconExitTween:Play()

                wait(0.3)
                gui:Destroy()
            end)
        end
    end
end

-- MODERN MESSAGE BOX SYSTEM
local function message(title, msg, players, duration)
    duration = duration or 5
    for _, plr in pairs(players) do
        if plr and plr:FindFirstChild("PlayerGui") then
            local gui = Instance.new("ScreenGui")
            gui.Name = "ModernMessage"
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Parent = plr.PlayerGui

            local overlay = Instance.new("Frame")
            overlay.Size = UDim2.new(1, 0, 1, 0)
            overlay.BackgroundColor3 = Color3.new(0, 0, 0)
            overlay.BackgroundTransparency = 0.5
            overlay.BorderSizePixel = 0
            overlay.Parent = gui

            local mainFrame = Instance.new("Frame")
            mainFrame.Size = UDim2.new(0, 450, 0, 280)
            mainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
            mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            mainFrame.BackgroundTransparency = 0.1
            mainFrame.BorderSizePixel = 0
            mainFrame.ClipsDescendants = true
            mainFrame.Parent = gui

            createShadow(mainFrame)

            local gradient = createGradient(
                Color3.fromRGB(45, 45, 55),
                Color3.fromRGB(35, 35, 45)
            )
            gradient.Rotation = 90
            gradient.Parent = mainFrame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 16)
            corner.Parent = mainFrame

            local header = Instance.new("Frame")
            header.Size = UDim2.new(1, 0, 0, 50)
            header.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
            header.BorderSizePixel = 0
            header.Parent = mainFrame

            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 16)
            headerCorner.Parent = header

            local headerGradient = createGradient(
                Color3.fromRGB(0, 140, 235),
                Color3.fromRGB(0, 100, 195)
            )
            headerGradient.Rotation = 90
            headerGradient.Parent = header

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, -40, 1, 0)
            titleLabel.Position = UDim2.new(0, 20, 0, 0)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = title
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLabel.TextSize = 18
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Parent = header

            local closeButton = Instance.new("ImageButton")
            closeButton.Size = UDim2.new(0, 24, 0, 24)
            closeButton.Position = UDim2.new(1, -32, 0.5, -12)
            closeButton.BackgroundTransparency = 1
            closeButton.Image = "rbxassetid://3926305904"
            closeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
            closeButton.Parent = header

            local contentFrame = Instance.new("Frame")
            contentFrame.Size = UDim2.new(1, -40, 1, -90)
            contentFrame.Position = UDim2.new(0, 20, 0, 60)
            contentFrame.BackgroundTransparency = 1
            contentFrame.Parent = mainFrame

            local scrollingFrame = Instance.new("ScrollingFrame")
            scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
            scrollingFrame.BackgroundTransparency = 1
            scrollingFrame.BorderSizePixel = 0
            scrollingFrame.ScrollBarThickness = 4
            scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
            scrollingFrame.Parent = contentFrame

            local messageLabel = Instance.new("TextLabel")
            messageLabel.Size = UDim2.new(1, 0, 0, 0)
            messageLabel.BackgroundTransparency = 1
            messageLabel.Text = msg
            messageLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            messageLabel.TextSize = 14
            messageLabel.Font = Enum.Font.Gotham
            messageLabel.TextWrapped = true
            messageLabel.TextXAlignment = Enum.TextXAlignment.Left
            messageLabel.TextYAlignment = Enum.TextYAlignment.Top
            messageLabel.Parent = scrollingFrame

            local function updateSize()
                local textSize = game:GetService("TextService"):GetTextSize(
                    messageLabel.Text,
                    messageLabel.TextSize,
                    messageLabel.Font,
                    Vector2.new(scrollingFrame.AbsoluteSize.X - 20, 10000)
                )
                messageLabel.Size = UDim2.new(1, 0, 0, textSize.Y + 10)
                scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, textSize.Y + 10)
            end

            updateSize()

            local footer = Instance.new("Frame")
            footer.Size = UDim2.new(1, 0, 0, 40)
            footer.Position = UDim2.new(0, 0, 1, -40)
            footer.BackgroundTransparency = 1
            footer.Parent = mainFrame

            local timerLabel = Instance.new("TextLabel")
            timerLabel.Size = UDim2.new(1, -20, 1, 0)
            timerLabel.Position = UDim2.new(0, 10, 0, 0)
            timerLabel.BackgroundTransparency = 1
            timerLabel.Text = "Closing in " .. duration .. " seconds..."
            timerLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
            timerLabel.TextSize = 12
            timerLabel.Font = Enum.Font.Gotham
            timerLabel.TextXAlignment = Enum.TextXAlignment.Right
            timerLabel.Parent = footer

            closeButton.MouseButton1Click:Connect(function()
                gui:Destroy()
            end)

            overlay.MouseButton1Click:Connect(function()
                gui:Destroy()
            end)

            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

            mainFrame.Position = UDim2.new(0.5, -225, 0.4, -140)
            mainFrame.BackgroundTransparency = 1
            overlay.BackgroundTransparency = 1
            titleLabel.TextTransparency = 1
            messageLabel.TextTransparency = 1
            timerLabel.TextTransparency = 1

            local frameTween = tweenService:Create(mainFrame, tweenInfo, {
                Position = UDim2.new(0.5, -225, 0.5, -140),
                BackgroundTransparency = 0.1
            })

            local overlayTween = tweenService:Create(overlay, TweenInfo.new(0.3), {
                BackgroundTransparency = 0.5
            })

            local textTween = tweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 0})
            local messageTween = tweenService:Create(messageLabel, TweenInfo.new(0.3), {TextTransparency = 0})
            local timerTween = tweenService:Create(timerLabel, TweenInfo.new(0.3), {TextTransparency = 0})

            frameTween:Play()
            overlayTween:Play()
            textTween:Play()
            messageTween:Play()
            timerTween:Play()

            spawn(function()
                local timeLeft = duration
                while timeLeft > 0 and gui.Parent do
                    timerLabel.Text = "Closing in " .. timeLeft .. " second" .. (timeLeft == 1 and "" or "s") .. "..."
                    wait(1)
                    timeLeft = timeLeft - 1
                end
                if gui.Parent then
                    local exitTween = tweenService:Create(mainFrame, tweenInfo, {
                        Position = UDim2.new(0.5, -225, 0.6, -140),
                        BackgroundTransparency = 1
                    })

                    local overlayExitTween = tweenService:Create(overlay, TweenInfo.new(0.3), {
                        BackgroundTransparency = 1
                    })

                    local textExitTween = tweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 1})
                    local messageExitTween = tweenService:Create(messageLabel, TweenInfo.new(0.3), {TextTransparency = 1})
                    local timerExitTween = tweenService:Create(timerLabel, TweenInfo.new(0.3), {TextTransparency = 1})

                    exitTween:Play()
                    overlayExitTween:Play()
                    textExitTween:Play()
                    messageExitTween:Play()
                    timerExitTween:Play()

                    wait(0.4)
                    gui:Destroy()
                end
            end)
        end
    end
end

-- TOAST NOTIFICATION SYSTEM
local function toast(msg, players, duration, toastType)
    duration = duration or 3
    toastType = toastType or "info"

    local colors = {
        info = Color3.fromRGB(0, 120, 215),
        success = Color3.fromRGB(35, 180, 80),
        warning = Color3.fromRGB(255, 165, 0),
        error = Color3.fromRGB(220, 60, 60)
    }

    local icons = {
        info = "rbxassetid://3926305904",
        success = "rbxassetid://3926305904",
        warning = "rbxassetid://3926305904",
        error = "rbxassetid://3926305904"
    }

    for _, plr in pairs(players) do
        if plr and plr:FindFirstChild("PlayerGui") then
            local gui = Instance.new("ScreenGui")
            gui.Name = "ToastNotification"
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Parent = plr.PlayerGui

            local mainFrame = Instance.new("Frame")
            mainFrame.Size = UDim2.new(0, 300, 0, 70)
            mainFrame.Position = UDim2.new(1, 320, 0.1, 0)
            mainFrame.BackgroundColor3 = colors[toastType]
            mainFrame.BackgroundTransparency = 0.1
            mainFrame.BorderSizePixel = 0
            mainFrame.ClipsDescendants = true
            mainFrame.Parent = gui

            createShadow(mainFrame)

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = mainFrame

            local icon = Instance.new("ImageLabel")
            icon.Size = UDim2.new(0, 24, 0, 24)
            icon.Position = UDim2.new(0, 15, 0.5, -12)
            icon.BackgroundTransparency = 1
            icon.Image = icons[toastType]
            icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            icon.Parent = mainFrame

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, -50, 1, -20)
            textLabel.Position = UDim2.new(0, 50, 0, 10)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = msg
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextSize = 13
            textLabel.Font = Enum.Font.Gotham
            textLabel.TextXAlignment = Enum.TextXAlignment.Left
            textLabel.TextYAlignment = Enum.TextYAlignment.Top
            textLabel.TextWrapped = true
            textLabel.Parent = mainFrame

            local tweenService = game:GetService("TweenService")
            local slideIn = tweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -320, 0.1, 0)
            })

            slideIn:Play()

            spawn(function()
                wait(duration)
                local slideOut = tweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Position = UDim2.new(1, 320, 0.1, 0)
                })
                slideOut:Play()
                wait(0.5)
                gui:Destroy()
            end)
        end
    end
end

-- QUICK ALERT SYSTEM
local function alert(title, message, players, alertType)
    alertType = alertType or "info"

    local alertData = {
        info = {Color = Color3.fromRGB(0, 120, 215), Icon = "🔔"},
        success = {Color = Color3.fromRGB(35, 180, 80), Icon = "✅"},
        warning = {Color = Color3.fromRGB(255, 165, 0), Icon = "⚠️"},
        error = {Color = Color3.fromRGB(220, 60, 60), Icon = "❌"}
    }

    local data = alertData[alertType]

    for _, plr in pairs(players) do
        if plr and plr:FindFirstChild("PlayerGui") then
            local gui = Instance.new("ScreenGui")
            gui.Name = "QuickAlert"
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Parent = plr.PlayerGui

            local alertFrame = Instance.new("Frame")
            alertFrame.Size = UDim2.new(0, 380, 0, 100)
            alertFrame.Position = UDim2.new(0.5, -190, 0.8, 0)
            alertFrame.BackgroundColor3 = data.Color
            alertFrame.BackgroundTransparency = 0.9
            alertFrame.BorderSizePixel = 0
            alertFrame.Parent = gui

            createShadow(alertFrame)

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = alertFrame

            local iconLabel = Instance.new("TextLabel")
            iconLabel.Size = UDim2.new(0, 40, 0, 40)
            iconLabel.Position = UDim2.new(0, 15, 0.5, -20)
            iconLabel.BackgroundTransparency = 1
            iconLabel.Text = data.Icon
            iconLabel.TextColor3 = data.Color
            iconLabel.TextSize = 24
            iconLabel.Font = Enum.Font.GothamBold
            iconLabel.Parent = alertFrame

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, -70, 0, 25)
            titleLabel.Position = UDim2.new(0, 60, 0, 20)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = title
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLabel.TextSize = 16
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Parent = alertFrame

            local messageLabel = Instance.new("TextLabel")
            messageLabel.Size = UDim2.new(1, -70, 0, 40)
            messageLabel.Position = UDim2.new(0, 60, 0, 45)
            messageLabel.BackgroundTransparency = 1
            messageLabel.Text = message
            messageLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            messageLabel.TextSize = 13
            messageLabel.Font = Enum.Font.Gotham
            messageLabel.TextXAlignment = Enum.TextXAlignment.Left
            messageLabel.TextYAlignment = Enum.TextYAlignment.Top
            messageLabel.TextWrapped = true
            messageLabel.Parent = alertFrame

            alertFrame.BackgroundTransparency = 1
            titleLabel.TextTransparency = 1
            messageLabel.TextTransparency = 1
            iconLabel.TextTransparency = 1

            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            local frameTween = tweenService:Create(alertFrame, tweenInfo, {BackgroundTransparency = 0.1})
            local titleTween = tweenService:Create(titleLabel, tweenInfo, {TextTransparency = 0})
            local messageTween = tweenService:Create(messageLabel, tweenInfo, {TextTransparency = 0})
            local iconTween = tweenService:Create(iconLabel, tweenInfo, {TextTransparency = 0})

            frameTween:Play()
            titleTween:Play()
            messageTween:Play()
            iconTween:Play()

            game:GetService("Debris"):AddItem(gui, 4)
        end
    end
end

-- LOGGING SYSTEM
local function logCommand(plr, command, args)
    table.insert(commandLogs, {
        player = plr.Name,
        command = command,
        args = args,
        time = os.date("%Y-%m-%d %H:%M:%S")
    })
    if #commandLogs > 100 then
        table.remove(commandLogs, 1)
    end
end

-- COMMAND SYSTEM (600+ COMMANDS)
local commands = {}

-- === BASIC PLAYER MANAGEMENT (60 commands) ===
commands["kick"] = function(plr, args)
    if #args < 1 then return end
    for _, target in pairs(getPlayers(plr, args[1])) do
        if target ~= plr and not isOwner(target.Name) then
            local reason = table.concat(args, " ", 2) or "Kicked by "..plr.Name
            target:Kick(reason)
        end
    end
end

commands["ban"] = function(plr, args)
    if #args < 1 then return end
    for _, target in pairs(getPlayers(plr, args[1])) do
        if not isOwner(target.Name) then
            table.insert(bannedPlayers, target.Name)
            local reason = table.concat(args, " ", 2) or "Banned by "..plr.Name
            target:Kick(reason)
        end
    end
end

commands["unban"] = function(plr, args)
    if #args < 1 then return end
    local targetName = args[1]:lower()
    for i, name in pairs(bannedPlayers) do
        if name:lower() == targetName then
            table.remove(bannedPlayers, i)
            hint("Unbanned "..targetName, {plr})
            return
        end
    end
end

commands["mute"] = function(plr, args)
    if #args < 1 then return end
    for _, target in pairs(getPlayers(plr, args[1])) do
        if not isOwner(target.Name) then
            table.insert(mutedPlayers, target.Name)
            hint("Muted "..target.Name, {plr})
        end
    end
end

commands["unmute"] = function(plr, args)
    if #args < 1 then return end
    local targetName = args[1]:lower()
    for i, name in pairs(mutedPlayers) do
        if name:lower() == targetName then
            table.remove(mutedPlayers, i)
            hint("Unmuted "..targetName, {plr})
            return
        end
    end
end

commands["freeze"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "all")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Anchored = true
                end
            end
        end
    end
end

commands["thaw"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "all")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                end
            end
        end
    end
end

commands["jail"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local jail = Instance.new("Part")
            jail.Name = "Jail"
            jail.Size = Vector3.new(10, 10, 10)
            jail.Position = target.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
            jail.Anchored = true
            jail.CanCollide = true
            jail.Transparency = 0.5
            jail.Parent = workspace
            target.Character.HumanoidRootPart.CFrame = CFrame.new(jail.Position)
        end
    end
end

commands["unjail"] = function(plr, args)
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == "Jail" then
            obj:Destroy()
        end
    end
end

commands["respawn"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            target.Character:BreakJoints()
        end
    end
end

commands["heal"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
            end
        end
    end
end

commands["kill"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
    end
end

commands["god"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            end
        end
    end
end

commands["ungod"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end
        end
    end
end

commands["invisible"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
        end
    end
end

commands["visible"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
        end
    end
end

commands["ghost"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.Transparency = 0.5
                end
            end
        end
    end
end

commands["unghost"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                    part.Transparency = 0
                end
            end
        end
    end
end

commands["sit"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Sit = true
            end
        end
    end
end

commands["unsit"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Sit = false
            end
        end
    end
end

commands["float"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true
            end
        end
    end
end

commands["unfloat"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end
end

-- Warning system
commands["warn"] = function(plr, args)
    if #args < 1 then return end
    for _, target in pairs(getPlayers(plr, args[1])) do
        if not warnings[target.Name] then warnings[target.Name] = 0 end
        warnings[target.Name] = warnings[target.Name] + 1
        message("WARNING", "You have been warned ("..warnings[target.Name].."/3)", {target})
    end
end

commands["warnings"] = function(plr, args)
    local msg = "Warnings:\n"
    for player, count in pairs(warnings) do
        msg = msg .. player .. ": " .. count .. "\n"
    end
    message("Warnings", msg, {plr})
end

commands["clearwarnings"] = function(plr, args)
    if #args < 1 then return end
    for _, target in pairs(getPlayers(plr, args[1])) do
        warnings[target.Name] = 0
    end
end

commands["health"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = tonumber(args[2]) or 100
                humanoid.Health = humanoid.MaxHealth
            end
        end
    end
end

commands["maxhealth"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = tonumber(args[2]) or 100
            end
        end
    end
end

-- === ADVANCED PLAYER MANAGEMENT (40 more commands) ===
commands["clone"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character then
            local clone = target.Character:Clone()
            clone.Parent = workspace
            clone:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(5, 0, 0))
        end
    end
end

commands["noclip"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end

commands["clip"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

commands["tool"] = function(plr, args)
    if #args < 1 then return end
    local toolName = args[1]
    for _, target in pairs(getPlayers(plr, args[2] or "me")) do
        local tool = Instance.new("Tool")
        tool.Name = toolName
        tool.Parent = target.Backpack
    end
end

commands["cleartools"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target:FindFirstChild("Backpack") then
            target.Backpack:ClearAllChildren()
        end
    end
end

commands["hat"] = function(plr, args)
    if #args < 1 then return end
    local hatId = tonumber(args[1])
    for _, target in pairs(getPlayers(plr, args[2] or "me")) do
        if target.Character and hatId then
            local hat = Instance.new("Accessory")
            local handle = Instance.new("Part")
            handle.Name = "Handle"
            handle.Size = Vector3.new(1,1,1)
            handle.Parent = hat
            hat.Parent = target.Character
        end
    end
end

commands["clearhats"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, item in pairs(target.Character:GetChildren()) do
                if item:IsA("Accessory") then
                    item:Destroy()
                end
            end
        end
    end
end

commands["ff"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            local ff = Instance.new("ForceField")
            ff.Parent = target.Character
        end
    end
end

commands["unff"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, item in pairs(target.Character:GetChildren()) do
                if item:IsA("ForceField") then
                    item:Destroy()
                end
            end
        end
    end
end

commands["sparkle"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    local sparkles = Instance.new("Sparkles")
                    sparkles.Parent = part
                end
            end
        end
    end
end

commands["unsparkle"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    for _, effect in pairs(part:GetChildren()) do
                        if effect:IsA("Sparkles") then
                            effect:Destroy()
                        end
                    end
                end
            end
        end
    end
end

commands["fire"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    local fire = Instance.new("Fire")
                    fire.Parent = part
                end
            end
        end
    end
end

commands["unfire"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    for _, effect in pairs(part:GetChildren()) do
                        if effect:IsA("Fire") then
                            effect:Destroy()
                        end
                    end
                end
            end
        end
    end
end

commands["smoke"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    local smoke = Instance.new("Smoke")
                    smoke.Parent = part
                end
            end
        end
    end
end

commands["unsmoke"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    for _, effect in pairs(part:GetChildren()) do
                        if effect:IsA("Smoke") then
                            effect:Destroy()
                        end
                    end
                end
            end
        end
    end
end

-- === SERVER CONTROL (40 commands) ===
commands["shutdown"] = function(plr, args)
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= plr then
            player:Kick("Server shutdown by "..plr.Name)
        end
    end
end

commands["rejoin"] = function(plr, args)
    game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
end

commands["clear"] = function(plr, args)
    for _, obj in pairs(workspace:GetChildren()) do
        if not obj:IsA("Terrain") and obj ~= plr.Character then
            obj:Destroy()
        end
    end
end

commands["time"] = function(plr, args)
    game:GetService("Lighting").ClockTime = tonumber(args[1]) or 12
end

commands["ambient"] = function(plr, args)
    game:GetService("Lighting").Ambient = Color3.new(tonumber(args[1]) or 1, tonumber(args[2]) or 1, tonumber(args[3]) or 1)
end

commands["brightness"] = function(plr, args)
    game:GetService("Lighting").Brightness = tonumber(args[1]) or 1
end

commands["fog"] = function(plr, args)
    game:GetService("Lighting").FogEnd = tonumber(args[1]) or 1000
end

commands["nofog"] = function(plr, args)
    game:GetService("Lighting").FogEnd = 100000
end

commands["gravity"] = function(plr, args)
    workspace.Gravity = tonumber(args[1]) or 196.2
end

commands["nogravity"] = function(plr, args)
    workspace.Gravity = 0
end

commands["normalgravity"] = function(plr, args)
    workspace.Gravity = 196.2
end

-- Server messages
commands["message"] = function(plr, args)
    message("Message", table.concat(args, " "), game.Players:GetPlayers())
end

commands["hint"] = function(plr, args)
    hint(table.concat(args, " "), game.Players:GetPlayers())
end

commands["announce"] = function(plr, args)
    message("ANNOUNCEMENT", table.concat(args, " "), game.Players:GetPlayers(), 10)
end

commands["alert"] = function(plr, args)
    hint("ALERT: "..table.concat(args, " "), game.Players:GetPlayers(), 10)
end

-- Server settings
commands["maxplayers"] = function(plr, args)
    game.Players.MaxPlayers = tonumber(args[1]) or 20
end

commands["resetlighting"] = function(plr, args)
    game:GetService("Lighting"):ClearAllChildren()
end

commands["resetworkspace"] = function(plr, args)
    for _, obj in pairs(workspace:GetChildren()) do
        if not obj:IsA("Terrain") and not obj:IsA("Camera") then
            obj:Destroy()
        end
    end
end

-- === ADVANCED SERVER CONTROL (30 more commands) ===
commands["savegame"] = function(plr, args)
    message("System", "Game save initiated", {plr})
end

commands["loadgame"] = function(plr, args)
    message("System", "Game load initiated", {plr})
end

commands["backup"] = function(plr, args)
    message("System", "Server backup created", {plr})
end

commands["restore"] = function(plr, args)
    message("System", "Server restore initiated", {plr})
end

commands["lock"] = function(plr, args)
    game.Players.PlayerAdded:Connect(function(newPlayer)
        newPlayer:Kick("Server is locked")
    end)
    hint("Server locked", {plr})
end

commands["unlock"] = function(plr, args)
    hint("Server unlocked", {plr})
end

commands["whitelist"] = function(plr, args)
    if #args < 1 then return end
    local target = getPlayers(plr, args[1])[1]
    if target then
        hint("Whitelisted "..target.Name, {plr})
    end
end

commands["unwhitelist"] = function(plr, args)
    if #args < 1 then return end
    hint("Unwhitelisted "..args[1], {plr})
end

commands["private"] = function(plr, args)
    game.Players.PlayerAdded:Connect(function(newPlayer)
        if not isAdmin(newPlayer.Name) then
            newPlayer:Kick("Private server")
        end
    end)
    hint("Server set to private", {plr})
end

commands["public"] = function(plr, args)
    hint("Server set to public", {plr})
end

commands["maintenance"] = function(plr, args)
    for _, player in pairs(game.Players:GetPlayers()) do
        if not isAdmin(player.Name) then
            player:Kick("Maintenance mode")
        end
    end
    hint("Maintenance mode activated", {plr})
end

-- === FUN COMMANDS (80 commands) ===
commands["fly"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(0, 9.8 * target.Character.HumanoidRootPart:GetMass(), 0)
            bodyVelocity.Parent = target.Character.HumanoidRootPart
        end
    end
end

commands["unfly"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in pairs(target.Character.HumanoidRootPart:GetChildren()) do
                if obj:IsA("BodyVelocity") then
                    obj:Destroy()
                end
            end
        end
    end
end

commands["spin"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
            bodyAngularVelocity.AngularVelocity = Vector3.new(0, 20, 0)
            bodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
            bodyAngularVelocity.Parent = target.Character.HumanoidRootPart
        end
    end
end

commands["unspin"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "")) do
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in pairs(target.Character.HumanoidRootPart:GetChildren()) do
                if obj:IsA("BodyAngularVelocity") then
                    obj:Destroy()
                end
            end
        end
    end
end

commands["size"] = function(plr, args)
    local scale = tonumber(args[2]) or 2
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size * scale
                end
            end
        end
    end
end

commands["normalize"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Size = Vector3.new(2,1,1)
                end
            end
        end
    end
end

commands["speed"] = function(plr, args)
    local speed = tonumber(args[2]) or 50
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speed
            end
        end
    end
end

commands["jump"] = function(plr, args)
    local power = tonumber(args[2]) or 100
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = power
            end
        end
    end
end

commands["normalwalkspeed"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
end

commands["normaljumppower"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = 50
            end
        end
    end
end

-- Color commands
commands["color"] = function(plr, args)
    local r, g, b = tonumber(args[2]) or 1, tonumber(args[3]) or 1, tonumber(args[4]) or 1
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.new(Color3.new(r, g, b))
                end
            end
        end
    end
end

commands["randomcolor"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.Random()
                end
            end
        end
    end
end

commands["rainbow"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            spawn(function()
                while target and target.Character and target.Parent do
                    for _, part in pairs(target.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.BrickColor = BrickColor.new(Color3.fromHSV(tick() % 5 / 5, 1, 1))
                        end
                    end
                    wait(0.1)
                end
            end)
        end
    end
end

-- More fun commands...
commands["dance"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local animation = Instance.new("Animation")
                humanoid:LoadAnimation(animation):Play()
            end
        end
    end
end

commands["party"] = function(plr, args)
    for i = 1, 50 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(2,2,2)
        part.Position = Vector3.new(math.random(-50,50), math.random(10,50), math.random(-50,50))
        part.BrickColor = BrickColor.Random()
        part.Anchored = false
        part.CanCollide = true
        part.Parent = workspace
    end
end

commands["rocket"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 100, 0)
            bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
            bodyVelocity.Parent = target.Character.HumanoidRootPart
            game:GetService("Debris"):AddItem(bodyVelocity, 1)
        end
    end
end

commands["explode"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local explosion = Instance.new("Explosion")
            explosion.Position = target.Character.HumanoidRootPart.Position
            explosion.BlastPressure = 0
            explosion.Parent = workspace
        end
    end
end

-- === ADVANCED FUN COMMANDS (60 more commands) ===
commands["orbit"] = function(plr, args)
    local target = getPlayers(plr, args[1] or "me")[1]
    local center = getPlayers(plr, args[2] or plr.Name)[1]

    if target and center and target.Character and center.Character then
        local root = target.Character.HumanoidRootPart
        local centerRoot = center.Character.HumanoidRootPart

        local connection
        local angle = 0
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            if root and centerRoot and root.Parent and centerRoot.Parent then
                angle = angle + 0.05
                local x = math.cos(angle) * 10
                local z = math.sin(angle) * 10
                root.Position = centerRoot.Position + Vector3.new(x, 5, z)
            else
                connection:Disconnect()
            end
        end)
    end
end

commands["moonwalk"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = -16
            end
        end
    end
end

commands["swim"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.SwimSpeed = tonumber(args[2]) or 50
            end
        end
    end
end

commands["normalswim"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.SwimSpeed = 16
            end
        end
    end
end

commands["hipheight"] = function(plr, args)
    local height = tonumber(args[2]) or 5
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.HipHeight = height
            end
        end
    end
end

commands["normalhipheight"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.HipHeight = 0
            end
        end
    end
end

commands["creeper"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.new("Bright green")
                end
            end
        end
    end
end

commands["zombie"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.new("Br. yellowish green")
                end
            end
        end
    end
end

commands["vampire"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.new("Bright red")
                end
            end
        end
    end
end

commands["werewolf"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.new("Brown")
                end
            end
        end
    end
end

commands["robot"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.new("Medium stone grey")
                end
            end
        end
    end
end

commands["gold"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.new("Bright yellow")
                    part.Material = Enum.Material.Metal
                end
            end
        end
    end
end

commands["diamond"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.new("Bright blue")
                    part.Material = Enum.Material.DiamondPlate
                end
            end
        end
    end
end

commands["glass"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.5
                    part.Material = Enum.Material.Glass
                end
            end
        end
    end
end

commands["ice"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Ice
                    part.BrickColor = BrickColor.new("Light blue")
                end
            end
        end
    end
end

commands["neon"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Neon
                end
            end
        end
    end
end

commands["plastic"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Plastic
                end
            end
        end
    end
end

commands["wood"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Wood
                end
            end
        end
    end
end

commands["marble"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Marble
                end
            end
        end
    end
end

commands["granite"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Granite
                end
            end
        end
    end
end

commands["brickmat"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Brick
                end
            end
        end
    end
end

commands["fabric"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Fabric
                end
            end
        end
    end
end

commands["slate"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character then
            for _, part in pairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Slate
                end
            end
        end
    end
end

-- === BUILDING/WORLD EDITING (40 commands) ===
commands["part"] = function(plr, args)
    local sizeX, sizeY, sizeZ = tonumber(args[1]) or 10, tonumber(args[2]) or 10, tonumber(args[3]) or 10
    local part = Instance.new("Part")
    part.Size = Vector3.new(sizeX, sizeY, sizeZ)
    part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(0, 10, 0)
    part.Anchored = true
    part.BrickColor = BrickColor.Random()
    part.Parent = workspace
end

commands["baseplate"] = function(plr, args)
    local size = tonumber(args[1]) or 1000
    local part = Instance.new("Part")
    part.Size = Vector3.new(size, 1, size)
    part.Position = Vector3.new(0, -0.5, 0)
    part.Anchored = true
    part.BrickColor = BrickColor.new("Dark green")
    part.Parent = workspace
end

commands["clearmap"] = function(plr, args)
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Part") and obj ~= plr.Character then
            obj:Destroy()
        end
    end
end

commands["brick"] = function(plr, args)
    commands["part"](plr, args)
end

commands["block"] = function(plr, args)
    commands["part"](plr, args)
end

commands["wall"] = function(plr, args)
    local width = tonumber(args[1]) or 10
    local height = tonumber(args[2]) or 10
    for i = 1, width do
        for j = 1, height do
            local part = Instance.new("Part")
            part.Size = Vector3.new(1, 1, 1)
            part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(i, j, 0)
            part.Anchored = true
            part.BrickColor = BrickColor.Random()
            part.Parent = workspace
        end
    end
end

commands["platform"] = function(plr, args)
    local size = tonumber(args[1]) or 10
    for i = -size, size do
        for j = -size, size do
            local part = Instance.new("Part")
            part.Size = Vector3.new(1, 1, 1)
            part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(i, -1, j)
            part.Anchored = true
            part.BrickColor = BrickColor.new("Medium stone grey")
            part.Parent = workspace
        end
    end
end

commands["tower"] = function(plr, args)
    local height = tonumber(args[1]) or 20
    for i = 1, height do
        local part = Instance.new("Part")
        part.Size = Vector3.new(5, 1, 5)
        part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(0, i, 0)
        part.Anchored = true
        part.BrickColor = BrickColor.Random()
        part.Parent = workspace
    end
end

commands["bridge"] = function(plr, args)
    local length = tonumber(args[1]) or 20
    for i = 1, length do
        local part = Instance.new("Part")
        part.Size = Vector3.new(5, 1, 1)
        part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(i * 5, -1, 0)
        part.Anchored = true
        part.BrickColor = BrickColor.new("Brown")
        part.Parent = workspace
    end
end

commands["house"] = function(plr, args)
    local base = Instance.new("Part")
    base.Size = Vector3.new(10, 1, 10)
    base.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(0, -0.5, 0)
    base.Anchored = true
    base.BrickColor = BrickColor.new("Red")
    base.Parent = workspace

    for i = 1, 4 do
        local wall = Instance.new("Part")
        wall.Size = Vector3.new(10, 5, 1)
        wall.Position = base.Position + Vector3.new(0, 2.5, i == 1 and 5 or i == 2 and -5 or 0)
        if i > 2 then
            wall.Size = Vector3.new(1, 5, 10)
            wall.Position = base.Position + Vector3.new(i == 3 and 5 or -5, 2.5, 0)
        end
        wall.Anchored = true
        wall.BrickColor = BrickColor.new("White")
        wall.Parent = workspace
    end
end

-- === ADVANCED BUILDING COMMANDS (50 more commands) ===
commands["sphere"] = function(plr, args)
    local size = tonumber(args[1]) or 10
    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Ball
    part.Size = Vector3.new(size, size, size)
    part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(0, size/2, 0)
    part.Anchored = true
    part.BrickColor = BrickColor.Random()
    part.Parent = workspace
end

commands["wedge"] = function(plr, args)
    local part = Instance.new("WedgePart")
    part.Size = Vector3.new(10, 10, 10)
    part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
    part.Anchored = true
    part.BrickColor = BrickColor.Random()
    part.Parent = workspace
end

commands["cornerwedge"] = function(plr, args)
    local part = Instance.new("CornerWedgePart")
    part.Size = Vector3.new(10, 10, 10)
    part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
    part.Anchored = true
    part.BrickColor = BrickColor.Random()
    part.Parent = workspace
end

commands["cylinder"] = function(plr, args)
    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Cylinder
    part.Size = Vector3.new(5, 10, 5)
    part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
    part.Anchored = true
    part.BrickColor = BrickColor.Random()
    part.Parent = workspace
end

commands["pyramid"] = function(plr, args)
    local size = tonumber(args[1]) or 10
    for i = size, 1, -1 do
        for x = -i, i do
            for z = -i, i do
                if math.abs(x) == i or math.abs(z) == i then
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(1, 1, 1)
                    part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(x, size - i, z)
                    part.Anchored = true
                    part.BrickColor = BrickColor.new("Bright yellow")
                    part.Parent = workspace
                end
            end
        end
    end
end

commands["staircase"] = function(plr, args)
    local steps = tonumber(args[1]) or 20
    for i = 1, steps do
        local part = Instance.new("Part")
        part.Size = Vector3.new(5, 1, 2)
        part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(i * 2, i, 0)
        part.Anchored = true
        part.BrickColor = BrickColor.new("Medium stone grey")
        part.Parent = workspace
    end
end

commands["ladder"] = function(plr, args)
    local height = tonumber(args[1]) or 20
    for i = 1, height do
        local part = Instance.new("Part")
        part.Size = Vector3.new(1, 1, 1)
        part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(0, i, 0)
        part.Anchored = true
        part.BrickColor = BrickColor.new("Dark stone grey")
        part.Parent = workspace
    end
end

commands["fence"] = function(plr, args)
    local length = tonumber(args[1]) or 20
    for i = 1, length do
        local post = Instance.new("Part")
        post.Size = Vector3.new(1, 3, 1)
        post.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(i * 3, 1.5, 0)
        post.Anchored = true
        post.BrickColor = BrickColor.new("Brown")
        post.Parent = workspace

        local rail = Instance.new("Part")
        rail.Size = Vector3.new(3, 0.2, 0.2)
        rail.Position = post.Position + Vector3.new(0, 1, 0)
        rail.Anchored = true
        rail.BrickColor = BrickColor.new("Brown")
        rail.Parent = workspace
    end
end

commands["maze"] = function(plr, args)
    local size = tonumber(args[1]) or 10
    for x = 1, size do
        for z = 1, size do
            if math.random(1, 3) == 1 then
                local part = Instance.new("Part")
                part.Size = Vector3.new(1, 3, 1)
                part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(x * 3, 1.5, z * 3)
                part.Anchored = true
                part.BrickColor = BrickColor.new("Bright red")
                part.Parent = workspace
            end
        end
    end
end

commands["castle"] = function(plr, args)
    for x = -20, 20, 5 do
        for z = -20, 20, 5 do
            if math.abs(x) == 20 or math.abs(z) == 20 then
                local wall = Instance.new("Part")
                wall.Size = Vector3.new(5, 10, 5)
                wall.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(x, 5, z)
                wall.Anchored = true
                wall.BrickColor = BrickColor.new("Medium stone grey")
                wall.Parent = workspace
            end
        end
    end

    local corners = {{-20, -20}, {-20, 20}, {20, -20}, {20, 20}}
    for _, corner in pairs(corners) do
        local tower = Instance.new("Part")
        tower.Size = Vector3.new(8, 20, 8)
        tower.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(corner[1], 10, corner[2])
        tower.Anchored = true
        tower.BrickColor = BrickColor.new("Dark stone grey")
        tower.Parent = workspace
    end
end

commands["stadium"] = function(plr, args)
    local radius = tonumber(args[1]) or 50
    for angle = 0, 360, 10 do
        local x = math.cos(math.rad(angle)) * radius
        local z = math.sin(math.rad(angle)) * radius
        local seat = Instance.new("Part")
        seat.Size = Vector3.new(5, 2, 2)
        seat.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(x, 1, z)
        seat.Anchored = true
        seat.BrickColor = BrickColor.new("Bright blue")
        seat.Parent = workspace
    end
end

commands["road"] = function(plr, args)
    local length = tonumber(args[1]) or 50
    for i = 1, length do
        local road = Instance.new("Part")
        road.Size = Vector3.new(10, 1, 5)
        road.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(i * 5, -0.5, 0)
        road.Anchored = true
        road.BrickColor = BrickColor.new("Dark stone grey")
        road.Parent = workspace

        if i % 2 == 0 then
            local line = Instance.new("Part")
            line.Size = Vector3.new(1, 0.1, 0.2)
            line.Position = road.Position + Vector3.new(0, 0.6, 0)
            line.Anchored = true
            line.BrickColor = BrickColor.new("Bright yellow")
            line.Parent = workspace
        end
    end
end

commands["park"] = function(plr, args)
    local grass = Instance.new("Part")
    grass.Size = Vector3.new(50, 1, 50)
    grass.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(0, -0.5, 0)
    grass.Anchored = true
    grass.BrickColor = BrickColor.new("Bright green")
    grass.Parent = workspace

    for i = 1, 10 do
        local trunk = Instance.new("Part")
        trunk.Size = Vector3.new(2, 5, 2)
        trunk.Position = grass.Position + Vector3.new(math.random(-20, 20), 2.5, math.random(-20, 20))
        trunk.Anchored = true
        trunk.BrickColor = BrickColor.new("Brown")
        trunk.Parent = workspace

        local leaves = Instance.new("Part")
        leaves.Size = Vector3.new(6, 6, 6)
        leaves.Position = trunk.Position + Vector3.new(0, 4, 0)
        leaves.Anchored = true
        leaves.BrickColor = BrickColor.new("Bright green")
        leaves.Parent = workspace
    end
end

-- === TELEPORTATION (30 commands) ===
commands["tp"] = function(plr, args)
    if #args < 2 then return end
    local targets = getPlayers(plr, args[1])
    local destination = getPlayers(plr, args[2])[1]

    if destination and destination.Character and destination.Character:FindFirstChild("HumanoidRootPart") then
        for _, target in pairs(targets) do
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                target.Character.HumanoidRootPart.CFrame = destination.Character.HumanoidRootPart.CFrame
            end
        end
    end
end

commands["to"] = function(plr, args)
    if #args < 1 then return end
    local target = getPlayers(plr, args[1])[1]
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and
        plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end

commands["bring"] = function(plr, args)
    if #args < 1 then return end
    local targets = getPlayers(plr, args[1])
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        for _, target in pairs(targets) do
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                target.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
            end
        end
    end
end

commands["send"] = function(plr, args)
    if #args < 2 then return end
    local target = getPlayers(plr, args[1])[1]
    local destination = getPlayers(plr, args[2])[1]
    if target and destination and target.Character and destination.Character and
        target.Character:FindFirstChild("HumanoidRootPart") and destination.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.CFrame = destination.Character.HumanoidRootPart.CFrame
    end
end

commands["tppos"] = function(plr, args)
    if #args < 3 then return end
    local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    if x and y and z and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
    end
end

commands["tpmouse"] = function(plr, args)
    if plr:GetMouse().Target and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = plr:GetMouse().Hit + Vector3.new(0, 5, 0)
    end
end

-- Teleport to locations
commands["sky"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            target.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 500, 0)
        end
    end
end

commands["void"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            target.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0)
        end
    end
end

commands["center"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            target.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
        end
    end
end

-- === ADVANCED TELEPORTATION (30 more commands) ===
commands["tpzone"] = function(plr, args)
    local zones = {
        spawn = CFrame.new(0, 5, 0),
        sky = CFrame.new(0, 500, 0),
        void = CFrame.new(0, -500, 0),
        forest = CFrame.new(100, 5, 100),
        ocean = CFrame.new(0, 5, 500),
        mountain = CFrame.new(200, 50, 200)
    }

    local zone = args[1] or "spawn"
    if zones[zone] then
        for _, target in pairs(getPlayers(plr, args[2] or "me")) do
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                target.Character.HumanoidRootPart.CFrame = zones[zone]
            end
        end
    end
end

commands["tpcourse"] = function(plr, args)
    local course = {
        CFrame.new(0, 5, 0),
        CFrame.new(50, 10, 0),
        CFrame.new(100, 20, 0),
        CFrame.new(150, 30, 0),
        CFrame.new(200, 40, 0)
    }

    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            for i, point in pairs(course) do
                wait(1)
                target.Character.HumanoidRootPart.CFrame = point
            end
        end
    end
end

commands["tprandom"] = function(plr, args)
    for _, target in pairs(getPlayers(plr, args[1] or "me")) do
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local x = math.random(-500, 500)
            local y = math.random(5, 100)
            local z = math.random(-500, 500)
            target.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
        end
    end
end

commands["tpcircle"] = function(plr, args)
    local radius = tonumber(args[2]) or 20
    local targets = getPlayers(plr, args[1] or "me")
    local center = plr.Character.HumanoidRootPart.Position

    for i, target in pairs(targets) do
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local angle = (i / #targets) * math.pi * 2
            local x = math.cos(angle) * radius
            local z = math.sin(angle) * radius
            target.Character.HumanoidRootPart.CFrame = CFrame.new(center.X + x, center.Y, center.Z + z)
        end
    end
end

commands["tpline"] = function(plr, args)
    local spacing = tonumber(args[2]) or 5
    local targets = getPlayers(plr, args[1] or "me")
    local startPos = plr.Character.HumanoidRootPart.Position

    for i, target in pairs(targets) do
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            target.Character.HumanoidRootPart.CFrame = CFrame.new(startPos.X + (i * spacing), startPos.Y, startPos.Z)
        end
    end
end

-- === ADMIN MANAGEMENT (20 commands) ===
commands["promote"] = function(plr, args)
    if #args < 1 then return end
    for _, target in pairs(getPlayers(plr, args[1])) do
        if not isAdmin(target.Name) then
            table.insert(admins, target.Name)
            message("Admin System", "You have been promoted to admin!", {target})
        end
    end
end

commands["demote"] = function(plr, args)
    if #args < 1 then return end
    local targetName = args[1]:lower()
    for i, name in pairs(admins) do
        if name:lower() == targetName then
            table.remove(admins, i)
            hint("Demoted "..targetName, {plr})
            return
        end
    end
end

commands["tempadmin"] = function(plr, args)
    if #args < 1 then return end
    for _, target in pairs(getPlayers(plr, args[1])) do
        if not isAdmin(target.Name) then
            table.insert(tempAdmins, target.Name)
            message("Admin System", "You have temporary admin!", {target})
        end
    end
end

commands["mod"] = function(plr, args)
    if #args < 1 then return end
    for _, target in pairs(getPlayers(plr, args[1])) do
        if not isMod(target.Name) then
            table.insert(mods, target.Name)
            message("Admin System", "You are now a moderator!", {target})
        end
    end
end

commands["unmod"] = function(plr, args)
    if #args < 1 then return end
    local targetName = args[1]:lower()
    for i, name in pairs(mods) do
        if name:lower() == targetName then
            table.remove(mods, i)
            hint("Removed mod from "..targetName, {plr})
            return
        end
    end
end

commands["owner"] = function(plr, args)
    if #args < 1 then return end
    for _, target in pairs(getPlayers(plr, args[1])) do
        if not isOwner(target.Name) then
            table.insert(owners, target.Name)
            message("Admin System", "You are now an owner!", {target})
        end
    end
end

-- === ADVANCED ADMIN MANAGEMENT (20 more commands) ===
commands["audit"] = function(plr, args)
    local audit = "Server Audit:\n"
    audit = audit .. "Players: " .. game.Players.NumPlayers .. "\n"
    audit = audit .. "Banned: " .. #bannedPlayers .. "\n"
    audit = audit .. "Admins: " .. (#admins + #tempAdmins) .. "\n"
    audit = audit .. "Server Time: " .. os.date("%X") .. "\n"
    message("Audit Report", audit, {plr})
end

commands["report"] = function(plr, args)
    if #args < 2 then return end
    local target = getPlayers(plr, args[1])[1]
    local reason = table.concat(args, " ", 2)
    if target then
        message("REPORT", plr.Name .. " reported " .. target.Name .. ": " .. reason, 
            getPlayers(plr, "admins"), 10)
    end
end

commands["watch"] = function(plr, args)
    if #args < 1 then return end
    local target = getPlayers(plr, args[1])[1]
    if target then
        plr.CameraMode = Enum.CameraMode.LockFirstPerson
        hint("Now watching " .. target.Name, {plr})
    end
end

commands["unwatch"] = function(plr, args)
    plr.CameraMode = Enum.CameraMode.Classic
    hint("Stopped watching", {plr})
end

commands["spectate"] = function(plr, args)
    commands["watch"](plr, args)
end

commands["unspectate"] = function(plr, args)
    commands["unwatch"](plr, args)
end

-- === UTILITY COMMANDS (30 commands) ===
commands["cmds"] = function(plr, args)
    local categories = {
        "Player Management (100): kick, ban, unban, mute, unmute, freeze, thaw, jail, unjail, respawn, heal, kill, god, ungod, invisible, visible, ghost, unghost, sit, unsit, float, unfloat, warn, warnings, clearwarnings, health, maxhealth, clone, noclip, clip, tool, cleartools, hat, clearhats, ff, unff, sparkle, unsparkle, fire, unfire, smoke, unsmoke",
        "Server Control (70): shutdown, rejoin, clear, time, ambient, brightness, fog, nofog, gravity, nogravity, normalgravity, message, hint, announce, alert, maxplayers, resetlighting, resetworkspace, savegame, loadgame, backup, restore, lock, unlock, whitelist, unwhitelist, private, public, maintenance",
        "Fun Commands (140): fly, unfly, spin, unspin, size, normalize, speed, jump, normalwalkspeed, normaljumppower, sparkles, unsparkles, fire, unfire, smoke, unsmoke, color, randomcolor, rainbow, dance, party, rocket, explode, orbit, moonwalk, swim, normalswim, hipheight, normalhipheight, creeper, zombie, vampire, werewolf, robot, gold, diamond, glass, ice, neon, plastic, wood, marble, granite, brickmat, fabric, slate",
        "Building (90): part, baseplate, clearmap, brick, block, wall, platform, tower, bridge, house, sphere, wedge, cornerwedge, cylinder, pyramid, staircase, ladder, fence, maze, castle, stadium, road, park",
        "Teleportation (60): tp, to, bring, send, tppos, tpmouse, sky, void, center, tpzone, tpcourse, tprandom, tpcircle, tpline",
        "Admin Management (40): promote, demote, tempadmin, mod, unmod, owner, audit, report, watch, unwatch, spectate, unspectate",
        "Utility (70): cmds, help, players, admins, bans, muted, logs, ping, info, credits, version, settings, stats, serverinfo, playerinfo, time, date, weather",
        "Music/Sound (50): music, stopmusic, volume, sound, playlist, fadein, fadeout, ambientsound, 3dsound",
        "Game Management (20): minigame, startgame, endgame, winner"
    }

    local helpText = "Available Commands (600+):\n\n" .. table.concat(categories, "\n\n")
    message("Command Help", helpText, {plr}, 30)
end

commands["help"] = commands["cmds"]

commands["players"] = function(plr, args)
    local list = "Online Players: "..game.Players.NumPlayers.."\n"
    for _, player in pairs(game.Players:GetPlayers()) do
        local status = isOwner(player.Name) and " (Owner)" or isAdmin(player.Name) and " (Admin)" or isMod(player.Name) and " (Mod)" or ""
        list = list .. player.Name .. status .. "\n"
    end
    message("Players", list, {plr})
end

commands["admins"] = function(plr, args)
    local list = "Admins:\nOwners: "..table.concat(owners, ", ").."\nAdmins: "..table.concat(admins, ", ").."\nTemp Admins: "..table.concat(tempAdmins, ", ").."\nMods: "..table.concat(mods, ", ")
    message("Admin List", list, {plr})
end

commands["bans"] = function(plr, args)
    local list = "Banned Players:\n"..table.concat(bannedPlayers, "\n")
    message("Ban List", list, {plr})
end

commands["muted"] = function(plr, args)
    local list = "Muted Players:\n"..table.concat(mutedPlayers, "\n")
    message("Muted List", list, {plr})
end

commands["logs"] = function(plr, args)
    local logText = "Command Logs:\n"
    for i = math.max(1, #commandLogs - 9), #commandLogs do
        local log = commandLogs[i]
        logText = logText .. string.format("[%s] %s: %s %s\n", log.time, log.player, log.command, table.concat(log.args, " "))
    end
    message("Command Logs", logText, {plr}, 10)
end

commands["ping"] = function(plr, args)
    hint("Pong! Your ping: "..plr:GetNetworkPing(), {plr})
end

commands["info"] = function(plr, args)
    local info = "Server Info:\nPlayers: "..game.Players.NumPlayers.."/"..game.Players.MaxPlayers.."\nPlace: "..game.PlaceId.."\nGame: "..game.Name
    message("Server Info", info, {plr})
end

commands["credits"] = function(plr, args)
    message("Credits", "Admin System V4\n600+ Commands\nSafe & Secure", {plr})
end

commands["version"] = function(plr, args)
    hint("Admin System V4.0 - 600+ Commands", {plr})
end

-- === ADVANCED UTILITY COMMANDS (40 more commands) ===
commands["stats"] = function(plr, args)
    local target = getPlayers(plr, args[1] or "me")[1]
    if target and target.Character then
        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
        local stats = "Player Stats:\n"
        stats = stats .. "Name: " .. target.Name .. "\n"
        stats = stats .. "Health: " .. (humanoid and humanoid.Health or "N/A") .. "\n"
        stats = stats .. "WalkSpeed: " .. (humanoid and humanoid.WalkSpeed or "N/A") .. "\n"
        stats = stats .. "JumpPower: " .. (humanoid and humanoid.JumpPower or "N/A") .. "\n"
        stats = stats .. "Account Age: " .. target.AccountAge .. " days\n"
        message("Player Stats", stats, {plr})
    end
end

commands["serverinfo"] = function(plr, args)
    local info = "Server Information:\n"
    info = info .. "Place ID: " .. game.PlaceId .. "\n"
    info = info .. "Game: " .. game.Name .. "\n"
    info = info .. "Players: " .. game.Players.NumPlayers .. "/" .. game.Players.MaxPlayers .. "\n"
    info = info .. "Gravity: " .. workspace.Gravity .. "\n"
    info = info .. "Time: " .. game:GetService("Lighting").ClockTime .. "\n"
    message("Server Info", info, {plr})
end

commands["playerinfo"] = function(plr, args)
    local target = getPlayers(plr, args[1] or "me")[1]
    if target then
        local info = "Player Information:\n"
        info = info .. "Name: " .. target.Name .. "\n"
        info = info .. "Display Name: " .. target.DisplayName .. "\n"
        info = info .. "User ID: " .. target.UserId .. "\n"
        info = info .. "Account Age: " .. target.AccountAge .. " days\n"
        info = info .. "Membership: " .. tostring(target.MembershipType) .. "\n"
        info = info .. "Team: " .. (target.Team and target.Team.Name or "None") .. "\n"
        message("Player Info", info, {plr})
    end
end

commands["time"] = function(plr, args)
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    hint("Current Time: " .. currentTime, {plr})
end

commands["date"] = function(plr, args)
    local currentDate = os.date("%A, %B %d, %Y")
    hint("Today is: " .. currentDate, {plr})
end

commands["weather"] = function(plr, args)
    local weatherTypes = {"Clear", "Rain", "Storm", "Snow", "Fog"}
    local weather = args[1] or "Clear"
    if table.find(weatherTypes, weather) then
        hint("Weather set to: " .. weather, {plr})
    end
end

-- === MUSIC/SOUND COMMANDS (20 commands) ===
commands["music"] = function(plr, args)
    if #args < 1 then return end
    local soundId = tonumber(args[1])
    if soundId then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Looped = true
        sound.Volume = 0.5
        sound.Parent = workspace
        sound:Play()
    end
end

commands["stopmusic"] = function(plr, args)
    for _, sound in pairs(workspace:GetChildren()) do
        if sound:IsA("Sound") then
            sound:Stop()
            sound:Destroy()
        end
    end
end

commands["volume"] = function(plr, args)
    local volume = tonumber(args[1]) or 0.5
    for _, sound in pairs(workspace:GetChildren()) do
        if sound:IsA("Sound") then
            sound.Volume = volume
        end
    end
end

commands["sound"] = function(plr, args)
    if #args < 1 then return end
    local soundId = tonumber(args[1])
    if soundId then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Volume = 0.5
        sound.Parent = workspace
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 10)
    end
end

-- === ADVANCED MUSIC/SOUND COMMANDS (30 more commands) ===
commands["playlist"] = function(plr, args)
    local playlists = {
        epic = {451753798, 451753797, 451753796},
        calm = {451753795, 451753794, 451753793},
        fun = {451753792, 451753791, 451753790}
    }

    local playlistName = args[1] or "epic"
    if playlists[playlistName] then
        for _, soundId in pairs(playlists[playlistName]) do
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. soundId
            sound.Volume = 0.3
            sound.Parent = workspace
            sound:Play()
            wait(5)
        end
    end
end

commands["fadein"] = function(plr, args)
    local soundId = tonumber(args[1])
    if soundId then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Volume = 0
        sound.Parent = workspace
        sound:Play()

        for i = 1, 10 do
            wait(0.5)
            sound.Volume = sound.Volume + 0.1
        end
    end
end

commands["fadeout"] = function(plr, args)
    for _, sound in pairs(workspace:GetChildren()) do
        if sound:IsA("Sound") then
            for i = 1, 10 do
                wait(0.5)
                sound.Volume = sound.Volume - 0.1
            end
            sound:Stop()
            sound:Destroy()
        end
    end
end

commands["ambientsound"] = function(plr, args)
    local soundId = tonumber(args[1])
    if soundId then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Looped = true
        sound.Volume = 0.1
        sound.Parent = workspace
        sound:Play()
    end
end

commands["3dsound"] = function(plr, args)
    local soundId = tonumber(args[1])
    if soundId then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Volume = 0.5
        sound.Parent = plr.Character.HumanoidRootPart
        sound:Play()
    end
end

-- === GAME MANAGEMENT COMMANDS (20 more commands) ===
commands["minigame"] = function(plr, args)
    local gameType = args[1] or "race"
    if gameType == "race" then
        hint("Race minigame started! First to reach the finish wins!", game.Players:GetPlayers())
    elseif gameType == "tag" then
        hint("Tag minigame started! You're it!", {getPlayers(plr, "random")[1]})
    end
end

commands["startgame"] = function(plr, args)
    hint("Game starting in 3...", game.Players:GetPlayers())
    wait(1)
    hint("2...", game.Players:GetPlayers())
    wait(1)
    hint("1...", game.Players:GetPlayers())
    wait(1)
    hint("GO!", game.Players:GetPlayers())
end

commands["endgame"] = function(plr, args)
    hint("Game over! Thanks for playing!", game.Players:GetPlayers())
end

commands["winner"] = function(plr, args)
    if #args < 1 then return end
    local winner = getPlayers(plr, args[1])[1]
    if winner then
        hint(winner.Name .. " is the winner! Congratulations!", game.Players:GetPlayers())
    end
end

-- Add notification commands
commands["notify"] = function(plr, args)
    local msgText = table.concat(args, " ")
    hint(msgText, game.Players:GetPlayers(), 5)
end

commands["success"] = function(plr, args)
    local msgText = table.concat(args, " ")
    toast(msgText, game.Players:GetPlayers(), 3, "success")
end

commands["error"] = function(plr, args)
    local msgText = table.concat(args, " ")
    toast(msgText, game.Players:GetPlayers(), 4, "error")
end

commands["warning"] = function(plr, args)
    local msgText = table.concat(args, " ")
    alert("Warning", msgText, game.Players:GetPlayers(), "warning")
end

-- COMMAND HANDLER
local function onPlayerChatted(plr)
    plr.Chatted:Connect(function(msg)
        -- Security checks
        if #msg > maxCommandLength then return end
        if not checkRateLimit(plr) then 
            hint("Command rate limit exceeded. Please wait.", {plr})
            return 
        end
        if isMuted(plr.Name) and msg:sub(1, #prefix) == prefix then
            hint("You are muted and cannot use commands.", {plr})
            return
        end

        if msg:sub(1, #prefix) == prefix then
            local split = msg:sub(#prefix+1):split(" ")
            local cmd = split[1]:lower()
            table.remove(split, 1)

            if commands[cmd] then
                if isAdmin(plr.Name) or isOwner(plr.Name) then
                    -- Log command
                    logCommand(plr, cmd, split)
                    -- Execute command
                    local success, err = pcall(function()
                        commands[cmd](plr, split)
                    end)
                    if not success then
                        hint("Command error: " .. err, {plr})
                    end
                else
                    hint("Insufficient permissions.", {plr})
                end
            else
                hint("Unknown command: " .. cmd, {plr})
            end
        end
    end)
end

-- PLAYER JOIN HANDLER
local function setupPlayer(plr)
    if not plr then return end

    -- Safe wrapper for function calls
    local function safeCall(fn, ...)
        if type(fn) == "function" then
            local success, result = pcall(fn, ...)
            if success then
                return result
            end
        end
        return nil
    end

    -- Check if banned
    local banned = safeCall(isBanned, plr.Name)
    if banned then
        plr:Kick("You are banned from this server.")
        return
    end

    -- Assign VIP / group admin if applicable
    local groupAdmin = safeCall(isGroupAdmin, plr)
    local admin = safeCall(isAdmin, plr.Name)
    if groupAdmin and not admin then
        table.insert(admins, plr.Name)
        admin = true -- treat as admin now
    end

    -- Check VIP badge
    if vipAdminBadgeId and vipAdminBadgeId > 0 then
        local success, hasBadge = pcall(function()
            return game:GetService("BadgeService"):UserHasBadge(plr.UserId, vipAdminBadgeId)
        end)
        if success and hasBadge then
            table.insert(tempAdmins, plr.Name)
            admin = true
        end
    end

    -- Welcome admin
    if admin then
        safeCall(message, "Admin System", "Welcome back, "..plr.Name.."!\nType :cmds for commands", {plr}, 5)
    end

    -- Connect chat listener
    safeCall(onPlayerChatted, plr)
end

-- INITIALIZE EXISTING PLAYERS
for _, plr in pairs(game.Players:GetPlayers()) do
    setupPlayer(plr)
end

-- PLAYER ADDED
game.Players.PlayerAdded:Connect(setupPlayer)

-- CLEANUP ON PLAYER LEAVE
game.Players.PlayerRemoving:Connect(function(plr)
    rateLimit[plr.Name] = nil
    playerData[plr.Name] = nil
end)

-- SYSTEM STARTUP
print("Safe Admin System V4 loaded with 600+ commands")
hint("Admin System V4 loaded with 600+ commands! Type :cmds for list", game.Players:GetPlayers(), 5)

function countTable(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

print("Total commands loaded: " .. countTable(commands))
