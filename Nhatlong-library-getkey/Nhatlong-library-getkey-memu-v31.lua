--[[
================================================================
             NHATLONG LIBRARY V30+ GETKEY UPDATE
================================================================

BASE:
Nhatlong-library-v30.lua

ARCHITECTURE:
---------------------------------------------------------------
1. Library ONLY
   -> Main Library

2. GetKey ONLY
   -> GetKey
   -> Valid Key
   -> Close GetKey
   -> Nothing else

3. GetKey -> Library
   -> GetKey
   -> Valid Key
   -> Close GetKey
   -> Main Library

4. GetKey -> Custom Menu
   -> GetKey
   -> Valid Key
   -> Close GetKey
   -> Custom Menu

IMPORTANT:
---------------------------------------------------------------
OpenLibraryAfterSuccess must be TRUE if GetKey should open
the Main Library after successful verification.

DEFAULT:
---------------------------------------------------------------
GetKey does NOT automatically open Library.

================================================================
]]

--==============================================================
-- SERVICES
--==============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

--==============================================================
-- BASE LIBRARY
--==============================================================

local BASE_URL =
    "https://raw.githubusercontent.com/longkawoa/nokia/refs/heads/main/Nhatlong-library-v30.lua"

local function HttpGet(url)
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok then
        error(
            "[NHATLONG] HttpGet failed:\n"
            .. tostring(result)
        )
    end

    if type(result) ~= "string" then
        error("[NHATLONG] Invalid library source.")
    end

    if #result < 1000 then
        error("[NHATLONG] Library source is too small.")
    end

    return result
end

--==============================================================
-- LOAD BASE
--==============================================================

local BaseSource = HttpGet(BASE_URL)

local BaseChunk, CompileError =
    loadstring(BaseSource)

if not BaseChunk then
    error(
        "[NHATLONG] Compile error:\n"
        .. tostring(CompileError)
    )
end

local Loaded, Library =
    pcall(BaseChunk)

if not Loaded then
    error(
        "[NHATLONG] Runtime error:\n"
        .. tostring(Library)
    )
end

if type(Library) ~= "table" then
    error(
        "[NHATLONG] Base library did not return table."
    )
end

--==============================================================
-- VERSION
--==============================================================

Library.FinalVersion =
    "V30+ GETKEY UPDATE"

Library.GetKeyVersion =
    "Independent GetKey UI"

--==============================================================
-- SAFE HELPERS
--==============================================================

local function Clamp(value, min, max, default)
    value = tonumber(value)

    if not value then
        return default
    end

    return math.clamp(
        value,
        min,
        max
    )
end

local function Color(value, fallback)

    if typeof(value) == "Color3" then
        return value
    end

    if type(value) == "table" then

        local r = tonumber(value[1])
        local g = tonumber(value[2])
        local b = tonumber(value[3])

        if r and g and b then

            return Color3.fromRGB(
                math.clamp(r, 0, 255),
                math.clamp(g, 0, 255),
                math.clamp(b, 0, 255)
            )

        end
    end

    return fallback
end

local function SafeDestroy(object)

    if object then

        pcall(function()
            object:Destroy()
        end)

    end

end

--==============================================================
-- PLAYER GUI
--==============================================================

local function GetPlayerGui()

    if not LocalPlayer then
        return nil
    end

    local ok, gui =
        pcall(function()

            return LocalPlayer:
                FindFirstChildOfClass(
                    "PlayerGui"
                )

        end)

    if ok then
        return gui
    end

    return nil
end

--==============================================================
-- NOTIFICATION
--==============================================================

local function Notify(title, text, duration)

    pcall(function()

        StarterGui:SetCore(
            "SendNotification",
            {
                Title = tostring(title),
                Text = tostring(text),
                Duration = tonumber(duration) or 3
            }
        )

    end)

end

--==============================================================
-- FIXED CORE MESSAGES
--==============================================================

local CORE_INVALID =
    "key đã hết hoặc sai key"

local CORE_ACTIVE =
    "Key còn hạn chơi game vv"

local DEFAULT_SUCCESS =
    "nhập key đúng/key còn hạn\nchúc chơi vui vẽ :))"

--==============================================================
-- GETKEY DEFAULT CONFIG
--==============================================================

Library.GetKey = Library.GetKey or {}

Library.GetKey.Enabled = false

Library.GetKey.Title =
    Library.GetKey.Title
    or "Get Key"

Library.GetKey.Note =
    Library.GetKey.Note
    or "Nhập key để tiếp tục"

Library.GetKey.Creator =
    Library.GetKey.Creator
    or "NHATLONG"

Library.GetKey.SuccessMessage =
    Library.GetKey.SuccessMessage
    or DEFAULT_SUCCESS

Library.GetKey.Instructions =
    Library.GetKey.Instructions
    or "Lấy key rồi nhập vào ô bên dưới."

Library.GetKey.OpenLibraryAfterSuccess =
    false

Library.GetKey.CoreMessages = {

    Invalid = CORE_INVALID,

    Active = CORE_ACTIVE

}

Library.GetKey.Links =
    Library.GetKey.Links
    or {

        GetKey = "",
        Discord = "",
        TikTok = "",
        YouTube = "",
        Telegram = "",
        Website = "",
        Other = ""

    }

Library.GetKey.Avatar =
    Library.GetKey.Avatar
    or {

        Enabled = true,
        Image = "",
        Size = 44,
        Gap = 10

    }

Library.GetKey.UI =
    Library.GetKey.UI
    or {}

--==============================================================
-- GETKEY UI DEFAULT
--==============================================================

local UI = Library.GetKey.UI

UI.Width =
    tonumber(UI.Width)
    or 440

UI.Height =
    tonumber(UI.Height)
    or 410

UI.MobileWidth =
    tonumber(UI.MobileWidth)
    or 350

UI.MobileHeight =
    tonumber(UI.MobileHeight)
    or 455

UI.CornerRadius =
    tonumber(UI.CornerRadius)
    or 18

UI.Background =
    Color(
        UI.Background,
        Color3.fromRGB(7, 7, 9)
    )

UI.GlassColor =
    Color(
        UI.GlassColor,
        Color3.fromRGB(17, 17, 22)
    )

UI.GlassTransparency =
    Clamp(
        UI.GlassTransparency,
        0,
        1,
        0.12
    )

UI.BorderColor =
    Color(
        UI.BorderColor,
        Color3.fromRGB(85, 85, 100)
    )

UI.BorderSize =
    math.floor(
        Clamp(
            UI.BorderSize,
            1,
            10,
            2
        )
    )

UI.BorderTransparency =
    Clamp(
        UI.BorderTransparency,
        0,
        1,
        0.15
    )

UI.Accent =
    Color(
        UI.Accent,
        Color3.fromRGB(120, 120, 255)
    )

UI.InputColor =
    Color(
        UI.InputColor,
        Color3.fromRGB(10, 10, 13)
    )

UI.ButtonText =
    Color(
        UI.ButtonText,
        Color3.fromRGB(255, 255, 255)
    )

UI.TextColor =
    Color(
        UI.TextColor,
        Color3.fromRGB(255, 255, 255)
    )

UI.SecondaryText =
    Color(
        UI.SecondaryText,
        Color3.fromRGB(175, 175, 185)
    )

--==============================================================
-- GETKEY STATE
--==============================================================

local GetKeyGui = nil
local GetKeyBusy = false

local function DestroyGetKey()

    if GetKeyGui then

        SafeDestroy(GetKeyGui)

        GetKeyGui = nil

    end

    GetKeyBusy = false
end

function Library:CloseGetKey()

    DestroyGetKey()

end

--==============================================================
-- CONFIG MERGE
--==============================================================

local function DeepMerge(base, custom)

    if type(custom) ~= "table" then
        return base
    end

    for key, value in pairs(custom) do

        if type(value) == "table"
            and type(base[key]) == "table"
        then

            DeepMerge(
                base[key],
                value
            )

        else

            base[key] = value

        end

    end

    return base
end

local function CloneTable(source)

    local result = {}

    for key, value in pairs(source) do

        if type(value) == "table" then

            result[key] =
                CloneTable(value)

        else

            result[key] = value

        end

    end

    return result
end

--==============================================================
-- GETKEY CONFIG BUILDER
--==============================================================

function Library:BuildGetKeyConfig(options)

    local config =
        CloneTable(
            self.GetKey
        )

    if type(options) == "table" then

        DeepMerge(
            config,
            options
        )

    end

    --==========================================================
    -- CORE MESSAGES ARE ALWAYS FIXED
    --==========================================================

    config.CoreMessages = {

        Invalid = CORE_INVALID,

        Active = CORE_ACTIVE

    }

    config.SuccessMessage =
        tostring(
            config.SuccessMessage
            or DEFAULT_SUCCESS
        )

    config.OpenLibraryAfterSuccess =
        config.OpenLibraryAfterSuccess
        == true

    return config
end

--==============================================================
-- LOCAL KEY SYSTEM
--==============================================================

Library.GetKey.LocalKeys =
    Library.GetKey.LocalKeys
    or {}

function Library:CreateKey(
    key,
    duration,
    maxUsers
)

    key =
        tostring(key or "")

    if key == "" then
        return false
    end

    duration =
        tonumber(duration)
        or 60

    maxUsers =
        math.max(
            1,
            math.floor(
                tonumber(maxUsers)
                or 1
            )
        )

    self.GetKey.LocalKeys[key] = {

        StartedAt =
            os.time(),

        ExpiresAt =
            os.time()
            + math.max(
                1,
                duration
            ),

        MaxUsers =
            maxUsers,

        Users = {}

    }

    return true
end

function Library:RemoveKey(key)

    key =
        tostring(key or "")

    if self.GetKey.LocalKeys[key] then

        self.GetKey.LocalKeys[key] = nil

        return true
    end

    return false
end

--==============================================================
-- USER ID
--==============================================================

function Library:GetKeyUserId()

    if not LocalPlayer then
        return "0"
    end

    return tostring(
        LocalPlayer.UserId
    )
end

--==============================================================
-- LOCAL VERIFY
--==============================================================

local function VerifyLocal(config, key)

    local data =
        config.LocalKeys
        and config.LocalKeys[key]

    if type(data) ~= "table" then

        return false,
            CORE_INVALID

    end

    local expires =
        tonumber(
            data.ExpiresAt
        )

    if not expires then

        return false,
            CORE_INVALID

    end

    if os.time() >= expires then

        return false,
            CORE_INVALID

    end

    data.Users =
        type(data.Users) == "table"
        and data.Users
        or {}

    local userId =
        tostring(
            LocalPlayer.UserId
        )

    -- Same account can reuse key.
    if data.Users[userId] then

        return true,
            CORE_ACTIVE

    end

    local maxUsers =
        math.max(
            1,
            tonumber(
                data.MaxUsers
            )
            or 1
        )

    local count = 0

    for _ in pairs(data.Users) do
        count = count + 1
    end

    if count >= maxUsers then

        return false,
            CORE_INVALID

    end

    data.Users[userId] = true

    return true,
        CORE_ACTIVE
end

--==============================================================
-- SERVER VERIFY
--==============================================================

local function VerifyServer(config, key)

    local verifyURL =
        tostring(
            config.VerifyURL
            or ""
        )

    if verifyURL == "" then

        return false,
            CORE_INVALID

    end

    local userId =
        tostring(
            LocalPlayer.UserId
        )

    local encodedKey =
        HttpService:UrlEncode(
            tostring(key)
        )

    local encodedUser =
        HttpService:UrlEncode(
            userId
        )

    local separator = "?"

    if string.find(
        verifyURL,
        "?"
    ) then

        separator = "&"

    end

    local url =
        verifyURL
        .. separator
        .. "key="
        .. encodedKey
        .. "&userid="
        .. encodedUser

    local ok, response =
        pcall(function()

            return game:HttpGet(
                url
            )

        end)

    if not ok then

        return false,
            CORE_INVALID

    end

    if type(response) ~= "string" then

        return false,
            CORE_INVALID

    end

    local clean =
        string.lower(
            string.gsub(
                response,
                "%s+",
                ""
            )
        )

    if clean == "active"
        or clean == "true"
        or clean == "success"
    then

        return true,
            CORE_ACTIVE

    end

    if clean == "invalid"
        or clean == "false"
        or clean == "expired"
    then

        return false,
            CORE_INVALID

    end

    local decoded

    pcall(function()

        decoded =
            HttpService:JSONDecode(
                response
            )

    end)

    if type(decoded) == "table" then

        if decoded.success == true
            or decoded.active == true
        then

            return true,
                CORE_ACTIVE

        end

    end

    return false,
        CORE_INVALID
end

--==============================================================
-- VERIFY API
--==============================================================

function Library:VerifyKey(key, config)

    config =
        config
        or self.GetKey

    key =
        tostring(key or "")

    if key == "" then

        return false,
            CORE_INVALID

    end

    if tostring(
        config.Mode
    ) == "Server"
    then

        return VerifyServer(
            config,
            key
        )

    end

    return VerifyLocal(
        config,
        key
    )
end

--==============================================================
-- CLIPBOARD
--==============================================================

local function CopyText(text)

    text =
        tostring(text or "")

    local success = false

    pcall(function()

        if setclipboard then

            setclipboard(text)

            success = true

        elseif toclipboard then

            toclipboard(text)

            success = true

        end

    end)

    return success
end

--==============================================================
-- OPEN LINK
--==============================================================

local function OpenOrCopyLink(url)

    url =
        tostring(url or "")

    if url == "" then
        return false
    end

    -- Roblox exploit environments may expose
    -- request/open-url functions differently.
    -- Copy is used as safe fallback.

    local opened = false

    pcall(function()

        if syn
            and syn.request
        then

            -- Do not request the page.
            -- Clipboard fallback remains preferred.

        end

    end)

    if not opened then

        return CopyText(url)

    end

    return true
end

--==============================================================
-- UI FACTORIES
--==============================================================

local function New(className, properties, parent)

    local object =
        Instance.new(className)

    for property, value in pairs(
        properties or {}
    ) do

        pcall(function()
            object[property] = value
        end)

    end

    if parent then
        object.Parent = parent
    end

    return object
end

local function AddCorner(
    object,
    radius
)

    return New(
        "UICorner",
        {
            CornerRadius =
                UDim.new(
                    0,
                    radius
                )
        },
        object
    )
end

local function AddStroke(
    object,
    color,
    thickness,
    transparency
)

    return New(
        "UIStroke",
        {
            Color = color,
            Thickness = thickness,
            Transparency = transparency
        },
        object
    )
end

--==============================================================
-- DRAG SUPPORT
--==============================================================

local function MakeDraggable(
    object,
    handle
)

    handle = handle or object

    local dragging = false
    local dragStart
    local startPosition

    handle.InputBegan:
        Connect(function(input)

            if input.UserInputType
                == Enum.UserInputType.MouseButton1
                or input.UserInputType
                == Enum.UserInputType.Touch
            then

                dragging = true

                dragStart =
                    input.Position

                startPosition =
                    object.Position

                input.Changed:
                    Connect(function()

                        if input.UserInputState
                            == Enum.UserInputState.End
                        then

                            dragging = false

                        end

                    end)

            end

        end)

    UserInputService.InputChanged:
        Connect(function(input)

            if not dragging then
                return
            end

            if input.UserInputType
                ~= Enum.UserInputType.MouseMovement
                and input.UserInputType
                ~= Enum.UserInputType.Touch
            then
                return
            end

            local delta =
                input.Position
                - dragStart

            object.Position =
                UDim2.new(
                    startPosition.X.Scale,
                    startPosition.X.Offset
                    + delta.X,

                    startPosition.Y.Scale,
                    startPosition.Y.Offset
                    + delta.Y
                )

        end)
end

--==============================================================
-- GETKEY ANIMATION
--==============================================================

local function PlayIntro(
    card,
    width,
    height,
    effect
)

    effect =
        tostring(
            effect
            or "Zoom"
        )

    local finalSize =
        UDim2.fromOffset(
            width,
            height
        )

    local startSize =
        UDim2.fromOffset(
            width * 0.84,
            height * 0.84
        )

    if effect == "Fade" then

        card.BackgroundTransparency = 1

        TweenService:Create(
            card,
            TweenInfo.new(
                0.30,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            {
                BackgroundTransparency =
                    card:GetAttribute(
                        "FinalTransparency"
                    )
                    or 0.12
            }
        ):Play()

        return
    end

    if effect == "SlideDown" then

        card.Position =
            UDim2.new(
                0.5,
                0,
                0,
                -height
            )

    elseif effect == "SlideUp" then

        card.Position =
            UDim2.new(
                0.5,
                0,
                1,
                height
            )

    elseif effect == "SlideLeft" then

        card.Position =
            UDim2.new(
                0,
                -width,
                0.5,
                0
            )

    elseif effect == "SlideRight" then

        card.Position =
            UDim2.new(
                1,
                width,
                0.5,
                0
            )

    elseif effect == "Zoom" then

        card.Size =
            startSize

    elseif effect == "Bounce" then

        card.Size =
            startSize

    else

        card.Size =
            startSize

    end

    local goal = {
        Position =
            UDim2.fromScale(
                0.5,
                0.5
            ),

        Size =
            finalSize

    }

    TweenService:Create(
        card,
        TweenInfo.new(
            effect == "Bounce"
                and 0.55
                or 0.30,

            effect == "Bounce"
                and Enum.EasingStyle.Back
                or Enum.EasingStyle.Quint,

            Enum.EasingDirection.Out
        ),
        goal
    ):Play()
end

--==============================================================
-- BUILD GETKEY UI
--==============================================================

function Library:ShowGetKey(options)

    local config =
        self:BuildGetKeyConfig(
            options
        )

    DestroyGetKey()

    local PlayerGui =
        GetPlayerGui()

    if not PlayerGui then
        return nil
    end

    local touch =
        UserInputService.TouchEnabled

    local keyboard =
        UserInputService.KeyboardEnabled

    local mobile =
        touch and not keyboard

    local width =
        mobile
        and config.UI.MobileWidth
        or config.UI.Width

    local height =
        mobile
        and config.UI.MobileHeight
        or config.UI.Height

    width =
        math.max(
            300,
            tonumber(width)
            or 440
        )

    height =
        math.max(
            300,
            tonumber(height)
            or 410
        )

    --==========================================================
    -- SCREEN GUI
    --==========================================================

    local ScreenGui =
        New(
            "ScreenGui",
            {
                Name =
                    "NHATLONG_GetKey_Independent",

                ResetOnSpawn = false,

                IgnoreGuiInset = true,

                ZIndexBehavior =
                    Enum.ZIndexBehavior.Sibling
            },
            PlayerGui
        )

    GetKeyGui =
        ScreenGui

    --==========================================================
    -- DIMMER
    --==========================================================

    local Dim =
        New(
            "Frame",
            {
                Size =
                    UDim2.fromScale(
                        1,
                        1
                    ),

                BackgroundColor3 =
                    Color3.fromRGB(
                        0,
                        0,
                        0
                    ),

                BackgroundTransparency =
                    0.38,

                BorderSizePixel = 0
            },
            ScreenGui
        )

    --==========================================================
    -- CARD
    --==========================================================

    local Card =
        New(
            "Frame",
            {
                Name =
                    "GetKeyCard",

                AnchorPoint =
                    Vector2.new(
                        0.5,
                        0.5
                    ),

                Position =
                    UDim2.fromScale(
                        0.5,
                        0.5
                    ),

                Size =
                    UDim2.fromOffset(
                        width,
                        height
                    ),

                BackgroundColor3 =
                    config.UI.GlassColor,

                BackgroundTransparency =
                    config.UI.GlassTransparency,

                BorderSizePixel = 0
            },
            ScreenGui
        )

    Card:SetAttribute(
        "FinalTransparency",
        config.UI.GlassTransparency
    )

    AddCorner(
        Card,
        config.UI.CornerRadius
    )

    AddStroke(
        Card,
        config.UI.BorderColor,
        config.UI.BorderSize,
        config.UI.BorderTransparency
    )

    --==========================================================
    -- TOP ACCENT
    --==========================================================

    local AccentBar =
        New(
            "Frame",
            {
                Position =
                    UDim2.fromOffset(
                        0,
                        0
                    ),

                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        4
                    ),

                BackgroundColor3 =
                    config.UI.Accent,

                BorderSizePixel = 0
            },
            Card
        )

    AddCorner(
        AccentBar,
        config.UI.CornerRadius
    )

    --==========================================================
    -- CONTENT
    --==========================================================

    local Content =
        New(
            "Frame",
            {
                BackgroundTransparency = 1,

                Position =
                    UDim2.fromOffset(
                        22,
                        17
                    ),

                Size =
                    UDim2.new(
                        1,
                        -44,
                        1,
                        -34
                    )
            },
            Card
        )

    --==========================================================
    -- HEADER
    --==========================================================

    local Header =
        New(
            "Frame",
            {
                BackgroundTransparency = 1,

                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        64
                    )
            },
            Content
        )

    --==========================================================
    -- AVATAR
    --==========================================================

    local avatar =
        config.Avatar

    local avatarEnabled =
        type(avatar) == "table"
        and avatar.Enabled ~= false
        and tostring(
            avatar.Image
            or ""
        ) ~= ""

    local avatarSize = 0

    if avatarEnabled then

        avatarSize =
            math.clamp(
                tonumber(
                    avatar.Size
                )
                or 44,
                24,
                80
            )

        local Avatar =
            New(
                "ImageLabel",
                {
                    BackgroundColor3 =
                        config.UI.InputColor,

                    BackgroundTransparency =
                        0,

                    Size =
                        UDim2.fromOffset(
                            avatarSize,
                            avatarSize
                        ),

                    Position =
                        UDim2.fromOffset(
                            0,
                            2
                        ),

                    Image =
                        tostring(
                            avatar.Image
                        ),

                    ScaleType =
                        Enum.ScaleType.Crop
                },
                Header
            )

        AddCorner(
            Avatar,
            avatarSize / 2
        )

        AddStroke(
            Avatar,
            config.UI.Accent,
            1,
            0.35
        )

    end

    local titleOffset =
        avatarEnabled
        and avatarSize
            + tonumber(
                avatar.Gap
            )
            or 0

    --==========================================================
    -- TITLE
    --==========================================================

    local Title =
        New(
            "TextLabel",
            {
                BackgroundTransparency = 1,

                Position =
                    UDim2.fromOffset(
                        titleOffset,
                        0
                    ),

                Size =
                    UDim2.new(
                        1,
                        -titleOffset - 90,
                        0,
                        30
                    ),

                Font =
                    Enum.Font.GothamBold,

                Text =
                    tostring(
                        config.Title
                        or "Get Key"
                    ),

                TextColor3 =
                    config.UI.TextColor,

                TextSize =
                    mobile
                    and 18
                    or 21,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            Header
        )

    --==========================================================
    -- CREATOR
    --==========================================================

    local Creator =
        New(
            "TextLabel",
            {
                BackgroundTransparency = 1,

                AnchorPoint =
                    Vector2.new(
                        1,
                        0
                    ),

                Position =
                    UDim2.new(
                        1,
                        0,
                        0,
                        4
                    ),

                Size =
                    UDim2.fromOffset(
                        100,
                        20
                    ),

                Font =
                    Enum.Font.GothamMedium,

                Text =
                    tostring(
                        config.Creator
                        or ""
                    ),

                TextColor3 =
                    config.UI.Accent,

                TextSize = 10,

                TextXAlignment =
                    Enum.TextXAlignment.Right
            },
            Header
        )

    --==========================================================
    -- NOTE
    --==========================================================

    local Note =
        New(
            "TextLabel",
            {
                BackgroundTransparency = 1,

                Position =
                    UDim2.fromOffset(
                        titleOffset,
                        31
                    ),

                Size =
                    UDim2.new(
                        1,
                        -titleOffset,
                        0,
                        25
                    ),

                Font =
                    Enum.Font.Gotham,

                Text =
                    tostring(
                        config.Note
                        or ""
                    ),

                TextColor3 =
                    config.UI.SecondaryText,

                TextSize = 11,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            Header
        )

    --==========================================================
    -- INFO LABEL
    --==========================================================

    local Info =
        New(
            "TextLabel",
            {
                BackgroundTransparency = 1,

                Position =
                    UDim2.fromOffset(
                        0,
                        73
                    ),

                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        42
                    ),

                Font =
                    Enum.Font.Gotham,

                Text =
                    tostring(
                        config.Instructions
                        or ""
                    ),

                TextColor3 =
                    config.UI.SecondaryText,

                TextSize = 11,

                TextWrapped = true,

                TextXAlignment =
                    Enum.TextXAlignment.Left,

                TextYAlignment =
                    Enum.TextYAlignment.Center
            },
            Content
        )

    --==========================================================
    -- KEY INPUT HOLDER
    --==========================================================

    local InputHolder =
        New(
            "Frame",
            {
                Position =
                    UDim2.fromOffset(
                        0,
                        123
                    ),

                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        48
                    ),

                BackgroundColor3 =
                    config.UI.InputColor,

                BackgroundTransparency =
                    0,

                BorderSizePixel = 0
            },
            Content
        )

    AddCorner(
        InputHolder,
        11
    )

    AddStroke(
        InputHolder,
        config.UI.BorderColor,
        1,
        0.35
    )

    --==========================================================
    -- KEY ICON
    --==========================================================

    local KeyIcon =
        New(
            "TextLabel",
            {
                BackgroundTransparency = 1,

                Position =
                    UDim2.fromOffset(
                        12,
                        0
                    ),

                Size =
                    UDim2.fromOffset(
                        30,
                        48
                    ),

                Font =
                    Enum.Font.GothamBold,

                Text = "#",

                TextColor3 =
                    config.UI.Accent,

                TextSize = 17
            },
            InputHolder
        )

    --==========================================================
    -- KEY BOX
    --==========================================================

    local KeyBox =
        New(
            "TextBox",
            {
                BackgroundTransparency = 1,

                Position =
                    UDim2.fromOffset(
                        44,
                        0
                    ),

                Size =
                    UDim2.new(
                        1,
                        -54,
                        1,
                        0
                    ),

                ClearTextOnFocus = false,

                PlaceholderText =
                    "Nhập key của bạn...",

                PlaceholderColor3 =
                    Color3.fromRGB(
                        100,
                        100,
                        110
                    ),

                Text = "",

                TextColor3 =
                    config.UI.TextColor,

                TextSize = 13,

                Font =
                    Enum.Font.Gotham,

                TextXAlignment =
                    Enum.TextXAlignment.Left
            },
            InputHolder
        )

    --==========================================================
    -- VERIFY BUTTON
    --==========================================================

    local VerifyButton =
        New(
            "TextButton",
            {
                Position =
                    UDim2.fromOffset(
                        0,
                        181
                    ),

                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        45
                    ),

                BackgroundColor3 =
                    config.UI.Accent,

                BorderSizePixel = 0,

                AutoButtonColor = false,

                Font =
                    Enum.Font.GothamBold,

                Text =
                    "XÁC NHẬN KEY",

                TextColor3 =
                    config.UI.ButtonText,

                TextSize = 13
            },
            Content
        )

    AddCorner(
        VerifyButton,
        11
    )

    --==========================================================
    -- VERIFY BUTTON HOVER / PRESS
    --==========================================================

    VerifyButton.MouseEnter:
        Connect(function()

            TweenService:Create(
                VerifyButton,
                TweenInfo.new(0.15),
                {
                    BackgroundColor3 =
                        config.UI.Accent:Lerp(
                            Color3.new(
                                1,
                                1,
                                1
                            ),
                            0.10
                        )
                }
            ):Play()

        end)

    VerifyButton.MouseLeave:
        Connect(function()

            TweenService:Create(
                VerifyButton,
                TweenInfo.new(0.15),
                {
                    BackgroundColor3 =
                        config.UI.Accent
                }
            ):Play()

        end)

    --==========================================================
    -- STATUS
    --==========================================================

    local Status =
        New(
            "TextLabel",
            {
                BackgroundTransparency = 1,

                Position =
                    UDim2.fromOffset(
                        0,
                        232
                    ),

                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        42
                    ),

                Font =
                    Enum.Font.GothamMedium,

                Text = "",

                TextColor3 =
                    config.UI.SecondaryText,

                TextSize = 11,

                TextWrapped = true,

                TextXAlignment =
                    Enum.TextXAlignment.Center
            },
            Content
        )

    --==========================================================
    -- ACTION ROW
    --==========================================================

    local ActionRow =
        New(
            "Frame",
            {
                BackgroundTransparency = 1,

                Position =
                    UDim2.fromOffset(
                        0,
                        280
                    ),

                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        38
                    )
            },
            Content
        )

    --==========================================================
    -- GET KEY BUTTON
    --==========================================================

    local GetKeyURL =
        config.Links
        and config.Links.GetKey
        or ""

    if tostring(GetKeyURL) ~= "" then

        local GetKeyButton =
            New(
                "TextButton",
                {
                    Position =
                        UDim2.fromOffset(
                            0,
                            0
                        ),

                    Size =
                        UDim2.new(
                            0.48,
                            0,
                            1,
                            0
                        ),

                    BackgroundColor3 =
                        config.UI.InputColor,

                    BorderSizePixel = 0,

                    AutoButtonColor = false,

                    Font =
                        Enum.Font.GothamMedium,

                    Text =
                        "GET KEY",

                    TextColor3 =
                        config.UI.Accent,

                    TextSize = 11
                },
                ActionRow
            )

        AddCorner(
            GetKeyButton,
            9
        )

        AddStroke(
            GetKeyButton,
            config.UI.BorderColor,
            1,
            0.4
        )

        GetKeyButton.MouseButton1Click:
            Connect(function()

                if CopyText(
                    GetKeyURL
                ) then

                    Notify(
                        "Get Key",
                        "Link Get Key đã được copy.",
                        2
                    )

                else

                    Notify(
                        "Get Key",
                        GetKeyURL,
                        4
                    )

                end

            end)

    end

    --==========================================================
    -- CLOSE BUTTON
    --==========================================================

    local CloseButton =
        New(
            "TextButton",
            {
                AnchorPoint =
                    Vector2.new(
                        1,
                        0
                    ),

                Position =
                    UDim2.new(
                        1,
                        0,
                        0,
                        0
                    ),

                Size =
                    UDim2.new(
                        0.48,
                        0,
                        1,
                        0
                    ),

                BackgroundColor3 =
                    config.UI.InputColor,

                BorderSizePixel = 0,

                AutoButtonColor = false,

                Font =
                    Enum.Font.GothamMedium,

                Text =
                    "ĐÓNG",

                TextColor3 =
                    config.UI.SecondaryText,

                TextSize = 11
            },
            ActionRow
        )

    AddCorner(
        CloseButton,
        9
    )

    AddStroke(
        CloseButton,
        config.UI.BorderColor,
        1,
        0.4
    )

    CloseButton.MouseButton1Click:
        Connect(function()

            DestroyGetKey()

        end)

    --==========================================================
    -- LINKS
    --==========================================================

    local linkList = {

        {
            "Discord",
            config.Links
                and config.Links.Discord
        },

        {
            "TikTok",
            config.Links
                and config.Links.TikTok
        },

        {
            "YouTube",
            config.Links
                and config.Links.YouTube
        },

        {
            "Telegram",
            config.Links
                and config.Links.Telegram
        },

        {
            "Website",
            config.Links
                and config.Links.Website
        },

        {
            "Other",
            config.Links
                and config.Links.Other
        }

    }

    local activeLinks = {}

    for _, item in ipairs(
        linkList
    ) do

        if type(item[2]) == "string"
            and item[2] ~= ""
        then

            table.insert(
                activeLinks,
                item
            )

        end

    end

    if #activeLinks > 0 then

        local LinkScroll =
            New(
                "ScrollingFrame",
                {
                    Position =
                        UDim2.fromOffset(
                            0,
                            326
                        ),

                    Size =
                        UDim2.new(
                            1,
                            0,
                            0,
                            mobile
                                and 48
                                or 40
                        ),

                    BackgroundTransparency = 1,

                    BorderSizePixel = 0,

                    ScrollBarThickness = 0,

                    CanvasSize =
                        UDim2.new(
                            0,
                            0,
                            0,
                            0
                        ),

                    AutomaticCanvasSize =
                        Enum.AutomaticSize.X,

                    ScrollingDirection =
                        Enum.ScrollingDirection.X
                },
                Content
            )

        local LinkLayout =
            New(
                "UIListLayout",
                {
                    FillDirection =
                        Enum.FillDirection.Horizontal,

                    HorizontalAlignment =
                        Enum.HorizontalAlignment.Left,

                    VerticalAlignment =
                        Enum.VerticalAlignment.Center,

                    Padding =
                        UDim.new(
                            0,
                            7
                        )
                },
                LinkScroll
            )

        for _, item in ipairs(
            activeLinks
        ) do

            local LinkButton =
                New(
                    "TextButton",
                    {
                        AutomaticSize =
                            Enum.AutomaticSize.X,

                        Size =
                            UDim2.fromOffset(
                                0,
                                30
                            ),

                        BackgroundColor3 =
                            config.UI.InputColor,

                        BorderSizePixel = 0,

                        AutoButtonColor = false,

                        Font =
                            Enum.Font.GothamMedium,

                        Text =
                            "  "
                            .. tostring(
                                item[1]
                            )
                            .. "  ",

                        TextColor3 =
                            config.UI.SecondaryText,

                        TextSize = 9
                    },
                    LinkScroll
                )

            AddCorner(
                LinkButton,
                8
            )

            LinkButton.MouseButton1Click:
                Connect(function()

                    if CopyText(
                        item[2]
                    ) then

                        Notify(
                            item[1],
                            "Link đã được copy.",
                            2
                        )

                    else

                        Notify(
                            item[1],
                            tostring(item[2]),
                            4
                        )

                    end

                end)

        end

    end

    --==========================================================
    -- HOW TO GET KEY
    --==========================================================

    local HowTo =
        tostring(
            config.HowToGetKey
            or ""
        )

    if HowTo ~= "" then

        local HowToButton =
            New(
                "TextButton",
                {
                    Position =
                        UDim2.new(
                            1,
                            -90,
                            1,
                            -2
                        ),

                    AnchorPoint =
                        Vector2.new(
                            1,
                            1
                        ),

                    Size =
                        UDim2.fromOffset(
                            90,
                            22
                        ),

                    BackgroundTransparency = 1,

                    Font =
                        Enum.Font.GothamMedium,

                    Text =
                        "CÁCH LẤY KEY",

                    TextColor3 =
                        config.UI.Accent,

                    TextSize = 9
                },
                Content
            )

        local HowToFrame =
            New(
                "Frame",
                {
                    Visible = false,

                    AnchorPoint =
                        Vector2.new(
                            0.5,
                            1
                        ),

                    Position =
                        UDim2.new(
                            0.5,
                            0,
                            1,
                            -25
                        ),

                    Size =
                        UDim2.new(
                            1,
                            -20,
                            0,
                            110
                        ),

                    BackgroundColor3 =
                        config.UI.InputColor,

                    BorderSizePixel = 0,

                    ZIndex = 20
                },
                Content
            )

        AddCorner(
            HowToFrame,
            12
        )

        AddStroke(
            HowToFrame,
            config.UI.BorderColor,
            1,
            0.25
        )

        local HowToText =
            New(
                "TextLabel",
                {
                    BackgroundTransparency = 1,

                    Position =
                        UDim2.fromOffset(
                            12,
                            10
                        ),

                    Size =
                        UDim2.new(
                            1,
                            -24,
                            1,
                            -20
                        ),

                    Font =
                        Enum.Font.Gotham,

                    Text =
                        HowTo,

                    TextColor3 =
                        config.UI.TextColor,

                    TextSize = 10,

                    TextWrapped = true,

                    TextXAlignment =
                        Enum.TextXAlignment.Left,

                    TextYAlignment =
                        Enum.TextYAlignment.Top,

                    ZIndex = 21
                },
                HowToFrame
            )

        HowToButton.MouseButton1Click:
            Connect(function()

                HowToFrame.Visible =
                    not HowToFrame.Visible

            end)

    end

    --==========================================================
    -- DRAG
    --==========================================================

    MakeDraggable(
        Card,
        Header
    )

    --==========================================================
    -- VERIFY
    --==========================================================

    local function Verify()

        if GetKeyBusy then
            return
        end

        GetKeyBusy = true

        VerifyButton.Text =
            "ĐANG KIỂM TRA..."

        Status.Text =
            "Đang xác định key..."

        Status.TextColor3 =
            config.UI.SecondaryText

        local valid, message =
            Library:VerifyKey(
                KeyBox.Text,
                config
            )

        if valid then

            Status.Text =
                CORE_ACTIVE

            Status.TextColor3 =
                Color3.fromRGB(
                    80,
                    220,
                    120
                )

            VerifyButton.Text =
                "KEY HỢP LỆ"

            Notify(
                "Key",
                config.SuccessMessage,
                3
            )

            task.wait(0.55)

            --==================================================
            -- CLOSE GETKEY FIRST
            --==================================================

            DestroyGetKey()

            --==================================================
            -- ONLY OPEN NEXT MENU WHEN EXPLICITLY REQUESTED
            --==================================================

            if config.OpenLibraryAfterSuccess
                == true
            then

                local callback =
                    config.OnSuccess

                if type(callback)
                    == "function"
                then

                    task.defer(
                        function()

                            pcall(
                                callback
                            )

                        end
                    )

                end

            end

        else

            Status.Text =
                CORE_INVALID

            Status.TextColor3 =
                Color3.fromRGB(
                    255,
                    85,
                    90
                )

            VerifyButton.Text =
                "XÁC NHẬN KEY"

            GetKeyBusy = false

            return

        end

        GetKeyBusy = false

    end

    VerifyButton.MouseButton1Click:
        Connect(
            Verify
        )

    KeyBox.FocusLost:
        Connect(function(
            enterPressed
        )

            if enterPressed then
                Verify()
            end

        end)

    --==========================================================
    -- OPEN ANIMATION
    --==========================================================

    local intro =
        config.Intro

    if intro == false then

        return ScreenGui

    end

    if type(intro) ~= "table" then
        intro = {}
    end

    local effect =
        intro.Effect
        or "Zoom"

    local startDelay =
        tonumber(
            intro.Delay
        )
        or 0

    if startDelay > 0 then

        task.wait(
            math.min(
                startDelay,
                3
            )
        )

    end

    PlayIntro(
        Card,
        width,
        height,
        effect
    )

    return ScreenGui
end

--==============================================================
-- CREATE GETKEY
--==============================================================

function Library:CreateGetKey(options)

    options =
        options
        or {}

    local config =
        self:BuildGetKeyConfig(
            options
        )

    config.Enabled = true

    self.GetKey =
        config

    return self:ShowGetKey(
        config
    )
end

--==============================================================
-- GETKEY ALIAS
--==============================================================

Library.ShowKey =
    Library.ShowGetKey

--==============================================================
-- MAIN MENU
--==============================================================

function Library:CreateMainMenu(options)

    options =
        options
        or {}

    --==========================================================
    -- IMPORTANT:
    -- This directly uses the base Library's CreateWindow.
    --==========================================================

    local final = {}

    if type(
        self.DefaultMenu
    ) == "table"
    then

        for key, value in pairs(
            self.DefaultMenu
        ) do

            final[key] =
                value

        end

    end

    for key, value in pairs(
        options
    ) do

        final[key] =
            value

    end

    local ok, result =
        pcall(function()

            return self:CreateWindow(
                final
            )

        end)

    if not ok then

        warn(
            "[NHATLONG] Main Library error: "
            .. tostring(result)
        )

        return nil
    end

    if result then

        task.defer(function()

            pcall(function()

                if self.ApplyFinalTheme then

                    self:ApplyFinalTheme(
                        result
                    )

                end

            end)

        end)

    end

    return result
end

--==============================================================
-- CUSTOM MENU
--==============================================================

function Library:CreateCustomMenu(config)

    config =
        config
        or {}

    if type(
        config.Create
    ) == "function"
    then

        local ok, result =
            pcall(function()

                return config.Create(
                    self
                )

            end)

        if not ok then

            warn(
                "[NHATLONG] Custom menu error: "
                .. tostring(result)
            )

            return nil
        end

        return result
    end

    return self:CreateMainMenu(
        config.Options
        or config
    )
end

--==============================================================
-- SCRIPT ROUTER
--==============================================================

function Library:CreateScript(config)

    config =
        config
        or {}

    --==========================================================
    -- GETKEY
    --==========================================================

    local getKeyConfig =
        config.GetKey

    local hasGetKey =
        type(getKeyConfig)
        == "table"
        and getKeyConfig.Enabled
        == true

    --==========================================================
    -- CUSTOM MENU
    --==========================================================

    local customMenu =
        config.CustomMenu

    local hasCustomMenu =
        type(customMenu)
        == "table"

    --==========================================================
    -- NEXT MENU
    --==========================================================

    local function OpenNext()

        -- Custom Menu has priority when explicitly supplied.
        if hasCustomMenu then

            return self:CreateCustomMenu(
                customMenu
            )

        end

        -- Otherwise Main Library.
        return self:CreateMainMenu(
            config.MainMenu
            or {}
        )

    end

    --==========================================================
    -- GETKEY
    --==========================================================

    if hasGetKey then

        local finalGetKey =
            self:BuildGetKeyConfig(
                getKeyConfig
            )

        --======================================================
        -- CRITICAL BEHAVIOR
        --
        -- DEFAULT:
        -- GetKey does NOT open Library.
        --
        -- ONLY:
        -- OpenLibraryAfterSuccess = true
        --
        -- opens next menu.
        --======================================================

        if finalGetKey.OpenLibraryAfterSuccess
            == true
        then

            finalGetKey.OnSuccess =
                OpenNext

        else

            finalGetKey.OnSuccess =
                nil

        end

        return self:CreateGetKey(
            finalGetKey
        )

    end

    --==========================================================
    -- NO GETKEY
    --
    -- DEFAULT = MAIN LIBRARY
    --==========================================================

    if hasCustomMenu then

        return self:CreateCustomMenu(
            customMenu
        )

    end

    return self:CreateMainMenu(
        config.MainMenu
        or {}
    )
end

--==============================================================
-- SIMPLE API
--==============================================================

function Library:UseGetKeyOnly(options)

    options =
        options
        or {}

    options.Enabled = true

    options.OpenLibraryAfterSuccess =
        false

    return self:CreateGetKey(
        options
    )
end

function Library:UseGetKeyToLibrary(options)

    options =
        options
        or {}

    options.Enabled = true

    options.OpenLibraryAfterSuccess =
        true

    return self:CreateScript({

        GetKey = options

    })
end

--==============================================================
-- FINAL THEME HELPERS
--==============================================================

if type(
    Library.SetFinalTheme
) == "function"
then

    -- Keep V30 theme system.
    pcall(function()

        Library:SetFinalTheme({

            BorderSize = 5

        })

    end)

end

--==============================================================
-- DEFAULT MENU PRIORITY
--==============================================================

Library.DefaultMenu =
    Library.DefaultMenu
    or {

        Title = "NHATLONG",

        Subtitle =
            "Main Library",

        Width = 507,

        Height = 384

    }

--==============================================================
-- FINAL API
--==============================================================

Library.FinalAPI =
    Library.FinalAPI
    or {}

Library.FinalAPI.CreateGetKey =
    function(options)

        return Library:CreateGetKey(
            options
        )

    end

Library.FinalAPI.CreateScript =
    function(config)

        return Library:CreateScript(
            config
        )

    end

Library.FinalAPI.CreateMainMenu =
    function(options)

        return Library:CreateMainMenu(
            options
        )

    end

Library.FinalAPI.UseGetKeyOnly =
    function(options)

        return Library:UseGetKeyOnly(
            options
        )

    end

Library.FinalAPI.UseGetKeyToLibrary =
    function(options)

        return Library:UseGetKeyToLibrary(
            options
        )

    end

Library.FinalAPI.CloseGetKey =
    function()

        return Library:CloseGetKey()

    end

--==============================================================
-- EXPORT
--==============================================================

return Library
