module SiteHelpers
  def toggle_tab tab
    if request.path =~ Regexp.new(tab)
      {class: 'current'}
    else
      {}
    end
  end

  def page_title
    title = "TennisForFans.com"
    if data.page.title
      title << " | " + current_page.data.page_title
    end
    title
  end
  
  def page_description
    if data.page.description
      description = data.page.description
    else
      description = "ATP Top 50 players' current ranking, rank history, tennis tournaments, player schedules etc"
    end
    description
  end

end
