--[[
  Vortex X Sage · Universal Hub (WindUI)
  Se carga cuando el PlaceId / GameId no está en la lista del loader.
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- Re-execution guard
pcall(function()
	if _G.VortexUniversalUnload then _G.VortexUniversalUnload() end
end)

local HUB = { conns = {}, drawings = {}, highlights = {}, dead = false }
_G.VortexUniversal = HUB
_G.VortexUniversalUnload = function()
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

-- ========== Vortex Notify ==========
local VortexNotify = {}
do
	local currentFrame, currentToken = nil, 0
	local WIDTH, HEIGHT = 260, 58
	local function getHost()
		local host
		pcall(function() if gethui then host = gethui() end end)
		if not host then host = CoreGui end
		local gui = host:FindFirstChild("VortexNotifyHost")
		if not gui then
			gui = Instance.new("ScreenGui")
			gui.Name = "VortexNotifyHost"
			gui.ResetOnSpawn = false
			gui.IgnoreGuiInset = true
			gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
			gui.Parent = host
		end
		return gui
	end
	function VortexNotify.Show(title, text, duration)
		duration = tonumber(duration) or 2.5
		title = tostring(title or "Vortex X Sage")
		text = tostring(text or "")
		if currentFrame then
			pcall(function() currentFrame:Destroy() end)
			currentFrame = nil
		end
		currentToken = currentToken + 1
		local token = currentToken
		local gui = getHost()
		local frame = Instance.new("Frame")
		frame.AnchorPoint = Vector2.new(1, 0)
		frame.Size = UDim2.fromOffset(WIDTH, HEIGHT)
		frame.Position = UDim2.new(1, 20, 0, 16)
		frame.BackgroundColor3 = Color3.fromRGB(18, 14, 8)
		frame.BackgroundTransparency = 0.35
		frame.BorderSizePixel = 0
		frame.Parent = gui
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
		local stroke = Instance.new("UIStroke", frame)
		stroke.Color = Color3.fromRGB(255, 200, 60)
		stroke.Thickness = 1.2
		stroke.Transparency = 0.35
		local accent = Instance.new("Frame", frame)
		accent.Size = UDim2.new(0, 4, 1, -10)
		accent.Position = UDim2.fromOffset(6, 5)
		accent.BackgroundColor3 = Color3.fromRGB(255, 195, 45)
		accent.BorderSizePixel = 0
		Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)
		local titleL = Instance.new("TextLabel", frame)
		titleL.BackgroundTransparency = 1
		titleL.Position = UDim2.fromOffset(16, 6)
		titleL.Size = UDim2.new(1, -24, 0, 18)
		titleL.Font = Enum.Font.GothamBold
		titleL.TextSize = 13
		titleL.TextXAlignment = Enum.TextXAlignment.Left
		titleL.TextColor3 = Color3.fromRGB(255, 215, 90)
		titleL.Text = title
		local bodyL = Instance.new("TextLabel", frame)
		bodyL.BackgroundTransparency = 1
		bodyL.Position = UDim2.fromOffset(16, 26)
		bodyL.Size = UDim2.new(1, -24, 0, 24)
		bodyL.Font = Enum.Font.Gotham
		bodyL.TextSize = 11
		bodyL.TextXAlignment = Enum.TextXAlignment.Left
		bodyL.TextColor3 = Color3.fromRGB(230, 230, 235)
		bodyL.Text = text
		bodyL.TextWrapped = true
		currentFrame = frame
		TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Position = UDim2.new(1, -16, 0, 16),
		}):Play()
		task.delay(duration, function()
			if token ~= currentToken or currentFrame ~= frame then return end
			currentFrame = nil
			local tw = TweenService:Create(frame, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.new(1, 40, 0, 16),
				BackgroundTransparency = 1,
			})
			tw:Play()
			task.delay(0.3, function() pcall(function() frame:Destroy() end) end)
		end)
	end
end

local function Notify(title, content, duration)
	VortexNotify.Show(title, content, duration or 2.5)
end

-- ========== WindUI ==========
local WindUI
for _, url in ipairs({
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
	warn("[Vortex Universal] WindUI no cargo")
	return
end

pcall(function()
	WindUI.Notify = function(_, opts)
		opts = opts or {}
		VortexNotify.Show(opts.Title or "Vortex X Sage", opts.Content or opts.Text or "", opts.Duration or 2.5)
	end
end)

WindUI:AddTheme({
	Name = "VortexGoldSolid",
	Accent = Color3.fromRGB(255, 195, 45),
	Background = Color3.fromRGB(12, 12, 14),
	BackgroundTransparency = 0,
	Outline = Color3.fromRGB(255, 200, 60),
	Text = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(200, 200, 210),
	WindowBackground = Color3.fromRGB(14, 14, 16),
	DialogBackground = Color3.fromRGB(18, 18, 22),
	DialogBackgroundTransparency = 0,
	DialogTitle = Color3.fromRGB(255, 255, 255),
	DialogContent = Color3.fromRGB(235, 235, 240),
	DialogIcon = Color3.fromRGB(255, 200, 60),
	WindowTopbarButtonIcon = Color3.fromRGB(255, 255, 255),
	WindowTopbarTitle = Color3.fromRGB(255, 255, 255),
	WindowTopbarAuthor = Color3.fromRGB(210, 210, 220),
	WindowTopbarIcon = Color3.fromRGB(255, 200, 60),
	TabBackground = Color3.fromRGB(20, 20, 24),
	TabTitle = Color3.fromRGB(255, 255, 255),
	TabIcon = Color3.fromRGB(255, 205, 70),
	ElementBackground = Color3.fromRGB(24, 24, 30),
	ElementTitle = Color3.fromRGB(255, 255, 255),
	ElementDesc = Color3.fromRGB(200, 200, 210),
	ElementIcon = Color3.fromRGB(255, 205, 70),
	PopupBackground = Color3.fromRGB(18, 18, 22),
	PopupBackgroundTransparency = 0,
	PopupTitle = Color3.fromRGB(255, 255, 255),
	PopupContent = Color3.fromRGB(230, 230, 235),
	PopupIcon = Color3.fromRGB(255, 205, 70),
	Toggle = Color3.fromRGB(255, 195, 45),
	ToggleBar = Color3.fromRGB(40, 40, 50),
	Checkbox = Color3.fromRGB(40, 40, 50),
	CheckboxIcon = Color3.fromRGB(255, 255, 255),
	Slider = Color3.fromRGB(255, 195, 45),
	SliderThumb = Color3.fromRGB(255, 255, 255),
})
WindUI:SetTheme("VortexGoldSolid")

local Window = WindUI:CreateWindow({
	Title = "Vortex X Sage [Universal]",
	Icon = "rbxassetid://118833096342184",
	IconSize = 35,
	Author = "By Israelcc",
	Folder = "VortexXSage",
	Background = "rbxassetid://133044138027516",
	Size = UDim2.fromOffset(680, 520),
	MinSize = Vector2.new(480, 360),
	MaxSize = Vector2.new(1100, 800),
	Resizable = true,
	HideSearchBar = true,
	Transparent = false,
	Theme = "VortexGoldSolid",
	User = { Enabled = true, Anonymous = false },
})

Window:EditOpenButton({
	Title = "VXS",
	Icon = "rbxassetid://118833096342184",
	CornerRadius = UDim.new(1, 0),
	StrokeThickness = 2,
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 110, 20)),
		ColorSequenceKeypoint.new(0.4, Color3.fromRGB(220, 170, 40)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 90)),
	}),
	OnlyMobile = true,
	Enabled = true,
	Draggable = true,
})

pcall(function()
	Window:Tag({ Title = "Universal", Icon = "globe", Color = Color3.fromRGB(220, 170, 40) })
end)
Window:SetToggleKey(Enum.KeyCode.K)

Notify("Login VortexHub", "Universal · juego no listado", 3)

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

-- ========== INFO ==========
local InfoTab = mainSec:Tab({ Title = "Info", Icon = "info", ShowTabTitle = true, Border = true })
InfoTab:Select()
InfoTab:Section({ Title = "Acerca del Script" })
InfoTab:Paragraph({
	Title = "Vortex X Sage [Universal]",
	Desc = "Hub universal para juegos que aún no tienen script dedicado.\nIncluye movimiento, fly, teleport, ESP, aimbot y server tools.\n\nDesarrollador: Israelcc\nUI: WindUI\nModo: Universal (fallback del loader)",
})
InfoTab:Paragraph({
	Title = "Juego actual",
	Desc = ("Name: %s\nPlaceId: %s\nGameId: %s"):format(
		tostring(game.Name),
		tostring(game.PlaceId),
		tostring(game.GameId)
	),
})
InfoTab:Divider()
InfoTab:Paragraph({
	Title = "Discord",
	Desc = "https://discord.gg/Fn74MpzFUn",
	Image = "rbxassetid://88267176037146",
	ImageSize = 80,
})
InfoTab:Button({
	Title = "Copiar Discord",
	Callback = function()
		pcall(function()
			if setclipboard then setclipboard("https://discord.gg/Fn74MpzFUn")
			elseif toclipboard then toclipboard("https://discord.gg/Fn74MpzFUn") end
		end)
		Notify("Discord", "Invite copiado", 2)
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
if not _G.VortexUniversalAntiAFK then
	_G.VortexUniversalAntiAFK = true
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
					hl.Name = "VXS_ESP"
					hl.FillTransparency = 0.65
					hl.OutlineTransparency = 0
					hl.FillColor = Color3.fromRGB(255, 195, 45)
					hl.OutlineColor = Color3.fromRGB(255, 215, 90)
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
	Desc = "Highlight dorado en jugadores.",
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
	Title = "Universal Hub",
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
	_G.VortexUniversal = nil
	Notify("Vortex Universal", "Unloaded", 2)
end

print("[Vortex X Sage] Universal Hub loaded · PlaceId=" .. tostring(game.PlaceId))
