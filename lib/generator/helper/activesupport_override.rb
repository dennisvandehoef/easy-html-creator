module ActivesupportOverride
  def stylesheet_link_tag(path, media='screen')
    '<link href="'+path_to_css(path)+'" media="'+media+'" rel="stylesheet" type="text/css" />'
  end

  def javascript_include_tag(path)
    '<script src="'+path_to_js(path)+'"></script>'
  end

  def meta_tag(type, content)
    '<meta name="'+type+'" content="'+content+'" />'
  end

  def meta_tag_http(type, content)
    '<meta http-equiv="'+type+'" content="'+content+'" />'
  end

  def link_tag(source, relation, type)
    '<link rel="'+relation+'" href="'+source+'" type="'+type+'" />'
  end

  def path_to_css(path)
    return path if external_path?(path)
    "css/#{path}"
  end

  def path_to_js(path)
    return path if external_path? path
    "js/#{path}"
  end

  def path_to_image(path)
    return path if external_path? path
    "images/#{path}"
  end

  def external_path? path
    path.start_with?('//') || path.start_with?('http')
  end

  def url_for(options = {})
    return ''
  end
end
