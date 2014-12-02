$('#modal').on('shown.bs.modal', function() {
    $(this).removeData('bs.modal');
});

$(".fileupload").fileinput({
  showUpload: false,
  browseClass: "btn btn-success"
});

function check_translator() {
  if ($('body').children('.skiptranslate:first-child').css('display') == 'block')
    $('.navbar-fixed-top').addClass('translator');
  else
    $('.navbar-fixed-top').removeClass('translator');
}

window.setInterval('check_translator()', 100);