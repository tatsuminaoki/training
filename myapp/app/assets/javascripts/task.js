$(function () {
  $('.task-modal-label-list-color').click(function() {
    var label_id = Number($(this).attr('id'));
    var task_id = Number($(this).attr('name'));
    var url = `/task_labels`
    var data = JSON.stringify({ task_id: task_id, label_id: label_id, authenticity_token: $("#authenticity_token").val() })
    fetch(url, {
      method: 'POST',
      headers: { "Content-Type": "application/json; charset=UTF-8" },
      body: data
    })
    .then(function(response){
      if (response.status !== 200) {
        throw Error(`http ${response.status} error`)
      }


      response.json().then(function(json) {
        var btn_task_modal_label_list_color =`.add-${json.task.id}-${json.label.id}`
        $(btn_task_modal_label_list_color).prop('disabled', true);
        inputLabelToTaskModalPage(json.task, json.label)
        inputLabelToProjectShowTask(json.task, json.label)
      });
    })
    .catch(function(err) {
      alert('error');
    })
  });
});

$(function () {
  $(document).on("click", ".task-modal-label-list-color-delete", function () {
    var label_id = Number($(this).attr('id'));
    var task_id = Number($(this).attr('name'));
    var url = `/task_labels`
    var data = JSON.stringify({ task_id: task_id, label_id: label_id, authenticity_token: $("#authenticity_token").val() })
    $(this).prop('disabled', true);
    fetch(url, {
      method: 'DELETE',
      headers: { "Content-Type": "application/json; charset=UTF-8" },
      body: data
    })
    .then(function(response){
      if (response.status !== 200) {
        throw Error(`http ${response.status} error`)
      }

      response.json().then(function(json) {
        var btn_task_modal_label_list_color =`.add-${json.task.id}-${json.label.id}`
        var btn_task_modal_label_list_color_delete =`.delete-${json.task.id}-${json.label.id}`
        var btn_task_containers_label_of_task =`.show-${json.task.id}-${json.label.id}`

        $(btn_task_modal_label_list_color).prop('disabled', false);
        $(btn_task_modal_label_list_color_delete).remove()
        $(btn_task_containers_label_of_task).remove()
      });
    })
    .catch(function(err) {
      alert('error');
    })
  });
});

function inputLabelToTaskModalPage(task, label) {
  create_element_button = document.createElement("BUTTON");
  create_element_button.setAttribute("type", "button");
  create_element_button.setAttribute("class", "btn task-modal-label-list-color-delete "+`delete-${task.id}-${label.id}`);
  create_element_button.setAttribute("name", task.id);
  create_element_button.setAttribute("id", label.id);
  create_element_button.setAttribute("style", 'background-color: '+label.color+'; border-color: '+label.color);

  var task_modal_show_parent_class = `.delete-label-of-task-${task.id}`
  $('.task-modal-joined-label-color'+ task_modal_show_parent_class).append(create_element_button);
}

function inputLabelToProjectShowTask(task, label) {
  create_element_button = document.createElement("div");
  create_element_button.setAttribute("class", "btn task-containers-label-of-task "+`show-${task.id}-${label.id}`);
  create_element_button.setAttribute("style", 'margin-left: 3px; background-color: '+label.color+'; border-color: '+label.color);

  var project_show_parent_class = `.task-containers-label-of-task-${task.id}`
  $('.task-containers-label'+ project_show_parent_class).append(create_element_button);
}
