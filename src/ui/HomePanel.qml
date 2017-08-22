import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Item{
  
    id:"panelHome"
    // property alias changeColor:helloText.color

    signal rotateMotor(int d)
    signal stopMotor()
    signal unitChanged(var unit)
    signal clearNotify()

    property alias temperatureUnit : tempDisplay.unit

    function updateTemperature(c, f){
        tempDisplay.tempC = c + " \u00B0C";
        tempDisplay.tempF = f + " \u00B0F";
    }
    function notifyRobot(msg){
        robotNotification.text = msg 
    }

   

    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin:60
        // anchors.topMargin: 10
        width: parent.width
        spacing:50

        Row {
            x: 119
            spacing: 60
            
             Button {
                width:226
                height:130
                text: "water"
                objectName: "btnWater"
            }

            Button {
                width:226
                height:130
                text: "nutrient"
            }
        }

        Row {
            x: 30
            spacing: 30
            
            Button {
                id:"btnLight"
                objectName:"btnLight"
                width:226
                height:130
                text: "Set Light Timer"

            }

            Item{
                id: "tempDisplay"
                
                property var unit: 'c'
                property var tempC: 0
                property var tempF: 0
                property bool c: unit == "c"

                width: 226
                height: 130
                anchors.verticalCenter: parent.verticalCenter
                // anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: parent.c ? parent.tempC : parent.tempF
                    font.pointSize: 40; font.bold: true
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
            }

            Button {
                width:226
                height:130
                id:"btnRobot"
                objectName:"btnRobot"
                text: qsTr("Robot Guy")    

                Item{
                    id: robotNotification
                    property alias text: txt.text
                    width: txt.width + 20
                    height: txt.height + 10
                    anchors.top: btnRobot.top
                    anchors.right: btnRobot.right
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
                        Text{
                            id: txt
                            anchors.centerIn: parent
                            text: ""
                            color: "white"
                            font.pointSize:12
                        }

                        Rectangle{
                            anchors.verticalCenter: parent.top
                            anchors.horizontalCenter: parent.right
                            width: 18; height: 18; radius: 10
                            color: "darkred"
                            Text{
                                anchors.centerIn: parent
                                text: "\u274C"
                                color: "white"
                                font.pointSize:7.5
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

