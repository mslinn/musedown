require 'musedown/version'
require 'thor'

module Musedown
  class Score
    attr_accessor :relative_image_file, :relative_score_file, :score_file
    attr_reader :prebuilt

    def initialize(prebuilt)
      @score_file = nil
      @relative_score_file = nil
      @relative_image_file = nil
      @prebuilt = prebuilt
    end

    def build(command)
      begin
        image_file = "#{@score_file.gsub('.mscz', '-mscz')}.png"
        `#{command} #{@score_file} -o #{image_file}`
      rescue Errno::ENOENT => error
        puts("⚠️ Error building #{@score_file}: #{error}")
      end

      if $?.success?
        @relative_image_file = @relative_score_file.sub(/.*\K\.mscz/, '-mscz-1.png') unless prebuilt
      else
        puts("⚠️ Error: Failed to convert #{@score_file}")
      end
      $?.success?
    end
  end

  class CLI < Thor
    desc('build [FILE_NAME]', 'build markdown file')
    option(:output, type: :string, required: false, desc: 'output file', aliases: '-o')
    option(:command, type: :string, default: 'mscore', desc: 'musescore command, default: mscore', aliases: '-c')

    def build(file_name)
      output_file = file_name
      if options[:output]
        puts("✏️ Output file will be #{options[:output]}")
        output_file = options[:output]
      end

      puts("👷‍♂️ Building file #{file_name}...")
      contents = nil
      File.open(file_name) do |file|
        contents = file.read
      end
      scores = []

      prebuilt_expression = /!\[.*\]\((?<file_name>.*\-mscz-1\.png)\)/
      prebuilt_matches = contents.scan(prebuilt_expression)

      puts("🔍 Found #{prebuilt_matches.length} previously built images...")
      prebuilt_matches.each do |match|
        score = Score.new(true)
        score.relative_image_file = match[0]
        resolved_image_file = File.join(File.dirname(file_name), score.relative_image_file)
        score.score_file = resolved_image_file.gsub('-mscz-1.png', '.mscz')
        scores << score
      end

      expression = /!\[.*\]\((?<file_name>.*\.mscz)\)/
      matches = contents.scan(expression)

      puts('🔍 Found unbuilt #{matches.length} score files...')
      matches.each do |match|
        score = Score.new(false)
        score.relative_score_file = match[0]
        score.score_file = File.join(File.dirname(file_name), score.relative_score_file)
        scores << score
      end

      scores.each do |score|
        sucess = score.build(options[:command])
        next unless sucess

        contents = contents.gsub(score.relative_score_file, score.relative_image_file) unless score.prebuilt
      end

      puts('💾 Saving...')
      File.write output_file, contents
      puts '✅ Done!'
    end
  end
end
