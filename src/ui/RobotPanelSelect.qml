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

    // onSlotsChanged:{
    //     console.log(JSON.stringify(slots))
    // }
    // The UI slot base
    RobotSlots{
        id: robotSlots
        anchors.fill: parent
    }
    
    /* The Slot Hole Component */
    Component{
        id: slotHole
        RoundMouseArea {
            property var slotPane : {}
            status: slots[slotPane][slotNum].status
            selected: slots[slotPane][slotNum].selected
            disabled: !selected && (mode == 0 ? status != -1 : status == -1)
    
            onClicked: {
                if(!disabled){
                    slots[slotPane][slotNum].selected = !slots[slotPane][slotNum].selected
                    slotsChanged()
                }
            }
        }
    }

    /* SLOTS on the LEFT */
    Repeater {
        model: slots[currLeft].length
        Loader { 
            sourceComponent: slotHole
            
            onLoaded:{
                // item.x = robotSlots.leftPanel.x + (robotSlots.slotPanelWidth/2) - (item.width/2) + 23 - (6 * index)
                // item.y = robotSlots.leftPanel.y + (slots[currLeft].length == 3 ?  + 50 : 80) + 80 * index
                item.x = robotSlots.capsuleAX + robotSlots.capsuleRadius + item.width/2 - 5 - (5 * index)
                item.y = robotSlots.capsuleY  + (slots[currLeft].length == 3 ?  + 50 : 80) + 80 * index
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
            onLoaded:{
                // item.x = robotSlots.rightPanel.x + (robotSlots.slotPanelWidth/2) - (item.width/2) - 23 + (6 * index)
                // item.y = robotSlots.rightPanel.y + (slots[currRight].length == 3 ?  + 50 : 80) + 80 * index
                item.x = robotSlots.capsuleBX + robotSlots.capsuleRadius + item.width/2 - 5 + (5 * index)
                item.y = robotSlots.capsuleY  + (slots[currRight].length == 3 ?  + 50 : 80) + 80 * index
                item.slotNum = index
                item.slotPane = Qt.binding(function() { return currRight} )
            }
        }
    }

    /* end SLOTS on the RIGHT */

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