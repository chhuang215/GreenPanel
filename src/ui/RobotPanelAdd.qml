import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelRobotAdd"
    objectName: "panelRobotAdd"
    visible: false
    signal plantSelected(int type)
    // Button {
    //     text: "<-Back"
    //     objectName: "btnBack"
    // }

    Text{
        id: "txtLabel"
        anchors.horizontalCenter : parent.horizontalCenter
        text: "Select plant"
        font.pointSize: 38
    }

    Grid{
        anchors.horizontalCenter : parent.horizontalCenter
        anchors.top : txtLabel.bottom
        columns: 4
        spacing: 20

        Repeater {
            model: 8
            Rectangle{
                width:175
                height:160
                Button{
                    // id:"btnP"+index
                    anchors.horizontalCenter : parent.horizontalCenter
                    width: 150
                    height: 150
                    text: "Plant " + index 
                    onClicked: panelRobotAdd.plantSelected(index)
                }
                Text{
                    anchors.horizontalCenter : parent.horizontalCenter
                    anchors.bottom : parent.bottom
                    text: "Label: Plant " + index 
                    font.pointSize: 16
                }
            }
            
        }
    }

}