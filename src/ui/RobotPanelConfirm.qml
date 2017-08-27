import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelRobotConfirm"
    visible: false
    signal addConfirm(int ptype, var s)
    signal removeConfirm(var s)
    signal removeSelection(var slotP, int slotN)
    property var plantData: {}
    property var slots: {}
    property int mode: 0 // 0 is AddMode, 1 is RemoveMode

    onSlotsChanged:{
        listModel.clear()
        // console.log(JSON.stringify(slots))
        for (var p in slots) {
            //  console.log(p)
            for (var i = 0 ; i < slots[p].length; i ++){
                // console.log(p + " " + i + " ")
                if(!slots[p][i].selected) continue
                // console.log(JSON.stringify(slots[p][i]))
                var pn = ""
                if (mode == 0){
                    pn = plantData["name"]+ " (id:"+ plantData["id"] + ")" 
                    slots[p][i].date_planted = new Date()
                }
                else{
                    pn = slots[p][i].plant.name + " (id:" +slots[p][i].plant.plant_id+")" 
                    slots[p][i].date_planted = new Date(slots[p][i].date_planted)
                }

                var listData = {
                    "plantName" : pn,
                    "slotP" : p,
                    "slotN" : i,
                    "dateAdded": slots[p][i].date_planted
                }
                
                listModel.append(listData)
                
            }
        }
    }


    Row {
        id: listHeader
        anchors.top:parent.top
        anchors.topMargin: 75
        anchors.horizontalCenter:parent.horizontalCenter
        spacing: 1
        
        Repeater {
            id: repeater
            model: ["Plant Type", "Slot", "DatePlanted", ""]

            Label {
                width: index == 2 ? 200 : index == 3 ? 160 : 180
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
        width: 720
        
        anchors.top:listHeader.bottom
        anchors.bottom: btnConfirm.top
        anchors.bottomMargin: 30
        anchors.horizontalCenter:parent.horizontalCenter
        anchors.topMargin: 5
        model: listModel

        delegate: Row{
            width: listView.width
            height: listView.height / 6
            spacing:1

            Label {
                width: 180
                height: parent.height
                text: plantName
                font.pixelSize: 20
                padding: 10
                background: Rectangle { border.color : "black" }
            }
    
            Label {
                width: 180
                text: "Location: " + slotP + slotN
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
                    onPressed: mode == 0 ? popup.open() : null
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

                    Row{
                        spacing: 10
                        
                        Column{
                            width: 75
                            
                            Button{
                                width: 75
                                height: 33
                                text: "\u25B2"
                                onClicked: {
                                    var d = slots[slotP][slotN].date_planted
                                    d.setFullYear(d.getFullYear() + 1)
                                    slots[slotP][slotN].date_planted = d
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
                                height: 33
                                text: "\u25BC"
                                onClicked: {
                                    var d = slots[slotP][slotN].date_planted
                                    d.setFullYear(d.getFullYear() - 1)
                                    slots[slotP][slotN].date_planted = d
                                    dateAdded = d
                                }
                            }
                        }

                        Column{
                            width: 75
                            Button{
                                width: 75
                                height: 33
                                text: "\u25B2"
                                onClicked: {
                                    var d = slots[slotP][slotN].date_planted
                                    d.setMonth((d.getMonth() + 1) % 12)
                                    slots[slotP][slotN].date_planted = d
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
                                height: 33
                                text: "\u25BC"
                                onClicked: {
                                    var d = slots[slotP][slotN].date_planted
                                    var m = d.getMonth()
                                    d.setMonth(m == 0 ? 11 : (m - 1))
                                    slots[slotP][slotN].date_planted = d
                                    dateAdded = d
                                }
                            }
                        }

                        
                        Column{
                            width: 75
                            Button{
                                width: 75
                                height: 33
                                text: "\u25B2"
                                onClicked: {
                                    var d = slots[slotP][slotN].date_planted
                                    d.setDate(d.getDate() + 1)
                                    slots[slotP][slotN].date_planted = d
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
                                height: 33
                                text: "\u25BC"
                                onClicked: {
                                    var d = slots[slotP][slotN].date_planted
                                    d.setDate(d.getDate() - 1)
                                    slots[slotP][slotN].date_planted = d
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
                width: 160
                height: parent.height
        
                border.color: "black"
                Button{
                    anchors.centerIn: parent
                    text:"\u00D7"
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
        id: btnConfirm
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 70
        anchors.bottomMargin: 15
        text:"CONFIRM"
        onClicked:{
            mode == 0 ? parent.addConfirm(plantData[0], slots) : removeConfirm(slots)
        }
    }
}
