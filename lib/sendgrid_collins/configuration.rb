module SendgridCollins
  class Configuration
    attr_accessor :host, :username, :password
    def initialize(args={}, &block)
      if block_given?
        yield(self)
      else
        build_arguments(args)
      end
    end

    private
    def build_arguments(args)
      args.each do |k,v|
        self.class.send(:define_method, k, proc{ v })
      end
    end
  end
end
