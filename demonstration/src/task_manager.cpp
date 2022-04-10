#include "task_manager.h"

TaskManager::TaskManager(QObject *parent) : QObject(parent)
{

}

void TaskManager::startTaskByIndex(int taskIndex)
{
    std::thread taskThread([&]()
    {
        int index = taskIndex;
        cout << index << endl;
        for (int i = 1; i <= 100; i++) {
            std::this_thread::sleep_for(std::chrono::milliseconds(100));
            emit taskProgressChanged(index, i);
        }
        emit taskFinish(index);
    });
    taskThread.detach();
}
