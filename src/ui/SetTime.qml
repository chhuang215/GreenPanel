import QtQuick 2.7
import QtQuick.Controls 2.0

Item{

    property alias hours: timePicker.hours
    property alias minutes: timePicker.minutes

    visible: false

    onVisibleChanged:{
        if(visible){
            updateTimer.start()
        }
        else{
            updateTimer.stop()
        }
    }

    function timeChanged() {
        var date = new Date;
        // timePicker.hour = internationalTime ? date.getUTCHours() + Math.floor(clock.shift) : date.getHours()
        hours = date.getHours()
        // night = ( hours < 7 || hours > 19 )
        // timePicker.minute = internationalTime ? date.getUTCMinutes() + ((clock.shift % 1) * 60) : date.getMinutes()
        minutes = date.getMinutes()
        console.log("HEY")
        // seconds = date.getUTCSeconds();
    }

    

    Timer {
        id:updateTimer
        interval: 1000;  repeat: true;
        onTriggered: timeChanged()
    }

    TimePicker {
        id: timePicker
        objectName:"timePicker"
        // visible: false
        anchors.centerIn: parent

        Button {
            
            id:"btnTimeConfirm"
            objectName:"btnTimeConfirm"
            anchors.left: parent.right
            y: 330
            width:100
            height:50
            text: "Confirm"
        }

    }
}

