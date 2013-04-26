require 'net/http'

class Script
    attr_accessor :target

    def initialize(target)
        @target_uri = URI(target)
    end

    def alive?
        return fire "/alive"
    end

    def kill_app
        fire_and_forget "/die"
    end

    def leak
        fire_and_forget "/leaky"
    end

    def wait time
        fire_and_forget "/wait/#{time}"
    end

    def random_wait
        fire_and_forget "/wait"
    end

    def load_wait
        fire_and_forget "/load_wait"
    end

    def load
        fire_and_forget "/load"
    end

    def fire_email
    end

    def fire path
        http = Net::HTTP.new(@target_uri.host, @target_uri.port)
        begin
            res = http.get path
            return True
        rescue 
            return False
        end
    end

    def fire_and_forget path
        http = Net::HTTP.new(@target_uri.host, @target_uri.port)
        http.read_timeout = 0.01
        begin
            res = http.get path
        rescue Timeout::Error
        end
    end

    def work
    end

    def run
        fork { work }
    end
end

class Start<Script
    def work
        puts "start"
        sleep 5
        kill_app
    end
end


def main
    s = Start.new "http://lit-beyond-9012.herokuapp.com"
    s.run
    Process.join
end

if __FILE__ == $PROGRAM_NAME
    main
end
