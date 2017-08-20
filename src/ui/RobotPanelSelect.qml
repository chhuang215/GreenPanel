import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id: "panelRobotSelect"
    // objectName: "panelRobotAddSelect"
    visible: false
    signal slotsSelectedDone

    property int mode: 0

    property var slots : {}

    property var currLeft : slotsBase.currLeft
    property var currRight : slotsBase.currRight

    // onSlotsChanged:{
    //     console.log(JSON.stringify(slots))
    // }
    // The UI slot base
    RobotSlots{
        id: slotsBase
        anchors.fill: parent
    }
    
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
                item.x = slotsBase.leftPanel.x + (slotsBase.slotPanelWidth/2) - (item.width/2) + 23 - (6 * index)
                item.y = (slots[currLeft].length == 3 ? 170 : 200) + 80 * index
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
            // x: 440 - (5 * index)
            // y:(slots[currRight].length == 3 ? 170 : 210) + 80 * index
            onLoaded:{
    
                item.x = slotsBase.rightPanel.x + (slotsBase.slotPanelWidth/2) - (item.width/2) - 23 + (6 * index)
                item.y = (slots[currRight].length == 3 ? 170 : 200) + 80 * index
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