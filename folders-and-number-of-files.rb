#!/usr/bin/ruby

# Script to count folders in the directory and number of files in each folder

def print_folders_with_file_count(folder_file_count)
  folder_file_count.each do |folder_name, file_count|
    puts "Folder #{folder_name} has #{file_count} files"
  end
end

def count_files_in_each_folder(folders_list)
  folder_file_count = {}
  folders_list.map do |folder_name|
    folder_file_count[folder_name] = Dir[File.join(folder_name, '**', '*')].count { |file| File.file?(file) }
  end
  folder_file_count
end

def exclude_dotfolders(folders_list)
  folders_list.reject! { |folder_name| folder_name.include?('.') }
end

def folders
  Dir.entries(__dir__).select do |entry|
    File.directory?(File.join(__dir__, entry)) && !(entry == '.' || entry == '..')
  end
end

# Call the functions
folders_list = folders
exclude_dotfolders(folders_list)
folder_file_count = count_files_in_each_folder(folders_list)
print_folders_with_file_count(folder_file_count)
