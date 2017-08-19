import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelWater"
    
    property bool waterGood: false
    visible: false
    
    function changeWaterStatusText(t){
        txtStatus.text = t;
    }

    Text{
        id: "txtStatus"
        anchors.horizontalCenter : parent.horizontalCenter
        anchors.verticalCenter : parent.verticalCenter
        font.pointSize: 38
    }
}