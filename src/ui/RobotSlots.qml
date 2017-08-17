import QtQuick 2.7
import QtQuick.Controls 2.0

Item{

    property var currLeft: 'A'
    property var currRight: 'B'

  

    Rectangle{
        width:parent.width
        height:parent.height
        color: "red"
        border.width : 5
        border.color : "black"
    }

    Button {
        x: 400
        y: 25
        text: ">"
        objectName: "btnForward"
        onClicked : {
            var a = (currLeft.charCodeAt(0) - 65 + 2) % 8
            currLeft = String.fromCharCode(a + 65)
            currRight = String.fromCharCode(((a + 1) % 8 ) + 65)
        }
    }

    Button {
        x: 300
        y: 25
        text: "<"
        objectName: "btnBackward"
        onClicked : {
            var a = currLeft.charCodeAt(0) - 65 - 2
            if (a < 0) a = 8 + a 
            currLeft = String.fromCharCode(a + 65)
            currRight = String.fromCharCode(((a + 1) % 8 ) + 65)
        }
    }

    Text {
        // id: labelA
        x: 300
        y: 80
        text: currLeft
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
        // id: labelB
        x: 440
        y: 80
        text: currRight
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
            ctx.moveTo(0,50)
            ctx.lineTo(150,50)
            ctx.lineTo(100,300)
            ctx.lineTo(0,300)
            ctx.closePath()
            ctx.fill()
            ctx.stroke()
        }
    }

  
}