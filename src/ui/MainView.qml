import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0


Rectangle {

    id: main
    width: 800; height: 480
    signal quit
    signal rotateMotor(int dir)
    signal stopMotor
    // color: "lightgray"

    Button {
        text: "<-Back"
        objectName: "btnBack"
    }

    HomePanel{
        id: "panelHome"
        anchors.fill: parent
        onRotateMotor: parent.rotateMotor(d)
        onStopMotor: parent.stopMotor()
    }

    LightPanel{
        id: "panelLight"
        anchors.fill: parent
    }

    WaterPanel{
        id: "panelWater"
        anchors.fill: parent
    }

    /* SETTING */
    SettingPanel{
        id: "panelSetting"
        anchors.fill: parent
    }

    SetTime{
        id: "timePicker"
    }

    SetDate{
        id: "datePicker"
    }

    /* end SETTING */

    /* ROBOT */
    RobotPanel{
        id: "panelRobot"
        anchors.fill: parent
    }

    RobotPanelAdd{
        id: "panelRobotAdd"
        anchors.fill: parent
        
        // param: (int type)
        onPlantSelected:{
            panelRobotAddConfirm.plantType = type
        }
    }

    RobotPanelAddSelect{
        id: "panelRobotAddSelect"
        anchors.fill: parent
        // width:parent.width
        slots: panelRobot.slots
    }

    RobotPanelAddConfirm{
        id: "panelRobotAddConfirm"
        anchors.fill: parent
        // slotsSelected: panelRobotAddSelect.slotsSelected
        slots: panelRobotAddSelect.slots
        onRemoveSelection:{
            panelRobotAddSelect.slots[slotP][slotN].status = -1
            panelRobotAddSelect.slotsChanged()
        }
    }

    // Grid {
    //     id: grid
    //     x: 4; anchors.bottom: page.bottom; anchors.bottomMargin: 4
    //     rows: 1; columns: 6; spacing: 3            

    //     Cell { cellColor: "red"; onClicked: panelHome.changeColor = cellColor }
    //     Cell { cellColor: "green"; onClicked: panelHome.changeColor = cellColor }
    //     Cell { cellColor: "blue"; onClicked: panelHome.changeColor = cellColor }
    //     Cell { cellColor: "yellow"; onClicked: panelHome.changeColor = cellColor }
    //     Cell { cellColor: "steelblue"; onClicked: panelHome.changeColor = cellColor }
    //     Cell { cellColor: "black"; onClicked: panelHome.changeColor = cellColor }
    // }

    Button{
        anchors.bottom:parent.bottom
        anchors.right:parent.right
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        text:"quit"
        objectName:"btnQuit"
        onClicked:{
            parent.quit()
        }
    }

}
