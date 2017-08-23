import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelWater"
    
    property bool waterGood: false
    visible: false

    Text{
        id: "txtStatus"
        text: {
            if(waterGood) "Water level is good";
            else "Please add water\nYour plants will be ded."
        }
        anchors.horizontalCenter : parent.horizontalCenter
        anchors.verticalCenter : parent.verticalCenter
        font.pointSize: 38
    }
}