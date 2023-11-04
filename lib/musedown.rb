require 'English'
require 'thor'
require_relative 'musedown/version'

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
      rescue Errno::ENOENT => e
        puts("⚠️ Error building #{@score_file}: #{e}")
      end

      if $CHILD_STATUS.success?
        @relative_image_file = @relative_score_file.sub(/.*\K\.mscz/, '-mscz-1.png') unless prebuilt
      else
        puts("⚠️ Error: Failed to convert #{@score_file}")
      end
      $CHILD_STATUS.success?
    end

    def rewrite(contents)
      contents.gsub(@relative_score_file, @relative_image_file)
    end
  end
end
