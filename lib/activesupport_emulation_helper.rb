module ActivesupportEmulationHelper
  def stylesheet_link_tag(path, media='screen')
    '<link href="'+path_to_css(path)+'" media="'+media+'" rel="stylesheet" type="text/css" />'
  end

  def javascript_include_tag(path)
    '<script src="'+path_to_js(path)+'"></script>'
  end

  def image_tag(source, options={})
    options[:src] = path_to_image(source)
    tag("img", options)
  end

  def text_field_tag(name, value='', options = {})
    options[:name]  = name
    options[:value] = value
    options[:type]  = 'text'
    tag('input', options)
  end

  def text_area_tag(name, value='', options = {})
    options[:name]  = name
    content_tag(:textarea, value, options)
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

  def tag(name, options = nil, open = false, escape = true)
    "<#{name}#{tag_options(options, escape) if options}#{open ? ">" : " />"}"#.html_safe
  end

  def link_to(name = nil, url=nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options ||= {}
    html_options ||={}

    html_options['href'] ||= url

    content_tag(:a, name || url, html_options, &block)
  end

  def content_tag(type, name, options = true, &block)
    #if block_given?
    #  options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
    #  content_tag_string(type, capture(&block), name, options)
    #else
      content_tag_string(type, name, options)
    #end
  end

  def content_tag_string(type, content, options)
    tag_options = tag_options(options) if options
    "<#{type}#{tag_options}>#{content}</#{type}>"#.html_safe
  end

  def tag_options(options)
    return if options.blank?
    attrs = []
    options.each_pair do |key, value|
      if key.to_s == 'data' && value.is_a?(Hash)
        value.each_pair do |k, v|
          attrs << data_tag_option(k, v, escape)
        end
      elsif !value.nil?
        attrs << tag_option(key, value, escape)
      end
    end
    " #{attrs.sort! * ' '}" unless attrs.empty?
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

  def tag_options(options, escape = true)
    return if !options || options.nil? || options.empty?
    attrs = []
    options.each_pair do |key, value|
      if key.to_s == 'data' && value.is_a?(Hash)
        value.each_pair do |k, v|
          attrs << data_tag_option(k, v, escape)
        end
      elsif !value.nil?
        attrs << tag_option(key, value, escape)
      end
    end
    " #{attrs.sort! * ' '}" unless attrs.empty?
  end

  def data_tag_option(key, value, escape)
    key   = "data-#{key.to_s.dasherize}"
    unless value.is_a?(String) || value.is_a?(Symbol) || value.is_a?(BigDecimal)
      value = value.to_json
    end
    tag_option(key, value, escape)
  end

  def tag_option(key, value, escape)
    value = value.join(" ") if value.is_a?(Array)
    value = ERB::Util.h(value) if escape
    %(#{key}="#{value}")
  end
end
