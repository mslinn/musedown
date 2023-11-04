module Musedown
  class CLI < Thor
    include Thor::Actions

    package_name 'Musedown'

    desc('build [FILE_NAME]', 'build markdown file')
    option(:output, type: :string, required: false, desc: 'output file', aliases: '-o')
    option(:command, type: :string, default: 'mscore', desc: 'musescore command, default: mscore', aliases: '-c')

    def build(file_name)
      output_file = file_name
      if options[:output]
        puts("✏️ Output file will be #{options[:output]}")
        output_file = options[:output]
      end

      puts("👷‍♂️ Building file #{output_file}...")
      contents = nil
      File.open(output_file) do |file|
        contents = file.read
      end
      scores = collect_prebuilt_scores(output_file, contents)
      scores << collect_unbuilt_scores(output_file, contents)
      process scores
    end

    private

    def collect_prebuilt_scores(output_file, contents)
      scores = []
      prebuilt_expression = /!\[.*\]\((?<output_file>.*-mscz-1\.png)\)/
      prebuilt_matches = contents.scan(prebuilt_expression)

      puts("🔍 Found #{prebuilt_matches.length} previously built images...")
      prebuilt_matches.each do |match|
        score = Score.new(true)
        score.relative_image_file = match[0]
        resolved_image_file = File.join(File.dirname(output_file), score.relative_image_file)
        score.score_file = resolved_image_file.gsub('-mscz-1.png', '.mscz')
        scores << score
      end
      scores
    end

    def collect_unbuilt_scores(output_file, contents)
      scores = []
      expression = /!\[.*\]\((?<output_file>.*\.mscz)\)/
      matches = contents.scan(expression)
      puts("🔍 Need to build #{matches.length} score files...")
      matches.each do |match|
        score = Score.new(false)
        score.relative_score_file = match[0]
        score.score_file = File.join(File.dirname(output_file), score.relative_score_file)
        scores << score
      end
      scores
    end

    def process(scores)
      scores.each do |score|
        sucess = score.build(options[:command])
        next unless sucess

        save score, output_file, contents
      end
      puts '✅ Done!'
    end

    def save(score, output_file, contents)
      puts("💾 Saving #{output_file}.")
      contents = score.rewrite contents unless score.prebuilt
      File.write output_file, contents
    end
  end
end
