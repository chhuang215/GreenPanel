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


    Button{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin:20
        text:"CONFIRM"
        onClicked:{
            parent.addConfirm(plantType, slotsSelected)
        }
    }
}