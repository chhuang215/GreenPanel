import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Item{
  
    id:"panelHome"

    signal unitChanged(var unit)
    signal clearNotify()
 
    property bool waterGood : false 
    property int nutrientDays : -1
    property alias temperatureUnit : tempDisplay.unit
    
    function updateTemperature(c, f, s){
        tempDisplay.tempC = c + " \u00B0C";
        tempDisplay.tempF = f + " \u00B0F";
        tempDisplay.status = s;

    }
    function notifyRobot(msg){
        robotNotification.text = msg ;
    }
    
    Item{
            id: "tempDisplay"
            
            property var unit: 'c'
            property var tempC: 0
            property var tempF: 0
            property var status: 0
            property bool c: unit == "c"

            width: 170
            height: 130
            // anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 60
            // anchors.horizontalCenter: parent.horizontalCenter
            Image{
                anchors.right:parent.right
                anchors.rightMargin:30
                anchors.top:parent.top
                anchors.topMargin: 35
                fillMode: Image.PreserveAspectFit
                // width: 110
                height: 80
                source: "images/icon_te.png"
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                text: parent.c ? parent.tempC : parent.tempF
                font.pointSize: 23; font.bold: true
            }
            
            MouseArea { 
                anchors.fill: parent 
                onClicked: {
                     parent.unit = parent.unit == 'c' ? 'f' : 'c'
                     parent.c ? temperatureUnitChanged("c") : temperatureUnitChanged("f")
                }
            }
            onUnitChanged:{
                panelHome.unitChanged(unit)
            }

            Rectangle{
                width: txtTempNotification.width + 10
                height: txtTempNotification.height + 10
                anchors.top: parent.top
                anchors.right: parent.right
                color: tempDisplay.status == 1 ? 'red' : tempDisplay.status == -1 ? 'lightblue' : 'green'
                visible: tempDisplay.status != 0
                Text{
                    id: txtTempNotification
                    anchors.centerIn: parent
                    text: tempDisplay.status == 1 ? 'HOT' : tempDisplay.status == -1 ? 'COLD' : ''
                    // color: "white"
                    font.pointSize:12
                }
            }

            
        }

    Column{
        // anchors.horizontalCenter: parent.horizontalCenter
        anchors.right:parent.right
        anchors.left:parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin:40
        
        // anchors.topMargin: 10
        
        spacing:20

        Row {
            anchors.horizontalCenter:parent.horizontalCenter
            spacing: 65
            
            HomePanelButton {
                objectName: "btnWater"
                imgSource: "images/icon_wa.png"
                Rectangle{
                    width: txtWaterNoti.width + 10
                    height: 36
                    radius: 10
                    color: waterGood ? "blue" : "saddlebrown"
                    anchors.top: parent.top
                    anchors.right: parent.right
                    Text{
                        id: txtWaterNoti
                        anchors.centerIn: parent
                        text: waterGood ? "Good" : "Need water"
                        font.pointSize: 16
                        color: "white"
                    }
                }
            }

            HomePanelButton {
                objectName: "btnNutrient"
                imgSource: "images/icon_nu.png"
                Rectangle{
                    width: 36
                    height: 36
                    radius: 10
                    color: txtNutrientNoti.text == 0 ? "red" : "green"
                    anchors.top: parent.top
                    anchors.right: parent.right
                    Text{
                        id: txtNutrientNoti
                        anchors.centerIn: parent
                        text: panelHome.nutrientDays
                        font.pointSize: 16
                        color: "white"
                    }
                }
            }
        }

        Row {
            anchors.horizontalCenter:parent.horizontalCenter
            spacing: 65
            
            // Button to navigate to light setting page
            HomePanelButton{
                id:"btnLight"
                objectName:"btnLight"
                imgSource: "images/icon_li.png"
            }


            HomePanelButton{
                id:"btnRobot"
                objectName:"btnRobot"
                text: qsTr("Robot Guy")    
                Item{
                    id: robotNotification
                    property alias text: txt.text
                    width: txt.width + 20
                    height: txt.height + 10
                    anchors.bottom: btnRobot.top
                    anchors.right: btnRobot.right
                    anchors.bottomMargin: - 25
                    anchors.rightMargin: -5
                    visible : opacity > 0.0
                    opacity : txt.text.length > 0 ? 1 : 0

                    states: [
                        State { when: txt.text.length > 0;
                            PropertyChanges {   target: robotNotification; opacity: 1.0    }
                        },
                        State { when: txt.text.length <= 0;
                            PropertyChanges {   target: robotNotification; opacity: 0.0    }
                        }
                    ]
                    transitions: Transition {
                        NumberAnimation {property:'opacity'; duration: 200}
                    }

                    Rectangle{
                        anchors.fill: parent
                        color: "darkgreen"
                        radius: 10
                        Text{
                            id: txt
                            anchors.centerIn: parent
                            text: ""
                            color: "white"
                            font.pointSize:12
                            wrapMode:Text.Wrap 
                            onTextChanged:{
                                if(width > btnRobot.width) width = btnRobot.width;
                                else width = undefined
                            }
                        }
                        MouseArea{anchors.fill:parent}
                        Rectangle{ // X button
                            anchors.verticalCenter: parent.top
                            anchors.horizontalCenter: parent.right
                            width: 18.5; height: 18.5; radius: 10
                            color: "darkred"
                            Text{
                                anchors.centerIn: parent
                                text: "\u00D7"
                                color: "white"
                                font.pointSize:14
                                font.bold: true
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked:{
                                    panelHome.clearNotify()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

