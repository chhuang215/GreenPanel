import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelRobotConfirm"
    visible: false
    signal addConfirm(int ptype, var s)
    signal removeConfirm(var s)
    signal removeSelection(var slotP, int slotN)
    property var plantData: {} // "{id, name}"
    // property var slots: {}
    property int mode: 0 // 0 is AddMode, 1 is RemoveMode

    onVisibleChanged:{
        listModel.clear()
        // console.log(JSON.stringify(slots))
        for (var p in plantSlots) {
            //  console.log(p)
            for (var i = 0 ; i < plantSlots[p].length; i ++){
                // console.log(p + " " + i + " ")
                if(!plantSlots[p][i].selected) continue
                // console.log(JSON.stringify(slots[p][i]))
                var pn = ""
                // var datePlanted = new Date()
                if (mode == 0){
                    pn = plantData["name"]+ " (id:"+ plantData["id"] + ")" 
                    plantSlots[p][i].datePlanted = new Date()
                }
                else{
                    pn = plantSlots[p][i].plant.name + " (id:" +plantSlots[p][i].plant.plant_id+")" 
                    plantSlots[p][i].datePlanted = new Date(plantSlots[p][i].datePlanted)
                    // datePlanted = plantSlots[p][i].datePlanted
                }

                var listData = {
                    "plantName" : pn,
                    "slotP" : p,
                    "slotN" : i,
                    "dateAdded": plantSlots[p][i].datePlanted
                }
                
                listModel.append(listData)
                
            }
        }
    }

    Item{
        width: 700
        anchors.top:parent.top
        anchors.topMargin: 75
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.bottom: btnConfirm.top
        anchors.bottomMargin: 45
        Row {
            id: listHeader
            anchors.top:parent.top
            anchors.horizontalCenter:parent.horizontalCenter
            spacing: 1
            
            Repeater {
                id: repeater
                model: ["Plant Type", "Slot Location", "DatePlanted", ""]

                Label {
                    width: index == 2 ? 200 : index == 3 ? 150 : 175
                    text: modelData
                    font.bold: true
                    font.pixelSize: 20
                    padding: 10
                    background: Rectangle { color: "silver" }
                }
            }
        }
        ListView {
            id: listView
            
            anchors.top:listHeader.bottom
            anchors.bottom: parent.bottom
            anchors.right:parent.right
            anchors.left:parent.left
        
            anchors.topMargin: 5
            model: listModel

            delegate: Row{
                width: listView.width
                height: listView.height / 5
                spacing:1

                Label {
                    width: 175
                    height: parent.height
                    text: plantName
                    font.pixelSize: 20
                    padding: 10
                    background: Rectangle { border.color : "black" }
                }
        
                Label {
                    width: 175
                    text: "" + slotP + slotN
                    height: parent.height
                    font.pixelSize: 20
                    padding: 10
                    background: Rectangle { border.color : "black" }
                }

                Label {
                    width: 200
                    text: dateAdded.toDateString()
                    height: parent.height
                    font.pixelSize: 20
                    padding: 10
                    background: Rectangle { border.color : "black" }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: mode == 0 ? popup.open() : null
                    }

                    Popup {
                        id: popup
                        x: -parent.width/2
                        y: 0
                        width: 2 * parent.width 
                        height: parent.height * 2
                        modal: true
                        focus: true
                        padding : 3
                        leftPadding : 10
                        dim: false
                        enter: null
                        exit: null
                        Row{
                            spacing: 10
                            
                            Column{
                                width: 75
                                
                                Button{
                                    width: 75
                                    height: 35
                                    text: "\u25B2"
                                    onClicked: {
                                        var d = plantSlots[slotP][slotN].datePlanted
                                        d.setFullYear(d.getFullYear() + 1)
                                        // slots[slotP][slotN].date_planted = d
                                        dateAdded = d
                                    }
                                }

                                Text{
                                    id: txtSetYear
                                    width: parent.width
                                    text: dateAdded.getFullYear()
                                    font.pointSize: 16
                                    horizontalAlignment : Text.AlignHCenter
                                }

                                Button{
                                    width: 75
                                    height: 35
                                    text: "\u25BC"
                                    onClicked: {
                                        var d = plantSlots[slotP][slotN].datePlanted
                                        d.setFullYear(d.getFullYear() - 1)
                                        // slots[slotP][slotN].date_planted = d
                                        dateAdded = d
                                    }
                                }
                            }

                            Column{
                                width: 75
                                Button{
                                    width: 75
                                    height: 35
                                    text: "\u25B2"
                                    onClicked: {
                                        var d = plantSlots[slotP][slotN].datePlanted
                                        d.setMonth((d.getMonth() + 1) % 12)
                                        // slots[slotP][slotN].date_planted = d
                                        dateAdded = d
                                    }
                                }

                                Text{
                                    id: txtSetMonth
                                    width: parent.width
                                    text: {
                                        var dateString = dateAdded.toLocaleDateString(Qt.locale(), "MMM")
                                        return dateString
                                    }
                                    font.pointSize: 16
                                    horizontalAlignment : Text.AlignHCenter
                                }

                                Button{
                                    width: 75
                                    height: 35
                                    text: "\u25BC"
                                    onClicked: {
                                        var d = plantSlots[slotP][slotN].datePlanted
                                        var m = d.getMonth()
                                        d.setMonth(m == 0 ? 11 : (m - 1))
                                        // slots[slotP][slotN].date_planted = d
                                        dateAdded = d
                                    }
                                }
                            }

                            
                            Column{
                                width: 75
                                Button{
                                    width: 75
                                    height: 35
                                    text: "\u25B2"
                                    onClicked: {
                                        var d = plantSlots[slotP][slotN].datePlanted
                                        d.setDate(d.getDate() + 1)
                                        // slots[slotP][slotN].date_planted = d
                                        dateAdded = d
                                    }
                                }

                                Text{
                                    id: txtSetDate
                                    width: parent.width
                                    text: dateAdded.getDate()
                                    font.pointSize: 16
                                    horizontalAlignment : Text.AlignHCenter
                                }

                                Button{
                                    width: 75
                                    height: 35
                                    text: "\u25BC"
                                    onClicked: {
                                        var d = plantSlots[slotP][slotN].datePlanted
                                        d.setDate(d.getDate() - 1)
                                        // slots[slotP][slotN].date_planted = d
                                        dateAdded = d
                                    }
                                }
                            }
                        }

                        Button{
                            id: btnDateOk
                            anchors.right: parent.right
                            anchors.top: parent.top
                            text: "ok"
                            onClicked: {
                                popup.close()
                            }
                        }
                        Button{
                            id: btnDateToday
                            anchors.right: btnDateOk.left
                            anchors.top: parent.top
                            text: "today"
                            onClicked: {
                            dateAdded = new Date()
                            }
                        }
                    }
                }
                    
                Rectangle{
                    width: 150
                    height: parent.height
            
                    border.color: "black"
                    Button{
                        anchors.centerIn: parent
                        text:"\u00D7"
                        onClicked:{
                            //removeSelection(slotP, slotN)
                            plantSlots[slotP][slotN].selected = false
                            plantSlots[slotP][slotN].clearDatePlanted()
                        }
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
        id: btnConfirm
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 70
        anchors.bottomMargin: 15
        text:"CONFIRM"
        onClicked:{
            mode == 0 ? parent.addConfirm(plantData["id"], plantSlots) : removeConfirm(plantSlots)
        }
    }
}
