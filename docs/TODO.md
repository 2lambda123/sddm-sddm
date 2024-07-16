###Configuration
* Shouldn't remove comment lines
* Should reload when the file is changed
* Changed signals (single for all or one per each setting)

###Users/Authentication
* ~~Auto Login~~
* ~~Auto login needs to go through PAM as well~~
* ~~Auto Relogin~~
* AccountsService -- Needs Qt5
* LDAP -- Theoretically should work over PAM, needs to be tested
* DMRC
    * Contains user's preferred session and language
    * Update on succesfull logins
    * User model needs to be extended
    * Themes need to be modified
* XDMCP -- **MartinBriza**
* Remote VNC/RDP
* Guest Login
* Authenticator ==> SessionManager singleton, with backends -- **aavci**
    * daemonApp->sessionManager()->authenticate(?)
    * daemonApp->sessionManager()->startSession(?)
    * ~~Unix (authentication)~~
    * ConsoleKit (start/stop session)
    * ~~PAM (authenticate, start/stop session)~~
    * Utmp (start/stop session)

###Power Management
* Suspend when lid closed (not needed for systemd)
    * org.freedesktop.UPower.LidIsClosed
* ~~Create runtime pluggable backends~~
    * ~~UPowerBackend~~
    * ~~Login1Backend~~

###Themeing
* Login animations
* theme.conf.user overriding
* ~~Translations (linguist or gettext)~~
* On-screen keyboard/Maliit -- Needs Qt5
* Bodega server integration
* Plasma package format
* Plasma themeing
    
###Miscellaneous
* Missing environment variables
    * BROWSER, kdm, lightdm, set by /etc/environment, pam_env ?
    * ~~MAIL,kdm, lightdm, should be /var/spool/mail, we have /var/mail?~~
    * ~~XDG_RUNTIME_DIR, kdm, lightdm~~
    * ~~XDG_SESSION_ID, kdm, lightdm~~
    * ~~DM_CONTROL, kdm~~ -- only set by kdm, probably not needed.
    * ~~XDM_MANAGED, kdm~~ -- only set by kdm, probably not needed.
* ~~User filtering~~
    * ~~MinimumUid~~
    * ~~MaximumUid~~
    * ~~HideUsers~~
    * ~~HideShells~~
* ~~Instead of waitForFinished use finished signal in Authenticator~~
* ~~Greeter becomes a zombie process  after login~~
* ~~Find an unused display automatically~~
* ~~Find an unused virtual terminal automatically~~
* ~~Fast user switching~~
* ~~[[org.freedesktop.DisplayManager]]~~
* Create a lib to be used by the daemon, greeter and the config interface
    * Configuration, {User/Screen/Session/Theme}Models, Messages classes
    * Convert ServerPath, XauthPath, AuthDir etc. to compile time settings
* Login1 multi-seat -- **MartinBriza**
* Wayland system compositor support -- Needs Qt5 **Pier Luigi Fiorini**
* H/W & Biometrics (fingerprint, usb based authentication)
* Session hooks (scripts to run pre-x, post-x, pre-session, post-session, logout)

###Comments
* Checking gid's isn't a robust solution. Imagine a PAM setup that starts with "auth sufficient pam_usb.so ", i.e "if I have a special signed USB key" don't prompt me for the password." then in my greeter I want to know that. That's why the LightDM code goes through PAM all the time including for checking the nopasswdlogin group.

* PAM support for more than login(username, password). Mimicing the whole PAM conversation to/from the greeter makes writing themes a lot more difficult, but it needs doing if you have multiple password prompts. Passive prompts (fingerprint etc) are more difficult.Branch (to be merged) of LightDM-KDE shows a login button rather than a password prompt if the user is in the nopasswd group / doesn't need a password. LightDM supports starting a PAM conversation, and aborting straight away so you can see what prompts are needed. 