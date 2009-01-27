class RailsPage < Page
  display_name "Application"
  attr_accessor :breadcrumbs

  def find_by_url(url, live=true, clean=true)
    found_page = super
    if found_page.nil? || found_page.is_a?(FileNotFoundPage)
      url = clean_url(url) if clean
      self if url.starts_with?(self.url)
    else
      found_page
    end
  end
  
  def url=(path)
    @url = path
  end
  
  def url
    @url || super
  end
  
  def build_parts_from_hash!(content)
    content.each do |k,v|
      part_for_key(k).content = v
    end
  end
  
  alias_method "tag:old_breadcrumbs", "tag:breadcrumbs"
  tag 'breadcrumbs' do |tag|
    if tag.locals.page.is_a?(RailsPage) && tag.locals.page.breadcrumbs
      tag.locals.page.breadcrumbs
    else
      render_tag('old_breadcrumbs', tag)
    end
  end
  
  private
  
  def part_for_key(key)
    unless part = part(key)
      part = parts.build(:name => key.to_s)
      part.filter_id = nil
    end
    
    part
  end
end