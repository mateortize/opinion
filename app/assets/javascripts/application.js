//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require bootstrap
//= require bootstrap/modal
//= require morris
//= require lightbox.min
//= require profile
//= require raphael-min
//= require cocoon

//= require jquery-ui/autocomplete
//= require autocomplete-rails

$(function(){
    setTimeout(function(){
        $('.alert').fadeOut();
    }, 2500);

});

$(document).ready(function(){



    $('#profiletoggle').click(function(){

        if($(window).width() <= 690 ){
            $('.navbar-collapse').collapse('hide');

        }
        $(window).scrollTop(0);
    });

});

