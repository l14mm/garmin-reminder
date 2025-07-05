import Toybox.Lang;
import Toybox.WatchUi;

class reminderDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new reminderMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}