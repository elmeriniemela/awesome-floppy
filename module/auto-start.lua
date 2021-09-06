-- MODULE AUTO-START
-- Run all the apps listed in configuration/apps.lua as run_on_start_up only once when awesome start

local awful = require('awful')
local naughty = require('naughty')
local apps = require('configuration.apps')
local config = require('configuration.config')
local watch = awful.widget.watch
local debug_mode = config.module.auto_start.debug_mode or false
local gears = require('gears')

local run_watcher = function(findme)
    watch(
        string.format([[pgrep '%s']], findme),
        60,
        function(_, stdout, stderr, exitreason, exitcode)
            -- Debugger
            if exitcode ~= 0 then
                naughty.notification({
                    app_name = 'Start-up Applications',
                    title = string.format('<b>It seems that %s has died.</b>', findme),
                    message = 'Restarting..',
                    -- message = string.format('<br/>stdout=%s<br/>stderr=%s<br/>exitreason=%s<br/>exitcode=%s', stdout, stderr, exitreason, exitcode),
                    timeout = 20,
                    icon = require('beautiful').awesome_icon
                })
                awesome.emit_signal('module::auto-start:run')
            end
        end
    )
end

local run_once = function(findme, cmd)
    local command = string.format([[pgrep -u $USER '%s' > /dev/null || (%s &)]], findme, cmd)
    awful.spawn.easy_async_with_shell(
        command,
        function(stdout, stderr)
            -- Debugger
            if not stderr or stderr == '' or not debug_mode then
                return
            end
            naughty.notification({
                app_name = 'Start-up Applications',
                title = '<b>Oof! Error detected when starting an application!</b>',
                message = stderr:gsub('%\n', ''),
                timeout = 20,
                icon = require('beautiful').awesome_icon
            })
        end
    )
end

for _, cmd in ipairs(apps.run_on_start_up) do
    local findme = cmd
    local firstspace = cmd:find(' ')
    if firstspace then
        findme = cmd:sub(0, firstspace - 1)
    end
    if findme == "lxqt-policykit-agent" then
        findme = "lxqt-policykit"
    end
    run_once(findme, cmd)
    -- Add a little delay before checking if autostart apps have died
    gears.timer.start_new(
        5,
        function()
            run_watcher(findme)
        end
    )
end

awesome.connect_signal(
    'module::auto-start:run',
    function()
        for _, cmd in ipairs(apps.run_on_start_up) do
            run_once(cmd)
        end
    end
)

