require 'pry'
require 'fileutils'
$VERBOSE = nil

class FileSearcher
  attr_reader :search_directory, :document_types, :filetypes_directory

  def initialize(directory)
    @search_directory = directory
    @document_types = ['TXT', 'DOC', 'DOCX', 'PAGES']
    @filetypes_directory = "#{search_directory}/Filetypes"
    @directories_searched = 0
    FileUtils.mkdir(filetypes_directory) unless Dir.exists?(filetypes_directory)
    FileUtils.mkdir("#{filetypes_directory}/Miscellaneous") unless Dir.exists?("#{filetypes_directory}/Miscellaneous")
    Dir.chdir(search_directory)
    @directory_count = Dir.glob('**/').count - 1
  end

  def search_folders
    FileUtils.cd(Dir.pwd) do |dir|
      next if dir == ('.') || dir == ('..') || dir == ('Filetypes')
      if Dir.exists?(dir)
        check_files(File.absolute_path(dir))
        @directories_searched += 1
        print "\r"
        print "Directories Searched: #{@directories_searched} / #{@directory_count}"
      end
    end
  end

  def check_files(dir)
    Dir.foreach(dir) do |file|
      FileUtils.cd(dir) do
        next if file == ('.') || file == ('..') || file == ('Filetypes')
        if Dir.exists?(file)
          Dir.chdir(file)
          search_folders
        else
          add_to_bucket(File.extname(file), File.absolute_path(file))
          FileUtils.cd('..')
        end
      end
    end
  end

  def add_to_bucket(filetype, file)
    begin
      filename = File.basename(file, filetype)
      filetype.empty? ? bucket = "Miscellaneous/#{filename}" : bucket = filetype[1..-1].upcase
      bucket_directory = "#{filetypes_directory}/#{bucket}"
      FileUtils.mkdir(bucket_directory) unless Dir.exists?(bucket_directory)
      if File.exists?(file)
        if document_types.include?(bucket)
          first_line = File.open(file, &:gets).chomp || filename
          doc_path = "#{bucket_directory}/#{first_line.chomp + filetype}"
          FileUtils.cp(file, new_path)
        else
          new_path = "#{bucket_directory}/#{filename + filetype}"
          FileUtils.cp(file, new_path)
        end
      end
    rescue
      FileUtils.cp(file, "#{bucket_directory}/#{filename + filetype}") if File.exists?(file)
    end
  end
end

puts "Input search directory:"
directory = gets.chomp

if Dir.exists?(directory)
  puts "Valid Directory. Searching.."
  FileSearcher.new(directory).search_folders
  puts ''
  puts "Done sorting."
else
  puts 'Invalid Directory. Try again.'
end
