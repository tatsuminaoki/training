'use strict';
window.addEventListener('DOMContentLoaded', function() {
  document.getElementById("sign-in").onclick = clickActionSignIn;
});

const clickActionSignIn = () => {
  const signIn = $(this);
  signIn.prop("disabled", true);
  $("#alert-error-email").hide();
  $("#alert-error-password").hide();
  const inputEmailEl    = $("#inputEmail");
  const inputPasswordEl = $("#inputPassword");
  inputEmailEl.prop("disabled", true);
  inputPasswordEl.prop("disabled", true);
  $.ajax({
    url: '/login',
    type: 'post',
    dataType: 'json',
    data: {
      email: $('#inputEmail').val(),
      password: $('#inputPassword').val()
    },
    success: function(data) {
      console.log(data)
      if (data.response.result) {
        location.href = 'board';
      } else {
        data.response.errors.forEach(item => {
          $("#alert-error-" + item).show();
        });
        inputPasswordEl.prop("disabled", false);
      }
      signIn.prop("disabled", false);
      inputEmailEl.prop("disabled", false);
    },
    error: function(data) {
      console.log(data)
    }
  });
}
