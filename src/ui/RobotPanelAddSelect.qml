import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelRobotAddSelect"
    objectName: "panelRobotAddSelect"
    visible: false
    signal slotsSelectedDone
    property var slots : {}

    property var currLeft : slotsBase.currLeft
    property var currRight : slotsBase.currRight

    // The UI slot base
    RobotSlots{
        id: slotsBase
        anchors.fill: parent
    }
    
    Component{
        id: slotHole
        RoundMouseArea {
            id: rma
            property var slotPane : {}
            status: slots[slotPane][slotNum].status
            disabled: !selected && status != -1 
            
            onClicked: {
                if(!disabled){
                    slots[slotPane][slotNum].status = !selected ? 2 : -1 
                    // slotsSelected[slotPane][slotNum] ^= 1 
                    
                    panelRobotAddSelect.slotsChanged() 
                    // panelRobotAddSelect.slotsSelectedChanged()
                }
            }
        }
    }

    /* SLOTS on the LEFT */
    Repeater {
        model: slots[currLeft].length
        Loader { 
            sourceComponent: slotHole
            x: 305
            y: (slots[currLeft].length == 3 ? 180 : 210) + 70 * index
            onLoaded:{
                item.slotNum = index
                item.slotPane = Qt.binding(function() { return currLeft} )
            }
        }
    }
    /* end SLOTS on the LEFT */

    /* SLOTS on the RIGHT */
    Repeater {
        model: slots[currRight].length
        Loader { 
            sourceComponent: slotHole
            x:430
            y:(slots[currRight].length == 3 ? 180 : 210) + 70 * index
            onLoaded:{
                item.slotNum = index
                item.slotPane = Qt.binding(function() { return currRight} )
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