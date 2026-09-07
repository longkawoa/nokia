--[[
===============================================================
 LONG UI LIBRARY
 VERSION: V33.0 FINAL LOADER
===============================================================

 FEATURES:
 - V32 / V31 compatibility
 - Automatic fallback loading
 - Runtime validation
 - Compile error handling
 - Safe HttpGet
 - No duplicate libraries
 - Backward compatible loading
 - GetKey support from V31/V32
 - CreateKey / VerifyKey support
 - Mobile / Touch support from loaded library
 - Theme / UI support from loaded library
 - Safe failure messages

 IMPORTANT:
 This loader loads ONE compatible library only.
 It does NOT execute every historical library simultaneously.

 LOAD ORDER:
 V32
 V31
 V30
 V25
 V21
 V20
 V15
 V13
 V12
 V11
 V10
 V9
 V8
 V7
 V6
 V5
 V4
 V3
 V2
 V1

===============================================================
]]

local LONG = {}

--==============================================================
-- SERVICES
--==============================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

--==============================================================
-- VERSION
--==============================================================

LONG.Version = "V33.0"
LONG.Name = "LONG UI LIBRARY"

--==============================================================
-- SOURCE LIST
--==============================================================

LONG.Sources = {

    {
        Version = "V32",
        URL = "https://raw.githubusercontent.com/longkawoa/nokia/refs/heads/main/nhatlong-library%2B2-v32.lua"
    },

    {
        Version = "V31",
        URL = "https://raw.githubusercontent.com/longkawoa/nokia/refs/heads/main/Nhatlong-library-getkey/Nhatlong-library-getkey-memu-v31.lua"
    },

    {
        Version = "V30",
        URL = "https://raw.githubusercontent.com/longkawoa/nokia/refs/heads/main/Nhatlong-library-v30.lua"
    },

    {
        Version = "V25",
        URL = "https://raw.githubusercontent.com/longkawoa/nokia/refs/heads/main/nokia-nhatlong-library-v25.lua"
    },

    {
        Version = "V21",
        URL = "https://raw.githubusercontent.com/longkawoa/nokia/refs/heads/main/NHATLONG_library_nokiav21.lua"
    },

    {
        Version = "V20",
        URL = "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/NHATLONG-library-v20.lua"
    },

    {
        Version = "V15",
        URL = "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/menulibrary_by_nhatlong_v15noki.lua"
    },

    {
        Version = "V13",
        URL = "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/by-nhat-long-V13-LIBRARY.lua"
    },

    {
        Version = "V12",
        URL = "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/bynhatlong-v12-Library.lua"
    },

    {
        Version = "V11",
        URL = "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/by-nhatlong-library-v11.lua"
    },

    {
        Version = "V10",
        URL = "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/nhatlong-library-v10.0.lua"
    },

    {
        Version = "V9",
        URL = "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/by-nhatlong-v9"
    },

    {
        Version = "V8",
        URL = "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/bynhatlong-v8-Library"
    },

    {
        Version = "V7",
        URL = "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/nhatlong-library-v7"
    },

    {
        Version = "V6",
        URL = "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/Long-libraly-v6"
    },

    {
        Version = "V5",
        URL = "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/long-library-5-new"
    },

    {
        Version = "V4",
        URL = "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/Long-Library-4"
    },

    {
        Version = "V3",
        URL = "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/Long-Library-3"
    },

    {
        Version = "V2",
        URL = "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/Long-Library-2"
    },

    {
        Version = "V1",
        URL = "https://raw.githubusercontent.com/longkawoa/Script-roblox-/refs/heads/main/long-Library-chester-v1"
    }
}

--==============================================================
-- OPTIONAL LEGACY GETKEY SOURCE
--==============================================================

LONG.GetKeySource =
    "https://raw.githubusercontent.com/longkawoa/nokia/refs/heads/main/Nhatlong-library-getkey/Nhatlong-library-getkey-memu-v31.lua"

--==============================================================
-- DEFAULT SETTINGS
--==============================================================

LONG.Settings = {

    MenuWidth = 507,
    MenuHeight = 384,
    SidebarWidth = 145,

    UIScale = 100,

    CornerRadius = 10,

    AnimationSpeed = 18,

    Transparency = 57,

    GlassMode = false,

    TabSearch = true,

    Notifications = true,

    Dragging = true,

    CloseConfirmation = true,

    ShowTabIcons = true,

    AutoFitScreen = true,

    AccentPreset = "Purple",

    ThemePreset = "Purple",

    Language = "Vietnamese",

    Font = "Gotham"
}

--==============================================================
-- SAFE ERROR
--==============================================================

local function ErrorMessage(message)

    warn(
        "[LONG UI LIBRARY V33] "
        .. tostring(message)
    )

end

--==============================================================
-- SAFE HTTP
--==============================================================

local function HttpGet(url)

    if type(url) ~= "string" or url == "" then
        return false, "Invalid URL"
    end

    local ok, result = pcall(function()

        return game:HttpGet(url)

    end)

    if not ok then

        return false, tostring(result)

    end

    if type(result) ~= "string" then

        return false, "HttpGet did not return string"

    end

    if #result < 100 then

        return false, "Source is too small"

    end

    return true, result

end

--==============================================================
-- SAFE LOADSTRING
--==============================================================

local function Compile(source)

    if type(loadstring) ~= "function" then

        return false,
            "loadstring is unavailable in this executor"

    end

    local ok, chunk, compileError =
        pcall(function()

            return loadstring(source)

        end)

    if not ok then

        return false, tostring(chunk)

    end

    if type(chunk) ~= "function" then

        return false,
            tostring(compileError or "Invalid compiled chunk")

    end

    return true, chunk

end

--==============================================================
-- EXECUTE SOURCE
--==============================================================

local function Execute(chunk)

    local ok, result =
        pcall(chunk)

    if not ok then

        return false, tostring(result)

    end

    if type(result) ~= "table" then

        return false,
            "Library source did not return a table"

    end

    return true, result

end

--==============================================================
-- LIBRARY VALIDATION
--==============================================================

local function ValidateLibrary(library)

    if type(library) ~= "table" then

        return false

    end

    -- At least one recognizable Library API
    local recognizable = {

        "CreateWindow",
        "CreateTab",
        "CreateKey",
        "CreateGetKey",
        "BuildGetKeyConfig",
        "VerifyKey"
    }

    for _, method in ipairs(recognizable) do

        if type(library[method]) == "function" then

            return true

        end

    end

    return false

end

--==============================================================
-- LOAD ONE SOURCE
--==============================================================

local function LoadSource(entry)

    local okHttp, source =
        HttpGet(entry.URL)

    if not okHttp then

        return false,
            "HttpGet: " .. tostring(source)

    end

    local okCompile, chunk =
        Compile(source)

    if not okCompile then

        return false,
            "Compile: " .. tostring(chunk)

    end

    local okExecute, library =
        Execute(chunk)

    if not okExecute then

        return false,
            "Runtime: " .. tostring(library)

    end

    if not ValidateLibrary(library) then

        return false,
            "Returned table is not a recognized LONG UI Library"

    end

    return true, library

end

--==============================================================
-- LOAD LATEST COMPATIBLE LIBRARY
--==============================================================

function LONG:Load()

    local failures = {}

    for _, entry in ipairs(self.Sources) do

        local ok, library =
            LoadSource(entry)

        if ok then

            self.Library = library

            self.LoadedVersion =
                entry.Version

            self.LoadedURL =
                entry.URL

            return library

        end

        failures[#failures + 1] =
            entry.Version
            .. ": "
            .. tostring(library)

    end

    ErrorMessage(
        "Unable to load any compatible library."
    )

    for _, failure in ipairs(failures) do

        warn(
            "[LONG UI LIBRARY] "
            .. failure
        )

    end

    return nil

end

--==============================================================
-- SETTINGS NORMALIZER
--==============================================================

function LONG:NormalizeSettings()

    local settings = self.Settings

    settings.MenuWidth =
        math.clamp(
            tonumber(settings.MenuWidth) or 507,
            280,
            1200
        )

    settings.MenuHeight =
        math.clamp(
            tonumber(settings.MenuHeight) or 384,
            220,
            900
        )

    settings.SidebarWidth =
        math.clamp(
            tonumber(settings.SidebarWidth) or 145,
            90,
            300
        )

    settings.UIScale =
        math.clamp(
            tonumber(settings.UIScale) or 100,
            50,
            150
        )

    settings.CornerRadius =
        math.clamp(
            tonumber(settings.CornerRadius) or 10,
            0,
            50
        )

    settings.AnimationSpeed =
        math.clamp(
            tonumber(settings.AnimationSpeed) or 18,
            1,
            60
        )

    settings.Transparency =
        math.clamp(
            tonumber(settings.Transparency) or 57,
            0,
            100
        )

    return settings

end

--==============================================================
-- APPLY SETTINGS
--==============================================================

function LONG:ApplySettings()

    self:NormalizeSettings()

    local library = self.Library

    if type(library) ~= "table" then
        return false
    end

    -- Copy settings when supported
    if type(library.Settings) ~= "table" then

        library.Settings = {}

    end

    for key, value in pairs(self.Settings) do

        pcall(function()

            library.Settings[key] = value

        end)

    end

    -- Optional Configure API
    if type(library.Configure) == "function" then

        pcall(function()

            library:Configure({

                MenuWidth =
                    self.Settings.MenuWidth,

                MenuHeight =
                    self.Settings.MenuHeight,

                SidebarWidth =
                    self.Settings.SidebarWidth,

                UIScale =
                    self.Settings.UIScale,

                CornerRadius =
                    self.Settings.CornerRadius,

                AnimationSpeed =
                    self.Settings.AnimationSpeed,

                Transparency =
                    self.Settings.Transparency,

                GlassMode =
                    self.Settings.GlassMode,

                TabSearch =
                    self.Settings.TabSearch,

                Notifications =
                    self.Settings.Notifications,

                Dragging =
                    self.Settings.Dragging,

                CloseConfirmation =
                    self.Settings.CloseConfirmation,

                ShowTabIcons =
                    self.Settings.ShowTabIcons,

                AutoFitScreen =
                    self.Settings.AutoFitScreen,

                Theme =
                    self.Settings.ThemePreset,

                Accent =
                    self.Settings.AccentPreset,

                Language =
                    self.Settings.Language,

                Font =
                    self.Settings.Font

            })

        end)

    end

    return true

end

--==============================================================
-- THEME BRIDGE
--==============================================================

function LONG:SetTheme(theme)

    theme = tostring(theme or "")

    self.Settings.ThemePreset = theme

    local library = self.Library

    if not library then
        return false
    end

    if type(library.SetTheme) == "function" then

        local ok =
            pcall(function()

                library:SetTheme(theme)

            end)

        return ok

    end

    return false

end

--==============================================================
-- ACCENT BRIDGE
--==============================================================

function LONG:SetAccent(accent)

    accent = tostring(accent or "")

    self.Settings.AccentPreset = accent

    local library = self.Library

    if not library then
        return false
    end

    if type(library.SetAccentColor) == "function" then

        local ok =
            pcall(function()

                library:SetAccentColor(accent)

            end)

        return ok

    end

    return false

end

--==============================================================
-- LANGUAGE BRIDGE
--==============================================================

function LONG:SetLanguage(language)

    language = tostring(language or "")

    self.Settings.Language = language

    local library = self.Library

    if not library then
        return false
    end

    if type(library.SetLanguage) == "function" then

        local ok =
            pcall(function()

                library:SetLanguage(language)

            end)

        return ok

    end

    return false

end

--==============================================================
-- RGB BRIDGE
--==============================================================

function LONG:SetRGB(r, g, b)

    r = math.clamp(
        tonumber(r) or 255,
        0,
        255
    )

    g = math.clamp(
        tonumber(g) or 255,
        0,
        255
    )

    b = math.clamp(
        tonumber(b) or 255,
        0,
        255
    )

    local library = self.Library

    if not library then
        return false
    end

    if type(library.SetRGB) == "function" then

        local ok =
            pcall(function()

                library:SetRGB(r, g, b)

            end)

        return ok

    end

    if type(library.SetAccentColor) == "function" then

        local ok =
            pcall(function()

                library:SetAccentColor(
                    Color3.fromRGB(r, g, b)
                )

            end)

        return ok

    end

    return false

end

--==============================================================
-- GLASS BRIDGE
--==============================================================

function LONG:SetGlassMode(enabled)

    enabled = enabled == true

    self.Settings.GlassMode = enabled

    local library = self.Library

    if not library then
        return false
    end

    if type(library.SetGlassMode) == "function" then

        local ok =
            pcall(function()

                library:SetGlassMode(enabled)

            end)

        return ok

    end

    return false

end

--==============================================================
-- TRANSPARENCY
--==============================================================

function LONG:SetTransparency(value)

    value = tonumber(value) or 57

    if value > 1 then

        value = value / 100

    end

    value =
        math.clamp(
            value,
            0,
            1
        )

    self.Settings.Transparency =
        value * 100

    local library = self.Library

    if not library then
        return false
    end

    if type(library.SetTransparency) == "function" then

        local ok =
            pcall(function()

                library:SetTransparency(value)

            end)

        return ok

    end

    if type(library.Refresh) == "function" then

        pcall(function()

            library:Refresh()

        end)

    end

    return true

end

--==============================================================
-- GETKEY BRIDGE
--==============================================================

function LONG:ConfigureGetKey(config)

    if type(config) ~= "table" then

        config = {}

    end

    local library = self.Library

    if not library then
        return false
    end

    if type(library.BuildGetKeyConfig) == "function" then

        local ok, result =
            pcall(function()

                return library:BuildGetKeyConfig(
                    config
                )

            end)

        if ok then

            self.GetKeyConfig = result

            return true, result

        end

    end

    self.GetKeyConfig = config

    return true, config

end

--==============================================================
-- CREATE KEY BRIDGE
--==============================================================

function LONG:CreateKey(key, duration, maxUsers)

    local library = self.Library

    if not library then
        return false
    end

    if type(library.CreateKey) ~= "function" then

        return false

    end

    local ok, result =
        pcall(function()

            return library:CreateKey(
                key,
                duration,
                maxUsers
            )

        end)

    if not ok then

        ErrorMessage(result)

        return false

    end

    return result

end

--==============================================================
-- VERIFY KEY BRIDGE
--==============================================================

function LONG:VerifyKey(key, config)

    local library = self.Library

    if not library then
        return false,
            "Library not loaded"
    end

    if type(library.VerifyKey) ~= "function" then

        return false,
            "VerifyKey is unavailable"
    end

    local ok, valid, message =
        pcall(function()

            return library:VerifyKey(
                key,
                config
            )

        end)

    if not ok then

        return false,
            tostring(valid)

    end

    return valid, message

end

--==============================================================
-- SAFE LIBRARY CALL
--==============================================================

function LONG:Call(method, ...)

    local library = self.Library

    if not library then

        return false,
            "Library not loaded"

    end

    if type(library[method]) ~= "function" then

        return false,
            "API unavailable: "
            .. tostring(method)

    end

    local args = table.pack(...)

    local ok, result =
        pcall(function()

            return library[method](
                library,
                table.unpack(
                    args,
                    1,
                    args.n
                )
            )

        end)

    if not ok then

        return false,
            tostring(result)

    end

    return true, result

end

--==============================================================
-- LOAD
--==============================================================

LONG:NormalizeSettings()

local Library = LONG:Load()

if not Library then

    error(
        "[LONG UI LIBRARY V33] "
        .. "No compatible library could be loaded."
    )

end

--==============================================================
-- APPLY DEFAULTS
--==============================================================

LONG:ApplySettings()

--==============================================================
-- EXPOSE VERSION
--==============================================================

pcall(function()

    Library.LongLoaderVersion =
        LONG.Version

    Library.LongLoadedVersion =
        LONG.LoadedVersion

    Library.LongLoadedURL =
        LONG.LoadedURL

    Library.LongSources =
        LONG.Sources

end)

--==============================================================
-- BACKWARD-COMPATIBLE VALUES
--==============================================================

if type(Library.Values) ~= "table" then

    Library.Values = {}

end

if type(Library.SetValue) ~= "function" then

    function Library:SetValue(key, value)

        self.Values[key] = value

    end

end

if type(Library.GetValue) ~= "function" then

    function Library:GetValue(key)

        return self.Values[key]

    end

end

--==============================================================
-- WINDOW REGISTRY
--==============================================================

if type(Library.Windows) ~= "table" then

    Library.Windows = {}

end

--==============================================================
-- HIDE ALL
--==============================================================

if type(Library.HideAll) ~= "function" then

    function Library:HideAll()

        for _, window in pairs(
            self.Windows
        ) do

            if type(window) == "table"
                and type(window.Hide) == "function"
            then

                pcall(function()

                    window:Hide()

                end)

            end

        end

    end

end

--==============================================================
-- SHOW ALL
--==============================================================

if type(Library.ShowAll) ~= "function" then

    function Library:ShowAll()

        for _, window in pairs(
            self.Windows
        ) do

            if type(window) == "table"
                and type(window.Show) == "function"
            then

                pcall(function()

                    window:Show()

                end)

            end

        end

    end

end

--==============================================================
-- TOGGLE ALL
--==============================================================

if type(Library.ToggleAll) ~= "function" then

    function Library:ToggleAll()

        for _, window in pairs(
            self.Windows
        ) do

            if type(window) == "table"
                and type(window.Toggle) == "function"
            then

                pcall(function()

                    window:Toggle()

                end)

            end

        end

    end

end

--==============================================================
-- REFRESH
--==============================================================

if type(Library.Refresh) == "function" then

    pcall(function()

        Library:Refresh()

    end)

end

--==============================================================
-- RETURN
--==============================================================

return Library
