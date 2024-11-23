module ApplicationHelper
  def number_to_brl(number)
    number_to_currency(number, unit: "R$", separator: ",", delimiter: ".")
  end
end
