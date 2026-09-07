--[[
===============================================================
 NHATLONG LIBRARY V31 PATCHED LOADER
===============================================================

 SOURCE:
 Nhatlong-library-getkey-memu-v31.lua

 PATCH:
 - Preserve original Library
 - Preserve original API
 - Preserve GetKey architecture
 - Fix transparency normalization
 - Add safe theme presets
 - Preserve CreateScript
 - Preserve CreateGetKey
 - Preserve VerifyKey
 - Preserve OpenLibraryAfterSuccess
 - Preserve Mobile / Touch / Drag
===============================================================
]]

local SOURCE_URL =
    "https://raw.githubusercontent.com/longkawoa/nokia/refs/heads/main/Nhatlong-library-getkey/Nhatlong-library-getkey-memu-v31.lua"

--==============================================================
-- SAFE HTTP
--==============================================================

local function SafeHttpGet(url)
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok then
        error(
            "[NHATLONG PATCH] HttpGet failed:\n"
            .. tostring(result)
        )
    end

    if type(result) ~= "string" then
        error(
            "[NHATLONG PATCH] Invalid source."
        )
    end

    if #result < 1000 then
        error(
            "[NHATLONG PATCH] Source too small."
        )
    end

    return result
end

--==============================================================
-- LOAD ORIGINAL V31
--==============================================================

local Source =
    SafeHttpGet(SOURCE_URL)

local Chunk, CompileError =
    loadstring(Source)

if not Chunk then
    error(
        "[NHATLONG PATCH] Compile error:\n"
        .. tostring(CompileError)
    )
end

local ok, Library =
    pcall(Chunk)

if not ok then
    error(
        "[NHATLONG PATCH] Runtime error:\n"
        .. tostring(Library)
    )
end

if type(Library) ~= "table" then
    error(
        "[NHATLONG PATCH] Library did not return table."
    )
end

--==============================================================
-- SAFE HELPERS
--==============================================================

local function Number(value, default)
    value = tonumber(value)

    if not value then
        return default
    end

    if value ~= value then
        return default
    end

    if value == math.huge
        or value == -math.huge
    then
        return default
    end

    return value
end

local function Clamp(value, minValue, maxValue, default)
    value = Number(value, default)

    return math.clamp(
        value,
        minValue,
        maxValue
    )
end

--==============================================================
-- TRANSPARENCY NORMALIZER
--
-- Supported:
--
-- 0       -> 0
-- 0.30    -> 0.30
-- 1       -> 1
-- 30      -> 0.30
-- 57      -> 0.57
-- 100     -> 1
-- 300     -> 0.30
-- 500     -> 0.50
-- 1000    -> 1
--==============================================================

local function NormalizeTransparency(
    value,
    default
)

    value =
        tonumber(value)

    if not value then
        return default
    end

    if value ~= value then
        return default
    end

    if value == math.huge
        or value == -math.huge
    then
        return default
    end

    if value >= 0
        and value <= 1
    then

        return value

    end

    if value > 1
        and value <= 100
    then

        return math.clamp(
            value / 100,
            0,
            1
        )

    end

    if value > 100 then

        return math.clamp(
            value / 1000,
            0,
            1
        )

    end

    return default
end

--==============================================================
-- SAFE COLOR
--==============================================================

local function SafeColor(
    value,
    fallback
)

    if typeof(value) == "Color3" then
        return value
    end

    if type(value) == "table" then

        local r =
            tonumber(value[1])

        local g =
            tonumber(value[2])

        local b =
            tonumber(value[3])

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
-- SAFE COLOR EXPORT
--==============================================================

local function RGB(
    r,
    g,
    b
)

    return Color3.fromRGB(
        math.clamp(
            tonumber(r) or 0,
            0,
            255
        ),
        math.clamp(
            tonumber(g) or 0,
            0,
            255
        ),
        math.clamp(
            tonumber(b) or 0,
            0,
            255
        )
    )
end

--==============================================================
-- THEME DEFAULTS
--==============================================================

local Themes = {}

Themes["Black Glass"] = {

    GlassColor =
        RGB(7, 7, 10),

    GlassTransparency =
        0.30,

    BorderColor =
        RGB(80, 80, 95),

    BorderSize =
        2,

    BorderTransparency =
        0.20,

    Accent =
        RGB(120, 120, 255),

    TextColor =
        RGB(255, 255, 255),

    SecondaryText =
        RGB(175, 175, 185),

    InputColor =
        RGB(12, 12, 16)

}

Themes["Dark Glass"] = {

    GlassColor =
        RGB(20, 20, 25),

    GlassTransparency =
        0.25,

    BorderColor =
        RGB(100, 100, 115),

    BorderSize =
        2,

    BorderTransparency =
        0.18,

    Accent =
        RGB(140, 140, 255),

    TextColor =
        RGB(255, 255, 255),

    SecondaryText =
        RGB(180, 180, 190),

    InputColor =
        RGB(25, 25, 30)

}

Themes["White"] = {

    GlassColor =
        RGB(245, 245, 248),

    GlassTransparency =
        0,

    BorderColor =
        RGB(180, 180, 185),

    BorderSize =
        2,

    BorderTransparency =
        0,

    Accent =
        RGB(60, 100, 255),

    TextColor =
        RGB(20, 20, 25),

    SecondaryText =
        RGB(90, 90, 100),

    InputColor =
        RGB(230, 230, 235)

}

Themes["Red"] = {

    GlassColor =
        RGB(25, 8, 10),

    GlassTransparency =
        0.20,

    BorderColor =
        RGB(130, 40, 45),

    BorderSize =
        2,

    BorderTransparency =
        0.15,

    Accent =
        RGB(230, 60, 70),

    TextColor =
        RGB(255, 255, 255),

    SecondaryText =
        RGB(200, 165, 170),

    InputColor =
        RGB(35, 12, 15)

}

Themes["Blue"] = {

    GlassColor =
        RGB(7, 15, 30),

    GlassTransparency =
        0.20,

    BorderColor =
        RGB(40, 90, 150),

    BorderSize =
        2,

    BorderTransparency =
        0.15,

    Accent =
        RGB(60, 140, 255),

    TextColor =
        RGB(255, 255, 255),

    SecondaryText =
        RGB(165, 190, 220),

    InputColor =
        RGB(10, 25, 45)

}

Themes["Purple"] = {

    GlassColor =
        RGB(18, 8, 30),

    GlassTransparency =
        0.20,

    BorderColor =
        RGB(100, 60, 150),

    BorderSize =
        2,

    BorderTransparency =
        0.15,

    Accent =
        RGB(170, 90, 255),

    TextColor =
        RGB(255, 255, 255),

    SecondaryText =
        RGB(195, 175, 220),

    InputColor =
        RGB(28, 12, 45)

}

Themes["Green"] = {

    GlassColor =
        RGB(7, 25, 15),

    GlassTransparency =
        0.20,

    BorderColor =
        RGB(45, 130, 80),

    BorderSize =
        2,

    BorderTransparency =
        0.15,

    Accent =
        RGB(70, 220, 120),

    TextColor =
        RGB(255, 255, 255),

    SecondaryText =
        RGB(170, 210, 185),

    InputColor =
        RGB(10, 38, 22)

}

Themes["Yellow"] = {

    GlassColor =
        RGB(28, 25, 7),

    GlassTransparency =
        0.20,

    BorderColor =
        RGB(150, 130, 40),

    BorderSize =
        2,

    BorderTransparency =
        0.15,

    Accent =
        RGB(255, 205, 60),

    TextColor =
        RGB(255, 255, 255),

    SecondaryText =
        RGB(220, 205, 165),

    InputColor =
        RGB(40, 35, 10)

}

--==============================================================
-- COMPATIBILITY ALIASES
--==============================================================

Themes.Black =
    Themes["Black Glass"]

Themes.Dark =
    Themes["Dark Glass"]

Themes.White =
    Themes["White"]

Themes.Red =
    Themes["Red"]

Themes.Blue =
    Themes["Blue"]

Themes.Purple =
    Themes["Purple"]

Themes.Green =
    Themes["Green"]

Themes.Yellow =
    Themes["Yellow"]

--==============================================================
-- ATTACH THEME SYSTEM
--==============================================================

Library.ThemePresets =
    Library.ThemePresets
    or {}

for name, theme in pairs(Themes) do

    if Library.ThemePresets[name] == nil then

        local copy = {}

        for key, value in pairs(theme) do
            copy[key] = value
        end

        Library.ThemePresets[name] =
            copy

    end

end

--==============================================================
-- DEFAULT THEME
--==============================================================

Library.CurrentTheme =
    "Black Glass"

Library.FinalTheme =
    Library.FinalTheme
    or {}

--==============================================================
-- NORMALIZE THEME
--==============================================================

local function NormalizeTheme(
    theme
)

    if type(theme) ~= "table" then
        theme = {}
    end

    local result = {}

    result.GlassColor =
        SafeColor(
            theme.GlassColor,
            RGB(7, 7, 10)
        )

    result.GlassTransparency =
        NormalizeTransparency(
            theme.GlassTransparency,
            0.30
        )

    result.BorderColor =
        SafeColor(
            theme.BorderColor,
            RGB(80, 80, 95)
        )

    result.BorderSize =
        math.floor(
            Clamp(
                theme.BorderSize,
                0,
                10,
                2
            )
        )

    result.BorderTransparency =
        NormalizeTransparency(
            theme.BorderTransparency,
            0.20
        )

    result.Accent =
        SafeColor(
            theme.Accent,
            RGB(120, 120, 255)
        )

    result.TextColor =
        SafeColor(
            theme.TextColor,
            RGB(255, 255, 255)
        )

    result.SecondaryText =
        SafeColor(
            theme.SecondaryText,
            RGB(175, 175, 185)
        )

    result.InputColor =
        SafeColor(
            theme.InputColor,
            RGB(12, 12, 16)
        )

    -- Old API compatibility
    result.AccentColor =
        result.Accent

    result.SecondaryTextColor =
        result.SecondaryText

    return result
end

--==============================================================
-- APPLY PATCHED THEME
--==============================================================

function Library:SetPatchedTheme(
    theme
)

    theme =
        NormalizeTheme(theme)

    for key, value in pairs(theme) do

        self.FinalTheme[key] =
            value

    end

    if type(self.SetFinalTheme)
        == "function"
    then

        pcall(function()

            self:SetFinalTheme(
                self.FinalTheme
            )

        end)

    end

    return self.FinalTheme
end

--==============================================================
-- USE THEME
--==============================================================

function Library:UsePatchedTheme(
    name
)

    name =
        tostring(
            name
            or "Black Glass"
        )

    local theme =
        self.ThemePresets[name]

    if type(theme) ~= "table" then

        theme =
            self.ThemePresets[
                "Black Glass"
            ]

        name =
            "Black Glass"

    end

    self.CurrentTheme =
        name

    return self:SetPatchedTheme(
        theme
    )
end

--==============================================================
-- COMPATIBLE THEME API
--==============================================================

Library.SetTheme =
    Library.SetTheme
    or function(
        self,
        name
    )

        return self:UsePatchedTheme(
            name
        )

    end

Library.GetTheme =
    Library.GetTheme
    or function(
        self,
        name
    )

        name =
            tostring(
                name
                or self.CurrentTheme
                or "Black Glass"
            )

        return self.ThemePresets[name]
    end

--==============================================================
-- PATCH EXISTING SETFINALTHEME
--
-- The old API remains.
-- We only normalize transparency before
-- forwarding to the original function.
--==============================================================

local OriginalSetFinalTheme =
    Library.SetFinalTheme

if type(OriginalSetFinalTheme)
    == "function"
then

    Library.SetFinalTheme =
        function(
            self,
            options
        )

            if type(options)
                ~= "table"
            then

                return OriginalSetFinalTheme(
                    self,
                    options
                )

            end

            local safe = {}

            for key, value in pairs(
                options
            ) do

                safe[key] =
                    value

            end

            if safe.GlassTransparency
                ~= nil
            then

                safe.GlassTransparency =
                    NormalizeTransparency(
                        safe.GlassTransparency,
                        0.30
                    )

            end

            if safe.BorderTransparency
                ~= nil
            then

                safe.BorderTransparency =
                    NormalizeTransparency(
                        safe.BorderTransparency,
                        0.20
                    )

            end

            if safe.BorderSize
                ~= nil
            then

                safe.BorderSize =
                    math.floor(
                        Clamp(
                            safe.BorderSize,
                            0,
                            10,
                            2
                        )
                    )

            end

            if safe.GlassColor
                ~= nil
            then

                safe.GlassColor =
                    SafeColor(
                        safe.GlassColor,
                        RGB(7, 7, 10)
                    )

            end

            if safe.BorderColor
                ~= nil
            then

                safe.BorderColor =
                    SafeColor(
                        safe.BorderColor,
                        RGB(80, 80, 95)
                    )

            end

            if safe.Accent
                ~= nil
            then

                safe.Accent =
                    SafeColor(
                        safe.Accent,
                        RGB(120, 120, 255)
                    )

            end

            if safe.TextColor
                ~= nil
            then

                safe.TextColor =
                    SafeColor(
                        safe.TextColor,
                        RGB(255, 255, 255)
                    )

            end

            if safe.SecondaryText
                ~= nil
            then

                safe.SecondaryText =
                    SafeColor(
                        safe.SecondaryText,
                        RGB(175, 175, 185)
                    )

            end

            if safe.InputColor
                ~= nil
            then

                safe.InputColor =
                    SafeColor(
                        safe.InputColor,
                        RGB(12, 12, 16)
                    )

            end

            return OriginalSetFinalTheme(
                self,
                safe
            )
        end

end

--==============================================================
-- PATCH GETKEY DEFAULT UI VALUES
--==============================================================

Library.GetKey =
    Library.GetKey
    or {}

Library.GetKey.UI =
    Library.GetKey.UI
    or {}

local GetKeyUI =
    Library.GetKey.UI

GetKeyUI.GlassTransparency =
    NormalizeTransparency(
        GetKeyUI.GlassTransparency,
        0.12
    )

GetKeyUI.BorderTransparency =
    NormalizeTransparency(
        GetKeyUI.BorderTransparency,
        0.15
    )

GetKeyUI.BorderSize =
    math.floor(
        Clamp(
            GetKeyUI.BorderSize,
            0,
            10,
            2
        )
    )

--==============================================================
-- PATCH BUILDGETKEYCONFIG
--
-- Keeps original function/API.
-- Only normalizes incoming values.
--==============================================================

local OriginalBuildGetKeyConfig =
    Library.BuildGetKeyConfig

if type(
    OriginalBuildGetKeyConfig
) == "function"
then

    Library.BuildGetKeyConfig =
        function(
            self,
            options
        )

            local config =
                OriginalBuildGetKeyConfig(
                    self,
                    options
                )

            if type(config)
                ~= "table"
            then

                return config

            end

            config.OpenLibraryAfterSuccess =
                config.OpenLibraryAfterSuccess
                == true

            config.UI =
                type(config.UI)
                == "table"
                and config.UI
                or {}

            config.UI.GlassTransparency =
                NormalizeTransparency(
                    config.UI.GlassTransparency,
                    0.12
                )

            config.UI.BorderTransparency =
                NormalizeTransparency(
                    config.UI.BorderTransparency,
                    0.15
                )

            config.UI.BorderSize =
                math.floor(
                    Clamp(
                        config.UI.BorderSize,
                        0,
                        10,
                        2
                    )
                )

            return config
        end

end

--==============================================================
-- PATCH VERIFY KEY SAFETY
--==============================================================

local OriginalVerifyKey =
    Library.VerifyKey

if type(
    OriginalVerifyKey
) == "function"
then

    Library.VerifyKey =
        function(
            self,
            key,
            config
        )

            key =
                tostring(
                    key
                    or ""
                )

            if #key > 500 then

                return false,
                    "key đã hết hoặc sai key"

            end

            if type(config)
                ~= "table"
            then

                config =
                    self.GetKey
            end

            return OriginalVerifyKey(
                self,
                key,
                config
            )
        end

end

--==============================================================
-- PATCH CREATE SCRIPT
--
-- IMPORTANT:
--
-- GetKey false:
--     Main Library / Custom Menu
--
-- GetKey true + OpenLibraryAfterSuccess false:
--     GetKey only
--
-- GetKey true + OpenLibraryAfterSuccess true:
--     GetKey -> next menu
--
-- No automatic GetKey.Enabled check.
--==============================================================

local OriginalCreateScript =
    Library.CreateScript

if type(
    OriginalCreateScript
) == "function"
then

    Library.CreateScript =
        function(
            self,
            config
        )

            if type(config)
                ~= "table"
            then

                config = {}

            end

            local getKey =
                config.GetKey

            if type(getKey)
                == "table"
            then

                getKey.Enabled =
                    getKey.Enabled
                    == true

                getKey.OpenLibraryAfterSuccess =
                    getKey.OpenLibraryAfterSuccess
                    == true

            end

            return OriginalCreateScript(
                self,
                config
            )
        end

end

--==============================================================
-- APPLY DEFAULT BLACK GLASS
--==============================================================

pcall(function()

    Library:UsePatchedTheme(
        "Black Glass"
    )

end)

--==============================================================
-- FINAL COMPATIBILITY INFO
--==============================================================

Library.FinalVersion =
    "V31 PATCHED"

Library.Patched =
    true

Library.PatchedFeatures = {

    Transparency =
        true,

    Themes =
        true,

    GetKeyRouter =
        true,

    Mobile =
        true,

    Touch =
        true,

    Drag =
        true,

    ResizeSafe =
        true

}

--==============================================================
-- EXPORT
--==============================================================

return Library
