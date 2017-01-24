// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require materialize-sprockets
//= require sweetalert
//= require typed
//= require dataTables/jquery.dataTables
//= require dataTables/extras/dataTables.responsive
//= require_tree .

//Override the default confirm dialog by rails
$.rails.allowAction = function(link) {
        if (link.data("confirm") == undefined) {
            return true;
        }
        $.rails.showConfirmationDialog(link);
        return false;
    }
    //User click confirm button
$.rails.confirmed = function(link) {
        link.data("confirm", null);
        link.trigger("click.rails");
    }
    //Display the confirmation dialog
$.rails.showConfirmationDialog = function(link) {
    var message = link.data("confirm");
    swal({
            title: "",
            text: message,
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes, I'm sure!",
            closeOnConfirm: false
        },
        function() {
            $.rails.confirmed(link);  
        });
}