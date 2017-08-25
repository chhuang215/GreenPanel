import QtQuick 2.7
import QtQuick.Controls 2.0

Item{

    property var currLeft: 'A'
    property var currRight: 'B'
    property var currLeftLeft: 'A' == currLeft ? 'H' : String.fromCharCode(currLeft.charCodeAt(0) - 1)

    property var currRightRight: 'H' == currRight ? 'A' : String.fromCharCode(currRight.charCodeAt(0) + 1)
    
    property int capsuleRadius: 50
    property int capsuleHeight: 160

    property int capsuleRadius2: 25
    property int capsuleHeight2: 160

    property int capsulesCenter: capsules.width / 2

    property int capsuleXOffset : 57
    property int capsuleXDisplacement: 10
    property int capsuleY : 90
    property int capsuleXOffset2: 155
    property int capsuleXDisplacement2: 40
    property int capsuleY2: 85
    property int capsuleAX: capsulesCenter - capsuleXOffset
    property int capsuleBX: capsulesCenter + capsuleXOffset
    property int capsuleCX: capsulesCenter + capsuleXOffset2
    property int capsuleHX: capsulesCenter - capsuleXOffset2

    Button {
        anchors.left: capsules.horizontalCenter
        anchors.leftMargin:20
        anchors.bottom: capsules.top
        anchors.bottomMargin: -15
        width: 75; height: 70
        
        text: ">"
       
        onClicked : {
            var a = (currLeft.charCodeAt(0) - 65 + 2) % 8
            currLeft = String.fromCharCode(a + 65)
            currRight = String.fromCharCode(((a + 1) % 8 ) + 65)
        }
    }

    Button {
        anchors.right: capsules.horizontalCenter
        anchors.rightMargin:20
        anchors.bottom: capsules.top
        anchors.bottomMargin: -15
        width: 75; height: 70
        y: 25
        text: "<"
        onClicked : {
            var a = currLeft.charCodeAt(0) - 65 - 2
            if (a < 0) a += 8
            currLeft = String.fromCharCode(a + 65)
            currRight = String.fromCharCode(((a + 1) % 8 ) + 65)
        }
    }

    

    Text {
        anchors.top: capsules.bottom
        anchors.right: capsules.horizontalCenter
        anchors.rightMargin: 57

        text: currLeft
        font.bold: true
        font.pointSize: 36
    }

    
    Text {
        anchors.top: capsules.bottom
        anchors.left: capsules.horizontalCenter
        anchors.leftMargin: 57

        text: currRight
        font.bold: true
        font.pointSize: 36
    }


    Text {
        anchors.top: capsules.bottom
        anchors.topMargin: - 30
        anchors.right: capsules.right
        anchors.rightMargin: capsulesCenter - capsuleXOffset2 - capsuleXDisplacement2 - capsuleRadius2 - 10

        text: currRightRight
        font.bold: true
        font.pointSize: 26
    }

     Text {
        anchors.top: capsules.bottom
        anchors.topMargin: - 30
        anchors.left: capsules.left
        anchors.leftMargin: capsulesCenter - capsuleXOffset2 - capsuleXDisplacement2 - capsuleRadius2 - 10

        text: currLeftLeft
        font.bold: true
        font.pointSize: 26
    }

    Canvas{
        id: capsules

        width: 580
        height: 325
        
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 85
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = 4
            ctx.strokeStyle = "green"
            ctx.fillStyle = "lightgreen"
            // ctx.resetTransform()
            
            // frame
            ctx.beginPath();
            ctx.arc(capsulesCenter, -480 - anchors.topMargin, 600, 0.4 * Math.PI, 0.6 * Math.PI)
            ctx.arc(capsulesCenter, -500 - anchors.topMargin, 900, 0.6 * Math.PI, 0.4 * Math.PI, true);
            ctx.closePath()
            ctx.stroke();

            //A
            ctx.beginPath()
            ctx.arc(capsuleAX, capsuleY, capsuleRadius, Math.PI, 0)
            ctx.arc(capsuleAX - capsuleXDisplacement, capsuleY + capsuleHeight, capsuleRadius, 0, Math.PI)
            ctx.closePath()
            ctx.fill()
            ctx.stroke()
            
            //B
            ctx.beginPath()
            ctx.arc(capsuleBX, capsuleY, capsuleRadius, Math.PI, 0)
            ctx.arc(capsuleBX + capsuleXDisplacement, capsuleY + capsuleHeight, capsuleRadius, 0, Math.PI)
            ctx.closePath()
            ctx.fill()
            ctx.stroke()

            //H
            ctx.beginPath()
            ctx.arc(capsuleHX ,capsuleY2, capsuleRadius2, 7* Math.PI/6 ,  0)
            ctx.arc(capsuleHX - capsuleXDisplacement2, capsuleY2 + capsuleHeight2, capsuleRadius2, Math.PI / 6 , Math.PI )
            ctx.closePath()
            ctx.fill()
            ctx.stroke()
            
            //C
            ctx.beginPath()
            ctx.arc(capsuleCX , capsuleY2, capsuleRadius2, Math.PI, 11 * Math.PI / 6)
            ctx.arc(capsuleCX + capsuleXDisplacement2 , capsuleY2 + capsuleHeight2, capsuleRadius2, 0, 5* Math.PI/6)
            ctx.closePath()
            ctx.fill()
            ctx.stroke()

        }
        // Rectangle{ // the border to see the canvas position/size
        //     anchors.fill: parent
        //     border.width: 2
        //     color: "transparent"
        // }
    }

    // property alias leftPanel: panelA
    // property alias rightPanel: panelB

    // property int slotPanelWidth: 155
    // property int slotPanelHeight: 305
    
    // property int aX: 98
    // property int aY: 75
    // property int aDisplacement: 10

    // property int bX: 58
    // property int bY: 75
    // property int bDisplacement: 10

    // property int hX: 170
    // property int hY: 50

    // property int cX: 125
    // property int cY: 115

    // Canvas {
    //     id: frame
    //     x: 0
    //     y: 0
    //     width: 800
    //     height: 480
    //     onPaint: {
    //         var ctx = getContext("2d")
    //         ctx.lineWidth = 6
    //         ctx.strokeStyle = "red"
    //         ctx.fillStyle = "light green"
            
    //         // One stroke
    //         ctx.beginPath();
    //         ctx.arc(400, -480, 600, 0.4 * Math.PI, 0.6 * Math.PI)
    //         ctx.arc(400, -500, 900, 0.6 * Math.PI, 0.4 * Math.PI, true);
    //         ctx.closePath()
    //         ctx.stroke();


            // OLD
            // ctx.beginPath();
            // ctx.arc(400, -480, 600, 0.4 * Math.PI, 0.6 * Math.PI);
            // ctx.stroke();
           
            // ctx.beginPath();
            // ctx.moveTo(215, 90);
            // ctx.lineTo(120, 358)
            // ctx.stroke();

            //  ctx.beginPath();
            // ctx.arc(400, -500, 900, 0.4 * Math.PI, 0.6 * Math.PI);
            // ctx.stroke();

            // ctx.beginPath();
            // ctx.moveTo(585, 90);
            // ctx.lineTo(680, 358)
            // ctx.stroke();            

            //ctx.bezierCurveTo(180,140,620,140,620,100);        
    //     }
    // }

    // Text {
    //     // id: labelA
    //     anchors.top: panelA.bottom
    //     anchors.right: panelA.right
    //     anchors.rightMargin: slotPanelWidth / 2 - 18
    //     text: currLeft
    //     font.family: "Ariel"
    //     font.bold: true
    //     font.pointSize: 36
    // }

    // Canvas {
        // id: panelA
        // anchors.verticalCenter:parent.verticalCenter
        // x: 243
        // y: 100
        // canvas size
        // width: slotPanelWidth; height: slotPanelHeight
        // handler to override for drawing
        // onPaint: {
        //     // get context to draw with
        //     var ctx = getContext("2d")
        //     // setup the stroke
        //     ctx.lineWidth = 4
        //     ctx.strokeStyle = "green"
        //     // setup the fill
        //     ctx.fillStyle = "light green"
            
        //     // capsule drawing
        //     ctx.beginPath()
        //     ctx.moveTo(aX - capsuleRadius, aY)
        //     ctx.arc(aX, aY, capsuleRadius, Math.PI, 0)
        //     // ctx.lineTo(aX + capsuleRadius - aDisplacement, aY + capsuleHeight)
        //     ctx.arc(aX - aDisplacement, aY + capsuleHeight, capsuleRadius, 0, Math.PI)
        //     // ctx.lineTo(aX - capsuleRadius, aY)
        //     ctx.closePath()
        //     ctx.fill()
        //     ctx.stroke()
            
        //     // begin a new path to draw
        //     //ctx.beginPath()
        //     // top-left start point
        //     //ctx.moveTo(50, ctx.lineWidth)
        //     // upper line
        //     //ctx.lineTo(width, ctx.lineWidth)
        //     // right line
        //     //ctx.lineTo(width, height - ctx.lineWidth)
        //     // bottom line
        //     //ctx.lineTo(0, height - ctx.lineWidth)
        //     // left line through path closing
        //     //ctx.closePath()
        //     // fill using fill style
        //     //ctx.fill()
        //     // stroke using line width and stroke style
        //     //ctx.stroke()
        // } 
    // }

    // Text {
    //     anchors.top: panelB.bottom
    //     anchors.left: panelB.left
    //     anchors.leftMargin: slotPanelWidth / 2 - 18

    //     text: currRight
    //     font.family: "Ariel"
    //     font.bold: true
    //     font.pointSize: 36
    // }

    // Canvas {
        // id: panelB
        // anchors.verticalCenter:panelA.verticalCenter
        // x: panelA.x + slotPanelWidth
        // y: panelA.y
        // width: slotPanelWidth; height: slotPanelHeight
        // onPaint: {
        //     var ctx = getContext("2d")
        //     ctx.lineWidth = 4
        //     ctx.strokeStyle = "green"
        //     ctx.fillStyle = "light green"

        //     // capsule drawing
        //     ctx.beginPath()
        //     ctx.moveTo(bX - capsuleRadius, bY)
        //     ctx.arc(bX, bY, capsuleRadius, Math.PI, 0)
        //     // ctx.lineTo(bX + capsuleRadius + bDisplacement, bY + capsuleHeight)
        //     ctx.arc(bX + bDisplacement, bY + capsuleHeight, capsuleRadius, 0, Math.PI)
        //     // ctx.lineTo(bX - capsuleRadius, bY)
        //     ctx.closePath()
        //     ctx.fill()
        //     ctx.stroke()
            
        //     //ctx.beginPath()
        //     //ctx.moveTo(width - 50 - ctx.lineWidth, ctx.lineWidth)
        //     //ctx.lineTo(0, ctx.lineWidth)
        //     //ctx.lineTo(0, height - ctx.lineWidth)
        //     //ctx.lineTo(width - ctx.lineWidth, height - ctx.lineWidth)
        //     //ctx.closePath()
        //     //ctx.fill()
        //     //ctx.stroke()
        // }
    // }  

    // Text {
    //     anchors.top: panelH.bottom
    //     anchors.topMargin: - 15
    //     anchors.left: panelH.left
    //     anchors.leftMargin: slotPanelWidth - 75

    //     text: currLeftLeft
    //     font.bold: true
    //     font.pointSize: 26
    // }

    // Canvas {
    //     id: panelH
    //     // anchors.verticalCenter:panelA.verticalCenter
    //     x: panelA.x - slotPanelWidth
    //     y: panelA.y - 15
    //     width: slotPanelWidth * 2; height: slotPanelHeight + 15
    //     onPaint: {
    //         var ctx = getContext("2d")
    //         ctx.lineWidth = 4
    //         ctx.strokeStyle = "green"
    //         ctx.fillStyle = "light green"

    //         // capsule drawing
    //         ctx.rotate(13*Math.PI/180)
    //         ctx.beginPath()
    //         ctx.moveTo(hX - capsuleRadius2, hY)
    //         ctx.arc(hX, hY, capsuleRadius2, Math.PI, 0)
    //         // ctx.lineTo(hX + capsuleRadius2, hY + capsuleHeight2)
    //         ctx.arc(hX, hY + capsuleHeight2, capsuleRadius2, 0, Math.PI)
    //         // ctx.lineTo(hX - capsuleRadius2, hY)
    //         ctx.closePath()
    //         ctx.fill()
    //         ctx.stroke()

    //         //ctx.beginPath()
    //         //ctx.moveTo(width/2, ctx.lineWidth )
    //         //ctx.lineTo(width/2 + 50, ctx.lineWidth + 15)
    //         //ctx.lineTo(width/2, height - ctx.lineWidth)
    //         //ctx.lineTo(ctx.lineWidth + 40, height - ctx.lineWidth - 30)
    //         //ctx.closePath()
    //         //ctx.fill()
    //         //ctx.stroke()
    //     }
    // }  

    // Text {
    //     anchors.top: panelC.bottom
    //     anchors.topMargin: - 15
    //     anchors.right: panelC.right
    //     anchors.rightMargin: slotPanelWidth - 75

    //     text: currRightRight
    //     font.bold: true
    //     font.pointSize: 26
    // }

    // Canvas {
    //     id: panelC
    //     // anchors.verticalCenter:panelA.verticalCenter
    //     x: panelB.x
    //     y: panelB.y - 15
    //     width: slotPanelWidth * 2; height: slotPanelHeight + 15
    //     onPaint: {
    //         var ctx = getContext("2d")
    //         ctx.lineWidth = 4
    //         ctx.strokeStyle = "green"
    //         ctx.fillStyle = "light green"

    //         // capsule drawing
    //         ctx.rotate(-13*Math.PI/180)
    //         ctx.beginPath()
    //         ctx.moveTo(cX - capsuleRadius2, cY)
    //         ctx.arc(cX, cY, capsuleRadius2, Math.PI, 0)
    //         // ctx.lineTo(cX + capsuleRadius2, cY + capsuleHeight2)
    //         ctx.arc(cX, cY + capsuleHeight2, capsuleRadius2, 0, Math.PI)
    //         // ctx.lineTo(cX - capsuleRadius2, cY)
    //         ctx.closePath()
    //         ctx.fill()
    //         ctx.stroke()

    //         //ctx.beginPath()
    //         //ctx.moveTo(width/2 - 50 - ctx.lineWidth, ctx.lineWidth + 15)
    //         //ctx.lineTo(width/2, ctx.lineWidth)
    //         //ctx.lineTo(width - 40, height - ctx.lineWidth - 30)
    //         //ctx.lineTo(width/2 - ctx.lineWidth, height - ctx.lineWidth)
    //         //ctx.closePath()
    //         //ctx.fill()
    //         //ctx.stroke()
    //     }
    // }  

}