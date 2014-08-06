module ApplicationHelper
  def link_to_remove_fields(name, f, form)
    f.hidden_field(:_destroy) + link_to(name, "javascript:;", onclick: "remove_fields(this, '#{form}');")
  end

  def link_to_add_fields(name, f, association, form)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("/#{form}/#{form}_fields", :f => builder)
    end
    link_to(name,"javascript:;", onclick: "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\");")
  end

  def attributes
    ["skill", "energy", "luck", "gold"]
  end

  def skills
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
  end

  def energy
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 
      14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
  end

  def quantity
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 
      14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 
      25, 26, 27, 28, 29, 30]
  end

  def modifiers
    [-5, -4, -3, -2, -1, +1, +2, +3, +4, +5]
  end

end
