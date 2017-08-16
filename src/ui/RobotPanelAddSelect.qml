import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelRobotAddSelect"
    objectName: "panelRobotAddSelect"
    visible: false

    property var slots : {"A": [-1, 1, 0], "B": [-1, 0],
                        "C": [-1, -1, -1], "D": [-1, -1],
                        "E": [-1, -1, -1], "F": [-1, -1],
                        "G": [-1, -1, -1], "H": [-1, -1],
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
        status: slots[currLeft][slotNum]
        selected: status == 2
        disabled: !selected && status != -1 
        x: 305
        y: 180
        
        onClicked: {
            if(!disabled){
                
                slots[currLeft][slotNum] = !selected ? 2 : -1 
                status = Qt.binding(function() { return slots[currLeft][slotNum] })
            }
        }
    }

    RoundMouseArea {
        slotNum: 1
        status: slots[currLeft][slotNum]
        selected: status == 2
        disabled: !selected && status != -1 
        x: 305
        y: 250

        onClicked: {
            if(!disabled){
                
                slots[currLeft][slotNum] = !selected ? 2 : -1 
                status = Qt.binding(function() { return slots[currLeft][slotNum] })
            }
        }
    }

    RoundMouseArea {
        slotNum: 2
        status: slots[currLeft][slotNum]
        selected: status == 2
        disabled: !selected && status != -1 
        x: 305
        y: 320

        onClicked: {
            if(!disabled){
                
                slots[currLeft][slotNum] = !selected ? 2 : -1 
                status = Qt.binding(function() { return slots[currLeft][slotNum] })
            }
        }
    }
    /* end SLOTS on the LEFT */

    /* SLOTS on the RIGHT */
    RoundMouseArea {
        slotNum: 0
        status: slots[currRight][slotNum]
        selected: status == 2
        disabled: !selected && status != -1 
        x: 430
        y: 210

        onClicked: {
            if(!disabled){
                
                slots[currRight][slotNum] = !selected ? 2 : -1 
                status = Qt.binding(function() { return slots[currRight][slotNum] })
            }
        }
    }

    RoundMouseArea {
        // id: roundMouseArea2

        slotNum: 1
        status: slots[currRight][slotNum]
        selected: status == 2
        disabled: !selected && status != -1 
        x: 430
        y: 280

        onClicked: {
            if(!disabled){
                
                slots[currRight][slotNum] = !selected ? 2 : -1 
                status = Qt.binding(function() { return slots[currRight][slotNum] })
            }
        }
    }
    /* end SLOTS on the RIGHT */
}