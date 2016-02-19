require_relative 'IO'
require_relative 'braille_key'
require 'pry'

class NightWriter
  attr_reader :file_reader
  attr_writer :file_writer

  def initialize
    @reader = FileReader.new
    @writer = FileWriter.new
  end

  def encode_file_to_braille
    plain = @reader.read
    braille = encode_to_braille(plain)
    @writer.write(braille)
  end

  def encode_to_braille(text)
    return "" if text.empty?

    text_chars = split_text_to_chars(text)
    mapped_braille = map_chars_to_braille(text_chars)
    formated_braille = format_braille_to_lines(mapped_braille)
    wrap_braille_lines_after_80_chars(formated_braille)
  end

  def split_text_to_chars(text)
    text.chomp.gsub("\n", " ").split("")
  end

  def capital_letter?(char)
    ('A'..'Z').include?(char)
  end

  def is_a_number?(char)
    char.to_i != 0 || char == "0"
  end

  def map_chars_to_braille(text_characters)
    braille_characters = []
    number_follows = true
    text_characters.each do |char|
      number_follows = true if [" ",".",","].include?(char)
      if is_a_number?(char)
        braille_characters << BrailleKey::NUMBERS_TO_BRAILLE[:number] if number_follows == true
        braille_characters << BrailleKey::NUMBERS_TO_BRAILLE[char]
        number_follows = false
      else
        braille_characters << BrailleKey::LETTERS_TO_BRAILLE[:capital] if capital_letter?(char)
        braille_characters << BrailleKey::LETTERS_TO_BRAILLE[char.downcase]
      end
    end
    braille_characters
  end

  def format_braille_to_lines(braille_characters)
    line1 = []
    line2 = []
    line3 = []
    braille_characters.each do |braille_char|
      line1 << braille_char[0]
      line2 << braille_char[1]
      line3 << braille_char[2]
    end
    formated_braille_lines = [line1.flatten.join, line2.flatten.join, line3.flatten.join]
  end

  def wrap_braille_lines_after_80_chars(formated_braille_lines)
    lines_split_80 = formated_braille_lines.map {|line| line.scan(/.{1,80}/)}

    braille_lines_output = []
    0.upto(lines_split_80[0].length-1) do |i|
      braille_lines_output << lines_split_80[0][i] + "\n" + lines_split_80[1][i] + "\n" + lines_split_80[2][i] + "\n"
    end
    braille_lines_output.join
  end
end

night_writer = NightWriter.new
night_writer.encode_file_to_braille
