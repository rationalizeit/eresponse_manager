// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//
//= require jquery
//= require jquery_ujs
//= require_tree .



$('a.remote').live('click', function (event) {
    var $link = $(this);
    var id = $link.data('load-into');

    $('#' + id).load($link.attr('href'));

    event.preventDefault();
  });

  $('a.toggle-div').live('click', function (event) {
    var divToToggle = $(this).data('toggle-id');

    $('#' + divToToggle).toggle();

    event.preventDefault();
  });

  $('a.delete-resource-link').live('click', function(event) {
    var $link = $(this);
    var confirm_text = $link.data('confirm-text');
    var id = $link.data('clear-id');

    event.preventDefault();
    if (!confirm_text || !confirm(confirm_text))
      return;
