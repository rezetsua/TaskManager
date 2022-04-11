#include "task_manager.h"

TaskManager::TaskManager(QObject *parent) : QObject(parent)
{

}

void TaskManager::startTaskByIndex(int taskIndex)
{
    std::thread taskThread([&, taskIndex]()
    {
        for (int i = 1; i <= 100; i++) {
            std::this_thread::sleep_for(std::chrono::milliseconds(100));
            emit taskProgressChanged(taskIndex, i);
        }
        emit taskFinish(taskIndex);
    });
    taskThread.detach();
}
