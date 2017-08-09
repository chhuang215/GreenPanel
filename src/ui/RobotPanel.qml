import QtQuick 2.3
import QtQuick.Controls 1.2

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
    
    Canvas {
        id: socket1
        x: 280
        y: 160
        width: 100; height: 100
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();

            var centreX = width / 2;
            var centreY = height / 2;

            ctx.beginPath();
            ctx.fillStyle = "white";
            ctx.moveTo(centreX, centreY);
            ctx.arc(centreX, centreY, width / 4, 0, Math.PI * 0.5, false);
            ctx.lineTo(centreX, centreY);
            ctx.fill();

            ctx.beginPath();
            ctx.fillStyle = "white";
            ctx.moveTo(centreX, centreY);
            ctx.arc(centreX, centreY, width / 4, Math.PI * 0.5, Math.PI * 2, false);
            ctx.lineTo(centreX, centreY);
            ctx.fill();
        }
    }
    
    /*RoundButton {
        x: 300
        y: 300
        text: "1" // Unicode Character 'CHECK MARK'
        onClicked: textArea.readOnly = true
    }*/

}