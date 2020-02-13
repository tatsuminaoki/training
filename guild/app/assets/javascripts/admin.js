// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
'use strict';
let targetUserId;
let targetUser;
let userList;

const getLatest = () => {
  $.ajax({
    url: '/admin/api/user/all',
    type: 'get',
    success: response => {
        console.log(response)
        userList = response;
        createUserListElements();
    },
    error: error => {
      console.log(error)
    }
  });
}

const clickActionAddUser = () => {
  const name      = $("#name").val();
  const email     = $("#email").val();
  const password  = $("#password").val();
  const authority = $("#authority").val();
  if (!MailCheck(email)) {
    $('#email-error').text('invalid email');
    return;
  }
  $.ajax({
    url: '/admin/api/user',
    type: 'post',
    dataType: 'json',
    data: {
      name: name,
      email: email,
      password: password,
      authority: authority,
    },
    success: function(data) {
        console.log(data.response)
        $.LoadingOverlay("show");
        getLatest();
        $('#modal-window').modal('hide')
        $.LoadingOverlay("hide");
    },
    error: function(data) {
      console.log(data)
    }
  });
}

const openAddingeModalWindow = () => {
  resetModal()
  $('#modal-body-input').show();
  $('#modal-title').text("Add User");
  $('#form-password').show();
  $('#add-user').show();
  $('#modal-window').modal('show')
  return;
}

const resetModal = () => {

  // hide body elements
  $('#modal-body-message').hide();
  $('#modal-body-input').hide();
  $('#form-password').hide();

  // hide buttons
  $('#add-user').hide();
  $('#change-user').hide();
  $('#delete-user').hide();

  // reset input forms
  $('#modal-title').text("");
  $("#name").val("");
  $("#email").val("");
  $('#password').val();
  $("#authority").val("");
  return;
}

const createUserListElements = () => {
  const elUserList = $("#user-list-doby");
  elUserList.empty();
  userList.forEach((user, index, ar) => {
    var elTr = $("<tr></tr>");
    elTr.append('<th scope="row" ><a id="id-link-' + user.id + '" href="javascript:openChangeModalWindow(' + user.id + ');">' + user.id + '</a></td>');
    var elTdName = $("<td></td>");
    elTdName.text(user.name);
    elTr.append(elTdName);
    elTr.append("<td>" + user.login.email + "</td>");
    if (user.authority == 1) {
      elTr.append("<td>Member</td>");
    } else {
      elTr.append("<td>Administrator</td>");
    }
    elTr.append("<td>" + user.created_at + "</td>");
    elTr.append("<td>" + user.updated_at + "</td>");
    elUserList.append(elTr);
  });
}

const MailCheck = email => {
  const mail_regex1 = new RegExp( '(?:[-!#-\'*+/-9=?A-Z^-~]+\.?(?:\.[-!#-\'*+/-9=?A-Z^-~]+)*|"(?:[!#-\[\]-~]|\\\\[\x09 -~])*")@[-!#-\'*+/-9=?A-Z^-~]+(?:\.[-!#-\'*+/-9=?A-Z^-~]+)*' );
  const mail_regex2 = new RegExp( '^[^\@]+\@[^\@]+$' );
  if( email.match( mail_regex1 ) && email.match( mail_regex2 ) ) {
    if( email.match( /[^a-zA-Z0-9\!\"\#\$\%\&\'\(\)\=\~\|\-\^\\\@\[\;\:\]\,\.\/\\\<\>\?\_\`\{\+\*\} ]/ ) ) {
      return false;
    }
    if( !email.match( /\.[a-z]+$/ ) ) {
      return false;
    }
    return true;
  } else {
    return false;
  }
}

window.addEventListener('DOMContentLoaded', function() {
  document.getElementById("add-user").onclick = clickActionAddUser;
});
