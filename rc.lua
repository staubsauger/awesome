-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("vicious")
-- Load Debian menu entries
require("debian.menu")


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
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/rudi/.config/awesome/themes/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.floating,
--    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
--    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "-|1|-", "-|2|-", "-|3|-", "-|4|-" }, s, layouts[1])
end
-- }}}




-- {{{ Menu

-- new menu
vmmenu = {
  { "vmware", "vmware" },
	{ "virtualbox", "virtualbox"},
	 }

-- Create a laucher widget and a main menu /// Menu 1
myawesomemenu = {
   { "geany ", "geany" },
   { "files", "pcmanfm" },
   { "tex", "texmaker" },
   { "calculator", "xcalc"},
   { "office","libreoffice" },
   { "vmaschines", vmmenu },
   { "others", debian.menu.Debian_menu.Debian },
}

mymainmenu = awful.menu({ items = 	{ 	{ "open browser", "chromium" },
										{ "open mail", "icedove" },
										{ "mainmenu", myawesomemenu },

									}
						})

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- Create a laucher widget and a main menu // Menu 2
myawesomemenu2 = 	{
					}

mymainmenu2 = awful.menu({ items = 	{
										{ "Hibernate", "sudo pm-suspend" },
										{ "", "" },
										{ "reboot", "gksu reboot" },
									}
                        })

mylauncher2 = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu2 = mymainmenu2 })
-- }}}

-- {{{ Wibox TOP

-- Widget spacer
spacer = widget({ type = "textbox" })
spacer.text = '<span color= "red"> | | </span>'

-- Widget spacer1
spacer1 = widget({ type = "textbox" })
spacer1.text = '<span color= "green"> | </span>'

-- Edges 
edger = widget ({ type = "textbox" })
edger.text = "                                                          --=--"
edgel = widget ({ type = "textbox" })
edgel.text = "--=-- "   

-- Edges end mid
endwid1 = widget ({ type = "textbox" })
endwid1.text  = '<span color = "red">=-</span>'
endwid2 = widget ({ type = "textbox" })
endwid2.text  = '<span color = "red">-=</span>'

-- Volume widget
-- Initialize widget
   volwidget = awful.widget.progressbar({})
   --volwidget = widget({type = "textbox"})
   -- Progressbar properties
   volwidget:set_width(30)
   volwidget:set_height(22)
   volwidget:set_vertical(false)
   volwidget:set_background_color("#232323")
   volwidget:set_border_color(nil)
   --volwidget:set_border_width(10)
   volwidget:set_color("#606060")
   volwidget:set_gradient_colors({ "#606060", "green" })
   --Register widget
   vicious.register(volwidget, vicious.widgets.volume,
           function(widget, args)
               if args[2] == "♩" then
                   volwidget:set_border_color("#990000")
                   --volwidget:set_gradient_color({"#606061", "red"})
                   --desc1.text:set_text "Mute"
               else
                   volwidget:set_border_color(nil)
                   --volwidget:set_gradient_color(nil)
                   --desc1.text:set_text "Vol."
               end
               return args[1]
           end
           , 0.2, "Master")
   ----Mouse bindings
   --volwidget.widget:buttons(awful.util.table.join(
   --    awful.button({ }, 4, function () awful.util.spawn_with_shell("amixer -c 0 set Master 1+ unmute") end),
   --    awful.button({ }, 5, function () awful.util.spawn_with_shell("amixer -c 0 set Master 1-") end)
   --Mouse bindings
   volwidget.widget:buttons(awful.util.table.join(
       awful.button({ }, 4, function () awful.util.spawn_with_shell("amixer set Master 9%+") end),
       awful.button({ }, 5, function () awful.util.spawn_with_shell("amixer set Master 9%-") end),
       awful.button({ }, 1, function () awful.util.spawn_with_shell("amixer sset Master toggle") end)
   ))
   --description
	desc1 = widget({ type = "textbox" })
	desc1.text = "Vol."

---- Sound
--    awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer set Master 9%+") end),
--    awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer set Master 9%-") end),
--    awful.key({ }, "XF86AudioMute", function () awful.util.spawn("amixer sset Master toggle") end),

-- Bat Widget
-- Initialize widget battwidget
battwidget = widget({ type = "textbox" })
vicious.register(battwidget, vicious.widgets.bat,  '<span color= "green">Battery: $1$2% Remaining: $3</span>', 15, 'BAT1')

-- Cpu Widget 
-- Initialize widget
cpuwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(cpuwidget, vicious.widgets.cpu, '<span color="green">CPU: $1%</span>')
cpuwidget:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn_with_shell('gnome-terminal -e top') end)
 ))
-- Memory Widget
-- Initialize widget
memwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(memwidget, vicious.widgets.mem, '<span color="green">RAM: $1% $2MB/4GB</span>', 13)
memwidget:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn_with_shell('gnome-terminal -e top') end)
 ))
-- Wifi
wifiicon = widget({ type = "textbox" })
wifiicon.text = "Wifi"
-- Initialize widget
wifiwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(wifiwidget, vicious.widgets.wifi, "Wifi: ${ssid} Signal: ${link}% ${rate}mbps", 5, "wlan1") 

wifiwidget:buttons(awful.util.table.join(
		      awful.button({}, 1, function() awful.util.spawn("wicd-client -n", true) end) --Left click to open wicd-client, but becarefull to don't open it twice or more
					))

-- Create a textclock widget
-- mytextclock = awful.widget.textclock({ align = "right" })
-- Initialize widget
mytextclock = widget({ type = "textbox" })
-- Register widget
vicious.register(mytextclock, vicious.widgets.date, '<span color="yellow">%b %d, %a, %R </span>', 60)
--vicious.register(mytextclock, vicious.widgets.date, "%b %d, %R", 60)

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )


for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons )

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = "16" })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
			edgel,
            --mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        
        edger,
        endwid1,
        mytextclock,
        spacer,
        volwidget.widget,
        desc1,
        --mytextclock,
        spacer,
        battwidget,
        spacer,
        memwidget,
        spacer,
        cpuwidget,
        spacer,
        wifiwidget,
        --mytaglist[s],
        endwid2,
        s == 1 and mysystray or nil,
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Wibox BOTTOM

-- Create a wibox for each screen and add it

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "bottom", screen = s, height = "16" })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mytaglist[s],
            layout = awful.widget.layout.horizontal.leftright
            
        },
        mylayoutbox[s],
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    --awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "d",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "s",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "a", function () mymainmenu:toggle({keygrabber=true, coords={x=0, y=10}}) end),
    awful.key({ modkey,           }, "c", function () mymainmenu2:toggle({keygrabber=true, coords={x=0, y=759}}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "d", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "s", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "d", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "s", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    -- Sound
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer set Master 9%+", false) end),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer set Master 9%-", false) end),
    awful.key({ }, "XF86AudioMute", function () awful.util.spawn("amixer sset Master toggle", false) end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "x",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "y",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "y",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "x",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "y",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "x",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "k",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
    { rule = { class = "chromium" },
      properties = { tag = tags[1][1] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
--awful.util.spawn_with_shell("fdpowermon")
awful.util.spawn_with_shell("python ~/touchpad.py")
--awful.util.spawn_with_shell("wicd-client -t")
awful.util.spawn_with_shell("xscreensaver -no-splash")
