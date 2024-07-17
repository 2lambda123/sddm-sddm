## Themes

SDDM themes are created using QtQuick framework, a declarative framework to develop next-generation, hardware-accelerated user interfaces with fluid animations. QtQuick offers some basic components

On top of QtQuick, we provide some custom components to make theme development even easier. For example a picturebox which can show user avatars. Most of the components can be used as views in a model-view sense.

We also provide models containing information about the screens, sessions available and users. Connect these with the provided components and you have fully working solution. For example, below is the whole _code_ needed to create a session selection combobox:

    ComboBox {
    	id: session
    	arrowIcon: "angle-down.png"
    	model: sessionModel
    	index: sessionModel.lastIndex
    }

## Proxy Object

We provide a proxy object, called as `sddm` to the themes as a context property. This object holds some useful properties about the host system. It also acts as a proxy between the greeter and the daemon. All of the methods called on this object will transfered to the daemon through a local socket and will be executed there. 

### Properties

**hostname:** Holds the name of the host computer.

**canPowerOff:** true, if we can power off the machine; false, otherwise

**canReboot:** true, if we can reboot the machine; false, otherwise

**canSuspend:** true, if the machine supports suspending to the memory; false, otherwise

**canHibernate:** true, if the machine supports hibernating, e.g suspending to the disk; false, otherwise

**canHybridSleep:** true, if the machine supports hybrid sleep, e.g suspending to both memory and disk; false, otherwise

### Methods

**powerOff():** Powers of the machine.

**reboot():** Reboots the machine.

**suspend():** Suspends the machine to the memory.

**hibernate():** Suspends the machine to the disk.

**hybridSleep():** Suspends the machine both to the memory and the disk.

**login(user, password, sessionIndex):** Attempts to login as the `user`, using the `password` into the session pointed by the `sessionIndex`. Either the `loginFailed` or the `loginSucceeded` signal will be emitted depending on whether the operation is successfull or not. 

### Signals

**loginFailed():** Emitted when a requested login operation fails.

**loginSucceeded():** Emitted when a requested login operation succeeds.

## Data Models
Besides the proxy object we offer a few models that can be hooked to the views to handle multiple screens or enable selection of users or sessions.

**screenModel:** This is a list model containing geometry information of the screens available. This model only provides logical screen numbers and geometries. If you have two physical monitors, but configured to be duplicates we only report one screen.

For each screen the model provides `name` and `geometry` properties.
The model also provides, a `primary` property pointing to the index of the primary monitor and a `geometry` method which takes a monitor index and returns the geometry of it. If you `-1` to the `geometry` method it will return the united geometry of all the screens avaiable.

**sessionModel:** This is a list model. Contains information about the desktop sessions installed on the system. This information is gathered by parsing the desktop files in the `/usr/share/xsessions`. These desktop files are generally installed when you install a desktop environment or a window manager.

For each session, the model provides `file`, `name`, `exec` and `comment` properties.
Also there is a `lastIndex` property, pointing to the last session the user successfully logged in.
In SDDM 0.21+ there is a `count` property that provides count of available sessions.

**userModel:** This is list model. Contains information about the users available on the system. This information is gathered by parsing the `/etc/passwd` file. To prevent system users polluting the user model we only show users with user ids greater than a certain threshold. This threshold is adjustable through the config file and called `MinimumUid`. 

For each user the model provides `name`, `realName`, `homeDir` and `icon` properties.
This model also has a `lastIndex` property holding the index of the last user successfully logged in, and a `lastUser` property containing the name of the last user successfully logged in.
There is a `count` property that provides count of available users.

### Keyboard stuff
**keyboard** object.

**keyboard.numLock** - boolean, numlock state (can be changed).

**keyboard.capsLock** - boolean, capslock state (can be changed).

**keyboard.currentLayout** - integer, id of current layout (can be changed).

**keyboard.layouts** - list model, each element provides properties `shortName` - 2 symbol country code and `longName` - full country name

## Localization

See [this](https://github.com/sddm/sddm/wiki/Localization)

## Theme Configuration

Themes can have a configuration file to allow changing of appearance (e.g. wallpaper path and type) and behaviour (e.g. controls to show). This configuration file is in the theme's directory and by default called `theme.conf`. The filename can be changed by setting `[SddmGreeterTheme] ConfigFile=foobar.ini` in `metadata.desktop`. To change configuration values, create a file next to it with the filename + a `.user` suffix, e.g. `theme.conf.user` and write the desired values into it. This split is such that theme authors, editors and packagers can specify default values and changes performed by users are not lost on upgrades.

Themes can access the configuration values through the `config` object in the global QML namespace.

**config.keys().indexOf(key)** Returns -1 if key is not specified in the configuration file(s).

### Old implicitly typed API

The configuration value is directly accessible as member of the `config` object, e.g. `config.timeout` for `timeout=10`.

It's discouraged to use this API as all values are returned as `string` type, which means that for e.g. `doStuff=false`, `if(config.doStuff)` will be executed and for `timeout=10`, `config.timeout + 1` will be `101`!

### New explicitly typed API (since SDDM 0.20)

**config.boolValue(key)** Returns the value of the setting as boolean, `false` if unset. This uses `QVariant::toBool` internally, so `false`, `0` or an empty string in the configuration file count as `false`, everything else is `true`. Example: `if(config.boolValue("doStuff")) doStuff();`.

**config.intValue(key)** Returns the value of the setting as integer, `0` if unset or conversion fails. This uses `QVariant::toInt` internally. Example: `timeout_plus_one = config.intValue("timeout") + 1;`.

**config.realValue(key)** Returns the value of the setting as real, `0.0` if unset or conversion fails. This uses `QVariant::toReal` internally.

**config.stringValue(key)** Returns the value of the setting as string, an empty string if unset.

## Testing

You can test your themes using `sddm-greeter`. Note that in this mode, actions like shutdown, suspend or login will have no effect.

    sddm-greeter --test-mode --theme /path/to/you/theme

When using Qt5, test-mode requires at least xorg-server 1.15.0, as older releases don't support GLX in Xephyr which is required by QtQuick2.
