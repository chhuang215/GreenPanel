import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelRobotSelectPlant"
    visible: false
    signal plantSelected(var plantData)

    property var plantList: {}

    Text{
        id: "txtLabel"
        anchors.horizontalCenter : parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
        text: "Select plant"
        font.pointSize: 38
    }

    Grid{
        anchors.horizontalCenter : parent.horizontalCenter
        anchors.top : txtLabel.bottom
        anchors.topMargin: 20
        columns: 4
        spacing: 20

        Repeater {
            model: plantList
            Item{
                width:175
                height:160
                Button{
                    // id:"btnP"+index
                    anchors.horizontalCenter : parent.horizontalCenter
                    width: 150
                    height: 150
                    text: modelData[1]
                    onClicked: panelRobotSelectPlant.plantSelected(modelData)
                }
                Text{
                    anchors.horizontalCenter : parent.horizontalCenter
                    anchors.bottom : parent.bottom
                    text: modelData[1] + " id:" + modelData[0] 
                    font.pointSize: 16
                }
            }
            
        }
    }

}