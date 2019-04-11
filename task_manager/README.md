# Table Schema

## Task

|Column|Type|
|:---|:---|
|id|integer|
|name|string|
|due_date|datetime|
|priority|integer|
|staus_id|integer|
|description|text|
|created_by|integer|
|created_at|datetime|
|updated_at|datetime|

## Task_label

|Column|Type|
|:---|:---|
|task_id|integer|
|label_id|integer|
|created_at|datetime|
|updated_at|datetime|

## Label

|Column|Type|
|:---|:---|
|id|integer|
|name|string|
|created_at|datetime|
|updated_at|datetime|

## Status

|Column|Type|
|:---|:---|
|id|integer|
|name|string|
|created_at|datetime|
|updated_at|datetime|

## User

|Column|Type|
|:---|:---|
|id|integer|
|name|string|
|email|string|
|password|string|
|created_at|datetime|
|updated_at|datetime|
