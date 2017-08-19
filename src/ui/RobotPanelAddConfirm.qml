import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelRobotAddConfirm"
    objectName: "panelRobotAddConfirm"
    visible: false
    signal addConfirm(int ptype, var s)
    signal removeSelection(var slotP, int slotN)
    property int plantType: -1
    property var slots: {}

    onSlotsChanged:{
        listModel.clear()
        // console.log(JSON.stringify(slots))
        for (var p in slots) {
            //  console.log(p)
            for (var i = 0 ; i < slots[p].length; i ++){
                // console.log(p + " " + i + " ")
                // console.log(JSON.stringify(slots[p][i]))
                if(slots[p][i].selected){
                    listModel.append({
                        "slotP" : p,
                        "slotN" : i
                    })
                }
            }
        }
    }

    ListView {
        id: listView
        width:650
        anchors.top:parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.topMargin: 90
        model: listModel

        header: Row {
            spacing: 1
            Repeater {
                id: repeater
                model: ["Plant Type", "Slot", "Opt"]
                Label {
                    width: 200
                    text: modelData
                    font.bold: true
                    font.pixelSize: 20
                    padding: 10
                    background: Rectangle { color: "silver" }
                }
            }
        }

        delegate: Row{
            width: listView.width
            height: listView.height / 8

            Label {
                width: 200
                height: parent.height
                text: "Plant: " + panelRobotAddConfirm.plantType
                font.pixelSize: 20
                padding: 10
                background: Rectangle { border.color : "black" }
            }
    
            Label {
                width: 200
                text: "Location: " + slotP + slotN
                height: parent.height
                font.pixelSize: 20
                padding: 10
                background: Rectangle { border.color : "black" }
            }
                
            Rectangle{
                width: 200
                height: parent.height
        
                border.color: "black"
                Button{
                    anchors.centerIn: parent
                    text:"Remove"
                    onClicked:{
                        removeSelection(slotP, slotN)

                    }
                }
            }

        }
    }

    ListModel {
        id: listModel

    }
    // Grid{
    //     id:grid
    //     anchors.centerIn: parent
    //     columns:3
    //     rows: 4

    //     Repeater{
    //         model: parent.rows
    //         Text{
    //             text:plantType
    //         }
    //         Text{
    //             text:"stuff"
    //         }
    //         Button{
    //             text:"X"
    //         }
    //     }
    // }

    Button{
        // anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 70
        anchors.bottomMargin: 15
        text:"CONFIRM"
        onClicked:{
            parent.addConfirm(plantType, slots)
        }
    }
}