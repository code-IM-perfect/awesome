---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gears = require "gears"
local gcolor = gears.color.recolor_image

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local Gio = require("lgi").Gio

local theme = {}

-- cat_subs = require("~/.config/awesome/data/wallpUwUrs/src/cats.lua")
-- windoze = require("~/.config/awesome/data/wallpUwUrs/src/windoze.lua")
-- others = require("~/.config/awesome/data/wallpUwUrs/src/redd.lua")

--- ME
font = "Inter"

-- {{{ Catppuccin Macchiato colors
theme.macchiato = {
    rosewater = "#f4dbd6",
    flamingo = "#f0c6c6",
    pink = "#f5bde6",
    mauve = "#c6a0f6",
    red = "#ed8796",
    maroon = "#ee99a0",
    peach = "#f5a97f",
    yellow = "#eed49f",
    green = "#a6da95",
    teal = "#8bd5ca",
    sky = "#91d7e3",
    sapphire = "#7dc4e4",
    blue = "#8aadf4",
    lavender = "#b7bdf8",

    text = "#cad3f5",
    subtext1 = "#b8c0e0",
    subtext0 = "#a5adcb",

    overlay2 = "#939ab7",
    overlay1 = "#8087a2",
    overlay0 = "#6e738d",
    surface2 = "#5b6078",
    surface1 = "#494d64",
    surface0 = "#363a4f",
    base = "#24273a",
    mantle = "#1e2030",
    crust = "#181926"
}
-- }}}

theme.cat1=".config/awesome/assets/icons/vol/1.svg"
theme.cat2=".config/awesome/assets/icons/vol/2.svg"
theme.cat3=".config/awesome/assets/icons/vol/3.svg"
theme.cat4=".config/awesome/assets/icons/vol/4.svg"
theme.cat5=".config/awesome/assets/icons/vol/5.svg"
theme.cat6=".config/awesome/assets/icons/vol/6.svg"

theme.bt_inactive=".config/awesome/assets/icons/bt/inactive.svg"
theme.bt_active=".config/awesome/assets/icons/bt/active.svg"
theme.bt_updating=".config/awesome/assets/icons/bt/updating.svg"

theme.device_icons = {
    headphones = ".config/awesome/assets/icons/bt/devices/headphones.svg",
    buds = ".config/awesome/assets/icons/bt/devices/buds.svg",
    speaker = ".config/awesome/assets/icons/bt/devices/speaker.svg",
    general = ".config/awesome/assets/icons/bt/devices/general.svg",
}

theme.themeColor = theme.macchiato.blue

theme.font          = font.." 9"

theme.bg_normal     = theme.macchiato.mantle
theme.bg_focus      = theme.macchiato.surface1
theme.bg_urgent     = theme.macchiato.red
theme.bg_minimize   = theme.macchiato.crust
-- theme.bg_systray    = theme.macchiato.mantle

theme.fg_normal     = theme.macchiato.subtext1
theme.fg_focus      = theme.macchiato.text
theme.fg_urgent     = theme.macchiato.text
theme.fg_minimize   = theme.macchiato.subtext0

theme.useless_gap   = dpi(3)
theme.border_width  = dpi(4)
theme.border_normal = theme.macchiato.mantle
theme.border_focus  = theme.themeColor
theme.border_marked = "#91231c"

theme.wibar_bg = theme.macchiato.crust

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]       ------done
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

--Generate taglist squares:
-- local taglist_square_size = dpi(5)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--     taglist_square_size, theme.fg_normal
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, theme.fg_normal
-- )

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"


-- {{{ Icons

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

theme.wallpaper = "/home/harshit/Harshit Work/Funny Stuff/z_wallpaper/Windows crash error [1920x1080].png"

-- You can use your own layout icons like this:
theme.layout_fairh = gcolor(themes_path.."default/layouts/fairhw.png", theme.macchiato.text)
theme.layout_fairv = gcolor(themes_path.."default/layouts/fairvw.png", theme.macchiato.text)
theme.layout_floating  = gcolor(themes_path.."default/layouts/floatingw.png", theme.macchiato.text)
theme.layout_magnifier = gcolor(themes_path.."default/layouts/magnifierw.png", theme.macchiato.text)
theme.layout_max = gcolor(themes_path.."default/layouts/maxw.png", theme.macchiato.text)
theme.layout_fullscreen = gcolor(themes_path.."default/layouts/fullscreenw.png", theme.macchiato.text)
theme.layout_tilebottom = gcolor(themes_path.."default/layouts/tilebottomw.png", theme.macchiato.text)
theme.layout_tileleft   = gcolor(themes_path.."default/layouts/tileleftw.png", theme.macchiato.text)
theme.layout_tile = gcolor(themes_path.."default/layouts/tilew.png", theme.macchiato.text)
theme.layout_tiletop = gcolor(themes_path.."default/layouts/tiletopw.png", theme.macchiato.text)
theme.layout_spiral  = gcolor(themes_path.."default/layouts/spiralw.png", theme.macchiato.text)
theme.layout_dwindle = gcolor(themes_path.."default/layouts/dwindlew.png", theme.macchiato.text)
theme.layout_cornernw = gcolor(themes_path.."default/layouts/cornernww.png", theme.macchiato.text)
theme.layout_cornerne = gcolor(themes_path.."default/layouts/cornernew.png", theme.macchiato.text)
theme.layout_cornersw = gcolor(themes_path.."default/layouts/cornersww.png", theme.macchiato.text)
theme.layout_cornerse = gcolor(themes_path.."default/layouts/cornersew.png", theme.macchiato.text)

-- }}}

-- Generate Awesome icon:
-- theme.awesome_icon = theme_assets.awesome_icon(
--     theme.menu_height, theme.bg_focus, theme.fg_focus
-- )

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
-- theme.icon_theme = "papirus-dark"


-------------- MY CUSTOM SHIT ---------------
-- wibar
theme.wibar_height = 40
-- theme.wibar_widget_hight = 35 ---custom tho
-- theme.wibar_margins = 15

theme.taglist_font = font.." 8"
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
theme.taglist_bg_focus = theme.themeColor
theme.taglist_bg_urgent = theme.macchiato.red
theme.taglist_bg_occupied = theme.macchiato.surface2
theme.taglist_bg_empty = theme.macchiato.surface0

theme.taglist_fg_focus = theme.macchiato.crust
theme.taglist_fg_urgent = theme.macchiato.crust
theme.taglist_fg_occupied = theme.macchiato.subtext1
theme.taglist_fg_empty = theme.macchiato.subtext0

-- theme.taglist_spacing = dpi(5)
-- theme.taglist_shape =
theme.taglist_shape_border_width = 0
theme.taglist_shape_border_width_focus = 2
-- theme.taglist_shape_border_width_empty = 0
-- theme.taglist_shape_border_color = theme.macchiato.surface1
theme.taglist_shape_border_color_focus = theme.macchiato.surface1


theme.systray_icon_spacing = 2

-- tasklist
-- theme.tasklist_bg_normal = theme.macchiato.
-- theme.tasklist_fg_normal = theme.macchiato.
theme.tasklist_bg_focus = theme.themeColor
theme.tasklist_fg_focus = theme.macchiato.base
-- theme.tasklist_bg_minimize = theme.macchiato.
-- theme.tasklist_fg_minimize = theme.macchiato.

theme.tasklist_shape=gears.shape.rounded_rect
theme.tasklist_shape_border_width = 3
-- theme.tasklist_shape_border_width_focus = 2
theme.tasklist_shape_border_width_focus = 2
theme.tasklist_shape_border_color = theme.themeColor
theme.tasklist_shape_border_color_minimized = theme.macchiato.surface1
theme.tasklist_shape_border_color_focus = "#00000000"
theme.tasklist_shape_border_color_urgent = theme.macchiato.red


-- Notification
theme.notification_bg = theme.macchiato.surface0
theme.notification_fg = theme.themeColor
theme.notification_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height)
end
theme.notification_margin=20


-- function getFiles_in(path, exts)
--     local files, valid_exts = {}, {}

--     -- Transforms { "jpg", ... } into { [jpg] = #, ... }
--     if exts then for i, j in ipairs(exts) do valid_exts[j:lower():gsub("^[.]", "")] = i end end

--     -- Build a table of files from the path with the required extensions
--     local file_list = Gio.File.new_for_path(path):enumerate_children("standard::*", 0)

--     -- This will happen when the directory doesn't exist.
--     if not file_list then return nil end

--     for file in function() return file_list:next_file() end do
--         if file:get_file_type() == "REGULAR" then
--             local file_name = file:get_display_name()

--             if not exts or valid_exts[file_name:lower():match(".+%.(.*)$") or ""] then
--                table.insert(files, file_name)
--             end
--         end
--     end

--     if #files == 0 then return nil end

--     -- Return a randomly selected filename from the file table
--     local file = files[math.random(#files)]

--     return (path:gsub("[/]*$", "") .. "/" .. file)
-- end

Gio.Async.call()

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
