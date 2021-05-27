-- MODULE AUTO-START
-- Run all the apps listed in configuration/apps.lua as run_on_start_up only once when awesome start

local awful = require('awful')
local naughty = require('naughty')
local apps = require('configuration.apps')
local config = require('configuration.config')
local watch = awful.widget.watch
local debug_mode = config.module.auto_start.debug_mode or false

local run_watcher = function(cmd)
    watch(
        string.format([[pgrep -f '%s']], cmd),
        60,
        function(_, stdout, stderr, exitreason, exitcode)
            -- Debugger
            if exitcode ~= 0 then
                naughty.notification({
                    app_name = 'Start-up Applications',
                    title = string.format('<b>It seems that %s has died.</b>', cmd),
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

local run_once = function(cmd)
    awful.spawn.easy_async_with_shell(
        string.format([[pgrep -u $USER -x -f '%s' > /dev/null || (%s &)]], cmd, cmd),
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

for _, app in ipairs(apps.run_on_start_up) do
    run_once(app)
    run_watcher(app)
end

awesome.connect_signal(
    'module::auto-start:run',
    function()
        for _, app in ipairs(apps.run_on_start_up) do
            run_once(app)
        end
    end
)

