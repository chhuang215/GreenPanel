import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: 'robotSlots'
    property var currLeft: 'A'
    property var currRight: 'B'
    property var currLeftLeft: 'A' == currLeft ? 'H' : String.fromCharCode(currLeft.charCodeAt(0) - 1)

    property var currRightRight: 'H' == currRight ? 'A' : String.fromCharCode(currRight.charCodeAt(0) + 1)
    

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

    

    function rotateForward(){
        var a = (currLeft.charCodeAt(0) - 65 + 2) % 8
        currLeft = String.fromCharCode(a + 65)
        currRight = String.fromCharCode(((a + 1) % 8 ) + 65)
    }

    function rotateBackward(){
        var a = currLeft.charCodeAt(0) - 65 - 2
        if (a < 0) a = 8 + a 
        currLeft = String.fromCharCode(a + 65)
        currRight = String.fromCharCode(((a + 1) % 8 ) + 65)
    }

    states: [
            State{
                name: "here" 
                AnchorChanges { 
                    target: labelA
                    anchors.left: undefined
                    anchors.bottom: panelA.top
                    anchors.right: panelA.right
                }
                PropertyChanges{
                    target: labelA
                    font.pointSize: 36
                    anchors.rightMargin: 35
                }
                AnchorChanges { 
                    target: labelB
                    anchors.right: undefined
                    anchors.bottom: panelB.top
                    anchors.left: panelB.left
                }
                PropertyChanges{
                    target: labelB
                    font.pointSize: 36
                    anchors.leftMargin: 35
                }
                AnchorChanges {  
                    target: labelC
                    anchors.right: undefined
                    anchors.bottom: panelC.top
                    anchors.left: panelC.left
                    
                }
                PropertyChanges{
                    target: labelC
                    font.pointSize: 26
                    anchors.bottomMargin: - 15
                    anchors.leftMargin: slotPanelWidth - 45
                    visible: true
                }

                AnchorChanges {  
                    target: labelH
                    anchors.left: undefined
                    anchors.bottom: panelH.top
                    anchors.right: panelH.right        
                }
                PropertyChanges{
                    target: labelH
                    anchors.bottomMargin: - 15
                    anchors.rightMargin: slotPanelWidth - 45
                    font.pointSize: 26
                    visible: true
                }
            },
            State{
                name: "moveRight" 
                AnchorChanges { target: labelA; anchors.right: undefined; anchors.left: panelB.left}
                PropertyChanges{target: labelA; anchors.leftMargin: 35}
                AnchorChanges { 
                    target: labelB
                    anchors.bottom: panelC.top
                    anchors.left: panelC.left
                }
                PropertyChanges{
                    target: labelB
                    anchors.bottomMargin: - 15
                    anchors.leftMargin: slotPanelWidth - 45
                    font.pointSize: 26
                }
                PropertyChanges{
                    target: labelC
                    visible: false
                }
                AnchorChanges {  
                    target: labelH
                    anchors.bottom: panelA.top
                    anchors.right: panelA.right
                    
                }
                PropertyChanges{
                    target: labelH
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 35 
                    font.pointSize: 36
                }
            },
            State{
                name: "moveLeft" 
                AnchorChanges { 
                    target: labelA
                    anchors.right: panelH.right
                    anchors.bottom: panelH.top
                }
                PropertyChanges{
                    target: labelA
                    anchors.bottomMargin: - 15
                    anchors.rightMargin: slotPanelWidth - 45
                    font.pointSize: 26
                }
                AnchorChanges {  target: labelB; anchors.left: undefined; anchors.right: panelA.right }
                PropertyChanges{target: labelB; anchors.rightMargin: 35}
                AnchorChanges {  
                    target: labelC
                    anchors.bottom: panelB.top
                    anchors.left: panelB.left
                    
                }
                PropertyChanges{
                    target: labelC
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 35 
                    font.pointSize: 36
                }
                PropertyChanges{
                    target: labelH
                    visible: false
                }
            }
        ]

        transitions:[
            Transition {
                to: "moveRight"
       
                AnchorAnimation { duration: 250}

                onRunningChanged:{
                    if( running === false)
                    {
                        rotateBackward()
                        robotSlots.state = "here"
                    }
                }
                
            },
            Transition {
                to: "moveLeft"
                AnchorAnimation { duration: 250}

                onRunningChanged:{
                    if( running === false)
                    {
                        rotateForward()
                        robotSlots.state = "here"

                    }
                }
                
            }
        ]

    Button {
        anchors.left:panelB.left
        anchors.leftMargin:20
        // x: 400
        y: 25
        text: ">"
        onClicked : {
            // var a = (currLeft.charCodeAt(0) - 65 + 2) % 8
            // currLeft = String.fromCharCode(a + 65)
            // currRight = String.fromCharCode(((a + 1) % 8 ) + 65)
            robotSlots.state = 'moveLeft'
            
        }
    }

    Button {
        anchors.right:panelA.right
        anchors.rightMargin:20
        // x: 300
        y: 25
        text: "<"
        onClicked : {
            // var a = currLeft.charCodeAt(0) - 65 - 2
            // if (a < 0) a = 8 + a 
            // currLeft = String.fromCharCode(a + 65)
            // currRight = String.fromCharCode(((a + 1) % 8 ) + 65)
            robotSlots.state = 'moveRight'
        }
    }

    Text {
        id: labelA
        anchors.bottom: panelA.top
        anchors.right: panelA.right
        anchors.rightMargin: 35
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
            ctx.moveTo(50, ctx.lineWidth)
            // upper line
            ctx.lineTo(width, ctx.lineWidth)
            // right line
            ctx.lineTo(width, height - ctx.lineWidth)
            // bottom line
            ctx.lineTo(0, height - ctx.lineWidth)
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
        anchors.bottom: panelB.top
        anchors.left: panelB.left
        anchors.leftMargin: 35

        text: currRight
        font.family: "Ariel"
        font.bold: true
        font.pointSize: 36
    }

    Canvas {
        id: panelB
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
            ctx.moveTo(width - 50 - ctx.lineWidth, ctx.lineWidth)
            ctx.lineTo(0, ctx.lineWidth)
            ctx.lineTo(0, height - ctx.lineWidth)
            ctx.lineTo(width - ctx.lineWidth, height - ctx.lineWidth)
            ctx.closePath()
            ctx.fill()
            ctx.stroke()
        }
    }  

    /* Below are extra placement panels */
    Text {
        id: labelH
        anchors.bottom: panelH.top
        anchors.bottomMargin: - 15
        anchors.right: panelH.right
        anchors.rightMargin: slotPanelWidth - 45

        text: currLeftLeft
        font.bold: true
        font.pointSize: 26
    }

    Canvas {
        id: panelH
        // anchors.verticalCenter:panelA.verticalCenter
        x: panelA.x - slotPanelWidth
        y: panelA.y - 15
        width: slotPanelWidth * 2; height: slotPanelHeight + 15
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = 4
            ctx.strokeStyle = "green"
            ctx.fillStyle = "limegreen"

            ctx.beginPath()
            ctx.moveTo(width/2, ctx.lineWidth )
            ctx.lineTo(width/2 + 50, ctx.lineWidth + 15)
            ctx.lineTo(width/2, height - ctx.lineWidth)
            ctx.lineTo(ctx.lineWidth + 40, height - ctx.lineWidth - 30)
            
            ctx.closePath()
            ctx.fill()
            ctx.stroke()
        }
    }  

    Text {
        id: labelC
        anchors.bottom: panelC.top
        anchors.bottomMargin: - 15
        anchors.left: panelC.left
        anchors.leftMargin: slotPanelWidth - 45

        text: currRightRight
        font.bold: true
        font.pointSize: 26
    }

    Canvas {
        id: panelC
        // anchors.verticalCenter:panelA.verticalCenter
        x: panelB.x
        y: panelB.y - 15
        width: slotPanelWidth * 2; height: slotPanelHeight + 15
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = 4
            ctx.strokeStyle = "green"
            ctx.fillStyle = "limegreen"

            ctx.beginPath()
            ctx.moveTo(width/2 - 50 - ctx.lineWidth, ctx.lineWidth + 15)
            ctx.lineTo(width/2, ctx.lineWidth)
            ctx.lineTo(width - 40, height - ctx.lineWidth - 30)
            ctx.lineTo(width/2 - ctx.lineWidth, height - ctx.lineWidth)
            ctx.closePath()
            ctx.fill()
            ctx.stroke()
        }
    }  
}