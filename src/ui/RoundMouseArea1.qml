import QtQuick 2.3
import QtQuick.Controls 1.2

Item {
    id: roundMouseArea1

    property alias mouseX: mouseArea1.mouseX
    property alias mouseY: mouseArea1.mouseY

    property bool containsMouse1: {
        var x1 = width / 2;
        var y1 = height / 2;
        var x2 = mouseX;
        var y2 = mouseY;
        var distanceFromCenter = Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2);
        var radiusSquared = Math.pow(Math.min(width, height) / 2, 2);
        var isWithinOurRadius = distanceFromCenter < radiusSquared;
        return isWithinOurRadius;
    }

    readonly property bool pressed: containsMouse1 && mouseArea1.pressed

    signal clicked

    MouseArea {
        id: mouseArea1
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: if (roundMouseArea1.containsMouse1) roundMouseArea1.clicked()
    }
}