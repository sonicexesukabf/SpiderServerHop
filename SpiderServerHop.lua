
--[[
    SPIDER SERVER HOP — by Sonic Exe
    Theme: VOID X
    Purple Futuristic + Red Accent
    Mobile Friendly | Draggable | Minimize / Reopen
    Public Server Browser | TikTok Button
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local TIKTOK_URL = "https://www.tiktok.com/@sonic.exereal1"

local PURPLE = Color3.fromRGB(145, 75, 255)
local DARK = Color3.fromRGB(17, 13, 28)
local PANEL = Color3.fromRGB(29, 22, 44)
local RED = Color3.fromRGB(255, 65, 85)
local WHITE = Color3.fromRGB(245, 240, 255)
local MUTED = Color3.fromRGB(170, 155, 195)
local GREEN = Color3.fromRGB(100, 255, 170)

local old = playerGui:FindFirstChild("SpiderServerHop")
if old then
    old:Destroy()
end

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius or 12)
    }, obj)
end

local function stroke(obj, color, thickness, transparency)
    return create("UIStroke", {
        Color = color or PURPLE,
        Thickness = thickness or 1,
        Transparency = transparency or 0
    }, obj)
end

local function makeButton(parent, text, color, size, position)
    local b = create("TextButton", {
        Size = size,
        Position = position,
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = WHITE,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = true
    }, parent)
    corner(b, 10)
    return b
end

-- MAIN GUI
local gui = create("ScreenGui", {
    Name = "SpiderServerHop",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999
}, playerGui)

local panel = create("Frame", {
    Name = "MainPanel",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 320, 0, 455),
    BackgroundColor3 = DARK,
    BackgroundTransparency = 0.04,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, gui)

corner(panel, 18)
stroke(panel, PURPLE, 1.6, 0.12)

local scale = create("UIScale", {
    Scale = 1
}, panel)

local function updateScale()
    local cam = workspace.CurrentCamera
    if not cam then return end

    local viewport = cam.ViewportSize
    scale.Scale = math.clamp(
        math.min(viewport.X / 360, viewport.Y / 510),
        0.68,
        1
    )
end

updateScale()

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

-- HEADER
local header = create("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 74),
    BackgroundColor3 = Color3.fromRGB(42, 27, 66),
    BorderSizePixel = 0
}, panel)

create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 35, 105)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 20, 42))
    }),
    Rotation = 0
}, header)

create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 14, 0, 8),
    Size = UDim2.new(1, -65, 0, 28),
    Text = "SPIDER SERVER HOP",
    TextColor3 = WHITE,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold
}, header)

create("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 38),
    Size = UDim2.new(1, -70, 0, 20),
    Text = "by Sonic Exe  •  VOID X",
    TextColor3 = MUTED,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamMedium
}, header)

local minimize = makeButton(
    header, "—", RED,
    UDim2.new(0, 34, 0, 30),
    UDim2.new(1, -45, 0, 14)
)
minimize.TextSize = 20

-- STATUS
local status = create("TextLabel", {
    Name = "Status",
    Position = UDim2.new(0, 13, 0, 82),
    Size = UDim2.new(1, -26, 0, 25),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    Text = "●  READY TO SCAN",
    TextColor3 = GREEN,
    TextSize = 11,
    Font = Enum.Font.GothamBold
}, panel)
corner(status, 8)

-- REFRESH
local refresh = makeButton(
    panel, "↻  REFRESH SERVERS", PURPLE,
    UDim2.new(1, -26, 0, 36),
    UDim2.new(0, 13, 0, 115)
)

-- LOW PLAYER FILTER
local lowButton = makeButton(
    panel, "LOW PLAYERS: 1–2", Color3.fromRGB(91, 38, 60),
    UDim2.new(1, -26, 0, 31),
    UDim2.new(0, 13, 0, 158)
)
lowButton.TextSize = 12

-- TIKTOK BUTTON
local tiktokButton = makeButton(
    panel, "♪  MY TIKTOK  •  @sonic.exereal1", RED,
    UDim2.new(1, -26, 0, 31),
    UDim2.new(0, 13, 0, 196)
)
tiktokButton.TextSize = 11

tiktokButton.Activated:Connect(function()
    local copied = false

    -- Copy link if the script environment supports it.
    if typeof(setclipboard) == "function" then
        copied = pcall(function()
            setclipboard(TIKTOK_URL)
        end)
    end

    if copied then
        status.Text = "●  TIKTOK LINK COPIED"
        status.TextColor3 = GREEN
    else
        status.Text = "●  TIKTOK: @sonic.exereal1"
        status.TextColor3 = RED
        warn("TikTok profile: " .. TIKTOK_URL)
    end
end)

-- SERVER COUNT
local countLabel = create("TextLabel", {
    Position = UDim2.new(0, 14, 0, 234),
    Size = UDim2.new(1, -28, 0, 20),
    BackgroundTransparency = 1,
    Text = "PUBLIC SERVERS  •  0 FOUND",
    TextColor3 = MUTED,
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, panel)

-- SERVER LIST
local list = create("ScrollingFrame", {
    Name = "ServerList",
    Position = UDim2.new(0, 12, 0, 257),
    Size = UDim2.new(1, -24, 1, -269),
    BackgroundColor3 = PANEL,
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = PURPLE,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
}, panel)

corner(list, 12)

create("UIPadding", {
    PaddingTop = UDim.new(0, 8),
    PaddingBottom = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8)
}, list)

create("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder
}, list)

-- REOPEN ICON
local reopen = create("TextButton", {
    Name = "ReopenIcon",
    AnchorPoint = Vector2.new(0, 0),
    Position = UDim2.new(0, 18, 0.5, -24),
    Size = UDim2.new(0, 52, 0, 52),
    BackgroundColor3 = Color3.fromRGB(39, 24, 58),
    BorderSizePixel = 0,
    Text = "VX",
    TextColor3 = WHITE,
    TextSize = 18,
    Font = Enum.Font.GothamBlack,
    Visible = false,
    ZIndex = 20
}, gui)

corner(reopen, 18)
stroke(reopen, RED, 2, 0)

-- DRAG SUPPORT: PANEL AND ICON
local function makeDraggable(target, handle, onClick)
    local dragging = false
    local moved = false
    local startPos
    local startInputPos
    local activeInput
    local endConnection

    handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        dragging = true
        moved = false
        activeInput = input
        startInputPos = input.Position
        startPos = target.Position

        if endConnection then
            endConnection:Disconnect()
        end

        endConnection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false

                if endConnection then
                    endConnection:Disconnect()
                    endConnection = nil
                end

                if not moved and onClick then
                    onClick()
                end
            end
        end)
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging then return end

        local matchesMouse = activeInput
            and activeInput.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseMovement

        local matchesTouch = activeInput
            and activeInput.UserInputType == Enum.UserInputType.Touch
            and input == activeInput

        if not matchesMouse and not matchesTouch then
            return
        end

        local delta = input.Position - startInputPos

        if math.abs(delta.X) + math.abs(delta.Y) > 5 then
            moved = true
        end

        target.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end)
end

makeDraggable(panel, header)

makeDraggable(reopen, reopen, function()
    panel.Visible = true
    reopen.Visible = false
end)

minimize.Activated:Connect(function()
    panel.Visible = false
    reopen.Visible = true
end)

-- SERVER BROWSER
local scanning = false
local lowOnly = true

local function setStatus(text, color)
    status.Text = "●  " .. text
    status.TextColor3 = color or MUTED
end

local function clearList()
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

local function addMessage(text)
    create("TextLabel", {
        Size = UDim2.new(1, -4, 0, 48),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = MUTED,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextWrapped = true
    }, list)
end

local function getRequestFunction()
    if typeof(request) == "function" then
        return request
    end

    if typeof(http_request) == "function" then
        return http_request
    end

    if typeof(syn) == "table"
        and typeof(syn.request) == "function" then
        return syn.request
    end

    return nil
end

local function fetchServers()
    if scanning then return end

    scanning = true
    refresh.Text = "SCANNING..."
    clearList()
    addMessage("Mengambil daftar server publik...")
    setStatus("SCANNING SERVERS", PURPLE)

    task.spawn(function()
        local requestFn = getRequestFunction()

        if not requestFn then
            clearList()
            addMessage("HTTP request tidak tersedia di lingkungan ini.")
            setStatus("HTTP REQUEST UNSUPPORTED", RED)
            scanning = false
            refresh.Text = "↻  REFRESH SERVERS"
            return
        end

        local placeId = game.PlaceId
        local cursor = ""
        local found = {}
        local seen = {}
        local pages = 0

        repeat
            pages += 1

            local url = "https://games.roblox.com/v1/games/"
                .. tostring(placeId)
                .. "/servers/Public?sortOrder=Asc&limit=100"

            if cursor ~= "" then
                url = url .. "&cursor=" .. HttpService:UrlEncode(cursor)
            end

            local ok, response = pcall(function()
                return requestFn({
                    Url = url,
                    Method = "GET"
                })
            end)

            if not ok or type(response) ~= "table" then
                break
            end

            local body = response.Body or response.body
            if type(body) ~= "string" then
                break
            end

            local decodedOk, data = pcall(function()
                return HttpService:JSONDecode(body)
            end)

            if not decodedOk or type(data) ~= "table" then
                break
            end

            for _, server in ipairs(data.data or {}) do
                local id = server.id
                local playing = tonumber(server.playing) or 0
                local maxPlayers = tonumber(server.maxPlayers) or 0

                if id and id ~= game.JobId and not seen[id]
                    and playing < maxPlayers then

                    seen[id] = true

                    if not lowOnly or playing <= 2 then
                        table.insert(found, {
                            id = id,
                            playing = playing,
                            maxPlayers = maxPlayers
                        })
                    end
                end
            end

            cursor = data.nextPageCursor or ""
        until cursor == "" or pages >= 5

        table.sort(found, function(a, b)
            if a.playing == b.playing then
                return a.maxPlayers < b.maxPlayers
            end
            return a.playing < b.playing
        end)

        clearList()

        if #found == 0 then
            addMessage("Server tidak ditemukan. Coba refresh lagi.")
            setStatus("NO SERVERS FOUND", RED)
        else
            setStatus("SCAN COMPLETE", GREEN)

            for index, server in ipairs(found) do
                local item = create("TextButton", {
                    Name = "Server_" .. index,
                    Size = UDim2.new(1, -4, 0, 57),
                    BackgroundColor3 = Color3.fromRGB(38, 28, 56),
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = true,
                    LayoutOrder = index
                }, list)

                corner(item, 10)
                stroke(item, index == 1 and RED or PURPLE, 1, 0.35)

                create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 7),
                    Size = UDim2.new(1, -82, 0, 21),
                    Text = "SERVER #" .. index,
                    TextColor3 = WHITE,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, item)

                create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 29),
                    Size = UDim2.new(1, -82, 0, 17),
                    Text = "ID: " .. string.sub(server.id, 1, 13) .. "...",
                    TextColor3 = MUTED,
                    TextSize = 10,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, item)

                local playerCount = create("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -9, 0.5, 0),
                    Size = UDim2.new(0, 62, 0, 28),
                    BackgroundColor3 = server.playing <= 2
                        and Color3.fromRGB(89, 33, 52)
                        or Color3.fromRGB(58, 40, 85),
                    BorderSizePixel = 0,
                    Text = tostring(server.playing)
                        .. "/" .. tostring(server.maxPlayers),
                    TextColor3 = WHITE,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold
                }, item)

                corner(playerCount, 8)

                item.Activated:Connect(function()
                    setStatus("TELEPORTING...", RED)

                    local okTeleport, err = pcall(function()
                        TeleportService:TeleportToPlaceInstance(
                            placeId,
                            server.id,
                            player
                        )
                    end)

                    if not okTeleport then
                        setStatus("TELEPORT FAILED", RED)
                        warn("Teleport failed:", err)
                    end
                end)
            end
        end

        countLabel.Text = "PUBLIC SERVERS  •  " .. #found .. " FOUND"
        scanning = false
        refresh.Text = "↻  REFRESH SERVERS"
    end)
end

refresh.Activated:Connect(fetchServers)

lowButton.Activated:Connect(function()
    lowOnly = not lowOnly

    lowButton.Text = lowOnly
        and "LOW PLAYERS: 1–2"
        or "SHOW ALL SERVERS"

    lowButton.BackgroundColor3 = lowOnly
        and Color3.fromRGB(91, 38, 60)
        or Color3.fromRGB(65, 40, 95)

    fetchServers()
end)

setStatus("READY TO SCAN", GREEN)
countLabel.Text = "PUBLIC SERVERS  •  0 FOUND"

