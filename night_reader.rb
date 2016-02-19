require_relative 'IO'
require_relative 'braille_key'
require 'pry'

class NightReader
  attr_reader :file_reader
  attr_writer :file_writer

  def initialize
    @reader = FileReader.new
    @writer = FileWriter.new
  end

  def decode_file_to_text
    braille = @reader.read
    plain = decode_to_text(braille)
    @writer.write(plain)
  end

  def decode_to_text(braille)
    if braille != ""
      braille_chars = braille_lines_formatting(braille)
      text_chars = map_braille_chars_to_text_chars(braille_chars)
      text = format_and_join_text_characters(text_chars)
      text
    else
      ""
    end
  end

  def braille_lines_formatting(braille)
    lines_split_80 = braille.split("\n")
    line1_indices = (0...lines_split_80.length).to_a.select { |i| i % 3 == 0 }
    line2_indices = line1_indices.map { |i| i + 1 }
    line3_indices = line1_indices.map { |i| i + 2 }

    line1 = line1_indices.map{ |index| lines_split_80[index] }.join
    line2 = line2_indices.map{ |index| lines_split_80[index] }.join
    line3 = line3_indices.map{ |index| lines_split_80[index] }.join

    line1_chars = line1.split("")
    line2_chars = line2.split("")
    line3_chars = line3.split("")

    braille_chars = []
    loop do
      braille_chars << [line1_chars.shift(2), line2_chars.shift(2), line3_chars.shift(2)]
      break if line3_chars.empty?
    end
    braille_chars
  end

  def map_braille_chars_to_text_chars(braille_characters)
    text_characters = []
    number_follows = false
    braille_characters.each do |braille_char|
      number_follows = true if braille_char == [[".", "0"], [".", "0"], ["0", "0"]]

        if number_follows
          text_characters << BrailleKey::BRAILLE_TO_NUMBERS[braille_char]
        else
          text_characters << BrailleKey::BRAILLE_TO_LETTERS[braille_char]
        end
    end
    text_characters
  end

  def format_and_join_text_characters(text_characters)
    text_characters.delete(:number)

    if text_characters.include?(:capital)
      loop do
        i = text_characters.index(:capital)
        text_characters[i+1] = text_characters[i+1].capitalize
        text_characters.delete_at(i)
        break if !text_characters.include?(:capital)
      end
    end
    text_characters.join
  end

end

night_reader = NightReader.new
night_reader.decode_file_to_text
