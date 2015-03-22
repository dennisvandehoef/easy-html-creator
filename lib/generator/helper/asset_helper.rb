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
end
