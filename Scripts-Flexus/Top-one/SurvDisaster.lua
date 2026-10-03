-- ==========================================
-- VORTEX X SAGE - SURVIVAL DISASTER [WindUI]
-- ==========================================

if _G.EmoteFling_GlobalCleanup then
    pcall(function() _G.EmoteFling_GlobalCleanup() end)
end

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- VORTEX NOTIFY (pequeña, dorada, transparente)
-- Solo 1 visible: la nueva reemplaza a la anterior
-- ==========================================
local VortexNotify = {}
do
	local TweenService = game:GetService("TweenService")
	local CoreGui = game:GetService("CoreGui")
	local currentFrame = nil
	local currentToken = 0
	local WIDTH, HEIGHT = 260, 58

	local function getHost()
		local host
		pcall(function()
			if gethui then host = gethui() end
		end)
		if not host then
			host = CoreGui
		end
		local gui = host:FindFirstChild("VortexNotifyHost")
		if not gui then
			gui = Instance.new("ScreenGui")
			gui.Name = "VortexNotifyHost"
			gui.ResetOnSpawn = false
			gui.IgnoreGuiInset = true
			gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			pcall(function()
				if syn and syn.protect_gui then syn.protect_gui(gui) end
			end)
			gui.Parent = host
		end
		return gui
	end

	local function dismiss(frame, instant)
		if not frame then return end
		pcall(function()
			if instant then
				frame:Destroy()
				return
			end
			local tw = TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.new(1, 40, 0, 16),
				BackgroundTransparency = 1,
			})
			tw:Play()
			task.delay(0.28, function()
				pcall(function() frame:Destroy() end)
			end)
		end)
	end

	function VortexNotify.Show(title, text, duration)
		duration = tonumber(duration) or 2.5
		title = tostring(title or "Vortex X Sage")
		text = tostring(text or "")

		-- Quitar la anterior al instante
		if currentFrame then
			local old = currentFrame
			currentFrame = nil
			dismiss(old, true)
		end

		currentToken = currentToken + 1
		local token = currentToken

		local gui = getHost()
		local frame = Instance.new("Frame")
		frame.Name = "VN"
		frame.AnchorPoint = Vector2.new(1, 0)
		frame.Size = UDim2.fromOffset(WIDTH, HEIGHT)
		frame.Position = UDim2.new(1, 20, 0, 16)
		frame.BackgroundColor3 = Color3.fromRGB(18, 14, 8)
		frame.BackgroundTransparency = 0.35
		frame.BorderSizePixel = 0
		frame.Parent = gui
		currentFrame = frame

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 10)
		corner.Parent = frame

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(255, 200, 55)
		stroke.Thickness = 1.2
		stroke.Transparency = 0.35
		stroke.Parent = frame

		local accent = Instance.new("Frame")
		accent.Size = UDim2.new(0, 3, 1, -12)
		accent.Position = UDim2.new(0, 6, 0, 6)
		accent.BackgroundColor3 = Color3.fromRGB(255, 195, 45)
		accent.BackgroundTransparency = 0.15
		accent.BorderSizePixel = 0
		accent.Parent = frame
		Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

		local titleL = Instance.new("TextLabel")
		titleL.BackgroundTransparency = 1
		titleL.Position = UDim2.new(0, 14, 0, 6)
		titleL.Size = UDim2.new(1, -22, 0, 18)
		titleL.Font = Enum.Font.GothamBold
		titleL.TextSize = 13
		titleL.TextXAlignment = Enum.TextXAlignment.Left
		titleL.TextColor3 = Color3.fromRGB(255, 220, 90)
		titleL.Text = title
		titleL.Parent = frame

		local bodyL = Instance.new("TextLabel")
		bodyL.BackgroundTransparency = 1
		bodyL.Position = UDim2.new(0, 14, 0, 26)
		bodyL.Size = UDim2.new(1, -22, 0, 28)
		bodyL.Font = Enum.Font.Gotham
		bodyL.TextSize = 12
		bodyL.TextXAlignment = Enum.TextXAlignment.Left
		bodyL.TextYAlignment = Enum.TextYAlignment.Top
		bodyL.TextWrapped = true
		bodyL.TextColor3 = Color3.fromRGB(230, 220, 190)
		bodyL.TextTransparency = 0.1
		bodyL.Text = text
		bodyL.Parent = frame

		TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Position = UDim2.new(1, -16, 0, 16)
		}):Play()

		task.delay(duration, function()
			if token ~= currentToken then return end
			if currentFrame ~= frame then return end
			currentFrame = nil
			local tw = TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
				Position = UDim2.new(1, 40, 0, 16),
				BackgroundTransparency = 1
			})
			tw:Play()
			pcall(function()
				titleL.TextTransparency = 1
				bodyL.TextTransparency = 1
				stroke.Transparency = 1
				accent.BackgroundTransparency = 1
			end)
			tw.Completed:Wait()
			pcall(function() frame:Destroy() end)
		end)
	end
end

local function VXSNotify(title, content, duration)
	pcall(function()
		if VortexNotify and VortexNotify.Show then
			VortexNotify.Show(tostring(title or "Vortex X Sage"), tostring(content or ""), tonumber(duration) or 2.5)
		end
	end)
end

-- Redirigir WindUI Notify -> VortexNotify
pcall(function()
    if WindUI and type(WindUI.Notify) == "function" then
        local _old = WindUI.Notify
        WindUI.Notify = function(self, opts)
            opts = opts or {}
            if type(self) == "table" and not opts.Title and self.Title then
                opts = self
                self = WindUI
            end
            pcall(function()
                if VortexNotify and VortexNotify.Show then
                    VortexNotify.Show(tostring(opts.Title or "Vortex X Sage"), tostring(opts.Content or opts.Text or ""), tonumber(opts.Duration) or 2.5)
                end
            end)
            -- no llamar old para evitar doble notificacion
        end
    end
end)




local ModuleState = _G.ModuleState or { EmoteFlingActive = false, TurboFlingActive = false }
_G.ModuleState = ModuleState

local EmoteFlingConfig = {
    Armed = true,
    AnimId = "133566007754001",
    Speed = 16,
    Active = false,
    Resolving = false,
    UseCustomId = false,
    CustomId = "",
    ToggleKey = Enum.KeyCode.K,
    QuickFireKey = Enum.KeyCode.T,
    NotificationsEnabled = true,
    antiFallEnabled = false,
    godEnabled = false,
    antiFlingEnabled = false,
    noclipEnabled = false,
}

-- Fly (Superman / Invincible style)
local flyEnabled = false
local flySpeed = 90
local flyBV, flyBG = nil, nil
local flyConn = nil
local flyBubbleFab = nil

local EmoteFlingTrack = nil
local lastFireTime = 0
local FIRE_COOLDOWN = 1
local UI_Loaded = false
local editBubblesState = false
local bubbleSize = 42

local PresetAnimations = {
    ["Dropkick"] = "133566007754001",
    ["Dropkicking [TRENDY]"] = "90717656419568",
    ["Tenna Kick"] = "118139885865308",
    ["MMA Kick"] = "88347541858075",
    ["Slap"] = "108225134235478",
    ["Slap2"] = "78221709455150",
    ["Push"] = "135890160317037",
    ["Push2"] = "82070755455634",
}
local PresetNames = { "Dropkick", "Dropkicking [TRENDY]", "Tenna Kick", "MMA Kick", "Slap", "Slap2", "Push", "Push2" }
local CONFIG_FILE = "VortexXSage_EmoteFling.json"

local EventConnections = {}
local function RegisterConnection(name, conn)
    if EventConnections[name] then
        pcall(function() EventConnections[name]:Disconnect() end)
    end
    EventConnections[name] = conn
end
local function DisconnectConnection(name)
    if EventConnections[name] then
        pcall(function() EventConnections[name]:Disconnect() end)
        EventConnections[name] = nil
    end
end

-- WindUI
local WindUI
do
    local urls = {
        "https://github.com/MrSxxo/WindUI/releases/latest/download/main.lua",
        "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua",
        "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua",
    }
    for _, url in ipairs(urls) do
        local ok, res = pcall(function() return loadstring(game:HttpGet(url))() end)
        if ok and res then WindUI = res break end
    end
end
if not WindUI then
    warn("[Vortex] WindUI load failed")
    return
end

local function Notify(data)
    if not EmoteFlingConfig.NotificationsEnabled then return end
    pcall(function()
        VXSNotify("Vortex X Sage", "", 2.5)
    end)
end

local function showBottomMessage(msg)
    pcall(function()
        if VortexNotify and VortexNotify.Show then
            VortexNotify.Show("Vortex X Sage", tostring(msg or ""), 2.2)
        end
    end)
    Notify({ Title = "Vortex X Sage", Content = tostring(msg), Duration = 2 })
end

local function SaveConfig()
    pcall(function()
        if flyEnabled ~= nil then SharedOpts.flyEnabled = flyEnabled end
        if flySpeed ~= nil then SharedOpts.flySpeed = flySpeed end
        if auraEnabled ~= nil then SharedOpts.auraEnabled = auraEnabled end
        if auraRadius ~= nil then SharedOpts.auraRadius = auraRadius end
        if auraAttraction ~= nil then SharedOpts.auraAttraction = auraAttraction end
        if bubbleSize ~= nil then SharedOpts.bubbleSize = bubbleSize end
    end)
    local config = {
        Armed = EmoteFlingConfig.Armed,
        AnimId = EmoteFlingConfig.AnimId,
        Speed = EmoteFlingConfig.Speed,
        UseCustomId = EmoteFlingConfig.UseCustomId,
        CustomId = EmoteFlingConfig.CustomId,
        NotificationsEnabled = EmoteFlingConfig.NotificationsEnabled,
        antiFallEnabled = EmoteFlingConfig.antiFallEnabled,
        godEnabled = EmoteFlingConfig.godEnabled,
        antiFlingEnabled = EmoteFlingConfig.antiFlingEnabled,
        noclipEnabled = EmoteFlingConfig.noclipEnabled,
        ToggleKey = (EmoteFlingConfig.ToggleKey and typeof(EmoteFlingConfig.ToggleKey) == "EnumItem") and EmoteFlingConfig.ToggleKey.Name or "K",
        QuickFireKey = (EmoteFlingConfig.QuickFireKey and typeof(EmoteFlingConfig.QuickFireKey) == "EnumItem") and EmoteFlingConfig.QuickFireKey.Name or "T",
        BubbleSize = tonumber(SharedOpts.bubbleSize) or bubbleSize,
        -- Fly / Aura / extras (via SharedOpts para no perder locals)
        flyEnabled = SharedOpts.flyEnabled == true,
        flySpeed = tonumber(SharedOpts.flySpeed) or 90,
        auraEnabled = SharedOpts.auraEnabled == true,
        auraRadius = tonumber(SharedOpts.auraRadius) or 50,
        auraAttraction = tonumber(SharedOpts.auraAttraction) or 1000,
        FloatingButtonsEnabled = EmoteFlingConfig.FloatingButtonsEnabled ~= false,
    }
    pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(config)) end)
end

local function LoadConfig()
    local fileExists = false
    if type(isfile) == "function" then
        pcall(function() fileExists = isfile(CONFIG_FILE) end)
    else
        local ok = pcall(function() return readfile(CONFIG_FILE) end)
        fileExists = ok
    end
    if not fileExists then SaveConfig() return false end
    local ok, content = pcall(function() return readfile(CONFIG_FILE) end)
    if ok and content and content ~= "" then
        local decodeOk, config = pcall(function() return HttpService:JSONDecode(content) end)
        if decodeOk and type(config) == "table" then
            EmoteFlingConfig.Armed = config.Armed ~= false
            EmoteFlingConfig.AnimId = config.AnimId or "133566007754001"
            EmoteFlingConfig.Speed = config.Speed or 16
            EmoteFlingConfig.UseCustomId = config.UseCustomId or false
            EmoteFlingConfig.CustomId = config.CustomId or ""
            EmoteFlingConfig.NotificationsEnabled = config.NotificationsEnabled ~= false
            EmoteFlingConfig.antiFallEnabled = config.antiFallEnabled == true
            EmoteFlingConfig.godEnabled = config.godEnabled == true
            EmoteFlingConfig.antiFlingEnabled = config.antiFlingEnabled == true
            EmoteFlingConfig.noclipEnabled = config.noclipEnabled == true
            bubbleSize = math.clamp(tonumber(config.BubbleSize) or 42, 28, 64)
            if config.flyEnabled ~= nil then flyEnabled = config.flyEnabled == true end
            if config.flySpeed ~= nil then flySpeed = tonumber(config.flySpeed) or flySpeed end
            if config.auraEnabled ~= nil then auraEnabled = config.auraEnabled == true end
            if config.auraRadius ~= nil then radius = tonumber(config.auraRadius) or radius end
            if config.auraAttraction ~= nil then attractionStrength = tonumber(config.auraAttraction) or attractionStrength end
            if config.FloatingButtonsEnabled ~= nil then EmoteFlingConfig.FloatingButtonsEnabled = config.FloatingButtonsEnabled ~= false end
            if config.ToggleKey then pcall(function() EmoteFlingConfig.ToggleKey = Enum.KeyCode[config.ToggleKey] end) end
            if config.QuickFireKey then pcall(function() EmoteFlingConfig.QuickFireKey = Enum.KeyCode[config.QuickFireKey] end) end
            return true
        end
    end
    SaveConfig()
    return false
end

local ConfigLoaded = LoadConfig()

local function GetPresetNameFromId(id)
    for name, presetId in pairs(PresetAnimations) do
        if presetId == id then return name end
    end
    return "Dropkick"
end

local function ResolveAnimationId(rawId)
    if not rawId or type(rawId) ~= "string" or rawId == "" or rawId:match("^%s*$") then return nil end
    local numStr = rawId:match("%d+")
    if not numStr then return nil end
    local numId = tonumber(numStr)
    local ok, info = pcall(function() return MarketplaceService:GetProductInfo(numId) end)
    if ok and info then
        if info.AssetTypeId ~= 24 and info.AssetTypeId ~= 61 then return nil end
    end
    local getOk, objects = pcall(function() return game:GetObjects("rbxassetid://" .. numStr) end)
    if getOk and type(objects) == "table" then
        for _, obj in pairs(objects) do
            if typeof(obj) == "Instance" then
                if obj:IsA("Animation") then return obj.AnimationId end
                local childAnim = obj:FindFirstChildWhichIsA("Animation", true)
                if childAnim then return childAnim.AnimationId end
            end
        end
    end
    return "rbxassetid://" .. numStr
end

local function EmoteFlingCleanup()
    EmoteFlingConfig.Active = false
    ModuleState.EmoteFlingActive = false
    if EmoteFlingTrack then
        pcall(function() EmoteFlingTrack:Stop() end)
        EmoteFlingTrack = nil
    end
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            pcall(function() hrp.Velocity = Vector3.zero end)
            pcall(function() hrp.RotVelocity = Vector3.zero end)
        end
    end
end

local function FireEmoteFling()
    local now = tick()
    if now - lastFireTime < FIRE_COOLDOWN then return end
    lastFireTime = now

    if EmoteFlingConfig.Resolving then
        Notify({ Title = "Emote Fling", Content = "Resolviendo animacion...", Duration = 2, Icon = "loader" })
        return
    end
    if EmoteFlingConfig.Active then
        EmoteFlingConfig.Active = false
        return
    end
    if not EmoteFlingConfig.Armed then
        Notify({ Title = "Emote Fling", Content = "Activa Enable Emote Fling primero.", Duration = 2, Icon = "alert-circle" })
        return
    end

    local targetId = EmoteFlingConfig.AnimId
    if type(targetId) ~= "string" or targetId == "" or targetId:match("^%s*$") then
        Notify({ Title = "Emote Fling", Content = "Animation ID invalido.", Duration = 2, Icon = "alert-circle" })
        return
    end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")
    if not (hrp and hum) then
        Notify({ Title = "Emote Fling", Content = "Personaje no encontrado.", Duration = 2, Icon = "alert-circle" })
        return
    end

    EmoteFlingConfig.Resolving = true
    Notify({ Title = "Emote Fling", Content = "Resolviendo animacion...", Duration = 1.5, Icon = "loader" })

    task.spawn(function()
        local finalAnimId = ResolveAnimationId(targetId)
        EmoteFlingConfig.Resolving = false
        if not finalAnimId then
            Notify({ Title = "Emote Fling", Content = "ID invalido (debe ser Animation/Emote).", Duration = 3, Icon = "x-circle" })
            return
        end

        char = LocalPlayer.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        hum = char and char:FindFirstChildWhichIsA("Humanoid")
        if not (hrp and hum) then return end

        local anim = Instance.new("Animation")
        anim.AnimationId = finalAnimId
        local trackOk, track = pcall(function() return hum:LoadAnimation(anim) end)
        if not trackOk or not track then
            Notify({ Title = "Emote Fling", Content = "No se pudo cargar la animacion.", Duration = 2, Icon = "x-circle" })
            return
        end

        EmoteFlingConfig.Active = true
        ModuleState.EmoteFlingActive = true
        EmoteFlingTrack = track

        local animStopped = false
        local trackStoppedConn
        trackStoppedConn = track.Stopped:Once(function()
            animStopped = true
            if trackStoppedConn then pcall(function() trackStoppedConn:Disconnect() end) end
        end)

        track.Priority = Enum.AnimationPriority.Action
        track.Looped = false
        track:Play()

        Notify({ Title = "Emote Fling", Content = "Activo! Vuelve a ejecutar para STOP.", Duration = 2, Icon = "zap" })

        local flip = 1
        local timeout = tick() + 300

        while EmoteFlingConfig.Active and not animStopped do
            if tick() > timeout then break end
            RunService.Heartbeat:Wait()
            local c = LocalPlayer.Character
            local r = c and c:FindFirstChild("HumanoidRootPart")
            local h = c and c:FindFirstChildWhichIsA("Humanoid")
            if r and h then
                local dir = h.MoveDirection
                flip = flip * -1
                r.AssemblyLinearVelocity = Vector3.new(100000 * flip, 0, 100000 * flip)
                r.AssemblyAngularVelocity = Vector3.new(100000 * flip, 100000 * flip, 100000 * flip)
                RunService.RenderStepped:Wait()
                if not EmoteFlingConfig.Active then break end
                if dir.Magnitude > 0 then
                    local spd = EmoteFlingConfig.Speed
                    r.AssemblyLinearVelocity = Vector3.new(dir.X * spd, -2, dir.Z * spd)
                    pcall(function() r.Velocity = Vector3.new(dir.X * spd, -2, dir.Z * spd) end)
                else
                    r.AssemblyLinearVelocity = Vector3.new(0, -2, 0)
                    pcall(function() r.Velocity = Vector3.new(0, -2, 0) end)
                end
                r.AssemblyAngularVelocity = Vector3.zero
                pcall(function() r.RotVelocity = Vector3.zero end)
            else
                break
            end
        end
        EmoteFlingCleanup()
        Notify({ Title = "Emote Fling", Content = "Fisica restaurada.", Duration = 2, Icon = "shield-off" })
    end)
end

local function fireWithSpecificId(animId)
    if type(animId) ~= "string" or animId == "" or animId:match("^%s*$") then return end
    local savedId = EmoteFlingConfig.AnimId
    EmoteFlingConfig.AnimId = animId
    FireEmoteFling()
    EmoteFlingConfig.AnimId = savedId
end


local function setFlyBubbleVisual(on)
	pcall(function()
		local ic = flyBubbleFab and flyBubbleFab:FindFirstChild("Icon")
		local st = flyBubbleFab and flyBubbleFab:FindFirstChild("Stroke")
		if on then
			if ic then ic.ImageColor3 = Color3.fromRGB(120, 200, 255) end
			if st then st.Color = Color3.fromRGB(120, 200, 255); st.Transparency = 0.15 end
		else
			if ic then ic.ImageColor3 = Color3.fromRGB(255, 200, 55) end
			if st then st.Color = Color3.fromRGB(255, 200, 55); st.Transparency = 0.45 end
		end
	end)
end

local flyAnimTrack = nil
local flyControls = nil
local flySmoothVel = Vector3.zero

local function getFlyControls()
	if flyControls then return flyControls end
	pcall(function()
		local ps = LocalPlayer:FindFirstChild("PlayerScripts")
		local pm = ps and ps:FindFirstChild("PlayerModule")
		if pm then
			flyControls = require(pm):GetControls()
		end
	end)
	return flyControls
end

-- Input unificado PC + Movil (joystick) relativo a camara
local function getFlyMoveDir(cam, hum)
	local move = Vector3.zero
	local ctrl = getFlyControls()
	if ctrl then
		pcall(function()
			local mv = ctrl:GetMoveVector()
			if mv and mv.Magnitude > 0.05 then
				-- GetMoveVector suele ser relativo a camara (X=right, Z=forward)
				local look = cam.CFrame.LookVector
				local right = cam.CFrame.RightVector
				move = right * mv.X + look * -mv.Z
				-- vertical con pitch de camara al avanzar
				if math.abs(mv.Z) > 0.1 then
					move = move + Vector3.yAxis * (look.Y * -mv.Z * 0.9)
				end
			end
		end)
	end

	-- PC teclado (siempre suma, por si el modulo no captura)
	if not UserInputService:GetFocusedTextBox() then
		local look = cam.CFrame.LookVector
		local right = cam.CFrame.RightVector
		local k = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then k = k + look end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then k = k - look end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then k = k - right end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then k = k + right end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then k = k + Vector3.yAxis end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			k = k - Vector3.yAxis
		end
		if k.Magnitude > 0.05 then
			move = move + k
		end
	end

	-- Mobile / stick: siempre sumar MoveDirection + pitch de camara
	if hum and hum.MoveDirection.Magnitude > 0.05 then
		local md = hum.MoveDirection
		local lookY = cam.CFrame.LookVector.Y
		move = move + Vector3.new(md.X, lookY * md.Magnitude, md.Z)
	end
	-- Legacy flat fallback kept for older paths
	if false and move.Magnitude < 0.08 and hum and hum.MoveDirection.Magnitude > 0.05 then
		local md = hum.MoveDirection
		local flatLook = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
		if flatLook.Magnitude > 0.05 then
			flatLook = flatLook.Unit
			local right = Vector3.new(-flatLook.Z, 0, flatLook.X)
			-- md ya viene en mundo; usarlo directo + pitch de camara
			move = md + Vector3.yAxis * (cam.CFrame.LookVector.Y * md.Magnitude * 0.75)
		else
			move = md
		end
	end

	if move.Magnitude > 1 then
		move = move.Unit
	end
	return move
end

local function stopFlyAnim()
	if flyAnimTrack then
		pcall(function() flyAnimTrack:Stop(0.2) end)
		flyAnimTrack = nil
	end
end

local function playFlyAnim(hum)
	stopFlyAnim()
	if not hum then return end
	-- Pose de vuelo / freefall (animacion base Roblox, se ve menos "palo")
	local ids = {
		"rbxassetid://616006778", -- levitation idle-ish
		"rbxassetid://10921293373", -- fall
		"rbxassetid://507767968", -- fall classic
	}
	for _, id in ipairs(ids) do
		local ok, track = pcall(function()
			local a = Instance.new("Animation")
			a.AnimationId = id
			return hum:LoadAnimation(a)
		end)
		if ok and track then
			pcall(function()
				track.Priority = Enum.AnimationPriority.Action
				track.Looped = true
				track:Play(0.25)
				track:AdjustSpeed(0.35)
			end)
			flyAnimTrack = track
			return
		end
	end
end

local function stopFlyMovers()
	if flyConn then pcall(function() flyConn:Disconnect() end) flyConn = nil end
	if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
	if flyBG then pcall(function() flyBG:Destroy() end) flyBG = nil end
	stopFlyAnim()
	flySmoothVel = Vector3.zero
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		pcall(function()
			hum.PlatformStand = false
			hum.AutoRotate = true
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		end)
	end
end

local function startFlyMovers()
	stopFlyMovers()
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hrp then return false end

	-- NO PlatformStand: el cuerpo puede animar (no queda como palo)
	if hum then
		pcall(function()
			hum.PlatformStand = false
			hum.AutoRotate = false
			hum:ChangeState(Enum.HumanoidStateType.Freefall)
		end)
		playFlyAnim(hum)
	end

	local bv = Instance.new("BodyVelocity")
	bv.Name = "VXFlyVel"
	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bv.P = 1250
	bv.Velocity = Vector3.zero
	bv.Parent = hrp
	flyBV = bv

	-- Gyro suave para inclinacion Superman sin congelar del todo
	local bg = Instance.new("BodyGyro")
	bg.Name = "VXFlyGyro"
	bg.MaxTorque = Vector3.new(4e5, 4e5, 4e5)
	bg.P = 8e3
	bg.D = 800
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp
	flyBG = bg

	flySmoothVel = Vector3.zero
	return true
end

local function toggleFly()
	flyEnabled = not flyEnabled
	if flyEnabled then
		if not startFlyMovers() then
			flyEnabled = false
			setFlyBubbleVisual(false)
			Notify({ Title = "Fly", Content = "Sin personaje.", Duration = 2, Icon = "alert-circle" })
			return
		end
		setFlyBubbleVisual(true)
		Notify({ Title = "Fly", Content = "Superman Fly ON (PC + Movil)", Duration = 2, Icon = "plane" })

		if flyConn then pcall(function() flyConn:Disconnect() end) end
		flyConn = RunService.RenderStepped:Connect(function(dt)
			if not flyEnabled then return end
			dt = math.clamp(dt or 0.016, 0.001, 0.05)
			local char = LocalPlayer.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local cam = workspace.CurrentCamera
			if not hrp or not cam then return end

			if not flyBV or flyBV.Parent ~= hrp or not flyBG or flyBG.Parent ~= hrp then
				startFlyMovers()
				if not flyBV then return end
			end

			if hum then
				pcall(function()
					hum.PlatformStand = false
					hum.AutoRotate = false
				end)
				-- mantener animacion de vuelo
				if not flyAnimTrack or not flyAnimTrack.IsPlaying then
					playFlyAnim(hum)
				end
			end

			local dir = getFlyMoveDir(cam, hum)
			local targetVel
			if dir.Magnitude > 0.08 then
				targetVel = dir.Unit * flySpeed
			else
				-- hover suave (Invincible)
				targetVel = Vector3.new(0, 1.2, 0)
			end

			-- aceleracion suave (no teletransporta)
			local accel = 12
			flySmoothVel = flySmoothVel:Lerp(targetVel, math.clamp(accel * dt, 0, 1))
			flyBV.Velocity = flySmoothVel

			-- Orientacion: hacia donde vuelas + lean Superman
			local lookDir
			if flySmoothVel.Magnitude > 4 then
				lookDir = flySmoothVel.Unit
			else
				lookDir = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
				if lookDir.Magnitude < 0.05 then
					lookDir = hrp.CFrame.LookVector
				end
				lookDir = lookDir.Unit
			end

			local up = Vector3.yAxis
			if math.abs(lookDir:Dot(up)) > 0.92 then
				up = cam.CFrame.RightVector
			end
			local cf = CFrame.lookAt(hrp.Position, hrp.Position + lookDir, up)
			-- inclinacion hacia adelante al acelerar
			local lean = math.clamp(flySmoothVel.Magnitude / math.max(flySpeed, 1), 0, 1)
			cf = cf * CFrame.Angles(math.rad(-18 * lean), 0, 0)
			-- roll suave al strafear
			local side = flySmoothVel:Dot(cam.CFrame.RightVector)
			local roll = math.clamp(side / math.max(flySpeed, 1), -1, 1)
			cf = cf * CFrame.Angles(0, 0, math.rad(-20 * roll))

			flyBG.CFrame = flyBG.CFrame:Lerp(cf, math.clamp(8 * dt, 0, 1))
		end)
	else
		stopFlyMovers()
		setFlyBubbleVisual(false)
		Notify({ Title = "Fly", Content = "Fly OFF", Duration = 2, Icon = "plane" })
	end
end


-- Theme
VXSNotify("Login VortexHub", "Login VortexHub", 2)
task.wait(0.3)

WindUI:AddTheme({
    Name = "VortexGoldSolid",
    Accent = Color3.fromRGB(255, 195, 45),
    Background = Color3.fromRGB(12, 12, 14),
    BackgroundTransparency = 0,
    Outline = Color3.fromRGB(255, 210, 70),
    Text = Color3.fromRGB(255, 255, 255),
    Placeholder = Color3.fromRGB(190, 190, 200),
    Button = Color3.fromRGB(210, 160, 35),
    Icon = Color3.fromRGB(255, 200, 60),
    Hover = Color3.fromRGB(255, 255, 255),
    WindowBackground = Color3.fromRGB(14, 14, 16),
    WindowShadow = Color3.fromRGB(255, 185, 50),
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
    Title = "Vortex X Sage [Survival Disaster]",
    Icon = "rbxassetid://118833096342184",
    IconSize = 35,
    Author = "By Israelcc",
    Folder = "VortexXSage",
    Background = "rbxassetid://133044138027516",
    Size = UDim2.fromOffset(620, 500),
    MinSize = Vector2.new(420, 320),
    MaxSize = Vector2.new(1000, 750),
    Resizable = true,
    HideSearchBar = true,
    Transparent = false,
    Theme = "VortexGoldSolid",
    User = { Enabled = true, Anonymous = false },
})

pcall(function()
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
        OnlyMobile = false,
        Enabled = true,
        Draggable = true,
    })
end)

pcall(function()
    Window:Tag({ Title = "Fling", Icon = "zap", Color = Color3.fromRGB(220, 170, 40) })
end)

Window:SetToggleKey(EmoteFlingConfig.ToggleKey or Enum.KeyCode.K)

local mainSec = Window:Section({ Title = "Main", Opened = true })
local extraSec = Window:Section({ Title = "Extra", Opened = true })

-- ========== TABS ==========
local infoTab = mainSec:Tab({ Title = "Info", Icon = "info", ShowTabTitle = true, Border = true })
local flingTab = mainSec:Tab({ Title = "Fling", Icon = "zap", ShowTabTitle = true, Border = true })
local utilityTab = mainSec:Tab({ Title = "Utility", Icon = "sparkles", ShowTabTitle = true, Border = true })
local survivalTab = mainSec:Tab({ Title = "Survival", Icon = "balloon", ShowTabTitle = true, Border = true })
local bubblesTab = mainSec:Tab({ Title = "Bubbles", Icon = "circle-dot", ShowTabTitle = true, Border = true })
local protectTab = mainSec:Tab({ Title = "Protection", Icon = "shield", ShowTabTitle = true, Border = true })
local animTab = extraSec:Tab({ Title = "Animaciones", Icon = "person-standing", ShowTabTitle = true, Border = true })
local configTab = extraSec:Tab({ Title = "Config", Icon = "settings", ShowTabTitle = true, Border = true })

infoTab:Select()

-- FPS / Ping monitor state
local showFpsPing = false
local fpsScreenGui = nil
local fpsPingLabel = nil
local fpsFrames, fpsLast, fpsValue = 0, tick(), 0
RunService.RenderStepped:Connect(function()
	fpsFrames = fpsFrames + 1
	local now = tick()
	if now - fpsLast >= 1 then
		fpsValue = fpsFrames
		fpsFrames = 0
		fpsLast = now
	end
	if showFpsPing and fpsPingLabel then
		local ping = 0
		pcall(function()
			ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
		end)
		fpsPingLabel.Text = "FPS: " .. tostring(fpsValue) .. "\nPing: " .. tostring(ping) .. " ms"
	end
end)

-- Fling UI
flingTab:Section({ Title = "Settings" })
flingTab:Toggle({
    Title = "Enable Emote Fling",
    Desc = "Arma el fling para poder ejecutarlo.",
    Value = EmoteFlingConfig.Armed,
    Callback = function(state)
        EmoteFlingConfig.Armed = state
        if not state and EmoteFlingConfig.Active then EmoteFlingConfig.Active = false end
        SaveConfig()
    end,
})

flingTab:Dropdown({
    Title = "Preset Animations",
    Desc = "Elige un emote predefinido para el fling.",
    Values = PresetNames,
    Value = GetPresetNameFromId(EmoteFlingConfig.AnimId),
    Callback = function(selected)
        if EmoteFlingConfig.UseCustomId then return end
        EmoteFlingConfig.AnimId = PresetAnimations[selected] or "133566007754001"
        SaveConfig()
    end,
})

flingTab:Toggle({
    Title = "Use Custom Animation ID",
    Desc = "Usa un ID de animacion personalizado.",
    Value = EmoteFlingConfig.UseCustomId,
    Callback = function(state)
        EmoteFlingConfig.UseCustomId = state
        if state then
            EmoteFlingConfig.AnimId = EmoteFlingConfig.CustomId or ""
        else
            EmoteFlingConfig.AnimId = PresetAnimations["Dropkick"] or "133566007754001"
        end
        SaveConfig()
    end,
})

flingTab:Input({
    Title = "Animation ID",
    Desc = "ID de asset de Roblox (Animation/Emote).",
    Value = EmoteFlingConfig.CustomId,
    Placeholder = "Enter Asset ID...",
    Callback = function(text)
        EmoteFlingConfig.CustomId = text
        if EmoteFlingConfig.UseCustomId then EmoteFlingConfig.AnimId = text end
        SaveConfig()
    end,
})

flingTab:Slider({
    Title = "Walk Speed",
    Desc = "Velocidad al flingear (movimiento controlado).",
    Step = 1,
    Value = { Min = 16, Max = 200, Default = EmoteFlingConfig.Speed },
    Callback = function(val)
        EmoteFlingConfig.Speed = val
        SaveConfig()
    end,
})

flingTab:Button({
    Title = "Execute / Stop Fling",
    Desc = "Inicia o detiene el emote fling.",
    Callback = function() FireEmoteFling() end,
})

flingTab:Keybind({
    Title = "Fling Keybind",
    Desc = "Tecla para ejecutar/parar el fling.",
    Key = (EmoteFlingConfig.QuickFireKey and EmoteFlingConfig.QuickFireKey.Name) or "T",
    Callback = function()
        FireEmoteFling()
    end,
})

flingTab:Toggle({
    Title = "Enable Notifications",
    Desc = "Muestra notificaciones de WindUI.",
    Value = EmoteFlingConfig.NotificationsEnabled,
    Callback = function(state)
        EmoteFlingConfig.NotificationsEnabled = state
        SaveConfig()
    end,
})

RegisterConnection("FlingInputConn", UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Unknown then return end
    if EmoteFlingConfig.QuickFireKey and input.KeyCode == EmoteFlingConfig.QuickFireKey then
        FireEmoteFling()
    end
end))

-- ========== BUBBLES (Vortex FAB style) ==========
local FAB_GOLD = Color3.fromRGB(255, 200, 55)
local FAB_GLASS = Color3.fromRGB(8, 12, 20)
local FAB_GLASS_T = 0.35

local _VortexIcons, _VortexIconReady = nil, false
local _VortexIconQueue = {}
task.spawn(function()
    local ok, res = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/icons.lua"))()
    end)
    if ok and type(res) == "table" then
        _VortexIcons = res
        _VortexIconReady = true
        for _, q in ipairs(_VortexIconQueue) do
            pcall(function()
                local entry = _VortexIcons["48px"] and _VortexIcons["48px"][q.name]
                if entry and q.img and q.img.Parent then
                    q.img.Image = "rbxassetid://" .. tostring(entry[1])
                    q.img.ImageRectSize = Vector2.new(entry[2][1], entry[2][2])
                    q.img.ImageRectOffset = Vector2.new(entry[3][1], entry[3][2])
                end
            end)
        end
        table.clear(_VortexIconQueue)
    end
end)

local function applyLucideIcon(img, iconName)
    if not img then return end
    iconName = tostring(iconName or "zap")
    local atlas = _VortexIcons and _VortexIcons["48px"]
    if _VortexIconReady and atlas and atlas[iconName] then
        local entry = atlas[iconName]
        img.Image = "rbxassetid://" .. tostring(entry[1])
        img.ImageRectSize = Vector2.new(entry[2][1], entry[2][2])
        img.ImageRectOffset = Vector2.new(entry[3][1], entry[3][2])
    else
        table.insert(_VortexIconQueue, { img = img, name = iconName })
    end
end

local function makeDraggable(trigger, target, canDragFn)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if canDragFn and not canDragFn() then return end
            dragging = true
            dragStart = input.Position
            startPos = target.Position
        end
    end)
    trigger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            if canDragFn and not canDragFn() then dragging = false return end
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    trigger.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local bubblesScreenGui = Instance.new("ScreenGui")
bubblesScreenGui.Name = "VXEmoteBubbles"
bubblesScreenGui.ResetOnSpawn = false
bubblesScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
bubblesScreenGui.IgnoreGuiInset = true
pcall(function()
    if gethui then bubblesScreenGui.Parent = gethui()
    else bubblesScreenGui.Parent = CoreGui end
end)
if not bubblesScreenGui.Parent then
    pcall(function() bubblesScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
end

local bubblesContainer = Instance.new("Frame")
bubblesContainer.Size = UDim2.fromScale(1, 1)
bubblesContainer.BackgroundTransparency = 1
bubblesContainer.Parent = bubblesScreenGui

local allBubbleFabs = {}
local bubbleHits = {} -- name -> TextButton
local bubbleVis = {} -- name -> bool desired

local PRESET_ICONS = {
    ["Dropkick"] = "zap",
    ["Dropkicking [TRENDY]"] = "flame",
    ["Tenna Kick"] = "footprints",
    ["MMA Kick"] = "swords",
    ["Slap"] = "hand",
    ["Slap2"] = "hand-metal",
    ["Push"] = "move",
    ["Push2"] = "chevrons-up",
    ["Custom"] = "pencil",
}

local function createVaporStyleFab(parent, cfg)
    cfg = cfg or {}
    local BTN_SZ = math.floor(tonumber(cfg.Size) or bubbleSize)
    local ICO_SZ = math.floor(BTN_SZ * 0.42)
    local Fab = Instance.new("Frame")
    Fab.Name = cfg.Name or "Fab"
    Fab.Size = UDim2.fromOffset(BTN_SZ, BTN_SZ)
    Fab.Position = cfg.Position or UDim2.new(1, -10, 0.5, 0)
    Fab.AnchorPoint = cfg.AnchorPoint or Vector2.new(1, 0.5)
    Fab.BackgroundColor3 = FAB_GLASS
    Fab.BackgroundTransparency = FAB_GLASS_T
    Fab.BorderSizePixel = 0
    Fab.Visible = false
    Fab.ZIndex = 100
    Fab.Parent = parent
    Instance.new("UICorner", Fab).CornerRadius = UDim.new(0, 10)

    local fabStroke = Instance.new("UIStroke")
    fabStroke.Name = "Stroke"
    fabStroke.Color = FAB_GOLD
    fabStroke.Thickness = 1.5
    fabStroke.Transparency = 0.45
    fabStroke.Parent = Fab

    local FabGlow = Instance.new("Frame")
    FabGlow.Name = "Glow"
    FabGlow.Size = UDim2.fromScale(1, 1)
    FabGlow.BackgroundColor3 = FAB_GOLD
    FabGlow.BackgroundTransparency = 0.92
    FabGlow.BorderSizePixel = 0
    FabGlow.ZIndex = Fab.ZIndex
    FabGlow.Parent = Fab
    Instance.new("UICorner", FabGlow).CornerRadius = UDim.new(0, 10)

    local fabIco = Instance.new("ImageLabel")
    fabIco.Name = "Icon"
    fabIco.BackgroundTransparency = 1
    fabIco.AnchorPoint = Vector2.new(0.5, 0.5)
    fabIco.Position = UDim2.fromScale(0.5, 0.5)
    fabIco.Size = UDim2.fromOffset(ICO_SZ, ICO_SZ)
    fabIco.ImageColor3 = FAB_GOLD
    fabIco.ZIndex = Fab.ZIndex + 2
    fabIco.Parent = Fab
    applyLucideIcon(fabIco, cfg.Icon or "zap")

    local FabBtn = Instance.new("TextButton")
    FabBtn.Name = "Hit"
    FabBtn.Size = UDim2.fromScale(1, 1)
    FabBtn.BackgroundTransparency = 1
    FabBtn.Text = ""
    FabBtn.ZIndex = Fab.ZIndex + 3
    FabBtn.Parent = Fab

    FabBtn.MouseEnter:Connect(function()
        TweenService:Create(Fab, TweenInfo.new(0.15), { BackgroundTransparency = 0.18 }):Play()
        TweenService:Create(fabStroke, TweenInfo.new(0.15), { Transparency = 0.2 }):Play()
    end)
    FabBtn.MouseLeave:Connect(function()
        TweenService:Create(Fab, TweenInfo.new(0.15), { BackgroundTransparency = FAB_GLASS_T }):Play()
        TweenService:Create(fabStroke, TweenInfo.new(0.15), { Transparency = 0.45 }):Play()
    end)

    return Fab, FabBtn
end

local function applyBubbleSize(sz)
    bubbleSize = math.clamp(math.floor(sz), 28, 64)
    for _, fab in ipairs(allBubbleFabs) do
        if fab and fab.Parent then
            fab.Size = UDim2.fromOffset(bubbleSize, bubbleSize)
            local ic = fab:FindFirstChild("Icon")
            if ic then
                local ico = math.floor(bubbleSize * 0.42)
                ic.Size = UDim2.fromOffset(ico, ico)
            end
        end
    end
    SaveConfig()
end

local function createBubble(name, iconName, rowY, posX)
    local Fab, FabBtn = createVaporStyleFab(bubblesContainer, {
        Name = name,
        Icon = iconName,
        Size = bubbleSize,
        Position = UDim2.new(1, posX or -10, 0.5, rowY or 0),
        AnchorPoint = Vector2.new(1, 0.5),
    })
    makeDraggable(FabBtn, Fab, function() return editBubblesState == true end)
    table.insert(allBubbleFabs, Fab)
    bubbleHits[name] = FabBtn
    bubbleVis[name] = false
    return Fab, FabBtn
end



-- ==========================================
-- AURA DE ITEMS (logica exacta Super Ring Parts)
-- ==========================================
local auraEnabled = false
local auraRadius = 50
local auraHeight = 100
local auraRotSpeed = 10
local auraAttraction = 1000
local auraParts = {}
-- Aplicar config guardada (listas/sliders/toggles de aura/fly)
pcall(function()
    if type(LoadedCFG) == "table" then
        if LoadedCFG.auraEnabled ~= nil then auraEnabled = LoadedCFG.auraEnabled == true end
        if LoadedCFG.auraRadius ~= nil then auraRadius = tonumber(LoadedCFG.auraRadius) or auraRadius end
        if LoadedCFG.auraAttraction ~= nil then auraAttraction = tonumber(LoadedCFG.auraAttraction) or auraAttraction end
        if LoadedCFG.flyEnabled ~= nil then flyEnabled = LoadedCFG.flyEnabled == true end
        if LoadedCFG.flySpeed ~= nil then flySpeed = tonumber(LoadedCFG.flySpeed) or flySpeed end
        if LoadedCFG.BubbleSize ~= nil then bubbleSize = math.clamp(tonumber(LoadedCFG.BubbleSize) or bubbleSize, 28, 64) end
    end
end)
pcall(function()
    SharedOpts.auraEnabled = auraEnabled
    SharedOpts.auraRadius = auraRadius
    SharedOpts.auraAttraction = auraAttraction
    SharedOpts.flyEnabled = flyEnabled
    SharedOpts.flySpeed = flySpeed
    SharedOpts.bubbleSize = bubbleSize
end)
local auraMenu = nil
local auraMenuVisible = false
local auraBubbleFab = nil
local auraToggleBtn = nil
local auraTitleLabel = nil

-- Network exactamente como el script original
if not getgenv().Network then
	getgenv().Network = {
		BaseParts = {},
		Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424),
	}
	getgenv().Network.RetainPart = function(Part)
		if typeof(Part) == "Instance" and Part:IsA("BasePart") and Part:IsDescendantOf(workspace) then
			table.insert(getgenv().Network.BaseParts, Part)
			Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
			Part.CanCollide = false
		end
	end
	local function EnablePartControl()
		LocalPlayer.ReplicationFocus = workspace
		RunService.Heartbeat:Connect(function()
			pcall(function()
				if sethiddenproperty then
					sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
				end
			end)
			for _, Part in pairs(getgenv().Network.BaseParts) do
				if Part:IsDescendantOf(workspace) then
					Part.Velocity = getgenv().Network.Velocity
				end
			end
		end)
	end
	EnablePartControl()
end

local function AuraRetainPart(Part)
	if Part:IsA("BasePart") and not Part.Anchored and Part:IsDescendantOf(workspace) then
		if Part.Parent == LocalPlayer.Character or Part:IsDescendantOf(LocalPlayer.Character) then
			return false
		end
		Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
		Part.CanCollide = false
		return true
	end
	return false
end

local function auraAddPart(part)
	if AuraRetainPart(part) then
		if not table.find(auraParts, part) then
			table.insert(auraParts, part)
		end
	end
end

local function auraRemovePart(part)
	local index = table.find(auraParts, part)
	if index then
		table.remove(auraParts, index)
	end
end

for _, part in pairs(workspace:GetDescendants()) do
	auraAddPart(part)
end
workspace.DescendantAdded:Connect(auraAddPart)
workspace.DescendantRemoving:Connect(auraRemovePart)

-- Heartbeat: partes orbitan alrededor del jugador (logica original)
RunService.Heartbeat:Connect(function()
	if not auraEnabled then return end

	local humanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if humanoidRootPart then
		local tornadoCenter = humanoidRootPart.Position
		local radius = auraRadius
		local height = auraHeight
		local rotationSpeed = auraRotSpeed
		local attractionStrength = auraAttraction
		for _, part in pairs(auraParts) do
			if part.Parent and not part.Anchored then
				local pos = part.Position
				local distance = (Vector3.new(pos.X, tornadoCenter.Y, pos.Z) - tornadoCenter).Magnitude
				local angle = math.atan2(pos.Z - tornadoCenter.Z, pos.X - tornadoCenter.X)
				local newAngle = angle + math.rad(rotationSpeed)
				local targetPos = Vector3.new(
					tornadoCenter.X + math.cos(newAngle) * math.min(radius, distance),
					tornadoCenter.Y + (height * (math.abs(math.sin((pos.Y - tornadoCenter.Y) / height)))),
					tornadoCenter.Z + math.sin(newAngle) * math.min(radius, distance)
				)
				local directionToTarget = (targetPos - part.Position).Unit
				part.Velocity = directionToTarget * attractionStrength
			end
		end
	end
end)

local function setAuraBubbleVisual()
	pcall(function()
		local st = auraBubbleFab and auraBubbleFab:FindFirstChild("Stroke")
		local ic = auraBubbleFab and auraBubbleFab:FindFirstChild("Icon")
		if auraEnabled then
			if st then st.Color = Color3.fromRGB(120, 180, 255); st.Transparency = 0.15 end
			if ic then ic.ImageColor3 = Color3.fromRGB(120, 180, 255) end
		else
			if st then st.Color = Color3.fromRGB(255, 200, 55); st.Transparency = 0.45 end
			if ic then ic.ImageColor3 = Color3.fromRGB(255, 200, 55) end
		end
	end)
	if auraToggleBtn then
		if auraEnabled then
			auraToggleBtn.Text = "Aura: ON"
			auraToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 180)
		else
			auraToggleBtn.Text = "Aura: OFF"
			auraToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
		end
	end
	if auraTitleLabel then
		auraTitleLabel.Text = "Aura de Items  [" .. tostring(auraRadius) .. "]"
	end
end

local function buildAuraMenu()
	if auraMenu and auraMenu.Parent then return end
	local gui = bubblesScreenGui
	if not gui then return end

	local menu = Instance.new("Frame")
	menu.Name = "AuraItemsMenu"
	menu.Size = UDim2.fromOffset(158, 138)
	menu.AnchorPoint = Vector2.new(1, 0.5)
	menu.Position = UDim2.new(1, -72, 0.5, 160)
	menu.BackgroundColor3 = Color3.fromRGB(8, 12, 20)
	menu.BackgroundTransparency = 0.28
	menu.BorderSizePixel = 0
	menu.Visible = false
	menu.ZIndex = 130
	menu.Parent = gui
	Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 200, 55)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.4
	stroke.Parent = menu

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, -10, 0, 20)
	title.Position = UDim2.fromOffset(6, 6)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 12
	title.TextColor3 = Color3.fromRGB(255, 220, 90)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Text = "Aura de Items  [50]"
	title.ZIndex = 131
	title.Parent = menu
	auraTitleLabel = title

	local function mkBtn(text, y, bg)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, -14, 0, 26)
		b.Position = UDim2.fromOffset(7, y)
		b.BackgroundColor3 = bg
		b.BackgroundTransparency = 0.2
		b.Text = text
		b.Font = Enum.Font.GothamBold
		b.TextSize = 12
		b.TextColor3 = Color3.fromRGB(255, 255, 255)
		b.ZIndex = 132
		b.Parent = menu
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
		local bs = Instance.new("UIStroke")
		bs.Color = Color3.fromRGB(255, 200, 55)
		bs.Thickness = 1
		bs.Transparency = 0.55
		bs.Parent = b
		return b
	end

	auraToggleBtn = mkBtn("Aura: OFF", 30, Color3.fromRGB(40, 45, 55))
	local decBtn = mkBtn("Radius  -", 62, Color3.fromRGB(35, 40, 50))
	local incBtn = mkBtn("Radius  +", 94, Color3.fromRGB(35, 40, 50))

	auraToggleBtn.MouseButton1Click:Connect(function()
		auraEnabled = not auraEnabled
		setAuraBubbleVisual()
		Notify({
			Title = "Aura de Items",
			Content = auraEnabled and "ON - objetos orbitan a tu alrededor" or "OFF",
			Duration = 2,
			Icon = "sparkles",
		})
	end)

	decBtn.MouseButton1Click:Connect(function()
		auraRadius = math.max(10, auraRadius - 5)
		setAuraBubbleVisual()
	end)
	incBtn.MouseButton1Click:Connect(function()
		auraRadius = math.min(100, auraRadius + 5)
		setAuraBubbleVisual()
	end)

	makeDraggable(menu, menu, function() return true end)
	auraMenu = menu
end

local function openAuraMenu()
	buildAuraMenu()
	if not auraMenu then return end
	if auraBubbleFab and auraBubbleFab.Parent then
		local pos = auraBubbleFab.AbsolutePosition
		local sz = auraBubbleFab.AbsoluteSize
		auraMenu.Position = UDim2.fromOffset(pos.X - 10, pos.Y + sz.Y / 2)
		auraMenu.AnchorPoint = Vector2.new(1, 0.5)
	end
	auraMenuVisible = not auraMenuVisible
	auraMenu.Visible = auraMenuVisible
	setAuraBubbleVisual()
end

-- ========== FLY MINI MENU ==========
local flyMenu = nil
local flyMenuVisible = false
local flyToggleBtn = nil
local flyTitleLabel = nil

local function setFlyMenuVisual()
	if flyTitleLabel then
		flyTitleLabel.Text = "Fly  [" .. tostring(math.floor(flySpeed or 90)) .. "]"
	end
	if flyToggleBtn then
		if flyEnabled then
			flyToggleBtn.Text = "Fly: ON"
			flyToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 180)
		else
			flyToggleBtn.Text = "Fly: OFF"
			flyToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
		end
	end
	pcall(function() setFlyBubbleVisual(flyEnabled) end)
end

local function buildFlyMenu()
	if flyMenu and flyMenu.Parent then return end
	local gui = bubblesScreenGui
	if not gui then return end
	local menu = Instance.new("Frame")
	menu.Name = "FlyMiniMenu"
	menu.Size = UDim2.fromOffset(158, 138)
	menu.AnchorPoint = Vector2.new(1, 0.5)
	menu.Position = UDim2.new(1, -72, 0.5, 0)
	menu.BackgroundColor3 = Color3.fromRGB(8, 12, 20)
	menu.BackgroundTransparency = 0.28
	menu.BorderSizePixel = 0
	menu.Visible = false
	menu.ZIndex = 130
	menu.Parent = gui
	Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(120, 200, 255)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.4
	stroke.Parent = menu
	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, -10, 0, 20)
	title.Position = UDim2.fromOffset(6, 6)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 12
	title.TextColor3 = Color3.fromRGB(140, 210, 255)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Text = "Fly  [90]"
	title.ZIndex = 131
	title.Parent = menu
	flyTitleLabel = title
	local function mkBtn(text, y, bg)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, -14, 0, 26)
		b.Position = UDim2.fromOffset(7, y)
		b.BackgroundColor3 = bg
		b.BackgroundTransparency = 0.2
		b.Text = text
		b.Font = Enum.Font.GothamBold
		b.TextSize = 12
		b.TextColor3 = Color3.fromRGB(255, 255, 255)
		b.ZIndex = 132
		b.Parent = menu
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
		local bs = Instance.new("UIStroke")
		bs.Color = Color3.fromRGB(120, 200, 255)
		bs.Thickness = 1
		bs.Transparency = 0.55
		bs.Parent = b
		return b
	end
	flyToggleBtn = mkBtn("Fly: OFF", 30, Color3.fromRGB(40, 45, 55))
	local decB = mkBtn("Speed  -", 62, Color3.fromRGB(35, 40, 50))
	local incB = mkBtn("Speed  +", 94, Color3.fromRGB(35, 40, 50))
	flyToggleBtn.MouseButton1Click:Connect(function()
		toggleFly()
		setFlyMenuVisual()
	end)
	decB.MouseButton1Click:Connect(function()
		flySpeed = math.max(30, (flySpeed or 90) - 10)
		setFlyMenuVisual()
	end)
	incB.MouseButton1Click:Connect(function()
		flySpeed = math.min(250, (flySpeed or 90) + 10)
		setFlyMenuVisual()
	end)
	if makeDraggable then
		makeDraggable(menu, menu, function() return true end)
	end
	flyMenu = menu
end

local function openFlyMenu()
	if not bubblesScreenGui then return end
	buildFlyMenu()
	if not flyMenu then return end
	if flyBubbleFab and flyBubbleFab.Parent then
		local pos = flyBubbleFab.AbsolutePosition
		local sz = flyBubbleFab.AbsoluteSize
		flyMenu.Position = UDim2.fromOffset(pos.X - 10, pos.Y + sz.Y / 2)
		flyMenu.AnchorPoint = Vector2.new(1, 0.5)
	end
	flyMenuVisible = not flyMenuVisible
	flyMenu.Visible = flyMenuVisible
	setFlyMenuVisual()
end

-- Layout: 2 columns mid-right (presets + custom)
local BX_OUT, BX_IN, BGAP = -10, -58, 46
local bubbleFabsByPreset = {}

for i, presetName in ipairs(PresetNames) do
    local col = (i <= 5) and BX_OUT or BX_IN
    local idx = (i <= 5) and (i - 1) or (i - 6)
    local rowY = (idx - 2) * BGAP
    local icon = PRESET_ICONS[presetName] or "zap"
    local fab, hit = createBubble("Bubble_" .. presetName, icon, rowY, col)
    bubbleFabsByPreset[presetName] = fab
    hit.MouseButton1Click:Connect(function()
        if editBubblesState then return end
        local id = PresetAnimations[presetName]
        if id then fireWithSpecificId(id) end
    end)
end

local customFab, customHit = createBubble("Bubble_Custom", "pencil", 2 * BGAP, BX_IN)
customHit.MouseButton1Click:Connect(function()
    if editBubblesState then return end
    local customId = EmoteFlingConfig.CustomId
    if not customId or customId == "" or customId:match("^%s*$") then
        Notify({ Title = "Emote Fling", Content = "Custom Animation ID no configurado.", Duration = 3, Icon = "alert-circle" })
        return
    end
    fireWithSpecificId(customId)
end)

local flyFab, flyHit = createBubble("Bubble_Fly", "plane", 3 * BGAP, BX_OUT)
flyBubbleFab = flyFab
flyHit.MouseButton1Click:Connect(function()
    if editBubblesState then return end
    openFlyMenu()
end)

local auraFab, auraHit = createBubble("Bubble_Aura", "sparkles", 3 * BGAP, BX_IN)
auraBubbleFab = auraFab
auraHit.MouseButton1Click:Connect(function()
    if editBubblesState then return end
    openAuraMenu()
end)

bubblesTab:Paragraph({
    Title = "Floating Bubbles",
    Desc = "Activa cada bubble para mostrarla. Solo se mueven con Edit Bubble activo. Tamaño con el slider.",
})

bubblesTab:Toggle({
    Title = "Edit Bubble Positions",
    Desc = "Desbloquea las bubbles para arrastrarlas. Con esto OFF no se mueven.",
    Value = false,
    Callback = function(state)
        editBubblesState = state
        showBottomMessage(state and "Edit Bubble: ON" or "Edit Bubble: OFF")
    end,
})

bubblesTab:Slider({
    Title = "Tamano de Bubbles",
    Desc = "Agrandar o hacer mas pequenas las bubbles (cuadradas).",
    Step = 1,
    Value = { Min = 28, Max = 64, Default = bubbleSize },
    Callback = function(v) applyBubbleSize(v) end,
})

bubblesTab:Divider()
bubblesTab:Paragraph({ Title = "Mostrar / Ocultar", Desc = "Cada bubble se activa por separado." })

for _, presetName in ipairs(PresetNames) do
    bubblesTab:Toggle({
        Title = "Show: " .. presetName,
        Desc = "Muestra u oculta la bubble de " .. presetName .. ".",
        Value = false,
        Callback = function(val)
            local fab = bubbleFabsByPreset[presetName]
            if fab then fab.Visible = val end
            bubbleVis[presetName] = val
        end,
    })
end

bubblesTab:Toggle({
    Title = "Show: Custom animID",
    Desc = "Bubble para el ID personalizado.",
    Value = false,
    Callback = function(val)
        customFab.Visible = val
        bubbleVis["Custom"] = val
    end,
})

bubblesTab:Toggle({
    Title = "Show: Fly (Superman)",
    Desc = "Bubble para vuelo estilo Superman / Invincible.",
    Value = false,
    Callback = function(val)
        if flyBubbleFab then flyBubbleFab.Visible = val end
        bubbleVis["Fly"] = val
    end,
})

bubblesTab:Toggle({
    Title = "Show: Aura de Items",
    Desc = "Menu Aura de Items (radius + ON/OFF, logica completa).",
    Value = false,
    Callback = function(val)
        if auraBubbleFab then auraBubbleFab.Visible = val end
        bubbleVis["Aura"] = val
        if not val and auraMenu then
            auraMenu.Visible = false
            auraMenuVisible = false
        end
    end,
})



-- ========== UTILITY (Fly + Aura) ==========
utilityTab:Section({ Title = "Fly (Superman)" })
utilityTab:Paragraph({
    Title = "Vuelo",
    Desc = "Activa el fly desde aqui o con la bubble (mini menu ON/OFF + Speed).",
})
utilityTab:Toggle({
    Title = "Fly Enabled",
    Desc = "Activa/desactiva el vuelo estilo Superman (PC + movil).",
    Value = false,
    Callback = function(state)
        if state ~= flyEnabled then
            toggleFly()
            pcall(function() if setFlyMenuVisual then setFlyMenuVisual() end end)
        end
    end,
})
utilityTab:Slider({
    Title = "Fly Speed",
    Desc = "Velocidad del vuelo (tambien en el mini menu de la bubble).",
    Step = 5,
    Value = { Min = 30, Max = 250, Default = 90 },
    Callback = function(v)
        flySpeed = v
        pcall(function() if setFlyMenuVisual then setFlyMenuVisual() end end)
    end,
})

utilityTab:Section({ Title = "Aura de Items" })
utilityTab:Paragraph({
    Title = "Orbita",
    Desc = "Hace girar partes no ancladas a tu alrededor. Usa la bubble o estos controles.",
})
utilityTab:Toggle({
    Title = "Aura Enabled",
    Desc = "Activa/desactiva el aura de items.",
    Value = false,
    Callback = function(state)
        if state ~= auraEnabled then
            auraEnabled = state; SharedOpts.auraEnabled = state; pcall(SaveConfig)
            setAuraBubbleVisual()
            Notify({ Title = "Aura de Items", Content = state and "ON" or "OFF", Duration = 2, Icon = "sparkles" })
        end
    end,
})
utilityTab:Slider({
    Title = "Aura Radius",
    Desc = "Radio de la orbita de items.",
    Step = 5,
    Value = { Min = 10, Max = 100, Default = 50 },
    Callback = function(v)
        auraRadius = v
        setAuraBubbleVisual()
    end,
})

-- ========== SURVIVAL ==========
survivalTab:Section({ Title = "Natural Disaster Survival" })
survivalTab:Paragraph({
    Title = "Items",
    Desc = "Herramientas utiles para Survival / NDS.",
})
survivalTab:Button({
    Title = "Get Green Balloon",
    Desc = "Clona el Green Balloon del mapa a tu mochila si existe.",
    Callback = function()
        local found = workspace:FindFirstChild("GreenBalloon", true)
        if found then
            local ok, err = pcall(function()
                local clone = found:Clone()
                clone.Parent = LocalPlayer.Backpack
            end)
            if ok then
                Notify({ Title = "Survival", Content = "Green Balloon robado!", Duration = 3, Icon = "balloon" })
            else
                Notify({ Title = "Survival", Content = "Error al clonar: " .. tostring(err), Duration = 3, Icon = "x-circle" })
            end
        else
            Notify({ Title = "Survival", Content = "No hay Green Balloon en el mapa.", Duration = 3, Icon = "alert-circle" })
        end
    end,
})

-- ========== PROTECTION ==========
protectTab:Section({ Title = "Godmode & Anti-Fall" })

local function HookAntiFall(char)
    task.spawn(function()
        local r = char:WaitForChild("HumanoidRootPart", 10)
        if r and EmoteFlingConfig.antiFallEnabled then
            DisconnectConnection("antiFallLoopConn")
            local conn = RunService.Heartbeat:Connect(function()
                if not EmoteFlingConfig.antiFallEnabled or not r.Parent then
                    DisconnectConnection("antiFallLoopConn")
                    return
                end
                local v = r.AssemblyLinearVelocity
                r.AssemblyLinearVelocity = Vector3.zero
                RunService.RenderStepped:Wait()
                r.AssemblyLinearVelocity = v
            end)
            RegisterConnection("antiFallLoopConn", conn)
        end
    end)
end

local function OnAntiFallToggle(Value, isInitialization)
    EmoteFlingConfig.antiFallEnabled = Value
    if EmoteFlingConfig.antiFallEnabled then
        if game.PlaceId ~= 189707 then
            if not isInitialization then
                Notify({ Title = "Error", Content = "Anti-Fall solo en Natural Disasters!", Duration = 5, Icon = "circle-x" })
            end
            EmoteFlingConfig.antiFallEnabled = false
            SaveConfig()
            return
        end
        if LocalPlayer.Character then HookAntiFall(LocalPlayer.Character) end
        DisconnectConnection("antiFallRespawnConn")
        RegisterConnection("antiFallRespawnConn", LocalPlayer.CharacterAdded:Connect(function(char)
            if EmoteFlingConfig.antiFallEnabled then HookAntiFall(char) end
        end))
        if not isInitialization then
            Notify({ Title = "Anti-Fall", Content = "Enabled (NDS)", Duration = 3, Icon = "shield" })
        end
    else
        DisconnectConnection("antiFallLoopConn")
        DisconnectConnection("antiFallRespawnConn")
        if not isInitialization then
            Notify({ Title = "Anti-Fall", Content = "Disabled", Duration = 3, Icon = "shield-off" })
        end
    end
    SaveConfig()
end

protectTab:Toggle({
    Title = "Anti-Fall Damage",
    Desc = "Solo Natural Disaster Survival (PlaceId 189707).",
    Value = EmoteFlingConfig.antiFallEnabled,
    Callback = function(Value) OnAntiFallToggle(Value, not UI_Loaded) end,
})

local function RestoreGodProperties(char)
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")
    if hum then
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        end)
    end
end

local function ApplyGodProperties(char)
    task.spawn(function()
        local hum = char:WaitForChild("Humanoid", 10)
        if hum and EmoteFlingConfig.godEnabled then
            pcall(function()
                hum.MaxHealth = 100
                hum.Health = 100
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end)
        end
    end)
end

local function OnGodToggle(Value, isInitialization)
    EmoteFlingConfig.godEnabled = Value
    if EmoteFlingConfig.godEnabled then
        DisconnectConnection("godLoopConn")
        RegisterConnection("godLoopConn", RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and EmoteFlingConfig.godEnabled then
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                if hum then hum.Health = 100 end
            end
        end))
        if LocalPlayer.Character then ApplyGodProperties(LocalPlayer.Character) end
        DisconnectConnection("godRespawnConn")
        RegisterConnection("godRespawnConn", LocalPlayer.CharacterAdded:Connect(function(char)
            if EmoteFlingConfig.godEnabled then ApplyGodProperties(char) end
        end))
        if not isInitialization then
            Notify({ Title = "Godmode", Content = "ON", Duration = 3, Icon = "heart-pulse" })
        end
    else
        DisconnectConnection("godLoopConn")
        DisconnectConnection("godRespawnConn")
        if LocalPlayer.Character then RestoreGodProperties(LocalPlayer.Character) end
        if not isInitialization then
            Notify({ Title = "Godmode", Content = "OFF", Duration = 3, Icon = "heart-crack" })
        end
    end
    SaveConfig()
end

protectTab:Toggle({
    Title = "Godmode (Anti-Instakill)",
    Desc = "Mantiene vida y bloquea estados de muerte.",
    Value = EmoteFlingConfig.godEnabled,
    Callback = function(Value) OnGodToggle(Value, not UI_Loaded) end,
})

protectTab:Section({ Title = "Anti-Fling" })

local lastSafeCFrameFling = nil
local lastNotifyTimeFling = 0
local isRecoveringFling = false

local function OnAntiFlingToggle(Value, isInitialization)
    EmoteFlingConfig.antiFlingEnabled = Value
    if EmoteFlingConfig.antiFlingEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            lastSafeCFrameFling = char.HumanoidRootPart.CFrame
        end
        DisconnectConnection("antiFlingLoopConn")
        RegisterConnection("antiFlingLoopConn", RunService.Stepped:Connect(function()
            if not EmoteFlingConfig.antiFlingEnabled then return end
            char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChild("Humanoid")
            if hrp and humanoid and humanoid.Health > 0 then
                local velocity = hrp.AssemblyLinearVelocity
                local rotVelocity = hrp.AssemblyAngularVelocity
                local mag = velocity.Magnitude
                local rotMag = rotVelocity.Magnitude
                if not lastSafeCFrameFling then lastSafeCFrameFling = hrp.CFrame end
                local isControlledMotion = rotMag < 60
                local currentState = humanoid:GetState()
                local isFalling = velocity.Y < -50 and (currentState == Enum.HumanoidStateType.Freefall or currentState == Enum.HumanoidStateType.FallingDown)
                local maxLinear = EmoteFlingConfig.Active and 250 or 150
                local maxVerticalUp = 250
                local maxVerticalDown = -350
                if isControlledMotion then
                    maxLinear = 1000
                    maxVerticalUp = 800
                    maxVerticalDown = isFalling and -5000 or -800
                end
                local isFlinged = rotMag > 120 or velocity.Y > maxVerticalUp or velocity.Y < maxVerticalDown or mag > maxLinear
                if isFlinged then
                    isRecoveringFling = true
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    if lastSafeCFrameFling then hrp.CFrame = lastSafeCFrameFling end
                    if currentState == Enum.HumanoidStateType.Physics or currentState == Enum.HumanoidStateType.Ragdoll or currentState == Enum.HumanoidStateType.FallingDown then
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        humanoid.PlatformStand = false
                        humanoid.Sit = false
                    end
                    if tick() - lastNotifyTimeFling > 2.0 then
                        Notify({ Title = "Anti-Fling", Content = "Anomalia cinética suprimida.", Duration = 1.5, Icon = "shield" })
                        lastNotifyTimeFling = tick()
                    end
                else
                    local distance = (hrp.Position - lastSafeCFrameFling.Position).Magnitude
                    if distance > 50 and mag < 100 and not isRecoveringFling then
                        lastSafeCFrameFling = hrp.CFrame
                    end
                    if isControlledMotion and mag < 900 then
                        lastSafeCFrameFling = hrp.CFrame
                        isRecoveringFling = false
                    end
                end
            end
        end))
        if not isInitialization then
            Notify({ Title = "Anti-Fling", Content = "ON", Duration = 2.5, Icon = "check-circle" })
        end
    else
        DisconnectConnection("antiFlingLoopConn")
        lastSafeCFrameFling = nil
        isRecoveringFling = false
        if not isInitialization then
            Notify({ Title = "Anti-Fling", Content = "OFF", Duration = 2.5, Icon = "x-circle" })
        end
    end
    SaveConfig()
end

protectTab:Toggle({
    Title = "Anti-Fling Protection",
    Desc = "Detecta y cancela flings hacia ti.",
    Value = EmoteFlingConfig.antiFlingEnabled,
    Callback = function(Value) OnAntiFlingToggle(Value, not UI_Loaded) end,
})

local NoClipStates = setmetatable({}, { __mode = "k" })

local function RestoreNoClip(char)
    if not char then return end
    for part, state in pairs(NoClipStates) do
        if part and part.Parent then part.CanCollide = state end
    end
    for k in pairs(NoClipStates) do NoClipStates[k] = nil end
end

local function HookNoClip(char)
    DisconnectConnection("noclipLoopConn")
    DisconnectConnection("noclipAddedConn")
    if not EmoteFlingConfig.noclipEnabled then return end
    local parts = {}
    for k in pairs(NoClipStates) do NoClipStates[k] = nil end
    local function registerPart(part)
        if part:IsA("BasePart") then
            table.insert(parts, part)
            if NoClipStates[part] == nil then NoClipStates[part] = part.CanCollide end
        end
    end
    for _, part in ipairs(char:GetDescendants()) do registerPart(part) end
    RegisterConnection("noclipAddedConn", char.DescendantAdded:Connect(registerPart))
    RegisterConnection("noclipLoopConn", RunService.Stepped:Connect(function()
        if not EmoteFlingConfig.noclipEnabled or not char.Parent then
            DisconnectConnection("noclipLoopConn")
            DisconnectConnection("noclipAddedConn")
            return
        end
        for i = 1, #parts do
            local part = parts[i]
            if part.Parent and part.CanCollide then part.CanCollide = false end
        end
    end))
end

local function OnNoClipToggle(Value, isInitialization)
    EmoteFlingConfig.noclipEnabled = Value
    if EmoteFlingConfig.noclipEnabled then
        if LocalPlayer.Character then HookNoClip(LocalPlayer.Character) end
        DisconnectConnection("noclipRespawnConn")
        RegisterConnection("noclipRespawnConn", LocalPlayer.CharacterAdded:Connect(function(char)
            if EmoteFlingConfig.noclipEnabled then HookNoClip(char) end
        end))
        if not isInitialization then
            Notify({ Title = "NoClip", Content = "ON", Duration = 3, Icon = "ghost" })
        end
    else
        DisconnectConnection("noclipLoopConn")
        DisconnectConnection("noclipRespawnConn")
        DisconnectConnection("noclipAddedConn")
        if LocalPlayer.Character then RestoreNoClip(LocalPlayer.Character) end
        if not isInitialization then
            Notify({ Title = "NoClip", Content = "OFF", Duration = 3, Icon = "box" })
        end
    end
    SaveConfig()
end

protectTab:Toggle({
    Title = "NoClip",
    Desc = "Atraviesa paredes y objetos.",
    Value = EmoteFlingConfig.noclipEnabled,
    Callback = function(Value) OnNoClipToggle(Value, not UI_Loaded) end,
})

-- ========== INFO ==========
infoTab:Section({ Title = "Acerca del Script" })

infoTab:Paragraph({
    Title = "Vortex X Sage [Survival Disaster]",
    Desc = "Script multi-executor para Natural Disaster Survival y juegos similares.\nIncluye Emote Fling, Fly Superman, Aura de Items, protecciones, bubbles y utilidades.\nCompatible con PC y movil (Delta, Hydrogen, CodeX, etc.).\n\nDesarrollador: Israelcc\nUI: WindUI\nTema: VortexGoldSolid",
})

infoTab:Paragraph({
    Title = "Desarrollador",
    Desc = "Israelcc\nDesarrollo principal, mantenimiento y actualizaciones.",
})

infoTab:Divider()

infoTab:Paragraph({
    Title = "Unete a nuestro Discord",
    Desc = "Unete a nuestra comunidad oficial para soporte, actualizaciones y hablar con otros miembros.\n\nhttps://discord.gg/Fn74MpzFUn",
    Image = "rbxassetid://88267176037146",
    ImageSize = 80,
})

infoTab:Button({
    Title = "Copiar enlace de Discord",
    Desc = "Copia el invite de Discord de Vortex al portapapeles.",
    Callback = function()
        pcall(function()
            if setclipboard then
                setclipboard("https://discord.gg/Fn74MpzFUn")
            elseif setclip then
                setclip("https://discord.gg/Fn74MpzFUn")
            elseif toclipboard then
                toclipboard("https://discord.gg/Fn74MpzFUn")
            end
        end)
        showBottomMessage("Link de Discord copiado al portapapeles!")
    end,
})

infoTab:Section({ Title = "Informacion del Servidor" })

local gameNameStr = "Desconocido"
pcall(function()
    gameNameStr = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

infoTab:Paragraph({
    Title = "Juego Actual",
    Desc = gameNameStr .. "\nPlace ID: " .. tostring(game.PlaceId),
    Image = "rbxthumb://type=GameIcon&id=" .. tostring(game.GameId) .. "&w=150&h=150",
    ImageSize = 48,
})

local nombreEjecutor = "Desconocido"
pcall(function()
    if identifyexecutor then
        nombreEjecutor = identifyexecutor()
    elseif getexecutorname then
        nombreEjecutor = getexecutorname()
    end
end)

infoTab:Paragraph({
    Title = "Ejecutor",
    Desc = tostring(nombreEjecutor),
})

infoTab:Section({ Title = "Monitor" })

infoTab:Toggle({
    Title = "Mostrar FPS y Ping",
    Desc = "Contador FPS/Ping en la esquina (caja dorada).",
    Value = false,
    Callback = function(state)
        task.spawn(function()
            showFpsPing = state and true or false
            if not fpsScreenGui or not fpsScreenGui.Parent then
                pcall(function()
                    local parent = (gethui and gethui()) or CoreGui
                    if not parent then
                        parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                    end
                    fpsScreenGui = Instance.new("ScreenGui")
                    fpsScreenGui.Name = "VortexFpsPing"
                    fpsScreenGui.ResetOnSpawn = false
                    fpsScreenGui.IgnoreGuiInset = true
                    fpsScreenGui.DisplayOrder = 99950
                    fpsScreenGui.Parent = parent
                    local box = Instance.new("Frame")
                    box.AnchorPoint = Vector2.new(1, 0)
                    box.Position = UDim2.new(1, -12, 0, 10)
                    box.Size = UDim2.fromOffset(128, 44)
                    box.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
                    box.BackgroundTransparency = 0.15
                    box.BorderSizePixel = 0
                    box.Parent = fpsScreenGui
                    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
                    local st = Instance.new("UIStroke")
                    st.Color = Color3.fromRGB(255, 200, 55)
                    st.Thickness = 1.2
                    st.Transparency = 0.35
                    st.Parent = box
                    fpsPingLabel = Instance.new("TextLabel")
                    fpsPingLabel.BackgroundTransparency = 1
                    fpsPingLabel.Size = UDim2.fromScale(1, 1)
                    fpsPingLabel.Font = Enum.Font.GothamBold
                    fpsPingLabel.TextSize = 13
                    fpsPingLabel.TextColor3 = Color3.fromRGB(255, 220, 90)
                    fpsPingLabel.Text = "FPS: --\nPing: --"
                    fpsPingLabel.TextYAlignment = Enum.TextYAlignment.Center
                    fpsPingLabel.Parent = box
                end)
            end
            if fpsScreenGui then
                fpsScreenGui.Enabled = showFpsPing
            end
            if fpsPingLabel then
                fpsPingLabel.Visible = true
            end
            showBottomMessage(showFpsPing and "FPS/Ping: ON" or "FPS/Ping: OFF")
        end)
    end,
})


-- ========== ANIMACIONES ==========
local animationData = {
    ["Old School"] = { Walk = 10921244891, Run = 10921240218, Jump = 10921242013, Fall = 10921241244, SwimIdle = 10921244018, Swim = 10921243048, Idle = 10921230744, Idle2 = 10921232093, Climb = 10921229866 },
    ["Adidas Sports"] = { Walk = 18537392113, Run = 18537384940, Jump = 18537380791, Fall = 18537367238, SwimIdle = 18537387180, Swim = 18537389531, Idle = 18537376492, Idle2 = 18537371272, Climb = 18537363391 },
    ["Adidas Community"] = { Walk = 122150855457006, Run = 82598234841035, Jump = 75290611992385, Fall = 98600215928904, SwimIdle = 109346520324160, Swim = 133308483266208, Idle = 122257458498464, Idle2 = 102357151005774, Climb = 88763136693023 },
    ["Adidas Aura"] = { Walk = 83842218823011, Run = 118320322718866, Jump = 109996626521204, Fall = 95603166884636, SwimIdle = 94922130551805, Swim = 134530128383903, Idle = 110211186840347, Idle2 = 114191137265065, Climb = 97824616490448 },
    ["Wicked Popular"] = { Walk = 92072849924640, Run = 72301599441680, Jump = 104325245285198, Fall = 121152442762481, Idle = 118832222982049, Idle2 = 76049494037641, SwimIdle = 113199415118199, Swim = 99384245425157, Climb = 131326830509784 },
    ["Elder"] = { Walk = 10921111375, Run = 10921104374, Jump = 10921107367, Fall = 10921105765, SwimIdle = 10921110146, Swim = 10921108971, Idle = 10921101664, Idle2 = 10921102574, Climb = 10921100400 },
    ["Zombie"] = { Walk = 10921355261, Run = 616163682, Jump = 10921351278, Fall = 10921350320, SwimIdle = 10921353442, Swim = 10921352344, Idle = 10921344533, Idle2 = 10921345304, Climb = 10921343576 },
    ["Mage"] = { Walk = 10921152678, Run = 10921148209, Jump = 10921149743, Fall = 10921148939, SwimIdle = 10921151661, Swim = 10921150788, Idle = 10921144709, Idle2 = 10921145797, Climb = 10921143404 },
    ["Catwalk Glam"] = { Walk = 109168724482748, Run = 81024476153754, Jump = 116936326516985, Fall = 92294537340807, SwimIdle = 98854111361360, Swim = 134591743181628, Idle = 133806214992291, Idle2 = 94970088341563, Climb = 119377220967554 },
    ["Astronaut"] = { Walk = 10921046031, Run = 10921039308, Jump = 10921042494, Fall = 10921040576, SwimIdle = 10921045006, Swim = 10921044000, Idle = 10921034824, Idle2 = 10921036806, Climb = 10921032124 },
    ['Wicked "Dancing Through Life"'] = { Walk = 73718308412641, Run = 135515454877967, Jump = 78508480717326, Fall = 78147885297412, SwimIdle = 129183123083281, Swim = 110657013921774, Idle = 92849173543269, Idle2 = 132238900951109, Climb = 129447497744818 },
    ["Werewolf"] = { Walk = 10921342074, Run = 10921336997, Fall = 10921337907, SwimIdle = 10921341319, Swim = 10921340419, Idle = 10921330408, Idle2 = 10921333667, Climb = 10921329322 },
    ["Superhero"] = { Walk = 10921298616, Run = 10921291831, Jump = 10921294559, Fall = 10921293373, SwimIdle = 10921297391, Swim = 10921295495, Idle = 10921288909, Idle2 = 10921290167, Climb = 10921286911 },
    ["Toy"] = { Walk = 10921312010, Run = 10921306285, Jump = 10921308158, Fall = 10921307241, SwimIdle = 10921310341, Swim = 10921309319, Idle = 10921301576, Climb = 10921300839 },
    ["No Boundaries"] = { Walk = 18747074203, Run = 18747070484, Jump = 18747069148, Fall = 18747062535, SwimIdle = 18747071682, Swim = 18747073181, Idle = 18747067405, Idle2 = 18747063918, Climb = 18747060903 },
    ["NFL"] = { Walk = 110358958299415, Run = 117333533048078, Jump = 119846112151352, Fall = 129773241321032, SwimIdle = 79090109939093, Swim = 132697394189921, Idle = 92080889861410, Idle2 = 74451233229259, Climb = 134630013742019 },
    ["Amazon Unboxed"] = { Walk = 90478085024465, Run = 134824450619865, Jump = 121454505477205, Fall = 94788218468396, SwimIdle = 129126268464847, Swim = 105962919001086, Idle = 98281136301627, Climb = 121145883950231 },
    ["Vampire"] = { Walk = 10921326949, Run = 10921320299, Jump = 10921322186, Fall = 10921321317, SwimIdle = 10921325443, Swim = 10921324408, Idle = 10921315373, Climb = 10921314188 },
    ["Ninja"] = { Walk = 656121766, Run = 656118852, Jump = 656117878, Fall = 656115606, SwimIdle = 656121397, Swim = 656119721, Idle = 656117400, Idle2 = 656118341, Climb = 656114359 },
    ["Robot"] = { Walk = 616095330, Run = 616091570, Jump = 616090535, Fall = 616087089, SwimIdle = 616094091, Swim = 616092998, Idle = 616088211, Idle2 = 616089559, Climb = 616086039 },
    ["Levitation"] = { Walk = 616013216, Run = 616010382, Jump = 616008936, Fall = 616005863, SwimIdle = 616012453, Swim = 616011509, Idle = 616006778, Idle2 = 616008087, Climb = 616003713 },
    ["Stylish"] = { Walk = 616146177, Run = 616140816, Jump = 616139451, Fall = 616134815, SwimIdle = 616144772, Swim = 616143378, Idle = 616136790, Idle2 = 616138447, Climb = 616133594 },
    ["Bubbly"] = { Walk = 910034870, Run = 910025107, Jump = 910016857, Fall = 910001910, SwimIdle = 910030921, Swim = 910028158, Idle = 910004836, Idle2 = 910009958, Climb = 909997997 },
    ["Cartoon"] = { Walk = 742640026, Run = 742638842, Jump = 742637942, Fall = 742637151, SwimIdle = 742639812, Swim = 742639220, Idle = 742637544, Idle2 = 742638445, Climb = 742636889 }
}

local function clearAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    for _, track in pairs(hum:GetPlayingAnimationTracks()) do
        track:Stop(0)
        track:Destroy()
    end
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0)
            track:Destroy()
        end
    end
    task.wait(0.1)
end

local animacionActualActiva = nil
local misAnimacionesOriginales = nil

local function applyCustomAnims(customData)
    if not customData then return end
    local char = LocalPlayer.Character
    if not char then return end
    clearAllAnimations()

    local animate = char:FindFirstChild("Animate")
    if not animate then return end

    if not misAnimacionesOriginales then
        local function getAnim(folderName, animName)
            local folder = animate:FindFirstChild(folderName)
            if folder then
                local anim = folder:FindFirstChild(animName)
                if anim and anim:IsA("Animation") then
                    local idStr = anim.AnimationId:match("%d+")
                    if idStr then return tonumber(idStr) end
                end
            end
            return nil
        end

        misAnimacionesOriginales = {
            Idle = getAnim("idle", "Animation1") or 507766666,
            Idle2 = getAnim("idle", "Animation2") or 507766951,
            Walk = getAnim("walk", "WalkAnim") or 507777826,
            Run = getAnim("run", "RunAnim") or 507767714,
            Jump = getAnim("jump", "JumpAnim") or 507765000,
            Climb = getAnim("climb", "ClimbAnim") or 507765644,
            Fall = getAnim("fall", "FallAnim") or 507767968,
            Swim = getAnim("swim", "Swim") or 507784897,
            SwimIdle = getAnim("swimidle", "SwimIdle") or 507785072
        }
    end

    animate.Disabled = true
    task.wait(0.1)

    local function updateAnimation(folderName, animName, animId)
        if not animId then return end
        local folder = animate:FindFirstChild(folderName)
        if folder then
            local anim = folder:FindFirstChild(animName)
            if anim and anim:IsA("Animation") then
                anim.AnimationId = "rbxassetid://" .. tostring(animId)
            end
        end
    end

    updateAnimation("idle", "Animation1", customData.Idle)
    updateAnimation("idle", "Animation2", customData.Idle2 or customData.Idle)
    updateAnimation("walk", "WalkAnim", customData.Walk)
    updateAnimation("run", "RunAnim", customData.Run)
    updateAnimation("jump", "JumpAnim", customData.Jump)
    updateAnimation("climb", "ClimbAnim", customData.Climb)
    updateAnimation("fall", "FallAnim", customData.Fall)
    updateAnimation("swim", "Swim", customData.Swim)
    updateAnimation("swimidle", "SwimIdle", customData.SwimIdle or customData.Swim)

    task.wait(0.1)
    animate.Disabled = false

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Landed)
        task.wait(0.05)
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
end

task.spawn(function()
    while task.wait(1) do
        if animacionActualActiva then
            local char = LocalPlayer.Character
            if char then
                local animate = char:FindFirstChild("Animate")
                if animate then
                    local idleFolder = animate:FindFirstChild("idle")
                    if idleFolder then
                        local anim1 = idleFolder:FindFirstChild("Animation1")
                        if anim1 then
                            local currentId = anim1.AnimationId:match("%d+")
                            if currentId ~= tostring(animacionActualActiva.Idle) then
                                applyCustomAnims(animacionActualActiva)
                            end
                        end
                    end
                end
            end
        end
    end
end)

local animList = {"Ninguno"}
for name, _ in pairs(animationData) do
    table.insert(animList, name)
end
table.sort(animList)

animTab:Section({ Title = "Paquetes Completos" })

local selectedBundleCompleto = "Ninguno"
animTab:Dropdown({
    Title = "Elegir Paquete",
    Desc = "Elige un set completo de animaciones de movimiento.",
    Values = animList,
    Value = "Ninguno",
    Callback = function(Value)
        selectedBundleCompleto = Value
    end
})

local function restoreDefaultAnimsSD()
    local defaultAnims = misAnimacionesOriginales or {
        Idle = 507766666, Idle2 = 507766951, Walk = 507777826, Run = 507767714,
        Jump = 507765000, Climb = 507765644, Fall = 507767968, Swim = 507784897, SwimIdle = 507785072
    }
    animacionActualActiva = nil
    applyCustomAnims(defaultAnims)
end

animTab:Toggle({
    Flag = "Activar_Paquete",
    Title = "Activar Paquete",
    Desc = "ON = aplica el paquete. OFF = restaura default.",
    Default = false,
    Callback = function(state)
        task.spawn(function()
            if state then
                if selectedBundleCompleto == "Ninguno" or not animationData[selectedBundleCompleto] then
                    showBottomMessage("Elige un paquete primero.")
                    return
                end
                showBottomMessage("Paquete ON: " .. selectedBundleCompleto)
                animacionActualActiva = animationData[selectedBundleCompleto]
                applyCustomAnims(animacionActualActiva)
            else
                restoreDefaultAnimsSD()
                showBottomMessage("Paquete OFF · default")
            end
        end)
    end
})

animTab:Toggle({
    Flag = "Forzar_Default",
    Title = "Forzar Default",
    Desc = "Restaura animaciones originales del avatar.",
    Default = false,
    Callback = function(state)
        if state then
            task.spawn(function()
                restoreDefaultAnimsSD()
                showBottomMessage("Animaciones default restauradas.")
            end)
        end
    end
})

animTab:Section({ Title = "Mezclador de Animaciones" })

local mixParts = {
    Idle = "Ninguno", Walk = "Ninguno", Run = "Ninguno",
    Jump = "Ninguno", Fall = "Ninguno", Climb = "Ninguno"
}

animTab:Dropdown({ Title = "Reposo", Desc = "Animacion de idle (cuando estas quieto).", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Idle = Value end })
animTab:Dropdown({ Title = "Caminar", Desc = "Animacion al caminar.", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Walk = Value end })
animTab:Dropdown({ Title = "Correr", Desc = "Animacion al correr.", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Run = Value end })
animTab:Dropdown({ Title = "Saltar", Desc = "Animacion al saltar.", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Jump = Value end })
animTab:Dropdown({ Title = "Caer", Desc = "Animacion al caer en el aire.", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Fall = Value end })
animTab:Dropdown({ Title = "Escalar", Desc = "Animacion al trepar o escalar.", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Climb = Value end })

animTab:Toggle({
    Flag = "Activar_Mezcla",
    Title = "Activar Mezcla",
    Desc = "ON = aplica mezcla. OFF = restaura default.",
    Default = false,
    Callback = function(state)
        task.spawn(function()
            if not state then
                restoreDefaultAnimsSD()
                showBottomMessage("Mezcla OFF · default")
                return
            end
            local customMix = {}
            if mixParts.Idle ~= "Ninguno" and animationData[mixParts.Idle] then
                customMix.Idle = animationData[mixParts.Idle].Idle
                customMix.Idle2 = animationData[mixParts.Idle].Idle2
            end
            if mixParts.Walk ~= "Ninguno" and animationData[mixParts.Walk] then
                customMix.Walk = animationData[mixParts.Walk].Walk
            end
            if mixParts.Run ~= "Ninguno" and animationData[mixParts.Run] then
                customMix.Run = animationData[mixParts.Run].Run
            end
            if mixParts.Jump ~= "Ninguno" and animationData[mixParts.Jump] then
                customMix.Jump = animationData[mixParts.Jump].Jump
            end
            if mixParts.Fall ~= "Ninguno" and animationData[mixParts.Fall] then
                customMix.Fall = animationData[mixParts.Fall].Fall
            end
            if mixParts.Climb ~= "Ninguno" and animationData[mixParts.Climb] then
                customMix.Climb = animationData[mixParts.Climb].Climb
            end
            local hasValues = false
            for _, v in pairs(customMix) do
                if v then hasValues = true break end
            end
            if hasValues then
                showBottomMessage("Mezcla ON")
                animacionActualActiva = customMix
                applyCustomAnims(animacionActualActiva)
            else
                showBottomMessage("Selecciona al menos una animación.")
            end
        end)
    end
})




-- ========== CONFIG ==========
configTab:Section({ Title = "UI" })
pcall(function()
    configTab:Toggle({
        Title = "Panel Background",
        Desc = "Muestra u oculta el fondo del panel de la UI.",
        Value = true,
        Callback = function(state)
            pcall(function() Window:SetPanelBackground(state) end)
        end,
    })
end)
pcall(function() Window:SetPanelBackground(true) end)

configTab:Input({
    Title = "Background Image ID",
    Desc = "ID de Roblox para el fondo (rbxassetid://...).",
    Value = "rbxassetid://133044138027516",
    Callback = function(input)
        pcall(function() Window:SetBackground(input) end)
    end,
})

configTab:Divider()
configTab:Section({ Title = "Notificaciones" })
configTab:Toggle({
    Title = "Notificaciones",
    Desc = "Activa o desactiva las notificaciones del script.",
    Value = EmoteFlingConfig.NotificationsEnabled,
    Callback = function(state)
        EmoteFlingConfig.NotificationsEnabled = state
        SaveConfig()
    end,
})

configTab:Section({ Title = "Config local" })
configTab:Button({
    Title = "Guardar Config",
    Desc = "Guarda Armed, IDs, keys y protecciones en archivo local.",
    Callback = function()
        SaveConfig()
        Notify({ Title = "Config", Content = "Guardada.", Duration = 2, Icon = "check" })
    end,
})
configTab:Button({
    Title = "Cargar Config",
    Desc = "Recarga la config desde archivo local.",
    Callback = function()
        if LoadConfig() then
            Notify({ Title = "Config", Content = "Cargada.", Duration = 2, Icon = "check" })
        else
            Notify({ Title = "Config", Content = "No se pudo cargar.", Duration = 2, Icon = "x-circle" })
        end
    end,
})

-- Cleanup
RegisterConnection("charAddedConn", LocalPlayer.CharacterAdded:Connect(function()
    if EmoteFlingConfig.Active then
        EmoteFlingConfig.Active = false
        Notify({ Title = "Emote Fling", Content = "Interrumpido (respawn).", Duration = 2, Icon = "shield-off" })
    end
    if flyEnabled then
        flyEnabled = false
        stopFlyMovers()
        setFlyBubbleVisual(false)
    end
end))

local isCleaningUp = false
_G.EmoteFling_GlobalCleanup = function()
    if isCleaningUp then return end
    isCleaningUp = true
    for name, _ in pairs(EventConnections) do DisconnectConnection(name) end
    if EmoteFlingConfig.Active then EmoteFlingConfig.Active = false end
    if flyEnabled then flyEnabled = false stopFlyMovers() end
    auraEnabled = false
    pcall(function() if auraMenu then auraMenu:Destroy() end end)
    pcall(function() if flyMenu then flyMenu:Destroy() end end)
    pcall(function() if bubblesScreenGui then bubblesScreenGui:Destroy() end end)
    pcall(function() Window:Destroy() end)
end

UI_Loaded = true

if EmoteFlingConfig.antiFallEnabled then OnAntiFallToggle(true, true) end
if EmoteFlingConfig.godEnabled then OnGodToggle(true, true) end
if EmoteFlingConfig.antiFlingEnabled then OnAntiFlingToggle(true, true) end
if EmoteFlingConfig.noclipEnabled then OnNoClipToggle(true, true) end

if ConfigLoaded then
    Notify({ Title = "Emote Fling", Content = "Config cargada.", Duration = 2, Icon = "check-circle" })
else
    Notify({ Title = "Emote Fling", Content = "Modulo cargado.", Duration = 3, Icon = "check-circle" })
end

print("[Vortex X Sage] Survival Disaster WindUI loaded")
-- Autosave Survival options
task.spawn(function()
    while true do
        task.wait(15)
        pcall(SaveConfig)
    end
end)


-- Redirect WindUI notifications -> VortexNotify
pcall(function()
    if WindUI and type(WindUI) == "table" then
        WindUI.Notify = function(_, opts)
            opts = opts or {}
            vortexNotify(opts.Title or opts.title, opts.Content or opts.content or opts.Text, opts.Duration or opts.duration)
        end
    end
end)


-- Force all notifications through VortexNotify (no WindUI notify UI)
pcall(function()
    local function hookNotify(tbl)
        if type(tbl) ~= "table" then return end
        tbl.Notify = function(_, opts)
            opts = type(opts) == "table" and opts or { Content = tostring(opts) }
            local title = opts.Title or opts.title or "Vortex X Sage"
            local content = opts.Content or opts.content or opts.Text or opts.text or ""
            local dur = opts.Duration or opts.duration or 2.5
            if VortexNotify and VortexNotify.Show then
                VortexNotify.Show(tostring(title), tostring(content), tonumber(dur) or 2.5)
            end
        end
    end
    if WindUI then hookNotify(WindUI) end
    if Window then hookNotify(Window) end
end)
