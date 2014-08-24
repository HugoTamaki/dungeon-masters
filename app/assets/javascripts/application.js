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
//= require jquery
//= require jquery_ujs
//= require wysihtml5-0.3.0
//= require bootstrap.min
//= require bootstrap3-wysihtml5
//= require_tree .
//= require jquery-ui
//= require remove-image

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  if (association == "decisions" ||
    association == "monsters" ||
    association == "modifiers_items" ||
    association == "modifiers_attributes") {
    $(link).before(content.replace(regexp, new_id));
  } else {
    $(link).parent().before(content.replace(regexp, new_id));
  }
}

function remove_fields(link, form) {
  $(link).prev("input[type=hidden]").val("1");
  //$(link).closest("."+form+"-fields").remove();
  $(link).closest("."+form+"-fields").hide();
}

$(document).ready(function(){

  $(function() {
    $("#tabs").tabs();
  });

  $('.chapter-fields').accordion({
    active: false,
    collapsible: true,
    header: '.accordionButton',
    heightStyle: "content",
    autoHeight: false,
    clearStyle: true,
  });

  $('.chapter-content-wysiwyg').wysihtml5({
    lists: true,
    html: false, //Button which allows you to edit the generated HTML.
    link: false, //Button to insert a link.
    image: false, //Button to insert an image.
    color: false //Button to change color of font
  });

  $(function() {
    $(document).tooltip({
      tooltipClass: "tooltip-style"
    });
  });

  function fadeMessage(){
    $('#message').fadeOut('slow');//just a function to fade out the message
  }

  $(document).on('click', '.usable-checkbox', function() {
    if ($(this).prop('checked')) {
      $(this).next().addClass('visible');
      console.log($(this).next().html());
    } else {
      $(this).next().removeClass('visible');
      console.log($(this).next().html());
    }
  });

});
