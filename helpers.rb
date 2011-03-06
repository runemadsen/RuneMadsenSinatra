helpers do

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Testing HTTP Auth")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['rune', 'Enurmadsen1']
  end
  
  def convert_pre_to_code content
    h = Hpricot(content)
    c = Syntax::Convertors::HTML.for_syntax "ruby"
    h.search('//pre[@class="ruby"]') do |e|
      e.inner_html = c.convert(e.inner_text, false)
    end
    h.to_s
  end

end