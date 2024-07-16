There are still unimplemented parts but user switching, session list in krunner etc are working with KDE master now, so we don't need to implement rest yet.

* DisplayManager
    * AddSeat
    * AddLocalXSeat
    * ~~SeatAdded~~
    * ~~SeatRemoved~~
    * ~~SessionAdded~~
    * ~~SesssionRemoved~~
    * ~~Seats~~
    * ~~Sessions~~
* DisplayManager.Seat
    * ~~SwitchToGreeter~~
    * SwitchToUser
    * SwitchToGuest
    * Lock
    * ~~CanSwitch~~
    * ~~HasGuestAccount~~
    * ~~Sessions~~
* DisplayManager.Session
    * Lock
    * ~~Seat~~
    * ~~UserName~~