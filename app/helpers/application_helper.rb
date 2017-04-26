module ApplicationHelper
  def fraction_to_percentage(fraction)
    number_to_percentage(fraction * 100, precision: 0)
  end
end
