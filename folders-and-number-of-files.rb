#!/usr/bin/ruby

#Script to count folders in the directory and number of files in each folder

def get_folders_list
    Dir.entries(__dir__).select { |entry| 
        File.directory? File.join(__dir__,entry) and !(entry =='.' || entry == '..') 
    }
end

def exclude_dotfiles(folders_list)
    folders_list.reject! { |folder_name| folder_name.include?('.') }
end

def count_files_in_each_folder(folders_list)
    folder_file_count = {}
    folders_list.map { |folder_name| 
        folder_file_count[folder_name] = Dir[File.join(folder_name, '**', '*')].count { |file| File.file?(file) } 
    }
    folder_file_count
end

def print_folders_with_file_count(folder_file_count)
    folder_file_count.each { |folder_name, file_count| 
        puts "Folder #{folder_name} has #{file_count} files" 
    }
end

# Call the functions
folders_list = get_folders_list
exclude_dotfiles(folders_list)
folder_file_count = count_files_in_each_folder(folders_list)
print_folders_with_file_count(folder_file_count)
