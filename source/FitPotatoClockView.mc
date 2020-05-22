using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time.Gregorian;

using Toybox.System;
using Toybox.Lang;
using Toybox.Math;

class FitPotatoClockView extends WatchUi.WatchFace {
    const MOTIVATIONAL_LINES = [
      ["Stop Being A", "Couch Potato!"]
    ];
 
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));      
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get and show the current time
        var clockTime = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        var hour = clockTime.hour;
        
        var timeString = Lang.format("$1$:$2$$3$", [twelveHour(hour), clockTime.min.format("%02d"), ampm(hour)]);
        var timeLabel = View.findDrawableById("TimeLabel");
        timeLabel.setText(timeString);
        
        var dateString = Lang.format("$1$ $2$, $3$", [clockTime.month, clockTime.day, clockTime.year]);
        var dateLabel = View.findDrawableById("DateLabel");
        dateLabel.setText(dateString);
        
        var motivationLines = motivation(clockTime);
        var motivationLabel1 = View.findDrawableById("MotivationLine1Label");
        motivationLabel1.setText(motivationLines[0]);
        
        var motivationLabel2 = View.findDrawableById("MotivationLine2Label");
        motivationLabel2.setText(motivationLines[1]);

        var batteryPercentageLabel = View.findDrawableById("BatteryPercentageLabel");
        var clockStats = System.getSystemStats();
        var batteryVal = clockStats.battery.toNumber();
        batteryPercentageLabel.setText(batteryVal + "%");
        
        var batteryImage = View.findDrawableById("BatteryLogo");
        batteryImage.setBitmap(getBatteryIcon(batteryVal));
        
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
    }
    
    function twelveHour(hour) {
        var newHour = hour % 12;
        if (newHour == 0) { newHour = 12; }
        return newHour;
    }

    function ampm(hour) {
        if (hour >= 12) { return "pm"; }
        return "am";
    }
    
    function getBatteryIcon(batteryVal) {
    	var batteryIcon;
        if (batteryVal >= 90) {
           batteryIcon = Rez.Drawables.BatteryLogoFull;
        } 
        else if (batteryVal >= 30) {
           batteryIcon = Rez.Drawables.BatteryLogoMid;
        } 
        else {
           batteryIcon = Rez.Drawables.BatteryLogoEmpty;
        }
        return batteryIcon;
    }

    function motivation(clockTime) {
      return MOTIVATIONAL_LINES[clockTime.min % MOTIVATIONAL_LINES.size()];
    }
 
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
