desc 'This task is called by the Heroku scheduler add-on'

task delete_download_files_: :environment do
  puts 'Deleting files from server...'
  FileUtils.rm_rf(Dir.glob("#{Rails.root}/public/tmp/*"))
  puts 'done.'
end
