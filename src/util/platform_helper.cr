module Hokusai::OS
  module Util::PlatformHelper
    def platform_os
    case platform.name
      when "postmarketos"
        "alpine"
      else
        platform.name
      end
    end
  end
end
