// this funtion is hiding flash message after 2 secondes
$(function(){
  setTimeout("$('.flash-notification').fadeOut('slow')", 2000)
})

// this funtion is update project name when name press to name-input
window.onload = function () {
  if ($(".change-name-input")[0]){
    changeSizeChangeNameInput();

    $('.change-name-input').on('keypress', function(e){
      var project_id = Number($('.change-name-input').attr('id'))
      var enter_key = 13
      if( e.which == enter_key) {
        var url = `/projects/${project_id}`
        var data = JSON.stringify({ name: $('.change-name-input').val(), authenticity_token: $("#authenticity_token").val() })
        fetch(url, {
          method: 'PATCH',
          headers: { "Content-Type": "application/json; charset=UTF-8" },
          body: data
        })
        .then(function(response){
          if (response.ok) {
            $('title').html(`${$('.change-name-input').val()}|TMS`);
            changeSizeChangeNameInput();
          } else {
            throw Error(`http ${response.status} error`)
          }
        })
        .catch(function(err) {
          changeSizeChangeNameInput();
        })
      }
      else {
        changeSizeChangeNameInput();
      }
    });
  }

  if ($(".trigger-btn-update-task")[0]){
    task_value = $(".trigger-btn-update-task-input").val()
    modal_btn_id = `#btn-update-task-${task_value}`;
    $(modal_btn_id).trigger('click');
  }
}

function changeSizeChangeNameInput() {
  $('.change-name-input').attr('size', $('.change-name-input').val().length+5);
}
