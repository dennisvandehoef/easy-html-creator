require 'coffee-script'

module AssetHelper
  include ActionView::Context

  def file_exists?(relative_path)
    File.exists?("#{@output_folder}/#{relative_path}")
  end

  def with_coffee(&block)
    input = capture_haml(&block)
    content_tag :script do
      raw Generator::CoffeeGenerator.new.compile(input)
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
    return "bower_components/#{path}" if file_exists? "bower_components/#{path}"
    path
  end
end
