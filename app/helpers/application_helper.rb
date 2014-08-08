module ApplicationHelper
  def country_flag(code, label=true)
    if label == true
      return "<span class=\'flag #{code}\'>#{I18nData.countries[code.upcase.to_s]}</span>".html_safe
    else
      return "<span class=\'flag #{code}\'>&nbsp;</span>".html_safe
    end
  end
end
