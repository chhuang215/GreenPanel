import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    
    property int lightHr: 7
    property int lightDuration: 17
    property int buttonHeight: 100
    property int buttonWidth: 100
    signal lightTimerChanged(var hr, var dur)
    signal lightSwitched
    id:"panelLight"
    visible: false
    Row{
        anchors.fill:parent
        anchors.topMargin:55
        anchors.centerIn: parent
        Column{
            width:parent.width / 2 
            Grid {
                id: grid
                width:parent.width
                rows: 2; columns: 3; spacing: 3            
                Row {
                    x: 30
                    spacing: 30
                    Text {
                        
                        anchors.verticalCenter: parent.verticalCenter
                        objectName: "txtHourLabel"
                        text: "Hour:"
                        font.pointSize: 40; font.bold: true

                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        id: "txtHour"
                        objectName: "txtHour"
                        text: lightHr
                        font.pointSize: 40; font.bold: true
                    }
                }
                Button {
                    // signal qmlSignal(var anObject)
                    objectName:"btnIncHour"
                    width:buttonWidth
                    height:buttonHeight
                    text: "+"
                    onClicked: {
                        
                        lightHr = (lightHr + 1) % 24;
                        panelLight.lightTimerChanged(lightHr, lightDuration)
                    }   
                }
                Button {
                    objectName:"btnDecHour"
                    width:buttonWidth
                    height:buttonHeight
                    text: "-"
                    
                    onClicked: {
                        
                        lightHr = lightHr <= 0 ? 23 : (lightHr - 1)
                        panelLight.lightTimerChanged(lightHr, lightDuration)
                    }
                    
                }
                Row {
                    x: 30
                    spacing: 30
                    
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Duration:"
                        font.pointSize: 40; font.bold: true
                    }

                    Text {
                        
                        anchors.verticalCenter: parent.verticalCenter
                        id: "txtDuration"
                        objectName: "txtDuration"
                        text: lightDuration

                        font.pointSize: 40; font.bold: true

                    }
                }
                Button {
                    width:buttonWidth
                    height:buttonHeight
                    text: "+"
                    onClicked: {
                        if (lightDuration < 23){
                            lightDuration = lightDuration + 1     
                            panelLight.lightTimerChanged(lightHr, lightDuration)
                        }
                        
                    }
                }
                Button {
                    width:buttonWidth
                    height:buttonHeight
                    text: "-"
                    
                    onClicked: {
                        if (lightDuration > 1){
                            lightDuration = lightDuration - 1     
                            panelLight.lightTimerChanged(lightHr, lightDuration)
                        }
                        
                    }   
                
                }
            }
        }
        Column{
            
            width: parent.width / 2
            Button {
                anchors.right: parent.right
                anchors.rightMargin: 10
                width:175
                height:130
                text: "Light Switch"
                objectName: "swtLight"            
                // checked: true
                onClicked: lightSwitched()
            }
        }


    }
   
}

