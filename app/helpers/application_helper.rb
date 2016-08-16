module ApplicationHelper
  
  def available_locales
    {
      en: :US,
      zh: :CN,
      es: :ES,
      ja: :JP,
      de: :DE,
      fr: :FR,
      pt: :PT,
      ru: :RU,
      it: :IT,
      ko: :KR,
      tw: :TW,
      nl: :NL,
      tr: :TR
    }
  end

  def country_flag(code, label=true, inline=true)
    country = available_locales[code.to_sym].to_s
    if label
      if inline
        return "<span><span class=\'flag #{country.downcase}\'>#{I18nData.countries[country]}</span></span>".html_safe
      else
        return "<span class=\'flag #{country.downcase}\'></span>#{I18nData.countries[country]}".html_safe
      end
    else
      return "<span class=\'flag #{country.downcase}\'>&nbsp;</span>".html_safe
    end
  end

  def money_with_cents_and_with_symbol(amount)
    humanized_money_with_symbol(amount, {no_cents: false, no_cents_if_whole: false})
  end

  def seconds_to_duration(seconds)
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end

  def plan_classes
    %w(warning success info primary danger)
  end  

end
