module SiteHelpers
  def toggle_tab tab
    if request.path =~ Regexp.new(tab)
      {class: 'current'}
    else
      {}
    end
  end

  def page_title
    title = "Set your site title in /helpers/site_helpers.rb"
    if data.page.title
      title << " | " + data.page.title
    end
    title
  end
  
  def page_description
    if data.page.description
      description = data.page.description
    else
      description = "Set your site description in /helpers/site_helpers.rb"
    end
    description
  end

end
