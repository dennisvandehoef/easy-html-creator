require 'digest/md5'

module Generator
  class Base
    @@FILE_CHECKSUMS={}

    def generate(input_folder, output_folder)

    end

    def compile_file(input_file, *args)
      return unless self.class.changed? (input_file)

      #if args[0] isset, it is a file, the output file
      if args.length > 0
        write(args[0], compile(File.read(input_file), *args))
      else
        compile(input_file, *args)
      end

      self.class.cache(input_file)
    end

    def compile(input)
      input
    end

    def write(file, content)
      File.open(file, "w") do |f|
        f.write content
      end
    end

    def self.checksum(file)
      Digest::MD5.hexdigest(File.read(file))
    end

    def self.changed?(file)
      return true unless @@FILE_CHECKSUMS.has_key? file
      @@FILE_CHECKSUMS[file] != self.checksum(file)
    end

    def self.cache(file)
      @@FILE_CHECKSUMS[file] = self.checksum(file)
    end
  end
end
