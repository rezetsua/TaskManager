import QtQuick 2.0
import QtGraphicalEffects 1.13
import theme 1.0

Rectangle {
    id: root

    property int progress: 0

    color: TaskTheme.primary40
    radius: height / 2

    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Rectangle {
            width: root.width
            height: root.height
            radius: TaskTheme.bigRadius
        }
    }

    Rectangle {
        height: parent.height
        width: parent.width * progress / 100
        color: TaskTheme.primary90
    }
}
