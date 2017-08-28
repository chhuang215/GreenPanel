import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelRobotSelect"
    // objectName: "panelRobotAddSelect"
    visible: false
    signal slotsSelectedDone

    property int mode: 0 // 0 is AddMode, 1 is RemoveMode

    property var slots : {}

    property alias currLeft : robotSlots.currLeft
    property alias currRight : robotSlots.currRight

    onVisibleChanged:{
        slotsChanged()
    }

    // onSlotsChanged:{
    //     console.log(JSON.stringify(slots))
    // }
    
    Item{
        id: mini
        width: 164
        height: 164
        anchors.top: parent.top
        anchors.topMargin:65
        anchors.left: parent.left
        anchors.leftMargin: 10

        property int center: width/2
        property int radius: width/2

        Canvas{
            anchors.fill:parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.lineWidth = 1.5
                ctx.strokeStyle = "green"
                ctx.fillStyle = "lightgreen"
                // ctx.resetTransform()
                ctx.beginPath()
                ctx.arc(width/2, height/2, width/2 - ctx.lineWidth/2, 0, 2*Math.PI)
                ctx.closePath()
                ctx.fill()
                ctx.stroke()

                ctx.beginPath()
                ctx.moveTo(width/2, 0)
                ctx.lineTo(width/2, height)
                ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(0, height/2)
                ctx.lineTo(width, height/2)
                ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(width/2 - (width/2) / Math.pow(2, 0.5), height/2 - (height/2) / Math.pow(2, 0.5))
                ctx.lineTo(width/2 + (width/2) / Math.pow(2, 0.5), height/2 + (height/2) / Math.pow(2, 0.5))
                ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(width/2 + (width/2) / Math.pow(2, 0.5), height/2 - (height/2) / Math.pow(2, 0.5))
                ctx.lineTo(width/2 - (width/2) / Math.pow(2, 0.5), height/2 + (height/2) / Math.pow(2, 0.5))
                ctx.stroke()
            }

            Component{
                id: miniSlot
                Rectangle{ 
                    width:15
                    height:15
                    radius:7
                    border.width: 1
                    property var slotData: {"status": -1, "selected": false}
                    color: {
                        var selected = slotData.selected
                        var stat = slotData.status
                        if (selected){
                            return "blue"
                        }
                        else if (stat == 0){
                            return "red"
                        }
                        else if (stat == 1){
                            return "green"
                        }
                        else{
                            return "white"
                        }
                    }
                }
            }
            Repeater{
                model: 8
                Item{
                    id: miniPane
                    property var capsuleLabel: String.fromCharCode((((currLeft.charCodeAt(0) - 65) + index) % 8 + 65))
                    property real angle: (112.5 - 45 * index) * Math.PI/180
                    Repeater{
                        model: slots[capsuleLabel].length
                        Loader { 
                            sourceComponent: miniSlot
                            onLoaded:{
                                var distance = 0.8 - 0.25 * index
                                var centerX = mini.center - item.width/2
                                var centerY = mini.center - item.height/2
                                item.x = centerX + mini.radius * Math.cos(miniPane.angle) * distance
                                item.y = centerY + mini.radius * Math.sin(miniPane.angle) * distance
                                item.slotData = Qt.binding(function(){ return slots[miniPane.capsuleLabel][index]})
                            }
                        }
                    }

                    Text{
                        text:capsuleLabel
                        x: mini.center - width/2 + mini.radius * Math.cos(miniPane.angle) * 1.05
                        y: mini.center - height/2 + mini.radius * Math.sin(miniPane.angle) * 1.05
                    }
                }                
            }
            
            // Rectangle{ // the border to see the canvas position/size
            //     anchors.fill: parent
            //     border.width: 2
            //     color: "transparent"
            // }
        }
    }

        
    
    /* The Slot Hole Component */
    Component{
        id: slotHoleComponent
        
        RoundMouseArea {
            property var slotPane : {}
            property int slotNum : -1
            property var slotData: slots[slotPane][slotNum]
            label: slotNum + 1
            status: slotData.status
            selected: slotData.selected
            disabled: !selected && (mode == 0 ? status != -1 : status == -1)
    
            onClicked: {
                if(!disabled){
                    // slots[slotPane][slotNum].selected = !slots[slotPane][slotNum].selected
                    slotData.selected = !slotData.selected
                    slotDataChanged()
                    currLeftChanged() // Reevaluate purpose
                }
            }
        }
    }

    // The UI slot base
    RobotSlots{
        id: robotSlots
        anchors.fill: parent
        slotComponent: slotHoleComponent
        leftSlotsQuantity: slots[currLeft].length
        rightSlotsQuantity: slots[currRight].length
    }

    Button{
        id: "btnDoneAddSelect"
        width:150
        height:100
        
        anchors.right: parent.right
        text: "DONE"

        onClicked:{
            parent.slotsSelectedDone()
        }
    }
    // Button{
    //     width:150
    //     height:150
        
    //     anchors.right: parent.right
    //     anchors.top: btnDoneAddSelect.bottom
    //     text: "J"
    //     onClicked:{
    //         console.log(JSON.stringify(slotsSelected,  null, '\t') )

    //     }
    // }

}