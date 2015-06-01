require 'coffee-script'
require 'uglifier'

module AssetHelper
  include ActionView::Context

  def file_exists?(relative_path)
    File.exists?("#{@output_folder}/#{relative_path}")
  end

  def with_coffee(&block)
    input = capture_haml(&block)
    content_tag :script do
      raw Uglifier.compile(Generator::CoffeeGenerator.new.compile(input))
    end
  end

  def with_sass(&block)
    input = capture_haml(&block)
    content_tag :style do
      raw Generator::SassGenerator.new.compile(input)
    end
  end

  def glyph_icon_classes(icon)
    "glyphicon glyphicon-#{icon}"
  end

  def glyph_icon(icon, content='')
    content_tag(:span, content, class: glyph_icon_classes(icon))
  end

  def select_partials(dir='*', &block)
    folder = "#{@input_folder}/partials/#{dir}"
    Dir.glob("#{folder}").each do |partial|
      partial = partial.sub("#{@input_folder}/partials/", '').sub('.haml', '')
      block.call(partial) if block_given?
    end
  end

  def javascript_include_bower_tag(path)
    '<script src="'+path_to_bower(path)+'"></script>'
  end

  def path_to_bower(path)
    return "bower_components/#{path}"
    path
  end

  def headjs_javascript_include_tag(tag, path)
    content_tag :script do
      raw "head.load({'#{tag}': '#{path_to_js(path)}'});"
    end
  end

  def headjs_javascript_include_bower_tag(tag, path)
    headjs_javascript_include_tag(tag, path_to_bower(path))
  end

  def headjs_stylesheet_link_tag(tag, path)
    headjs_javascript_include_tag(tag, path_to_css(path))
  end
end
