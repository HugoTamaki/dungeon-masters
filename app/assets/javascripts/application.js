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
//= require_tree .
//= require jquery-ui
//= require jquery.autosave

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
        $("#tabs").tabs({

            });
    });

    $(document).on("blur", ".chapter-reference", function(){
       var ref = $(this).val();
       $(this).parent().parent().parent().prev().html("");
       $(this).parent().parent().parent().prev().html("<h3>Chapter "+ref+"</h3>");
    });



    $(document).on('click', '.accordionButton', function(){
      //REMOVE THE ON CLASS FROM ALL BUTTONS
      $('.accordionButton').removeClass('on');
      //NO MATTER WHAT WE CLOSE ALL OPEN SLIDES
      $('.accordionContent').slideUp('normal');
      //IF THE NEXT SLIDE WASN'T OPEN THEN OPEN IT
      if($(this).next().is(':hidden') == true) {
        //ADD THE ON CLASS TO THE BUTTON
        $(this).addClass('on');
        //OPEN THE SLIDE
        $(this).next().slideDown('normal');
      }
    });

    /*** REMOVE IF MOUSEOVER IS NOT REQUIRED ***/
    //ADDS THE .OVER CLASS FROM THE STYLESHEET ON MOUSEOVER

    $('.accordionButton').mouseover(function() {
      $(this).addClass('over');
      //ON MOUSEOUT REMOVE THE OVER CLASS
    }).mouseout(function() {
      $(this).removeClass('over');
    });

    /*** END REMOVE IF MOUSEOVER IS NOT REQUIRED ***/
    /********************************************************************************************************************
    CLOSES ALL S ON PAGE LOAD
    ********************************************************************************************************************/
    $('.accordionContent').hide();



    $(function() {
        $( document ).tooltip();
    });

    function fadeMessage(){
        $('#message').fadeOut('slow');//just a function to fade out the message
    }


});
