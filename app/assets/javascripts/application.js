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
//= require twitter/bootstrap
//= require_tree .
//= require jquery-ui
//= require jquery.autosave

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    $(link).parent().before(content.replace(regexp, new_id));
}

function remove_fields(link, form) {
    $(link).prev("input[type=hidden]").val("1");
    //$(link).closest(".fields").remove();
    $(link).closest("."+form+"-fields").hide();
}

$(document).ready(function(){

    $(function() {
        $( "#tabs" ).tabs();
    });

    $(function() {
        if ($("#edit_story_"+document.getElementById('story_id').value).length > 0) {
            setTimeout(autoSavePost, 1000);
        }
    });

    function fadeMessage(){
        $('#message').fadeOut('slow');//just a function to fade out the message
    }

    function autoSavePost() {
        var story_id = document.getElementById('story_id').value
        $.ajax({
            type: "POST",
            url: "/stories/auto_save?story_id=" + story_id,
            data: $("#edit_story_"+story_id).serialize(),
            dataType: "script",
            success: function(data) {
                $('#message').html("Data saved.").show();
                setTimeout("$('#message').fadeOut('slow');",2000);
                console.log(data);
            },
            error: function(data,status,error) {
                console.log(error);
                console.log(status);
                console.log(data);
                $('#message').html(error).show();
                fadeMessage();
            }
        });
        setTimeout(autoSavePost, 5000);
    }

});
