require 'csv'

namespace :db do
  desc 'import Projects from csv'
  task :import_projects => 'environment' do

    Project.transaction do
      csv_file_path = Rails.root.join('db', 'projects.csv')
      table = CSV.table(csv_file_path)

      table.each do |row|
        project = Project.new(title:row[:title], price_plan:row[:price_plan], url:row[:url], usage:row[:usage], published_at:row[:published_at])
        if project.save
          puts "saved #{project.title}"
        else
          puts "failed #{project.title}"
        end
      end

    end
  end
end
