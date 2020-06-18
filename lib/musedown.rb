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

    	matches.each do |match|
    		png_name = match[0]
    		png_name = File.join(File.dirname(file_name), png_name)
    		score_file = png_name.gsub("-mscz-1.png", ".mscz")
    		png_file = "#{score_file.gsub(".mscz", "-mscz")}.png"
    		begin
				command = `#{options[:command]} #{score_file} -o #{png_file}`
			rescue Errno::ENOENT => error
				puts("Error regenerating #{score_file}: #{error}")
			end
			
			if $?.success?
				puts("Regenerated #{score_file}")
			else
				puts("Failed to regenerate #{score_file}")
			end
		end

    	expression = /!\[.*\]\((?<file_name>.*\.mscz)\)/
    	matches = contents.scan(expression)
    	file_names = {}

    	matches.each do |match|
    		score_file = match[0]
            original_path = score_file
    		score_file = File.join(File.dirname(file_name), score_file)
    		png_file = "#{score_file.gsub(".mscz", "-mscz")}.png"
    		begin
				command = `#{options[:command]} #{score_file} -o #{png_file}`
			rescue Errno::ENOENT => error
				puts("Error building #{score_file}: #{error}")
			end
			
			if $?.success?
				converted = original_path.sub(/.*\K\.mscz/, '-mscz-1.png')
				file_names[original_path] = converted
			else
				puts("Failed to convert #{score_file}")
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
