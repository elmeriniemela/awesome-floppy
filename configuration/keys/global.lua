local awful = require('awful')
local beautiful = require('beautiful')

require('awful.autofocus')

local hotkeys_popup = require('awful.hotkeys_popup').widget

local modkey = require('configuration.keys.mod').mod_key
local altkey = require('configuration.keys.mod').alt_key
local apps = require('configuration.apps')

local function run_or_raise(cmd, class)
    name = class:lower()
    local matcher = function (c)
        if not c.class then
            return false
        end
        local client_class = c.class:lower()
        if client_class:find(class) then
            return true
        end
        return false
    end
    awful.client.run_or_raise(cmd, matcher)
end

local function run_or_raise_name(cmd, name)
    name = name:lower()
    local matcher = function (c)
        if not c.name then
            return false
        end
        local client_class = c.name:lower()
        if client_class:find(name) then
            return true
        end
        return false
    end
    awful.client.run_or_raise(cmd, matcher)
end

-- Key bindings
local global_keys = awful.util.table.join(
    -- X screen locker
    awful.key({ altkey, "Control" }, "l",
        function ()
            awful.spawn.with_shell(apps.default.lock)
        end,
        { description = "lock screen", group = "hotkeys" }
    ),

    -- -- Hotkeys
    awful.key({ }, "F1",
        function ()
            hotkeys_popup.new{ width = 3000, height = 1500 }:show_help()
        end,
        { description="show help", group="awesome" }
    ),

    -- Tag browsing
    awful.key({ modkey }, "Left",
        awful.tag.viewprev,
        { description = "view previous", group = "tag" }
    ),

    awful.key({ modkey }, "Right",
        awful.tag.viewnext,
        { description = "view next", group = "tag" }
    ),

    awful.key({ modkey }, "Escape",
        awful.tag.history.restore,
        { description = "go back", group = "tag" }
    ),

    awful.key({ }, "Print",
        function()
            awful.spawn.with_shell("flameshot gui")
        end,
        { description = "print screen", group = "hotkeys" }
    ),

    -- Default client focus
    awful.key({ altkey, }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        { description = "focus next by index", group = "client" }
    ),

    awful.key({ altkey, }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus down", group = "client" }
    ),

    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus up", group = "client" }
    ),

    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus left", group = "client" }
    ),

    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus right", group = "client" }
    ),


    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j",
        function ()
            awful.client.swap.byidx(1)
        end,
        { description = "swap with next client by index", group = "client" }
    ),

    awful.key({ modkey, "Shift" }, "k",
        function ()
            awful.client.swap.byidx( -1)
        end,
        { description = "swap with previous client by index", group = "client" }
    ),

    awful.key({ modkey, "Control" }, "j",
        function ()
            awful.screen.focus_relative(1)
        end,
        { description = "focus the next screen", group = "screen" }
    ),

    awful.key({ modkey, "Control" }, "k",
        function ()
            awful.screen.focus_relative(-1)
        end,
        { description = "focus the previous screen", group = "screen" }
    ),

    awful.key({ modkey }, "u",
        awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }
    ),

    awful.key({ modkey }, "Tab",
        function ()
            if cycle_prev then
                awful.client.focus.history.previous()
            else
                awful.client.focus.byidx(-1)
            end
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "cycle with previous/go back", group = "client" }
    ),

    awful.key({ modkey, "Shift" }, "Tab",
        function ()
            if cycle_prev then
                awful.client.focus.byidx(1)
                if client.focus then
                    client.focus:raise()
                end
            end
        end,
        { description = "go forth", group = "client" }
    ),

    -- Standard program
    awful.key({ modkey, "Control" }, "r",
        awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),

    awful.key({ modkey, "Shift" }, "q",
        awesome.quit,
        { description = "quit awesome", group = "awesome" }
    ),

    awful.key({ altkey, "Shift" }, "l",
        function ()
            awful.tag.incmwfact( 0.05)
        end,
        { description = "increase master width factor", group = "layout" }
    ),

    awful.key({ altkey, "Shift" }, "h",
        function ()
            awful.tag.incmwfact(-0.05)
        end,
        { description = "decrease master width factor", group = "layout" }
    ),

    awful.key({ modkey, "Shift" }, "h",
        function ()
            awful.tag.incnmaster(1, nil, true)
        end,
        { description = "increase the number of master clients", group = "layout" }
    ),

    awful.key({ modkey, "Shift" }, "l",
        function ()
            awful.tag.incnmaster(-1, nil, true)
        end,
        { description = "decrease the number of master clients", group = "layout" }
    ),

    awful.key({ modkey, "Control" }, "h",
        function ()
            awful.tag.incncol( 1, nil, true)
        end,
        { description = "increase the number of columns", group = "layout" }
    ),

    awful.key({ modkey, "Control" }, "l",
        function ()
            awful.tag.incncol(-1, nil, true)
        end,
        { description = "decrease the number of columns", group = "layout" }
    ),

    awful.key({ modkey }, "space",
        function ()
            awful.spawn("rofi -show drun")
        end,
        { description = "select next", group = "layout" }
    ),

    awful.key({ modkey, "Shift" }, "space",
        function ()
            awful.layout.inc(-1)
        end,
        { description = "select previous", group = "layout" }
    ),

    awful.key({ modkey, "Control" }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        { description = "restore minimized", group = "client" }
    ),

    -- Brightness
    awful.key({ }, "XF86MonBrightnessUp",
        function ()
            awful.spawn("xbacklight -inc 10")
        end,
        { description = "+10%", group = "hotkeys" }
    ),

    awful.key({ }, "XF86MonBrightnessDown",
        function ()
            awful.spawn("xbacklight -dec 10")
        end,
        { description = "-10%", group = "hotkeys" }
    ),

    awful.key({ }, "XF86PowerOff",
        function()
            awesome.emit_signal('module::exit_screen:show')
        end,
        { description = "show exitscreen", group = "hotkeys" }
    ),

    awful.key({ }, "XF86PowerDown",
        function()
            awesome.emit_signal('module::exit_screen:show')
        end,
        { description = "show exitscreen", group = "hotkeys" }
    ),

    -- ALSA volume control
    awful.key({ }, "XF86AudioRaiseVolume",
        function()
            awful.spawn('amixer -D pulse sset Master 5%+', false)
            awesome.emit_signal('widget::volume')
            awesome.emit_signal('module::volume_osd:show', true)
        end,
        {description = 'increase volume up by 5%', group = 'hotkeys'}
    ),

    awful.key({ }, "XF86AudioLowerVolume",
        function()
            awful.spawn('amixer -D pulse sset Master 5%-', false)
            awesome.emit_signal('widget::volume')
            awesome.emit_signal('module::volume_osd:show', true)
        end,
        {description = 'decrease volume up by 5%', group = 'hotkeys'}
    ),

    awful.key({ "Control" }, "XF86AudioRaiseVolume",
        function()
            awful.spawn('amixer -D pulse sset Capture 5%+', false)
            awesome.emit_signal('widget::mic')
            awesome.emit_signal('module::mic_osd:show', true)
        end,
        {description = 'increase mic up by 5%', group = 'hotkeys'}
    ),

    awful.key({ "Control" }, "XF86AudioLowerVolume",
        function()
            awful.spawn('amixer -D pulse sset Capture 5%-', false)
            awesome.emit_signal('widget::mic')
            awesome.emit_signal('module::mic_osd:show', true)
        end,
        {description = 'decrease mic up by 5%', group = 'hotkeys'}
    ),

    awful.key({ }, "XF86AudioMute",
        function()
            awful.spawn('amixer -D pulse set Master 1+ toggle', false)
        end,
        {description = 'toggle mute', group = 'hotkeys'}
    ),

    awful.key({ }, "XF86AudioMicMute",
        function()
            awful.spawn('amixer set Capture toggle', false)
        end,
        {description = 'mute microphone', group = 'hotkeys'}
    ),

    awful.key({ }, "XF86Tools",
        function ()
            run_or_raise("pavucontrol", "pavucontrol")
        end,
        { description = "configure audio", group = "hotkeys" }
    ),

    awful.key({ }, "XF86ScreenSaver",
        function ()
            run_or_raise("arandr", "arandr")
        end,
        { description = "reconfigure monitors", group = "hotkeys" }
    ),

    awful.key({ }, "XF86Display",
        function ()
            run_or_raise("arandr", "arandr")
        end,
        { description = "reconfigure monitors", group = "hotkeys" }
    ),

    awful.key({ altkey, }, "w",
        function ()
            awful.spawn.easy_async(
                "bootstrap-linux monitor",
                function (stdout, stderr, exitreason, exitcode)
                    awesome.restart()
                end
            )
        end,
        { description = "autoconfigure monitors", group = "hotkeys" }
    ),

    -- User programs
    awful.key({ modkey }, "Return",
        function ()
            run_or_raise(apps.default.terminal, apps.default.terminal)
        end,
        { description = "open existing or new apps.default.terminal", group = "launcher" }
    ),

    awful.key({ modkey, "Shift" }, "Return",
        function ()
            awful.spawn(apps.default.terminal)
        end,
        { description = "open new apps.default.terminal", group = "launcher" }
    ),

    awful.key({ modkey, }, "d",
        function ()
            run_or_raise_name("libreoffice Documents/DEADLINES.ods", "DEADLINES.ods")
        end,
        { description = "open new apps.default.terminal", group = "launcher" }
    ),

    awful.key({ modkey }, "q",
        function ()
            run_or_raise(apps.default.web_browser, apps.default.web_browser)
        end,
        { description = "open apps.default.web_browser", group = "launcher" }
    ),

    awful.key({ modkey }, "e",
        function ()
            run_or_raise(apps.default.file_manager, apps.default.file_manager)
        end,
        { description = "open filemanager", group = "launcher" }
    ),

    awful.key({ modkey }, "t",
        function ()
            run_or_raise("thunderbird", "thunderbird")
        end,
        { description = "open thunderbird", group = "launcher" }
    ),

    awful.key({ modkey }, "w",
        function ()
            run_or_raise("whatsapp-for-linux", "whatsapp")
        end,
        { description = "open whatsapp", group = "launcher" }
    ),

    awful.key({ modkey }, "a",
        function ()
            run_or_raise("signal-desktop", "signal")
        end,
        { description = "open signal", group = "launcher" }
    ),

    awful.key({ modkey }, "s",
        function ()
            run_or_raise("slack", "slack")
        end,
        { description = "open slack", group = "launcher" }
    ),

    awful.key({ modkey }, "z",
        function ()
            run_or_raise("zoom", "zoom")
        end,
        { description = "open zoom", group = "launcher" }
    ),

    awful.key({ modkey }, "v",
        function ()
            awful.spawn.with_shell("copyq show")
        end,
        { description = "open clipboard manager", group = "launcher" }
    ),

    awful.key({ modkey }, "c",
        function ()
            run_or_raise(apps.default.development, apps.default.development)
        end,
        { description = "open development editor", group = "launcher" }
    ),

    awful.key({ modkey }, "g",
        function ()
            run_or_raise("galculator", "galculator")
        end,
        { description = "open galculator", group = "launcher" }
    ),

    -- Prompt
    awful.key({ modkey }, "r",
        function ()
            awful.spawn("rofi -show run")
        end,
        { description = "run prompt", group = "launcher" }
    )

)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = 'view tag #', group = 'tag'}
        descr_toggle = {description = 'toggle tag #', group = 'tag'}
        descr_move = {description = 'move focused client to tag #', group = 'tag'}
        descr_toggle_focus = {description = 'toggle focused client on tag #', group = 'tag'}
    end
    global_keys =
        awful.util.table.join(
        global_keys,
        -- View tag only.
        awful.key(
            {modkey},
            '#' .. i + 9,
            function()
                local focused = awful.screen.focused()
                local tag = focused.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            descr_view
        ),
        -- Toggle tag display.
        awful.key(
            {modkey, 'Control'},
            '#' .. i + 9,
            function()
                local focused = awful.screen.focused()
                local tag = focused.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            descr_toggle
        ),
        -- Move client to tag.
        awful.key(
            {modkey, 'Shift'},
            '#' .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            descr_move
        ),
        -- Toggle tag on focused client.
        awful.key(
            {modkey, 'Control', 'Shift'},
            '#' .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            descr_toggle_focus
        )
    )
end

return global_keys
