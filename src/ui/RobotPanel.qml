import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Qt.labs.calendar 1.0
Item{
    id: "panelRobot"
    visible: false
    signal addButtonClicked
    signal removeButtonClicked
    property var slots : {}
    property alias currLeft : robotSlots.currLeft
    property alias currRight : robotSlots.currRight

    Button {
        x: 700
        y: 100
        text: "Add Plant"
        objectName: "btnAddPlant"
        onClicked: parent.addButtonClicked()
    }

    Button {
        x: 700
        y: 150
        text: "Remove Plant"
        objectName: "btnRemovePlant"
        onClicked: parent.removeButtonClicked()
    }

    // Button {
    //     x: 700
    //     y: 200
    //     text: "SEE JSON"
    //     onClicked:{
    //         console.log(JSON.stringify(slots,  null, '\t') )
    //     }
    // }

    // The UI slot base
    RobotSlots{
        id: robotSlots
        anchors.fill: parent
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
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside	

        property int days: 0
        property var slotPos: {}
        property var plantName: ""
        property var description: ""
        property var imgSource: "images/placeholder.png"
        property var datePlanted: "dd/mm/yy"
        property var dateReady: "dd/mm/yy"
        
        onClosed: {
            days = 0
            plantName = ""
            description = ""
            datePlanted = "dd/mm/yy"
            dateReady = "dd/mm/yy"
            slotPos: {}
        }

        Rectangle{
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
                text:popup.plantName + " @" + popup.slotPos
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
                    text: popup.datePlanted
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
                    text: popup.days + " Days"
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
                    text: popup.dateReady
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
            anchors.bottomMargin: 15
            anchors.rightMargin: 15
            text:"Remove this plant"

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

    }/* end Popup */

     /* The Slot Hole Component */
    Component{
        id: slotHole
        RoundMouseArea {
            property var slotPane : {}
            status: slots[slotPane][slotNum].status

            onClicked: {
                var s = slots[slotPane][slotNum]
                var plant = s.plant
                popup.slotPos = [slotPane, slotNum]
                if(plant) {
                    popup.plantName = plant.name
                    popup.datePlanted = s.date_planted
                    popup.dateReady = s.date_ready
                    popup.days = s.days
                    popup.description = "Description for " + plant.name
                }
                popup.open()
            }
        }
    }
     /* SLOTS on the LEFT */
    Repeater {
        model: slots[currLeft].length
        Loader { 
           
            sourceComponent: slotHole
            
            onLoaded:{
                item.x = robotSlots.capsuleAX + robotSlots.capsuleRadius + item.width/2 - 5 - (5 * index)
                item.y = robotSlots.capsuleY  + (slots[currLeft].length == 3 ?  + 50 : 80) + 80 * index
                item.slotNum = index
                item.slotPane = Qt.binding(function() { return currLeft} )
            }
        }
    }
    /* end SLOTS on the LEFT */

    /* SLOTS on the RIGHT */
    Repeater {
        model: slots[currRight].length
        Loader { 
           
            sourceComponent: slotHole
            
            onLoaded:{
                item.x = robotSlots.capsuleBX + robotSlots.capsuleRadius + item.width/2 - 5 + (5 * index)
                item.y = robotSlots.capsuleY  + (slots[currRight].length == 3 ?  + 50 : 80) + 80 * index
                item.slotNum = index
                item.slotPane = Qt.binding(function() { return currRight} )
            }
        }
    }
    /* end SLOTS on the RIGHT */

}