import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Qt.labs.calendar 1.0
Item{
    id: "panelRobot"
    visible: false
    signal addButtonClicked()
    signal removeButtonClicked()
    property string selectedP: 'A'
    property int selectedN: 0
    property alias currCenter : robotSlots.currCenter
    property alias currRight : robotSlots.currRight

    function editDatePlanted(p, n, d) {
        plantSlots[p][n].editDatePlanted(d)
        // plantSlots[p][n].datePlanted = d
    }

    // The UI slot base
    RobotSlots{
        id: robotSlots
        anchors.fill: parent
        slotComponent: slotHole
    }

    Button {
        id:btnAddPlant
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 5
        anchors.topMargin: 100

        text: "Add Plant"
        objectName: "btnAddPlant"
        onClicked: parent.addButtonClicked()
    }

    Button {
        anchors.right: parent.right
        anchors.top : btnAddPlant.bottom
        anchors.rightMargin: 5
        anchors.topMargin : 5
        text: "Remove Plant"
        objectName: "btnRemovePlant"
        onClicked: parent.removeButtonClicked()
    }

    /* The Slot Hole Component */
    Component{
        id: slotHole
        RoundMouseArea {
            property string slotPane : ""
            property int slotNum : -1
            property var slotData: plantSlots[slotPane][slotNum]
            // property var slotData: slots[slotPane][slotNum]
            status: slotData.status
            label: slotNum + 1
            onClicked: {
                if(status == -1) return

                selectedP = slotPane
                selectedN = slotNum
                popup.slotData = slotData

                popup.open()
            }
        }
    }

    

    /* Popup */
    Popup {
        id: popup
        x: 80
        y: 60
        width: 640
        height: 360
        modal: true
        focus: true
        dim: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside	

        property var slotData: plantSlots[selectedP][selectedN]
        // property var slotData: slots[selectedP][selectedN]
        property var plantData : slotData.plant
        property string plantName: plantData ? plantData.name : "NO plant"
        property string description: plantData ? plantData.description : "NO plant"
        property string imgSource: plantData ? "images/plant/" + plantData.img : "images/placeholder.png"
        property var datePlanted: slotData.datePlanted ? slotData.datePlanted : "NO plant"
        property var dateReady: slotData.dateReady ? slotData.dateReady : "NO plant"
        property var daysPassed: slotData.daysPassed
        enter: null
        exit: null
        // onClosed: {
        //     days = 0
        //     plantName = ""
        //     description = ""
        //     datePlanted = ""
        //     dateReady = ""
        // }

        Rectangle{ // X Button
            width:30
            height:30
            radius: 10
            color:  maClose.pressed ? "darkgrey" : "grey"
            anchors.top: parent.top
            anchors.right: parent.right
            
            MouseArea{
                id: maClose
                anchors.fill: parent

                onClicked: {
                    popup.close()
                }
            }

            Text{
                id: txtX
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 17; font.bold: true
                color: maClose.pressed ? "red" : "white"
                text: "\u00D7"
            }
        }

        Item {
            x: 20
            y: 10
            height: 20
            Text {
                id: plantNameTxt1
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 18; font.bold: true
                text:popup.plantName + " (" + selectedP + selectedN + ")"
            }
        }

        Image{
            id: img
            x: 20
            y: 50
            width: 100
            height: 100
            source: popup.imgSource
        }

        Grid {
            id: grid1
            x: 250
            y: 10
            width: 300
            height: 180
            rows: 3; columns: 2; spacing: 10

            Item {
                width: 220
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Date Planted: "
                    font.pointSize: 14; font.bold: true
                }
            }

            Item {
                width: 100
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: popup.datePlanted.toLocaleDateString(Qt.locale(), "yyyy-MMM-dd")
                    font.pointSize: 12; font.bold: false
                }
            }

            Item {
                width: 220
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Planted Duration: "
                    font.pointSize: 14; font.bold: true
                }
            }

            Item {
                width: 100
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: popup.daysPassed + " Days"
                    font.pointSize: 12; font.bold: false
                }
            }

            Item {
                width: 220
                height: 40
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Ready Date: "
                    font.pointSize: 14; font.bold: true
                }
            }

            Item {
                width: 100
                height: 40
                Text {
                    id: txtReady
                    anchors.verticalCenter: parent.verticalCenter
                    text: popup.dateReady.toLocaleDateString(Qt.locale(), "yyyy-MMM-dd")
                    font.pointSize: 12; font.bold: false
                }
            }
        }

        Item{
            x: 20
            y: 180
            width: 100
            height: 20
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Plant Description: "
                font.pointSize: 16; font.bold: true
            }
        }

        Item{
            x: 20
            y: 210
            width: 600
            height: 130
            Text {
                id: txtDescription
                text: popup.description
                font.pointSize: 10; font.bold: false
            }
        }

        Button{
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 130
            anchors.rightMargin: 15
            text:"Change date planted"
            onClicked: popup2.open()
        }

        Button{
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 15
            anchors.rightMargin: 15
            text:"Remove this plant"
            onClicked: {
                popupConfirmRemove.open()
                // popup.close()
            }
        
        }
        Popup{
            id: popupConfirmRemove
            width: 210
            height: 110
            x : parent.width/2 - width/2
            y : parent.height/2 - height/2
            enter: null
            exit: null
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                spacing:10
                Button{
                    width: 85
                    text: "OK"
                    onClicked: {
                        popupConfirmRemove.close()
                        popup.close()
                        plantSlots[selectedP][selectedN].removePlant()
                    }
                }
                Button{
                    width: 85
                    text:"Cancel"
                    onClicked: popupConfirmRemove.close()
                }
            }
        }
        Popup {
            id: popup2
            x: parent.width/2
            y: 0
            width: parent.width/2 
            height: parent.height/2
            modal: true
            focus: true
            padding : 3
            leftPadding : 10
            dim: false
            enter: null
            exit: null

            property var datePlanted: { return new Date(popup.datePlanted)}

            Row{
                spacing: 10
                
                Column{
                    width: 75
                    
                    Button{
                        width: 75
                        height: 35
                        text: "\u25B2"
                        onClicked: {
                            var d = popup2.datePlanted 
                            d.setFullYear(d.getFullYear() + 1)
                            editDatePlanted(selectedP, selectedN, d)
                        }
                    }

                    Text{
                        id: txtSetYear
                        width: parent.width
                        text: popup2.datePlanted.getFullYear()
                        font.pointSize: 16
                        horizontalAlignment : Text.AlignHCenter
                    }

                    Button{
                        width: 75
                        height: 35
                        text: "\u25BC"
                        onClicked: {
                            var d = popup2.datePlanted 
                            d.setFullYear(d.getFullYear() - 1)
                            editDatePlanted(selectedP, selectedN, d)
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
                            var d = popup2.datePlanted 
                            d.setMonth((d.getMonth() + 1) % 12)
                            editDatePlanted(selectedP, selectedN, d)
                        }
                    }

                    Text{
                        id: txtSetMonth
                        width: parent.width
                        text: {
                            var dateString = popup2.datePlanted.toLocaleDateString(Qt.locale(), "MMM")
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
                            var d = popup2.datePlanted 
                            var m = d.getMonth()
                            d.setMonth(m == 0 ? 11 : (m - 1))
                            editDatePlanted(selectedP, selectedN, d)
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
                            var d = popup2.datePlanted 
                            d.setDate(d.getDate() + 1)
                            editDatePlanted(selectedP, selectedN, d)
                        }
                    }

                    Text{
                        id: txtSetDate
                        width: parent.width
                        text: popup2.datePlanted.getDate()
                        font.pointSize: 16
                        horizontalAlignment : Text.AlignHCenter
                    }

                    Button{
                        width: 75
                        height: 35
                        text: "\u25BC"
                        onClicked: {
                            var d = popup2.datePlanted 
                            d.setDate(d.getDate() - 1)
                            editDatePlanted(selectedP, selectedN, d)
                        }
                    }
                }
            }

            Button{
                id: btnDateOk
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                text: "ok"
                onClicked: {
                    popup2.close()
                }
            }
            Button{
                id: btnDateToday
                anchors.right: btnDateOk.left
                anchors.bottom: parent.bottom
                text: "today"
                onClicked: {
                popup.datePlanted = new Date()
                }
            }
        }/* end Popup2 */
    }/* end Popup */
}


      // Item{
        //     x: 300
        //     y: 140
        //     width:280
        //     height:300
        //     ColumnLayout {
        //         DayOfWeekRow {
        //             locale: grid.locale
        //             Layout.fillWidth: true
        //         }

        //         MonthGrid {
        //             id: grid
        //             month: Calendar.December
        //             year: 2017
        //             title: "Dec 2017"
        //             locale: Qt.locale("en_US")
        //             Layout.fillWidth: true
        //         }

        //         MonthGrid {
        //             // id: grid
        //             month: (grid.month + 1) % 11
        //             year: month == 0 ? grid.year + 1 : grid.year
        //             locale: Qt.locale("en_US")
        //             Layout.fillWidth: true
        //         }
        //     }
           
        // }