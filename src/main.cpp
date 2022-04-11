#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "task_manager.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    TaskManager task_manager_;
    engine.rootContext()->setContextProperty("task_manager_", &task_manager_);
    engine.addImportPath("qrc:/");
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
