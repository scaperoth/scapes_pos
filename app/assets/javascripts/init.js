
// make sure the script only runs once
var pos_js_init_flag = false

ready = function() {
    
    if (!pos_js_init_flag) {
        pos_js_init_flag = true
        
        $('.button-collapse').sideNav();
        $(".dropdown-button").dropdown({
            inDuration: 300,
            outDuration: 225,
            hover: true,
            belowOrigin: true, // Displays dropdown below the button
            alignment: 'right' // Displays dropdown with edge aligned to the
        });

        // datepicker 
        $('.datepicker').datepicker();

        // matching heights 
        $('.match-heights').each(function() {
            elem = $(this)
            elem_to_match = $('#' + elem.data('align'))
            new_height = elem_to_match.css('height')
            new_margin = elem_to_match.css('margin')
            elem.css('height', new_height)
            elem.css('margin', new_margin)
        })

        // auto typing
        $(".typed").each(function() {
            elem = $(this)
            typed_strings = $('#typed-strings')
            typed_speed = elem.data('speed')
            elem.typed({
                cursorChar: "|",
                stringsElement: typed_strings,
                typeSpeed: typed_speed,
                loop: true
            })
        })
        
        // data tables 
        $('.datatable').DataTable({
            responsive: true
        });

        // modals
        $('.modal').modal();

        // Select boxes
        $('select').material_select();
        
        // initialize labels
        $('input').each(function(){
          if($(this).val().length>0){
            console.log()
            $('label[for='+$(this).attr('id')+']').addClass('active')
          }
        })
        
    }
}
$(document).on('ready turbolinks:load', ready);
