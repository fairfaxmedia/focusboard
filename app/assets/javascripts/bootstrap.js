$(document).ready(function() {
  $('[data-toggle="tooltip"').tooltip();
  $('[data-toggle="popover"').popover({
    trigger: 'hover'
  });
});

$('#myModal').on('shown.bs.modal', function () {
  $('#myInput').focus()
});

