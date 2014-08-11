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
        return "<span class=\'flag #{country.downcase}\'>#{I18nData.countries[country]}</span>".html_safe
      else
        return "<span class=\'flag #{country.downcase}\'></span>#{I18nData.countries[country]}".html_safe
      end
    else
      return "<span class=\'flag #{country.downcase}\'>&nbsp;</span>".html_safe
    end
  end

end
