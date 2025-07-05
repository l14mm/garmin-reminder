import Toybox.Graphics;
import Toybox.WatchUi;

class reminderView extends WatchUi.View {

    var _reminderTimer;
    function initialize() {
        View.initialize();
        // Set up a timer to trigger every 5 minutes (300 seconds)
        _reminderTimer = null;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        // Start the 5-minute timer when the view is shown
        _startReminderTimer();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        // Stop the timer when the view is hidden
        if (_reminderTimer != null) {
            _reminderTimer.stop();
            _reminderTimer = null;
        }
    }

    // Start or restart the reminder timer
    function _startReminderTimer() as Void {
        if (_reminderTimer != null) {
            _reminderTimer.stop();
        }
        // Use Toybox.Timer.Timer for a repeating timer
        _reminderTimer = new Toybox.Timer.Timer();
        // 300 seconds = 300000 ms
        // Timer.start(callback as Method, delay as Number, repeat as Boolean)
        _reminderTimer.start(method(:_showReminder), 5000, true);
    }

    // Show the posture reminder
    var _showingNotification = false;
    var _notificationTimer;
    function _showReminder() as Void {
        // Vibrate
        if (Toybox has :Attention) {
            Toybox.Attention.vibrate([]);
        }
        // Show notification on screen
        _showingNotification = true;
        // Redraw to show notification
        WatchUi.requestUpdate();
        // Hide notification after 3 seconds
        if (_notificationTimer != null) {
            _notificationTimer.stop();
        }
        _notificationTimer = new Toybox.Timer.Timer();
        _notificationTimer.start(method(:_hideNotification), 3000, false);
    }

    function _hideNotification() as Void {
        _showingNotification = false;
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        if (_showingNotification) {
            var w = dc.getWidth();
            var h = dc.getHeight();
            var msg = "Check your posture!";
            var font = Graphics.FONT_XLARGE;
            var textWidth = dc.getTextWidth(msg, font);
            var textHeight = dc.getFontHeight(font);
            var x = (w - textWidth) / 2;
            var y = (h - textHeight) / 2;
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            dc.clear();
            dc.drawText(x, y, font, msg, Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

}
