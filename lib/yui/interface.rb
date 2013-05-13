module YUI
  module Interface

    if RUBY_PLATFORM == "java"
      require "yui/interface/io_interface"
      @interface_class = YUI::Interface::IoInterface
    elsif RUBY_VERSION =~ /^1\.8/
      require "yui/interface/open4_interface"
      @interface_class = YUI::Interface::Open4Interface
    else
      require "yui/interface/open3_interface"
      @interface_class = YUI::Interface::Open3Interface
    end

    def self.new
      @interface_class.new
    end

  end
end
