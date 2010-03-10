namespace :cmadmin do
  desc "Sync static assets and migrations from cmadmin plugin."
  task :sync do
    here = File.dirname(__FILE__)
    system "rsync -ruv #{here}/../db/migrate db"
    system "rsync -ruv #{here}/../public ."
    system "rsync -ruv #{here}/../app/stylesheets app"
  end
end