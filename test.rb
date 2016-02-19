require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'night_reader'
require_relative 'night_writer'

class Test < Minitest::Test
  def test_input_file_is_readable
    assert File.readable?(ARGV[0])
  end

  def test_write_file_is_created
    assert File.exists?(ARGV[1])
  end

  def test_output_file_is_writable
    assert File.writable?(ARGV[1])
  end

  #in output file, assert that Braille files are limited to 80 characters wide (yes)
  #in output file, assert that a plaintext file can be converted to Braille, and then back to plaintext (yes)
  #in output file, assert that the code supports the conversion of capital letters to Braille, and then back to plaintext (yes)
  #in output file, assert that the code supports the conversion of numbers to Braille, and then back to plaintext (yes)

end
