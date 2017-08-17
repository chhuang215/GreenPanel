import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelRobotAddConfirm"
    objectName: "panelRobotAddConfirm"
    visible: false
    signal addConfirm(int ptype, var s)
    property int plantType: -1
    property var slotsSelected: {"A": [0,0,0], "B": [0,0],
                                "C": [0,0,0], "D": [0,0],
                                "E": [0,0,0], "F": [0,0],
                                "G": [0,0,0], "H": [0,0]
                                }
    onSlotsSelectedChanged:{
        console.log("YOYOYOYOYO!")
    }
    
    Grid{
        id:grid
        anchors.centerIn: parent
        columns:3
        rows: 4

        Repeater{
            model: parent.rows
            Text{
                text:plantType
            }
            Text{
                text:"stuff"
            }
            Button{
                text:"X"
            }
        }
    }

    Button{
        // anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 70
        anchors.bottomMargin: 15
        text:"CONFIRM"
        onClicked:{
            parent.addConfirm(plantType, slotsSelected)
        }
    }
}