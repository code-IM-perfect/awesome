-- {{{ Importing and stuff

-- Standard awesome libraries
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- -- cairo
-- local cairo = require("lgi").cairo

local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- local xresources = require("beautiful.xresources")
-- local dpi = xresources.apply_dpi

math.randomseed(os.clock()*os.time()*math.random(247598))
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
					 title = "Oops, there were errors during startup!",
					 text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
						 title = "Oops, an error happened!",
						 text = tostring(err) })
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions

	-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
	beautiful.init("~/.config/awesome/theme/theme.lua")


	-- This is used later as the default terminal and editor to run.
	terminal = "konsole"
	editor = os.getenv("EDITOR") or "nano"
	editor_cmd = terminal .. " -e " .. editor


	-- Default modkey.
	modkey = "Mod4"


	-- Table of layouts to cover with awful.layout.inc, order matters.
	awful.layout.layouts = {
		awful.layout.suit.tile,
		awful.layout.suit.floating,
		-- awful.layout.suit.tile.left,
		-- awful.layout.suit.tile.bottom,
		-- awful.layout.suit.tile.top,
		-- awful.layout.suit.fair,
		-- awful.layout.suit.fair.horizontal,
		-- awful.layout.suit.spiral,
		-- awful.layout.suit.spiral.dwindle,
		-- awful.layout.suit.max,
		-- awful.layout.suit.max.fullscreen,
		-- awful.layout.suit.magnifier,
		-- awful.layout.suit.corner.nw,
		-- awful.layout.suit.corner.ne,
		-- awful.layout.suit.corner.sw,
		-- awful.layout.suit.corner.se,
	}

connected_devices = {}
prev_bt_output = nil

cat_walls=require("data.wallpUwUrs.cats")
art_walls=require("data.wallpUwUrs.art")
win_walls=require("data.wallpUwUrs.win")
all_walls=gears.table.join(cat_walls,art_walls,win_walls)

-- }}}

-- {{{ Custom functions and stuff

get_random_from=function (table)
	return(table[math.random(#table)])
end

current_wallp = function ()
	awful.spawn.easy_async_with_shell("tail -n2 ~/.config/awesome/data/wallpUwUrs/current.txt | head -c1",
	function (stdout, _, _, _)
		return stdout
	end)
end

set_wallpaper_from=function (konsa)
	local this='/home/harshit/Harshit Work/Funny Stuff/z_wallpaper/Windows crash error [1920x1080].png'
	naughty.notify({text=konsa})
	if konsa=="current" then
		awful.spawn.easy_async_with_shell("tail -n1 ~/.config/awesome/data/wallpUwUrs/current.txt",
		function (stdout, _, _, _)
			this=stdout:gsub("\n","")
			gears.wallpaper.fit(this)
		end)
		elseif konsa=="last" then
			awful.spawn.easy_async_with_shell("head -n -1 ~/.config/awesome/data/wallpUwUrs/current.txt",
				function (stdout, _, _, _)
					local log_current = io.open("/home/harshit/.config/awesome/data/wallpUwUrs/current.txt","w")
					log_current:write(stdout)
					log_current:close()
					awful.spawn.easy_async_with_shell("tail -n1 ~/.config/awesome/data/wallpUwUrs/current.txt",
						function (yo, _, _, _)
							this=yo:gsub("\n","")
							gears.wallpaper.fit(this)
						end)
				end)
		else
			if konsa=="cat" then
				this=get_random_from(cat_walls)
			elseif konsa=="all" then
				this=get_random_from(all_walls)
			elseif konsa=="win" then
				this=get_random_from(win_walls)
			elseif konsa=="art" then
				this=get_random_from(art_walls)
			end
			local log_current = io.open("/home/harshit/.config/awesome/data/wallpUwUrs/current.txt","a")
			log_current:write('\n',this)
			log_current:close()
			gears.wallpaper.fit(this)
	end
	
end


buildWallDatabase=function (foldersTable,saveFile)
	naughty.notify({text="Saving shit to "..saveFile})
	local folders2search = ""
	for _,folderr in ipairs(foldersTable) do
		folders2search=folders2search.." "..folderr
	end

	awful.spawn.easy_async_with_shell("find "..folders2search.." -type f -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' | awk '{print \"\\\"\"$0\"\\\",\"}' | shuf | shuf", function (stuffies,_,_,_)
		local save__file = io.open ("/home/harshit/.config/awesome/data/wallpUwUrs/"..saveFile, "w")
		save__file:write(
			"return {","\n",
			stuffies,
			"}")
		save__file:close()
	end)
	naughty.notify({text="built wallaper database-  "..saveFile})

	------- For when cario starts supporting webp
	-- awful.spawn.easy_async_with_shell("find "..folders2search.." -type f -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' -o -name '*.webp' | awk '{print \"\\\"\"$0\"\\\",\"}' | shuf | shuf", function (stuffies,_,_,_)
	-- 	local save__file = io.open ("/home/harshit/.config/awesome/data/wallpUwUrs/"..saveFile, "w")
	-- 	save__file:write(
	-- 		"return {","\n",
	-- 		stuffies,
	-- 		"}")
	-- 	save__file:close()
	-- end)
end

-- {{  trying with shell
	-- buildWallDatabase=function (foldersTable,saveFile)
-- 	for _,folderr in ipairs(foldersTable) do
-- 		awful.spawn.with_shell("find "..folderr.." -type f -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' -o -name '*.webp' | awk '{print \"\\\"\"$0\"\\\",\"} | shuf > '~/.config/awesome/data/wallpUwUrs/"..saveFile.."_temp'")
-- 	end
-- 	awful.spawn.with_shell("echo 'return {' > '~/.config/awesome/data/wallpUwUrs/"..saveFile.."'".." ; ".."shuf '~/.config/awesome/data/wallpUwUrs/"..saveFile.."_temp' | shuf >> '~/.config/awesome/data/wallpUwUrs/"..saveFile.."'".." ; ".."echo '}' >> '~/.config/awesome/data/wallpUwUrs/"..saveFile.."'")
-- end

	-- local temp_db_file =  "~/.config/awesome/data/wallpUwUrs/"..saveFile.."_temp.txt"
	-- awful.spawn.with_shell("echo '' > "..temp_db_file)
	-- for _, folderr in ipairs(foldersTable) do
	-- 	awful.spawn.with_shell("echo '\"ha\",' >> "..temp_db_file)
	-- end
	-- awful.spawn.with_shell("sleep 10;echo 'return {' > ~/.config/awesome/data/wallpUwUrs/"..saveFile.." ; ".."shuf "..temp_db_file.." >> "..saveFile.." ; ".."echo '}' >> ~/.config/awesome/data/wallpUwUrs/"..saveFile)
-- }}



gotoTag = function (t)
	awful.tag.viewonly(awful.screen.focused().tags[t])
end

updateVolume = function ()
	awful.spawn.easy_async("wpctl get-volume @DEFAULT_AUDIO_SINK@",
		function(stdout, _, _, _)
			vol_float = string.sub(stdout, 9, 12)
			vol = math.floor(vol_float*100)
			if string.find(stdout, "MUTED")
				then
					mute_hai=true
					volbox:set_markup_silently('<span strikethrough="true" strikethrough_color="'..(beautiful.macchiato.red)..'">'..vol..'%'..'</span>'..' ')
				else
					mute_hai=false
					volbox:set_markup_silently(' '..vol..'%'..' ')
			end
			if (mute_hai==false) then
				if (vol==0) then
					cat=beautiful.cat1
					elseif (vol>0) and (vol<20) then
						cat=beautiful.cat2
					elseif (vol>20) and (vol<=45) then
						cat=beautiful.cat3
					elseif (vol>45) and (vol<=70) then
						cat=beautiful.cat4
					elseif (vol>70) and (vol<=100) then
						cat=beautiful.cat5
					elseif (vol>100) then
						cat=beautiful.cat6
				end
				else
					cat=beautiful.cat1
			end
			vol_cat:set_image(gears.surface.load_uncached(cat))
	end)
end

change_vol= function (c)
	-- awful.spawn_with_shell("wpctl set-volume @DEFAULT_AUDIO_SINK@ "..c)
	-- updateVolume()
	awful.spawn.easy_async_with_shell ("wpctl set-volume @DEFAULT_AUDIO_SINK@ "..c, function ()
		updateVolume()
	end)
end
toggle_mute	= function ()
	awful.spawn.easy_async_with_shell ("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", function () updateVolume() end)
end


update_bt = function ()
	awful.spawn.easy_async_with_shell("bluetoothctl devices Connected",
		function(stdout, _, _, _)
			if stdout == prev_bt_output then
			else
				bluetoothTray:reset()
				yo = gears.string.split(stdout,"\n")
				table.remove(yo)	-- Remove empty string at the end
				connected_devices = {}
				for _,device_info in pairs(yo) do
					local device = {name = string.sub(device_info,26), address = string.sub(device_info,8,24)}
					-- naughty.notify{
					-- 	text=device.name.." ("..device.address..")"
					-- }
					local img = beautiful.device_icons.general
					if string.find(device.name,"bud") or string.find(device.name,"Bud") then
							img = beautiful.device_icons.buds
						elseif string.find(device.name,"pod") or string.find(device.name,"Pod") then
							img = beautiful.device_icons.buds
						elseif string.find(device.name,"rockerz") or string.find(device.name,"Rockerz") then
							img = beautiful.device_icons.headphones
						elseif string.find(device.name,"JBL GO") then
							img = beautiful.device_icons.speaker
					end
					-- bluetoothTray:add(bluetoothTrayIcon(img))
					bluetoothTray:add(bluetoothTrayIcon(img,4))
					table.insert(connected_devices, device)
				end
				if (#connected_devices > 0)
					then
						bluetoothIcon.image = gears.surface.load_uncached(beautiful.bt_active)
						bt_tray_separator.visible=true
					else
						bluetoothIcon.image = gears.surface.load_uncached(beautiful.bt_inactive)
						bt_tray_separator.visible=false
				end
			end
			prev_bt_output = stdout
		end)
end

activate_bluetooth = function ()
	bt_activate:again()
	naughty.notify{text="Looking for Bluetooth changes now"}
	bluetoothIcon.image=gears.surface.load_uncached(beautiful.bt_searching)
end

-- }}}


-- {{{ Wibar

-- Create a textclock widget
mytextclock = wibox.widget.textclock('     %a, %d %b %Y  %l:%M %p     ')

volbox = wibox.widget.textbox()

vol_cat = wibox.widget.imagebox(gears.surface.load_uncached(beautiful.cat1))

separator = function (w, button)
	var_not_used_anywhere_else = {
		forced_width = w,
		widget=wibox.container.background,
		buttons = button,
	}
	return var_not_used_anywhere_else
end

wibarWidget = function (widget, borders, bg_huh, button)
		vidget = {
			widget,
			shape = gears.shape.rounded_rect,
			widget = wibox.container.background,
			buttons=button,
		}
		if not(bg_huh==false) then
			vidget.bg=beautiful.wibar_bg
		end
		if not(borders==false) then
			vidget.shape_border_width=2
			vidget.shape_border_color=beautiful.themeColor
		end
	return vidget
end

bluetoothIcon = wibox.widget {
	image=gears.surface.load_uncached(beautiful.bt_inactive),
	widget=wibox.widget.imagebox,
	margin=8,
	buttons=awful.button({},1,function ()	activate_bluetooth()	end)
}

bt_tray_separator = wibox.widget.textbox(" | ")

bt_tray_separator.visible=false

bluetoothTray = wibox.layout.fixed.horizontal()
-- bluetoothTray = wibox.layout.fixed.horizontal(wibox.widget.imagebox(beautiful.bt_active),wibox.widget.imagebox(beautiful.bt_active),wibox.widget.imagebox(beautiful.bt_inactive))

bluetoothTrayIcon = function (icon_input,marg)
	local widg = wibox.container.margin (wibox.widget.imagebox(gears.surface.load_uncached(icon_input)),marg,marg,marg,marg)
	return widg
end


-- {{ Mouse control stuff

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({ }, 1, function(t) t:view_only() end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			  client.focus:move_to_tag(t)
		end
	end),

	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),

	awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
	awful.button({ }, 1, function (c)
			if c == client.focus then
				c.minimized = true
			else
			  c:emit_signal(
				  "request::activate",
				  "tasklist",
				  {raise = true}
			  )
		  end
	  end),
	awful.button({ }, 3, function()
		  awful.menu.client_list({ theme = { width = 250 } })
	  end),
	awful.button({ }, 4, function ()
		  awful.client.focus.byidx(1)
	  end),
	awful.button({ }, 5, function ()
		  awful.client.focus.byidx(-1)
	  end))

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		-- gears.wallpaper.maximized(wallpaper, s, true)
		gears.wallpaper.fit(wallpaper, s)
	end
end

-- }}

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag({ "  1  ", "  2  ", "  3  ", "  4  ", "  5  ", "  6  ", "  7  ", "  8  ", "  9  " }, s, awful.layout.layouts[1])


	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()


	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
						   awful.button({ }, 1, function () awful.layout.inc( 1) end),
						   awful.button({ }, 3, function () awful.layout.inc(-1) end),
						   awful.button({ }, 4, function () awful.layout.inc( 1) end),
						   awful.button({ }, 5, function () awful.layout.inc(-1) end)))

	-- {{ Create a taglist widget
	s.mytaglist = awful.widget.taglist {
		screen  = s,
		filter  = awful.widget.taglist.filter.all,
		style   = {
			shape = function (cr, height, width)
				gears.shape.circle(cr, height, width, 9)
			end,
			shape_focus = function (cr, height, width)
				gears.shape.circle(cr, height, width, 10)
			end
		},
		buttons = taglist_buttons,
	}
	-- }}



	-- {{ Create a tasklist widget
	s.mytasklist = awful.widget.tasklist {
		screen  = s,
		filter  = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		layout   = {
			spacing = 4,
			layout  = wibox.layout.flex.horizontal
		},
		-- Notice that there is *NO* wibox.wibox prefix, it is a template,
		-- not a widget instance.
		widget_template = {
			{
				{
					{
						-- {
						-- 	{
						-- 		{
						-- 	id     = "icon_role",
						-- 	widget = wibox.widget.imagebox,
						-- 		},
						-- 		widget=wibox.container.margin,
						-- 		margins=6
						-- 	},
						-- 	widget=wibox.container.background,
						-- 	shape=gears.shape.rounded_rect,
						-- 	bg=beautiful.tasklist_fg_focus.."5e"
						-- },
						{
							id     = "icon_role",
							widget = wibox.widget.imagebox,
						},
						margins = 8,
						right=10,
						widget  = wibox.container.margin,
					},
					{
						id     = "text_role",
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				widget = wibox.container.place,
			},
			id     = "background_role",
			widget = wibox.container.background,
			forced_height=beautiful.wibar_height,
		},
	}
	-- }}

	-- Create the wibox
	s.mywibox = awful.wibar {
		position = "top",
		screen = s,
		type = "dock",
		-- margins = {top = 10, left = 20, right = 20},
		bg = "#00000000"
	}


-------------------- MAIN WIBAR DECLARATION ------------------------
	-- Add widgets to the wibox
	s.mywibox:setup {
		layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				-- mylauncher,
				separator(5,awful.button({}, 1, function () gotoTag(1) end)),
				wibarWidget({
					separator(7,awful.button({}, 1, function () gotoTag(1) end)),
					s.mytaglist,
					separator(7,awful.button({}, 1, function () gotoTag(9) end)),
					layout = wibox.layout.fixed.horizontal
				}),
				s.mypromptbox,
				separator(10),
				layout = wibox.layout.fixed.horizontal,
			},
			wibarWidget({	s.mytasklist,
				content_fill_horizontal=true,
				widget = wibox.container.place,
			},false, false),
			{ -- Right widgets
				separator(5),
				wibarWidget({
					wibox.widget.systray(),
					margins = 5,
					widget = wibox.container.margin,
				}),
				wibarWidget({
					{
						{
							bluetoothIcon,
							margins=bluetoothIcon.margin,
							widget=wibox.container.margin,
						},
					widget=wibox.container.place,
					forced_width=beautiful.wibar_widget_hight,
					},
					bt_tray_separator,
					bluetoothTray,
					layout=wibox.layout.fixed.horizontal,
				}),

				wibarWidget({	-- Vol Cat
					separator(4),
					{	vol_cat,
						margins=7,
						widget=wibox.container.margin,
					},
					volbox,
					separator(4),
					layout=wibox.layout.fixed.horizontal,
				},true,true,
				gears.table.join(
					awful.button({ }, 1, function () toggle_mute() end),
					awful.button({ }, 4, function () change_vol("2%+") end),
					awful.button({ }, 5, function () change_vol("2%-") end))
				),

				wibarWidget(mytextclock),

				-- {
				-- 	wibox.widget.textbox("some text"),
				-- 	shape_border_width=10,
				-- 	shape = gears.shape.rounded_rect,
				-- 	widget = wibox.container.background,
				-- 	shape_border_color=beautiful.themeColor,
				-- },

				wibarWidget({	s.mylayoutbox,
					margins = 5,
					widget = wibox.container.margin,
				}),

				separator(0),
				spacing = 5,
				layout = wibox.layout.fixed.horizontal,
			},
		}

		-- awful.placement.top(s.mywibox,
		-- {
		-- 	margins = {
		-- 		top = dpi(8),
		-- 		bottom = dpi(8),
		-- 		left = dpi(5)
		-- 	}
		-- })
end)

-- {{ -------------------- Floating WIBAR DECLARATION ------------------------

-- wibarWidget = function (widget, square, fill_horizontal, bg_huh, button)
-- 	local fill = false
-- 	local sq = nil
-- 	local bghuh = beautiful.wibar_bg
-- 	if fill_horizontal==true then
-- 		fill = true
-- 	end
-- 	if bg_huh==false then
-- 		bghuh = nil
-- 	end
-- 	if square==true then
-- 		sq = beautiful.wibar_widget_hight
-- 	end
-- 		vidget = {
-- 			{
-- 				widget,
-- 				forced_height = beautiful.wibar_widget_hight,
-- 				forced_width = sq,
-- 				shape = gears.shape.rounded_rect,
-- 				bg = bghuh,
-- 				widget = wibox.container.background,
-- 			},
-- 			content_fill_horizontal = fill,
-- 			widget=wibox.container.place,
-- 			buttons=button,
-- 			valign='bottom',
-- 		}
-- 	return vidget
-- end

-- 	-- Add widgets to the wibox
-- 	s.mywibox:setup {
-- 		layout = wibox.layout.align.horizontal,
-- 			{ -- Left widgets
-- 				-- mylauncher,
-- 				separator(5,awful.button({}, 1, function () gotoTag(1) end)),
-- 				wibarWidget({
-- 					separator(7,awful.button({}, 1, function () gotoTag(1) end)),
-- 					s.mytaglist,
-- 					separator(7,awful.button({}, 1, function () gotoTag(9) end)),
-- 					layout = wibox.layout.fixed.horizontal
-- 				}),
-- 				s.mypromptbox,
-- 				separator(10),
-- 				layout = wibox.layout.fixed.horizontal,
-- 			},
-- 			wibarWidget({	s.mytasklist,
-- 				content_fill_horizontal=true,
-- 				widget = wibox.container.place,
-- 			},false, true, false),
-- 			{ -- Right widgets
-- 				separator(5),
-- 				wibarWidget({
-- 					wibox.widget.systray(),
-- 					margins = 5,
-- 					widget = wibox.container.margin,
-- 				}),
-- 				wibarWidget({
-- 					{
-- 						{
-- 							bluetoothIcon,
-- 							margins=bluetoothIcon.margin,
-- 							widget=wibox.container.margin,
-- 						},
-- 					widget=wibox.container.place,
-- 					forced_width=beautiful.wibar_widget_hight,
-- 					},
-- 					bt_tray_separator,
-- 					bluetoothTray,
-- 					layout=wibox.layout.fixed.horizontal,
-- 				}),

-- 				wibarWidget({	-- Vol Cat
-- 					separator(4),
-- 					{	vol_cat,
-- 						margins=5,
-- 						widget=wibox.container.margin,
-- 					},
-- 					volbox,
-- 					separator(4),
-- 					layout=wibox.layout.fixed.horizontal,
-- 				},false,false,true,
-- 				gears.table.join(
-- 					awful.button({ }, 1, function () toggle_mute() end),
-- 					awful.button({ }, 4, function () change_vol("2%+") end),
-- 					awful.button({ }, 5, function () change_vol("2%-") end))
-- 				),

-- 				wibarWidget(mytextclock),

-- 				wibarWidget({	s.mylayoutbox,
-- 					margins = 5,
-- 					widget = wibox.container.margin,
-- 				}, true),

-- 				separator(0),
-- 				spacing = 5,
-- 				layout = wibox.layout.fixed.horizontal,
-- 			},
-- 		}

-- 		-- awful.placement.top(s.mywibox,
-- 		-- {
-- 		-- 	margins = {
-- 		-- 		top = dpi(8),
-- 		-- 		bottom = dpi(8),
-- 		-- 		left = dpi(5)
-- 		-- 	}
-- 		-- })
-- end)

-- }}

-- }}}



-- {{{ Key bindings


-- {{ Global Keys
globalkeys = gears.table.join(
-- {{ Default Stuff
	awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
			  {description="show help", group="awesome"}),
	awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
			  {description = "view previous", group = "tag"}),
	awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
			  {description = "view next", group = "tag"}),
	awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
			  {description = "go back", group = "tag"}),

	awful.key({ modkey,           }, "j",
		function ()
			awful.client.focus.byidx( 1)
		end,
		{description = "focus next by index", group = "client"}
	),
	awful.key({ modkey,           }, "k",
		function ()
			awful.client.focus.byidx(-1)
		end,
		{description = "focus previous by index", group = "client"}
	),

	-- I COMMENTED THIS OUT
	-- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
	--           {description = "show main menu", group = "awesome"}),

	-- Layout manipulation
	awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
			  {description = "swap with next client by index", group = "client"}),
	awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
			  {description = "swap with previous client by index", group = "client"}),
	awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
			  {description = "focus the next screen", group = "screen"}),
	awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
			  {description = "focus the previous screen", group = "screen"}),
	awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
			  {description = "jump to urgent client", group = "client"}),
	awful.key({ modkey,           }, "Tab",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
		{description = "go back", group = "client"}),

	-- Standard program
	awful.key({ modkey,           },	"Return",	function () awful.spawn(terminal)	end,
			  {description = "open a terminal", group = "launcher"}),
	awful.key({ modkey, "Control" }, "r", awesome.restart,
			  {description = "reload awesome", group = "awesome"}),
	awful.key({ modkey, "Shift"   }, "q", awesome.quit,
			  {description = "quit awesome", group = "awesome"}),

	awful.key({ modkey,           },	"l",	function () awful.tag.incmwfact( 0.01)	end,
			  {description = "increase master width factor", group = "layout"}),
	awful.key({ modkey,           },	"h",	function () awful.tag.incmwfact(-0.01)	end,
			  {description = "decrease master width factor", group = "layout"}),
	awful.key({ modkey, "Shift"   },	"h",	function () awful.tag.incnmaster( 1, nil, true)	end,
			  {description = "increase the number of master clients", group = "layout"}),
	awful.key({ modkey, "Shift"   },	"l",	function () awful.tag.incnmaster(-1, nil, true)	end,
			  {description = "decrease the number of master clients", group = "layout"}),
	awful.key({ modkey, "Control" },	"h",	function () awful.tag.incncol( 1, nil, true)	end,
			  {description = "increase the number of columns", group = "layout"}),
	awful.key({ modkey, "Control" },	"l",	function () awful.tag.incncol(-1, nil, true)	end,
			  {description = "decrease the number of columns", group = "layout"}),
	awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)	end,
			  {description = "select next", group = "layout"}),
	awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)	end,
			  {description = "select previous", group = "layout"}),

	awful.key({ modkey, "Control" }, "n",
			  function ()
				  local c = awful.client.restore()
				  -- Focus restored client
				  if c then
					c:emit_signal(
						"request::activate", "key.unminimize", {raise = true}
					)
				  end
			  end,
			  {description = "restore minimized", group = "client"}),

	------I commented this out to add rofi instead of the awesome run thingy
	-- -- Prompt
	-- awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
	--           {description = "run prompt", group = "launcher"}),

	awful.key({ modkey }, "x",
			  function ()
				  awful.prompt.run {
					prompt       = "Run Lua code: ",
					textbox      = awful.screen.focused().mypromptbox.widget,
					exe_callback = awful.util.eval,
					history_path = awful.util.get_cache_dir() .. "/history_eval"
				  }
			  end,
			  {description = "lua execute prompt", group = "awesome"}),

	-- -- Menubar               ------ commented this out coz I removed Menubar
	-- awful.key({ modkey }, "p", function() menubar.show() end,
	--           {description = "show the menubar", group = "launcher"}),
-- }}

-- {{{ MY CUSTOM SHORTCUTS (okay, most of em)

	-- {{ Shortcuts for Apps
		awful.key({ modkey, "Control" },	"s",	function () awful.spawn("spotify") end,
		{description = "Open Spotify", group = "Applications"}),

		awful.key({ modkey, "Control" },	"f",	function () awful.spawn("firefox") end,
		{description = "Open Firefox", group = "Applications"}),

		awful.key({ modkey, "Shift" },	"f",	function () awful.spawn("firefox-developer-edition") end,
		{description = "Open Firefox Dev Edititon", group = "Applications"}),

		awful.key({ modkey, "Mod1" },	"f",	function () awful.spawn("firefox --private-window") end,
		{description = "Open a Firefox Private Window", group = "Applications"}),

		awful.key({ modkey },	"e",	function () awful.spawn("dolphin") end,
		{description = "Open Dolphin", group = "Applications"}),

		awful.key({ modkey, "Control" },	"c",	function () awful.spawn("kronometer") end,
		{description = "Open Kronometer", group = "Applications"}),

		awful.key({ modkey, "Control" },      "v",     function () awful.spawn("vlc") end,
		{description = "Open VLC", group = "Applications"}),

		awful.key({ modkey, "Control" },      "/",     function () awful.spawn("code") end,
		{description = "Open VsCode", group = "Applications"}),

		awful.key({ modkey, "Control" },      "Escape",     function () awful.spawn(terminal.." -e htop") end,
		{description = "Open htop", group = "Applications"}),

		awful.key({ modkey, "Mod1" },      "KP_Next",     function ()
			awful.spawn.with_shell(terminal.." -e python '/home/harshit/Harshit Work/Funny Stuff/Save Posts.py'")
		end,
		{description = "Save Posts", group = "Applications"}),


	-- }}

	-- {{ Media Control

		awful.key({  },      "KP_Begin",     function () awful.spawn("playerctl play-pause", false) end,
		{description = "Play/Pause", group = "Media"}),

		awful.key({  },      "XF86AudioPlay",     function () awful.spawn("playerctl play-pause", false) end),

		awful.key({  },      "XF86AudioPause",     function () awful.spawn("playerctl play-pause", false) end),

		awful.key({  },      "XF86AudioNext",     function () awful.spawn("playerctl next", false) end),

		awful.key({  },      "XF86AudioPrev",     function () awful.spawn("playerctl previous", false) end,
		{}),

		awful.key({ "Control" },      "KP_Right",     function () awful.spawn("playerctl next", false) end,
		{description = "Next", group = "Media"}),

		awful.key({ "Control" },      "KP_Left",     function () awful.spawn("playerctl previous", false) end,
		{description = "Previous", group = "Media"}),


		awful.key({ "Control" },      "KP_Begin",     function ()
			toggle_mute()
		end,
		{description = "Toggle Mute", group = "Media"}),

		awful.key({  },      "KP_Up",     function ()
			change_vol("1%+")
			updateVolume()
		end,  -- Num+up
		{description = "Increase Volume(1%)", group = "Media"}),

		awful.key({ "Control" },      "KP_Up",     function ()
			change_vol("5%+")
		end,  -- Num+up
		{description = "Increase Volume(5%)", group = "Media"}),

		awful.key({  },      "KP_Down",     function ()
			change_vol("1%-")
		end,  -- Num+down
		{description = "Decrease Volume(1%)", group = "Media"}),

		awful.key({ "Control" },      "KP_Down",     function ()
			change_vol("5%-")
		end,
		{description = "Decrease Volume(5%)", group = "Media"}),
	-- }}

	-- {{ Background
	awful.key({ modkey, "Control" },      "KP_Begin",
		function ()		-- Numpad 5
			-- awful.spawn("nitrogen --set-zoom --random --save", false)
			set_wallpaper_from("all")
		end,   {description = "New Background from all", group = "Wallpaper"}),

		awful.key({ modkey, "Control" },      "KP_Insert",	-- Numpad 0
			function ()
				-- awful.spawn("nitrogen --restore", false)
				set_wallpaper_from("current")
			end,
		{description = "Restoring Last Wallpaper", group = "Wallpaper"}),

		awful.key({ modkey, "Control" },      "KP_Down",	-- Numpad 2
			function ()
				-- awful.spawn("nitrogen --restore", false)
				set_wallpaper_from("last")
			end,
		{description = "Going to the Wallpaper Before Current", group = "Wallpaper"}),

	awful.key({ modkey, "Control" },      "KP_Home",
		function ()
			-- awful.spawn("nitrogen 'Harshit Work/Windows Spotlight' --set-auto --random --save", false)
			set_wallpaper_from("win")
		end,
		{description = "New Spotlight Background", group = "Wallpaper"}),

	awful.key({ modkey, "Control" },      "KP_Prior",
		function ()
			-- awful.spawn("nitrogen 'Harshit Work/Funny Stuff/z_wallpaper' --set-auto --random --save", false)
			set_wallpaper_from("art")
		end,
		{description = "New Art Background", group = "Wallpaper"}),

	awful.key({ modkey, "Control" },      "KP_Up",
		function ()
			set_wallpaper_from("cat")
		end,
		{description = "New Cat Background", group = "Wallpaper"}),


	awful.key({ modkey, "Control","Mod1" },      "KP_Prior",     function ()
			buildWallDatabase(require("data.wallpUwUrs.src.cats"),"cats.lua")
			buildWallDatabase(require("data.wallpUwUrs.src.redd"),"art.lua")
			buildWallDatabase(require("data.wallpUwUrs.src.windoze"),"win.lua")
		end,
		{description = "Build Wallpaper Database", group = "Wallpaper"}),
	
	
	-- }}

	-- To run rofi app menu
	awful.key({ modkey, "Mod1" },        "space",     function () awful.spawn("rofi -show drun") end,
	{description = "Rofi Runner", group = "launcher"}),

	awful.key({ modkey, "Mod1" },        "KP_Multiply",     function ()
		activate_bluetooth()
	end,
	{description = "Rofi Runner", group = "launcher"}),



	-- Test values
	awful.key({ modkey, "Mod1" },        "Return",     function ()
		naughty.notify({
			title = "Test",
			text = "yeah that's it"
		})
		-- buildWallDatabase({"~/'Harshit Work/Funny Stuff/z_CatDrawings'","~/'Harshit Work/Funny Stuff/z_androidthemes'"},"yo.lua")
		-- awful.spawn.with_shell("echo 'hey' > ~/.config/awesome/yo.txt")
		-- set_wallpaper_from("last")
	end,
	{description = "test notification", group = "launcher"}),


	awful.key({ modkey, "Mod1"}, "KP_End", function ()
		-- awful.tag.viewidx(3)
		-- awful.tag.viewonly(awful.screen.focused().tags[3])
		
	end)
-- }}}
)
-- }}


-- {{ Client Keys
clientkeys = gears.table.join(
	awful.key({ modkey,           }, "f",
		function (c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{description = "toggle fullscreen", group = "client"}),
	awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
			  {description = "close", group = "client"}),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
			  {description = "toggle floating", group = "client"}),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
			  {description = "move to master", group = "client"}),
	awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
			  {description = "move to screen", group = "client"}),
	awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
			  {description = "toggle keep on top", group = "client"}),
	awful.key({ modkey,           }, "n",
		function (c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end ,
		{description = "minimize", group = "client"}),
	awful.key({ modkey,           }, "m",
		function (c)
			c.maximized = not c.maximized
			c:raise()
		end ,
		{description = "(un)maximize", group = "client"}),
	awful.key({ modkey, "Control" }, "m",
		function (c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end ,
		{description = "(un)maximize vertically", group = "client"}),
	awful.key({ modkey, "Shift"   }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end ,
		{description = "(un)maximize horizontally", group = "client"}),

	awful.key({ modkey, 'Control', 'Mod1' },	'Prior',	function (c) awful.titlebar.toggle(c) end,	-- PageUp added this to toggle showing titlebar
		{description = 'toggle title bar', group = 'client'})
)
-- }}


-- {{ Bind all key numbers to tags.

-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9,
				  function ()
						local screen = awful.screen.focused()
						local tag = screen.tags[i]
						if tag then
						   tag:view_only()
						end
				  end,
				  {description = "view tag #"..i, group = "tag"}),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9,
				  function ()
					  local screen = awful.screen.focused()
					  local tag = screen.tags[i]
					  if tag then
						 awful.tag.viewtoggle(tag)
					  end
				  end,
				  {description = "toggle tag #" .. i, group = "tag"}),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
				  function ()
					  if client.focus then
						  local tag = client.focus.screen.tags[i]
						  if tag then
							  client.focus:move_to_tag(tag)
						  end
					 end
				  end,
				  {description = "move focused client to tag #"..i, group = "tag"}),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
				  function ()
					  if client.focus then
						  local tag = client.focus.screen.tags[i]
						  if tag then
							  client.focus:toggle_tag(tag)
						  end
					  end
				  end,
				  {description = "toggle focused client on tag #" .. i, group = "tag"})
	)
end
-- }}


-- {{ IDK whatever but Mouse related
clientbuttons = gears.table.join(
	awful.button({ }, 1, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
	end),
	awful.button({ modkey }, 1, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
		awful.mouse.client.resize(c)
	end)
-- }}
)

-- Set keys
root.keys(globalkeys)


-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
	  properties = { border_width = beautiful.border_width,
					 border_color = beautiful.border_normal,
					 focus = awful.client.focus.filter,
					 raise = true,
					 keys = clientkeys,
					 buttons = clientbuttons,
					 screen = awful.screen.preferred,
					 placement = awful.placement.no_overlap+awful.placement.no_offscreen
	 }
	},

	-- Floating clients.
	{ rule_any = {
		instance = {
		  "DTA",  -- Firefox addon DownThemAll.
		  "copyq",  -- Includes session name in class.
		  "pinentry",
		},
		class = {
		  "Arandr",
		  "Blueman-manager",
		  "Gpick",
		  "Kruler",
		  "MessageWin",  -- kalarm.
		  "Sxiv",
		  "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
		  "Wpa_gui",
		  "veromix",
		  "xtightvncviewer",
		  "MEGAsync",
		  "Calculator"
		},

		-- Note that the name property shown in xprop might be set slightly after creation of the client
		-- and the name shown there might not match defined rules here.
		name = {
		  "Event Tester",  -- xev.
		},
		role = {
		  "AlarmWindow",  -- Thunderbird's calendar.
		  "ConfigManager",  -- Thunderbird's about:config.
		  "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
		}
	  }, properties = { floating = true }},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = {type = { "normal", "dialog" }
	  }, properties = { titlebars_enabled = true }
	},

	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup
	  and not c.size_hints.user_position
	  and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end

	awful.titlebar.hide(c)	-- I added this to hide the titlebar
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({ }, 1, function()
			c:emit_signal("request::activate", "titlebar", {raise = true})
			awful.mouse.client.move(c)
		end),
		awful.button({ }, 3, function()
			c:emit_signal("request::activate", "titlebar", {raise = true})
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c) : setup {
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout  = wibox.layout.fixed.horizontal
		},
		{ -- Middle
			{ -- Title
				align  = "center",
				widget = awful.titlebar.widget.titlewidget(c)
			},
			buttons = buttons,
			layout  = wibox.layout.flex.horizontal
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton (c),
			awful.titlebar.widget.stickybutton   (c),
			awful.titlebar.widget.ontopbutton    (c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.closebutton    (c),
			layout = wibox.layout.fixed.horizontal()
		},
		layout = wibox.layout.align.horizontal
	}
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


gears.timer {
    timeout   = 10,
    autostart = true,
    callback  = function()
		updateVolume()
    end
}
gears.timer {
    timeout   = 30,
    autostart = true,
    callback  = function()
		update_bt()
    end
}
bt_act=0
bt_activate = gears.timer {
    timeout   = 2,
	co=0,
	autostart=false,
    callback  = function()
		if bt_act < 30 then
			update_bt()
			bt_act = bt_act + 1
		elseif bt_act==30 then
			prev_bt_output = "a"
			update_bt()
			bt_act = 0
			bt_activate:stop()
		end
    end
}

naughty.config.defaults.margin = beautiful.notification_margin

-- {{{ Mouse bindings for desktop

-- root.buttons(gears.table.join(
	-- 	awful.button({ }, 3, function () mymainmenu:toggle() end)
	-- awful.button({ }, 4, awful.tag.viewnext),	--mouse scroll up
	-- awful.button({ }, 5, awful.tag.viewprev)		--and scroll down used to browse tags (globally so on desktop mainly)
-- ))

-- }}}

awesome.set_preferred_icon_size(32)

updateVolume()

update_bt()

-- realized this isn't needed
-- set_wallpaper_from("current")