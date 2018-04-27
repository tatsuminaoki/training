# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# For using labels on tasks
$(document).on 'turbolinks:load', ->
  $('#task-labels').tagit
    fieldName: 'label_list'
    singleField: true
  $('#task-labels').tagit()
  label_string = $("#label_hidden").val()
  try
    label_list = label_string.split(',')
    for tag in label_list
      $('#task-labels').tagit 'createTag', tag
  catch error
