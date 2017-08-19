import QtQuick 2.7
import QtQuick.Controls 2.0

Item{

    property var currLeft: 'A'
    property var currRight: 'B'

    property alias leftPanel: panelA
    property alias rightPanel: panelB

    property int slotPanelWidth: 155
    property int slotPanelHeight: 305
    // Rectangle{
    //     width:parent.width
    //     height:parent.height
    //     color: "red"
    //     border.width : 5
    //     border.color : "black"
    // }

    Button {
        anchors.left:panelB.left
        anchors.leftMargin:20
        // x: 400
        y: 25
        text: ">"
        onClicked : {
            var a = (currLeft.charCodeAt(0) - 65 + 2) % 8
            currLeft = String.fromCharCode(a + 65)
            currRight = String.fromCharCode(((a + 1) % 8 ) + 65)
        }
    }

    Button {
        anchors.right:panelA.right
        anchors.rightMargin:20
        // x: 300
        y: 25
        text: "<"
        onClicked : {
            var a = currLeft.charCodeAt(0) - 65 - 2
            if (a < 0) a = 8 + a 
            currLeft = String.fromCharCode(a + 65)
            currRight = String.fromCharCode(((a + 1) % 8 ) + 65)
        }
    }

    Text {
        // id: labelA
        anchors.bottom: panelA.top
        anchors.horizontalCenter: panelA.horizontalCenter    
        text: currLeft
        font.family: "Ariel"
        font.bold: true
        font.pointSize: 36
    }

    Canvas {
        id: panelA
        // anchors.verticalCenter:parent.verticalCenter
        x: 243
        y: 130
        // canvas size
        width: slotPanelWidth; height: slotPanelHeight
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
            ctx.moveTo(ctx.lineWidth, ctx.lineWidth)
            // upper line
            ctx.lineTo(width, ctx.lineWidth)
            // right line
            ctx.lineTo(width, height - ctx.lineWidth)
            // bottom line
            ctx.lineTo(ctx.lineWidth + 50, height - ctx.lineWidth)
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
        anchors.bottom: panelB.top
        anchors.horizontalCenter: panelB.horizontalCenter    

        text: currRight
        font.family: "Ariel"
        font.bold: true
        font.pointSize: 36
    }

    Canvas {
        id: panelB
        anchors.left : panelA.right
   
        // anchors.verticalCenter:panelA.verticalCenter
        x: panelA.x + slotPanelWidth
        y: panelA.y
        width: slotPanelWidth; height: slotPanelHeight
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = 4
            ctx.strokeStyle = "green"
            ctx.fillStyle = "limegreen"

            ctx.beginPath()
            ctx.moveTo(width - ctx.lineWidth, ctx.lineWidth)
            ctx.lineTo(0, ctx.lineWidth)
            ctx.lineTo(0, height - ctx.lineWidth)
            ctx.lineTo(width - 50, height - ctx.lineWidth)
            ctx.closePath()
            ctx.fill()
            ctx.stroke()
        }
    }  
}