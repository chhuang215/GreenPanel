import QtQuick 2.3
import QtQuick.Controls 1.2

TimePicker {
    id: timePicker
    objectName:"timePicker"
    visible: false
    anchors.centerIn: parent

    Row {
        x: 450
        y: 330
        Button {
                id:"btnTimeConfirm"
                objectName:"btnTimeConfirm"
                width:100
                height:50
                text: "Confirm"
        }
    }
}