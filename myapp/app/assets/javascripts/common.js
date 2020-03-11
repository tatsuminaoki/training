$(document).on('turbolinks:load', function() {
  I18n.locale = $('body').data('locale')
});

$(function(){
  $(".datepicker").datetimepicker({
    format : "YYYY/MM/DD",
    icons: {
      previous: "fa fa-arrow-left",
      next: "fa fa-arrow-right"
    }
  });

  $(document).off().on("click", ".input-search-form",function(event) {
    // search-form hidden when other area click
    $("body").click(function(e) {
      if ($(".search-result").has(e.target).length == 0) {
          $(".search-result").hide();
          $(".search-result-tasks-list").empty();
          $(".search-result-projects-list").empty();
      };
    });

    $(".search-result").show("swing");
    $(".input-search-form").on("keypress", function(e){
      var query_data = $(".input-search-form").val();
      var enter_key = 13;
      if( e.which == enter_key) {
        var url = `/search?query=${query_data}`
        fetch(url, {
          method: "GET",
          mode: "cors",
          headers: { "Content-Type": "application/json; charset=UTF-8" },
        })
        .then(
          function(response) {
            if (response.status !== 200) {
              throw Error(`http ${response.status} error`)
            }

            response.json().then(function(json) {
              createATagOfTasks(json.tasks)
              createATagOfProjects(json.projects)
            });
          }
        )
        .catch(err => console.log(err));
      }
    });
  });
});

function createATagOfTasks(tasks) {
  $(".search-result-tasks-list").empty();
  if ($.isEmptyObject(tasks)) {
    $(".search-result-tasks-list").append(I18n.t('search.tasks.no_data'));
  } else {
    $.each(tasks, function( index, value ) {
      create_element_button = document.createElement("A");
      create_element_button.setAttribute("class", "btn btn-outline-success search-result-task-view");
      create_element_button.setAttribute("onclick", 'moveToShowProjectPageAndSendTaskId('+value.project.id+', '+value.id+')');
      create_element_button.innerHTML = `${value.name} in ${value.group.name} on ${value.project.name}`;
      $(".search-result-tasks-list").append(create_element_button);
    });
  }
}
function createATagOfProjects(projects) {
  $(".search-result-projects-list").empty();
  if ($.isEmptyObject(projects)) {
    $(".search-result-projects-list").append(I18n.t('search.projects.no_data'));
  } else {
    $.each(projects, function( index, value ) {
      create_element_button = document.createElement("A");
      create_element_button.setAttribute("class", "btn btn-outline-primary search-result-project-view");
      create_element_button.setAttribute("href", `/${I18n.locale}/projects/${value.id}`);
      create_element_button.innerHTML = value.name;
      $(".search-result-projects-list").append(create_element_button);
    });
  }
}

function moveToShowProjectPageAndSendTaskId(project_id, task_id) {
  var url = `/${I18n.locale}/projects/${project_id}?show_task_id=${task_id}`
  $(location).attr('href', url)
};
