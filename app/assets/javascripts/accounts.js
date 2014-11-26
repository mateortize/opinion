$('#modal').on('shown.bs.modal', function() {
    $(this).removeData('bs.modal');
});

$(".fileupload").fileinput({
  showUpload: false,
  browseClass: "btn btn-success"
});