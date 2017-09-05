import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0

Item{
    visible: false
    Calendar{
        id: datePicker
        objectName:"datePicker"
        
        width: 400
        height: 400
        weekNumbersVisible: true
        anchors.centerIn: parent
        
        Button {
                id:"btnDateConfirm"
                objectName:"btnDateConfirm"
                x: 450
                y: 350
                width:100
                height:50
                text: "Confirm"
        }
        
    }
}

