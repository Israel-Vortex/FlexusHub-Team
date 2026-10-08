--[[
  FlexusHub · Universal Hub (WindUI)
  Se carga cuando el PlaceId / GameId no está en la lista del loader.
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- Re-execution guard
pcall(function()
        if _G.FlexusUniversalUnload then _G.FlexusUniversalUnload() end
end)

local HUB = { conns = {}, drawings = {}, highlights = {}, dead = false }
_G.FlexusUniversal = HUB
_G.FlexusUniversalUnload = function()
        if HUB.Unload then HUB.Unload() end
end

local function track(conn)
        if conn then table.insert(HUB.conns, conn) end
        return conn
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local player = LocalPlayer

-- ========== Notify (WindUI) ==========
local function Notify(title, content, duration)
        pcall(function()
                if WindUI and type(WindUI.Notify) == "function" then
                        WindUI:Notify({
                                Title = tostring(title or "FlexusHub"),
                                Content = tostring(content or ""),
                                Duration = tonumber(duration) or 2.5,
                        })
                end
        end)
end

-- ========== WindUI ==========
local WindUI
for _, url in ipairs({
        "https://raw.githubusercontent.com/Israel-Vortex/FlexusHub-Team/refs/heads/main/FlexusHub/Flexus-Lib/Flexus-Team/WindUi-FlexusHub.lua",
        "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua",
        "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua",
}) do
        local ok, res = pcall(function()
                return loadstring(game:HttpGet(url))()
        end)
        if ok and res then
                WindUI = res
                break
        end
end
if not WindUI then
        warn("[FlexusHub Universal] WindUI no cargo")
        return
end

local function createTheme(name, colors)
        local theme = { Name = name }
        pcall(function()
                for key, value in pairs(WindUI:GetThemes().Dark) do
                        theme[key] = value
                end
        end)
        for key, value in pairs(colors) do
                theme[key] = value
        end
        WindUI:AddTheme(theme)
end

createTheme("Graphite", {
        Accent = Color3.fromRGB(200, 200, 210),
        Outline = Color3.fromRGB(90, 90, 98),
        Text = Color3.fromRGB(245, 245, 250),
        Placeholder = Color3.fromRGB(150, 150, 160),
        Button = Color3.fromRGB(70, 70, 78),
        Background = Color3.fromRGB(8, 8, 10),
        Icon = Color3.fromRGB(220, 220, 225),
        Hover = Color3.fromRGB(255, 255, 255),
        WindowBackground = Color3.fromRGB(10, 10, 12),
        WindowShadow = Color3.fromRGB(0, 0, 0),
        PanelBackground = Color3.fromRGB(16, 16, 18),
        PanelBackgroundTransparency = 0.58,
        TabBackground = Color3.fromRGB(28, 28, 32),
        TabBackgroundHover = Color3.fromRGB(55, 55, 60),
        TabBackgroundHoverTransparency = 0.7,
        TabBackgroundActive = Color3.fromRGB(75, 75, 82),
        TabBackgroundActiveTransparency = 0.48,
        TabTitle = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(22, 22, 26),
        ElementTitle = Color3.fromRGB(245, 245, 250),
        ElementDesc = Color3.fromRGB(170, 170, 180),
        Toggle = Color3.fromRGB(200, 200, 210),
        ToggleBar = Color3.fromRGB(40, 40, 48),
        Slider = Color3.fromRGB(200, 200, 210),
        SliderThumb = Color3.fromRGB(255, 255, 255),
})

createTheme("Neon Blue", {
        Accent = Color3.fromRGB(60, 160, 255),
        Outline = Color3.fromRGB(40, 100, 180),
        Text = Color3.fromRGB(230, 240, 255),
        Background = Color3.fromRGB(4, 10, 22),
        Icon = Color3.fromRGB(120, 190, 255),
        WindowBackground = Color3.fromRGB(6, 14, 28),
        PanelBackground = Color3.fromRGB(8, 18, 36),
        TabBackground = Color3.fromRGB(12, 30, 55),
        ElementBackground = Color3.fromRGB(10, 24, 48),
        Toggle = Color3.fromRGB(60, 160, 255),
        Slider = Color3.fromRGB(60, 160, 255),
})

createTheme("Golden", {
        Accent = Color3.fromRGB(255, 195, 55),
        Outline = Color3.fromRGB(180, 130, 30),
        Text = Color3.fromRGB(255, 245, 220),
        Background = Color3.fromRGB(14, 10, 4),
        Icon = Color3.fromRGB(255, 210, 100),
        WindowBackground = Color3.fromRGB(18, 12, 6),
        PanelBackground = Color3.fromRGB(28, 18, 8),
        TabBackground = Color3.fromRGB(45, 30, 12),
        ElementBackground = Color3.fromRGB(32, 22, 10),
        Toggle = Color3.fromRGB(255, 195, 55),
        Slider = Color3.fromRGB(255, 195, 55),
})

WindUI:SetTheme("Graphite")

local themeBackgrounds = {
        Graphite = "rbxassetid://83511264088514",
        ["Neon Blue"] = "rbxassetid://91622993482762",
        Golden = "rbxassetid://73167161449222",
}

local Window = WindUI:CreateWindow({
        Title = "FlexusHub [Universal]",
        Author = "Flexus-Team",
        Folder = "FlexusHub_Universal",
        ConfigName = "FlexusHub_Universal",
        Theme = "Graphite",
        Size = UDim2.fromOffset(520, 405),
        MinSize = Vector2.new(440, 335),
        MaxSize = Vector2.new(650, 500),
        Icon = "rbxassetid://78482030075403",
        IconThemed = true,
        Background = "rbxassetid://83511264088514",
        BackgroundImageTransparency = 0.22,
        Transparent = false,
        Acrylic = false,
        SideBarWidth = 145,
        ElementsRadius = 12,
        ScrollBarEnabled = true,
        HideSearchBar = true,
        Resizable = true,
        ModernLayout = true,
        ModernLayoutMergeElements = false,
        HidePanelBackground = false,
        BottomDragBarEnabled = true,
        OpenButton = {
                Enabled = true,
                Title = "FlexusHub [Universal]",
                Icon = "rbxassetid://78482030075403",
                OnlyMobile = false,
                Draggable = true,
                Scale = 0.82,
                StrokeThickness = 1,
                Color = ColorSequence.new(Color3.fromRGB(118, 118, 124), Color3.fromRGB(164, 164, 170)),
        },
})
pcall(function() Window:SetIconSize(30) end)

pcall(function()
        Window:EditOpenButton({
                Title = "FlexusHub",
                Icon = "rbxassetid://78482030075403",
                CornerRadius = UDim.new(0, 10),
                StrokeThickness = 1,
                Color = ColorSequence.new(Color3.fromRGB(118, 118, 124), Color3.fromRGB(164, 164, 170)),
                OnlyMobile = false,
                Enabled = true,
                Draggable = true,
        })
end)

pcall(function()
        Window:Tag({ Title = "Universal", Icon = "globe", Color = Color3.fromRGB(180, 180, 190) })
end)
Window:SetToggleKey(Enum.KeyCode.K)


local mainSec = Window:Section({ Title = "Popular", Opened = true })
local extraSec = Window:Section({ Title = "Extra", Opened = true })

-- Helpers
local function GetCharacter() return LocalPlayer.Character end
local function GetHumanoid()
        local c = GetCharacter()
        return c and c:FindFirstChildOfClass("Humanoid")
end
local function GetHRP()
        local c = GetCharacter()
        return c and c:FindFirstChild("HumanoidRootPart")
end

-- ========== INFORMATION ==========
local InfoTab = mainSec:Tab({ Title = "Information", Icon = "badge-info", ShowTabTitle = true, Border = true })
InfoTab:Select()

InfoTab:Divider({ Title = "Acerca de" })
InfoTab:Paragraph({
        Title = "FlexusHub [Universal]",
        Desc = "Hub universal para juegos que aun no tienen script dedicado.\nIncluye movimiento, fly, teleport, ESP, aimbot y server tools.\n\nDesarrollador: Flexus-Team\nUI: WindUI\nModo: Universal (fallback del loader)",
        Image = "rbxassetid://78482030075403",
        ImageSize = 72,
})
InfoTab:Paragraph({
        Title = "Developer",
        Desc = "FlexusHub\nDesarrollo, mantenimiento y actualizaciones del script.",
})
InfoTab:Paragraph({
        Title = "Juego actual",
        Desc = ("Name: %s\nPlaceId: %s\nGameId: %s"):format(
                tostring(game.Name),
                tostring(game.PlaceId),
                tostring(game.GameId)
        ),
})

InfoTab:Divider({ Title = "Comunidad" })
local currentThemeName = "Graphite"
local function getThemeBannerImage(themeName)
        return themeBackgrounds[themeName] or themeBackgrounds.Graphite or "rbxassetid://83511264088514"
end
local discordBanner = InfoTab:Paragraph({
        Title = "Discord FlexusHub",
        Desc = "Unete a la comunidad oficial para soporte, updates y chat.\nhttps://discord.gg/Fn74MpzFUn",
        Image = getThemeBannerImage(currentThemeName),
        ImageSize = 140,
})
local function updateDiscordBannerImage(themeName)
        currentThemeName = themeName or currentThemeName
        local img = getThemeBannerImage(currentThemeName)
        if not discordBanner then return end
        pcall(function()
                if type(discordBanner.SetImage) == "function" then
                        discordBanner:SetImage(img)
                elseif type(discordBanner.Set) == "function" then
                        discordBanner:Set({ Image = img })
                elseif discordBanner.Image ~= nil then
                        discordBanner.Image = img
                end
        end)
end
InfoTab:Button({
        Title = "Copiar Discord",
        Icon = "message-circle",
        Callback = function()
                pcall(function()
                        if setclipboard then setclipboard("https://discord.gg/Fn74MpzFUn")
                        elseif toclipboard then toclipboard("https://discord.gg/Fn74MpzFUn") end
                end)
                Notify("Discord", "Invite copiado", 2)
        end,
})
InfoTab:Button({
        Title = "Copiar Website",
        Icon = "globe",
        Callback = function()
                pcall(function()
                        if setclipboard then setclipboard("https://flexushub-scripts.netlify.app/")
                        elseif toclipboard then toclipboard("https://flexushub-scripts.netlify.app/") end
                end)
                Notify("Website", "Link copiado", 2)
        end,
})

InfoTab:Divider({ Title = "Apariencia" })
InfoTab:Dropdown({
        Title = "Theme",
        Values = { "Graphite", "Neon Blue", "Golden" },
        Value = "Graphite",
        Callback = function(themeName)
                themeName = tostring(themeName or "Graphite")
                local background = themeBackgrounds[themeName]
                if not background then return end
                pcall(function() WindUI:SetTheme(themeName) end)
                pcall(function()
                        if Window.SetBackgroundImage then
                                Window:SetBackgroundImage(background)
                        elseif Window.SetBackground then
                                Window:SetBackground(background)
                        end
                end)
                pcall(function()
                        if Window.SetBackgroundImageTransparency then
                                Window:SetBackgroundImageTransparency(0.22)
                        end
                end)
                pcall(function() updateDiscordBannerImage(themeName) end)
                pcall(function()
                        local seq
                        if themeName == "Golden" then
                                seq = ColorSequence.new(Color3.fromRGB(180, 130, 30), Color3.fromRGB(255, 210, 90))
                        elseif themeName == "Neon Blue" then
                                seq = ColorSequence.new(Color3.fromRGB(30, 90, 170), Color3.fromRGB(120, 190, 255))
                        else
                                seq = ColorSequence.new(Color3.fromRGB(118, 118, 124), Color3.fromRGB(164, 164, 170))
                        end
                        Window:EditOpenButton({
                                Title = "FlexusHub",
                                Icon = "rbxassetid://78482030075403",
                                Color = seq,
                                StrokeThickness = 1,
                        })
                end)
                Notify("Theme", themeName, 2)
        end,
})

InfoTab:Divider({ Title = "Report Bug / Suggestion" })
local reportText = ""
local lastReportTime = 0
InfoTab:Input({
        Title = "Mensaje",
        Value = "",
        Placeholder = "Describe el bug o sugerencia...",
        Callback = function(t) reportText = t end,
})
InfoTab:Button({
        Title = "Enviar reporte",
        Callback = function()
                local now = os.time()
                if now - lastReportTime < 60 then
                        Notify("Report", "Espera " .. tostring(60 - (now - lastReportTime)) .. "s", 2)
                        return
                end
                if reportText == "" or tostring(reportText):match("^%s*$") then
                        Notify("Report", "Escribe un mensaje primero", 2)
                        return
                end
                lastReportTime = now
                local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1555645993247051906/5spy-DPMDAL5qhbS2mk5S-wesGubALPm5JhtiNO9CR34A70x2VKTk2Du2jmTPx37cGi1"
                local payload = HttpService:JSONEncode({
                        username = "FlexusHub Reports",
                        embeds = {{
                                title = "Report · Universal",
                                description = tostring(reportText),
                                color = 0xC8C8D0,
                                fields = {
                                        { name = "User", value = tostring(LocalPlayer.Name) .. " (" .. tostring(LocalPlayer.UserId) .. ")", inline = true },
                                        { name = "Game", value = tostring(game.Name), inline = true },
                                        { name = "PlaceId", value = tostring(game.PlaceId), inline = true },
                                },
                        }},
                })
                local ok = false
                pcall(function()
                        local req = request or http_request or (syn and syn.request)
                        if req then
                                req({ Url = DISCORD_WEBHOOK, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = payload })
                                ok = true
                        end
                end)
                Notify("Report", ok and "Reporte enviado" or "No se pudo enviar", 2)
                if ok then reportText = "" end
        end,
})


-- ========== PLAYER / MOVEMENT ==========
local MoveTab = mainSec:Tab({ Title = "Movement", Icon = "zap", ShowTabTitle = true, Border = true })

local wsEnabled, wsValue = false, 16
local jpEnabled, jpValue = false, 50
local infJump = false
local gravityEnabled, gravityValue = false, 196.2
local defaultGravity = Workspace.Gravity

MoveTab:Section({ Title = "Speed & Jump" })
MoveTab:Toggle({
        Title = "WalkSpeed",
        Desc = "Activa velocidad personalizada.",
        Default = false,
        Callback = function(v)
                wsEnabled = v
                local hum = GetHumanoid()
                if hum then hum.WalkSpeed = v and wsValue or 16 end
        end,
})
MoveTab:Slider({
        Title = "WalkSpeed Value",
        Value = { Min = 16, Max = 200, Default = 28 },
        Callback = function(v)
                wsValue = v
                if wsEnabled then
                        local hum = GetHumanoid()
                        if hum then hum.WalkSpeed = v end
                end
        end,
})
MoveTab:Toggle({
        Title = "JumpPower",
        Default = false,
        Callback = function(v)
                jpEnabled = v
                local hum = GetHumanoid()
                if hum then
                        hum.UseJumpPower = true
                        hum.JumpPower = v and jpValue or 50
                end
        end,
})
MoveTab:Slider({
        Title = "JumpPower Value",
        Value = { Min = 50, Max = 300, Default = 50 },
        Callback = function(v)
                jpValue = v
                if jpEnabled then
                        local hum = GetHumanoid()
                        if hum then hum.UseJumpPower = true; hum.JumpPower = v end
                end
        end,
})
MoveTab:Toggle({
        Title = "Infinite Jump",
        Default = false,
        Callback = function(v) infJump = v end,
})

MoveTab:Section({ Title = "Gravity" })
MoveTab:Toggle({
        Title = "Custom Gravity",
        Default = false,
        Callback = function(v)
                gravityEnabled = v
                Workspace.Gravity = v and gravityValue or defaultGravity
        end,
})
MoveTab:Slider({
        Title = "Gravity",
        Value = { Min = 0, Max = 400, Default = 196 },
        Callback = function(v)
                gravityValue = v
                if gravityEnabled then Workspace.Gravity = v end
        end,
})

track(LocalPlayer.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 10)
        if not hum or HUB.dead then return end
        task.wait(0.2)
        if wsEnabled then hum.WalkSpeed = wsValue end
        if jpEnabled then hum.UseJumpPower = true; hum.JumpPower = jpValue end
end))

track(UserInputService.JumpRequest:Connect(function()
        if HUB.dead or not infJump then return end
        local hum = GetHumanoid()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end))

-- Fly / Noclip
MoveTab:Section({ Title = "Fly & Noclip" })
local flying, flySpeed = false, 50
local noclip = false
local flyConn, noclipConn
local noclipParts = {}

local function getFlyDir()
        local dir = Vector3.zero
        local cf = Camera.CFrame
        -- PC
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                dir = dir - Vector3.yAxis
        end
        -- Mobile MoveDirection
        local hum = GetHumanoid()
        if hum and hum.MoveDirection.Magnitude > 0.05 then
                local md = hum.MoveDirection
                dir = dir + Vector3.new(md.X, cf.LookVector.Y * md.Magnitude * 0.9, md.Z)
        end
        if dir.Magnitude > 0.05 then return dir.Unit end
        return Vector3.zero
end

local function startFly()
        if flyConn then flyConn:Disconnect() end
        flyConn = RunService.RenderStepped:Connect(function()
                if HUB.dead or not flying then return end
                local h = GetHumanoid()
                local root = GetHRP()
                if not h or not root then return end
                h.PlatformStand = true
                local dir = getFlyDir()
                root.AssemblyLinearVelocity = dir.Magnitude > 0 and dir * flySpeed or Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
        end)
end

local function stopFly()
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        local hum = GetHumanoid()
        if hum then hum.PlatformStand = false end
        local root = GetHRP()
        if root then root.AssemblyLinearVelocity = Vector3.zero end
end

MoveTab:Toggle({
        Title = "Fly",
        Desc = "PC: WASD + Space/Shift · Móvil: joystick + mira",
        Default = false,
        Callback = function(v)
                flying = v
                if v then startFly() else stopFly() end
                Notify("Fly", v and "ON" or "OFF", 2)
        end,
})
MoveTab:Slider({
        Title = "Fly Speed",
        Value = { Min = 10, Max = 250, Default = 50 },
        Callback = function(v) flySpeed = v end,
})

local function startNoclip()
        if noclipConn then noclipConn:Disconnect() end
        noclipConn = RunService.Stepped:Connect(function()
                if HUB.dead or not noclip then return end
                local char = GetCharacter()
                if not char then return end
                for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                                noclipParts[part] = true
                                part.CanCollide = false
                        end
                end
        end)
end

local function stopNoclip()
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        for part in pairs(noclipParts) do
                if part and part.Parent then pcall(function() part.CanCollide = true end) end
        end
        table.clear(noclipParts)
end

MoveTab:Toggle({
        Title = "Noclip",
        Default = false,
        Callback = function(v)
                noclip = v
                if v then startNoclip() else stopNoclip() end
                Notify("Noclip", v and "ON" or "OFF", 2)
        end,
})

MoveTab:Section({ Title = "Character" })
local antiAFK = true
MoveTab:Toggle({
        Title = "Anti-AFK",
        Default = true,
        Callback = function(v) antiAFK = v end,
})
if not _G.FlexusUniversalAntiAFK then
        _G.FlexusUniversalAntiAFK = true
        LocalPlayer.Idled:Connect(function()
                if antiAFK then
                        pcall(function()
                                VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
                                task.wait(1)
                                VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
                        end)
                end
        end)
end
MoveTab:Button({
        Title = "Respawn",
        Callback = function()
                local hum = GetHumanoid()
                if hum then hum.Health = 0 end
        end,
})
MoveTab:Button({
        Title = "Reset Stats",
        Callback = function()
                local hum = GetHumanoid()
                if hum then hum.WalkSpeed = 16; hum.JumpPower = 50; hum.UseJumpPower = true end
                Workspace.Gravity = defaultGravity
                Notify("Character", "Stats default", 2)
        end,
})

-- ========== TELEPORT ==========
local TpTab = mainSec:Tab({ Title = "Teleport", Icon = "map-pin", ShowTabTitle = true, Border = true })
local selectedPlayer = nil
local function GetPlayerNames()
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then table.insert(names, p.Name) end
        end
        table.sort(names)
        if #names == 0 then names = { "(no players)" } end
        return names
end
local function ResolvePlayer(name)
        for _, p in ipairs(Players:GetPlayers()) do
                if p.Name == name then return p end
        end
end

TpTab:Section({ Title = "Players" })
local playerDrop
playerDrop = TpTab:Dropdown({
        Title = "Player",
        Values = GetPlayerNames(),
        Callback = function(v) selectedPlayer = v end,
})
TpTab:Button({
        Title = "Refresh Players",
        Callback = function()
                pcall(function() playerDrop:Refresh(GetPlayerNames()) end)
                Notify("Teleport", "Lista actualizada", 2)
        end,
})
TpTab:Button({
        Title = "Teleport To Player",
        Callback = function()
                local target = ResolvePlayer(selectedPlayer)
                local myHRP = GetHRP()
                local tHRP = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                if myHRP and tHRP then
                        myHRP.CFrame = tHRP.CFrame * CFrame.new(0, 0, 3)
                        Notify("Teleport", "TP a " .. target.Name, 2)
                else
                        Notify("Teleport", "Target no disponible", 2)
                end
        end,
})

local following = false
TpTab:Toggle({
        Title = "Follow Player",
        Default = false,
        Callback = function(v) following = v end,
})
task.spawn(function()
        while not HUB.dead do
                if following then
                        local target = ResolvePlayer(selectedPlayer)
                        local myHRP = GetHRP()
                        local tHRP = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                        if myHRP and tHRP then
                                myHRP.CFrame = tHRP.CFrame * CFrame.new(0, 0, 4)
                        end
                end
                task.wait(0.4)
        end
end)

TpTab:Section({ Title = "Waypoints" })
local waypoints = {}
local pendingName = "Spot 1"
local selectedWaypoint = nil
local function WaypointNames()
        local names = {}
        for name in pairs(waypoints) do table.insert(names, name) end
        table.sort(names)
        if #names == 0 then names = { "(none)" } end
        return names
end
TpTab:Input({
        Title = "Waypoint Name",
        Placeholder = "Spot 1",
        Callback = function(text) pendingName = (text ~= "" and text) or "Spot 1" end,
})
local wpDrop
TpTab:Button({
        Title = "Save Current Position",
        Callback = function()
                local hrp = GetHRP()
                if not hrp then Notify("Waypoints", "Sin personaje", 2); return end
                waypoints[pendingName] = hrp.CFrame
                pcall(function() if wpDrop then wpDrop:Refresh(WaypointNames()) end end)
                Notify("Waypoints", "Saved " .. pendingName, 2)
        end,
})
wpDrop = TpTab:Dropdown({
        Title = "Saved Waypoints",
        Values = WaypointNames(),
        Callback = function(v) selectedWaypoint = v end,
})
TpTab:Button({
        Title = "Teleport To Waypoint",
        Callback = function()
                local cf = selectedWaypoint and waypoints[selectedWaypoint]
                local hrp = GetHRP()
                if cf and hrp then
                        hrp.CFrame = cf
                        Notify("Waypoints", "TP a " .. tostring(selectedWaypoint), 2)
                end
        end,
})
TpTab:Button({
        Title = "Delete Waypoint",
        Callback = function()
                if selectedWaypoint and waypoints[selectedWaypoint] then
                        waypoints[selectedWaypoint] = nil
                        pcall(function() if wpDrop then wpDrop:Refresh(WaypointNames()) end end)
                end
        end,
})

TpTab:Section({ Title = "Misc" })
local clickTp = false
TpTab:Toggle({
        Title = "Click Teleport (Key T)",
        Desc = "Presiona T para TP al cursor.",
        Default = false,
        Callback = function(v) clickTp = v end,
})
track(UserInputService.InputBegan:Connect(function(input, gp)
        if gp or HUB.dead or not clickTp then return end
        if input.KeyCode == Enum.KeyCode.T then
                local hrp = GetHRP()
                if not hrp then return end
                local mouseLoc = UserInputService:GetMouseLocation()
                local ray = Camera:ViewportPointToRay(mouseLoc.X, mouseLoc.Y)
                local params = RaycastParams.new()
                params.FilterType = Enum.RaycastFilterType.Exclude
                params.FilterDescendantsInstances = { GetCharacter() }
                local result = Workspace:Raycast(ray.Origin, ray.Direction * 5000, params)
                if result then
                        hrp.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
                end
        end
end))
TpTab:Button({
        Title = "Teleport To Spawn",
        Callback = function()
                local hrp = GetHRP()
                local spawn = Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
                if hrp and spawn then
                        hrp.CFrame = spawn.CFrame * CFrame.new(0, 3, 0)
                        Notify("Teleport", "Spawn", 2)
                else
                        Notify("Teleport", "No spawn", 2)
                end
        end,
})

-- ========== VISUALS / ESP ==========
local VisTab = mainSec:Tab({ Title = "Visuals", Icon = "eye", ShowTabTitle = true, Border = true })
local espEnabled = false
local espTeamCheck = false
local enemyEspMap = {}

local function clearESP()
        for plr, hl in pairs(enemyEspMap) do
                pcall(function() if hl then hl:Destroy() end end)
                enemyEspMap[plr] = nil
        end
end

local function refreshESP()
        if not espEnabled then clearESP(); return end
        for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                        if espTeamCheck and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
                                if enemyEspMap[plr] then
                                        pcall(function() enemyEspMap[plr]:Destroy() end)
                                        enemyEspMap[plr] = nil
                                end
                        else
                                if not enemyEspMap[plr] then
                                        local hl = Instance.new("Highlight")
                                        hl.Name = "FlexusHub_ESP"
                                        hl.FillTransparency = 0.65
                                        hl.OutlineTransparency = 0
                                        hl.FillColor = Color3.fromRGB(200, 200, 210)
                                        hl.OutlineColor = Color3.fromRGB(230, 230, 235)
                                        hl.Adornee = plr.Character
                                        hl.Parent = plr.Character
                                        enemyEspMap[plr] = hl
                                        table.insert(HUB.highlights, hl)
                                else
                                        pcall(function()
                                                enemyEspMap[plr].Adornee = plr.Character
                                                enemyEspMap[plr].Parent = plr.Character
                                        end)
                                end
                        end
                end
        end
end

track(RunService.Heartbeat:Connect(function()
        if HUB.dead then return end
        if espEnabled then refreshESP() end
end))
Players.PlayerRemoving:Connect(function(plr)
        if enemyEspMap[plr] then
                pcall(function() enemyEspMap[plr]:Destroy() end)
                enemyEspMap[plr] = nil
        end
end)

VisTab:Section({ Title = "ESP" })
VisTab:Toggle({
        Title = "ESP Players",
        Desc = "Highlight en jugadores en jugadores.",
        Default = false,
        Callback = function(v)
                espEnabled = v
                if not v then clearESP() end
                Notify("ESP", v and "ON" or "OFF", 2)
        end,
})
VisTab:Toggle({
        Title = "Team Check",
        Default = false,
        Callback = function(v) espTeamCheck = v end,
})

VisTab:Section({ Title = "World" })
local fullbright = false
local savedLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        GlobalShadows = Lighting.GlobalShadows,
        Ambient = Lighting.Ambient,
}
VisTab:Toggle({
        Title = "Fullbright",
        Default = false,
        Callback = function(v)
                fullbright = v
                if v then
                        Lighting.Brightness = 2
                        Lighting.ClockTime = 14
                        Lighting.FogEnd = 1e9
                        Lighting.GlobalShadows = false
                        Lighting.Ambient = Color3.fromRGB(180, 180, 180)
                else
                        Lighting.Brightness = savedLighting.Brightness
                        Lighting.ClockTime = savedLighting.ClockTime
                        Lighting.FogEnd = savedLighting.FogEnd
                        Lighting.GlobalShadows = savedLighting.GlobalShadows
                        Lighting.Ambient = savedLighting.Ambient
                end
        end,
})
local defaultFOV = Camera.FieldOfView
VisTab:Slider({
        Title = "Field of View",
        Value = { Min = 30, Max = 120, Default = math.floor(defaultFOV) },
        Callback = function(v) Camera.FieldOfView = v end,
})

-- ========== COMBAT AIMBOT ==========
local CombatTab = mainSec:Tab({ Title = "Combat", Icon = "crosshair", ShowTabTitle = true, Border = true })
local aim = {
        enabled = false,
        smoothness = 12,
        fov = 150,
        prediction = 0,
        part = "Head",
        teamCheck = false,
        visibleCheck = false,
        aliveCheck = true,
        useRightClick = true,
        showFov = false,
}
local mb2Down = false
track(UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then mb2Down = true end
end))
track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then mb2Down = false end
end))

local function getAimPart(char)
        if not char then return nil end
        return char:FindFirstChild(aim.part)
                or char:FindFirstChild("Head")
                or char:FindFirstChild("HumanoidRootPart")
end

local function isAlive(char)
        if not aim.aliveCheck then return true end
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        return hum and hum.Health > 0
end

local function isVisible(char, part)
        if not aim.visibleCheck then return true end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { GetCharacter() }
        local origin = Camera.CFrame.Position
        local result = Workspace:Raycast(origin, part.Position - origin, params)
        if not result then return true end
        return result.Instance:IsDescendantOf(char)
end

local function getClosestTarget()
        local best, bestDist
        local mouse = UserInputService:GetMouseLocation()
        local center = Vector2.new(mouse.X, mouse.Y)
        for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                        local isTeammate = aim.teamCheck and p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team
                        if not isTeammate then
                                local char = p.Character
                                local part = getAimPart(char)
                                if part and isAlive(char) then
                                        local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                                        if onScreen then
                                                local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                                                if d <= aim.fov and (not bestDist or d < bestDist) and isVisible(char, part) then
                                                        best, bestDist = part, d
                                                end
                                        end
                                end
                        end
                end
        end
        return best
end

track(RunService.RenderStepped:Connect(function()
        if HUB.dead or not aim.enabled then return end
        if not (aim.useRightClick and mb2Down) then return end
        local target = getClosestTarget()
        if not target then return end
        local camPos = Camera.CFrame.Position
        local aimPos = target.Position
        if aim.prediction > 0 then
                aimPos = aimPos + target.AssemblyLinearVelocity * aim.prediction
        end
        local goal = CFrame.new(camPos, aimPos)
        local alpha = math.clamp(1 / math.max(aim.smoothness, 1), 0, 1)
        Camera.CFrame = Camera.CFrame:Lerp(goal, alpha)
end))

CombatTab:Section({ Title = "Aimbot" })
CombatTab:Toggle({
        Title = "Enabled",
        Desc = "Hold Right-Click para apuntar.",
        Default = false,
        Callback = function(v)
                aim.enabled = v
                Notify("Aimbot", v and "ON (RMB)" or "OFF", 2)
        end,
})
CombatTab:Slider({
        Title = "Smoothness",
        Value = { Min = 1, Max = 40, Default = 12 },
        Callback = function(v) aim.smoothness = v end,
})
CombatTab:Slider({
        Title = "FOV (px)",
        Value = { Min = 30, Max = 600, Default = 150 },
        Callback = function(v) aim.fov = v end,
})
CombatTab:Dropdown({
        Title = "Target Part",
        Values = { "Head", "UpperTorso", "Torso", "HumanoidRootPart" },
        Value = "Head",
        Callback = function(v) aim.part = v end,
})
CombatTab:Toggle({
        Title = "Team Check",
        Default = false,
        Callback = function(v) aim.teamCheck = v end,
})
CombatTab:Toggle({
        Title = "Wall Check",
        Default = false,
        Callback = function(v) aim.visibleCheck = v end,
})
CombatTab:Toggle({
        Title = "Hold Right-Click",
        Default = true,
        Callback = function(v) aim.useRightClick = v end,
})

-- ========== SERVER ==========
local ServerTab = extraSec:Tab({ Title = "Server", Icon = "globe", ShowTabTitle = true, Border = true })
ServerTab:Button({
        Title = "Rejoin Server",
        Callback = function()
                Notify("Server", "Rejoining...", 2)
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end,
})
ServerTab:Button({
        Title = "Server Hop",
        Callback = function()
                Notify("Server", "Buscando server...", 2)
                task.spawn(function()
                        local ok, err = pcall(function()
                                local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)
                                local data = HttpService:JSONDecode(game:HttpGet(url))
                                for _, s in ipairs(data.data or {}) do
                                        if type(s.playing) == "number" and s.playing < s.maxPlayers and s.id ~= game.JobId then
                                                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                                                return
                                        end
                                end
                                TeleportService:Teleport(game.PlaceId, LocalPlayer)
                        end)
                        if not ok then Notify("Server", "Hop failed", 3) end
                end)
        end,
})
ServerTab:Button({
        Title = "Copy Job ID",
        Callback = function()
                pcall(function()
                        if setclipboard then setclipboard(game.JobId)
                        elseif toclipboard then toclipboard(game.JobId) end
                end)
                Notify("Server", "JobId copiado", 2)
        end,
})
ServerTab:Paragraph({
        Title = "Session",
        Desc = ("Place: %d\nJob: %s\nPlayers: %d/%d"):format(
                game.PlaceId,
                tostring(game.JobId),
                #Players:GetPlayers(),
                Players.MaxPlayers
        ),
})

-- ========== SETTINGS ==========
local SettingsTab = extraSec:Tab({ Title = "Settings", Icon = "settings", ShowTabTitle = true, Border = true })
SettingsTab:Paragraph({
        Title = "FlexusHub Universal",
        Desc = "Este script se usa cuando el loader no encuentra un script dedicado para el juego actual.",
})
SettingsTab:Button({
        Title = "Unload Hub",
        Callback = function()
                HUB.Unload()
        end,
})

function HUB.Unload()
        if HUB.dead then return end
        HUB.dead = true
        flying = false
        noclip = false
        following = false
        aim.enabled = false
        espEnabled = false
        pcall(stopFly)
        pcall(stopNoclip)
        clearESP()
        for _, c in ipairs(HUB.conns) do pcall(function() c:Disconnect() end) end
        for _, h in ipairs(HUB.highlights) do pcall(function() h:Destroy() end) end
        pcall(function()
                local hum = GetHumanoid()
                if hum then hum.PlatformStand = false; hum.WalkSpeed = 16; hum.JumpPower = 50 end
        end)
        Workspace.Gravity = defaultGravity
        Camera.FieldOfView = defaultFOV
        if fullbright then
                Lighting.Brightness = savedLighting.Brightness
                Lighting.ClockTime = savedLighting.ClockTime
                Lighting.FogEnd = savedLighting.FogEnd
                Lighting.GlobalShadows = savedLighting.GlobalShadows
                Lighting.Ambient = savedLighting.Ambient
        end
        pcall(function() Window:Destroy() end)
        _G.FlexusUniversal = nil
        Notify("FlexusHub Universal", "Unloaded", 2)
end

print("[FlexusHub] Universal loaded")