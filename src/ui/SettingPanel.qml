import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id:"panelSetting"
    objectName:"panelSetting"
    visible: false

    signal scanWifi()
    property int hour: 00
    property int min: 00

    Column{
        anchors.top: parent.top
        anchors.topMargin: 40

        Grid {
            id: grid
            width:parent.width
            rows: 4; columns: 2; spacing: 10

            Rectangle {
                x: 30
                width: 300
                height: 80
                color: "transparent"
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    objectName: "languageLabel"
                    text: "Language: "
                    font.pointSize: 30; font.bold: true
                }
            }

            /*Rectangle {
                z: 100
                width: 300
                height: 80
                color: "transparent"
                ComboBox {
                    currentIndex: 0
                    model: ListModel {
                        id: cbItems
                        ListElement { text: "English" }
                        ListElement { text: "French" }
                        ListElement { text: "Chinese" }
                    }
                    onCurrentIndexChanged: console.debug(cbItems.get(currentIndex).text + ", " + cbItems.get(currentIndex).color)
                }
            }*/

            Rectangle {
                width:300
                height: 80
                color: "transparent"

                Rectangle {
                    id:comboBox
                    property variant items: ["English", "French", "Chinese"]
                    property alias selectedItem: chosenItemText.text;
                    property alias selectedIndex: listView.currentIndex;
                    signal comboClicked;
                    width: 150;
                    height: 50;
                    color: "transparent"
                    z: 100;
                    smooth:true;

                    Rectangle {
                        id:chosenItem
                        radius:4;
                        width:parent.width;
                        height:comboBox.height;
                        color: "white"
                        smooth:true;
                        Text {
                            anchors.top: parent.top;
                            anchors.left: parent.left;
                            anchors.margins: 8;
                            id:chosenItemText
                            objectName: "chosenItemText"
                            text:comboBox.items[0];
                            font.family: "Arial"
                            font.pointSize: 14;
                            smooth:true
                        }

                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                comboBox.state = comboBox.state==="dropDown"?"":"dropDown"
                            }
                        }
                    }

                    Rectangle {
                        id:dropDown
                        width:comboBox.width;
                        height:0;
                        clip:true;
                        radius:4;
                        anchors.top: chosenItem.bottom;
                        anchors.margins: 2;
                        color: "white"

                        ListView {
                            id:listView
                            height:100;
                            model: comboBox.items
                            currentIndex: 0
                            delegate: Item{
                                width:comboBox.width;
                                height: comboBox.height;

                                Text {
                                    text: modelData
                                    anchors.top: parent.top;
                                    anchors.left: parent.left;
                                    anchors.margins: 5;

                                }
                                MouseArea {
                                    anchors.fill: parent;
                                    onClicked: {
                                        comboBox.state = ""
                                        var prevSelection = chosenItemText.text
                                        chosenItemText.text = modelData
                                        if(chosenItemText.text != prevSelection){
                                            comboBox.comboClicked();
                                        }
                                        listView.currentIndex = index;
                                    }
                                }
                            }
                        }
                    }

                    Component {
                        id: highlight
                        Rectangle {
                            width:comboBox.width;
                            height:comboBox.height;
                            color: "red";
                            radius: 4
                        }
                    }

                    states: State {
                        name: "dropDown";
                        PropertyChanges { target: dropDown; height:40*comboBox.items.length }
                    }

                    transitions: Transition {
                        NumberAnimation { target: dropDown; properties: "height"; easing.type: Easing.OutExpo; duration: 1000 }
                    }
                }
            }
            
            Rectangle {
                x: 30
                width: 300
                height: 80
                color: "transparent"
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    objectName: "timeLabel"
                    text: "Time: "
                    font.pointSize: 30; font.bold: true
                }
            }

            /*Rectangle {
                x: 30
                width: 300
                height: 80
                color: "transparent"
                TextField {
                    objectName: "timeField"
                    placeholderText: qsTr("Hour: Minute")
                }
            }*/

            Row{
                x: 30
                
                Button {
                    id:"btnSetTime"
                    objectName:"btnSetTime"
                    width:100
                    height:50
                    text: "Set Time"

                    onClicked: {
                        timePopup.open()
                    }
                }
            }

            Rectangle {
                x: 30
                width: 300
                height: 80
                color: "transparent"
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    objectName: "dateLabel"
                    text: "Date: "
                    font.pointSize: 30; font.bold: true
                }
            }

            /*Rectangle {
                x: 30
                width: 300
                height: 80
                color: "transparent"
                TextField {
                    objectName: "dateField"
                    placeholderText: qsTr("mm/dd/yyyy")
                }
            }*/

            Row{
                x: 30
                
                Button {
                    id:"btnSetDate"
                    objectName:"btnSetDate"
                    width:100
                    height:50
                    text: "Set Date"
                }
            }

            Item {
                x: 30
                width: 300
                height: 80
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    objectName: "wifiLabel"
                    text: "Wifi: "
                    font.pointSize: 30; font.bold: true
                }
            }

            Button{
                text: "scan"
                onClicked: scanWifi()
            }
        }
    }
    Row {
        x: 600
        y: 350
        Button {
                id:"btnConfirm"
                objectName:"btnConfirm"
                width:100
                height:50
                text: "Confirm"
        }
    }

    Popup {
        id: timePopup
        x: 300
        y: 120
        width: 320
        height: 180
        modal: true
        focus: true
        dim: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        Row{
            spacing: 10
            
            Column{
                width: 100
                
                Button{
                    width: 100
                    height: 45
                    text: "\u25B2"
                    onClicked: {
                        
                    }
                }

                Text{
                    id: txtSetHour
                    width: parent.width
                    text: {
                        if (hour == 0){
                            var original = hour;
                            var pad = "0"
                            var result = pad.concat(original);
                            return result;
                        }
                        else
                            return hour;
                    }
                    font.pointSize: 36
                    horizontalAlignment : Text.AlignHCenter
                }

                Button{
                    width: 100
                    height: 45
                    text: "\u25BC"
                    onClicked: {
                        
                    }
                }
            }

            Column{
                width: 100
                Button{
                    width: 100
                    height: 45
                    text: "\u25B2"
                    onClicked: {
                        
                    }
                }

                Text{
                    id: txtSetMinute
                    width: parent.width
                    text: {
                        if (min == 0){
                            var original = min;
                            var pad = "0"
                            var result = pad.concat(original);
                            return result;
                        }
                        else
                            return hour;
                    }
                    font.pointSize: 36
                    horizontalAlignment : Text.AlignHCenter
                }

                Button{
                    width: 100
                    height: 45
                    text: "\u25BC"
                    onClicked: {
                        
                    }
                }
            }
        }

        Button{
            id: btnDateOk
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            text: "ok"
            onClicked: {
                timePopup.close()
            }
        }
    }
}