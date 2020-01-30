const checkMaintenance = () => {
  $.ajax({
    url: '/maintenance/api/state',
    type: 'get',
    success: function(data) {
      if (data.response) {
        location.href= "/maintenance";
      }
    },
    error: function(data) {
      console.log(data)
    }
  });
}
if (location.pathname !== "/maintenance") {
  setInterval(checkMaintenance, 10000);
  window.addEventListener('DOMContentLoaded', function() {
    document.body.onclick = () => {
      checkMaintenance
    }
  });
}
