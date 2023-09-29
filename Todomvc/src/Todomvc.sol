// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ToDoMVC {
    struct Task {
        string description;
        bool completed;
        uint256 id;
    }

    mapping(uint256 => Task) public activeTasks;
    mapping(uint256 => Task) public completedTasks;

    uint256 public activeTaskCount;
    uint256 public activeTasksLength;
    uint256 public completedTaskCount;

    event TaskAdded(uint256 taskId, string description);
    event TaskEdited(uint256 taskId, string newDescription);
    event TaskCompleted(uint256 taskId);
    event CompletedTasksCleared();

    function addTask(string memory description) public {
        uint256 taskId = activeTasksLength;
        Task memory newTask = Task(description, false, taskId);
        activeTasks[taskId] = newTask;
        activeTaskCount++;
        activeTasksLength++;
        emit TaskAdded(taskId, description);
    }

    function editTask(uint256 taskId, string memory newDescription) public {
        require(
            activeTasks[taskId].completed == false,
            "Cannot edit completed task"
        );
        activeTasks[taskId].description = newDescription;
        emit TaskEdited(taskId, newDescription);
    }

    function completeTask(uint256 taskId) public {
        Task storage task = activeTasks[taskId];
        require(task.completed == false, "Task is already completed");

        task.completed = true;
        completedTasks[completedTaskCount] = task;
        delete activeTasks[taskId];
        activeTaskCount--;
        completedTaskCount++;

        emit TaskCompleted(taskId);
    }

    function clearCompletedTasks() public {
        for (uint256 i = 0; i < completedTaskCount; i++) {
            delete completedTasks[i];
        }
        completedTaskCount = 0;
        emit CompletedTasksCleared();
    }

    function getActiveTaskList() public view returns (Task[] memory) {
        Task[] memory tasks = new Task[](activeTaskCount);
        uint256 index = 0;
        for (uint256 i = 0; i < activeTasksLength; i++) {
            if (bytes(activeTasks[i].description).length != 0) {
                tasks[index] = activeTasks[i];
                index++;
            }
        }
        return tasks;
    }

    function getCompletedTaskList() public view returns (Task[] memory) {
        Task[] memory tasks = new Task[](completedTaskCount);
        for (uint256 i = 0; i < completedTaskCount; i++) {
            tasks[i] = completedTasks[i];
        }
        return tasks;
    }
}
