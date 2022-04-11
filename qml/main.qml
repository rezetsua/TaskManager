import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.13
import theme 1.0
import components 1.0

Window {
    id: root

    width: 520
    height: 480
    visible: true
    title: "Task Manager"

    Connections {
        target: task_manager_
        function onTaskProgressChanged(index, progress) {
            listView.itemAtIndex(index).children[1].progress = progress
            updateInfo()
        }
    }

    // Фон
    Rectangle {
        anchors.fill: parent
        color: TaskTheme.primary10

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: TaskTheme.bigGap
            spacing: TaskTheme.bigGap

            // Панель управления
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: TaskTheme.elementHeight
                Layout.leftMargin: TaskTheme.bigGap
                Layout.rightMargin: TaskTheme.bigGap

                color: TaskTheme.primary40
                radius: TaskTheme.bigRadius

                // Кнопка выделения всех задач
                CustomButton {
                    anchors.left: parent.left
                    anchors.leftMargin: TaskTheme.bigGap
                    anchors.verticalCenter: parent.verticalCenter

                    withImage: true
                    buttonCheckable: true
                    imageSource: "qrc:icon/check.svg"
                    imageSourceChecked: "qrc:icon/cancel.svg"
                    tipText: buttonChecked ? "Снять выделение" : "Выбрать все"

                    onButtonCheckedChanged: setAllTask(buttonChecked)
                }

                // Информация о количестве выполненных задач
                Text {
                    id: taskInfo
                    anchors.centerIn: parent
                    text: "Завершены 0 из 10 задач"
                    font.family: "Roboto"
                    font.pixelSize: TaskTheme.contentTextSize
                    color: TaskTheme.primary95
                }

                // Кнопка запуска выделенных задач
                CustomButton {
                    anchors.right: parent.right
                    anchors.rightMargin: TaskTheme.bigGap
                    anchors.verticalCenter: parent.verticalCenter

                    withImage: true
                    imageSource: "qrc:icon/play.svg"
                    tipText: "Запустить выбранное"

                    TapHandler {
                        onTapped: runTask()
                    }
                }
            }

            // Подложка списка
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true

                color: TaskTheme.primary40
                radius: TaskTheme.bigRadius

                // Контейнер для закругленной обрезки списка
                Rectangle {
                    id: clipContainer
                    anchors.fill: parent
                    anchors.margins: TaskTheme.bigGap
                    color: TaskTheme.primary40
                    radius: TaskTheme.bigRadius

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: clipContainer.width
                            height: clipContainer.height
                            radius: TaskTheme.bigRadius
                        }
                    }

                    // Список
                    ListView {
                        id: listView
                        anchors.fill: parent
                        spacing: TaskTheme.gap
                        cacheBuffer: TaskTheme.elementHeight * model

                        model: 10
                        delegate: Rectangle {
                            width: parent.width
                            height: TaskTheme.elementHeight
                            color: TaskTheme.primary20
                            radius: TaskTheme.bigRadius

                            // Кнопка выбора задачи
                            CustomButton {
                                id: taskIndexButton
                                anchors.left: parent.left
                                anchors.leftMargin: TaskTheme.bigGap
                                anchors.verticalCenter: parent.verticalCenter

                                buttonEnable: taskProgressBar.progress == 0 || taskProgressBar.progress == 100
                                buttonCheckable: true
                                contentText: index + 1
                                tipText: "Выбрать задачу"
                            }

                            // Виджет с прогрессом задачи
                            CustomProgressBar {
                                id: taskProgressBar
                                anchors.left: taskIndexButton.right
                                anchors.right: taskResetButton.left
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: TaskTheme.bigGap
                                anchors.rightMargin: TaskTheme.bigGap
                                height: TaskTheme.elementHeight / 12
                            }

                            // Кнопка сброса задачи
                            CustomButton {
                                id: taskResetButton
                                anchors.right: parent.right
                                anchors.rightMargin: TaskTheme.bigGap
                                anchors.verticalCenter: parent.verticalCenter

                                withImage: true
                                imageSource: "qrc:icon/reset.svg"
                                tipText: "Сбросить прогресс"
                                buttonEnable: taskProgressBar.progress == 0 || taskProgressBar.progress == 100

                                TapHandler {
                                    onTapped: {
                                        taskIndexButton.buttonChecked = false
                                        taskProgressBar.progress = 0
                                        updateInfo()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function setAllTask(state) {
        for (var i = 0; i < listView.count; i++)
            if (listView.itemAtIndex(i).children[0].buttonEnable)
                listView.itemAtIndex(i).children[0].buttonChecked = state
    }

    function runTask() {
        for (var i = 0; i < listView.count; i++)
            if (listView.itemAtIndex(i).children[0].buttonChecked
                && listView.itemAtIndex(i).children[0].buttonEnable) {
                task_manager_.startTaskByIndex(i)
            }
    }

    function updateInfo() {
        var completeTask = 0
        for (var i = 0; i < listView.count; i++)
            if (listView.itemAtIndex(i).children[1].progress === 100)
                completeTask++
        taskInfo.text = "Завершены " + completeTask + " из " + listView.count + " задач"
    }
}
