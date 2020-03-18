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

      $(this).prop('disabled', true);

      response.json().then(function(json) {
        inputLabelToTaskShowPage(json.tasks, json.labels)
      });
    })
    .catch(function(err) {
        alert('error');
      changeSizeChangeNameInput();
    })
  });
});

function inputLabelToTaskShowPage(task, labels) {
}
