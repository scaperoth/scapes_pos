module ApplicationHelper

    def display_flash
        content = ''
        flash.each do |key, value|
            content += content_tag :div, value, class: "flash #{key}"
        end
        content.html_safe
    end
    
    def homepage? 
      false 
      true if controller.controller_name == 'pages' && controller.action_name == 'index'
    end
    
    
    
    def logo_img_tag
      image_tag 'logo_white_35.png', style: "vertical-align:middle"
    end
end
