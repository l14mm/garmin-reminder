using Toybox.Application as App;
using Toybox.Timer;
using Toybox.Notifications;
using Toybox.WatchUi;
using Toybox.Lang;
import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class ReminderApp extends Application.AppBase {
    var _reminderTimer;
    var _dismissTimer;
    var _showingNotification = false;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Lang.Dictionary?) as Void {
        _startReminderTimer();
    }
    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new reminderView(), new reminderDelegate() ];
    }

    function _startReminderTimer() {
        if (_reminderTimer != null) {
            _reminderTimer.stop();
        }
        _reminderTimer = new Timer.Timer();
        _reminderTimer.start(method(:_showNotification), 10000, true); // repeat every 10s
    }

    function _showNotification() as Void {
        if (_showingNotification) {
            return;
        }
        _showingNotification = true;
        Notifications.showNotification(
            "Reminder!",
            "It's time to check in.",
            {
                :body => "This is your scheduled reminder.",
                :icon => Rez.Drawables.LauncherIcon,
                :dismissPrevious => true
            }
        );
        // Dismiss after 3 seconds
        _dismissTimer = new Timer.Timer();
        _dismissTimer.start(method(:_dismissNotification), 3000, false);
    }

    function _dismissNotification() as Void {
        Notifications.showNotification(
            "",
            "",
            {
                :body => "",
                :dismissPrevious => true
            }
        );
        _showingNotification = false;
    }

    function onStop(state as Lang.Dictionary?) as Void {
        if (_reminderTimer != null) {
            _reminderTimer.stop();
            _reminderTimer = null;
        }
        if (_dismissTimer != null) {
            _dismissTimer.stop();
            _dismissTimer = null;
        }
    }

    // No UI, so no onShowView/onHideView
}

function getApp() as ReminderApp {
    return Application.getApp() as ReminderApp;
}