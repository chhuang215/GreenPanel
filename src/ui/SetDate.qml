import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0

Item{
    Calendar{
        id: datePicker
        objectName:"datePicker"
        visible: false
        weekNumbersVisible: true
        anchors.centerIn: parent
        
        Button {
                id:"btnDateConfirm"
                objectName:"btnDateConfirm"
                x: 250
                y: 200
                width:100
                height:50
                text: "Confirm"
        }
        
    }
}

