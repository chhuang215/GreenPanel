import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelRobotConfirm"
    // objectName: "panelRobotAddConfirm"
    visible: false
    signal addConfirm(int ptype, var s)
    signal removeConfirm(var s)
    signal removeSelection(var slotP, int slotN)
    property int plantType: -1
    property var slots: {}
    property int mode: 0

    onSlotsChanged:{
        listModel.clear()
        // console.log(JSON.stringify(slots))
        for (var p in slots) {
            //  console.log(p)
            for (var i = 0 ; i < slots[p].length; i ++){
                // console.log(p + " " + i + " ")
               
                if(slots[p][i].selected){
                    // console.log(JSON.stringify(slots[p][i]))
                    var pn = mode == 0 ? ("Plant: " + plantType) : slots[p][i].plant.name
                    
                    listModel.append({
                        "plantName": pn,
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
                text: plantName
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


    Button{
        // anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 70
        anchors.bottomMargin: 15
        text:"CONFIRM"
        onClicked:{
            mode == 0 ? parent.addConfirm(plantType, slots) : removeConfirm(slots)
        }
    }
}