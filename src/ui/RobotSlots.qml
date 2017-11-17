import QtQuick 2.7
import QtQuick.Controls 2.0

Item{


    property string currLeft: 'B'
    property string currCenter: 'A'
    property string currRight:  'H' == currCenter ? 'A' : String.fromCharCode(currCenter.charCodeAt(0) + 1)
    property string currLeftLeft: 'A' == currCenter ? 'H' : String.fromCharCode(currCenter.charCodeAt(0) - 1)
    property string currRightRight: 'H' == currRight ? 'A' : String.fromCharCode(currRight.charCodeAt(0) + 1)
    
    property int capsuleRadius: 50
    property int capsuleHeight: 160

    property int capsuleRadius2: 25
    property int capsuleHeight2: 160

    // horizontal center point of the canvas drawing
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

    property var slotComponent: {}
    property int leftSlotsQuantity: plantSlots[currCenter].length
    property int rightSlotsQuantity: plantSlots[currRight].length

    Image{
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left:parent.left
        anchors.top:parent.top
        anchors.topMargin:-200
        anchors.bottomMargin:-70
        source: "images/inside.bmp"
    }

    Button {
        anchors.left: capsules.horizontalCenter
        anchors.leftMargin:20
        anchors.bottom: capsules.top
        anchors.bottomMargin: -15
        width: 75; height: 70
        
        text: ">"
       
        onClicked : {
            var a = (currCenter.charCodeAt(0) - 65 + 1) % 8
            currCenter = String.fromCharCode(a + 65)
            // currRight = String.fromCharCode(((a + 1) % 8 ) + 65)
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
            var a = currCenter.charCodeAt(0) - 65 - 1
            if (a < 0) a += 8
            currCenter = String.fromCharCode(a + 65)
            // currRight = String.fromCharCode(((a + 1) % 8 ) + 65)
        }
    }

    

    Text {
        anchors.top: capsules.bottom
        anchors.right: capsules.horizontalCenter
        anchors.rightMargin: 57

        text: currCenter
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
            ctx.strokeStyle = "black"
            // ctx.resetTransform()

            // frame
            ctx.beginPath();
            ctx.arc(capsulesCenter, -480 - anchors.topMargin, 600, 0.4 * Math.PI, 0.6 * Math.PI)
            ctx.arc(capsulesCenter, -500 - anchors.topMargin, 900, 0.6 * Math.PI, 0.4 * Math.PI, true);
            ctx.closePath()
            ctx.fillStyle = "#f2f2f2"
            ctx.fill()
            ctx.stroke();

            //A
            ctx.beginPath()
            ctx.arc(capsuleAX, capsuleY, capsuleRadius, Math.PI, 0)
            ctx.arc(capsuleAX - capsuleXDisplacement, capsuleY + capsuleHeight, capsuleRadius, 0, Math.PI)
            ctx.closePath()
            ctx.fillStyle = "#cecece"
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

    

    Repeater {
        model: [leftSlotsQuantity, rightSlotsQuantity]
        Repeater{
            property int slotsQuantity: modelData
            property int capsuleX: index == 0 ? capsuleAX: capsuleBX
            property var currLeftRight : index == 0 ? currCenter : currRight
            model: modelData
            Loader { 
                sourceComponent: slotComponent
                onLoaded:{
                    if(currLeftRight == currCenter){
                        item.x = capsuleX + capsuleRadius + item.width/2 - 5 - (5 * (slotsQuantity  - 1- index))
                    }
                    else{ 
                        item.x = capsuleX + capsuleRadius + item.width/2 - 5 + (5 * (slotsQuantity  - 1- index)) 
                    }
                    item.y = capsuleY  + (slotsQuantity == 3 ?  + 50 : 80) + 80 * (slotsQuantity - 1 - index)
                    item.slotNum = index
                    item.slotPane = Qt.binding(function() { return currLeftRight} )
                }
            }
        }
    }

}