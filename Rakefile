require "bundler/gem_tasks"

desc "Run tests without re-compiling extensions"
task :test do
  sh "bundle exec ruby -Ilib:test test/test_*.rb"
end
