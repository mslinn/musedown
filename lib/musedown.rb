require "musedown/version"
require "thor"

module Musedown
  class CLI < Thor
    desc("build [FILE_NAME]", "build markdown file")
    option(:output, :type => :string, :required => false, :desc => "output file", :aliases => "-o")
    option(:command, :type => :string, :default => "mscore", :desc => "musescore command, default: mscore", :aliases => "-c")
    def build(file_name)

    	output_file = file_name
    	if options[:output]
    		puts("Output file will be #{options[:output]}")
    		output_file = options[:output]
    	end

    	puts("Building file #{file_name}...")
    	contents = nil
    	File.open(file_name) do |file|
    		contents = file.read
    	end

    	old_expression = /!\[.*\]\((?<file_name>.*\-mscz-1\.png)\)/
    	matches = contents.scan(old_expression)
    	file_names = {}

    	matches.each do |match|
    		png_name = match[0]
    		file_name = png_name.gsub("-mscz-1.png", ".mscz")
    		file_target = "#{file_name.gsub(".mscz", "-mscz")}.png"
    		begin
				command = `#{options[:command]} #{file_name} -o #{file_target}`
			rescue Errno::ENOENT => error
				puts("Error regenerating #{file_name}: #{error}")
			end
			
			if $?.success?
				puts("Regenerated #{file_name}")
			else
				puts("Failed to regenerate #{file_name}")
			end
		end

    	expression = /!\[.*\]\((?<file_name>.*\.mscz)\)/
    	matches = contents.scan(expression)
    	file_names = {}

    	matches.each do |match|
    		file_name = match[0]
    		file_target = "#{file_name.gsub(".mscz", "-mscz")}.png"
    		begin
				command = `#{options[:command]} #{file_name} -o #{file_target}`
			rescue Errno::ENOENT => error
				puts("Error building #{file_name}: #{error}")
			end
			
			if $?.success?
				converted = file_target.sub(/.*\K\.png/, '-1.png')
				file_names[file_name] = converted
			else
				puts("Failed to convert #{file_name}")
			end
		end

		new_contents = contents
		file_names.each do |score_file, image_file|
			new_contents = new_contents.gsub(score_file, image_file)
		end

		puts("Saving...")
    	File.open(output_file, "w") do |file|
    		 file.write(new_contents)
    	end

    	puts "Done!"
    end

  end
end
