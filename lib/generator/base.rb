require 'digest/md5'

module Generator
  class Base
    @@FILE_CHECKSUMS={}

    def generate(input_folder, output_folder)

    end

    def compile_file(input_file, *args)
      return unless changed? (input_file)

      #if args[0] is a file, it is the output file
      if args.length
        write(args[0], compile(File.read(input_file), *args))
      else
        compile(input_file, *args)
      end

      @@FILE_CHECKSUMS[input_file] = checksum(input_file)
    end

    def compile(input)
      input
    end

    def write(file, content)
      File.open(file, "w") do |f|
        f.write content
      end
    end

    def checksum(file)
      Digest::MD5.hexdigest(File.read(file))
    end

    def changed?(file)
      return true unless @@FILE_CHECKSUMS.has_key? file
      @@FILE_CHECKSUMS[file] != checksum(file)
    end
  end
end
