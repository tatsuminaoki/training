#!/bin/bash
curl -i -X POST localhost:3000/tasks -H 'Content-Type: application/json' -d '{"name": "task2", "description": "this is a task2", "user_id": 1, "priority": 1, "status": 1}'
curl -i -X PUT localhost:3000/tasks/2 -H 'Content-Type: application/json' -d '{"name": "task3", "description": "this is a task3", "user_id": 1, "priority": 1, "status": 1}'
curl -i -X DELETE localhost:3000/tasks/5
