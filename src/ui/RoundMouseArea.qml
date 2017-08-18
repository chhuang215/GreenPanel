import QtQuick 2.3
import QtQuick.Controls 1.2

Item {
    id: roundMouseArea
    width: 60
    height: 60

    property alias mouseX: mouseArea.mouseX
    property alias mouseY: mouseArea.mouseY
    property alias label: txtSlotLabel.text
    property alias color: slot.color

    property int slotNum : -1
    property int status : -1
    property bool disabled : false
    property bool selected : status == 2

    property bool containsMouse: {
        var x1 = width / 2;
        var y1 = height / 2;
        var x2 = mouseX;
        var y2 = mouseY;
        var distanceFromCenter = Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2);
        var radiusSquared = Math.pow(Math.min(width, height) / 2, 2);
        var isWithinOurRadius = distanceFromCenter < radiusSquared;
        return isWithinOurRadius;
    }

    readonly property bool pressed: containsMouse && mouseArea.pressed

    signal clicked

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: if (roundMouseArea.containsMouse && !disabled) roundMouseArea.clicked()
    }

    Rectangle {
        id: slot
        color: {
            
            if(disabled) return "grey"

            if(selected) return "blue"

            if(status == -1) return "white"
            else if (status == 1) return "green"
            else if (status == 0) return "red"
        }
        border.color: "black"
        border.width: 1
        radius: width / 2
        anchors.fill: parent
        Text {
            id: txtSlotLabel
            anchors.centerIn: parent
            font.pointSize: 12
            text:(slotNum+1) + ""
        }
    }
}