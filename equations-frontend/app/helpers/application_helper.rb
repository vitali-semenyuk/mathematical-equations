module ApplicationHelper
  def full_title(page_title)
    base_title = 'Equations solver'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def active_link(path)
    current_page?(path) ? 'active' : ''
  end
end
