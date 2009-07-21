module Whenever
  module Job
    class Default
      
      attr_accessor :task, :at, :cron_log
    
      def initialize(options = {})
        @task        = options[:task]
        @at          = options[:at]
        @cron_log    = options[:cron_log]
        @environment = options[:environment] || :production
        @path        = options[:path] || Whenever.path
      end
    
      def output
        output = wrap_task(task)
      end

    protected
      
      def path_required
        raise ArgumentError, "No path available; set :path, '/your/path' in your schedule file" if @path.blank?
      end

      def wrap_task(task)
        task
      end
      
    end
  end
end
