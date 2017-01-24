
namespace :db do
  desc "rebuilds the database by dropping, creating, migrating and seeding"
  task :rebuild => :environment do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
  end
end