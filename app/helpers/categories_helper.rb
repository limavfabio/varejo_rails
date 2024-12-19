module CategoriesHelper
  def render_categories(categories)
    categories.map do |category|
      render(partial: "category", locals: {category: category})
    end.join.html_safe
  end
end
