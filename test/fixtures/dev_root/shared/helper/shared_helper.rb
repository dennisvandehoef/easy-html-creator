module SharedHelper
  def copyright(who)
    "© #{Time.new.year} by #{who}"
  end

  def select_partials(dir='*', &block)
    folder = "#{@input_folder}/partials/#{dir}"
    Dir.glob("#{folder}").each do |partial|
      partial = partial.sub("#{@input_folder}/partials/", '').sub('.haml', '')
      block.call(partial) if block_given?
    end
  end
end
