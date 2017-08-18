import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    TimePicker {
        id: timePicker
        objectName:"timePicker"
        visible: false
        anchors.centerIn: parent

                
        Button {
            
            id:"btnTimeConfirm"
            objectName:"btnTimeConfirm"
            x: 450
            y: 330
            width:100
            height:50
            text: "Confirm"
        }

    }
}

