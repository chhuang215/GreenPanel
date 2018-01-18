import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    id:"panelSetting"
    visible: false

    signal scanWifi()
    signal timeChange(int a, int b)
    property int hour: 0
    property int min: 0

    function getCurrentTime() {
        var date = new Date;
        hour = date.getHours()
        min = date.getMinutes()
    }

    function incHour() {
        if(hour == 24)
            hour = 0;
        else
            hour++;
    }

    function decHour() {
        if(hour == 0)
            hour = 24;
        else
            hour--;
    }

    function incMin() {
        if(min == 59)
            min = 0;
        else
            min++;
    }

    function decMin() {
        if(min == 0)
            min = 59;
        else
            min--;
    }

    
    Grid {
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.left: parent.left
        anchors.leftMargin:20
        anchors.right: parent.right
        
        id: grid
    
        verticalItemAlignment:Grid.AlignVCenter

        // width:parent.width
        rows: 4; columns: 2; spacing: 15

        Item {
            x: 30
            width: 300
            height: 80
            Text {
                anchors.verticalCenter: parent.verticalCenter
                objectName: "languageLabel"
                text: "Language: "
                font.pointSize: 30; font.bold: true
            }
        }
        
        Item{
            x:30
            width: 300
            height: 80
            ButtonGroup {
                buttons: rowBtns.children
            }

            Row {
                id: rowBtns
                anchors.verticalCenter:parent.verticalCenter

                Button {
                    checked: true
                    text: qsTr("English")
                }

                Button {
                    text: qsTr("French")
                }

                Button {
                    text: qsTr("Chinese")
                }
            }

        }
        
        // Item {
        //     width:300
        //     height: 80

        //     Item {
        //         id:comboBox
        //         property variant items: ["English", "French", "Chinese"]
        //         property alias selectedItem: chosenItemText.text;
        //         property alias selectedIndex: listView.currentIndex;
        //         signal comboClicked;
        //         width: 150;
        //         height: 50;
        //         z: 100;
        //         smooth:true;

        //         Rectangle {
        //             id:chosenItem
        //             radius:4;
        //             width:parent.width;
        //             height:comboBox.height;
        //             color: "white"
        //             smooth:true;
        //             Text {
        //                 anchors.top: parent.top;
        //                 anchors.left: parent.left;
        //                 anchors.margins: 8;
        //                 id:chosenItemText
        //                 objectName: "chosenItemText"
        //                 text:comboBox.items[0];
        //                 font.family: "Arial"
        //                 font.pointSize: 14;
        //                 smooth:true
        //             }

        //             MouseArea {
        //                 anchors.fill: parent;
        //                 onClicked: {
        //                     comboBox.state = comboBox.state==="dropDown"?"":"dropDown"
        //                 }
        //             }
        //         }

        //         Rectangle {
        //             id:dropDown
        //             width:comboBox.width;
        //             height:0;
        //             clip:true;
        //             radius:4;
        //             anchors.top: chosenItem.bottom;
        //             anchors.margins: 2;
        //             color: "white"

        //             ListView {
        //                 id:listView
        //                 height:100;
        //                 model: comboBox.items
        //                 currentIndex: 0
        //                 delegate: Item{
        //                     width:comboBox.width;
        //                     height: comboBox.height;

        //                     Text {
        //                         text: modelData
        //                         anchors.top: parent.top;
        //                         anchors.left: parent.left;
        //                         anchors.margins: 5;

        //                     }
        //                     MouseArea {
        //                         anchors.fill: parent;
        //                         onClicked: {
        //                             comboBox.state = ""
        //                             var prevSelection = chosenItemText.text
        //                             chosenItemText.text = modelData
        //                             if(chosenItemText.text != prevSelection){
        //                                 comboBox.comboClicked();
        //                             }
        //                             listView.currentIndex = index;
        //                         }
        //                     }
        //                 }
        //             }
        //         }

        //         Component {
        //             id: highlight
        //             Rectangle {
        //                 width:comboBox.width;
        //                 height:comboBox.height;
        //                 color: "red";
        //                 radius: 4
        //             }
        //         }

        //         states: State {
        //             name: "dropDown";
        //             PropertyChanges { target: dropDown; height:40*comboBox.items.length }
        //         }

        //         transitions: Transition {
        //             NumberAnimation { target: dropDown; properties: "height"; easing.type: Easing.OutExpo; duration: 1000 }
        //         }
        //     }
        // }
        
        Item {
            x: 30
            width: 300
            height: 80
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
                    getCurrentTime()
                }
            }
        }

        Item {
            x: 30
            width: 300
            height: 80
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
    } // END Grid
        
    // Row {
    //     x: 600
    //     y: 350
    //     Button {
    //             id:"btnConfirm"
    //             objectName:"btnConfirm"
    //             width:100
    //             height:50
    //             text: "Confirm"
    //     }
    // }

    // TIME SETTING ADJUST POPUP
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
                        incHour();
                    }
                }

                Text{
                    id: txtSetHour
                    width: parent.width
                    text: {
                        if (hour <= 9){
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
                        decHour();
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
                        incMin();
                    }
                }

                Text{
                    id: txtSetMinute
                    width: parent.width
                    text: {
                        if (min <= 9){
                            var original = min;
                            var pad = "0"
                            var result = pad.concat(original);
                            return result;
                        }
                        else
                            return min;
                    }
                    font.pointSize: 36
                    horizontalAlignment : Text.AlignHCenter
                }

                Button{
                    width: 100
                    height: 45
                    text: "\u25BC"
                    onClicked: {
                        decMin();
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
                timeChange(hour, min)
                timePopup.close()
            }
        }
    }
}