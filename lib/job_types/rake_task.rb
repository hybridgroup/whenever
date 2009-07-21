module Whenever
  module Job
    class RakeTask < Whenever::Job::Default

      def output
        path_required
        super
      end

      protected

        def wrap_task(task)
        "cd #{@path} && RAILS_ENV=#{@environment} /usr/bin/env rake #{task}"
          
        end
      
    end
  end
end
