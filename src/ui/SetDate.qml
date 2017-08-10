import QtQuick 2.7
import QtQuick.Controls 1.2

Calendar{
    id: datePicker
    objectName:"datePicker"
    visible: false
    weekNumbersVisible: true
    anchors.centerIn: parent

    Button {
        x: 250
        y: 0
        text: "<-Back"
        objectName: "btnBack"
    }

    Row {
        x: 250
        y: 200
        Button {
                id:"btnDateConfirm"
                objectName:"btnDateConfirm"
                width:100
                height:50
                text: "Confirm"
        }
    }
}