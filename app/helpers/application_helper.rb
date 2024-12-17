module ApplicationHelper
  # Converts a number to a string formatted as a BRL currency value.
  #
  # @param [Numeric] number the number to be formatted
  # @return [String] the string representation of the number in BRL currency
  def number_to_brl(number)
    number_to_currency(number, unit: "R$ ", separator: ",", delimiter: ".")
  end

  # Renders a Bootstrap icon.
  #
  # @param [String] icon_name the name of the icon to be rendered
  # @return [String] the HTML code for the icon
  def bi_icon(icon_name)
    content_tag(:i, nil, class: "bi bi-#{icon_name}")
  end

  # Checks if the current controller have a gestao layout.
  #
  # @return [Boolean] true if the current controller has a gestao layout, false otherwise
  def gestao_layout?
    %w[home companies customers payment_methods products
      categories fiscal_documents document_items document_items].include?(controller_name)
  end

  def custom_date(date)
    date.strftime("%d/%m/%Y, %H:%M")
  end
end
