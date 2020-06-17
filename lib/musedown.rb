require "musedown/version"
require "thor"

module Musedown
  class CLI < Thor
    desc "parse [FILE_NAME]", "parse markdown file"
    def parse(file)
    	puts "Parsing file #{file}..."
    	puts "Done!"
    end

  end
end
