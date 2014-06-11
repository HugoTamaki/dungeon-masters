module ApplicationHelper
  def link_to_remove_fields(name, f, form)
    f.hidden_field(:_destroy) + link_to(name, "javascript: void();", onclick: "remove_fields(this, '#{form}')")
  end

  def link_to_add_fields(name, f, association, form)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("/#{form}/#{form}_fields", :f => builder)
    end
    link_to(name,"javascript: void();", onclick: "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

  def attributes
    ["skill", "energy", "luck", "gold"]
  end

end
