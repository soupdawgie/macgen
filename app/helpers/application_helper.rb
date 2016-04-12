module ApplicationHelper

  def glyph(name, text="")
    "<i class='glyphicon glyphicon-#{name}'></i>#{" " + text}".html_safe
  end
  
end
