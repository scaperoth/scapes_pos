# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
    $(document).on 'turbolinks:load', ->
        if $('#new_sale, .edit_sale').length > 0 
            bind_sku_field = (elem) -> 
                $(elem).on 'focusout', (event) ->
                    elem = $(this)
                    url = elem.data('search-url')
                    sku = elem.val()
                    $.ajax
                        url: url+'/'+sku
                        dataType: "json"
                        method: 'GET'
                        error: (jqXHR, textStatus, errorThrown) ->
                            console.log(textStatus)
                        success: (data, textStatus, jqXHR) ->
                            if data != null
                                new_item_price = parseFloat(data.price)
                                elem.closest('fieldset').find('.sale_sale_details_price input').val(new_item_price.toFixed(2))
                                update_form_total()

            bind_price_and_qty_fields = ->
                $('.sale_sale_details_price input, .sale_sale_details_quantity input').on 'change', (event) ->
                    update_form_total()
                $('.sale_sale_details_price input, .sale_sale_details_quantity input').on 'keyup', (event) ->
                    update_form_total()
                    $('#sale-amount-paid-field').change()
                
            update_form_total = ->
                total = 0.0
                $('.sale-detail').each ->
                    qty = $(this).find('.sale_sale_details_quantity input').val()
                    price = $(this).find('.sale_sale_details_price input').val()
                    total += (price * qty)
                total = total.toFixed(2)
                $('#sale-total').text(total)
                $('#sale-amount-paid-field').change()
                
            calculate_form_change = ->
                sub_total = parseFloat($('#sale-total').text())
                amount_paid = parseFloat($('#sale-amount-paid-field').val())
                total = amount_paid - sub_total
                if (total < 0 || isNaN(total)) 
                    total = 0
                $('#sale-change-text').text(total.toFixed(2)) 
                $('#sale-change-field').val(total.toFixed(2))

            field_focus = ->
                fieldset = $('#new_sale').find('fieldset')
                new_fields = fieldset.last().find('input')
                first_field = new_fields.first()[0]
                if new_fields.length > 0
                    first_field.focus()
                    bind_price_and_qty_fields()
                    bind_sku_field(first_field)

            add_field = (obj, event) ->
                time = new Date().getTime();
                regexp = new RegExp(obj.data('id'), 'g');
                obj.before(obj.data('fields').replace(regexp, time));
                field_focus()
                $('select').material_select();
                if event != undefined
                    event.preventDefault();

            $('#new_sale').on 'click', '.remove_fields', (event) -> 
                $(this).closest('fieldset').remove();
                field_focus()
                event.preventDefault();

            $('#new_sale').on 'click', '.add_fields', (event) -> 
                add_field $(this), event

            $('#sale-amount-paid-field').on 'change', (event) ->
                calculate_form_change()
                
            $('#sale-amount-paid-field').on 'keyup', (event) ->
                $('#sale-amount-paid-field').change()
                
            # add a new field right off the bat            
            add_field $('form .add_fields')




