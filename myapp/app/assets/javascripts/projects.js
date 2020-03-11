// this funtion is hiding flash message after 2 secondes
$(function(){
  setTimeout("$('.flash-notification').fadeOut('slow')", 2000)
})

// this funtion is update project name when name press to name-input
window.onload = function () {
  if ($(".change-name-input")[0]){
    changeSizeChangeNameInput();

    $('.change-name-input').on('keypress', function(e){
      var project_id = Number($('.change-name-input').attr('id'));
      var enter_key = 13;
      if( e.which == enter_key) {
        $.ajax({
          type: 'PATCH',
          url: `/projects/${project_id}`,
          dataType: 'json',
          contentType: 'application/json; charset=UTF-8',
          data: JSON.stringify({name: $('.change-name-input').val()})
        }).done(function(data, textStatus, jqXHR) {
          $('title').html(`${$('.change-name-input').val()}|TMS`);
          changeSizeChangeNameInput();
        }).fail(function(data, textStatus, jqXHR) {
          changeSizeChangeNameInput();
        });
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


