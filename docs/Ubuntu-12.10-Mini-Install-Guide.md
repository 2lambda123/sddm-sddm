    UBUNTU 12.10 mini install guide. There may be dependencies lacking.

    // SDDM -- Simple Desktop Display Manager
    // Install with QT5
    // (*) means this is in addition of basic recommended development 
    packages

    sudo apt-add-repository ppa:canonical-qt5-edgers/qt5-proper
    sudo apt-get update
    sudo apt-get upgrade
    *sudo apt-get install libpam0g-dev libqtbase5-dev qtbase5-dev-tools 
    qtdeclarative5-private-dev qtdeclarative5-qtquick2-plugin

    // Check that Qt5 is being used in case you have Qt4
    qmake --version
    // If it isn't : sudo apt-get install qt5-default

    git clone https://github.com/sddm/sddm.git
    cd sddm

    // At this point, you might want to read "./docs/INSTALL.md"

    mkdir build
    cd build
    cmake -DUSE_QT5=TRUE
    make
    sudo make install /OR/ sudo checkinstall --pkgname=sddm 
    --pkgversion=0.1.0-$(date +%Y%m%d)-git --deldoc=yes --fstrans=no 
    --backup=no -y

    // Don't forget to modify "/etc/X11/default-display-manage" with the path of the sddm executable (should be /usr/local/bin/sddm).
    // Last, backup your "/etc/pam.d/sddm" PAM profile, and copy a lightdm or gdm (non tested with gdm but should also work, since lighdm PAM config is adapted from GDM first) PAM profile. Rename it "sddm". You should end up with gdm or lightdm profiles untouched and one "/etc/pam.d/sddm" file that is a perfect, unaltered copy of your current working display manager.
    // Save all of your works. Switch to a tty (Ctrl-Alt-Fn where 'n' is 1 to 6). Stop your current display manager service with "sudo service mydisplaymanager stop". Finally, run "sudo sddm". 