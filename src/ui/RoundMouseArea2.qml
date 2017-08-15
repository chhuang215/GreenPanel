import QtQuick 2.3
import QtQuick.Controls 1.2

Item {
    id: roundMouseArea2

    property alias mouseX: mouseArea2.mouseX
    property alias mouseY: mouseArea2.mouseY

    property bool containsMouse2: {
        var x1 = width / 2;
        var y1 = height / 2;
        var x2 = mouseX;
        var y2 = mouseY;
        var distanceFromCenter = Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2);
        var radiusSquared = Math.pow(Math.min(width, height) / 2, 2);
        var isWithinOurRadius = distanceFromCenter < radiusSquared;
        return isWithinOurRadius;
    }

    readonly property bool pressed: containsMouse2 && mouseArea2.pressed

    signal clicked

    MouseArea {
        id: mouseArea2
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: if (roundMouseArea2.containsMouse2) roundMouseArea2.clicked()
    }
}