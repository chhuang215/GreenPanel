import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelRobot"
    objectName: "panelRobot"
    visible: false
    Column{
        Button {
            text: "<-Back"
            objectName: "btnBack"
        }
    }

    Button {
        x: 700
        y: 100
        text: "Add Plant"
        objectName: "btnAddPlant"
    }

    Button {
        x: 700
        y: 150
        text: "Remove Plant"
        objectName: "btnRemovePlant"
    }

    Button {
        x: 400
        y: 25
        text: ">"
        objectName: "btnForward"
    }

    Button {
        x: 300
        y: 25
        text: "<"
        objectName: "btnBackward"
    }

    Text {
        id: labelA
        x: 300
        y: 80
        text: "A"
        font.family: "Ariel"
        font.bold: true
        font.pointSize: 36
    }

    Canvas {
        id: panelA
        x: 245
        y: 100
        // canvas size
        width: 200; height: 400
        // handler to override for drawing
        onPaint: {
            // get context to draw with
            var ctx = getContext("2d")
            // setup the stroke
            ctx.lineWidth = 4
            ctx.strokeStyle = "green"
            // setup the fill
            ctx.fillStyle = "limegreen"
            // begin a new path to draw
            ctx.beginPath()
            // top-left start point
            ctx.moveTo(0,50)
            // upper line
            ctx.lineTo(150,50)
            // right line
            ctx.lineTo(150,300)
            // bottom line
            ctx.lineTo(50,300)
            // left line through path closing
            ctx.closePath()
            // fill using fill style
            ctx.fill()
            // stroke using line width and stroke style
            ctx.stroke()
        }
    }

    Text {
        id: labelB
        x: 440
        y: 80
        text: "B"
        font.family: "Ariel"
        font.bold: true
        font.pointSize: 36
    }

    Canvas {
        id: panelB
        x: 390
        y: 100
        width: 200; height: 400
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = 4
            ctx.strokeStyle = "green"
            ctx.fillStyle = "limegreen"
            ctx.beginPath()
            ctx.moveTo(3,50)
            ctx.lineTo(153,50)
            ctx.lineTo(103,300)
            ctx.lineTo(3,300)
            ctx.closePath()
            ctx.fill()
            ctx.stroke()
        }
    }

    Popup {
        id: popup
        x: 100
        y: 100
        width: 200
        height: 300
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    }

    RoundMouseArea {
        id: roundMouseArea
        x: 305
        y: 180
        width: 50
        height: 50

        onClicked: popup.open()

        Rectangle {
            color: roundMouseArea.pressed ? "red" : (roundMouseArea.containsMouse ? "blue" : "white")
            border.color: "black"
            border.width: 1
            radius: width / 2
            anchors.fill: parent
            Text {
                anchors.centerIn: parent
                text: "1"
                font.pointSize: 12
            }
        }
    }

    RoundMouseArea2 {
        id: roundMouseArea2
        x: 305
        y: 250
        width: 50
        height: 50

        onClicked: print("2 is clicked")

        Rectangle {
            color: roundMouseArea2.pressed ? "red" : (roundMouseArea2.containsMouse ? "blue" : "white")
            border.color: "black"
            border.width: 1
            radius: width / 2
            anchors.fill: parent
            Text {
                anchors.centerIn: parent
                text: "2"
                font.pointSize: 12
            }
        }
    }

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