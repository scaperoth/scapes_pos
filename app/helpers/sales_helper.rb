module SalesHelper
    def link_to_add_fields(_name, f, association)
        new_object = f.object.send(association).klass.new
        id = new_object.object_id
        
        new_object.build_product
        
        fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
            render(association.to_s.singularize + '_fields', f: builder)
        end

        link_to '#', class: 'waves-effect waves-light btn blue add_fields', data: { id: id, fields: fields.delete("\n") } do
            '<i class="material-icons">add</i>'.html_safe
        end
   end
end
