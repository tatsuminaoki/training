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
        var data = JSON.stringify({name: $('.change-name-input').val()})
        fetch(url, {
          method: 'PATCH',
          mode: "cors",
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
}

function changeSizeChangeNameInput() {
  $('.change-name-input').attr('size', $('.change-name-input').val().length+5);
}
