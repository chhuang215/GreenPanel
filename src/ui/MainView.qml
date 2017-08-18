import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0


Rectangle {

    id: main
    width: 800; height: 480
    signal quit
    signal rotateMotor(int dir)
    signal stopMotor
    signal navBack
    // color: "lightgray"

    

    Row{
        id: "topBar"
        anchors.horizontalCenter: parent.horizontalCenter
        
        width:parent.width - 5
        height: 50
        anchors.bottomMargin:10
        Item{
            width:  Math.max(btnBack.width, btnSetting.width)
            height: Math.max(btnBack.height, btnSetting.height)
            anchors.verticalCenter: parent.verticalCenter
            Button {
                text: "<-Back"
                id:"btnBack"
                objectName: "btnBack"
                visible: !panelHome.visible
                onClicked: navBack()
            }
            Button{
                id:"btnSetting"
                objectName:"btnSetting"
                text:"Setting"
                anchors.verticalCenter: parent.verticalCenter
                visible: panelHome.visible
            }
        }
        Button{
            id:"btnRotateLeft"
            objectName:"btnRotateLeft"
            text:"<-"
            anchors.verticalCenter: parent.verticalCenter
            onPressed: rotateMotor(2)
            onReleased: stopMotor()
            visible: panelHome.visible || panelRobot.visible || panelRobotAddSelect.visible
        }

        Button{
            id:"btnRotateRight"
            objectName:"btnRotateRight"
            text:"->"
            anchors.verticalCenter: parent.verticalCenter
            onPressed: rotateMotor(1)
            onReleased: stopMotor()
            visible: panelHome.visible || panelRobot.visible || panelRobotAddSelect.visible

        }
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
