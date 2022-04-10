pragma Singleton
import QtQuick 2.0

QtObject {
    property color primary10: "#001D1C"
    property color primary40: "#006D6B"
    property color primary90: "#96F6F1"

    property int gap: 5
    property int bigGap: gap * 3
    property int radius: 15
    property int bigRadius: radius * 2
    property int elementHeight: 60
    property int contentTextSize: 18
    property int tipTextSize: 14

    property double opacityMax: 1.0
    property double opacityMin: 0.7
}
