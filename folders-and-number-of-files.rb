#!/usr/bin/ruby

list_of_folders = 
    Dir.entries(__dir__).select { |entry| 
        File.directory? File.join(__dir__,entry) and !(entry =='.' || entry == '..') 
    }

#remove dotfiles
list_of_folders.reject! { |folder_name| folder_name.include?('.') }

folder_file_count = {}
list_of_folders.map { |folder_name| 
    folder_file_count[folder_name] = Dir[File.join(folder_name, '**', '*')].count { |file| 
        File.file?(file) 
    } 
}

folder_file_count.each { |folder_name, file_count| 
    p "Folder #{folder_name} has #{file_count} files" 
}
