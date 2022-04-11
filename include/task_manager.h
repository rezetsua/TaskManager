#ifndef TASKMANAGER_H
#define TASKMANAGER_H

#include <QObject>
#include <QTimer>
#include <thread>
#include <chrono>
#include <iostream>

class TaskManager : public QObject
{
    Q_OBJECT

public:
    explicit TaskManager(QObject *parent = nullptr);

public slots:
    void startTaskByIndex(int taskIndex);

signals:
    void taskProgressChanged(int taskIndex, int progress);
    void taskFinish(int taskIndex);
};

#endif // TASKMANAGER_H
