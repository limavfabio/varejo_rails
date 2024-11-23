module ApplicationHelper
  # Converts a number to a string formatted as a BRL currency value.
  #
  # @param [Numeric] number the number to be formatted
  # @return [String] the string representation of the number in BRL currency
  def number_to_brl(number)
    number_to_currency(number, unit: "R$", separator: ",", delimiter: ".")
  end
end
