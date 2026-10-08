ñlocal Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")

if not game:IsLoaded() then game.Loaded:Wait() end
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
	task.wait()
	LocalPlayer = Players.LocalPlayer
end

local GUI_NAME = "FlexusAvatarCopier"
local SAVE_FILE = "FlexusAvatarCopier.json"
local SHELL_NAME = "FxAvatarShell"
local LOGO_ID = 78482030075403
local BG_ID = 83511264088514
local DISCORD_LINK = "https://discord.gg/Fn74MpzFUn"
local env = (getgenv and getgenv()) or _G

if env.FlexusAvatarCleanup then
	pcall(env.FlexusAvatarCleanup)
end

local conns = {}
local function track(c)
	conns[#conns + 1] = c
	return c
end

local function withTimeout(secs, fn)
	local res, done = nil, false
	task.spawn(function()
		local ok, r = pcall(fn)
		if ok then res = r end
		done = true
	end)
	local t0 = os.clock()
	while not done and os.clock() - t0 < secs do task.wait(0.05) end
	return res
end

local function probeImage(id)
	local p = Instance.new("ImageLabel")
	p.Image = id
	withTimeout(0.8, function() ContentProvider:PreloadAsync({ p }) end)
	local ok, loaded = pcall(function() return p.IsLoaded end)
	pcall(function() p:Destroy() end)
	return ok and loaded
end

local function textureFromAsset(direct)
	local ok, obj = pcall(function() return game:GetObjects(direct)[1] end)
	if not (ok and obj) then return nil end
	local tex
	if obj:IsA("Decal") or obj:IsA("Texture") then
		tex = obj.Texture
	else
		local d = obj:FindFirstChildWhichIsA("Decal", true)
		if d then tex = d.Texture end
	end
	if tex and tex ~= "" then return tex end
	return nil
end

local Logo = {
	image = "rbxassetid://" .. tostring(LOGO_ID),
	ready = true,
	subs = {},
}
function Logo.onReady(fn)
	task.spawn(fn, Logo.image)
end

local Bg = {
	image = "rbxassetid://" .. tostring(BG_ID),
	ready = true,
	subs = {},
}
function Bg.onReady(fn)
	task.spawn(fn, Bg.image)
end

local function getParent()
	local ok, ui = pcall(function() return gethui and gethui() end)
	if ok and ui then return ui end
	ok, ui = pcall(function() return game:GetService("CoreGui") end)
	if ok and ui then
		local t = Instance.new("Folder")
		local good = pcall(function() t.Parent = ui end)
		t:Destroy()
		if good then return ui end
	end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local parent = getParent()
local old = parent:FindFirstChild(GUI_NAME)
if old then old:Destroy() end
local oldIntro = parent:FindFirstChild("FlexusAvatarIntro")
if oldIntro then oldIntro:Destroy() end

local WHITE = Color3.new(1, 1, 1)
local BLACK = Color3.new(0, 0, 0)

local IC = {
	title = Color3.fromRGB(255, 255, 255),
	titleLow = Color3.fromRGB(180, 180, 190),
	gold = Color3.fromRGB(255, 255, 255),       -- neon blanco
	goldLight = Color3.fromRGB(220, 220, 230),
	soft = Color3.fromRGB(140, 140, 150),
	btnText = Color3.fromRGB(235, 235, 240),
	btnBg = Color3.fromRGB(16, 16, 18),
	btnBgMain = Color3.fromRGB(28, 28, 32),
	btnLine = Color3.fromRGB(90, 90, 100),
}

local T = {
	text = IC.title,
	sub = IC.soft,
	line = IC.btnLine,
	gold = IC.gold,
	red = Color3.fromRGB(220, 60, 70),
	green = Color3.fromRGB(90, 200, 120),
	warn = Color3.fromRGB(255, 200, 80),
}

local STYLES = {
	main = { bg = IC.btnBgMain, bgT = 0.15, stroke = IC.gold, strokeT = 0.2, text = WHITE },
	dark = { bg = IC.btnBg, bgT = 0.35, stroke = IC.btnLine, strokeT = 0.45, text = IC.btnText },
	danger = { bg = Color3.fromRGB(40, 18, 22), bgT = 0.25, stroke = T.red, strokeT = 0.35, text = Color3.fromRGB(255, 220, 225) },
	green = { bg = Color3.fromRGB(22, 40, 32), bgT = 0.25, stroke = T.green, strokeT = 0.4, text = WHITE },
}

local data = { saved = {}, favs = {} }

local function loadData()
	local ok, raw = pcall(function()
		if isfile and isfile(SAVE_FILE) then return readfile(SAVE_FILE) end
	end)
	if ok and raw then
		local ok2, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
		if ok2 and type(decoded) == "table" then
			data.saved = type(decoded.saved) == "table" and decoded.saved or {}
			data.favs = type(decoded.favs) == "table" and decoded.favs or {}
		end
	end
end

local function saveData()
	pcall(function()
		if writefile then writefile(SAVE_FILE, HttpService:JSONEncode(data)) end
	end)
end
loadData()

local UI = {}
local touchOnly = UIS.TouchEnabled and not UIS.MouseEnabled

function UI.new(class, props)
	local o = Instance.new(class)
	local p
	for k, v in pairs(props) do
		if k == "Parent" then p = v else o[k] = v end
	end
	if p then o.Parent = p end
	return o
end
local new = UI.new

function UI.corner(o, r)
	return new("UICorner", { Parent = o, CornerRadius = UDim.new(0, r) })
end
local corner = UI.corner

function UI.stroke(o, color, thick, trans)
	return new("UIStroke", {
		Parent = o, Color = color, Thickness = thick or 1,
		Transparency = trans or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end
local stroke = UI.stroke

function UI.grad(o, c1, c2, rot)
	return new("UIGradient", { Parent = o, Color = ColorSequence.new(c1, c2), Rotation = rot or 90 })
end
local grad = UI.grad

function UI.tween(o, info, props)
	local t = TweenService:Create(o, info, props)
	t:Play()
	return t
end
local tween = UI.tween

local gui = new("ScreenGui", {
	Name = GUI_NAME, ResetOnSpawn = false, IgnoreGuiInset = true,
	DisplayOrder = 1200, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = parent,
})

function UI.viewport()
	local s = gui.AbsoluteSize
	if s.X < 10 or s.Y < 10 then s = workspace.CurrentCamera.ViewportSize end
	return s
end

function UI.clampPos(target, x, y)
	local vp = UI.viewport()
	local sz = target.AbsoluteSize
	return math.clamp(x, 0, math.max(0, vp.X - sz.X)), math.clamp(y, 0, math.max(0, vp.Y - sz.Y))
end
local clampPos = UI.clampPos

function UI.draggable(handle, target, onTap, onDown, onUp)
	local dragging, moved, active, startIn, startX, startY = false, false, nil, nil, 0, 0
	track(handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging, moved, active = true, false, input
			startIn = input.Position
			startX, startY = target.Position.X.Offset, target.Position.Y.Offset
			if onDown then onDown() end
			local c
			c = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					c:Disconnect()
					local wasDrag = moved
					dragging = false
					if onUp then onUp(wasDrag) end
					if not wasDrag and onTap then onTap() end
				end
			end)
		end
	end))
	track(UIS.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input == active then
			local d = input.Position - startIn
			if not moved and d.Magnitude < 6 then return end
			moved = true
			local x, y = clampPos(target, startX + d.X, startY + d.Y)
			target.Position = UDim2.fromOffset(x, y)
		end
	end))
end

function UI.logo(img, fallback)
	local image = Logo.image or ("rbxassetid://" .. tostring(LOGO_ID))
	img.Image = image
	img.ImageTransparency = 0
	if fallback then fallback.Visible = false end
end

function UI.background(host, overlayT)
	local holder = new("Frame", {
		Parent = host, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
		BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 0,
	})
	local img = new("ImageLabel", {
		Parent = holder, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Crop,
		Image = Bg.image or ("rbxassetid://" .. tostring(BG_ID)),
		ImageTransparency = 0.12,
		ZIndex = 0,
	})
	local sc = new("UIScale", { Parent = img, Scale = 1.02 })
	new("Frame", {
		Parent = host, Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(8, 10, 16),
		BackgroundTransparency = math.clamp((overlayT or 0.45) - 0.05, 0.2, 0.7),
		BorderSizePixel = 0, ZIndex = 1,
	})
	local shade = new("Frame", {
		Parent = host, Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(0, 18, 28),
		BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 1,
	})
	new("UIGradient", {
		Parent = shade, Rotation = 125,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.55),
			NumberSequenceKeypoint.new(0.45, 0.88),
			NumberSequenceKeypoint.new(1, 0.4),
		}),
		Color = ColorSequence.new(Color3.fromRGB(0, 40, 55), Color3.fromRGB(5, 8, 14)),
	})
	return sc
end

function UI.icon(kind, parent_, color, size)
	size = size or 16
	local root = new("Frame", {
		Parent = parent_, Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1,
	})
	local inner = new("Frame", {
		Parent = root, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1,
	})
	new("UIScale", { Parent = inner, Scale = size / 16 })

	local fills, strokes = {}, {}

	local function bar(cx, cy, w, h, rot)
		local f = new("Frame", {
			Parent = inner, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(cx, cy),
			Size = UDim2.fromOffset(w, h), Rotation = rot or 0, BackgroundColor3 = color, BorderSizePixel = 0,
		})
		corner(f, math.min(w, h) / 2)
		fills[#fills + 1] = f
	end

	local function line(x1, y1, x2, y2, th)
		local dx, dy = x2 - x1, y2 - y1
		local len = math.sqrt(dx * dx + dy * dy)
		bar((x1 + x2) / 2, (y1 + y2) / 2, len, th or 1.8, math.deg(math.atan2(dy, dx)))
	end

	local function box(cx, cy, w, h, r, th)
		local f = new("Frame", {
			Parent = inner, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(cx, cy),
			Size = UDim2.fromOffset(w, h), BackgroundTransparency = 1, BorderSizePixel = 0,
		})
		corner(f, r)
		strokes[#strokes + 1] = new("UIStroke", {
			Parent = f, Color = color, Thickness = th, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})
	end

	if kind == "close" then
		line(3.8, 3.8, 12.2, 12.2, 2)
		line(12.2, 3.8, 3.8, 12.2, 2)
	elseif kind == "min" then
		bar(8, 11, 10, 2)
	elseif kind == "plus" then
		bar(8, 8, 11, 2)
		bar(8, 8, 2, 11)
	elseif kind == "search" then
		box(7, 7, 10, 10, 5, 1.6)
		line(10.8, 10.8, 14.2, 14.2, 2)
	elseif kind == "copy" then
		bar(6.5, 3.2, 7, 1.6)
		bar(3.2, 6.5, 1.6, 7)
		box(9.5, 9.5, 9, 9, 2, 1.6)
	elseif kind == "trash" then
		box(8, 2.9, 4.6, 3.2, 1.4, 1.4)
		bar(8, 4.9, 12.5, 1.8)
		box(8, 10.6, 9, 8.6, 2, 1.5)
		bar(6.2, 10.8, 1.3, 4.6)
		bar(9.8, 10.8, 1.3, 4.6)
	elseif kind == "star" then
		local pts = {}
		for k = 0, 4 do
			local a = math.rad(-90 + 72 * k)
			pts[k] = { 8 + 7.2 * math.cos(a), 8.7 + 7.2 * math.sin(a) }
		end
		for k = 0, 4 do
			local p, q = pts[k], pts[(k + 2) % 5]
			line(p[1], p[2], q[1], q[2], 1.5)
		end
	elseif kind == "back" then
		line(3, 8, 13, 8, 1.8)
		line(3, 8, 7, 4, 1.8)
		line(3, 8, 7, 12, 1.8)
	end

	local icon = { root = root }
	function icon.set(c)
		for _, f in ipairs(fills) do f.BackgroundColor3 = c end
		for _, s in ipairs(strokes) do s.Color = c end
	end
	return icon
end

function UI.button(o)
	local S = STYLES[o.style or "dark"]
	local b = new("TextButton", {
		Parent = o.parent, Size = o.size, BackgroundColor3 = S.bg, BackgroundTransparency = S.bgT,
		AutoButtonColor = false, Text = "", BorderSizePixel = 0, LayoutOrder = o.order or 0,
	})
	if o.pos then b.Position = o.pos end
	if o.anchor then b.AnchorPoint = o.anchor end
	corner(b, o.radius or 4)
	local st = stroke(b, S.stroke, 1, S.strokeT)
	local sc = new("UIScale", { Parent = b, Scale = 1 })

	local row = new("Frame", { Parent = b, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 })
	new("UIListLayout", {
		Parent = row, FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local tc = o.textColor or S.text
	local icColor = o.iconColor or tc
	local ic, lbl
	if o.icon then
		ic = UI.icon(o.icon, row, icColor, o.iconSize or 14)
		ic.root.LayoutOrder = 1
	end
	if o.text then
		lbl = new("TextLabel", {
			Parent = row, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 16), Text = o.text, Font = Enum.Font.SourceSansSemibold,
			TextSize = o.textSize or 12, TextColor3 = tc, LayoutOrder = 2,
		})
	end

	local diamonds = {}
	if o.diamonds then
		for _, side in ipairs({ 0, 1 }) do
			diamonds[#diamonds + 1] = new("Frame", {
				Parent = b, AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(side, side == 0 and -16 or 16, 0.5, 0),
				Size = UDim2.fromOffset(7, 7), Rotation = 45, BackgroundColor3 = IC.gold, BorderSizePixel = 0,
			})
		end
	end

	local info = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
	local pinfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local rinfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	local function paint(mode)
		local bgT, stT, bgC
		if mode == "hover" then
			bgT, stT = math.max(0, S.bgT - 0.18), math.max(0, S.strokeT - 0.3)
			bgC = S.bg:Lerp(S.stroke, 0.18)
		elseif mode == "press" then
			bgT, stT = math.max(0, S.bgT - 0.3), math.max(0, S.strokeT - 0.4)
			bgC = S.bg:Lerp(S.stroke, 0.3)
		else
			bgT, stT, bgC = S.bgT, S.strokeT, S.bg
		end
		tween(b, info, { BackgroundTransparency = bgT, BackgroundColor3 = bgC })
		tween(st, info, { Transparency = stT })
	end

	b.MouseEnter:Connect(function()
		if touchOnly then return end
		paint("hover")
		if ic and o.iconHover then ic.set(o.iconHover) end
	end)
	b.MouseLeave:Connect(function()
		paint("idle")
		tween(sc, rinfo, { Scale = 1 })
		if ic and o.iconHover then ic.set(icColor) end
	end)
	b.MouseButton1Down:Connect(function()
		paint("press")
		tween(sc, pinfo, { Scale = 0.95 })
		if ic and o.iconHover then ic.set(o.iconHover) end
	end)
	b.MouseButton1Up:Connect(function()
		tween(sc, rinfo, { Scale = 1 })
		if touchOnly then
			paint("idle")
			if ic and o.iconHover then ic.set(icColor) end
		else
			paint("hover")
		end
	end)

	local h = { btn = b, label = lbl, icon = ic, stroke = st }
	function h.setStyle(name)
		S = STYLES[name] or S
		local c = o.textColor or S.text
		if lbl then lbl.TextColor3 = c end
		if ic and not o.iconColor then ic.set(c) end
		for _, d in ipairs(diamonds) do d.BackgroundColor3 = IC.gold end
		tween(st, info, { Color = S.stroke })
		paint("idle")
	end
	return h
end
local makeButton = UI.button

function UI.winButton(parent_, kind, xOff, accent)
	local b = new("TextButton", {
		Parent = parent_, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, xOff, 0.5, 0),
		Size = UDim2.fromOffset(28, 28), BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.45,
		AutoButtonColor = false, Text = "", BorderSizePixel = 0,
	})
	corner(b, 4)
	local st = stroke(b, IC.btnLine, 1, 0.65)
	local sc = new("UIScale", { Parent = b, Scale = 1 })
	local ic = UI.icon(kind, b, IC.soft, 14)
	ic.root.AnchorPoint = Vector2.new(0.5, 0.5)
	ic.root.Position = UDim2.fromScale(0.5, 0.5)

	local info = TweenInfo.new(0.14, Enum.EasingStyle.Quad)
	local pinfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local rinfo = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	local function state(bgColor, bgT, strokeColor, strokeT, iconColor)
		tween(b, info, { BackgroundColor3 = bgColor, BackgroundTransparency = bgT })
		tween(st, info, { Color = strokeColor, Transparency = strokeT })
		ic.set(iconColor)
	end
	local function idle() state(IC.btnBg, 0.45, IC.btnLine, 0.65, IC.soft) end
	local function over() state(accent:Lerp(BLACK, 0.7), 0.15, accent, 0.2, WHITE) end

	b.MouseEnter:Connect(function()
		if touchOnly then return end
		over()
		if kind == "close" then
			tween(ic.root, rinfo, { Rotation = 90 })
		end
	end)
	b.MouseLeave:Connect(function()
		idle()
		tween(sc, rinfo, { Scale = 1 })
		tween(ic.root, rinfo, { Rotation = 0 })
	end)
	b.MouseButton1Down:Connect(function()
		over()
		tween(sc, pinfo, { Scale = 0.88 })
	end)
	b.MouseButton1Up:Connect(function()
		tween(sc, rinfo, { Scale = 1 })
		if touchOnly then
			idle()
		else
			over()
		end
	end)
	return b
end

function UI.modal(host)
	local overlay = new("Frame", {
		Parent = host, Size = UDim2.fromScale(1, 1), BackgroundColor3 = BLACK,
		BackgroundTransparency = 1, BorderSizePixel = 0, Active = true, Visible = false, ZIndex = 100,
	})
	local box = new("Frame", {
		Parent = overlay, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(300, 142), BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.08,
		BorderSizePixel = 0, ZIndex = 101,
	})
	corner(box, 6)
	local boxStroke = stroke(box, WHITE, 1.2, 0.2)
	grad(boxStroke, IC.gold, IC.btnLine, 60)
	local scale = new("UIScale", { Parent = box, Scale = 0.9 })
	local title = new("TextLabel", {
		Parent = box, Position = UDim2.fromOffset(14, 12), Size = UDim2.new(1, -28, 0, 26),
		BackgroundTransparency = 1, Text = "", Font = Enum.Font.SourceSansBold,
		TextSize = 22, TextColor3 = IC.title, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 102,
	})
	local text = new("TextLabel", {
		Parent = box, Position = UDim2.fromOffset(14, 42), Size = UDim2.new(1, -28, 0, 34),
		BackgroundTransparency = 1, Text = "", Font = Enum.Font.SourceSans, TextSize = 12,
		TextColor3 = IC.soft, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 102,
	})
	local left = makeButton({
		parent = box, text = "Volver", size = UDim2.fromOffset(129, 34),
		pos = UDim2.fromOffset(14, 94), style = "dark", textSize = 13,
	})
	local right = makeButton({
		parent = box, text = "Aceptar", size = UDim2.fromOffset(129, 34),
		pos = UDim2.fromOffset(157, 94), style = "danger", textSize = 13,
	})
	for _, d in ipairs(box:GetDescendants()) do
		if d:IsA("GuiObject") and d.ZIndex < 102 then d.ZIndex = 102 end
	end

	local m = {}
	local cbLeft, cbRight
	local showToken = 0

	function m.show(o)
		showToken = showToken + 1
		title.Text = o.title or ""
		text.Text = o.text or ""
		left.label.Text = o.leftText or "Cancelar"
		right.label.Text = o.rightText or "Confirmar"
		left.setStyle(o.leftStyle or "dark")
		right.setStyle(o.rightStyle or "danger")
		cbLeft, cbRight = o.onLeft, o.onRight
		overlay.Visible = true
		tween(overlay, TweenInfo.new(0.2), { BackgroundTransparency = 0.45 })
		scale.Scale = 0.9
		tween(scale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
	end

	function m.hide()
		showToken = showToken + 1
		local my = showToken
		tween(scale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.9 })
		local t = tween(overlay, TweenInfo.new(0.18), { BackgroundTransparency = 1 })
		t.Completed:Connect(function()
			if showToken == my then overlay.Visible = false end
		end)
	end

	left.btn.MouseButton1Click:Connect(function()
		m.hide()
		if cbLeft then cbLeft() end
	end)
	right.btn.MouseButton1Click:Connect(function()
		m.hide()
		if cbRight then cbRight() end
	end)
	return m
end

local W, H = 580, 370
local vp0 = UI.viewport()
local BASE = math.min(1, (vp0.Y - 24) / H, (vp0.X - 24) / W)

local Root = new("Frame", {
	Parent = gui, BackgroundTransparency = 1, Active = true,
	Size = UDim2.fromOffset(W * BASE, H * BASE),
	Position = UDim2.fromOffset(math.floor((vp0.X - W * BASE) / 2), math.floor((vp0.Y - H * BASE) / 2)),
	Visible = false,
})

local Window = new("CanvasGroup", {
	Parent = Root, AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(W, H),
	BackgroundColor3 = Color3.fromRGB(10, 12, 18), BackgroundTransparency = 0, BorderSizePixel = 0,
	Active = true, GroupTransparency = 0,
})
corner(Window, 12)
local winStroke = stroke(Window, Color3.fromRGB(200, 200, 210), 1.5, 0.25)
grad(winStroke, Color3.fromRGB(255, 255, 255), Color3.fromRGB(80, 80, 90), 90)
local winScale = new("UIScale", { Parent = Window, Scale = BASE })

local bgScale = UI.background(Window, 0.5)

local TopBar = new("Frame", {
	Parent = Window, Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1,
})
local headLine = new("Frame", {
	Parent = Window, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 42),
	Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0,
})
new("UIGradient", {
	Parent = headLine,
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.3),
		NumberSequenceKeypoint.new(1, 1),
	}),
})
local dragArea = new("Frame", {
	Parent = TopBar, Size = UDim2.new(1, -86, 1, 0), BackgroundTransparency = 1, Active = true,
})

local logo = new("Frame", {
	Parent = TopBar, Position = UDim2.fromOffset(12, 8), Size = UDim2.fromOffset(26, 26),
	BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true,
})
corner(logo, 8)
local logoImg = new("ImageLabel", {
	Parent = logo, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
	ScaleType = Enum.ScaleType.Crop, Image = "", BorderSizePixel = 0, ImageTransparency = 1,
})
corner(logoImg, 8)
UI.logo(logoImg)

local titleMain = new("TextLabel", {
	Parent = TopBar, Position = UDim2.fromOffset(48, 3), Size = UDim2.fromOffset(330, 24),
	BackgroundTransparency = 1, Text = "FLEXUSHUB AVATAR COPI", Font = Enum.Font.GothamBold,
	TextSize = 15, TextColor3 = WHITE, TextXAlignment = Enum.TextXAlignment.Left,
	TextStrokeTransparency = 0.88, TextStrokeColor3 = BLACK,
})
grad(titleMain, IC.title, IC.titleLow, 90)
new("TextLabel", {
	Parent = TopBar, Position = UDim2.fromOffset(48, 25), Size = UDim2.fromOffset(330, 14),
	BackgroundTransparency = 1, Text = "Flexus-Team", Font = Enum.Font.SourceSansBold,
	TextSize = 15, TextColor3 = IC.soft, TextXAlignment = Enum.TextXAlignment.Left,
})

local btnMin = UI.winButton(TopBar, "min", -44, IC.gold)
local btnClose = UI.winButton(TopBar, "close", -10, T.red)

UI.draggable(dragArea, Root)

local Left = new("Frame", {
	Parent = Window, Position = UDim2.fromOffset(12, 50), Size = UDim2.fromOffset(168, 308),
	BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.2, BorderSizePixel = 0,
})
corner(Left, 10)
stroke(Left, IC.gold, 1, 0.55)

local previewHolder = new("Frame", {
	Parent = Left, Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(152, 152),
	BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.35, BorderSizePixel = 0, ClipsDescendants = true,
})
corner(previewHolder, 6)
local prevStroke = stroke(previewHolder, WHITE, 1, 0.3)
grad(prevStroke, IC.gold, IC.btnLine, 45)
local preview = new("ImageLabel", {
	Parent = previewHolder, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
	Image = "", ScaleType = Enum.ScaleType.Fit, BorderSizePixel = 0,
})
local previewHint = new("TextLabel", {
	Parent = previewHolder, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
	Text = "Sin perfil", Font = Enum.Font.SourceSansSemibold, TextSize = 12, TextColor3 = IC.soft,
})

local nameLabel = new("TextLabel", {
	Parent = Left, Position = UDim2.fromOffset(8, 168), Size = UDim2.fromOffset(152, 18),
	BackgroundTransparency = 1, Text = "-", Font = Enum.Font.SourceSansBold, TextSize = 14,
	TextColor3 = IC.title, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
})
local idChip = new("Frame", {
	Parent = Left, Position = UDim2.fromOffset(8, 190), Size = UDim2.fromOffset(0, 16),
	AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = IC.btnBgMain, BackgroundTransparency = 0.45,
	BorderSizePixel = 0,
})
corner(idChip, 4)
new("UIPadding", { Parent = idChip, PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7) })
local idLabel = new("TextLabel", {
	Parent = idChip, Size = UDim2.fromOffset(0, 16), AutomaticSize = Enum.AutomaticSize.X,
	BackgroundTransparency = 1, Text = "ID: -", Font = Enum.Font.SourceSansSemibold, TextSize = 10,
	TextColor3 = IC.gold,
})

local statusDot = new("Frame", {
	Parent = Left, Position = UDim2.fromOffset(10, 216), Size = UDim2.fromOffset(6, 6),
	BackgroundColor3 = IC.soft, BorderSizePixel = 0,
})
corner(statusDot, 3)
local statusLabel = new("TextLabel", {
	Parent = Left, Position = UDim2.fromOffset(22, 210), Size = UDim2.fromOffset(140, 40),
	BackgroundTransparency = 1, Text = "Escribe un usuario o ID.", Font = Enum.Font.SourceSans,
	TextSize = 11, TextColor3 = IC.soft, TextWrapped = true, TextTruncate = Enum.TextTruncate.AtEnd,
	TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
})
local progressTrack = new("Frame", {
	Parent = Left, Position = UDim2.fromOffset(8, 256), Size = UDim2.fromOffset(152, 3),
	BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.3, BorderSizePixel = 0, ClipsDescendants = true,
})
corner(progressTrack, 2)
local progressFill = new("Frame", {
	Parent = progressTrack, Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = WHITE, BorderSizePixel = 0,
})
corner(progressFill, 2)
grad(progressFill, IC.gold, IC.goldLight, 0)

local function setStatus(text, color)
	statusLabel.Text = text
	statusLabel.TextColor3 = color or IC.soft
	statusDot.BackgroundColor3 = color or IC.soft
end

local function setProgress(p)
	tween(progressFill, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
		Size = UDim2.new(math.clamp(p, 0, 1), 0, 1, 0),
	})
end

local Right = new("Frame", {
	Parent = Window, Position = UDim2.fromOffset(188, 50), Size = UDim2.fromOffset(380, 308),
	BackgroundTransparency = 1,
})

local inputBox = new("Frame", {
	Parent = Right, Size = UDim2.fromOffset(250, 34), BackgroundColor3 = IC.btnBg,
	BackgroundTransparency = 0.4, BorderSizePixel = 0,
})
corner(inputBox, 4)
local inputStroke = stroke(inputBox, IC.btnLine, 1, 0.55)
local searchIcon = UI.icon("search", inputBox, IC.soft, 15)
searchIcon.root.Position = UDim2.fromOffset(10, 10)
local input = new("TextBox", {
	Parent = inputBox, Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -42, 1, 0),
	BackgroundTransparency = 1, BorderSizePixel = 0, Text = "", PlaceholderText = "Usuario o ID",
	PlaceholderColor3 = IC.soft, TextColor3 = IC.title, Font = Enum.Font.SourceSansSemibold,
	TextSize = 13, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
	ClipsDescendants = true,
})
input.Focused:Connect(function()
	tween(inputStroke, TweenInfo.new(0.15), { Color = IC.gold, Transparency = 0.2 })
	searchIcon.set(IC.gold)
end)
input.FocusLost:Connect(function()
	tween(inputStroke, TweenInfo.new(0.15), { Color = IC.btnLine, Transparency = 0.55 })
	searchIcon.set(IC.soft)
end)

local btnSearch = makeButton({
	parent = Right, text = "Buscar", size = UDim2.fromOffset(90, 34),
	pos = UDim2.fromOffset(288, 0), style = "main", textSize = 12,
})

local btnCopy = makeButton({
	parent = Right, text = "Copiar", icon = "copy", size = UDim2.fromOffset(90, 32),
	pos = UDim2.fromOffset(0, 42), style = "main", textSize = 11,
})
local btnSave = makeButton({
	parent = Right, text = "Guardar", icon = "plus", size = UDim2.fromOffset(90, 32),
	pos = UDim2.fromOffset(96, 42), style = "dark", textSize = 11,
})
local btnFav = makeButton({
	parent = Right, text = "Fav", icon = "star", size = UDim2.fromOffset(90, 32),
	pos = UDim2.fromOffset(192, 42), style = "dark", textSize = 11,
})
btnFav.icon.set(T.warn)
local btnRestore = makeButton({
	parent = Right, text = "Restaurar", icon = "back", size = UDim2.fromOffset(90, 32),
	pos = UDim2.fromOffset(288, 42), style = "dark", textSize = 11,
})

local tabBar = new("Frame", {
	Parent = Right, Position = UDim2.fromOffset(0, 82), Size = UDim2.fromOffset(380, 28),
	BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.3, BorderSizePixel = 0,
})
corner(tabBar, 4)
stroke(tabBar, IC.btnLine, 1, 0.65)

local tabStrokes = {}
local function makeTab(text, x, key)
	local t = new("TextButton", {
		Parent = tabBar, Position = UDim2.fromOffset(x, 2), Size = UDim2.fromOffset(100, 24),
		BackgroundColor3 = IC.btnBgMain, BackgroundTransparency = 1, AutoButtonColor = false,
		Text = text, Font = Enum.Font.SourceSansSemibold, TextSize = 11, TextColor3 = IC.soft, BorderSizePixel = 0,
	})
	corner(t, 3)
	tabStrokes[key] = stroke(t, IC.gold, 1, 1)
	return t
end
local tabSaved = makeTab("Guardados", 4, "saved")
local tabFavs = makeTab("Favoritos", 106, "favs")



local listFrame = new("ScrollingFrame", {
	Parent = Right, Position = UDim2.fromOffset(0, 118), Size = UDim2.fromOffset(380, 188),
	BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.4, BorderSizePixel = 0, ScrollBarThickness = 3,
	ScrollBarImageColor3 = IC.gold, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollingDirection = Enum.ScrollingDirection.Y, ClipsDescendants = true,
})
corner(listFrame, 8)
stroke(listFrame, IC.btnLine, 1, 0.65)
new("UIPadding", {
	Parent = listFrame, PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
	PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
})
new("UIListLayout", { Parent = listFrame, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })

local Modal = UI.modal(Window)

local current = nil
local busy = false
local applying = false
local thumbCache = {}
local pendingId = nil

local function getThumb(id, ttype, size)
	for i = 1, 4 do
		local ok, content, ready = pcall(Players.GetUserThumbnailAsync, Players, id, ttype, size)
		if ok and content and content ~= "" and (ready or i == 4) then return content end
		task.wait(0.25)
	end
end

local function headThumb(id)
	if thumbCache[id] then return thumbCache[id] end
	local c = getThumb(id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	thumbCache[id] = c
	return c
end

local function resolveUser(text)
	text = string.match(text or "", "^%s*(.-)%s*$")
	if text == "" then return nil, "Escribe un usuario o ID." end
	local id, name
	if text:match("^%d+$") then
		id = tonumber(text)
		local ok, n = pcall(Players.GetNameFromUserIdAsync, Players, id)
		if ok then
			name = n
		else
			local ok2, id2 = pcall(Players.GetUserIdFromNameAsync, Players, text)
			if ok2 then id = id2 else return nil, "ID no encontrado." end
		end
	else
		local ok, uid = pcall(Players.GetUserIdFromNameAsync, Players, text)
		if not ok then return nil, "Usuario no encontrado." end
		id = uid
	end
	if not name then
		local ok, n = pcall(Players.GetNameFromUserIdAsync, Players, id)
		name = ok and n or text
	end
	return id, name
end

local LEG_NAMES = {
	LeftFoot = true, RightFoot = true, LeftLowerLeg = true, RightLowerLeg = true,
	["Left Leg"] = true, ["Right Leg"] = true,
}

local STD_PARTS = {}
for _, n in ipairs({
	"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand",
	"RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
	"RightUpperLeg", "RightLowerLeg", "RightFoot", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg",
}) do
	STD_PARTS[n] = true
end

local State = {
	template = nil, desc = nil, shell = nil, sRoot = nil, shellParts = {}, char = nil,
	conns = {}, hidden = {}, pairList = {}, offset = CFrame.new(), fp = false, lastScan = 0,
	sAnimator = nil, mirror = {}, animActive = false, c0Dirty = false,
}

local Build = {}
local BuildOrder = {}
local MAX_BUILDS = 4

local function loadAsset(id)
	local obj
	local ok = pcall(function() obj = game:GetObjects("rbxassetid://" .. id)[1] end)
	if ok and obj then return obj end
	ok = pcall(function() obj = game:GetService("InsertService"):LoadAsset(id) end)
	if ok and obj then return obj end
end

local function findClass(obj, class)
	if not obj then return nil end
	if obj:IsA(class) then return obj end
	return obj:FindFirstChildWhichIsA(class, true)
end

local function preload(model)
	local list = {}
	for _, d in ipairs(model:GetDescendants()) do
		if d:IsA("MeshPart") or d:IsA("SpecialMesh") or d:IsA("Decal") or d:IsA("Texture")
			or d:IsA("SurfaceAppearance") or d:IsA("Shirt") or d:IsA("Pants") or d:IsA("ShirtGraphic") then
			list[#list + 1] = d
		end
	end
	if #list == 0 then return end
	withTimeout(15, function() ContentProvider:PreloadAsync(list) end)
end

local function buildFromAssets(desc)
	local model = Instance.new("Model")
	model.Name = "AvatarSource"
	local pending = 0
	local function async(fn)
		pending = pending + 1
		task.spawn(function()
			pcall(fn)
			pending = pending - 1
		end)
	end

	local bc = Instance.new("BodyColors")
	bc.HeadColor3 = desc.HeadColor
	bc.TorsoColor3 = desc.TorsoColor
	bc.LeftArmColor3 = desc.LeftArmColor
	bc.RightArmColor3 = desc.RightArmColor
	bc.LeftLegColor3 = desc.LeftLegColor
	bc.RightLegColor3 = desc.RightLegColor
	bc.Parent = model

	local function loadInto(id, class, rename)
		if id and id > 0 then
			async(function()
				local o = findClass(loadAsset(id), class)
				if o then
					if rename then o.Name = rename end
					o.Parent = model
				end
			end)
		end
	end
	loadInto(desc.Shirt, "Shirt")
	loadInto(desc.Pants, "Pants")
	loadInto(desc.GraphicTShirt, "ShirtGraphic")
	loadInto(desc.Face, "Decal", "face")

	local okA, accs = pcall(function() return desc:GetAccessories(true) end)
	if okA and type(accs) == "table" then
		for _, a in ipairs(accs) do
			if a.AssetId and a.AssetId > 0 then
				async(function()
					local acc = findClass(loadAsset(a.AssetId), "Accessory")
					if acc then
						local wl = acc:FindFirstChildWhichIsA("WrapLayer", true)
						if wl then
							if a.Order then wl.Order = a.Order end
							if a.Puffiness then wl.Puffiness = a.Puffiness end
						end
						acc.Parent = model
					end
				end)
			end
		end
	end

	local t0 = os.clock()
	while pending > 0 and os.clock() - t0 < 25 do task.wait(0.05) end
	return model
end

local function attachByAttachments(model, acc)
	local handle = acc:FindFirstChild("Handle")
	if not handle or not handle:IsA("BasePart") then
		acc.Parent = model
		return false
	end
	for _, d in ipairs(handle:GetChildren()) do
		if d:IsA("Weld") or d:IsA("Motor6D") or d:IsA("WeldConstraint") then d:Destroy() end
	end
	for _, a in ipairs(handle:GetChildren()) do
		if a:IsA("Attachment") then
			local target
			for _, p in ipairs(model:GetChildren()) do
				if p:IsA("BasePart") then
					local t = p:FindFirstChild(a.Name)
					if t and t:IsA("Attachment") then
						target = t
						break
					end
				end
			end
			if target then
				local w = Instance.new("Weld")
				w.Name = "AccessoryWeld"
				w.Part0 = handle
				w.Part1 = target.Parent
				w.C0 = a.CFrame
				w.C1 = target.CFrame
				w.Parent = handle
				acc.Parent = model
				return true
			end
		end
	end
	acc.Parent = model
	return false
end

local function prepShell(model)
	for _, d in ipairs(model:GetDescendants()) do
		if d:IsA("LuaSourceContainer") or d:IsA("Tool") or d:IsA("ForceField")
			or d:IsA("Sound") or d:IsA("BillboardGui") or d:IsA("SurfaceGui") then
			pcall(function() d:Destroy() end)
		end
	end
	for _, d in ipairs(model:GetDescendants()) do
		if d:IsA("BasePart") then
			pcall(function()
				d.Anchored = false
				d.CanCollide = false
				d.CanTouch = false
				d.CanQuery = false
				d.Massless = true
			end)
		end
	end
	local root = model:FindFirstChild("HumanoidRootPart")
	if root then root.Anchored = true end
	local h = model:FindFirstChildOfClass("Humanoid")
	if h then
		pcall(function() h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end)
		pcall(function() h.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff end)
		pcall(function() h.BreakJointsOnDeath = false end)
		pcall(function() h.RequiresNeck = false end)
		pcall(function() h.EvaluateStateMachine = false end)
		pcall(function() h.AutoRotate = false end)
		pcall(function() h.WalkSpeed = 0 end)
	end
end

local function templateFromDescription(desc, rig)
	for attempt = 1, 3 do
		local m = withTimeout(30, function()
			return Players:CreateHumanoidModelFromDescription(desc, rig)
		end)
		if typeof(m) == "Instance" then
			local h = m:FindFirstChildOfClass("Humanoid")
			if m:FindFirstChild("HumanoidRootPart") and h and h.RigType == rig then
				return m
			end
			pcall(function() m:Destroy() end)
		end
		task.wait(0.3)
	end
	return nil
end

local function templateFromAssets(desc, char)
	local base
	local okc = pcall(function()
		char.Archivable = true
		for _, d in ipairs(char:GetDescendants()) do
			pcall(function() d.Archivable = true end)
		end
		for inst, t in pairs(State.hidden) do
			if inst.Parent then inst.Transparency = t end
		end
		base = char:Clone()
		for inst in pairs(State.hidden) do
			if inst.Parent then inst.Transparency = 1 end
		end
	end)
	if not okc or not base then return nil end

	for _, d in ipairs(base:GetDescendants()) do
		if d:IsA("LuaSourceContainer") or d:IsA("Tool") or d:IsA("Accoutrement")
			or d:IsA("CharacterAppearance") or d:IsA("BillboardGui") or d:IsA("SurfaceGui")
			or d:IsA("Highlight") or d:IsA("ForceField") then
			pcall(function() d:Destroy() end)
		end
	end

	local src = buildFromAssets(desc)
	for _, c in ipairs(src:GetChildren()) do
		if c:IsA("CharacterAppearance") then c.Parent = base end
	end
	local head = base:FindFirstChild("Head")
	local face = src:FindFirstChild("face")
	if head and face then
		for _, d in ipairs(head:GetChildren()) do
			if d:IsA("Decal") then d:Destroy() end
		end
		face.Parent = head
	end
	for _, a in ipairs(src:GetChildren()) do
		if a:IsA("Accoutrement") then attachByAttachments(base, a) end
	end
	pcall(function() src:Destroy() end)
	return base
end

local function lowestLeg(model)
	local root = model:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local cf = { [root] = CFrame.identity }
	local joints = {}
	for _, d in ipairs(model:GetDescendants()) do
		if d:IsA("Motor6D") and d.Part0 and d.Part1 then joints[#joints + 1] = d end
	end
	local changed, guard = true, 0
	while changed and guard < 30 do
		changed = false
		guard = guard + 1
		for _, j in ipairs(joints) do
			local a, b = j.Part0, j.Part1
			if cf[a] and not cf[b] then
				cf[b] = cf[a] * j.C0 * j.C1:Inverse()
				changed = true
			elseif cf[b] and not cf[a] then
				cf[a] = cf[b] * j.C1 * j.C0:Inverse()
				changed = true
			end
		end
	end
	local low
	for p, c in pairs(cf) do
		if LEG_NAMES[p.Name] and p.Parent == model then
			local s = p.Size
			local ext = 0.5 * (math.abs(c.RightVector.Y) * s.X + math.abs(c.UpVector.Y) * s.Y + math.abs(c.LookVector.Y) * s.Z)
			local y = c.Position.Y - ext
			if not low or y < low then low = y end
		end
	end
	return low
end

local function hideReal(char)
	local function hide(p)
		if State.hidden[p] == nil then State.hidden[p] = p.Transparency end
		if p.Transparency ~= 1 then p.Transparency = 1 end
	end
	for _, c in ipairs(char:GetChildren()) do
		if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
			hide(c)
		elseif c:IsA("Accoutrement") then
			for _, d in ipairs(c:GetDescendants()) do
				if d:IsA("BasePart") then hide(d) end
			end
		end
	end
end

local function setShellLTM(v)
	for _, p in ipairs(State.shellParts) do
		pcall(function() p.LocalTransparencyModifier = v end)
	end
end

local function unmount()
	for _, c in ipairs(State.conns) do pcall(function() c:Disconnect() end) end
	State.conns = {}
	if State.shell then
		pcall(function() State.shell:Destroy() end)
	end
	for inst, t in pairs(State.hidden) do
		if inst.Parent then pcall(function() inst.Transparency = t end) end
	end
	State.shell, State.sRoot, State.char = nil, nil, nil
	State.shellParts, State.hidden, State.pairList = {}, {}, {}
	State.mirror, State.sAnimator, State.animActive, State.c0Dirty = {}, nil, false, false
	State.fp = false
end

local function noCollide()
	for _, p in ipairs(State.shellParts) do
		if p.CanCollide then p.CanCollide = false end
		if p.CanTouch then p.CanTouch = false end
		if p.CanQuery then p.CanQuery = false end
	end
end

local function poseTransform(rm)
	local p0, p1 = rm.Part0, rm.Part1
	if p0 and p1 then
		return (p0.CFrame * rm.C0):Inverse() * (p1.CFrame * rm.C1)
	end
	return rm.Transform
end

local function resetC0()
	for _, pr in ipairs(State.pairList) do
		local sm = pr[2]
		if sm.Parent then sm.C0 = pr[3] end
	end
	State.c0Dirty = false
end

local function syncPose()
	local shell, char = State.shell, State.char
	if not shell or not char or not char.Parent then return end
	if State.animActive then
		if State.c0Dirty then resetC0() end
		return
	end
	for _, pr in ipairs(State.pairList) do
		local rm, sm, baseC0 = pr[1], pr[2], pr[3]
		if rm.Parent and sm.Parent then
			local ok, tr = pcall(poseTransform, rm)
			if ok and tr then
				sm.C0 = baseC0 * tr
			end
		end
	end
	State.c0Dirty = true
end

local function mirrorAnimations()
	local char, shell, sAnim = State.char, State.shell, State.sAnimator
	if not char or not shell or not sAnim or not sAnim.Parent then
		State.animActive = false
		return
	end
	local rHum = char:FindFirstChildOfClass("Humanoid")
	local rAnim = rHum and rHum:FindFirstChildOfClass("Animator")
	if not rAnim then
		State.animActive = false
		return
	end
	local okT, tracks = pcall(function() return rAnim:GetPlayingAnimationTracks() end)
	if not okT or type(tracks) ~= "table" then
		State.animActive = false
		return
	end

	local seen, count = {}, 0
	for _, rt in ipairs(tracks) do
		local anim = rt.Animation
		if anim and anim.AnimationId ~= "" then
			seen[rt] = true
			local m = State.mirror[rt]
			if not m then
				local ok, st = pcall(function() return sAnim:LoadAnimation(anim) end)
				if ok and st then
					m = st
					State.mirror[rt] = st
					pcall(function()
						st.Priority = rt.Priority
						st.Looped = rt.Looped
						st:Play(0.1, math.max(rt.WeightCurrent, 0.01), rt.Speed)
					end)
				end
			end
			if m then
				pcall(function()
					if not m.IsPlaying then
						m:Play(0.1, math.max(rt.WeightCurrent, 0.01), rt.Speed)
					end
					m.Priority = rt.Priority
					m.Looped = rt.Looped
					m:AdjustWeight(math.max(rt.WeightCurrent, 0.01), 0)
					m:AdjustSpeed(rt.Speed)
					local len = rt.Length
					if len and len > 0 then
						local d = math.abs(m.TimePosition - rt.TimePosition)
						if rt.Looped then d = math.min(d, len - d) end
						if d > 0.25 then m.TimePosition = rt.TimePosition end
					end
				end)
				count = count + 1
			end
		end
	end

	for rt, st in pairs(State.mirror) do
		if not seen[rt] then
			pcall(function() st:Stop(0.1) end)
			State.mirror[rt] = nil
		end
	end

	State.animActive = count > 0
end

local function onStep()
	local shell, char, sRoot = State.shell, State.char, State.sRoot
	if not shell or not char or not sRoot or not char.Parent then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local want = workspace.CurrentCamera or workspace
	if shell.Parent ~= want then shell.Parent = want end

	for inst in pairs(State.hidden) do
		if inst.Parent and inst.Transparency ~= 1 then inst.Transparency = 1 end
	end

	noCollide()

	sRoot.CFrame = hrp.CFrame * State.offset

	mirrorAnimations()
	syncPose()

	local now = os.clock()
	if now - State.lastScan > 0.3 then
		State.lastScan = now
		hideReal(char)
	end

	local cam = workspace.CurrentCamera
	local head = char:FindFirstChild("Head")
	if cam and head then
		local fp = (cam.CFrame.Position - head.Position).Magnitude < 1.6
		if fp ~= State.fp then
			State.fp = fp
			setShellLTM(fp and 1 or 0)
		end
	end
end

local function mount(char, hum, template)
	unmount()
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return false, "Tu personaje no tiene raíz." end

	local shell = template:Clone()
	shell.Name = SHELL_NAME
	local sRoot = shell:FindFirstChild("HumanoidRootPart")
	if not sRoot then
		shell:Destroy()
		return false, "El avatar no tiene raíz."
	end

	local sh = shell:FindFirstChildOfClass("Humanoid")
	local sAnimator
	if sh then
		pcall(function() sh.WalkSpeed = 0 end)
		pcall(function() sh.JumpPower = 0 end)
		pcall(function() sh.AutoRotate = false end)
		sAnimator = sh:FindFirstChildOfClass("Animator")
		if not sAnimator then
			sAnimator = Instance.new("Animator")
			sAnimator.Parent = sh
		end
	end

	local list = {}
	for _, rm in ipairs(char:GetDescendants()) do
		if rm:IsA("Motor6D") and rm.Parent and rm.Parent.Parent == char then
			local sp = shell:FindFirstChild(rm.Parent.Name)
			local sm = sp and sp:FindFirstChild(rm.Name)
			if sm and sm:IsA("Motor6D") then
				list[#list + 1] = { rm, sm, sm.C0 }
			end
		end
	end

	local dy = 0
	local lowR, lowS = lowestLeg(char), lowestLeg(shell)
	if lowR and lowS then dy = math.clamp(lowR - lowS, -8, 8) end

	State.offset = CFrame.new(0, dy, 0)
	sRoot.Anchored = true
	shell.PrimaryPart = sRoot
	shell:PivotTo(hrp.CFrame * State.offset)

	local parts = {}
	for _, d in ipairs(shell:GetDescendants()) do
		if d:IsA("BasePart") then
			pcall(function()
				d.CanCollide = false
				d.CanTouch = false
				d.CanQuery = false
				d.Massless = true
			end)
			parts[#parts + 1] = d
		end
	end

	State.shell, State.sRoot, State.char = shell, sRoot, char
	State.sAnimator, State.mirror, State.animActive, State.c0Dirty = sAnimator, {}, false, false
	State.shellParts, State.pairList = parts, list
	State.fp = false
	shell.Parent = workspace.CurrentCamera or workspace

	hideReal(char)
	State.lastScan = os.clock()
	State.conns[#State.conns + 1] = RunService.RenderStepped:Connect(onStep)
	State.conns[#State.conns + 1] = RunService.Stepped:Connect(function()
		noCollide()
		syncPose()
	end)
	State.conns[#State.conns + 1] = RunService.Heartbeat:Connect(function()
		noCollide()
		syncPose()
	end)
	return true
end

local function verifyShell(char)
	local missing = {}
	local shell = State.shell
	if not shell then return { "sin modelo" } end
	for _, c in ipairs(char:GetChildren()) do
		if c:IsA("BasePart") and STD_PARTS[c.Name] and not shell:FindFirstChild(c.Name) then
			missing[#missing + 1] = c.Name
		end
	end
	if #State.pairList == 0 then missing[#missing + 1] = "uniones" end
	return missing
end

local function buildTemplate(desc, rig, char)
	local template, mode = templateFromDescription(desc, rig), "model"
	if not template then
		template, mode = templateFromAssets(desc, char), "assets"
	end
	if not template then return nil end

	prepShell(template)
	preload(template)
	return template, mode
end

local function evictBuilds()
	while #BuildOrder > MAX_BUILDS do
		local victim
		for i, id in ipairs(BuildOrder) do
			local b = Build[id]
			if b and b.state ~= "building" and b.template ~= State.template then
				victim = i
				break
			end
		end
		if not victim then return end
		local id = table.remove(BuildOrder, victim)
		local b = Build[id]
		Build[id] = nil
		if b and b.template then pcall(function() b.template:Destroy() end) end
	end
end

local function ensureBuild(entry)
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return nil end
	local rig = hum.RigType

	local b = Build[entry.id]
	if b and b.rig == rig and b.state ~= "failed" then return b end
	if b then
		local i = table.find(BuildOrder, entry.id)
		if i then table.remove(BuildOrder, i) end
		if b.template and b.template ~= State.template then
			pcall(function() b.template:Destroy() end)
		end
	end

	b = { state = "building", rig = rig }
	Build[entry.id] = b
	BuildOrder[#BuildOrder + 1] = entry.id

	task.spawn(function()
		local ok, t, mode = pcall(buildTemplate, entry.desc, rig, char)
		if ok and t then
			b.template, b.mode, b.state = t, mode, "ready"
		else
			b.state = "failed"
		end
		evictBuilds()
	end)
	return b
end

local function search(text)
	if busy then return false end
	busy = true
	setStatus("Buscando usuario...", IC.soft)
	setProgress(0.2)
	local id, name = resolveUser(text)
	if not id then
		setStatus(name, T.red)
		setProgress(0)
		busy = false
		return false
	end

	pendingId = id
	preview.Image = ""
	preview.ImageTransparency = 0
	previewHint.Text = "Cargando..."
	previewHint.Visible = true
	task.spawn(function()
		local img = getThumb(id, Enum.ThumbnailType.AvatarThumbnail, Enum.ThumbnailSize.Size420x420)
		if pendingId == id then
			if img then
				preview.ImageTransparency = 1
				preview.Image = img
				tween(preview, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { ImageTransparency = 0 })
			else
				preview.Image = ""
			end
			previewHint.Text = "Sin vista previa"
			previewHint.Visible = not img
		end
	end)

	local desc
	for _ = 1, 3 do
		local ok, d = pcall(Players.GetHumanoidDescriptionFromUserId, Players, id)
		if ok and d then
			desc = d
			break
		end
		task.wait(0.3)
	end
	if not desc then
		setStatus("No se pudo obtener el avatar.", T.red)
		setProgress(0)
		busy = false
		return false
	end

	current = { id = id, name = name, desc = desc }
	nameLabel.Text = name
	idLabel.Text = "ID: " .. tostring(id)
	setStatus("Avatar listo. Pulsa Copiar.", T.green)
	setProgress(1)
	task.delay(0.6, function() setProgress(0) end)

	ensureBuild(current)

	busy = false
	return true
end

local function applyAvatar(entry)
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return false, "No se encontró tu personaje." end
	local rig = hum.RigType

	local b = ensureBuild(entry)
	if not b then return false, "No se encontró tu personaje." end

	if b.state == "building" then
		setStatus("Cargando avatar...", IC.soft)
		local t0 = os.clock()
		while b.state == "building" do
			setProgress(math.min(0.85, 0.15 + (os.clock() - t0) / 20))
			task.wait(0.1)
		end
	end
	if b.state ~= "ready" or not b.template then
		Build[entry.id] = nil
		local i = table.find(BuildOrder, entry.id)
		if i then table.remove(BuildOrder, i) end
		return false, "No se pudo armar el avatar."
	end
	local template, mode = b.template, b.mode
	setProgress(0.9)

	char = LocalPlayer.Character
	hum = char and char:FindFirstChildOfClass("Humanoid")
	hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return false, "Tu personaje cambió. Inténtalo de nuevo." end

	State.template = template
	State.desc = entry.desc

	setStatus("Aplicando...", IC.soft)

	local ok, err = mount(char, hum, template)
	if not ok then return false, tostring(err) end

	-- Copiar animaciones del objetivo (HumanoidDescription + Animate)
	pcall(function()
		if not entry.desc or not hum then return end
		local targetDesc = entry.desc
		local myDesc = hum:GetAppliedDescription()
		if not myDesc or not targetDesc then return end
		local animProps = {
			"IdleAnimation", "WalkAnimation", "RunAnimation", "JumpAnimation",
			"FallAnimation", "ClimbAnimation", "SwimAnimation", "MoodAnimation",
		}
		for _, prop in ipairs(animProps) do
			pcall(function()
				local v = targetDesc[prop]
				if v ~= nil and v ~= 0 and v ~= "" then
					myDesc[prop] = v
				end
			end)
		end
		pcall(function() hum:ApplyDescription(myDesc) end)
	end)

-- Si el template trae script Animate, copiar valores de animacion
	pcall(function()
		local srcAnimate = template:FindFirstChild("Animate")
		local dstAnimate = char:FindFirstChild("Animate")
		if srcAnimate and dstAnimate then
			for _, child in ipairs(srcAnimate:GetChildren()) do
				local d = dstAnimate:FindFirstChild(child.Name)
				if d and child:IsA("StringValue") and d:IsA("StringValue") then
					d.Value = child.Value
				elseif d and child:IsA("NumberValue") and d:IsA("NumberValue") then
					d.Value = child.Value
				elseif child:IsA("Folder") or child:IsA("StringValue") then
					-- nested anim values
					local function copyFolder(src, dst)
						for _, c in ipairs(src:GetChildren()) do
							local t = dst:FindFirstChild(c.Name)
							if t and c:IsA("StringValue") and t:IsA("StringValue") then
								t.Value = c.Value
							elseif t and c:IsA("Animation") and t:IsA("Animation") then
								t.AnimationId = c.AnimationId
							elseif c:IsA("Folder") and t then
								copyFolder(c, t)
							end
						end
					end
					if d then copyFolder(child, d) end
				end
			end
		end
	end)

	setProgress(1)
	task.delay(0.6, function() setProgress(0) end)

	local note = ""
	if rig ~= Enum.HumanoidRigType.R15 then note = note .. " | R6" end
	if mode == "assets" then note = note .. " | básico" end
	local missing = verifyShell(char)
	if #missing > 0 then
		note = note .. " | " .. #missing .. " avisos"
	end
	return true, note
end

local function restoreAvatar()
	unmount()
	State.template, State.desc = nil, nil
end

local function copyCurrent()
	if applying then return end
	if not current then setStatus("Primero busca un avatar.", T.warn) return end
	applying = true
	local cur = current
	setStatus("Copiando avatar...", IC.soft)
	local ok, success, info = pcall(applyAvatar, cur)
	if not ok then
		setStatus("Error: " .. tostring(success), T.red)
		setProgress(0)
	elseif success then
		setStatus("Avatar aplicado: " .. cur.name .. info, T.green)
	else
		setStatus(tostring(info), T.red)
		setProgress(0)
	end
	applying = false
end

track(LocalPlayer.CharacterAdded:Connect(function(char)
	unmount()
	local hum = char:WaitForChild("Humanoid", 15)
	if not hum then return end
	local hrp = char:WaitForChild("HumanoidRootPart", 15)
	if not hrp then return end
	char:WaitForChild("Animate", 4)
	task.wait(0.4)
	if LocalPlayer.Character ~= char or not State.template then return end
	while applying do task.wait(0.2) end
	local th = State.template:FindFirstChildOfClass("Humanoid")
	if not th or th.RigType ~= hum.RigType then return end
	local ok = mount(char, hum, State.template)
	if ok then
		setStatus("Avatar reaplicado.", T.green)
	end
end))

local activeTab = "saved"
local refreshList

local function indexOf(list, id)
	for i, e in ipairs(list) do
		if e.id == id then return i end
	end
end

local function addTo(listName)
	if not current then setStatus("Primero busca un avatar.", T.warn) return end
	local list = data[listName]
	if indexOf(list, current.id) then
		setStatus("Ya está en " .. (listName == "saved" and "guardados." or "favoritos."), T.warn)
		return
	end
	table.insert(list, { id = current.id, name = current.name })
	saveData()
	refreshList()
	setStatus((listName == "saved" and "Guardado: " or "Favorito: ") .. current.name, T.green)
end

local function removeFrom(listName, id)
	local i = indexOf(data[listName], id)
	if i then
		table.remove(data[listName], i)
		saveData()
		refreshList()
		setStatus("Eliminado de la lista.", IC.soft)
	end
end

local function confirmRemove(listName, entry)
	Modal.show({
		title = "¿Seguro que quieres borrarlo?",
		text = "Se eliminará " .. entry.name .. " de " .. (listName == "saved" and "tus guardados." or "tus favoritos."),
		leftText = "Volver", leftStyle = "dark",
		rightText = "Borrar", rightStyle = "danger",
		onRight = function() removeFrom(listName, entry.id) end,
	})
end

local function useEntry(entry)
	if search(tostring(entry.id)) then copyCurrent() end
end

local ROW_W = 360

local function buildRow(entry, listName, order)
	local row = new("Frame", {
		Parent = listFrame, Size = UDim2.fromOffset(ROW_W, 42), BackgroundColor3 = IC.btnBg,
		BackgroundTransparency = 0.35, BorderSizePixel = 0, LayoutOrder = order,
	})
	corner(row, 4)
	stroke(row, IC.btnLine, 1, 0.7)

	local thumb = new("ImageLabel", {
		Parent = row, Position = UDim2.fromOffset(6, 6), Size = UDim2.fromOffset(30, 30),
		BackgroundColor3 = IC.btnBg, BorderSizePixel = 0, Image = "", ImageTransparency = 1,
		ScaleType = Enum.ScaleType.Crop,
	})
	corner(thumb, 15)
	stroke(thumb, IC.gold, 1, 0.5)
	local cachedThumb = thumbCache[entry.id]
	if cachedThumb then
		thumb.Image = cachedThumb
		thumb.ImageTransparency = 0
	else
		task.spawn(function()
			local c = headThumb(entry.id)
			if c and thumb.Parent then
				thumb.Image = c
				tween(thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { ImageTransparency = 0 })
			end
		end)
	end

		-- Botones siempre visibles: Usar | Fav(opcional) | Eliminar
	local hasFavBtn = (listName == "saved")
	local btnsW = hasFavBtn and 120 or 88
	local nameW = ROW_W - 44 - btnsW - 8
	new("TextLabel", {
		Parent = row, Position = UDim2.fromOffset(44, 5), Size = UDim2.fromOffset(nameW, 18),
		BackgroundTransparency = 1, Text = entry.name, Font = Enum.Font.GothamBold, TextSize = 12,
		TextColor3 = IC.title, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
	})
	new("TextLabel", {
		Parent = row, Position = UDim2.fromOffset(44, 22), Size = UDim2.fromOffset(nameW, 14),
		BackgroundTransparency = 1, Text = tostring(entry.id), Font = Enum.Font.Gotham, TextSize = 10,
		TextColor3 = IC.soft, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
	})

	local box = new("Frame", {
		Parent = row, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -4, 0.5, 0),
		Size = UDim2.fromOffset(btnsW, 30), BackgroundTransparency = 1,
	})
	new("UIListLayout", {
		Parent = box, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4),
		HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local use = makeButton({
		parent = box, text = "Usar", size = UDim2.fromOffset(48, 28), style = "main",
		textSize = 11, order = 1, radius = 4,
	})
	use.btn.MouseButton1Click:Connect(function() task.spawn(useEntry, entry) end)

	if hasFavBtn then
		local inFavs = indexOf(data.favs, entry.id) ~= nil
		local fav = makeButton({
			parent = box, icon = "star", iconSize = 14, size = UDim2.fromOffset(28, 28),
			style = "dark", order = 2, radius = 4,
		})
		fav.icon.set(inFavs and T.warn or IC.soft)
		fav.btn.MouseButton1Click:Connect(function()
			if indexOf(data.favs, entry.id) then
				setStatus("Ya está en favoritos.", T.warn)
			else
				table.insert(data.favs, { id = entry.id, name = entry.name })
				saveData()
				refreshList()
				setStatus("Favorito: " .. entry.name, T.green)
			end
		end)
	end

	local del = makeButton({
		parent = box, icon = "trash", iconSize = 15, size = UDim2.fromOffset(28, 28),
		style = "danger", iconColor = T.red, iconHover = WHITE, order = 3, radius = 4,
	})
	del.btn.MouseButton1Click:Connect(function() confirmRemove(listName, entry) end)
end


function refreshList()
	for _, c in ipairs(listFrame:GetChildren()) do
		if c:IsA("Frame") or c:IsA("TextLabel") then c:Destroy() end
	end
	local list = data[activeTab]
	tabSaved.Text = "Guardados (" .. #data.saved .. ")"
	tabFavs.Text = "Favoritos (" .. #data.favs .. ")"
	if #list == 0 then
		new("TextLabel", {
			Parent = listFrame, Size = UDim2.fromOffset(ROW_W, 100), BackgroundTransparency = 1,
			Text = activeTab == "saved" and "No hay avatares guardados." or "No hay favoritos.",
			Font = Enum.Font.SourceSansSemibold, TextSize = 12, TextColor3 = IC.soft,
		})
		return
	end
	for i, e in ipairs(list) do buildRow(e, activeTab, i) end
end

local function setTab(name)
	activeTab = name
	local info = TweenInfo.new(0.15)
	tween(tabSaved, info, {
		BackgroundTransparency = name == "saved" and 0.25 or 1,
		TextColor3 = name == "saved" and WHITE or IC.soft,
	})
	tween(tabFavs, info, {
		BackgroundTransparency = name == "favs" and 0.25 or 1,
		TextColor3 = name == "favs" and WHITE or IC.soft,
	})
	tween(tabStrokes.saved, info, { Transparency = name == "saved" and 0.4 or 1 })
	tween(tabStrokes.favs, info, { Transparency = name == "favs" and 0.4 or 1 })
	listFrame.CanvasPosition = Vector2.new(0, 0)
	refreshList()
end

btnSearch.btn.MouseButton1Click:Connect(function() task.spawn(search, input.Text) end)
input.FocusLost:Connect(function(enter)
	if enter then task.spawn(search, input.Text) end
end)
btnCopy.btn.MouseButton1Click:Connect(function() task.spawn(copyCurrent) end)
btnSave.btn.MouseButton1Click:Connect(function() addTo("saved") end)
btnFav.btn.MouseButton1Click:Connect(function() addTo("favs") end)
tabSaved.MouseButton1Click:Connect(function() setTab("saved") end)
tabFavs.MouseButton1Click:Connect(function() setTab("favs") end)

btnRestore.btn.MouseButton1Click:Connect(function()
	if applying then return end
	applying = true
	setStatus("Restaurando...", IC.soft)
	task.spawn(function()
		local ok, err = pcall(restoreAvatar)
		if ok then
			setStatus("Avatar restaurado.", T.green)
		else
			setStatus("Error: " .. tostring(err), T.red)
		end
		setProgress(0)
		applying = false
	end)
end)

setTab("saved")

local FS = 48
local floatRoot = new("Frame", {
	Parent = gui, Size = UDim2.fromOffset(FS, FS), Position = UDim2.fromOffset(18, 120),
	BackgroundTransparency = 1, Visible = false, Active = true,
})
-- Boton flotante: letra F
local floatBtn = new("TextButton", {
	Parent = floatRoot, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.fromRGB(16, 20, 30),
	BackgroundTransparency = 0.05,
	AutoButtonColor = false,
	Text = "",
	BorderSizePixel = 0,
	ClipsDescendants = true,
})
corner(floatBtn, 14)
local floatStroke = stroke(floatBtn, IC.gold, 1.6, 0.3)
grad(floatStroke, IC.gold, Color3.fromRGB(40, 80, 120), 45)
-- glow suave
local floatGlow = new("Frame", {
	Parent = floatBtn,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(0.72, 0.72),
	BackgroundColor3 = IC.gold,
	BackgroundTransparency = 0.88,
	BorderSizePixel = 0,
	ZIndex = 1,
})
corner(floatGlow, 10)
local floatLetter = new("TextLabel", {
	Parent = floatBtn,
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Text = "F",
	Font = Enum.Font.GothamBlack,
	TextSize = 28,
	TextColor3 = Color3.fromRGB(200, 245, 255),
	TextStrokeTransparency = 0.7,
	TextStrokeColor3 = Color3.fromRGB(0, 40, 60),
	BorderSizePixel = 0,
	Active = false,
	ZIndex = 3,
})
local floatScale = new("UIScale", { Parent = floatBtn, Scale = 1 })

-- hover simple
floatBtn.MouseEnter:Connect(function()
	if touchOnly then return end
	tween(floatBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(32, 42, 58) })
	tween(floatStroke, TweenInfo.new(0.12), { Transparency = 0.15 })
end)
floatBtn.MouseLeave:Connect(function()
	tween(floatBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(22, 26, 36) })
	tween(floatStroke, TweenInfo.new(0.12), { Transparency = 0.35 })
end)

local token = 0
local floatPlaced = false
local TI_CLOSE = TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
local TI_FLOAT_OUT = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

local function floatDelta()
	local fx = floatRoot.Position.X.Offset + FS / 2
	local fy = floatRoot.Position.Y.Offset + FS / 2
	local rx = Root.Position.X.Offset + (W * BASE) / 2
	local ry = Root.Position.Y.Offset + (H * BASE) / 2
	return fx - rx, fy - ry
end

local function openWindow()
	token = token + 1
	local my = token
	Root.Visible = true
	Window.GroupTransparency = 0
	Window.Position = UDim2.fromScale(0.5, 0.5)
	winScale.Scale = BASE
	-- Layout fijo (controles izq, preview der) — sin animacion de entrada
	Left.Position = UDim2.fromOffset(12, 52)
	Right.Position = UDim2.fromOffset(224, 52)
	headLine.Size = UDim2.new(1, 0, 0, 1)
	if bgScale then bgScale.Scale = 1 end
	floatRoot.Visible = false
	floatScale.Scale = 1
end

local function minimizeWindow()
	token = token + 1
	local my = token
	if not floatPlaced then
		local vp = UI.viewport()
		local cx = Root.Position.X.Offset + (W * BASE) / 2 - FS / 2
		local cy = Root.Position.Y.Offset + (H * BASE) / 2 - FS / 2
		floatRoot.Position = UDim2.fromOffset(
			math.clamp(cx, 0, math.max(0, vp.X - FS)),
			math.clamp(cy, 0, math.max(0, vp.Y - FS))
		)
		floatPlaced = true
	end
	floatRoot.Visible = true
	floatScale.Scale = 1
	Root.Visible = false
	Window.GroupTransparency = 1
	Window.Position = UDim2.fromScale(0.5, 0.5)
	winScale.Scale = BASE
end

UI.draggable(floatBtn, floatRoot, openWindow,
	function()
		tween(floatScale, TweenInfo.new(0.08), { Scale = 0.94 })
	end,
	function()
		tween(floatScale, TweenInfo.new(0.12), { Scale = 1 })
	end)

btnMin.MouseButton1Click:Connect(minimizeWindow)

local function destroyAll()
	pcall(restoreAvatar)
	for _, b in pairs(Build) do
		if b.template then pcall(function() b.template:Destroy() end) end
	end
	Build, BuildOrder = {}, {}
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	conns = {}
	if gui then gui:Destroy() end
	env.FlexusAvatarCleanup = nil
end
env.FlexusAvatarCleanup = destroyAll

btnClose.MouseButton1Click:Connect(function()
	Modal.show({
		title = "¿Seguro que quieres cerrar?",
		text = "Al cerrar tendrás que volver a ejecutar el script para abrir la herramienta.",
		leftText = "Abrir de nuevo", leftStyle = "main",
		rightText = "Cerrar GUI", rightStyle = "danger",
		onRight = function()
			tween(winScale, TI_CLOSE, { Scale = BASE * 0.85 })
			tween(Window, TI_CLOSE, { GroupTransparency = 1 }).Completed:Connect(destroyAll)
		end,
	})
end)

-- Abrir menu al instante (sin intro)
Root.Visible = true
Window.GroupTransparency = 0
winScale.Scale = BASE
Window.Position = UDim2.fromScale(0.5, 0.5)
Left.Position = UDim2.fromOffset(12, 50)
Right.Position = UDim2.fromOffset(188, 50)
headLine.Size = UDim2.new(1, 0, 0, 1)
floatRoot.Visible = false
floatScale.Scale = 1
