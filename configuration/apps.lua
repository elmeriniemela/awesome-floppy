local filesystem = require('gears.filesystem')
local config_dir = filesystem.get_configuration_dir()
local utils_dir = config_dir .. 'utilities/'

return {
    -- The default applications that we will use in keybindings and widgets
    default = {
        -- Default terminal emulator
        terminal = 'terminator',
        -- Default web browser
        web_browser = 'firefox',
        -- Default text editor
        text_editor = 'vim',
        -- Default file manager
        file_manager = 'pcmanfm',
        -- Default media player
        multimedia = 'vlc',
        -- Default game, can be a launcher like steam
        game = 'supertuxkart',
        -- Default graphics editor
        graphics = 'gimp-2.10',
        -- Default sandbox
        sandbox = 'virtualbox',
        -- Default IDE
        development = 'code',
        -- Default power manager
        power_manager = 'xfce4-power-manager',
        -- Default GUI package manager
        package_manager = 'pacman',
        -- Default locker
        lock = 'awesome-client "awesome.emit_signal(\'module::lockscreen_show\')"',
        -- Default rofi global menu
        rofi_global = 'rofi -dpi ' .. screen.primary.dpi ..
                            ' -show "Global Search" -modi "Global Search":' .. config_dir ..
                            '/configuration/rofi/global/rofi-spotlight.sh' ..
                            ' -theme ' .. config_dir ..
                            '/configuration/rofi/global/rofi.rasi',
        -- Default app menu
        rofi_appmenu = 'rofi -dpi ' .. screen.primary.dpi ..
                            ' -show drun -theme ' .. config_dir ..
                            '/configuration/rofi/appmenu/rofi.rasi'

        -- You can add more default applications here
    },

    -- List of apps to start once on start-up
    run_on_start_up = {
        "nm-applet",
        "picom -b --experimental-backends --dbus --config " .. config_dir .. "configuration/picom.conf",
        "lxqt-policykit-agent",
        "copyq",
        "blueman-applet", -- not really used atmgit s
        [[xidlehook --not-when-fullscreen --not-when-audio --timer 600  "awesome-client 'awesome.emit_signal(\"module::lockscreen_show\")'" ""]],
    },

    -- List of binaries/shell scripts that will execute for a certain task
    utils = {
        -- Fullscreen screenshot
        full_screenshot = utils_dir .. 'snap full',
        -- Area screenshot
        area_screenshot = utils_dir .. 'snap area',
        -- Update profile picture
        update_profile  = utils_dir .. 'profile-image'
    }
}
