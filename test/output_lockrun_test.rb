require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class OutputLockrunTest < Test::Unit::TestCase

  context "A lockrun on a command" do
    setup do
      
      @output = Whenever.cron \
        <<-file
          set :path, '/some/directory'
          every 2.hours do
            command "blahblah", :lockrun => true
          end
      file
    end

    should "output the command wrapped by lockrun with the default lockfile" do
      assert_match two_hours + %Q{ /usr/bin/env lockrun --lockfile=/some/directory/log/default.lockrun -- sh -c "blahblah"}, @output
    end
  end

  context "A lockrun on a rake task" do
    setup do
      @output = Whenever.cron \
        <<-file
          set :path, '/my/super/directory'
          every 2.hours do
            rake "blahblah", :lockrun => true
          end
      file
    end

    "cd #{@path} && RAILS_ENV=#{@environment} /usr/bin/env rake #{task}"

    should "output the command wrapped by lockrun with the default lockfile" do
      assert_includes %Q{#{two_hours} /usr/bin/env lockrun --lockfile=/my/super/directory/log/default.lockrun -- sh -c "cd /my/super/directory && RAILS_ENV=production /usr/bin/env rake blahblah"}, @output
    end
  end

  context "A lockrun on a runner" do
    setup do
      @output = Whenever.cron \
        <<-file
          set :path, '/my/directory'
          every 2.hours do
            runner "blahblah", :lockrun => true
          end
      file
    end

    should "output the command wrapped by lockrun with the default lockfile" do
      assert_includes %Q{#{two_hours} /usr/bin/env lockrun --lockfile=/my/directory/log/default.lockrun -- sh -c "/my/directory/script/runner -e production \"blahblah\""}, @output
    end
  end

  context "A lockrun with a custom lockfile" do
    setup do
      @output = Whenever.cron \
        <<-file
          set :path, '/some/directory'
          every 2.hours do
            command "blahblah", :lockrun => "zomg"
          end
      file
    end

    should "output the command wrapped by lockrun with the zomg lockfile" do
      assert_includes %Q{#{two_hours} /usr/bin/env lockrun --lockfile=/some/directory/log/zomg.lockrun -- sh -c "blahblah"}, @output
    end
  end

end
