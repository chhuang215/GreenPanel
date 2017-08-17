import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelRobotAddSelect"
    objectName: "panelRobotAddSelect"
    visible: false
    signal slotsSelectedDone
    property var slots : {}
    property var slotsSelected: {"A": [0,0,0], "B": [0,0],
                                "C": [0,0,0], "D": [0,0],
                                "E": [0,0,0], "F": [0,0],
                                "G": [0,0,0], "H": [0,0]
                                }

    property var currLeft : slotsBase.currLeft
    property var currRight : slotsBase.currRight
    
    // The UI slot base
    RobotSlots{
        id: slotsBase
    }
    
    /* SLOTS on the LEFT */
    RoundMouseArea {
        slotNum: 0
        status: slots[currLeft][slotNum].status
        disabled: !selected && status != -1 
        x: 305
        y: 180
        
        onClicked: {
            if(!disabled){
                
                slots[currLeft][slotNum].status = !selected ? 2 : -1 
                slotsSelected[currLeft][slotNum] ^= 1 
                status = Qt.binding(function() { return slots[currLeft][slotNum].status })
            }
        }
    }

    RoundMouseArea {
        slotNum: 1
        status: slots[currLeft][slotNum].status
        disabled: !selected && status != -1 
        x: 305
        y: 250

        onClicked: {
            if(!disabled){
                
                slots[currLeft][slotNum].status = !selected ? 2 : -1 
                slotsSelected[currLeft][slotNum] ^= 1 
                status = Qt.binding(function() { return slots[currLeft][slotNum].status })
            }
        }
    }

    RoundMouseArea {
        slotNum: 2
        status: slots[currLeft][slotNum].status
        disabled: !selected && status != -1 
        x: 305
        y: 320

        onClicked: {
            if(!disabled){
                
                slots[currLeft][slotNum].status = !selected ? 2 : -1 
                slotsSelected[currLeft][slotNum] ^= 1 
                status = Qt.binding(function() { return slots[currLeft][slotNum].status })
            }
        }
    }
    /* end SLOTS on the LEFT */

    /* SLOTS on the RIGHT */
    RoundMouseArea {
        slotNum: 0
        status: slots[currRight][slotNum].status
        disabled: !selected && status != -1 
        x: 430
        y: 210

        onClicked: {
            if(!disabled){
                
                slots[currRight][slotNum].status = !selected ? 2 : -1 
                slotsSelected[currRight][slotNum] ^= 1 
                status = Qt.binding(function() {return slots[currRight][slotNum].status })
            }
        }
    }

    RoundMouseArea {
        // id: roundMouseArea2

        slotNum: 1
        status: slots[currRight][slotNum].status
        disabled: !selected && status != -1 
        x: 430
        y: 280

        onClicked: {
            if(!disabled){
                
                slots[currRight][slotNum].status = !selected ? 2 : -1
                slotsSelected[currRight][slotNum] ^= 1 
                status = Qt.binding(function() { return slots[currRight][slotNum].status })
            }
        }
    }
    /* end SLOTS on the RIGHT */

    Button{
        id: "btnDoneAddSelect"
        width:150
        height:150
        
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