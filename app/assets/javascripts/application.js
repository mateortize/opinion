//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require jquery.cookie
//= require bootstrap
//= require bootstrap/modal
//= require morris
//= require lightbox.min
//= require profile
//= require raphael-min
//= require cocoon
//= require fileinput.min

//= require jquery-ui/autocomplete
//= require autocomplete-rails

$(function () {
  setTimeout(function() {
    $('.alert:not(.sticky)').fadeOut();
  }, 2500);
});

$(document).ready(function() {
  $('#profiletoggle').click(function () {
    if ($(window).width() <= 690) {
      $('.navbar-collapse').collapse('hide');
    }
    $(window).scrollTop(0);
  });
  $('.tooltipp').tooltip();
});

$('.modal').on('hidden.bs.modal', function () {
    $('.modal-content').html('');
});

function check_answers(elem) {
  $(elem).parents('.answers-wrapper').find('.customcheckbox').each(function() {
    var selected = $(this);
    if(selected.find('input').prop('checked') === true) {
      selected.addClass('checked');
      selected.find('i').removeClass('icon-check-empty');
      selected.find('i').addClass('icon-check');
    }
    else {
      selected.removeClass('checked');
      selected.find('i').removeClass('icon-check');
      selected.find('i').addClass('icon-check-empty');
    }
  });
}