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

    /* SLOTS on the LEFT */
    RoundMouseArea {
        slotNum: 0
        status: slots[currLeft][slotNum]["status"]

        x: 305
        y: robotSlots.capsuleY + 50

        // x: 305
        // y: 180
        
        onClicked: {
            var s = slots[currLeft][slotNum]
            var plant = s.plant
            popup.slotPos = [currLeft, slotNum]
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

    RoundMouseArea {
        slotNum: 1
        status: slots[currLeft][slotNum]["status"]

        x: 305
        y: robotSlots.capsuleY + 120

        onClicked: {
            var s = slots[currLeft][slotNum]
            var plant = s.plant
            popup.slotPos = [currLeft, slotNum]
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

    RoundMouseArea {
        slotNum: 2
        status: slots[currLeft][slotNum]["status"]

        x: 305
        y: robotSlots.capsuleY + 190

        onClicked: {
            var s = slots[currLeft][slotNum]
            var plant = s.plant
            popup.slotPos = [currLeft, slotNum]
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
    /* end SLOTS on the LEFT */

    /* SLOTS on the RIGHT */
    RoundMouseArea {
        slotNum: 0
        status: slots[currRight][slotNum]["status"]

        x: 430
        y: robotSlots.capsuleY + 80

        onClicked: {
            var s = slots[currRight][slotNum]
            var plant = s.plant
            popup.slotPos = [currRight, slotNum]
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

    RoundMouseArea {
        slotNum: 1
        status: slots[currRight][slotNum]["status"]

        x: 430
        y: robotSlots.capsuleY + 150

        onClicked: {
            var s = slots[currRight][slotNum]
            var plant = s.plant
            popup.slotPos = [currRight, slotNum]
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
    /* end SLOTS on the RIGHT */

    
    // Text {
    //     // id: labelA
    //     x: 300
    //     y: 80
    //     text: currLeft
    //     font.family: "Ariel"
    //     font.bold: true
    //     font.pointSize: 36
    // }

    // Canvas {
    //     id: panelA
    //     x: 245
    //     y: 100
    //     // canvas size
    //     width: 200; height: 400
    //     // handler to override for drawing
    //     onPaint: {
    //         // get context to draw with
    //         var ctx = getContext("2d")
    //         // setup the stroke
    //         ctx.lineWidth = 4
    //         ctx.strokeStyle = "green"
    //         // setup the fill
    //         ctx.fillStyle = "limegreen"
    //         // begin a new path to draw
    //         ctx.beginPath()
    //         // top-left start point
    //         ctx.moveTo(0,50)
    //         // upper line
    //         ctx.lineTo(150,50)
    //         // right line
    //         ctx.lineTo(150,300)
    //         // bottom line
    //         ctx.lineTo(50,300)
    //         // left line through path closing
    //         ctx.closePath()
    //         // fill using fill style
    //         ctx.fill()
    //         // stroke using line width and stroke style
    //         ctx.stroke()
    //     }
    // }

    // Text {
    //     // id: labelB
    //     x: 440
    //     y: 80
    //     text: currRight
    //     font.family: "Ariel"
    //     font.bold: true
    //     font.pointSize: 36
    // }

    // Canvas {
    //     id: panelB
    //     x: 390
    //     y: 100
    //     width: 200; height: 400
    //     onPaint: {
    //         var ctx = getContext("2d")
    //         ctx.lineWidth = 4
    //         ctx.strokeStyle = "green"
    //         ctx.fillStyle = "limegreen"
    //         ctx.beginPath()
    //         ctx.moveTo(3,50)
    //         ctx.lineTo(153,50)
    //         ctx.lineTo(103,300)
    //         ctx.lineTo(3,300)
    //         ctx.closePath()
    //         ctx.fill()
    //         ctx.stroke()
    //     }
    // }


      // Popup {
    //     id: popup2
    //     x: 80
    //     y: 60
    //     width: 640
    //     height: 360
    //     modal: true
    //     focus: true
    //     closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    //     Rectangle {
    //         x: 20
    //         y: 10
    //         height: 20
    //         Text {
    //             id: plantNameTxt2
    //             anchors.verticalCenter: parent.verticalCenter
    //             text: "Plant A2"
    //             font.pointSize: 18; font.bold: true
    //         }
    //     }

    //     Image{
    //         x: 20
    //         y: 50
    //         width: 100
    //         height: 100
    //         source: "images/placeholder.png"
    //     }

    //     Grid {
    //         id: grid2
    //         x: 250
    //         y: 10
    //         width: 300
    //         height: 180
    //         rows: 3; columns: 2; spacing: 10

    //         Rectangle {
    //             width: 220
    //             height: 40
    //             Text {
    //                 anchors.verticalCenter: parent.verticalCenter
    //                 text: "Date Planted: "
    //                 font.pointSize: 14; font.bold: true
    //             }
    //         }

    //         Rectangle {
    //             width: 100
    //             height: 40
    //             Text {
    //                 anchors.verticalCenter: parent.verticalCenter
    //                 text: "dd/mm/yy"
    //                 font.pointSize: 12; font.bold: false
    //             }
    //         }

    //         Rectangle {
    //             width: 220
    //             height: 40
    //             Text {
    //                 anchors.verticalCenter: parent.verticalCenter
    //                 text: "Planted Duration: "
    //                 font.pointSize: 14; font.bold: true
    //             }
    //         }

    //         Rectangle {
    //             width: 100
    //             height: 40
    //             Text {
    //                 anchors.verticalCenter: parent.verticalCenter
    //                 text: "00Days"
    //                 font.pointSize: 12; font.bold: false
    //             }
    //         }

    //         Rectangle {
    //             width: 220
    //             height: 40
    //             Text {
    //                 anchors.verticalCenter: parent.verticalCenter
    //                 text: "Ready Date: "
    //                 font.pointSize: 14; font.bold: true
    //             }
    //         }

    //         Rectangle {
    //             width: 100
    //             height: 40
    //             Text {
    //                 anchors.verticalCenter: parent.verticalCenter
    //                 text: "dd/mm/yy"
    //                 font.pointSize: 12; font.bold: false
    //             }
    //         }
    //     }

    //     Rectangle{
    //         x: 20
    //         y: 180
    //         width: 100
    //         height: 20
    //         Text {
    //             anchors.verticalCenter: parent.verticalCenter
    //             text: "Plant Description: "
    //             font.pointSize: 16; font.bold: true
    //         }
    //     }

    //     Rectangle{
    //         x: 20
    //         y: 210
    //         width: 600
    //         height: 130
    //         Text {
    //             text: "Empty Text"
    //             font.pointSize: 10; font.bold: false
    //         }
    //     }

    // }


    // RoundMouseArea2 {
    //     id: roundMouseArea2
    //     x: 305
    //     y: 250
    //     width: 50
    //     height: 50

    //     onClicked: {
    //         popup1.open()
    //     }

    //     Rectangle {
    //         color: "white"
    //         border.color: "black"
    //         border.width: 1
    //         radius: width / 2
    //         anchors.fill: parent
    //         Text {
    //             anchors.centerIn: parent
    //             text: "2"
    //             font.pointSize: 12
    //         }
    //     }
    // }

    /*Rectangle {
        x: 280
        y: 160
        width: 50
        height: 50
        color: "white"
        border.color: "black"
        border.width: 1
        radius: width*0.5
        Text {
            x: 500
            y: 500
            text: "1"
        }
    }*/

}