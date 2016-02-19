class FileReader
  def read
    filename = ARGV[0]
    File.read(filename)
  end
end


class FileWriter
  def write(output)
    filename = ARGV[1]
    File.open(filename, 'w') do |file|
      file.puts output
    end
    puts "Created '#{filename}' containing #{output.length} characters."
  end
end
