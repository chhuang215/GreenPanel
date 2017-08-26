import QtQuick 2.3
import QtQuick.Controls 1.2

Item {
    id: roundMouseArea
    width: 64
    height: 64

    property alias mouseX: mouseArea.mouseX
    property alias mouseY: mouseArea.mouseY
    property alias label: txtLabel.text
    property alias color: slot.color

    property int status : -1
    property bool disabled : false
    property bool selected : false

    // property bool containsMouse: {
    //     var x1 = width / 2;
    //     var y1 = height / 2;
    //     var x2 = mouseX;
    //     var y2 = mouseY;
    //     var distanceFromCenter = Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2);
    //     var radiusSquared = Math.pow(Math.min(width, height) / 2, 2);
    //     var isWithinOurRadius = distanceFromCenter < radiusSquared;
    //     return isWithinOurRadius;
    // }

    readonly property bool pressed: mouseArea.pressed // && containsMouse

    signal clicked

    MouseArea {
        id: mouseArea
        anchors.centerIn: parent
        width: Math.pow(Math.pow(parent.width, 2) >> 1, 0.5) + 7
        height: width
        // hoverEnabled: true
        // acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: if (/*roundMouseArea.containsMouse &&*/ !disabled) roundMouseArea.clicked()
        // Rectangle{
        //     anchors.fill: parent
        //     border.width:1
        // }
    }
  

    Rectangle {
        id: slot
        color: {
            
            if(disabled) return "grey"

            if(selected) return "blue"

            switch (status){
                case 0:
                    return "red"
                case 1:
                    return "green"
                default:
                    return "white"
            }
        }
        border.color: "black"
        border.width: 1
        radius: width / 2
        anchors.fill: parent
        Text {
            id: txtLabel
            anchors.centerIn: parent
            font.pointSize: 12
            // text:(slotNum+1) + ""
        }
    }

    
}