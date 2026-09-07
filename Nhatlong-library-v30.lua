--[[
================================================================
             NHATLONG LIBRARY V21 - FINAL WRAPPER
================================================================

MAIN FEATURES
----------------------------------------------------------------
✓ Direct load NHATLONG_library_nokiav21.lua
✓ Black Theme
✓ Glass Color / Glass Tint unified
✓ Glass Transparency
✓ Border Color
✓ Border Size 1 -> 10
✓ Default Border Size = 5
✓ Border Transparency
✓ Runtime Theme API
✓ 1000+ Icon Engine from V21
✓ Smart Tab Icon
✓ Fallback Icon
✓ Creator Intro
✓ 10 Intro Effects
✓ Separate GetKey GUI
✓ Local Key System
✓ Server Verify System
✓ UserId binding
✓ Expiration
✓ Multiple Users
✓ Custom Success Message
✓ Fixed Core Key Messages
✓ Separate Custom Menu
✓ Main Library default menu
✓ Avatar support
✓ GetKey links
✓ Mobile + PC
✓ Touch support
✓ Safe pcall protection
================================================================
]]

--==============================================================
-- SERVICES
--==============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--==============================================================
-- V21 SOURCE
--==============================================================

local SOURCE_URL =
    "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/NHATLONG_library_nokiav21.lua"

--==============================================================
-- SAFE HTTP
--==============================================================

local function SafeHttpGet(url)
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok then
        error(
            "[NHATLONG V21] HttpGet failed:\n"
            .. tostring(result)
        )
    end

    if type(result) ~= "string" then
        error("[NHATLONG V21] Invalid source.")
    end

    if #result < 1000 then
        error("[NHATLONG V21] Source is too small.")
    end

    return result
end

--==============================================================
-- LOAD V21
--==============================================================

local Source = SafeHttpGet(SOURCE_URL)

local Chunk, CompileError = loadstring(Source)

if not Chunk then
    error(
        "[NHATLONG V21] Compile error:\n"
        .. tostring(CompileError)
    )
end

local Success, Library = pcall(Chunk)

if not Success then
    error(
        "[NHATLONG V21] Runtime error:\n"
        .. tostring(Library)
    )
end

if type(Library) ~= "table" then
    error(
        "[NHATLONG V21] Library did not return a table."
    )
end

--==============================================================
-- VERSION
--==============================================================

Library.FinalVersion = "V21 FINAL"

--==============================================================
-- DEFAULT THEME
--==============================================================

Library.FinalTheme = {

    Name = "Black",

    -- Màu nền chính
    BackgroundColor = Color3.fromRGB(
        8,
        8,
        10
    ),

    -- Màu kính.
    -- GlassColor và GlassTint dùng CHUNG một màu.
    GlassColor = Color3.fromRGB(
        18,
        18,
        22
    ),

    GlassTint = Color3.fromRGB(
        18,
        18,
        22
    ),

    -- Độ trong suốt kính
    GlassTransparency = 0.30,

    -- Viền
    BorderColor = Color3.fromRGB(
        80,
        80,
        88
    ),

    -- 1 -> 10
    -- 5 = vừa
    BorderSize = 5,

    -- 0 = rõ
    -- 1 = hoàn toàn trong
    BorderTransparency = 0.20,

    -- Text
    TextColor = Color3.fromRGB(
        255,
        255,
        255
    ),

    SecondaryTextColor = Color3.fromRGB(
        180,
        180,
        185
    ),

    AccentColor = Color3.fromRGB(
        120,
        120,
        255
    ),

    CornerRadius = 12
}

--==============================================================
-- CLAMP
--==============================================================

local function ClampNumber(value, min, max, default)
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

--==============================================================
-- COLOR SAFE
--==============================================================

local function SafeColor(value, fallback)

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

--==============================================================
-- SET THEME
--==============================================================

function Library:SetFinalTheme(options)

    if type(options) ~= "table" then
        return false
    end

    local theme = self.FinalTheme

    if options.Name ~= nil then
        theme.Name =
            tostring(options.Name)
    end

    if options.BackgroundColor ~= nil then
        theme.BackgroundColor =
            SafeColor(
                options.BackgroundColor,
                theme.BackgroundColor
            )
    end

    -- GlassColor + GlassTint = SAME COLOR
    if options.GlassColor ~= nil then

        local color =
            SafeColor(
                options.GlassColor,
                theme.GlassColor
            )

        theme.GlassColor = color
        theme.GlassTint = color
    end

    if options.GlassTint ~= nil
        and options.GlassColor == nil
    then

        local color =
            SafeColor(
                options.GlassTint,
                theme.GlassColor
            )

        theme.GlassColor = color
        theme.GlassTint = color
    end

    if options.GlassTransparency ~= nil then

        theme.GlassTransparency =
            ClampNumber(
                options.GlassTransparency,
                0,
                1,
                theme.GlassTransparency
            )
    end

    if options.BorderColor ~= nil then

        theme.BorderColor =
            SafeColor(
                options.BorderColor,
                theme.BorderColor
            )
    end

    if options.BorderSize ~= nil then

        theme.BorderSize =
            math.floor(
                ClampNumber(
                    options.BorderSize,
                    1,
                    10,
                    5
                )
            )
    end

    if options.BorderTransparency ~= nil then

        theme.BorderTransparency =
            ClampNumber(
                options.BorderTransparency,
                0,
                1,
                theme.BorderTransparency
            )
    end

    if options.TextColor ~= nil then

        theme.TextColor =
            SafeColor(
                options.TextColor,
                theme.TextColor
            )
    end

    if options.SecondaryTextColor ~= nil then

        theme.SecondaryTextColor =
            SafeColor(
                options.SecondaryTextColor,
                theme.SecondaryTextColor
            )
    end

    if options.AccentColor ~= nil then

        theme.AccentColor =
            SafeColor(
                options.AccentColor,
                theme.AccentColor
            )
    end

    if options.CornerRadius ~= nil then

        theme.CornerRadius =
            ClampNumber(
                options.CornerRadius,
                0,
                50,
                theme.CornerRadius
            )
    end

    return true
end

--==============================================================
-- THEME PRESETS
--==============================================================

Library.ThemePresets = {

    Black = {
        Name = "Black",

        BackgroundColor =
            Color3.fromRGB(
                8,
                8,
                10
            ),

        GlassColor =
            Color3.fromRGB(
                18,
                18,
                22
            ),

        GlassTransparency = 0.30,

        BorderColor =
            Color3.fromRGB(
                80,
                80,
                88
            ),

        BorderSize = 5,

        BorderTransparency = 0.20,

        TextColor =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        SecondaryTextColor =
            Color3.fromRGB(
                180,
                180,
                185
            ),

        AccentColor =
            Color3.fromRGB(
                120,
                120,
                255
            )
    },

    Dark = {
        Name = "Dark",

        BackgroundColor =
            Color3.fromRGB(
                15,
                15,
                18
            ),

        GlassColor =
            Color3.fromRGB(
                30,
                30,
                35
            ),

        GlassTransparency = 0.25,

        BorderColor =
            Color3.fromRGB(
                100,
                100,
                110
            ),

        BorderSize = 5,

        BorderTransparency = 0.15
    },

    White = {
        Name = "White",

        BackgroundColor =
            Color3.fromRGB(
                235,
                235,
                240
            ),

        GlassColor =
            Color3.fromRGB(
                245,
                245,
                250
            ),

        GlassTransparency = 0.20,

        BorderColor =
            Color3.fromRGB(
                120,
                120,
                130
            ),

        BorderSize = 5,

        BorderTransparency = 0.20,

        TextColor =
            Color3.fromRGB(
                20,
                20,
                25
            ),

        SecondaryTextColor =
            Color3.fromRGB(
                70,
                70,
                80
            )
    },

    Red = {
        Name = "Red",

        BackgroundColor =
            Color3.fromRGB(
                12,
                6,
                8
            ),

        GlassColor =
            Color3.fromRGB(
                30,
                10,
                14
            ),

        GlassTransparency = 0.25,

        BorderColor =
            Color3.fromRGB(
                255,
                70,
                80
            ),

        BorderSize = 5,

        BorderTransparency = 0.15,

        AccentColor =
            Color3.fromRGB(
                255,
                60,
                70
            )
    },

    Blue = {
        Name = "Blue",

        BackgroundColor =
            Color3.fromRGB(
                5,
                8,
                15
            ),

        GlassColor =
            Color3.fromRGB(
                10,
                20,
                38
            ),

        GlassTransparency = 0.25,

        BorderColor =
            Color3.fromRGB(
                70,
                140,
                255
            ),

        BorderSize = 5,

        BorderTransparency = 0.15,

        AccentColor =
            Color3.fromRGB(
                80,
                150,
                255
            )
    },

    Purple = {
        Name = "Purple",

        BackgroundColor =
            Color3.fromRGB(
                10,
                6,
                18
            ),

        GlassColor =
            Color3.fromRGB(
                25,
                12,
                45
            ),

        GlassTransparency = 0.25,

        BorderColor =
            Color3.fromRGB(
                170,
                100,
                255
            ),

        BorderSize = 5,

        BorderTransparency = 0.15,

        AccentColor =
            Color3.fromRGB(
                180,
                100,
                255
            )
    },

    Green = {
        Name = "Green",

        BackgroundColor =
            Color3.fromRGB(
                5,
                12,
                8
            ),

        GlassColor =
            Color3.fromRGB(
                10,
                30,
                18
            ),

        GlassTransparency = 0.25,

        BorderColor =
            Color3.fromRGB(
                70,
                220,
                120
            ),

        BorderSize = 5,

        BorderTransparency = 0.15,

        AccentColor =
            Color3.fromRGB(
                70,
                220,
                120
            )
    },

    Yellow = {
        Name = "Yellow",

        BackgroundColor =
            Color3.fromRGB(
                15,
                12,
                5
            ),

        GlassColor =
            Color3.fromRGB(
                35,
                30,
                10
            ),

        GlassTransparency = 0.25,

        BorderColor =
            Color3.fromRGB(
                255,
                210,
                70
            ),

        BorderSize = 5,

        BorderTransparency = 0.15,

        AccentColor =
            Color3.fromRGB(
                255,
                210,
                70
            )
    }
}

--==============================================================
-- USE THEME PRESET
--==============================================================

function Library:UseTheme(name)

    local preset =
        self.ThemePresets[
            tostring(name)
        ]

    if not preset then
        return false
    end

    return self:SetFinalTheme(
        preset
    )
end

--==============================================================
-- BORDER API
--==============================================================

function Library:SetBorder(
    size,
    color,
    transparency
)

    self.FinalTheme.BorderSize =
        math.floor(
            ClampNumber(
                size,
                1,
                10,
                5
            )
        )

    if color ~= nil then

        self.FinalTheme.BorderColor =
            SafeColor(
                color,
                self.FinalTheme.BorderColor
            )
    end

    if transparency ~= nil then

        self.FinalTheme.BorderTransparency =
            ClampNumber(
                transparency,
                0,
                1,
                self.FinalTheme.BorderTransparency
            )
    end

    return true
end

--==============================================================
-- GLASS API
--==============================================================

function Library:SetGlass(
    color,
    transparency
)

    local finalColor =
        SafeColor(
            color,
            self.FinalTheme.GlassColor
        )

    self.FinalTheme.GlassColor =
        finalColor

    self.FinalTheme.GlassTint =
        finalColor

    if transparency ~= nil then

        self.FinalTheme.GlassTransparency =
            ClampNumber(
                transparency,
                0,
                1,
                self.FinalTheme.GlassTransparency
            )
    end

    return true
end

--==============================================================
-- APPLY STYLING TO INSTANCE
--==============================================================

local function ApplyInstanceTheme(
    object,
    theme
)

    pcall(function()

        if object:IsA("Frame")
            or object:IsA("ScrollingFrame")
            or object:IsA("ViewportFrame")
        then

            object.BackgroundColor3 =
                theme.GlassColor

            object.BackgroundTransparency =
                theme.GlassTransparency
        end

        if object:IsA("TextLabel")
            or object:IsA("TextButton")
            or object:IsA("TextBox")
        then

            object.TextColor3 =
                theme.TextColor
        end

        if object:IsA("UIStroke") then

            object.Color =
                theme.BorderColor

            object.Thickness =
                theme.BorderSize

            object.Transparency =
                theme.BorderTransparency
        end

        if object:IsA("UICorner") then

            object.CornerRadius =
                UDim.new(
                    0,
                    theme.CornerRadius
                )
        end

    end)

end

--==============================================================
-- APPLY THEME TO GUI
--==============================================================

function Library:ApplyFinalTheme(root)

    if not root then
        return false
    end

    local theme =
        self.FinalTheme

    pcall(function()

        if root:IsA("GuiObject") then

            root.BackgroundColor3 =
                theme.BackgroundColor
        end

        for _, object in ipairs(
            root:GetDescendants()
        ) do

            ApplyInstanceTheme(
                object,
                theme
            )

        end

    end)

    return true
end

--==============================================================
-- FIND PLAYER GUI
--==============================================================

local function GetPlayerGui()

    local ok, result =
        pcall(function()

            return LocalPlayer:
                FindFirstChildOfClass(
                    "PlayerGui"
                )

        end)

    if ok and result then
        return result
    end

    return nil
end

--==============================================================
-- GET KEY GUI
--==============================================================

local ExistingGetKeyGui = nil

local function DestroyGetKeyGui()

    if ExistingGetKeyGui then

        pcall(function()
            ExistingGetKeyGui:Destroy()
        end)

        ExistingGetKeyGui = nil
    end

end

--==============================================================
-- NOTIFICATION
--==============================================================

local function Notify(
    title,
    text,
    duration
)

    duration =
        tonumber(duration)
        or 3

    pcall(function()

        StarterGui:SetCore(
            "SendNotification",
            {
                Title = tostring(title),
                Text = tostring(text),
                Duration = duration
            }
        )

    end)

end

--==============================================================
-- GETKEY CONFIG
--==============================================================

Library.GetKey = {

    Enabled = false,

    Title = "Get Key",

    Note =
        "Nhập key để tiếp tục",

    Creator =
        "NHATLONG",

    --==========================================================
    -- KHÔNG ĐƯỢC THAY ĐỔI 2 CORE MESSAGE NÀY
    --==========================================================

    CoreMessages = {

        Invalid =
            "key đã hết hoặc sai key",

        Active =
            "Key còn hạn chơi game vv"

    },

    SuccessMessage =
        "nhập key đúng/key còn hạn\nchúc chơi vui vẽ :))",

    --==========================================================
    -- LINKS
    --==========================================================

    Links = {

        GetKey = "",

        Discord = "",

        TikTok = "",

        YouTube = "",

        Telegram = "",

        Website = "",

        Other = ""

    },

    Instructions =
        "Lấy key rồi nhập vào ô bên dưới.",

    --==========================================================
    -- AVATAR
    --==========================================================

    Avatar = {

        Enabled = true,

        Image = "",

        Size = 44,

        Gap = 10

    },

    --==========================================================
    -- LOCAL TEST KEY
    --==========================================================

    LocalKeys = {

        -- Example:
        -- ["123-890"] = {
        --     ExpiresAt = os.time() + 60,
        --     Users = {}
        -- }

    },

    --==========================================================
    -- SERVER MODE
    --==========================================================

    Mode = "Local",

    VerifyURL = "",

    --==========================================================
    -- UI
    --==========================================================

    UI = {

        Width = 430,

        Height = 330,

        MobileWidth = 350,

        MobileHeight = 355,

        CornerRadius = 18,

        Background =
            Color3.fromRGB(
                8,
                8,
                10
            ),

        GlassColor =
            Color3.fromRGB(
                18,
                18,
                22
            ),

        GlassTransparency = 0.30,

        BorderColor =
            Color3.fromRGB(
                80,
                80,
                88
            ),

        BorderSize = 5,

        BorderTransparency = 0.20,

        Accent =
            Color3.fromRGB(
                120,
                120,
                255
            )

    }

}

--==============================================================
-- GETKEY USER ID
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
-- CREATE LOCAL KEY
--==============================================================

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
        tonumber(maxUsers)
        or 1

    self.GetKey.LocalKeys[key] = {

        StartedAt = os.time(),

        ExpiresAt =
            os.time()
            + math.max(
                1,
                duration
            ),

        MaxUsers =
            math.max(
                1,
                math.floor(
                    maxUsers
                )
            ),

        Users = {}

    }

    return true
end

--==============================================================
-- REMOVE KEY
--==============================================================

function Library:RemoveKey(key)

    key =
        tostring(key or "")

    if self.GetKey.LocalKeys[key] then

        self.GetKey.LocalKeys[key] =
            nil

        return true
    end

    return false
end

--==============================================================
-- VERIFY LOCAL KEY
--==============================================================

local function VerifyLocalKey(
    config,
    key
)

    local data =
        config.LocalKeys[key]

    if not data then

        return false,
            config.CoreMessages.Invalid
    end

    if type(data) ~= "table" then

        return false,
            config.CoreMessages.Invalid
    end

    local expires =
        tonumber(
            data.ExpiresAt
        )

    if not expires
        or os.time() > expires
    then

        return false,
            config.CoreMessages.Invalid
    end

    data.Users =
        type(data.Users) == "table"
        and data.Users
        or {}

    local userId =
        tostring(
            LocalPlayer.UserId
        )

    if data.Users[userId] then

        return true,
            config.CoreMessages.Active
    end

    local maxUsers =
        tonumber(
            data.MaxUsers
        )
        or 1

    local used = 0

    for _ in pairs(
        data.Users
    ) do

        used =
            used + 1

    end

    if used >= maxUsers then

        return false,
            config.CoreMessages.Invalid
    end

    data.Users[userId] = true

    return true,
        config.CoreMessages.Active
end

--==============================================================
-- SERVER VERIFY
--==============================================================

local function VerifyServerKey(
    config,
    key
)

    if type(config.VerifyURL)
        ~= "string"
        or config.VerifyURL == ""
    then

        return false,
            config.CoreMessages.Invalid
    end

    local userId =
        tostring(
            LocalPlayer.UserId
        )

    local url =
        config.VerifyURL
        .. "?key="
        .. game:GetService(
            "HttpService"
        ):UrlEncode(key)
        .. "&userid="
        .. game:GetService(
            "HttpService"
        ):UrlEncode(userId)

    local ok, response =
        pcall(function()

            return game:HttpGet(
                url
            )

        end)

    if not ok then

        return false,
            config.CoreMessages.Invalid
    end

    if type(response)
        ~= "string"
    then

        return false,
            config.CoreMessages.Invalid
    end

    -- Server có thể trả:
    -- ACTIVE
    -- INVALID
    -- hoặc JSON có success=true

    if response == "ACTIVE"
        or response == "active"
    then

        return true,
            config.CoreMessages.Active
    end

    if response == "INVALID"
        or response == "invalid"
    then

        return false,
            config.CoreMessages.Invalid
    end

    local decoded

    pcall(function()

        decoded =
            game:GetService(
                "HttpService"
            ):JSONDecode(
                response
            )

    end)

    if type(decoded) == "table" then

        if decoded.success == true
            or decoded.active == true
        then

            return true,
                config.CoreMessages.Active
        end
    end

    return false,
        config.CoreMessages.Invalid
end

--==============================================================
-- VERIFY KEY API
--==============================================================

function Library:VerifyKey(key)

    key =
        tostring(key or "")

    if key == "" then

        return false,
            self.GetKey.CoreMessages.Invalid
    end

    if self.GetKey.Mode
        == "Server"
    then

        return VerifyServerKey(
            self.GetKey,
            key
        )
    end

    return VerifyLocalKey(
        self.GetKey,
        key
    )
end

--==============================================================
-- GETKEY GUI
--==============================================================

function Library:ShowGetKey(options)

    options =
        options
        or {}

    local config = {}

    for key, value in pairs(
        self.GetKey
    ) do

        config[key] = value

    end

    for key, value in pairs(
        options
    ) do

        config[key] = value

    end

    DestroyGetKeyGui()

    local PlayerGui =
        GetPlayerGui()

    if not PlayerGui then
        return false
    end

    local isMobile =
        UserInputService.TouchEnabled
        and not UserInputService.KeyboardEnabled

    local width =
        isMobile
        and config.UI.MobileWidth
        or config.UI.Width

    local height =
        isMobile
        and config.UI.MobileHeight
        or config.UI.Height

    --==========================================================
    -- SCREEN GUI
    --==========================================================

    local ScreenGui =
        Instance.new(
            "ScreenGui"
        )

    ScreenGui.Name =
        "NHATLONG_GetKey_FINAL"

    ScreenGui.ResetOnSpawn =
        false

    ScreenGui.IgnoreGuiInset =
        true

    ScreenGui.ZIndexBehavior =
        Enum.ZIndexBehavior.Sibling

    ScreenGui.Parent =
        PlayerGui

    ExistingGetKeyGui =
        ScreenGui

    --==========================================================
    -- BACKGROUND
    --==========================================================

    local Background =
        Instance.new(
            "Frame"
        )

    Background.Name =
        "Background"

    Background.Size =
        UDim2.fromScale(
            1,
            1
        )

    Background.BackgroundColor3 =
        Color3.fromRGB(
            0,
            0,
            0
        )

    Background.BackgroundTransparency =
        0.45

    Background.BorderSizePixel =
        0

    Background.Parent =
        ScreenGui

    --==========================================================
    -- MAIN CARD
    --==========================================================

    local Card =
        Instance.new(
            "Frame"
        )

    Card.Name =
        "GetKeyCard"

    Card.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    Card.Position =
        UDim2.fromScale(
            0.5,
            0.5
        )

    Card.Size =
        UDim2.fromOffset(
            width,
            height
        )

    Card.BackgroundColor3 =
        config.UI.GlassColor

    Card.BackgroundTransparency =
        config.UI.GlassTransparency

    Card.BorderSizePixel =
        0

    Card.Parent =
        ScreenGui

    local CardCorner =
        Instance.new(
            "UICorner"
        )

    CardCorner.CornerRadius =
        UDim.new(
            0,
            config.UI.CornerRadius
        )

    CardCorner.Parent =
        Card

    local CardStroke =
        Instance.new(
            "UIStroke"
        )

    CardStroke.Color =
        config.UI.BorderColor

    CardStroke.Thickness =
        math.clamp(
            tonumber(
                config.UI.BorderSize
            )
            or 5,
            1,
            10
        )

    CardStroke.Transparency =
        math.clamp(
            tonumber(
                config.UI.BorderTransparency
            )
            or 0.2,
            0,
            1
        )

    CardStroke.Parent =
        Card

    --==========================================================
    -- TOP AREA
    --==========================================================

    local Top =
        Instance.new(
            "Frame"
        )

    Top.BackgroundTransparency =
        1

    Top.Position =
        UDim2.fromOffset(
            18,
            15
        )

    Top.Size =
        UDim2.new(
            1,
            -36,
            0,
            58
        )

    Top.Parent =
        Card

    --==========================================================
    -- AVATAR
    --==========================================================

    local avatarEnabled =
        config.Avatar
        and config.Avatar.Enabled
        and type(
            config.Avatar.Image
        ) == "string"
        and config.Avatar.Image ~= ""

    local titleX = 0

    if avatarEnabled then

        local Avatar =
            Instance.new(
                "ImageLabel"
            )

        Avatar.Name =
            "Avatar"

        Avatar.BackgroundTransparency =
            1

        Avatar.Size =
            UDim2.fromOffset(
                tonumber(
                    config.Avatar.Size
                )
                or 44,
                tonumber(
                    config.Avatar.Size
                )
                or 44
            )

        Avatar.Position =
            UDim2.fromOffset(
                0,
                2
            )

        Avatar.Image =
            config.Avatar.Image

        Avatar.Parent =
            Top

        local AvatarCorner =
            Instance.new(
                "UICorner"
            )

        AvatarCorner.CornerRadius =
            UDim.new(
                1,
                0
            )

        AvatarCorner.Parent =
            Avatar

        titleX =
            (
                tonumber(
                    config.Avatar.Size
                )
                or 44
            )
            +
            (
                tonumber(
                    config.Avatar.Gap
                )
                or 10
            )
    end

    --==========================================================
    -- TITLE
    --==========================================================

    local Title =
        Instance.new(
            "TextLabel"
        )

    Title.BackgroundTransparency =
        1

    Title.Position =
        UDim2.fromOffset(
            titleX,
            0
        )

    Title.Size =
        UDim2.new(
            1,
            -titleX,
            0,
            30
        )

    Title.Font =
        Enum.Font.GothamBold

    Title.Text =
        tostring(
            config.Title
            or "Get Key"
        )

    Title.TextColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )

    Title.TextSize =
        20

    Title.TextXAlignment =
        Enum.TextXAlignment.Left

    Title.Parent =
        Top

    --==========================================================
    -- NOTE
    --==========================================================

    local Note =
        Instance.new(
            "TextLabel"
        )

    Note.BackgroundTransparency =
        1

    Note.Position =
        UDim2.fromOffset(
            titleX,
            31
        )

    Note.Size =
        UDim2.new(
            1,
            -titleX,
            0,
            24
        )

    Note.Font =
        Enum.Font.Gotham

    Note.Text =
        tostring(
            config.Note
            or ""
        )

    Note.TextColor3 =
        Color3.fromRGB(
            180,
            180,
            185
        )

    Note.TextSize =
        12

    Note.TextXAlignment =
        Enum.TextXAlignment.Left

    Note.Parent =
        Top

    --==========================================================
    -- CREATOR
    --==========================================================

    local Creator =
        Instance.new(
            "TextLabel"
        )

    Creator.BackgroundTransparency =
        1

    Creator.AnchorPoint =
        Vector2.new(
            1,
            0
        )

    Creator.Position =
        UDim2.new(
            1,
            0,
            0,
            5
        )

    Creator.Size =
        UDim2.fromOffset(
            100,
            20
        )

    Creator.Font =
        Enum.Font.GothamMedium

    Creator.Text =
        tostring(
            config.Creator
            or ""
        )

    Creator.TextColor3 =
        config.UI.Accent

    Creator.TextSize =
        11

    Creator.TextXAlignment =
        Enum.TextXAlignment.Right

    Creator.Parent =
        Top

    --==========================================================
    -- INSTRUCTIONS
    --==========================================================

    local Instruction =
        Instance.new(
            "TextLabel"
        )

    Instruction.BackgroundTransparency =
        1

    Instruction.Position =
        UDim2.fromOffset(
            20,
            82
        )

    Instruction.Size =
        UDim2.new(
            1,
            -40,
            0,
            42
        )

    Instruction.Font =
        Enum.Font.Gotham

    Instruction.Text =
        tostring(
            config.Instructions
            or ""
        )

    Instruction.TextColor3 =
        Color3.fromRGB(
            175,
            175,
            180
        )

    Instruction.TextSize =
        12

    Instruction.TextWrapped =
        true

    Instruction.TextXAlignment =
        Enum.TextXAlignment.Left

    Instruction.Parent =
        Card

    --==========================================================
    -- KEY BOX
    --==========================================================

    local KeyBox =
        Instance.new(
            "TextBox"
        )

    KeyBox.Name =
        "KeyBox"

    KeyBox.Position =
        UDim2.new(
            0,
            20,
            0,
            135
        )

    KeyBox.Size =
        UDim2.new(
            1,
            -40,
            0,
            46
        )

    KeyBox.BackgroundColor3 =
        Color3.fromRGB(
            5,
            5,
            7
        )

    KeyBox.BackgroundTransparency =
        0.10

    KeyBox.BorderSizePixel =
        0

    KeyBox.ClearTextOnFocus =
        false

    KeyBox.PlaceholderText =
        "Nhập key..."

    KeyBox.PlaceholderColor3 =
        Color3.fromRGB(
            110,
            110,
            115
        )

    KeyBox.Text =
        ""

    KeyBox.TextColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )

    KeyBox.TextSize =
        14

    KeyBox.Font =
        Enum.Font.Gotham

    KeyBox.Parent =
        Card

    local KeyCorner =
        Instance.new(
            "UICorner"
        )

    KeyCorner.CornerRadius =
        UDim.new(
            0,
            10
        )

    KeyCorner.Parent =
        KeyBox

    local KeyStroke =
        Instance.new(
            "UIStroke"
        )

    KeyStroke.Color =
        config.UI.BorderColor

    KeyStroke.Thickness =
        math.clamp(
            tonumber(
                config.UI.BorderSize
            )
            or 5,
            1,
            10
        )

    KeyStroke.Transparency =
        0.35

    KeyStroke.Parent =
        KeyBox

    --==========================================================
    -- VERIFY BUTTON
    --==========================================================

    local VerifyButton =
        Instance.new(
            "TextButton"
        )

    VerifyButton.Name =
        "VerifyButton"

    VerifyButton.Position =
        UDim2.new(
            0,
            20,
            0,
            192
        )

    VerifyButton.Size =
        UDim2.new(
            1,
            -40,
            0,
            42
        )

    VerifyButton.BackgroundColor3 =
        config.UI.Accent

    VerifyButton.BorderSizePixel =
        0

    VerifyButton.AutoButtonColor =
        false

    VerifyButton.Font =
        Enum.Font.GothamBold

    VerifyButton.Text =
        "XÁC ĐỊNH KEY"

    VerifyButton.TextColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )

    VerifyButton.TextSize =
        13

    VerifyButton.Parent =
        Card

    local VerifyCorner =
        Instance.new(
            "UICorner"
        )

    VerifyCorner.CornerRadius =
        UDim.new(
            0,
            10
        )

    VerifyCorner.Parent =
        VerifyButton

    --==========================================================
    -- STATUS
    --==========================================================

    local Status =
        Instance.new(
            "TextLabel"
        )

    Status.BackgroundTransparency =
        1

    Status.Position =
        UDim2.new(
            0,
            20,
            0,
            242
        )

    Status.Size =
        UDim2.new(
            1,
            -40,
            0,
            35
        )

    Status.Font =
        Enum.Font.GothamMedium

    Status.Text =
        ""

    Status.TextColor3 =
        Color3.fromRGB(
            180,
            180,
            185
        )

    Status.TextSize =
        12

    Status.TextWrapped =
        true

    Status.TextXAlignment =
        Enum.TextXAlignment.Center

    Status.Parent =
        Card

    --==========================================================
    -- LINKS
    --==========================================================

    local Links = {}

    local linkNames = {
        {
            "Get Key",
            config.Links
            and config.Links.GetKey
        },

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
        }
    }

    local linkIndex = 0

    for _, data in ipairs(
        linkNames
    ) do

        local name =
            data[1]

        local url =
            data[2]

        if type(url) == "string"
            and url ~= ""
        then

            local Button =
                Instance.new(
                    "TextButton"
                )

            Button.BackgroundTransparency =
                1

            Button.Size =
                UDim2.fromOffset(
                    75,
                    22
                )

            Button.Position =
                UDim2.new(
                    0,
                    20
                    + (
                        linkIndex
                        * 78
                    ),
                    1,
                    -30
                )

            Button.Text =
                name

            Button.TextColor3 =
                config.UI.Accent

            Button.TextSize =
                10

            Button.Font =
                Enum.Font.GothamMedium

            Button.Parent =
                Card

            Button.MouseButton1Click:
                Connect(function()

                    pcall(function()

                        if setclipboard then
                            setclipboard(url)
                        end

                    end)

                    Notify(
                        name,
                        "Link đã được copy.",
                        2
                    )

                end)

            table.insert(
                Links,
                Button
            )

            linkIndex =
                linkIndex + 1
        end
    end

    --==========================================================
    -- OPEN ANIMATION
    --==========================================================

    Card.Size =
        UDim2.fromOffset(
            width * 0.92,
            height * 0.92
        )

    Card.BackgroundTransparency =
        1

    TweenService:Create(
        Card,
        TweenInfo.new(
            0.28,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            Size =
                UDim2.fromOffset(
                    width,
                    height
                ),

            BackgroundTransparency =
                config.UI.GlassTransparency
        }
    ):Play()

    --==========================================================
    -- VERIFY
    --==========================================================

    local verifying = false

    local function Verify()

        if verifying then
            return
        end

        verifying = true

        VerifyButton.Text =
            "ĐANG KIỂM TRA..."

        Status.Text =
            ""

        local valid, message =
            Library:VerifyKey(
                KeyBox.Text
            )

        if valid then

            --==================================================
            -- CORE ACTIVE MESSAGE
            --==================================================

            Status.Text =
                Library.GetKey.CoreMessages.Active

            Status.TextColor3 =
                Color3.fromRGB(
                    80,
                    220,
                    120
                )

            task.wait(0.45)

            --==================================================
            -- SUCCESS
            --==================================================

            Notify(
                "Key",
                Library.GetKey.SuccessMessage,
                3
            )

            task.wait(0.20)

            DestroyGetKeyGui()

            --==================================================
            -- OPEN NEXT MENU
            --==================================================

            if type(
                Library._PendingLaunch
            ) == "function"
            then

                local callback =
                    Library._PendingLaunch

                Library._PendingLaunch =
                    nil

                task.defer(
                    function()

                        pcall(
                            callback
                        )

                    end
                )

            end

        else

            --==================================================
            -- CORE INVALID MESSAGE
            --==================================================

            Status.Text =
                Library.GetKey.CoreMessages.Invalid

            Status.TextColor3 =
                Color3.fromRGB(
                    255,
                    90,
                    90
                )

            VerifyButton.Text =
                "XÁC ĐỊNH KEY"

        end

        verifying = false

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

    return ScreenGui
end

--==============================================================
-- REQUIRE KEY
--==============================================================

function Library:RequireKey(options)

    options =
        options
        or {}

    local callback =
        options.OnSuccess

    self._PendingLaunch =
        callback

    return self:ShowGetKey(
        options
    )
end

--==============================================================
-- DEFAULT MAIN MENU OPTIONS
--==============================================================

Library.DefaultMenu = {

    Title =
        "NHATLONG",

    Subtitle =
        "Main Library",

    Width = 507,

    Height = 384

}

--==============================================================
-- CREATE MAIN MENU
--==============================================================

function Library:CreateMainMenu(
    options
)

    options =
        options
        or {}

    local final = {}

    for key, value in pairs(
        self.DefaultMenu
    ) do

        final[key] =
            value

    end

    for key, value in pairs(
        options
    ) do

        final[key] =
            value

    end

    local window

    local ok, result =
        pcall(function()

            return self:CreateWindow(
                final
            )

        end)

    if ok then
        window = result
    end

    if window then

        task.defer(
            function()

                self:ApplyFinalTheme(
                    window
                )

            end
        )

    end

    return window
end

--==============================================================
-- CREATE CUSTOM MENU
--==============================================================

function Library:CreateCustomMenu(
    config
)

    config =
        config
        or {}

    -- Creator tự tạo menu bằng callback.
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
                "[NHATLONG V21] Custom menu error: "
                .. tostring(result)
            )

            return nil
        end

        if result then

            task.defer(
                function()

                    self:ApplyFinalTheme(
                        result
                    )

                end
            )

        end

        return result
    end

    -- Không có callback:
    -- tạo menu bằng CreateWindow của Library.
    return self:CreateMainMenu(
        config.Options
        or config
    )
end

--==============================================================
-- SCRIPT ROUTING
--==============================================================

--[[

CASE 1
---------------------------------------------------------------
GetKey = true
CustomMenu = nil

GetKey
   ↓
Valid Key
   ↓
Close GetKey
   ↓
Main Library

CASE 2
---------------------------------------------------------------
GetKey = true
CustomMenu = {...}

GetKey
   ↓
Valid Key
   ↓
Close GetKey
   ↓
Custom Menu

CASE 3
---------------------------------------------------------------
GetKey = false
CustomMenu = {...}

Custom Menu

CASE 4 - DEFAULT
---------------------------------------------------------------
GetKey = false
CustomMenu = nil

Main Library automatically.

]]

function Library:CreateScript(
    config
)

    config =
        config
        or {}

    local getKey =
        config.GetKey

    local getKeyEnabled =
        type(getKey) == "table"
        and getKey.Enabled == true

    local customMenu =
        config.CustomMenu

    local hasCustomMenu =
        type(customMenu) == "table"

    --==========================================================
    -- APPLY GETKEY CONFIG
    --==========================================================

    if getKeyEnabled then

        for key, value in pairs(
            getKey
        ) do

            if key ~= "CoreMessages"
                and key ~= "UI"
                and key ~= "Avatar"
                and key ~= "Links"
            then

                self.GetKey[key] =
                    value

            end

        end

        -- Nested UI
        if type(getKey.UI)
            == "table"
        then

            for key, value in pairs(
                getKey.UI
            ) do

                self.GetKey.UI[key] =
                    value

            end

        end

        -- Nested Avatar
        if type(getKey.Avatar)
            == "table"
        then

            for key, value in pairs(
                getKey.Avatar
            ) do

                self.GetKey.Avatar[key] =
                    value

            end

        end

        -- Nested Links
        if type(getKey.Links)
            == "table"
        then

            for key, value in pairs(
                getKey.Links
            ) do

                self.GetKey.Links[key] =
                    value

            end

        end

        --======================================================
        -- NEVER ALLOW CREATOR TO CHANGE CORE MESSAGES
        --======================================================

        self.GetKey.CoreMessages.Invalid =
            "key đã hết hoặc sai key"

        self.GetKey.CoreMessages.Active =
            "Key còn hạn chơi game vv"

    end

    --==========================================================
    -- NEXT MENU
    --==========================================================

    local function OpenNextMenu()

        --======================================================
        -- CASE 2:
        -- GETKEY + CUSTOM MENU
        --======================================================

        if getKeyEnabled
            and hasCustomMenu
        then

            return self:CreateCustomMenu(
                customMenu
            )
        end

        --======================================================
        -- CASE 1:
        -- GETKEY + NO CUSTOM MENU
        --======================================================

        if getKeyEnabled
            and not hasCustomMenu
        then

            return self:CreateMainMenu(
                config.MainMenu
                or {}
            )
        end

        --======================================================
        -- CASE 3:
        -- NO GETKEY + CUSTOM MENU
        --======================================================

        if not getKeyEnabled
            and hasCustomMenu
        then

            return self:CreateCustomMenu(
                customMenu
            )
        end

        --======================================================
        -- CASE 4:
        -- NOTHING SPECIFIED
        -- DEFAULT MAIN LIBRARY
        --======================================================

        return self:CreateMainMenu(
            config.MainMenu
            or {}
        )
    end

    --==========================================================
    -- GETKEY FIRST
    --==========================================================

    if getKeyEnabled then

        self._PendingLaunch =
            OpenNextMenu

        return self:ShowGetKey(
            self.GetKey
        )
    end

    --==========================================================
    -- NO GETKEY
    --==========================================================

    return OpenNextMenu()
end

--==============================================================
-- FINAL SETTINGS
--==============================================================

pcall(function()

    if type(
        Library.Settings
    ) == "table"
    then

        Library.Settings.MenuWidth =
            507

        Library.Settings.MenuHeight =
            384

        Library.Settings.Transparency =
            57

        Library.Settings.AnimationSpeed =
            1.0

        Library.Settings.FloatingButton =
            false

    end

end)

--==============================================================
-- DEFAULT BLACK THEME
--==============================================================

Library:UseTheme(
    "Black"
)

--==============================================================
-- EXPORT FINAL API
--==============================================================

Library.FinalAPI = {

    SetTheme =
        function(options)

            return Library:SetFinalTheme(
                options
            )

        end,

    UseTheme =
        function(name)

            return Library:UseTheme(
                name
            )

        end,

    SetBorder =
        function(
            size,
            color,
            transparency
        )

            return Library:SetBorder(
                size,
                color,
                transparency
            )

        end,

    SetGlass =
        function(
            color,
            transparency
        )

            return Library:SetGlass(
                color,
                transparency
            )

        end,

    CreateScript =
        function(config)

            return Library:CreateScript(
                config
            )

        end,

    CreateMainMenu =
        function(options)

            return Library:CreateMainMenu(
                options
            )

        end,

    CreateCustomMenu =
        function(config)

            return Library:CreateCustomMenu(
                config
            )

        end,

    VerifyKey =
        function(key)

            return Library:VerifyKey(
                key
            )

        end,

    CreateKey =
        function(
            key,
            duration,
            maxUsers
        )

            return Library:CreateKey(
                key,
                duration,
                maxUsers
            )

        end,

    RemoveKey =
        function(key)

            return Library:RemoveKey(
                key
            )

        end

}

--==============================================================
-- EXAMPLE CONFIG
--==============================================================

--[[
----------------------------------------------------------------
-- 1. KHÔNG GETKEY + KHÔNG CUSTOM
--    => TỰ ĐỘNG MAIN LIBRARY
----------------------------------------------------------------

Library:CreateScript({
})

----------------------------------------------------------------
-- 2. GETKEY + MAIN LIBRARY
----------------------------------------------------------------

Library:CreateKey(
    "123-890",
    60,
    1
)

Library:CreateScript({

    GetKey = {

        Enabled = true,

        Title = "Get Key",

        Note =
            "Nhập key để vào script",

        Creator =
            "BY NHATLONG",

        SuccessMessage =
            "nhập key đúng/key còn hạn\nchúc chơi vui vẽ :))",

        Mode = "Local",

        Links = {

            GetKey =
                "https://example.com",

            Discord =
                "https://discord.com",

            TikTok =
                "https://tiktok.com",

            YouTube =
                "https://youtube.com",

            Telegram =
                "https://telegram.org"

        },

        Avatar = {

            Enabled = true,

            Image =
                "rbxassetid://123456789",

            Size = 44,

            Gap = 10

        },

        UI = {

            Width = 430,

            Height = 330,

            MobileWidth = 350,

            MobileHeight = 355,

            CornerRadius = 18,

            Background =
                Color3.fromRGB(
                    8,
                    8,
                    10
                ),

            GlassColor =
                Color3.fromRGB(
                    18,
                    18,
                    22
                ),

            GlassTransparency = 0.30,

            BorderColor =
                Color3.fromRGB(
                    80,
                    80,
                    88
                ),

            -- 1 -> 10
            -- 5 = vừa
            BorderSize = 5,

            BorderTransparency = 0.20,

            Accent =
                Color3.fromRGB(
                    120,
                    120,
                    255
                )

        }

    }

})

----------------------------------------------------------------
-- 3. GETKEY + CUSTOM MENU 2
----------------------------------------------------------------

Library:CreateKey(
    "123-890",
    60,
    1
)

Library:CreateScript({

    GetKey = {

        Enabled = true,

        Title = "NHATLONG KEY",

        Note =
            "Key riêng của script",

        Mode = "Local"

    },

    CustomMenu = {

        Options = {

            Title =
                "SCRIPT MENU 2",

            Subtitle =
                "Custom Menu"

        },

        Create = function(Library)

            local Window =
                Library:CreateWindow({

                    Title =
                        "SCRIPT MENU 2",

                    Subtitle =
                        "BY NHATLONG"

                })

            -- tạo tab ở đây

            return Window
        end

    }

})

----------------------------------------------------------------
-- 4. KHÔNG GETKEY + CUSTOM MENU
----------------------------------------------------------------

Library:CreateScript({

    CustomMenu = {

        Create = function(Library)

            local Window =
                Library:CreateWindow({

                    Title =
                        "MY SCRIPT",

                    Subtitle =
                        "Custom Menu"

                })

            return Window
        end

    }

})

----------------------------------------------------------------
-- THEME
----------------------------------------------------------------

Library:SetFinalTheme({

    Name = "Black",

    GlassColor =
        Color3.fromRGB(
            20,
            20,
            25
        ),

    -- GlassColor và GlassTint luôn dùng cùng màu

    GlassTransparency = 0.30,

    BorderColor =
        Color3.fromRGB(
            100,
            100,
            110
        ),

    -- 1 -> 10
    -- 5 = vừa
    BorderSize = 5,

    BorderTransparency = 0.20

})

----------------------------------------------------------------
-- ĐỔI ĐỘ DÀY VIỀN
----------------------------------------------------------------

Library:SetBorder(
    5
)

-- 1 = mỏng nhất
-- 5 = vừa
-- 10 = dày nhất

----------------------------------------------------------------
-- ĐỔI KÍNH
----------------------------------------------------------------

Library:SetGlass(
    Color3.fromRGB(
        20,
        20,
        25
    ),
    0.30
)

----------------------------------------------------------------
-- THEME PRESET
----------------------------------------------------------------

Library:UseTheme("Black")
-- Black
-- Dark
-- White
-- Red
-- Blue
-- Purple
-- Green
-- Yellow

]]

--==============================================================
-- FINAL RETURN
--==============================================================

return Library
